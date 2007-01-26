From: akpm@osdl.org
Subject: + updates-to-via-dri.patch added to -mm tree
Date: Thu, 25 Jan 2007 20:27:40 -0800
Message-ID: <200701260427.l0Q4ReT1007325@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44771 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030739AbXAZE1y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 23:27:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: claas@rootdir.de, airlied@linux.ie, davej@codemonkey.org.uk


The patch titled
     Updates to VIA DRI
has been added to the -mm tree.  Its filename is
     updates-to-via-dri.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Updates to VIA DRI
From: Claas Langbehn <claas@rootdir.de>

This patch is based on the source code that VIA released here:
http://www.viaarena.com/Driver/cle266cn400cn-cx700cn800xorg40072-kernel-src_20061226.tgz

Signed-off-by: Claas Langbehn <claas@rootdir.de>
Cc: Dave Airlie <airlied@linux.ie>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/drm/via_3d_reg.h |   68 ++++++++++++++++----------------
 1 file changed, 35 insertions(+), 33 deletions(-)

diff -puN drivers/char/drm/via_3d_reg.h~updates-to-via-dri drivers/char/drm/via_3d_reg.h
--- a/drivers/char/drm/via_3d_reg.h~updates-to-via-dri
+++ a/drivers/char/drm/via_3d_reg.h
@@ -1,6 +1,6 @@
 /*
- * Copyright 1998-2003 VIA Technologies, Inc. All Rights Reserved.
- * Copyright 2001-2003 S3 Graphics, Inc. All Rights Reserved.
+ * Copyright 1998-2006 VIA Technologies, Inc. All Rights Reserved.
+ * Copyright 2001-2006 S3 Graphics, Inc. All Rights Reserved.
  *
  * Permission is hereby granted, free of charge, to any person obtaining a
  * copy of this software and associated documentation files (the "Software"),
@@ -16,7 +16,7 @@
  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
- * VIA, S3 GRAPHICS, AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * THE AUTHOR(S) OR COPYRIGHT HOLDER(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
  * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
  * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
  * DEALINGS IN THE SOFTWARE.
@@ -26,8 +26,6 @@
 #define VIA_3D_REG_H
 #define HC_REG_BASE             0x0400
 
-#define HC_REG_TRANS_SPACE      0x0040
-
 #define HC_ParaN_MASK           0xffffffff
 #define HC_Para_MASK            0x00ffffff
 #define HC_SubA_MASK            0xff000000
@@ -176,7 +174,7 @@
 /* Command
  * Command A
  */
-#define HC_HCmdHeader_MASK      0xfe000000	/*0xffe00000 */
+#define HC_HCmdHeader_MASK      0xfe000000  /*0xffe00000*/
 #define HC_HE3Fire_MASK         0x00100000
 #define HC_HPMType_MASK         0x000f0000
 #define HC_HEFlag_MASK          0x0000e000
@@ -909,6 +907,15 @@
 #define HC_HTXnTB_TBC_T         0x00200000
 #define HC_HTXnTB_TB_S          0x00400000
 #define HC_HTXnTB_TB_T          0x00800000
+
+/* The "S" in FLS? means the S texture coordinate, and a "T" means the T
+ * texture coordinage.  The "e" in FL?e means the magnification ("enlarge")
+ * mode, and the "s" in FL?s means the minification ("shrink") mode.
+ *
+ * The "D" in FLD? means the intermipmap level mode.  That means that the
+ * GL_*_MIPMAP_LINEAR modes get FLDs_Linear, and the GL_*_MIPMAP_NEAREST modes
+ * get FLDs_Nearest.
+ */
 #define HC_HTXnFLSe_Nearest     0x00000000
 #define HC_HTXnFLSe_Linear      0x00002000
 #define HC_HTXnFLSe_NonLinear   0x00004000
@@ -935,6 +942,7 @@
 #define HC_HTXnFLDs_ConstLOD    0x00000005
 #define HC_HTXnFLDs_Ani         0x00000006
 #define HC_HTXnFLDs_AniDither   0x00000007
+
 /* HC_SubA_HTXnMPMD        0x0079
  */
 #define HC_HTXnMPMD_SMASK       0x00070000
@@ -960,20 +968,20 @@
  */
 #define HC_HTXnFM_MASK          0x00ff0000
 #define HC_HTXnLoc_MASK         0x00000003
