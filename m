From: akpm@linux-foundation.org
Subject: + viafb-rework-color-checking.patch added to -mm tree
Date: Tue, 16 Feb 2010 11:59:11 -0800
Message-ID: <201002161959.o1GJxB2G001918@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40148 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756767Ab0BPT7R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Feb 2010 14:59:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn


The patch titled
     viafb: rework color checking
has been added to the -mm tree.  Its filename is
     viafb-rework-color-checking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: viafb: rework color checking
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

Make color checking a bit more tolerant in what values it allows and more
fine grained to later support 15 and 30 bits formats.  It splits the
filling of the color information in var to a seperate function and sets
some color related values in var that where previously untouched.

This could be a bug fix but at least I don't know any applications that
was fooled by not correctly setting the fields in var.  At least no
regressions are expected.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/hw.c       |   30 ----------------
 drivers/video/via/viafbdev.c |   61 ++++++++++++++++++++++++++++++---
 2 files changed, 56 insertions(+), 35 deletions(-)

diff -puN drivers/video/via/hw.c~viafb-rework-color-checking drivers/video/via/hw.c
--- a/drivers/video/via/hw.c~viafb-rework-color-checking
+++ a/drivers/video/via/hw.c
@@ -2622,36 +2622,6 @@ void viafb_fill_var_timing_info(struct f
 	}
 
 	crt_reg = crt_timing[index].crtc;
-	switch (var->bits_per_pixel) {
-	case 8:
-		var->red.offset = 0;
-		var->green.offset = 0;
-		var->blue.offset = 0;
-		var->red.length = 6;
-		var->green.length = 6;
-		var->blue.length = 6;
-		break;
-	case 16:
-		var->red.offset = 11;
-		var->green.offset = 5;
-		var->blue.offset = 0;
-		var->red.length = 5;
-		var->green.length = 6;
-		var->blue.length = 5;
-		break;
-	case 32:
-		var->red.offset = 16;
-		var->green.offset = 8;
-		var->blue.offset = 0;
-		var->red.length = 8;
-		var->green.length = 8;
-		var->blue.length = 8;
-		break;
-	default:
-		/* never happed, put here to keep consistent */
-		break;
-	}
-
 	var->pixclock = viafb_get_pixclock(var->xres, var->yres, refresh);
 	var->left_margin =
 	    crt_reg.hor_total - (crt_reg.hor_sync_start + crt_reg.hor_sync_end);
diff -puN drivers/video/via/viafbdev.c~viafb-rework-color-checking drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~viafb-rework-color-checking
+++ a/drivers/video/via/viafbdev.c
@@ -60,6 +60,47 @@ static int viafb_pan_display(struct fb_v
 static struct fb_ops viafb_ops;
 
 
+static void viafb_fill_var_color_info(struct fb_var_screeninfo *var, u8 depth)
+{
+	var->grayscale = 0;
+	var->red.msb_right = 0;
+	var->green.msb_right = 0;
+	var->blue.msb_right = 0;
+	var->transp.offset = 0;
+	var->transp.length = 0;
+	var->transp.msb_right = 0;
+	var->nonstd = 0;
+	switch (depth) {
+	case 8:
+		var->bits_per_pixel = 8;
+		var->red.offset = 0;
+		var->green.offset = 0;
+		var->blue.offset = 0;
+		var->red.length = 6;
+		var->green.length = 6;
+		var->blue.length = 6;
+		break;
+	case 16:
+		var->bits_per_pixel = 16;
+		var->red.offset = 11;
+		var->green.offset = 5;
+		var->blue.offset = 0;
+		var->red.length = 5;
+		var->green.length = 6;
+		var->blue.length = 5;
+		break;
+	case 24:
+		var->bits_per_pixel = 32;
+		var->red.offset = 16;
+		var->green.offset = 8;
+		var->blue.offset = 0;
+		var->red.length = 8;
+		var->green.length = 8;
+		var->blue.length = 8;
+		break;
+	}
+}
+
 static void viafb_update_fix(struct fb_info *info)
 {
 	u32 bpp = info->var.bits_per_pixel;
@@ -81,6 +122,7 @@ static void viafb_setup_fixinfo(struct f
 
 	fix->type = FB_TYPE_PACKED_PIXELS;
 	fix->type_aux = 0;
+	fix->visual = FB_VISUAL_TRUECOLOR;
 
 	fix->xpanstep = fix->ywrapstep = 0;
 	fix->ypanstep = 1;
@@ -103,7 +145,7 @@ static int viafb_release(struct fb_info 
 static int viafb_check_var(struct fb_var_screeninfo *var,
 	struct fb_info *info)
 {
-	int htotal, vtotal;
+	int htotal, vtotal, depth;
 	struct VideoModeTable *vmode_entry;
 	struct viafb_par *ppar = info->par;
 	u32 long_refresh;
@@ -122,13 +164,22 @@ static int viafb_check_var(struct fb_var
 		return -EINVAL;
 	}
 
-	if (24 == var->bits_per_pixel)
-		var->bits_per_pixel = 32;
+	depth = fb_get_color_depth(var, &info->fix);
+	if (!depth)
+		depth = var->bits_per_pixel;
 
-	if (var->bits_per_pixel != 8 && var->bits_per_pixel != 16 &&
-		var->bits_per_pixel != 32)
+	if (depth < 0 || depth > 32)
 		return -EINVAL;
+	else if (!depth)
+		depth = 24;
+	else if (depth <= 8)
+		depth = 8;
+	else if (depth <= 16)
+		depth = 16;
+	else
+		depth = 24;
 
+	viafb_fill_var_color_info(var, depth);
 	if ((var->xres_virtual * (var->bits_per_pixel >> 3)) & 0x1F)
 		/*32 pixel alignment */
 		var->xres_virtual = (var->xres_virtual + 31) & ~31;
_

Patches currently in -mm which might be from FlorianSchandinat@gmx.de are

viafb-deprecate-private-ioctls.patch
viafb-remove-dead-code.patch
viafb-split-global-index-up.patch
viafb-split-global-index-up-fix.patch
viafb-remove-the-remaining-via_res_-uses.patch
viafb-some-dvi-cleanup.patch
viafb-yet-another-dead-code-removal.patch
viafb-reorder-initialization-for-dual-framebuffer-mode.patch
viafb-video-address-setting-revisited.patch
viafb-make-viafb_set_par-more-dual-framebuffer-compatible.patch
viafb-introduce-strict-parameter-checking.patch
viafb-split-color-mode-setting-up.patch
viafb-remove-dead-code-due-to-iga1_iga2.patch
viafb-make-some-variables-a-bit-less-global.patch
viafb-rework-color-checking.patch
viafb-some-virtual_xres-handling-fixes.patch
viafb-rework-color-setting.patch
viafb-support-color-depth-15-and-30.patch
drivers-video-via-fix-continuation-line-formats.patch

