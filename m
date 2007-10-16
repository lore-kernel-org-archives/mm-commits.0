From: akpm@linux-foundation.org
Subject: - s3c2410fb-removes-lcdcon1-register-value-from-s3c2410fb_display.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:43:43 -0700
Message-ID: <200710162043.l9GKhham016077@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36029 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965244AbXJPVOU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:14:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     s3c2410fb: removes lcdcon1 register value from s3c2410fb_display
has been removed from the -mm tree.  Its filename was
     s3c2410fb-removes-lcdcon1-register-value-from-s3c2410fb_display.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: s3c2410fb: removes lcdcon1 register value from s3c2410fb_display
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch removes lcdcon1 register field from the s3c2410fb_display as all
bits are calculated from other fields.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-s3c2410/mach-amlm5900.c |    1 -
 arch/arm/mach-s3c2410/mach-bast.c     |    3 ---
 arch/arm/mach-s3c2410/mach-h1940.c    |    4 ----
 arch/arm/mach-s3c2410/mach-qt2410.c   |   12 ------------
 arch/arm/mach-s3c2440/mach-rx3715.c   |    4 ----
 arch/arm/mach-s3c2440/mach-smdk2440.c |    4 ----
 drivers/video/s3c2410fb.c             |    9 +--------
 include/asm-arm/arch-s3c2410/fb.h     |    1 -
 8 files changed, 1 insertion(+), 37 deletions(-)

diff -puN arch/arm/mach-s3c2410/mach-amlm5900.c~s3c2410fb-removes-lcdcon1-register-value-from-s3c2410fb_display arch/arm/mach-s3c2410/mach-amlm5900.c
--- a/arch/arm/mach-s3c2410/mach-amlm5900.c~s3c2410fb-removes-lcdcon1-register-value-from-s3c2410fb_display
+++ a/arch/arm/mach-s3c2410/mach-amlm5900.c
@@ -184,7 +184,6 @@ static struct s3c2410fb_display __initda
 	.upper_margin	= 0,
 	.lower_margin	= 0,
 
-	.lcdcon1	= 0x00008225,
 	.lcdcon5	= 0x00000001,
 };
 
diff -puN arch/arm/mach-s3c2410/mach-bast.c~s3c2410fb-removes-lcdcon1-register-value-from-s3c2410fb_display arch/arm/mach-s3c2410/mach-bast.c
--- a/arch/arm/mach-s3c2410/mach-bast.c~s3c2410fb-removes-lcdcon1-register-value-from-s3c2410fb_display
+++ a/arch/arm/mach-s3c2410/mach-bast.c
@@ -484,7 +484,6 @@ static struct s3c2410fb_display __initda
 		.lower_margin	= 32,
 		.vsync_len	= 3,
 
-		.lcdcon1	= 0x00000176,
 		.lcdcon5	= 0x00014b02,
 	},
 	{
@@ -503,7 +502,6 @@ static struct s3c2410fb_display __initda
 		.lower_margin	= 32,
 		.vsync_len	= 3,
 
-		.lcdcon1	= 0x00000176,
 		.lcdcon5	= 0x00014b02,
 	},
 	{
@@ -522,7 +520,6 @@ static struct s3c2410fb_display __initda
 		.lower_margin	= 32,
 		.vsync_len	= 3,
 
-		.lcdcon1	= 0x00000176,
 		.lcdcon5	= 0x00014b02,
 	},
 };
