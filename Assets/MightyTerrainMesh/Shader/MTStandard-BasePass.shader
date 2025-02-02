﻿Shader "MT/Standard-BasePass" 
{
	Properties{
		[HideInInspector]_Control("AlphaMap", 2D) = "" {}
		[HideInInspector]_Splat0("Layer 0 (R)", 2D) = "white" {}
		[HideInInspector]_Normal0("Normal 0 (R)", 2D) = "white" {}
		[HideInInspector]_NormalScale0("NormalScale 0", Float) = 1.0
		[HideInInspector]_Splat1("Layer 1 (G)", 2D) = "white" {}
		[HideInInspector]_Normal1("Normal 1 (G)", 2D) = "white" {}
		[HideInInspector]_NormalScale1("NormalScale 1", Float) = 1.0
		[HideInInspector]_Splat2("Layer 2 (B)", 2D) = "white" {}
		[HideInInspector]_Normal2("Normal 2 (B)", 2D) = "white" {}
		[HideInInspector]_NormalScale2("NormalScale 2", Float) = 1.0
		[HideInInspector]_Splat3("Layer 3 (A)", 2D) = "white" {}
		[HideInInspector]_Normal3("Normal 3 (A)", 2D) = "white" {}
		[HideInInspector]_NormalScale3("NormalScale 3", Float) = 1.0
		[HideInInspector][Gamma] _Metallic0("Metallic 0", Range(0.0, 1.0)) = 0.0
		[HideInInspector][Gamma] _Metallic1("Metallic 1", Range(0.0, 1.0)) = 0.0
		[HideInInspector][Gamma] _Metallic2("Metallic 2", Range(0.0, 1.0)) = 0.0
		[HideInInspector][Gamma] _Metallic3("Metallic 3", Range(0.0, 1.0)) = 0.0
		[HideInInspector] _Smoothness0("Smoothness 0", Range(0.0, 1.0)) = 1.0
		[HideInInspector] _Smoothness1("Smoothness 1", Range(0.0, 1.0)) = 1.0
		[HideInInspector] _Smoothness2("Smoothness 2", Range(0.0, 1.0)) = 1.0
		[HideInInspector] _Smoothness3("Smoothness 3", Range(0.0, 1.0)) = 1.0
	}
	SubShader{
		Tags{
			"Queue" = "Geometry-100"
			"RenderType" = "Opaque"
		}

		CGPROGRAM
#pragma surface surf Standard vertex:SplatmapVert finalcolor:SplatmapFinalColor finalgbuffer:SplatmapFinalGBuffer addshadow fullforwardshadows
//#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap forwardadd
#pragma multi_compile_fog // needed because finalcolor oppresses fog code generation.
#pragma target 3.0
		// needs more than 8 texcoords
#pragma exclude_renderers gles
#include "UnityPBSLighting.cginc"

//#pragma multi_compile __ _NORMALMAP

#define TERRAIN_STANDARD_SHADER
#define _NORMALMAP
#define TERRAIN_SURFACE_OUTPUT SurfaceOutputStandard
#include "TerrainSplatmapCommon.cginc"

		half _Metallic0;
		half _Metallic1;
		half _Metallic2;
		half _Metallic3;

		half _Smoothness0;
		half _Smoothness1;
		half _Smoothness2;
		half _Smoothness3;

		void surf(Input IN, inout SurfaceOutputStandard o) {
			half4 splat_control;
			half weight;
			fixed4 mixedDiffuse;
			half4 defaultSmoothness = half4(_Smoothness0, _Smoothness1, _Smoothness2, _Smoothness3);
			SplatmapMix(IN, defaultSmoothness, splat_control, weight, mixedDiffuse, o.Normal);
			o.Albedo = mixedDiffuse.rgb;
			o.Alpha = weight;
			o.Smoothness = mixedDiffuse.a;
			o.Metallic = dot(splat_control, half4(_Metallic0, _Metallic1, _Metallic2, _Metallic3));
		}
		ENDCG
	}
	Fallback "Nature/Terrain/Diffuse"
}