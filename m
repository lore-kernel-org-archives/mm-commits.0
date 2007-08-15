From: akpm@linux-foundation.org
Subject: + s3c2410fb-multi-display-support.patch added to -mm tree
Date: Wed, 15 Aug 2007 16:21:04 -0700
Message-ID: <200708152321.l7FNL4lK020325@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37136 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934692AbXHOXVv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 19:21:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     s3c2410fb: multi-display support
has been added to the -mm tree.  Its filename is
     s3c2410fb-multi-display-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: s3c2410fb: multi-display support
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch adds a new structure to describe and handle
more than one panel (display mode) for the s3c2410 framebuffer.
This structure is added after the pxafb driver.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-s3c2410/mach-amlm5900.c |   49 +---
 arch/arm/mach-s3c2410/mach-bast.c     |  185 ++++++++++++++--
 arch/arm/mach-s3c2410/mach-h1940.c    |   26 +-
 arch/arm/mach-s3c2410/mach-qt2410.c   |  264 ++++++++++--------------
 arch/arm/mach-s3c2440/mach-rx3715.c   |   38 +--
 arch/arm/mach-s3c2440/mach-smdk2440.c |   41 +--
 drivers/video/s3c2410fb.c             |   85 ++++---
 drivers/video/s3c2410fb.h             |    2 
 include/asm-arm/arch-s3c2410/fb.h     |   33 +--
 9 files changed, 407 insertions(+), 316 deletions(-)

diff -puN arch/arm/mach-s3c2410/mach-amlm5900.c~s3c2410fb-multi-display-support arch/arm/mach-s3c2410/mach-amlm5900.c
--- a/arch/arm/mach-s3c2410/mach-amlm5900.c~s3c2410fb-multi-display-support
+++ a/arch/arm/mach-s3c2410/mach-amlm5900.c
@@ -168,13 +168,32 @@ static void __init amlm5900_map_io(void)
 }
 
 #ifdef CONFIG_FB_S3C2410
