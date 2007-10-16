From: akpm@linux-foundation.org
Subject: - s3c2410fb-add-margin-fields-to-s3c2410fb_display.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:43:11 -0700
Message-ID: <200710162043.l9GKhBZ1016021@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33776 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934453AbXJPVPe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:15:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     s3c2410fb: add margin fields to s3c2410fb_display
has been removed from the -mm tree.  Its filename was
     s3c2410fb-add-margin-fields-to-s3c2410fb_display.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: s3c2410fb: add margin fields to s3c2410fb_display
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch adds margins fields to the s3c2410fb_display
structure. It also sets display type and horizontal
margins in all platform files that use the s3c2410fb
driver.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-s3c2410/mach-amlm5900.c |    7 +++---
 arch/arm/mach-s3c2410/mach-bast.c     |   27 ++++++++++++++++++++++++
 arch/arm/mach-s3c2410/mach-h1940.c    |    3 ++
 arch/arm/mach-s3c2410/mach-qt2410.c   |    9 ++++++++
 arch/arm/mach-s3c2440/mach-rx3715.c   |   15 ++++++++-----
 arch/arm/mach-s3c2440/mach-smdk2440.c |    2 +
 include/asm-arm/arch-s3c2410/fb.h     |    7 ++++++
 7 files changed, 61 insertions(+), 9 deletions(-)

diff -puN arch/arm/mach-s3c2410/mach-amlm5900.c~s3c2410fb-add-margin-fields-to-s3c2410fb_display arch/arm/mach-s3c2410/mach-amlm5900.c
--- a/arch/arm/mach-s3c2410/mach-amlm5900.c~s3c2410fb-add-margin-fields-to-s3c2410fb_display
+++ a/arch/arm/mach-s3c2410/mach-amlm5900.c
@@ -172,12 +172,13 @@ static struct s3c2410fb_display __initda
 	.width		= 160,
 	.height		= 160,
 
-/* commented out until stn patch is submitted
-*	.type		= S3C2410_LCDCON1_STN4,
-*/
+	.type		= S3C2410_LCDCON1_STN4,
+
 	.xres		= 160,
 	.yres		= 160,
 	.bpp		= 4,
