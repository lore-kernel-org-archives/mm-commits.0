From: akpm@linux-foundation.org
Subject: - s3c2410fb-use-vertical-margins-values.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:43:21 -0700
Message-ID: <200710162043.l9GKhLCu016036@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59073 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935903AbXJPVHv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:07:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     s3c2410fb: use vertical margins values
has been removed from the -mm tree.  Its filename was
     s3c2410fb-use-vertical-margins-values.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 7 insertions(+), 14 deletions(-)

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

origin.patch
git-alsa.patch
cyber2000fb-checkpatch-fixes.patch