-#define HC_HTXnFM_INDEX         0x00000000
-#define HC_HTXnFM_Intensity     0x00080000
-#define HC_HTXnFM_Lum           0x00100000
-#define HC_HTXnFM_Alpha         0x00180000
-#define HC_HTXnFM_DX            0x00280000
-#define HC_HTXnFM_ARGB16        0x00880000
-#define HC_HTXnFM_ARGB32        0x00980000
-#define HC_HTXnFM_ABGR16        0x00a80000
-#define HC_HTXnFM_ABGR32        0x00b80000
-#define HC_HTXnFM_RGBA16        0x00c80000
-#define HC_HTXnFM_RGBA32        0x00d80000
-#define HC_HTXnFM_BGRA16        0x00e80000
-#define HC_HTXnFM_BGRA32        0x00f80000
-#define HC_HTXnFM_BUMPMAP       0x00380000
+#define HC_HTXnFM_INDEX         0x00000000 /*  0 << 19 */
+#define HC_HTXnFM_Intensity     0x00080000 /*  1 << 19 */
+#define HC_HTXnFM_Lum           0x00100000 /*  2 << 19 */
+#define HC_HTXnFM_Alpha         0x00180000 /*  3 << 19 */
+#define HC_HTXnFM_DX            0x00280000 /*  5 << 19 */
+#define HC_HTXnFM_BUMPMAP       0x00380000 /*  7 << 19 */
+#define HC_HTXnFM_ARGB16        0x00880000 /* 17 << 19 */
+#define HC_HTXnFM_ARGB32        0x00980000 /* 19 << 19 */
+#define HC_HTXnFM_ABGR16        0x00a80000 /* 21 << 19 */
+#define HC_HTXnFM_ABGR32        0x00b80000 /* 23 << 19 */
+#define HC_HTXnFM_RGBA16        0x00c80000 /* 25 << 19 */
+#define HC_HTXnFM_RGBA32        0x00d80000 /* 27 << 19 */
+#define HC_HTXnFM_BGRA16        0x00e80000 /* 29 << 19 */
+#define HC_HTXnFM_BGRA32        0x00f80000 /* 31 << 19 */
 #define HC_HTXnFM_Index1        (HC_HTXnFM_INDEX     | 0x00000000)
 #define HC_HTXnFM_Index2        (HC_HTXnFM_INDEX     | 0x00010000)
 #define HC_HTXnFM_Index4        (HC_HTXnFM_INDEX     | 0x00020000)
@@ -1030,8 +1038,8 @@
 #define HC_HTXnTBA_MASK         0x000000ff
 #define HC_HTXnTRAH_SHIFT       16
 #define HC_HTXnTRAL_SHIFT       8
-/* HC_SubA_HTXnTBLCsat     0x0080
- *-- Define the input texture.
+
+/*-- Define the input texture, for below
  */
 #define HC_XTC_TOPC             0x00000000
 #define HC_XTC_InvTOPC          0x00000010
@@ -1049,7 +1057,7 @@
 #define HC_XTC_Acur             0x00000008
 #define HC_XTC_HTXnTBLRC        0x00000009
 #define HC_XTC_Ctexnext         0x0000000a
-/*--
+/** HC_SubA_HTXnTBLCsat     0x0080
  */
 #define HC_HTXnTBLCsat_MASK     0x00800000
 #define HC_HTXnTBLCa_MASK       0x000fc000
@@ -1106,6 +1114,8 @@
 #define HC_HTXnTBLAop_MASK      0x00000380
 #define HC_HTXnTBLAbias_MASK    0x00000078
 #define HC_HTXnTBLAshift_MASK   0x00000003
+#define HC_HTXnTBLDOT3          0x00800000
+#define HC_HTXnTBLDOT4          0x00c00000
 #define HC_HTXnTBLCop_Add       0x00000000
 #define HC_HTXnTBLCop_Sub       0x00080000
 #define HC_HTXnTBLCop_Min       0x00100000
@@ -1127,10 +1137,6 @@
 #define HC_HTXnTBLCshift_2      0x00000800
 #define HC_HTXnTBLCshift_No     0x00001000
 #define HC_HTXnTBLCshift_DotP   0x00001800
-/*=* John Sheng [2003.7.18] texture combine *=*/
-#define HC_HTXnTBLDOT3   0x00080000
-#define HC_HTXnTBLDOT4   0x000C0000
-
 #define HC_HTXnTBLAop_Add       0x00000000
 #define HC_HTXnTBLAop_Sub       0x00000080
 #define HC_HTXnTBLAop_Min       0x00000100
@@ -1145,7 +1151,7 @@
 #define HC_HTXnTBLAshift_1      0x00000000
 #define HC_HTXnTBLAshift_2      0x00000001
 #define HC_HTXnTBLAshift_No     0x00000002
-/* #define HC_HTXnTBLAshift_DotP   0x00000003 */
+#define HC_HTXnTBLAshift_DotP   0x00000003
 /* HC_SubA_HTXnTBLMPFog    0x0082
  */
 #define HC_HTXnTBLMPfog_MASK    0x00e00000
@@ -1623,7 +1629,7 @@
 #define HALCYON_CMDB        0XEC000000
 #define HALCYON_CMDBMASK    0XFFFE0000
 #define HALCYON_SUB_ADDR0   0X00000000
-#define HALCYON_HEADER1MASK 0XFFFFFC00
+#define HALCYON_HEADER1MASK 0XFFFFFF00
 #define HALCYON_HEADER1     0XF0000000
 #define HC_SubA_HAGPBstL        0x0060
 #define HC_SubA_HAGPBendL       0x0061
@@ -1643,8 +1649,4 @@
 #define HC_HAGPBpID_STOP        0x00000002
 #define HC_HAGPBpH_MASK         0x00ffffff
 
-#define VIA_VIDEO_HEADER5       0xFE040000
-#define VIA_VIDEO_HEADER6       0xFE050000
-#define VIA_VIDEO_HEADER7       0xFE060000
-#define VIA_VIDEOMASK           0xFFFF0000
 #endif
_

Patches currently in -mm which might be from claas@rootdir.de are

via-agp-and-drm-adding-support-for-cx700m2-p4m890-and-vt3336-chipsets.patch
via-agp-and-drm-adding-support-for-cx700m2-p4m890-and-vt3336-chipsets-fix.patch
updates-to-via-dri.patch