+	.left_margin	= 1 << (4 + 3),
+	.right_margin	= 8 << 3,
 
 	.regs		= {
 		.lcdcon1	= 0x00008225,
diff -puN arch/arm/mach-s3c2410/mach-bast.c~s3c2410fb-add-margin-fields-to-s3c2410fb_display arch/arm/mach-s3c2410/mach-bast.c
--- a/arch/arm/mach-s3c2410/mach-bast.c~s3c2410fb-add-margin-fields-to-s3c2410fb_display
+++ a/arch/arm/mach-s3c2410/mach-bast.c
@@ -469,10 +469,13 @@ static struct platform_device bast_devic
 
 static struct s3c2410fb_display __initdata bast_lcd_info[] = {
 	{
+		.type		= S3C2410_LCDCON1_TFT,
 		.width		= 640,
 		.height		= 480,
 		.xres		= 320,
 		.yres		= 240,
+		.left_margin	= 40,
+		.right_margin	= 20,
 
 		.bpp		= 4,
 
@@ -485,12 +488,15 @@ static struct s3c2410fb_display __initda
 		}
 	},
 	{
+		.type		= S3C2410_LCDCON1_TFT,
 		.width		= 640,
 		.height		= 480,
 
 		.xres		= 640,
 		.yres		= 480,
 		.bpp		= 4,
+		.left_margin	= 40,
+		.right_margin	= 20,
 
 		.regs		= {
 			.lcdcon1	= 0x00000176,
@@ -501,12 +507,15 @@ static struct s3c2410fb_display __initda
 		}
 	},
 	{
+		.type		= S3C2410_LCDCON1_TFT,
 		.width		= 640,
 		.height		= 480,
 
 		.xres		= 800,
 		.yres		= 600,
 		.bpp		= 4,
+		.left_margin	= 40,
+		.right_margin	= 20,
 
 		.regs		= {
 			.lcdcon1	= 0x00000176,
@@ -517,12 +526,15 @@ static struct s3c2410fb_display __initda
 		}
 	},
 	{
+		.type		= S3C2410_LCDCON1_TFT,
 		.width		= 640,
 		.height		= 480,
 
 		.xres		= 320,
 		.yres		= 240,
 		.bpp		= 8,
+		.left_margin	= 40,
+		.right_margin	= 20,
 
 		.regs		= {
 			.lcdcon1	= 0x00000176,
@@ -533,12 +545,15 @@ static struct s3c2410fb_display __initda
 		}
 	},
 	{
+		.type		= S3C2410_LCDCON1_TFT,
 		.width		= 640,
 		.height		= 480,
 
 		.xres		= 640,
 		.yres		= 480,
 		.bpp		= 8,
+		.left_margin	= 40,
+		.right_margin	= 20,
 
 		.regs		= {
 			.lcdcon1	= 0x00000176,
@@ -549,12 +564,15 @@ static struct s3c2410fb_display __initda
 		}
 	},
 	{
+		.type		= S3C2410_LCDCON1_TFT,
 		.width		= 640,
 		.height		= 480,
 
 		.xres		= 800,
 		.yres		= 600,
 		.bpp		= 8,
+		.left_margin	= 40,
+		.right_margin	= 20,
 
 		.regs		= {
 			.lcdcon1	= 0x00000176,
@@ -565,12 +583,15 @@ static struct s3c2410fb_display __initda
 		}
 	},
 	{
+		.type		= S3C2410_LCDCON1_TFT,
 		.width		= 640,
 		.height		= 480,
 
 		.xres		= 320,
 		.yres		= 240,
 		.bpp		= 16,
+		.left_margin	= 40,
+		.right_margin	= 20,
 
 		.regs		= {
 			.lcdcon1	= 0x00000176,
@@ -581,12 +602,15 @@ static struct s3c2410fb_display __initda
 		}
 	},
 	{
+		.type		= S3C2410_LCDCON1_TFT,
 		.width		= 640,
 		.height		= 480,
 
 		.xres		= 640,
 		.yres		= 480,
 		.bpp		= 16,
+		.left_margin	= 40,
+		.right_margin	= 20,
 
 		.regs		= {
 			.lcdcon1	= 0x00000176,
@@ -597,12 +621,15 @@ static struct s3c2410fb_display __initda
 		}
 	},
 	{
+		.type		= S3C2410_LCDCON1_TFT,
 		.width		= 640,
 		.height		= 480,
 
 		.xres		= 800,
 		.yres		= 600,
 		.bpp		= 16,
+		.left_margin	= 40,
+		.right_margin	= 20,
 
 		.regs		= {
 			.lcdcon1	= 0x00000176,
diff -puN arch/arm/mach-s3c2410/mach-h1940.c~s3c2410fb-add-margin-fields-to-s3c2410fb_display arch/arm/mach-s3c2410/mach-h1940.c
--- a/arch/arm/mach-s3c2410/mach-h1940.c~s3c2410fb-add-margin-fields-to-s3c2410fb_display
+++ a/arch/arm/mach-s3c2410/mach-h1940.c
@@ -156,11 +156,14 @@ static struct s3c2410fb_display h1940_lc
 				S3C2410_LCDCON5_HWSWP,
 	},
 
+	.type =		S3C2410_LCDCON1_TFT,
 	.width =	240,
 	.height =	320,
 	.xres =		240,
 	.yres =		320,
 	.bpp =		16,
+	.left_margin =	20,
+	.right_margin =	8,
 };
 
 static struct s3c2410fb_mach_info h1940_fb_info __initdata = {
diff -puN arch/arm/mach-s3c2410/mach-qt2410.c~s3c2410fb-add-margin-fields-to-s3c2410fb_display arch/arm/mach-s3c2410/mach-qt2410.c
--- a/arch/arm/mach-s3c2410/mach-qt2410.c~s3c2410fb-add-margin-fields-to-s3c2410fb_display
+++ a/arch/arm/mach-s3c2410/mach-qt2410.c
@@ -123,12 +123,15 @@ static struct s3c2410fb_display qt2410_l
 				   S3C2410_LCDCON5_HWSWP,
 		},
 
+		.type		= S3C2410_LCDCON1_TFT,
 		.width		= 640,
 		.height		= 480,
 
 		.xres		= 640,
 		.yres		= 480,
 		.bpp		= 16,
+		.left_margin	= 44,
+		.right_margin	= 116,
 	},
 	{
 		/* Configuration for 480x640 toppoly TD028TTEC1 */
@@ -157,11 +160,14 @@ static struct s3c2410fb_display qt2410_l
 				   S3C2410_LCDCON5_HWSWP,
 		},
 
