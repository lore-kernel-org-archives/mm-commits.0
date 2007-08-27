From: akpm@linux-foundation.org
Subject: + s3c2410fb-removes-lcdcon1-register-value-from-s3c2410fb_display.patch added to -mm tree
Date: Mon, 27 Aug 2007 15:23:32 -0700
Message-ID: <200708272223.l7RMNWIq031658@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54888 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757717AbXH0WXg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Aug 2007 18:23:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     s3c2410fb: removes lcdcon1 register value from s3c2410fb_display
has been added to the -mm tree.  Its filename is
     s3c2410fb-removes-lcdcon1-register-value-from-s3c2410fb_display.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -303,8 +301,6 @@ static void s3c2410fb_calculate_stn_lcd_
 	if (type != S3C2410_LCDCON1_STN4)
 		hs >>= 1;
 
-	regs->lcdcon1 &= ~S3C2410_LCDCON1_MODEMASK;
-
 	switch (var->bits_per_pixel) {
 	case 1:
 		regs->lcdcon1 |= S3C2410_LCDCON1_STN1BPP;
@@ -358,8 +354,6 @@ static void s3c2410fb_calculate_tft_lcd_
 	const struct s3c2410fb_info *fbi = info->par;
 	const struct fb_var_screeninfo *var = &info->var;
 
-	regs->lcdcon1 &= ~S3C2410_LCDCON1_MODEMASK;
-
 	switch (var->bits_per_pixel) {
 	case 1:
 		regs->lcdcon1 |= S3C2410_LCDCON1_TFT1BPP;
@@ -429,7 +423,6 @@ static void s3c2410fb_activate_var(struc
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
git-arm-master.patch
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
