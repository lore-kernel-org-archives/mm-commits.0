From: akpm@linux-foundation.org
Subject: + freescale-diu-add-virtual-resolution-and-panning-support.patch added to -mm tree
Date: Wed, 13 Aug 2008 14:06:05 -0700
Message-ID: <200808132106.m7DL65xs006738@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54261 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752357AbYHMVGV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Aug 2008 17:06:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yorksun@freescale.com, adaplas@pol.net, galak@gate.crashing.org, krzysztof.h1@poczta.fm


The patch titled
     freescale DIU: add virtual resolution and panning support
has been added to the -mm tree.  Its filename is
     freescale-diu-add-virtual-resolution-and-panning-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: freescale DIU: add virtual resolution and panning support
From: York Sun <yorksun@freescale.com>

Application can now have the virtual resoltuion and use FBIOPAN_DISPLAY
ioctl to pan.

Signed-off-by: York Sun <yorksun@freescale.com>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fsl-diu-fb.c |   28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff -puN drivers/video/fsl-diu-fb.c~freescale-diu-add-virtual-resolution-and-panning-support drivers/video/fsl-diu-fb.c
--- a/drivers/video/fsl-diu-fb.c~freescale-diu-add-virtual-resolution-and-panning-support
+++ a/drivers/video/fsl-diu-fb.c
@@ -778,6 +778,22 @@ static void unmap_video_memory(struct fb
 }
 
 /*
+ * Using the fb_var_screeninfo in fb_info we set the aoi of this
+ * particular framebuffer. It is a light version of fsl_diu_set_par.
+ */
+static int fsl_diu_set_aoi(struct fb_info *info)
+{
+	struct fb_var_screeninfo *var = &info->var;
+	struct mfb_info *mfbi = info->par;
+	struct diu_ad *ad = mfbi->ad;
+
+	/* AOI should not be greater than display size */
+	ad->offset_xyi = cpu_to_le32((var->yoffset << 16) | var->xoffset);
+	ad->offset_xyd = cpu_to_le32((mfbi->y_aoi_d << 16) | mfbi->x_aoi_d);
+	return 0;
+}
+
+/*
  * Using the fb_var_screeninfo in fb_info we set the resolution of this
  * particular framebuffer. This function alters the fb_fix_screeninfo stored
  * in fb_info. It does not alter var in fb_info since we are using that
@@ -817,11 +833,11 @@ static int fsl_diu_set_par(struct fb_inf
 		diu_ops.get_pixel_format(var->bits_per_pixel,
 					 machine_data->monitor_port);
 	ad->addr    = cpu_to_le32(info->fix.smem_start);
-	ad->src_size_g_alpha = cpu_to_le32((var->yres << 12) |
-				var->xres) | mfbi->g_alpha;
-	/* fix me. AOI should not be greater than display size */
+	ad->src_size_g_alpha = cpu_to_le32((var->yres_virtual << 12) |
+				var->xres_virtual) | mfbi->g_alpha;
+	/* AOI should not be greater than display size */
 	ad->aoi_size 	= cpu_to_le32((var->yres << 16) | var->xres);
-	ad->offset_xyi = 0;
+	ad->offset_xyi = cpu_to_le32((var->yoffset << 16) | var->xoffset);
 	ad->offset_xyd = cpu_to_le32((mfbi->y_aoi_d << 16) | mfbi->x_aoi_d);
 
 	/* Disable chroma keying function */
@@ -921,6 +937,8 @@ static int fsl_diu_pan_display(struct fb
 	else
 		info->var.vmode &= ~FB_VMODE_YWRAP;
 
+	fsl_diu_set_aoi(info);
+
 	return 0;
 }
 
@@ -989,7 +1007,7 @@ static int fsl_diu_ioctl(struct fb_info 
 		pr_debug("set AOI display offset of index %d to (%d,%d)\n",
 				 mfbi->index, aoi_d.x_aoi_d, aoi_d.y_aoi_d);
 		fsl_diu_check_var(&info->var, info);
-		fsl_diu_set_par(info);
+		fsl_diu_set_aoi(info);
 		break;
 	case MFB_GET_AOID:
 		aoi_d.x_aoi_d = mfbi->x_aoi_d;
_

Patches currently in -mm which might be from yorksun@freescale.com are

freescale-diu-add-virtual-resolution-and-panning-support.patch
freescale-diu-bug-fix-add-sanity-check-for-aoi-position.patch

