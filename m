From: akpm@linux-foundation.org
Subject: - s3c2410fb-byte-ordering-fixes.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:43:29 -0700
Message-ID: <200710162043.l9GKhTxK016053@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49454 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935101AbXJPVHl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:07:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     s3c2410fb: byte ordering fixes
has been removed from the -mm tree.  Its filename was
     s3c2410fb-byte-ordering-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-alsa.patch
cyber2000fb-checkpatch-fixes.patch
