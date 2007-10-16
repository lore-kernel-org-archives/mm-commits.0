From: akpm@linux-foundation.org
Subject: - s3c2410fb-add-pulse-length-fields-to-s3c2410fb_display.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:43:23 -0700
Message-ID: <200710162043.l9GKhNqr016044@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39447 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933584AbXJPVPz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:15:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     s3c2410fb: add pulse length fields to s3c2410fb_display
has been removed from the -mm tree.  Its filename was
     s3c2410fb-add-pulse-length-fields-to-s3c2410fb_display.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: s3c2410fb: add pulse length fields to s3c2410fb_display
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch adds synchronization pulse lenght fields to
the s3c2410fb_display structure and makes use of them
in the driver.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-s3c2410/mach-amlm5900.c |    1 
 arch/arm/mach-s3c2410/mach-bast.c     |   18 ++++++++++++
 arch/arm/mach-s3c2410/mach-h1940.c    |    2 +
 arch/arm/mach-s3c2410/mach-qt2410.c   |    6 ++++
 arch/arm/mach-s3c2440/mach-rx3715.c   |    2 +
 arch/arm/mach-s3c2440/mach-smdk2440.c |    2 +
 drivers/video/s3c2410fb.c             |   34 +++++++++++-------------
 7 files changed, 47 insertions(+), 18 deletions(-)

diff -puN arch/arm/mach-s3c2410/mach-amlm5900.c~s3c2410fb-add-pulse-length-fields-to-s3c2410fb_display arch/arm/mach-s3c2410/mach-amlm5900.c
--- a/arch/arm/mach-s3c2410/mach-amlm5900.c~s3c2410fb-add-pulse-length-fields-to-s3c2410fb_display
+++ a/arch/arm/mach-s3c2410/mach-amlm5900.c
@@ -179,6 +179,7 @@ static struct s3c2410fb_display __initda
 	.bpp		= 4,
 	.left_margin	= 1 << (4 + 3),
 	.right_margin	= 8 << 3,
+	.hsync_len	= 48,
 	.upper_margin	= 0,
 	.lower_margin	= 0,
 
diff -puN arch/arm/mach-s3c2410/mach-bast.c~s3c2410fb-add-pulse-length-fields-to-s3c2410fb_display arch/arm/mach-s3c2410/mach-bast.c
--- a/arch/arm/mach-s3c2410/mach-bast.c~s3c2410fb-add-pulse-length-fields-to-s3c2410fb_display
+++ a/arch/arm/mach-s3c2410/mach-bast.c
@@ -477,8 +477,10 @@ static struct s3c2410fb_display __initda
 		.yres		= 240,
 		.left_margin	= 40,
 		.right_margin	= 20,
+		.hsync_len	= 88,
 		.upper_margin	= 30,
 		.lower_margin	= 32,
+		.vsync_len	= 3,
 
 		.bpp		= 4,
 
@@ -497,8 +499,10 @@ static struct s3c2410fb_display __initda
 		.bpp		= 4,
 		.left_margin	= 40,
 		.right_margin	= 20,
+		.hsync_len	= 88,
 		.upper_margin	= 30,
 		.lower_margin	= 32,
+		.vsync_len	= 3,
 
 		.lcdcon1	= 0x00000176,
 		.lcdcon2	= 0x1d77c7c2,
@@ -515,8 +519,10 @@ static struct s3c2410fb_display __initda
 		.bpp		= 4,
 		.left_margin	= 40,
 		.right_margin	= 20,
+		.hsync_len	= 88,
 		.upper_margin	= 30,
 		.lower_margin	= 32,
+		.vsync_len	= 3,
 
 		.lcdcon1	= 0x00000176,
 		.lcdcon2	= 0x1d77c7c2,
@@ -533,8 +539,10 @@ static struct s3c2410fb_display __initda
 		.bpp		= 8,
 		.left_margin	= 40,
 		.right_margin	= 20,
+		.hsync_len	= 88,
 		.upper_margin	= 30,
 		.lower_margin	= 32,
+		.vsync_len	= 3,
 
 		.lcdcon1	= 0x00000176,
 		.lcdcon2	= 0x1d77c7c2,
@@ -551,8 +559,10 @@ static struct s3c2410fb_display __initda
 		.bpp		= 8,
 		.left_margin	= 40,
 		.right_margin	= 20,
+		.hsync_len	= 88,
 		.upper_margin	= 30,
 		.lower_margin	= 32,
+		.vsync_len	= 3,
 
 		.lcdcon1	= 0x00000176,
 		.lcdcon2	= 0x1d77c7c2,
@@ -569,8 +579,10 @@ static struct s3c2410fb_display __initda
 		.bpp		= 8,
 		.left_margin	= 40,
 		.right_margin	= 20,
+		.hsync_len	= 88,
 		.upper_margin	= 30,
 		.lower_margin	= 32,
+		.vsync_len	= 3,
 
 		.lcdcon1	= 0x00000176,
 		.lcdcon2	= 0x1d77c7c2,
@@ -587,8 +599,10 @@ static struct s3c2410fb_display __initda
 		.bpp		= 16,
 		.left_margin	= 40,
 		.right_margin	= 20,