diff -puN arch/arm/mach-s3c2410/mach-h1940.c~s3c2410fb-removes-lcdcon1-register-value-from-s3c2410fb_display arch/arm/mach-s3c2410/mach-h1940.c
--- a/arch/arm/mach-s3c2410/mach-h1940.c~s3c2410fb-removes-lcdcon1-register-value-from-s3c2410fb_display
+++ a/arch/arm/mach-s3c2410/mach-h1940.c
@@ -134,10 +134,6 @@ static struct s3c2410_udc_mach_info h194
  * Set lcd on or off
  **/
 static struct s3c2410fb_display h1940_lcd __initdata = {
-	.lcdcon1=	S3C2410_LCDCON1_TFT16BPP | \
-			S3C2410_LCDCON1_TFT | \
-			S3C2410_LCDCON1_CLKVAL(0x0C),
-
 	.lcdcon5=	S3C2410_LCDCON5_FRM565 | \
 			S3C2410_LCDCON5_INVVLINE | \
 			S3C2410_LCDCON5_HWSWP,
diff -puN arch/arm/mach-s3c2410/mach-qt2410.c~s3c2410fb-removes-lcdcon1-register-value-from-s3c2410fb_display arch/arm/mach-s3c2410/mach-qt2410.c
--- a/arch/arm/mach-s3c2410/mach-qt2410.c~s3c2410fb-removes-lcdcon1-register-value-from-s3c2410fb_display
+++ a/arch/arm/mach-s3c2410/mach-qt2410.c
@@ -98,10 +98,6 @@ static struct s3c2410_uartcfg smdk2410_u
 static struct s3c2410fb_display qt2410_lcd_cfg[] __initdata = {
 	{
 		/* Configuration for 640x480 SHARP LQ080V3DG01 */
-		.lcdcon1 = S3C2410_LCDCON1_TFT16BPP |
-			   S3C2410_LCDCON1_TFT |
-			   S3C2410_LCDCON1_CLKVAL(0x01), /* HCLK/4 */
-
 		.lcdcon5 = S3C2410_LCDCON5_FRM565 |
 			   S3C2410_LCDCON5_INVVLINE |
 			   S3C2410_LCDCON5_INVVFRAME |
@@ -125,10 +121,6 @@ static struct s3c2410fb_display qt2410_l
 	},
 	{
 		/* Configuration for 480x640 toppoly TD028TTEC1 */
-		.lcdcon1 = S3C2410_LCDCON1_TFT16BPP |
-			   S3C2410_LCDCON1_TFT |
-			   S3C2410_LCDCON1_CLKVAL(0x01), /* HCLK/4 */
-
 		.lcdcon5 = S3C2410_LCDCON5_FRM565 |
 			   S3C2410_LCDCON5_INVVLINE |
 			   S3C2410_LCDCON5_INVVFRAME |
@@ -151,10 +143,6 @@ static struct s3c2410fb_display qt2410_l
 	},
 	{
 		/* Config for 240x320 LCD */
-		.lcdcon1 = S3C2410_LCDCON1_TFT16BPP |
-			   S3C2410_LCDCON1_TFT |
-			   S3C2410_LCDCON1_CLKVAL(0x04),
-
 		.lcdcon5 = S3C2410_LCDCON5_FRM565 |
 			   S3C2410_LCDCON5_INVVLINE |
 			   S3C2410_LCDCON5_INVVFRAME |
diff -puN arch/arm/mach-s3c2440/mach-rx3715.c~s3c2410fb-removes-lcdcon1-register-value-from-s3c2410fb_display arch/arm/mach-s3c2440/mach-rx3715.c
--- a/arch/arm/mach-s3c2440/mach-rx3715.c~s3c2410fb-removes-lcdcon1-register-value-from-s3c2410fb_display
+++ a/arch/arm/mach-s3c2440/mach-rx3715.c
@@ -111,10 +111,6 @@ static struct s3c2410_uartcfg rx3715_uar
 /* framebuffer lcd controller information */
 
 static struct s3c2410fb_display rx3715_lcdcfg __initdata = {
-	.lcdcon1 =	S3C2410_LCDCON1_TFT16BPP | \
-			S3C2410_LCDCON1_TFT | \
-			S3C2410_LCDCON1_CLKVAL(0x0C),
-
 	.lcdcon5 =	S3C2410_LCDCON5_INVVLINE |
 			S3C2410_LCDCON5_FRM565 |
 			S3C2410_LCDCON5_HWSWP,
diff -puN arch/arm/mach-s3c2440/mach-smdk2440.c~s3c2410fb-removes-lcdcon1-register-value-from-s3c2410fb_display arch/arm/mach-s3c2440/mach-smdk2440.c
--- a/arch/arm/mach-s3c2440/mach-smdk2440.c~s3c2410fb-removes-lcdcon1-register-value-from-s3c2410fb_display
+++ a/arch/arm/mach-s3c2440/mach-smdk2440.c
@@ -105,10 +105,6 @@ static struct s3c2410_uartcfg smdk2440_u
 
 static struct s3c2410fb_display smdk2440_lcd_cfg __initdata = {
 
-	.lcdcon1	= S3C2410_LCDCON1_TFT16BPP |
-			  S3C2410_LCDCON1_TFT |
-			  S3C2410_LCDCON1_CLKVAL(0x04),
-
 	.lcdcon5	= S3C2410_LCDCON5_FRM565 |
 			  S3C2410_LCDCON5_INVVLINE |
 			  S3C2410_LCDCON5_INVVFRAME |
diff -puN drivers/video/s3c2410fb.c~s3c2410fb-removes-lcdcon1-register-value-from-s3c2410fb_display drivers/video/s3c2410fb.c
--- a/drivers/video/s3c2410fb.c~s3c2410fb-removes-lcdcon1-register-value-from-s3c2410fb_display
+++ a/drivers/video/s3c2410fb.c
@@ -207,11 +207,9 @@ static int s3c2410fb_check_var(struct fb
 	var->vsync_len = display->vsync_len;
 	var->hsync_len = display->hsync_len;
 
-	fbi->regs.lcdcon1 = display->lcdcon1;
 	fbi->regs.lcdcon5 = display->lcdcon5;
 	/* set display type */
-	fbi->regs.lcdcon1 &= ~S3C2410_LCDCON1_TFT;
-	fbi->regs.lcdcon1 |= display->type;
+	fbi->regs.lcdcon1 = display->type;
 
 	var->transp.offset = 0;
 	var->transp.length = 0;
@@ -301,8 +299,6 @@ static void s3c2410fb_calculate_stn_lcd_
 	if (type != S3C2410_LCDCON1_STN4)
 		hs >>= 1;
 
-	regs->lcdcon1 &= ~S3C2410_LCDCON1_MODEMASK;
-
 	switch (var->bits_per_pixel) {
 	case 1:
 		regs->lcdcon1 |= S3C2410_LCDCON1_STN1BPP;
@@ -356,8 +352,6 @@ static void s3c2410fb_calculate_tft_lcd_
 	const struct s3c2410fb_info *fbi = info->par;
 	const struct fb_var_screeninfo *var = &info->var;
 
-	regs->lcdcon1 &= ~S3C2410_LCDCON1_MODEMASK;
-
 	switch (var->bits_per_pixel) {
 	case 1:
 		regs->lcdcon1 |= S3C2410_LCDCON1_TFT1BPP;
@@ -437,7 +431,6 @@ static void s3c2410fb_activate_var(struc
 			clkdiv = 2;
 	}
 
-	fbi->regs.lcdcon1 &= ~S3C2410_LCDCON1_CLKVAL(0x3ff);
 	fbi->regs.lcdcon1 |=  S3C2410_LCDCON1_CLKVAL(clkdiv);
 
 	/* write new registers */
diff -puN include/asm-arm/arch-s3c2410/fb.h~s3c2410fb-removes-lcdcon1-register-value-from-s3c2410fb_display include/asm-arm/arch-s3c2410/fb.h
--- a/include/asm-arm/arch-s3c2410/fb.h~s3c2410fb-removes-lcdcon1-register-value-from-s3c2410fb_display
+++ a/include/asm-arm/arch-s3c2410/fb.h
@@ -45,7 +45,6 @@ struct s3c2410fb_display {
 	unsigned short vsync_len;	/* value in lines (TFT) or 0 (STN) */
 
 	/* lcd configuration registers */
-	unsigned long	lcdcon1;
 	unsigned long	lcdcon5;
 };
 
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
git-alsa.patch
cyber2000fb-checkpatch-fixes.patch
