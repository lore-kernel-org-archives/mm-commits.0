From: akpm@linux-foundation.org
Subject: + s3c2410fb-use-vertical-margins-values.patch added to -mm tree
Date: Wed, 15 Aug 2007 16:21:14 -0700
Message-ID: <200708152321.l7FNLEl3020340@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48262 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757834AbXHOXVk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 19:21:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     s3c2410fb: use vertical margins values
has been added to the -mm tree.  Its filename is
     s3c2410fb-use-vertical-margins-values.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: s3c2410fb: use vertical margins values
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch makes use of vertical margins fields in
the s3c2410fb_display structure.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3c2410fb.c |   21 +++++++--------------
 1 files changed, 7 insertions(+), 14 deletions(-)

diff -puN drivers/video/s3c2410fb.c~s3c2410fb-use-vertical-margins-values drivers/video/s3c2410fb.c
--- a/drivers/video/s3c2410fb.c~s3c2410fb-use-vertical-margins-values
+++ a/drivers/video/s3c2410fb.c
@@ -325,14 +325,10 @@ static void s3c2410fb_calculate_stn_lcd_
 			var->bits_per_pixel);
 	}
 	/* update X/Y info */
-	dprintk("setting vert: up=%d, low=%d, sync=%d\n",
-		var->upper_margin, var->lower_margin, var->vsync_len);
-
 	dprintk("setting horz: lft=%d, rt=%d, sync=%d\n",
 		var->left_margin, var->right_margin, var->hsync_len);
 
-	regs->lcdcon2 &= ~S3C2410_LCDCON2_LINEVAL(0x3ff);
-	regs->lcdcon2 |=  S3C2410_LCDCON2_LINEVAL(var->yres - 1);
+	regs->lcdcon2 = S3C2410_LCDCON2_LINEVAL(var->yres - 1);
 
 	if (wdly > 3)
 		wdly = 3;
@@ -387,8 +383,10 @@ static void s3c2410fb_calculate_tft_lcd_
 	dprintk("setting horz: lft=%d, rt=%d, sync=%d\n",
 		var->left_margin, var->right_margin, var->hsync_len);
 
-	regs->lcdcon2 &= ~S3C2410_LCDCON2_LINEVAL(0x3ff);
-	regs->lcdcon2 |=  S3C2410_LCDCON2_LINEVAL(var->yres - 1);
+	regs->lcdcon2 &= S3C2410_LCDCON2_VSPW(0x3f);
+	regs->lcdcon2 |= S3C2410_LCDCON2_LINEVAL(var->yres - 1);
+	regs->lcdcon2 |= S3C2410_LCDCON2_VBPD(var->upper_margin - 1);
+	regs->lcdcon2 |= S3C2410_LCDCON2_VFPD(var->lower_margin - 1);
 
 	regs->lcdcon3 = S3C2410_LCDCON3_HBPD(var->right_margin - 1) |
 			S3C2410_LCDCON3_HFPD(var->left_margin - 1) |
@@ -416,8 +414,6 @@ static void s3c2410fb_activate_var(struc
 
 	if (!mach_info->fixed_syncs) {
 		fbi->regs.lcdcon2 =
-			S3C2410_LCDCON2_VBPD(var->upper_margin - 1) |
-			S3C2410_LCDCON2_VFPD(var->lower_margin - 1) |
 			S3C2410_LCDCON2_VSPW(var->vsync_len - 1);
 
 		fbi->regs.lcdcon4 &= ~S3C2410_LCDCON4_HSPW(0xff);
@@ -892,13 +888,10 @@ static int __init s3c2410fb_probe(struct
 	fbinfo->var.left_margin	    = display->left_margin;
 	fbinfo->var.right_margin    = display->right_margin;
 
-	fbinfo->var.upper_margin    =
-				S3C2410_LCDCON2_GET_VBPD(display->lcdcon2) + 1;
-	fbinfo->var.lower_margin    =
-				S3C2410_LCDCON2_GET_VFPD(display->lcdcon2) + 1;
+	fbinfo->var.upper_margin    = display->upper_margin;
+	fbinfo->var.lower_margin    = display->lower_margin;
 	fbinfo->var.vsync_len	    =
 				S3C2410_LCDCON2_GET_VSPW(display->lcdcon2) + 1;
-
 	fbinfo->var.hsync_len	    =
 				S3C2410_LCDCON4_GET_HSPW(display->lcdcon4) + 1;
 
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

git-alsa.patch
git-arm-master.patch
git-hwmon.patch
pm3fb-copyarea-and-partial-imageblit-suppor.patch
skeletonfb-wrong-field-name-fix.patch
pm3fb-header-file-reduction.patch
pm3fb-imageblit-improved.patch
pm3fb-3-small-fixes.patch
pm3fb-improvements-and-cleanups.patch
pm3fb-mtrr-support-and-noaccel-option.patch
pm2fb-mtrr-support-and-noaccel-option.patch
pm2fb-mtrr-support-and-noaccel-option-pm2fb-lowsyncs-section-mismatch-fix.patch
pm2fb-accelerated-imageblit.patch
pm2fb-source-code-improvements.patch
pm2fb-permedia-2v-initialization-fixes.patch
pm2fb-accelerated-24-bit-fillrect.patch
tridentfb-coding-style-improvement.patch
tdfxfb-coding-style-improvement.patch
tdfxfb-3-fixes.patch
tdfxfb-palette-fixes.patch
tdfxfb-code-improvements.patch
tdfxfb-hardware-cursor.patch
tdfxfb-mtrr-support.patch
tdfxfb-mtrr-support-fix.patch
tdfxfb-mtrr-support-fix-2.patch
pm2fb-checkpatch-fixes.patch
pm3fb-checkpatch-fixes.patch
pm2fb-permedia-2v-hardware-cursor-support.patch
pm3fb-hardware-cursor-support.patch
s3c2410fb-code-cleanup.patch
s3c2410fb-remove-fb_info-pointer-from-s3c2410fb_info.patch
s3c2410fb-multi-display-support.patch
s3c2410fb-add-margin-fields-to-s3c2410fb_display.patch
s3c2410fb-use-new-margin-fields.patch
s3c2410fb-remove-lcdcon3-register-from-s3c2410fb_display.patch
s3c2410fb-add-vertical-margins-fields-to-s3c2410fb_display.patch
s3c2410fb-use-vertical-margins-values.patch
s3c2410fb-add-pulse-length-fields-to-s3c2410fb_display.patch
s3c2410fb-remove-lcdcon2-and-lcdcon3-register-fields.patch
s3c2410fb-fix-missing-registers-offset.patch