-static struct s3c2410fb_mach_info __initdata amlm5900_lcd_info = {
+static struct s3c2410fb_display __initdata amlm5900_lcd_info = {
 	.width		= 160,
 	.height		= 160,
 
 /* commented out until stn patch is submitted
 *	.type		= S3C2410_LCDCON1_STN4,
 */
+	.xres		= 160,
+	.yres		= 160,
+	.bpp		= 4,
+
+	.regs		= {
+		.lcdcon1	= 0x00008225,
+		.lcdcon2	= 0x0027c000,
+		.lcdcon3	= 0x00182708,
+		.lcdcon4	= 0x00000002,
+		.lcdcon5	= 0x00000001,
+	}
+};
+
+static struct s3c2410fb_mach_info __initdata amlm5900_fb_info = {
+
+	.displays = &amlm5900_lcd_info,
+	.num_displays = 1,
+	.default_display = 0,
+
 	.gpccon =	0xaaaaaaaa,
 	.gpccon_mask =	0xffffffff,
 	.gpcup =	0x0000ffff,
@@ -184,32 +203,6 @@ static struct s3c2410fb_mach_info __init
 	.gpdcon_mask =	0xffffffff,
 	.gpdup =	0x0000ffff,
 	.gpdup_mask =	0xffffffff,
-
-	.xres		= {
-		.min		= 160,
-		.max		= 160,
-		.defval		= 160,
-	},
-
-	.yres		= {
-		.min		= 160,
-		.max	        = 160,
-		.defval		= 160,
-	},
-
-	.bpp		= {
-		.min		= 4,
-		.max		= 4,
-		.defval		= 4,
-	},
-
-	.regs		= {
-		.lcdcon1	= 0x00008225,
-		.lcdcon2	= 0x0027c000,
-		.lcdcon3	= 0x00182708,
-		.lcdcon4	= 0x00000002,
-		.lcdcon5	= 0x00000001,
-	}
 };
 #endif
 
@@ -239,7 +232,7 @@ static void __init amlm5900_init(void)
 {
 	amlm5900_init_pm();
 #ifdef CONFIG_FB_S3C2410
-	s3c24xx_fb_set_platdata(&amlm5900_lcd_info);
+	s3c24xx_fb_set_platdata(&amlm5900_fb_info);
 #endif
 	platform_add_devices(amlm5900_devices, ARRAY_SIZE(amlm5900_devices));
 }
diff -puN arch/arm/mach-s3c2410/mach-bast.c~s3c2410fb-multi-display-support arch/arm/mach-s3c2410/mach-bast.c
--- a/arch/arm/mach-s3c2410/mach-bast.c~s3c2410fb-multi-display-support
+++ a/arch/arm/mach-s3c2410/mach-bast.c
@@ -467,35 +467,160 @@ static struct platform_device bast_devic
 
 /* LCD/VGA controller */
 
-static struct s3c2410fb_mach_info __initdata bast_lcd_info = {
-	.width		= 640,
-	.height		= 480,
-
-	.xres		= {
-		.min		= 320,
-		.max		= 1024,
-		.defval		= 640,
-	},
-
-	.yres		= {
-		.min		= 240,
-		.max	        = 600,
-		.defval		= 480,
-	},
-
-	.bpp		= {
-		.min		= 4,
-		.max		= 16,
-		.defval		= 8,
-	},
-
-	.regs		= {
-		.lcdcon1	= 0x00000176,
-		.lcdcon2	= 0x1d77c7c2,
-		.lcdcon3	= 0x013a7f13,
-		.lcdcon4	= 0x00000057,
-		.lcdcon5	= 0x00014b02,
-	}
+static struct s3c2410fb_display __initdata bast_lcd_info[] = {
+	{
+		.width		= 640,
+		.height		= 480,
+		.xres		= 320,
+		.yres		= 240,
+
+		.bpp		= 4,
+
+		.regs		= {
+			.lcdcon1	= 0x00000176,
+			.lcdcon2	= 0x1d77c7c2,
+			.lcdcon3	= 0x013a7f13,
+			.lcdcon4	= 0x00000057,
+			.lcdcon5	= 0x00014b02,
+		}
+	},
+	{
+		.width		= 640,
+		.height		= 480,
+
+		.xres		= 640,
+		.yres		= 480,
+		.bpp		= 4,
+
+		.regs		= {
+			.lcdcon1	= 0x00000176,
+			.lcdcon2	= 0x1d77c7c2,
+			.lcdcon3	= 0x013a7f13,
+			.lcdcon4	= 0x00000057,
+			.lcdcon5	= 0x00014b02,
+		}
+	},
+	{
+		.width		= 640,
+		.height		= 480,
+
+		.xres		= 800,
+		.yres		= 600,
+		.bpp		= 4,
+
+		.regs		= {
+			.lcdcon1	= 0x00000176,
+			.lcdcon2	= 0x1d77c7c2,
+			.lcdcon3	= 0x013a7f13,
+			.lcdcon4	= 0x00000057,
+			.lcdcon5	= 0x00014b02,
+		}
+	},
+	{
+		.width		= 640,
+		.height		= 480,
+
+		.xres		= 320,
+		.yres		= 240,
+		.bpp		= 8,
+
+		.regs		= {
+			.lcdcon1	= 0x00000176,
+			.lcdcon2	= 0x1d77c7c2,
+			.lcdcon3	= 0x013a7f13,
+			.lcdcon4	= 0x00000057,
+			.lcdcon5	= 0x00014b02,
+		}
+	},
+	{
+		.width		= 640,
+		.height		= 480,
+
+		.xres		= 640,
+		.yres		= 480,
+		.bpp		= 8,
+
+		.regs		= {
+			.lcdcon1	= 0x00000176,
+			.lcdcon2	= 0x1d77c7c2,
+			.lcdcon3	= 0x013a7f13,
+			.lcdcon4	= 0x00000057,
+			.lcdcon5	= 0x00014b02,
+		}
+	},
+	{
+		.width		= 640,
+		.height		= 480,
+
+		.xres		= 800,
+		.yres		= 600,
+		.bpp		= 8,
+
+		.regs		= {
+			.lcdcon1	= 0x00000176,
+			.lcdcon2	= 0x1d77c7c2,
+			.lcdcon3	= 0x013a7f13,
+			.lcdcon4	= 0x00000057,
+			.lcdcon5	= 0x00014b02,
+		}
+	},
+	{
+		.width		= 640,
+		.height		= 480,
+
+		.xres		= 320,
+		.yres		= 240,
+		.bpp		= 16,
+
+		.regs		= {
+			.lcdcon1	= 0x00000176,
+			.lcdcon2	= 0x1d77c7c2,
+			.lcdcon3	= 0x013a7f13,
+			.lcdcon4	= 0x00000057,
+			.lcdcon5	= 0x00014b02,
+		}
+	},
+	{
+		.width		= 640,
+		.height		= 480,
+
+		.xres		= 640,
+		.yres		= 480,
+		.bpp		= 16,
+
+		.regs		= {
+			.lcdcon1	= 0x00000176,
+			.lcdcon2	= 0x1d77c7c2,
+			.lcdcon3	= 0x013a7f13,
+			.lcdcon4	= 0x00000057,
+			.lcdcon5	= 0x00014b02,
+		}
+	},
+	{
+		.width		= 640,
+		.height		= 480,
+
+		.xres		= 800,
+		.yres		= 600,
+		.bpp		= 16,
+
+		.regs		= {
+			.lcdcon1	= 0x00000176,
+			.lcdcon2	= 0x1d77c7c2,
+			.lcdcon3	= 0x013a7f13,
+			.lcdcon4	= 0x00000057,
+			.lcdcon5	= 0x00014b02,
+		}
+	},
+};
+
+/* LCD/VGA controller */
+
+static struct s3c2410fb_mach_info __initdata bast_fb_info = {
+
+	.displays = bast_lcd_info,
+	.num_displays = ARRAY_SIZE(bast_lcd_info),
+	.default_display = 4,
 };
 
 /* Standard BAST devices */
@@ -552,7 +677,7 @@ static void __init bast_map_io(void)
 
 static void __init bast_init(void)
 {
-	s3c24xx_fb_set_platdata(&bast_lcd_info);
+	s3c24xx_fb_set_platdata(&bast_fb_info);
 	platform_add_devices(bast_devices, ARRAY_SIZE(bast_devices));
 }
 
diff -puN arch/arm/mach-s3c2410/mach-h1940.c~s3c2410fb-multi-display-support arch/arm/mach-s3c2410/mach-h1940.c
--- a/arch/arm/mach-s3c2410/mach-h1940.c~s3c2410fb-multi-display-support
+++ a/arch/arm/mach-s3c2410/mach-h1940.c
@@ -133,8 +133,7 @@ static struct s3c2410_udc_mach_info h194
 /**
  * Set lcd on or off
  **/
-static struct s3c2410fb_mach_info h1940_lcdcfg __initdata = {
-	.fixed_syncs=		1,
+static struct s3c2410fb_display h1940_lcd __initdata = {
 	.regs={
 		.lcdcon1=	S3C2410_LCDCON1_TFT16BPP | \
 				S3C2410_LCDCON1_TFT | \
@@ -156,6 +155,21 @@ static struct s3c2410fb_mach_info h1940_
 				S3C2410_LCDCON5_INVVLINE | \
 				S3C2410_LCDCON5_HWSWP,
 	},
+
+	.width =	240,
+	.height =	320,
+	.xres =		240,
+	.yres =		320,
+	.bpp =		16,
+};
+
+static struct s3c2410fb_mach_info h1940_fb_info __initdata = {
+	.fixed_syncs =		1,
+
+	.displays = &h1940_lcd,
+	.num_displays = 1,
+	.default_display = 0,
+
 	.lpcsel=	0x02,
 	.gpccon=	0xaa940659,
 	.gpccon_mask=	0xffffffff,
@@ -165,12 +179,6 @@ static struct s3c2410fb_mach_info h1940_
 	.gpdcon_mask=	0xffffffff,
 	.gpdup=		0x0000faff,
 	.gpdup_mask=	0xffffffff,
-
-	.width=		240,
-	.height=	320,
-	.xres=		{240,240,240},
-	.yres=		{320,320,320},
-	.bpp=		{16,16,16},
 };
 
 static struct platform_device s3c_device_leds = {
@@ -217,7 +225,7 @@ static void __init h1940_init(void)
 {
 	u32 tmp;
 
-	s3c24xx_fb_set_platdata(&h1940_lcdcfg);
+	s3c24xx_fb_set_platdata(&h1940_fb_info);
  	s3c24xx_udc_set_platdata(&h1940_udc_cfg);
 
 	/* Turn off suspend on both USB ports, and switch the
diff -puN arch/arm/mach-s3c2410/mach-qt2410.c~s3c2410fb-multi-display-support arch/arm/mach-s3c2410/mach-qt2410.c
--- a/arch/arm/mach-s3c2410/mach-qt2410.c~s3c2410fb-multi-display-support
+++ a/arch/arm/mach-s3c2410/mach-qt2410.c
@@ -95,157 +95,116 @@ static struct s3c2410_uartcfg smdk2410_u
 
 /* LCD driver info */
 
-/* Configuration for 640x480 SHARP LQ080V3DG01 */
-static struct s3c2410fb_mach_info qt2410_biglcd_cfg __initdata = {
-	.regs	= {
-
-		.lcdcon1	= S3C2410_LCDCON1_TFT16BPP |
-				  S3C2410_LCDCON1_TFT |
-				  S3C2410_LCDCON1_CLKVAL(0x01),	/* HCLK/4 */
-
-		.lcdcon2	= S3C2410_LCDCON2_VBPD(18) |	/* 19 */
-				  S3C2410_LCDCON2_LINEVAL(479) |
-				  S3C2410_LCDCON2_VFPD(10) |	/* 11 */
-				  S3C2410_LCDCON2_VSPW(14),	/* 15 */
-
-		.lcdcon3	= S3C2410_LCDCON3_HBPD(43) |	/* 44 */
-				  S3C2410_LCDCON3_HOZVAL(639) |	/* 640 */
-				  S3C2410_LCDCON3_HFPD(115),	/* 116 */
-
-		.lcdcon4	= S3C2410_LCDCON4_MVAL(0) |
-				  S3C2410_LCDCON4_HSPW(95),	/* 96 */
-
-		.lcdcon5	= S3C2410_LCDCON5_FRM565 |
-				  S3C2410_LCDCON5_INVVLINE |
-				  S3C2410_LCDCON5_INVVFRAME |
-				  S3C2410_LCDCON5_PWREN |
-				  S3C2410_LCDCON5_HWSWP,
-	},
-
-	.lpcsel		= ((0xCE6) & ~7) | 1<<4,
-
-	.width		= 640,
-	.height		= 480,
-
-	.xres		= {
-		.min	= 640,
-		.max	= 640,
-		.defval	= 640,
-	},
-
-	.yres		= {
-		.min	= 480,
-		.max	= 480,
-		.defval = 480,
-	},
-
-	.bpp		= {
-		.min	= 16,
-		.max	= 16,
-		.defval = 16,
-	},
-};
-
-/* Configuration for 480x640 toppoly TD028TTEC1 */
-static struct s3c2410fb_mach_info qt2410_prodlcd_cfg __initdata = {
-	.regs	= {
-
-		.lcdcon1	= S3C2410_LCDCON1_TFT16BPP |
-				  S3C2410_LCDCON1_TFT |
-				  S3C2410_LCDCON1_CLKVAL(0x01),	/* HCLK/4 */
-
-		.lcdcon2	= S3C2410_LCDCON2_VBPD(1) |	/* 2 */
-				  S3C2410_LCDCON2_LINEVAL(639) |/* 640 */
-				  S3C2410_LCDCON2_VFPD(3) |	/* 4 */
-				  S3C2410_LCDCON2_VSPW(1),	/* 2 */
-
-		.lcdcon3	= S3C2410_LCDCON3_HBPD(7) |	/* 8 */
-				  S3C2410_LCDCON3_HOZVAL(479) |	/* 479 */
-				  S3C2410_LCDCON3_HFPD(23),	/* 24 */
-
-		.lcdcon4	= S3C2410_LCDCON4_MVAL(0) |
-				  S3C2410_LCDCON4_HSPW(7),	/* 8 */
-
-		.lcdcon5	= S3C2410_LCDCON5_FRM565 |
-				  S3C2410_LCDCON5_INVVLINE |
-				  S3C2410_LCDCON5_INVVFRAME |
-				  S3C2410_LCDCON5_PWREN |
-				  S3C2410_LCDCON5_HWSWP,
-	},
-
-	.lpcsel		= ((0xCE6) & ~7) | 1<<4,
-
-	.width		= 480,
-	.height		= 640,
-
-	.xres		= {
-		.min	= 480,
-		.max	= 480,
-		.defval	= 480,
-	},
-
-	.yres		= {
-		.min	= 640,
-		.max	= 640,
-		.defval = 640,
-	},
-
-	.bpp		= {
-		.min	= 16,
-		.max	= 16,
-		.defval = 16,
-	},
-};
-
-/* Config for 240x320 LCD */
-static struct s3c2410fb_mach_info qt2410_lcd_cfg __initdata = {
-	.regs	= {
-
-		.lcdcon1	= S3C2410_LCDCON1_TFT16BPP |
-				  S3C2410_LCDCON1_TFT |
-				  S3C2410_LCDCON1_CLKVAL(0x04),
-
-		.lcdcon2	= S3C2410_LCDCON2_VBPD(1) |
-				  S3C2410_LCDCON2_LINEVAL(319) |
-				  S3C2410_LCDCON2_VFPD(6) |
-				  S3C2410_LCDCON2_VSPW(3),
-
-		.lcdcon3	= S3C2410_LCDCON3_HBPD(12) |
-				  S3C2410_LCDCON3_HOZVAL(239) |
-				  S3C2410_LCDCON3_HFPD(7),
-
-		.lcdcon4	= S3C2410_LCDCON4_MVAL(0) |
-				  S3C2410_LCDCON4_HSPW(3),
-
-		.lcdcon5	= S3C2410_LCDCON5_FRM565 |
-				  S3C2410_LCDCON5_INVVLINE |
-				  S3C2410_LCDCON5_INVVFRAME |
-				  S3C2410_LCDCON5_PWREN |
-				  S3C2410_LCDCON5_HWSWP,
-	},
+static struct s3c2410fb_display qt2410_lcd_cfg[] __initdata = {
+	{
+		/* Configuration for 640x480 SHARP LQ080V3DG01 */
+		.regs	= {
+
+			.lcdcon1 = S3C2410_LCDCON1_TFT16BPP |
+				   S3C2410_LCDCON1_TFT |
+				   S3C2410_LCDCON1_CLKVAL(0x01), /* HCLK/4 */
+
+			.lcdcon2 = S3C2410_LCDCON2_VBPD(18) |	/* 19 */
+				   S3C2410_LCDCON2_LINEVAL(479) |
+				   S3C2410_LCDCON2_VFPD(10) |	/* 11 */
+				   S3C2410_LCDCON2_VSPW(14),	/* 15 */
+
+			.lcdcon3 = S3C2410_LCDCON3_HBPD(43) |	/* 44 */
+				   S3C2410_LCDCON3_HOZVAL(639) | /* 640 */
+				   S3C2410_LCDCON3_HFPD(115),	/* 116 */
+
+			.lcdcon4 = S3C2410_LCDCON4_MVAL(0) |
+				   S3C2410_LCDCON4_HSPW(95),	/* 96 */
+
+			.lcdcon5 = S3C2410_LCDCON5_FRM565 |
+				   S3C2410_LCDCON5_INVVLINE |
+				   S3C2410_LCDCON5_INVVFRAME |
+				   S3C2410_LCDCON5_PWREN |
+				   S3C2410_LCDCON5_HWSWP,
+		},
+
+		.width		= 640,
+		.height		= 480,
+
+		.xres		= 640,
+		.yres		= 480,
+		.bpp		= 16,
+	},
+	{
+		/* Configuration for 480x640 toppoly TD028TTEC1 */
+		.regs	= {
+
+			.lcdcon1 = S3C2410_LCDCON1_TFT16BPP |
+				   S3C2410_LCDCON1_TFT |
+				   S3C2410_LCDCON1_CLKVAL(0x01), /* HCLK/4 */
+
+			.lcdcon2 = S3C2410_LCDCON2_VBPD(1) |	/* 2 */
+				   S3C2410_LCDCON2_LINEVAL(639) |/* 640 */
+				   S3C2410_LCDCON2_VFPD(3) |	/* 4 */
+				   S3C2410_LCDCON2_VSPW(1),	/* 2 */
+
+			.lcdcon3 = S3C2410_LCDCON3_HBPD(7) |	/* 8 */
+				   S3C2410_LCDCON3_HOZVAL(479) | /* 479 */
+				   S3C2410_LCDCON3_HFPD(23),	/* 24 */
+
+			.lcdcon4 = S3C2410_LCDCON4_MVAL(0) |
+				   S3C2410_LCDCON4_HSPW(7),	/* 8 */
+
+			.lcdcon5 = S3C2410_LCDCON5_FRM565 |
+				   S3C2410_LCDCON5_INVVLINE |
+				   S3C2410_LCDCON5_INVVFRAME |
+				   S3C2410_LCDCON5_PWREN |
+				   S3C2410_LCDCON5_HWSWP,
+		},
+
+		.width		= 480,
+		.height		= 640,
+		.xres		= 480,
+		.yres		= 640,
+		.bpp		= 16,
+	},
+	{
+		/* Config for 240x320 LCD */
+		.regs	= {
+
+			.lcdcon1 = S3C2410_LCDCON1_TFT16BPP |
+				   S3C2410_LCDCON1_TFT |
+				   S3C2410_LCDCON1_CLKVAL(0x04),
+
+			.lcdcon2 = S3C2410_LCDCON2_VBPD(1) |
+				   S3C2410_LCDCON2_LINEVAL(319) |
+				   S3C2410_LCDCON2_VFPD(6) |
+				   S3C2410_LCDCON2_VSPW(3),
+
+			.lcdcon3 = S3C2410_LCDCON3_HBPD(12) |
+				   S3C2410_LCDCON3_HOZVAL(239) |
+				   S3C2410_LCDCON3_HFPD(7),
+
+			.lcdcon4 = S3C2410_LCDCON4_MVAL(0) |
+				   S3C2410_LCDCON4_HSPW(3),
+
+			.lcdcon5 = S3C2410_LCDCON5_FRM565 |
+				   S3C2410_LCDCON5_INVVLINE |
+				   S3C2410_LCDCON5_INVVFRAME |
+				   S3C2410_LCDCON5_PWREN |
+				   S3C2410_LCDCON5_HWSWP,
+		},
+
+		.width		= 240,
+		.height		= 320,
+		.xres		= 240,
+		.yres		= 320,
+		.bpp		= 16,
+	},
+};
+
+
+static struct s3c2410fb_mach_info qt2410_fb_info __initdata = {
+	.displays 	= qt2410_lcd_cfg,
+	.num_displays 	= ARRAY_SIZE(qt2410_lcd_cfg),
+	.default_display = 0,
 
 	.lpcsel		= ((0xCE6) & ~7) | 1<<4,
-
-	.width		= 240,
-	.height		= 320,
-
-	.xres		= {
-		.min	= 240,
-		.max	= 240,
-		.defval	= 240,
-	},
-
-	.yres		= {
-		.min	= 320,
-		.max	= 320,
-		.defval = 320,
-	},
-
-	.bpp		= {
-		.min	= 16,
-		.max	= 16,
-		.defval = 16,
-	},
 };
 
 /* CS8900 */
@@ -408,16 +367,17 @@ static void __init qt2410_machine_init(v
 
 	switch (tft_type) {
 	case 'p': /* production */
-		s3c24xx_fb_set_platdata(&qt2410_prodlcd_cfg);
+		qt2410_fb_info.default_display = 1;
 		break;
 	case 'b': /* big */
-		s3c24xx_fb_set_platdata(&qt2410_biglcd_cfg);
+		qt2410_fb_info.default_display = 0;
 		break;
 	case 's': /* small */
 	default:
-		s3c24xx_fb_set_platdata(&qt2410_lcd_cfg);
+		qt2410_fb_info.default_display = 2;
 		break;
 	}
+	s3c24xx_fb_set_platdata(&qt2410_fb_info);
 
 	s3c2410_gpio_cfgpin(S3C2410_GPB0, S3C2410_GPIO_OUTPUT);
 	s3c2410_gpio_setpin(S3C2410_GPB0, 1);
diff -puN arch/arm/mach-s3c2440/mach-rx3715.c~s3c2410fb-multi-display-support arch/arm/mach-s3c2440/mach-rx3715.c
--- a/arch/arm/mach-s3c2440/mach-rx3715.c~s3c2410fb-multi-display-support
+++ a/arch/arm/mach-s3c2440/mach-rx3715.c
@@ -110,7 +110,7 @@ static struct s3c2410_uartcfg rx3715_uar
 
 /* framebuffer lcd controller information */
 
-static struct s3c2410fb_mach_info rx3715_lcdcfg __initdata = {
+static struct s3c2410fb_display rx3715_lcdcfg __initdata = {
 	.regs	= {
 		.lcdcon1 =	S3C2410_LCDCON1_TFT16BPP | \
 				S3C2410_LCDCON1_TFT | \
@@ -133,6 +133,20 @@ static struct s3c2410fb_mach_info rx3715
 				S3C2410_LCDCON5_HWSWP,
 	},
 
+	.width  =	240,
+	.height =	320,
+
+	.xres	= 240,
+	.yres	= 320,
+	.bpp	= 16,
+};
+
+static struct s3c2410fb_mach_info rx3715_fb_info __initdata = {
+
+	.displays =	&rx3715_lcdcfg,
+	.num_displays =	1,
+	.default_display = 0,
+
 	.lpcsel =	0xf82,
 
 	.gpccon =	0xaa955699,
@@ -146,26 +160,6 @@ static struct s3c2410fb_mach_info rx3715
 	.gpdup_mask =	0xffffffff,
 
 	.fixed_syncs =	1,
-	.width  =	240,
-	.height =	320,
-
-	.xres	= {
-		.min =		240,
-		.max =		240,
-		.defval =	240,
-	},
-
-	.yres	= {
-		.max =		320,
-		.min =		320,
-		.defval	=	320,
-	},
-
-	.bpp	= {
-		.min =		16,
-		.max =		16,
-		.defval =	16,
-	},
 };
 
 static struct mtd_partition rx3715_nand_part[] = {
@@ -224,7 +218,7 @@ static void __init rx3715_init_machine(v
 #endif
 	s3c2410_pm_init();
 
-	s3c24xx_fb_set_platdata(&rx3715_lcdcfg);
+	s3c24xx_fb_set_platdata(&rx3715_fb_info);
 	platform_add_devices(rx3715_devices, ARRAY_SIZE(rx3715_devices));
 }
 
diff -puN arch/arm/mach-s3c2440/mach-smdk2440.c~s3c2410fb-multi-display-support arch/arm/mach-s3c2440/mach-smdk2440.c
--- a/arch/arm/mach-s3c2440/mach-smdk2440.c~s3c2410fb-multi-display-support
+++ a/arch/arm/mach-s3c2440/mach-smdk2440.c
@@ -103,7 +103,7 @@ static struct s3c2410_uartcfg smdk2440_u
 
 /* LCD driver info */
 
-static struct s3c2410fb_mach_info smdk2440_lcd_cfg __initdata = {
+static struct s3c2410fb_display smdk2440_lcd_cfg __initdata = {
 	.regs	= {
 
 		.lcdcon1	= S3C2410_LCDCON1_TFT16BPP |
@@ -129,6 +129,21 @@ static struct s3c2410fb_mach_info smdk24
 				  S3C2410_LCDCON5_HWSWP,
 	},
 
+	.type		= S3C2410_LCDCON1_TFT16BPP,
+
+	.width		= 240,
+	.height		= 320,
+
+	.xres		= 240,
+	.yres		= 320,
+	.bpp		= 16,
+};
+
+static struct s3c2410fb_mach_info smdk2440_fb_info __initdata = {
+	.displays	= &smdk2440_lcd_cfg,
+	.num_displays	= 1,
+	.default_display = 0,
+
 #if 0
 	/* currently setup by downloader */
 	.gpccon		= 0xaa940659,
@@ -142,28 +157,6 @@ static struct s3c2410fb_mach_info smdk24
 #endif
 
 	.lpcsel		= ((0xCE6) & ~7) | 1<<4,
-	.type		= S3C2410_LCDCON1_TFT16BPP,
-
-	.width		= 240,
-	.height		= 320,
-
-	.xres		= {
-		.min	= 240,
-		.max	= 240,
-		.defval	= 240,
-	},
-
-	.yres		= {
-		.min	= 320,
-		.max	= 320,
-		.defval = 320,
-	},
-
-	.bpp		= {
-		.min	= 16,
-		.max	= 16,
-		.defval = 16,
-	},
 };
 
 static struct platform_device *smdk2440_devices[] __initdata = {
@@ -183,7 +176,7 @@ static void __init smdk2440_map_io(void)
 
 static void __init smdk2440_machine_init(void)
 {
-	s3c24xx_fb_set_platdata(&smdk2440_lcd_cfg);
+	s3c24xx_fb_set_platdata(&smdk2440_fb_info);
 
 	platform_add_devices(smdk2440_devices, ARRAY_SIZE(smdk2440_devices));
 	smdk_machine_init();
diff -puN drivers/video/s3c2410fb.c~s3c2410fb-multi-display-support drivers/video/s3c2410fb.c
--- a/drivers/video/s3c2410fb.c~s3c2410fb-multi-display-support
+++ a/drivers/video/s3c2410fb.c
@@ -174,27 +174,28 @@ static int s3c2410fb_check_var(struct fb
 			       struct fb_info *info)
 {
 	struct s3c2410fb_info *fbi = info->par;
+	struct s3c2410fb_mach_info *mach_info = fbi->mach_info;
+	struct s3c2410fb_display *display = NULL;
+	unsigned i;
 
 	dprintk("check_var(var=%p, info=%p)\n", var, info);
 
 	/* validate x/y resolution */
 
-	if (var->yres > fbi->mach_info->yres.max)
-		var->yres = fbi->mach_info->yres.max;
-	else if (var->yres < fbi->mach_info->yres.min)
-		var->yres = fbi->mach_info->yres.min;
-
-	if (var->xres > fbi->mach_info->xres.max)
-		var->yres = fbi->mach_info->xres.max;
-	else if (var->xres < fbi->mach_info->xres.min)
-		var->xres = fbi->mach_info->xres.min;
-
-	/* validate bpp */
-
-	if (var->bits_per_pixel > fbi->mach_info->bpp.max)
-		var->bits_per_pixel = fbi->mach_info->bpp.max;
-	else if (var->bits_per_pixel < fbi->mach_info->bpp.min)
-		var->bits_per_pixel = fbi->mach_info->bpp.min;
+	for (i = 0; i < mach_info->num_displays; i++)
+		if (var->yres == mach_info->displays[i].yres &&
+		    var->xres == mach_info->displays[i].xres &&
+		    var->bits_per_pixel == mach_info->displays[i].bpp) {
+			display = mach_info->displays + i;
+			fbi->current_display = i;
+			break;
+		}
+
+	if (!display) {
+		dprintk("wrong resolution or depth %dx%d at %d bpp\n",
+			var->xres, var->yres, var->bits_per_pixel);
+		return -EINVAL;
+	}
 
 	var->transp.offset = 0;
 	var->transp.length = 0;
@@ -209,7 +210,7 @@ static int s3c2410fb_check_var(struct fb
 		var->blue	= var->red;
 		break;
 	case 8:
-		if (fbi->mach_info->type != S3C2410_LCDCON1_TFT) {
+		if (display->type != S3C2410_LCDCON1_TFT) {
 			/* 8 bpp 332 */
 			var->red.length		= 3;
 			var->red.offset		= 5;
@@ -236,7 +237,7 @@ static int s3c2410fb_check_var(struct fb
 
 	default:
 	case 16:
-		if (fbi->regs.lcdcon5 & S3C2410_LCDCON5_FRM565) {
+		if (display->regs.lcdcon5 & S3C2410_LCDCON5_FRM565) {
 			/* 16 bpp, 565 format */
 			var->red.offset		= 11;
 			var->green.offset	= 5;
@@ -278,6 +279,9 @@ static void s3c2410fb_activate_var(struc
 				   struct fb_var_screeninfo *var)
 {
 	struct s3c2410fb_info *fbi = info->par;
+	struct s3c2410fb_mach_info *mach_info = fbi->mach_info;
+	struct s3c2410fb_display *display = mach_info->displays +
+					    fbi->current_display;
 	int hs;
 
 	fbi->regs.lcdcon1 &= ~S3C2410_LCDCON1_MODEMASK;
@@ -287,9 +291,9 @@ static void s3c2410fb_activate_var(struc
 	dprintk("%s: var->yres  = %d\n", __FUNCTION__, var->yres);
 	dprintk("%s: var->bpp   = %d\n", __FUNCTION__, var->bits_per_pixel);
 
-	fbi->regs.lcdcon1 |= fbi->mach_info->type;
+	fbi->regs.lcdcon1 |= display->type;
 
-	if (fbi->mach_info->type == S3C2410_LCDCON1_TFT)
+	if (display->type == S3C2410_LCDCON1_TFT)
 		switch (var->bits_per_pixel) {
 		case 1:
 			fbi->regs.lcdcon1 |= S3C2410_LCDCON1_TFT1BPP;
@@ -338,7 +342,7 @@ static void s3c2410fb_activate_var(struc
 
 	/* check to see if we need to update sync/borders */
 
-	if (!fbi->mach_info->fixed_syncs) {
+	if (!mach_info->fixed_syncs) {
 		dprintk("setting vert: up=%d, low=%d, sync=%d\n",
 			var->upper_margin, var->lower_margin, var->vsync_len);
 
@@ -363,7 +367,7 @@ static void s3c2410fb_activate_var(struc
 	fbi->regs.lcdcon2 &= ~S3C2410_LCDCON2_LINEVAL(0x3ff);
 	fbi->regs.lcdcon2 |=  S3C2410_LCDCON2_LINEVAL(var->yres - 1);
 
-	switch (fbi->mach_info->type) {
+	switch (display->type) {
 	case S3C2410_LCDCON1_DSCAN4:
 	case S3C2410_LCDCON1_STN8:
 		hs = var->xres / 8;
@@ -388,7 +392,7 @@ static void s3c2410fb_activate_var(struc
 	if (var->pixclock > 0) {
 		int clkdiv = s3c2410fb_calc_pixclk(fbi, var->pixclock);
 
-		if (fbi->mach_info->type == S3C2410_LCDCON1_TFT) {
+		if (display->type == S3C2410_LCDCON1_TFT) {
 			clkdiv = (clkdiv / 2) - 1;
 			if (clkdiv < 0)
 				clkdiv = 0;
@@ -750,6 +754,7 @@ static char driver_name[] = "s3c2410fb";
 static int __init s3c2410fb_probe(struct platform_device *pdev)
 {
 	struct s3c2410fb_info *info;
+	struct s3c2410fb_display *display;
 	struct fb_info *fbinfo;
 	struct s3c2410fb_hw *mregs;
 	struct resource *res;
@@ -766,7 +771,8 @@ static int __init s3c2410fb_probe(struct
 		return -EINVAL;
 	}
 
-	mregs = &mach_info->regs;
+	display = mach_info->displays + mach_info->default_display;
+	mregs = &display->regs;
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
@@ -809,7 +815,7 @@ static int __init s3c2410fb_probe(struct
 
 	strcpy(fbinfo->fix.id, driver_name);
 
-	memcpy(&info->regs, &mach_info->regs, sizeof(info->regs));
+	memcpy(&info->regs, &display->regs, sizeof(info->regs));
 
 	/* Stop the video and unset ENVID if set */
 	info->regs.lcdcon1 &= ~S3C2410_LCDCON1_ENVID;
@@ -817,6 +823,7 @@ static int __init s3c2410fb_probe(struct
 	writel(lcdcon1 & ~S3C2410_LCDCON1_ENVID, info->io + S3C2410_LCDCON1);
 
 	info->mach_info		    = pdev->dev.platform_data;
+	info->current_display	    = mach_info->default_display;
 
 	fbinfo->fix.type	    = FB_TYPE_PACKED_PIXELS;
 	fbinfo->fix.type_aux	    = 0;
@@ -827,8 +834,8 @@ static int __init s3c2410fb_probe(struct
 
 	fbinfo->var.nonstd	    = 0;
 	fbinfo->var.activate	    = FB_ACTIVATE_NOW;
-	fbinfo->var.height	    = mach_info->height;
-	fbinfo->var.width	    = mach_info->width;
+	fbinfo->var.height	    = display->height;
+	fbinfo->var.width	    = display->width;
 	fbinfo->var.accel_flags     = 0;
 	fbinfo->var.vmode	    = FB_VMODE_NONINTERLACED;
 
@@ -836,11 +843,11 @@ static int __init s3c2410fb_probe(struct
 	fbinfo->flags		    = FBINFO_FLAG_DEFAULT;
 	fbinfo->pseudo_palette      = &info->pseudo_pal;
 
-	fbinfo->var.xres	    = mach_info->xres.defval;
-	fbinfo->var.xres_virtual    = mach_info->xres.defval;
-	fbinfo->var.yres	    = mach_info->yres.defval;
-	fbinfo->var.yres_virtual    = mach_info->yres.defval;
-	fbinfo->var.bits_per_pixel  = mach_info->bpp.defval;
+	fbinfo->var.xres	    = display->xres;
+	fbinfo->var.xres_virtual    = display->xres;
+	fbinfo->var.yres	    = display->yres;
+	fbinfo->var.yres_virtual    = display->yres;
+	fbinfo->var.bits_per_pixel  = display->bpp;
 
 	fbinfo->var.upper_margin    =
 				S3C2410_LCDCON2_GET_VBPD(mregs->lcdcon2) + 1;
@@ -864,9 +871,17 @@ static int __init s3c2410fb_probe(struct
 	fbinfo->var.green.length    = 6;
 	fbinfo->var.blue.length     = 5;
 	fbinfo->var.transp.length   = 0;
-	fbinfo->fix.smem_len	    =	mach_info->xres.max *
-					mach_info->yres.max *
-					mach_info->bpp.max / 8;
+
+	/* find maximum required memory size for display */
+	for (i = 0; i < mach_info->num_displays; i++) {
+		unsigned long smem_len = mach_info->displays[i].xres;
+
+		smem_len *= mach_info->displays[i].yres;
+		smem_len *= mach_info->displays[i].bpp;
+		smem_len >>= 3;
+		if (fbinfo->fix.smem_len < smem_len)
+			fbinfo->fix.smem_len = smem_len;
+	}
 
 	for (i = 0; i < 256; i++)
 		info->palette_buffer[i] = PALETTE_BUFF_CLEAR;
diff -puN drivers/video/s3c2410fb.h~s3c2410fb-multi-display-support drivers/video/s3c2410fb.h
--- a/drivers/video/s3c2410fb.h~s3c2410fb-multi-display-support
+++ a/drivers/video/s3c2410fb.h
@@ -34,6 +34,8 @@ struct s3c2410fb_info {
 
 	struct s3c2410fb_mach_info *mach_info;
 
+	unsigned current_display;
+
 	/* raw memory addresses */
 	dma_addr_t		map_dma;	/* physical */
 	u_char *		map_cpu;	/* virtual */
diff -puN include/asm-arm/arch-s3c2410/fb.h~s3c2410fb-multi-display-support include/asm-arm/arch-s3c2410/fb.h
--- a/include/asm-arm/arch-s3c2410/fb.h~s3c2410fb-multi-display-support
+++ a/include/asm-arm/arch-s3c2410/fb.h
@@ -14,12 +14,6 @@
 
 #include <asm/arch/regs-lcd.h>
 
-struct s3c2410fb_val {
-	unsigned int	defval;
-	unsigned int	min;
-	unsigned int	max;
-};
-
 struct s3c2410fb_hw {
 	unsigned long	lcdcon1;
 	unsigned long	lcdcon2;
@@ -28,23 +22,30 @@ struct s3c2410fb_hw {
 	unsigned long	lcdcon5;
 };
 
-struct s3c2410fb_mach_info {
-	unsigned char	fixed_syncs;	/* do not update sync/border */
-
-	/* LCD types */
-	int		type;
+/* LCD description */
+struct s3c2410fb_display {
+	/* LCD type */
+	unsigned type;
 
 	/* Screen size */
-	int		width;
-	int		height;
+	unsigned short width;
+	unsigned short height;
 
 	/* Screen info */
-	struct s3c2410fb_val xres;
-	struct s3c2410fb_val yres;
-	struct s3c2410fb_val bpp;
+	unsigned short xres;
+	unsigned short yres;
+	unsigned short bpp;
 
 	/* lcd configuration registers */
 	struct s3c2410fb_hw  regs;
+};
+
+struct s3c2410fb_mach_info {
+	unsigned char	fixed_syncs;	/* do not update sync/border */
+
+	struct s3c2410fb_display *displays;	/* attached diplays info */
+	unsigned num_displays;			/* number of defined displays */
+	unsigned default_display;
 
 	/* GPIOs */
 
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