+		.hsync_len	= 88,
 		.upper_margin	= 30,
 		.lower_margin	= 32,
+		.vsync_len	= 3,
 
 		.lcdcon1	= 0x00000176,
 		.lcdcon2	= 0x1d77c7c2,
@@ -605,8 +619,10 @@ static struct s3c2410fb_display __initda
 		.bpp		= 16,
 		.left_margin	= 40,
 		.right_margin	= 20,
+		.hsync_len	= 88,
 		.upper_margin	= 30,
 		.lower_margin	= 32,
+		.vsync_len	= 3,
 
 		.lcdcon1	= 0x00000176,
 		.lcdcon2	= 0x1d77c7c2,
@@ -623,8 +639,10 @@ static struct s3c2410fb_display __initda
 		.bpp		= 16,
 		.left_margin	= 40,
 		.right_margin	= 20,
+		.hsync_len	= 88,
 		.upper_margin	= 30,
 		.lower_margin	= 32,
+		.vsync_len	= 3,
 
 		.lcdcon1	= 0x00000176,
 		.lcdcon2	= 0x1d77c7c2,
diff -puN arch/arm/mach-s3c2410/mach-h1940.c~s3c2410fb-add-pulse-length-fields-to-s3c2410fb_display arch/arm/mach-s3c2410/mach-h1940.c
--- a/arch/arm/mach-s3c2410/mach-h1940.c~s3c2410fb-add-pulse-length-fields-to-s3c2410fb_display
+++ a/arch/arm/mach-s3c2410/mach-h1940.c
@@ -158,8 +158,10 @@ static struct s3c2410fb_display h1940_lc
 	.bpp =		16,
 	.left_margin =	20,
 	.right_margin =	8,
+	.hsync_len =	4,
 	.upper_margin =	8,
 	.lower_margin = 7,
+	.vsync_len =	1,
 };
 
 static struct s3c2410fb_mach_info h1940_fb_info __initdata = {
diff -puN arch/arm/mach-s3c2410/mach-qt2410.c~s3c2410fb-add-pulse-length-fields-to-s3c2410fb_display arch/arm/mach-s3c2410/mach-qt2410.c
--- a/arch/arm/mach-s3c2410/mach-qt2410.c~s3c2410fb-add-pulse-length-fields-to-s3c2410fb_display
+++ a/arch/arm/mach-s3c2410/mach-qt2410.c
@@ -125,8 +125,10 @@ static struct s3c2410fb_display qt2410_l
 		.bpp		= 16,
 		.left_margin	= 44,
 		.right_margin	= 116,
+		.hsync_len	= 96,
 		.upper_margin	= 19,
 		.lower_margin	= 11,
+		.vsync_len	= 15,
 	},
 	{
 		/* Configuration for 480x640 toppoly TD028TTEC1 */
@@ -156,8 +158,10 @@ static struct s3c2410fb_display qt2410_l
 		.bpp		= 16,
 		.left_margin	= 8,
 		.right_margin	= 24,
+		.hsync_len	= 8,
 		.upper_margin	= 2,
 		.lower_margin	= 4,
+		.vsync_len	= 2,
 	},
 	{
 		/* Config for 240x320 LCD */
@@ -187,8 +191,10 @@ static struct s3c2410fb_display qt2410_l
 		.bpp		= 16,
 		.left_margin	= 13,
 		.right_margin	= 8,
+		.hsync_len	= 4,
 		.upper_margin	= 2,
 		.lower_margin	= 7,
+		.vsync_len	= 4,
 	},
 };
 
diff -puN arch/arm/mach-s3c2440/mach-rx3715.c~s3c2410fb-add-pulse-length-fields-to-s3c2410fb_display arch/arm/mach-s3c2440/mach-rx3715.c
--- a/arch/arm/mach-s3c2440/mach-rx3715.c~s3c2410fb-add-pulse-length-fields-to-s3c2410fb_display
+++ a/arch/arm/mach-s3c2440/mach-rx3715.c
@@ -136,8 +136,10 @@ static struct s3c2410fb_display rx3715_l
 	.bpp		= 16,
 	.left_margin	= 36,
 	.right_margin	= 36,
+	.hsync_len	= 8,
 	.upper_margin	= 6,
 	.lower_margin	= 7,
