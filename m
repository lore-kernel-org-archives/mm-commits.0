From: akpm@linux-foundation.org
Subject: + s3c2410fb-byte-ordering-fixes.patch added to -mm tree
Date: Sat, 15 Sep 2007 22:45:54 -0700
Message-ID: <200709160545.l8G5jsan002360@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49627 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751101AbXIPFqA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 01:46:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     s3c2410fb: byte ordering fixes
has been added to the -mm tree.  Its filename is
     s3c2410fb-byte-ordering-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: s3c2410fb: byte ordering fixes
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch sets correct bits related to the byte ordering of the
framebuffer.  This was tested on little endian kernel only.  The big endian
kernel may require different settings.

The patch also adds 32 bpp mode which is called 24 bpp by Samsung.  One
pixel takes 32 bits but only 24 bits are used in this mode.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3c2410fb.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff -puN drivers/video/s3c2410fb.c~s3c2410fb-byte-ordering-fixes drivers/video/s3c2410fb.c
--- a/drivers/video/s3c2410fb.c~s3c2410fb-byte-ordering-fixes
+++ a/drivers/video/s3c2410fb.c
@@ -265,8 +265,8 @@ static int s3c2410fb_check_var(struct fb
 			var->blue.length	= 5;
 		}
 		break;
-	case 24:
-		/* 24 bpp 888 */
+	case 32:
+		/* 24 bpp 888 and 8 dummy */
 		var->red.length		= 8;
 		var->red.offset		= 16;
 		var->green.length	= 8;
@@ -274,8 +274,6 @@ static int s3c2410fb_check_var(struct fb
 		var->blue.length	= 8;
 		var->blue.offset	= 0;
 		break;
-
-
 	}
 	return 0;
 }
@@ -374,11 +372,21 @@ static void s3c2410fb_calculate_tft_lcd_
 		break;
 	case 8:
 		regs->lcdcon1 |= S3C2410_LCDCON1_TFT8BPP;
+		regs->lcdcon5 |= S3C2410_LCDCON5_BSWP |
+				 S3C2410_LCDCON5_FRM565;
+		regs->lcdcon5 &= ~S3C2410_LCDCON5_HWSWP;
 		break;
 	case 16:
 		regs->lcdcon1 |= S3C2410_LCDCON1_TFT16BPP;
+		regs->lcdcon5 &= ~S3C2410_LCDCON5_BSWP;
+		regs->lcdcon5 |= S3C2410_LCDCON5_HWSWP;
+		break;
+	case 32:
+		regs->lcdcon1 |= S3C2410_LCDCON1_TFT24BPP;
+		regs->lcdcon5 &= ~(S3C2410_LCDCON5_BSWP |
+				   S3C2410_LCDCON5_HWSWP |
+				   S3C2410_LCDCON5_BPP24BL);
 		break;
-
 	default:
 		/* invalid pixel depth */
 		dev_err(fbi->dev, "invalid bpp %d\n",
@@ -475,7 +483,9 @@ static int s3c2410fb_set_par(struct fb_i
 	struct fb_var_screeninfo *var = &info->var;
 
 	switch (var->bits_per_pixel) {
+	case 32:
 	case 16:
+	case 12:
 		info->fix.visual = FB_VISUAL_TRUECOLOR;
 		break;
 	case 1:
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

git-alsa.patch
git-hwmon.patch
pm3fb-copyarea-and-partial-imageblit-suppor.patch
skeletonfb-wrong-field-name-fix.patch
pm3fb-header-file-reduction.patch
pm3fb-imageblit-improved.patch
pm3fb-3-small-fixes.patch
pm3fb-improvements-and-cleanups.patch
pm3fb-mtrr-support-and-noaccel-option.patch
pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch
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
s3c2410fb-byte-ordering-fixes.patch
fbdev-change-asm-uaccessh-to-linux-uaccessh.patch
s3c2410fb-source-code-improvements.patch
s3c2410fb-adds-pixclock-to-s3c2410fb_display.patch
s3c2410fb-removes-lcdcon1-register-value-from-s3c2410fb_display.patch
s3c2410fb-make-use-of-default_display-settings.patch
cirrusfb-checkpatchpl-cleanup.patch
cirrusfb-checkpatchpl-cleanup-ppc-fix.patch
cirrusfb-remove-typedefs.patch
cirrusfb-remove-fields-from-cirrusfb_info.patch
cirrusfb-code-improvements.patch
cirrusfb-code-improvement-2nd-part.patch
pm3fb-header-file-cleanup.patch
pm2fb-hardware-cursor-support-for-the-permedia2.patch
pm2fb-panning-and-hardware-cursor-fixes.patch
tdfxfb-replace-busy-waiting-with-cpu_relax.patch
pm2fb-replace-busy-waiting-with-cpu_relax.patch
pm3fb-replace-busy-waiting-with-cpu_relax.patch
tdfxfb-checkpatch-fixes.patch