+		.type		= S3C2410_LCDCON1_TFT,
 		.width		= 480,
 		.height		= 640,
 		.xres		= 480,
 		.yres		= 640,
 		.bpp		= 16,
+		.left_margin	= 8,
+		.right_margin	= 24,
 	},
 	{
 		/* Config for 240x320 LCD */
@@ -190,11 +196,14 @@ static struct s3c2410fb_display qt2410_l
 				   S3C2410_LCDCON5_HWSWP,
 		},
 
+		.type		= S3C2410_LCDCON1_TFT,
 		.width		= 240,
 		.height		= 320,
 		.xres		= 240,
 		.yres		= 320,
 		.bpp		= 16,
+		.left_margin	= 13,
+		.right_margin	= 8,
 	},
 };
 
diff -puN arch/arm/mach-s3c2440/mach-rx3715.c~s3c2410fb-add-margin-fields-to-s3c2410fb_display arch/arm/mach-s3c2440/mach-rx3715.c
--- a/arch/arm/mach-s3c2440/mach-rx3715.c~s3c2410fb-add-margin-fields-to-s3c2410fb_display
+++ a/arch/arm/mach-s3c2440/mach-rx3715.c
@@ -133,12 +133,15 @@ static struct s3c2410fb_display rx3715_l
 				S3C2410_LCDCON5_HWSWP,
 	},
 
-	.width  =	240,
-	.height =	320,
-
-	.xres	= 240,
-	.yres	= 320,
-	.bpp	= 16,
+	.type		= S3C2410_LCDCON1_TFT,
+	.width		= 240,
+	.height		= 320,
+
+	.xres		= 240,
+	.yres		= 320,
+	.bpp		= 16,
+	.left_margin	= 36,
+	.right_margin	= 36,
 };
 
 static struct s3c2410fb_mach_info rx3715_fb_info __initdata = {
diff -puN arch/arm/mach-s3c2440/mach-smdk2440.c~s3c2410fb-add-margin-fields-to-s3c2410fb_display arch/arm/mach-s3c2440/mach-smdk2440.c
--- a/arch/arm/mach-s3c2440/mach-smdk2440.c~s3c2410fb-add-margin-fields-to-s3c2410fb_display
+++ a/arch/arm/mach-s3c2440/mach-smdk2440.c
@@ -137,6 +137,8 @@ static struct s3c2410fb_display smdk2440
 	.xres		= 240,
 	.yres		= 320,
 	.bpp		= 16,
+	.left_margin	= 20,
+	.right_margin	= 8,
 };
 
 static struct s3c2410fb_mach_info smdk2440_fb_info __initdata = {
diff -puN include/asm-arm/arch-s3c2410/fb.h~s3c2410fb-add-margin-fields-to-s3c2410fb_display include/asm-arm/arch-s3c2410/fb.h
--- a/include/asm-arm/arch-s3c2410/fb.h~s3c2410fb-add-margin-fields-to-s3c2410fb_display
+++ a/include/asm-arm/arch-s3c2410/fb.h
@@ -36,6 +36,13 @@ struct s3c2410fb_display {
 	unsigned short yres;
 	unsigned short bpp;
 
+	unsigned short left_margin;  /* value in pixels (TFT) or HCLKs (STN) */
+	unsigned short right_margin; /* value in pixels (TFT) or HCLKs (STN) */
+	unsigned short hsync_len;    /* value in pixels (TFT) or HCLKs (STN) */
+	unsigned short upper_margin;	/* value in lines (TFT) or 0 (STN) */
+	unsigned short lower_margin;	/* value in lines (TFT) or 0 (STN) */
+	unsigned short vsync_len;	/* value in lines (TFT) or 0 (STN) */
+
 	/* lcd configuration registers */
 	struct s3c2410fb_hw  regs;
 };
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
git-alsa.patch
cyber2000fb-checkpatch-fixes.patch
