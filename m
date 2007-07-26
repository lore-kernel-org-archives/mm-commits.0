From: akpm@linux-foundation.org
Subject: + fbdev-fix-logo-if-logo-depth-is-less-than-framebuffer-depth.patch added to -mm tree
Date: Thu, 26 Jul 2007 12:00:04 -0700
Message-ID: <200707261900.l6QJ04JU015578@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55028 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753279AbXGZTAM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 15:00:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com


The patch titled
     fbdev: Fix logo if logo depth is less than framebuffer  depth
has been added to the -mm tree.  Its filename is
     fbdev-fix-logo-if-logo-depth-is-less-than-framebuffer-depth.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fbdev: Fix logo if logo depth is less than framebuffer  depth
From: "Antonino A. Daplas" <adaplas@gmail.com>

The VGA16 logo (bpp = 4) and monochrome logo (bpp = 1) do not contain any
color information (no CLUT).  If the fb depth is > logo depth, these logo's
will not properly display. Fix by using the console palette instead of
creating a new one.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmem.c |   42 ++++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 16 deletions(-)

diff -puN drivers/video/fbmem.c~fbdev-fix-logo-if-logo-depth-is-less-than-framebuffer-depth drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fbdev-fix-logo-if-logo-depth-is-less-than-framebuffer-depth
+++ a/drivers/video/fbmem.c
@@ -244,8 +244,17 @@ static void fb_set_logo(struct fb_info *
 	u8 xor = (info->fix.visual == FB_VISUAL_MONO01) ? 0xff : 0;
 	u8 fg = 1, d;
 
-	if (fb_get_color_depth(&info->var, &info->fix) == 3)
+	switch (fb_get_color_depth(&info->var, &info->fix)) {
+	case 1:
+		fg = 1;
+		break;
+	case 2:
+		fg = 3;
+		break;
+	default:
 		fg = 7;
+		break;
+	}
 
 	if (info->fix.visual == FB_VISUAL_MONO01 ||
 	    info->fix.visual == FB_VISUAL_MONO10)
@@ -564,21 +573,6 @@ int fb_prepare_logo(struct fb_info *info
 		depth = 4;
 	}
 
-	if (depth >= 8) {
-		switch (info->fix.visual) {
-		case FB_VISUAL_TRUECOLOR:
-			fb_logo.needs_truepalette = 1;
-			break;
-		case FB_VISUAL_DIRECTCOLOR:
-			fb_logo.needs_directpalette = 1;
-			fb_logo.needs_cmapreset = 1;
-			break;
-		case FB_VISUAL_PSEUDOCOLOR:
-			fb_logo.needs_cmapreset = 1;
-			break;
-		}
-	}
-
 	/* Return if no suitable logo was found */
 	fb_logo.logo = fb_find_logo(depth);
 
@@ -604,6 +598,22 @@ int fb_prepare_logo(struct fb_info *info
 	else
 		fb_logo.depth = 1;
 
+
+ 	if (fb_logo.depth > 4 && depth > 4) {
+ 		switch (info->fix.visual) {
+ 		case FB_VISUAL_TRUECOLOR:
+ 			fb_logo.needs_truepalette = 1;
+ 			break;
+ 		case FB_VISUAL_DIRECTCOLOR:
+ 			fb_logo.needs_directpalette = 1;
+ 			fb_logo.needs_cmapreset = 1;
+ 			break;
+ 		case FB_VISUAL_PSEUDOCOLOR:
+ 			fb_logo.needs_cmapreset = 1;
+ 			break;
+ 		}
+ 	}
+
 	return fb_prepare_extra_logos(info, fb_logo.logo->height, yres);
 }
 
_

Patches currently in -mm which might be from adaplas@gmail.com are

fbcon-fix-typo-and-bogus-logic-in-get_default_font.patch
fbdev-fix-logo-if-logo-depth-is-less-than-framebuffer-depth.patch
s3c2410fb-fix-s3c2410-compilation.patch
xilinxfbremove-__initdata-from-xilinx_fb_fix-and-xilinx_fb_var.patch
xilinxfb-dont-bail-if-the-xilinxfb-platform-device-doesnt-have-any-pdata.patch
lxfb-geode-add-framebuffer-support-for-the-amd-geode-lx.patch
fbdev-export-fb_destroy_modelist.patch
connector-change-connectors-max-message-size.patch
uvesafb-add-connector-entries.patch
uvesafb-the-driver-core.patch
uvesafb-documentation.patch
pm3fb-copyarea-and-partial-imageblit-suppor.patch
skeletonfb-wrong-field-name-fix.patch
pm3fb-header-file-reduction.patch
pm3fb-imageblit-improved.patch
pm3fb-3-small-fixes.patch
pm3fb-improvements-and-cleanups.patch
pm3fb-mtrr-support-and-noaccel-option.patch
pm2fb-mtrr-support-and-noaccel-option.patch
pm2fb-accelerated-imageblit.patch
pm2fb-source-code-improvements.patch
pm2fb-permedia-2v-initialization-fixes.patch
pm2fb-accelerated-24-bit-fillrect.patch
sm501fb-update-suspend-and-resume-code.patch
sm501fb-call-fb-suspend-function-during-suspend-and-resume.patch
sm501fb-ensure-panel-interface-is-not-tristated-when-setup.patch
mbxfb-improvements-and-new-features.patch
pxafb-add-support-for-other-palette-formats.patch
stifb-detect-cards-in-double-buffer-mode-more-reliably.patch
tdfxfb-coding-style-improvement.patch
tridentfb-coding-style-improvement.patch
tdfxfb-3-fixes.patch
tdfxfb-palette-fixes.patch