+	.vsync_len	= 3,
 };
 
 static struct s3c2410fb_mach_info rx3715_fb_info __initdata = {
diff -puN arch/arm/mach-s3c2440/mach-smdk2440.c~s3c2410fb-add-pulse-length-fields-to-s3c2410fb_display arch/arm/mach-s3c2440/mach-smdk2440.c
--- a/arch/arm/mach-s3c2440/mach-smdk2440.c~s3c2410fb-add-pulse-length-fields-to-s3c2410fb_display
+++ a/arch/arm/mach-s3c2440/mach-smdk2440.c
@@ -133,8 +133,10 @@ static struct s3c2410fb_display smdk2440
 	.bpp		= 16,
 	.left_margin	= 20,
 	.right_margin	= 8,
+	.hsync_len	= 4,
 	.upper_margin	= 8,
 	.lower_margin	= 7,
+	.vsync_len	= 4,
 };
 
 static struct s3c2410fb_mach_info smdk2440_fb_info __initdata = {
diff -puN drivers/video/s3c2410fb.c~s3c2410fb-add-pulse-length-fields-to-s3c2410fb_display drivers/video/s3c2410fb.c
--- a/drivers/video/s3c2410fb.c~s3c2410fb-add-pulse-length-fields-to-s3c2410fb_display
+++ a/drivers/video/s3c2410fb.c
@@ -290,6 +290,7 @@ static void s3c2410fb_calculate_stn_lcd_
 	int type = regs->lcdcon1 & ~S3C2410_LCDCON1_TFT;
 	int hs = var->xres >> 2;
 	unsigned wdly = (var->left_margin >> 4) - 1;
+	unsigned wlh = (var->hsync_len >> 4) - 1;
 
 	dprintk("%s: var->xres  = %d\n", __FUNCTION__, var->xres);
 	dprintk("%s: var->yres  = %d\n", __FUNCTION__, var->yres);
@@ -333,9 +334,15 @@ static void s3c2410fb_calculate_stn_lcd_
 	if (wdly > 3)
 		wdly = 3;
 
+	if (wlh > 3)
+		wlh = 3;
+
 	regs->lcdcon3 =	S3C2410_LCDCON3_WDLY(wdly) |
 			S3C2410_LCDCON3_LINEBLANK(var->right_margin / 8) |
 			S3C2410_LCDCON3_HOZVAL(hs - 1);
+
+	regs->lcdcon4 &= ~S3C2410_LCDCON4_HSPW(0xff);
+	regs->lcdcon4 |=  S3C2410_LCDCON4_HSPW(wlh);
 }
 
 /* s3c2410fb_calculate_tft_lcd_regs
@@ -383,14 +390,17 @@ static void s3c2410fb_calculate_tft_lcd_
 	dprintk("setting horz: lft=%d, rt=%d, sync=%d\n",
 		var->left_margin, var->right_margin, var->hsync_len);
 
-	regs->lcdcon2 &= S3C2410_LCDCON2_VSPW(0x3f);
-	regs->lcdcon2 |= S3C2410_LCDCON2_LINEVAL(var->yres - 1);
-	regs->lcdcon2 |= S3C2410_LCDCON2_VBPD(var->upper_margin - 1);
-	regs->lcdcon2 |= S3C2410_LCDCON2_VFPD(var->lower_margin - 1);
+	regs->lcdcon2 = S3C2410_LCDCON2_LINEVAL(var->yres - 1) |
+			S3C2410_LCDCON2_VBPD(var->upper_margin - 1) |
+			S3C2410_LCDCON2_VFPD(var->lower_margin - 1) |
+			S3C2410_LCDCON2_VSPW(var->vsync_len - 1);
 
 	regs->lcdcon3 = S3C2410_LCDCON3_HBPD(var->right_margin - 1) |
 			S3C2410_LCDCON3_HFPD(var->left_margin - 1) |
 			S3C2410_LCDCON3_HOZVAL(var->xres - 1);
+
+	regs->lcdcon4 &= ~S3C2410_LCDCON4_HSPW(0xff);
+	regs->lcdcon4 |=  S3C2410_LCDCON4_HSPW(var->hsync_len - 1);
 }
 
 /* s3c2410fb_activate_var
@@ -410,16 +420,6 @@ static void s3c2410fb_activate_var(struc
 	fbi->regs.lcdcon1 &= ~S3C2410_LCDCON1_TFT;
 	fbi->regs.lcdcon1 |= display->type;
 
-	/* check to see if we need to update sync/borders */
-
-	if (!mach_info->fixed_syncs) {
-		fbi->regs.lcdcon2 =
-			S3C2410_LCDCON2_VSPW(var->vsync_len - 1);
-
-		fbi->regs.lcdcon4 &= ~S3C2410_LCDCON4_HSPW(0xff);
-		fbi->regs.lcdcon4 |=  S3C2410_LCDCON4_HSPW(var->hsync_len - 1);
-	}
-
 	if (var->pixclock > 0) {
 		int clkdiv = s3c2410fb_calc_pixclk(fbi, var->pixclock);
 
@@ -890,10 +890,8 @@ static int __init s3c2410fb_probe(struct
 
 	fbinfo->var.upper_margin    = display->upper_margin;
 	fbinfo->var.lower_margin    = display->lower_margin;
-	fbinfo->var.vsync_len	    =
-				S3C2410_LCDCON2_GET_VSPW(display->lcdcon2) + 1;
-	fbinfo->var.hsync_len	    =
-				S3C2410_LCDCON4_GET_HSPW(display->lcdcon4) + 1;
+	fbinfo->var.vsync_len	    = display->vsync_len;
+	fbinfo->var.hsync_len	    = display->hsync_len;
 
 	fbinfo->var.red.offset      = 11;
 	fbinfo->var.green.offset    = 5;
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
git-alsa.patch
cyber2000fb-checkpatch-fixes.patch
