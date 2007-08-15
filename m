From: akpm@linux-foundation.org
Subject: + s3c2410fb-remove-lcdcon3-register-from-s3c2410fb_display.patch added to -mm tree
Date: Wed, 15 Aug 2007 16:21:10 -0700
Message-ID: <200708152321.l7FNLAPg020334@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60404 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762033AbXHOXa0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 19:30:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     s3c2410fb: remove lcdcon3 register from s3c2410fb_display
has been added to the -mm tree.  Its filename is
     s3c2410fb-remove-lcdcon3-register-from-s3c2410fb_display.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: s3c2410fb: remove lcdcon3 register from s3c2410fb_display
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch removes unused lcdcon3 register from the
s3c2410fb_display structure.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-s3c2410/mach-amlm5900.c |   11 --
 arch/arm/mach-s3c2410/mach-bast.c     |   99 +++++++------------
 arch/arm/mach-s3c2410/mach-h1940.c    |   36 ++-----
 arch/arm/mach-s3c2410/mach-qt2410.c   |  123 +++++++++---------------
 arch/arm/mach-s3c2440/mach-rx3715.c   |   36 ++-----
 arch/arm/mach-s3c2440/mach-smdk2440.c |   40 +++----
 drivers/video/s3c2410fb.c             |   17 +--
 include/asm-arm/arch-s3c2410/fb.h     |    5 
 8 files changed, 151 insertions(+), 216 deletions(-)

diff -puN arch/arm/mach-s3c2410/mach-amlm5900.c~s3c2410fb-remove-lcdcon3-register-from-s3c2410fb_display arch/arm/mach-s3c2410/mach-amlm5900.c
--- a/arch/arm/mach-s3c2410/mach-amlm5900.c~s3c2410fb-remove-lcdcon3-register-from-s3c2410fb_display
+++ a/arch/arm/mach-s3c2410/mach-amlm5900.c
@@ -180,13 +180,10 @@ static struct s3c2410fb_display __initda
 	.left_margin	= 1 << (4 + 3),
 	.right_margin	= 8 << 3,
 
-	.regs		= {
-		.lcdcon1	= 0x00008225,
-		.lcdcon2	= 0x0027c000,
-		.lcdcon3	= 0x00182708,
-		.lcdcon4	= 0x00000002,
-		.lcdcon5	= 0x00000001,
-	}
+	.lcdcon1	= 0x00008225,
+	.lcdcon2	= 0x0027c000,
+	.lcdcon4	= 0x00000002,
+	.lcdcon5	= 0x00000001,
 };
 
 static struct s3c2410fb_mach_info __initdata amlm5900_fb_info = {
diff -puN arch/arm/mach-s3c2410/mach-bast.c~s3c2410fb-remove-lcdcon3-register-from-s3c2410fb_display arch/arm/mach-s3c2410/mach-bast.c
--- a/arch/arm/mach-s3c2410/mach-bast.c~s3c2410fb-remove-lcdcon3-register-from-s3c2410fb_display
+++ a/arch/arm/mach-s3c2410/mach-bast.c
@@ -479,13 +479,10 @@ static struct s3c2410fb_display __initda
 
 		.bpp		= 4,
 
-		.regs		= {
-			.lcdcon1	= 0x00000176,
-			.lcdcon2	= 0x1d77c7c2,
-			.lcdcon3	= 0x013a7f13,
-			.lcdcon4	= 0x00000057,
-			.lcdcon5	= 0x00014b02,
-		}
+		.lcdcon1	= 0x00000176,
+		.lcdcon2	= 0x1d77c7c2,
+		.lcdcon4	= 0x00000057,
+		.lcdcon5	= 0x00014b02,
 	},
 	{
 		.type		= S3C2410_LCDCON1_TFT,
@@ -498,13 +495,10 @@ static struct s3c2410fb_display __initda
 		.left_margin	= 40,
 		.right_margin	= 20,
 
-		.regs		= {
-			.lcdcon1	= 0x00000176,
-			.lcdcon2	= 0x1d77c7c2,
-			.lcdcon3	= 0x013a7f13,
-			.lcdcon4	= 0x00000057,
-			.lcdcon5	= 0x00014b02,
-		}
+		.lcdcon1	= 0x00000176,
+		.lcdcon2	= 0x1d77c7c2,
+		.lcdcon4	= 0x00000057,
+		.lcdcon5	= 0x00014b02,
 	},
 	{
 		.type		= S3C2410_LCDCON1_TFT,
@@ -517,13 +511,10 @@ static struct s3c2410fb_display __initda
 		.left_margin	= 40,
 		.right_margin	= 20,
 
-		.regs		= {
-			.lcdcon1	= 0x00000176,
-			.lcdcon2	= 0x1d77c7c2,
-			.lcdcon3	= 0x013a7f13,
-			.lcdcon4	= 0x00000057,
-			.lcdcon5	= 0x00014b02,
-		}
+		.lcdcon1	= 0x00000176,
+		.lcdcon2	= 0x1d77c7c2,
+		.lcdcon4	= 0x00000057,
+		.lcdcon5	= 0x00014b02,
 	},
 	{
 		.type		= S3C2410_LCDCON1_TFT,
@@ -536,13 +527,10 @@ static struct s3c2410fb_display __initda
 		.left_margin	= 40,
 		.right_margin	= 20,
 
-		.regs		= {
-			.lcdcon1	= 0x00000176,
-			.lcdcon2	= 0x1d77c7c2,
-			.lcdcon3	= 0x013a7f13,
-			.lcdcon4	= 0x00000057,
-			.lcdcon5	= 0x00014b02,
-		}
+		.lcdcon1	= 0x00000176,
+		.lcdcon2	= 0x1d77c7c2,
+		.lcdcon4	= 0x00000057,
+		.lcdcon5	= 0x00014b02,
 	},
 	{
 		.type		= S3C2410_LCDCON1_TFT,
@@ -555,13 +543,10 @@ static struct s3c2410fb_display __initda
 		.left_margin	= 40,
 		.right_margin	= 20,
 
-		.regs		= {
-			.lcdcon1	= 0x00000176,
-			.lcdcon2	= 0x1d77c7c2,
-			.lcdcon3	= 0x013a7f13,
-			.lcdcon4	= 0x00000057,
-			.lcdcon5	= 0x00014b02,
-		}
+		.lcdcon1	= 0x00000176,
+		.lcdcon2	= 0x1d77c7c2,
+		.lcdcon4	= 0x00000057,
+		.lcdcon5	= 0x00014b02,
 	},
 	{
 		.type		= S3C2410_LCDCON1_TFT,
@@ -574,13 +559,10 @@ static struct s3c2410fb_display __initda
 		.left_margin	= 40,
 		.right_margin	= 20,
 
-		.regs		= {
-			.lcdcon1	= 0x00000176,
-			.lcdcon2	= 0x1d77c7c2,
-			.lcdcon3	= 0x013a7f13,
-			.lcdcon4	= 0x00000057,
-			.lcdcon5	= 0x00014b02,
-		}
+		.lcdcon1	= 0x00000176,
+		.lcdcon2	= 0x1d77c7c2,
+		.lcdcon4	= 0x00000057,
+		.lcdcon5	= 0x00014b02,
 	},
 	{
 		.type		= S3C2410_LCDCON1_TFT,
@@ -593,13 +575,10 @@ static struct s3c2410fb_display __initda
 		.left_margin	= 40,
 		.right_margin	= 20,
 
-		.regs		= {
-			.lcdcon1	= 0x00000176,
-			.lcdcon2	= 0x1d77c7c2,
-			.lcdcon3	= 0x013a7f13,
-			.lcdcon4	= 0x00000057,
-			.lcdcon5	= 0x00014b02,
-		}
+		.lcdcon1	= 0x00000176,
+		.lcdcon2	= 0x1d77c7c2,
+		.lcdcon4	= 0x00000057,
+		.lcdcon5	= 0x00014b02,
 	},
 	{
 		.type		= S3C2410_LCDCON1_TFT,
@@ -612,13 +591,10 @@ static struct s3c2410fb_display __initda
 		.left_margin	= 40,
 		.right_margin	= 20,
 
-		.regs		= {
-			.lcdcon1	= 0x00000176,
-			.lcdcon2	= 0x1d77c7c2,
-			.lcdcon3	= 0x013a7f13,
-			.lcdcon4	= 0x00000057,
-			.lcdcon5	= 0x00014b02,
-		}
+		.lcdcon1	= 0x00000176,
+		.lcdcon2	= 0x1d77c7c2,
+		.lcdcon4	= 0x00000057,
+		.lcdcon5	= 0x00014b02,
 	},
 	{
 		.type		= S3C2410_LCDCON1_TFT,
@@ -631,13 +607,10 @@ static struct s3c2410fb_display __initda
 		.left_margin	= 40,
 		.right_margin	= 20,
 
-		.regs		= {
-			.lcdcon1	= 0x00000176,
-			.lcdcon2	= 0x1d77c7c2,
-			.lcdcon3	= 0x013a7f13,
-			.lcdcon4	= 0x00000057,
-			.lcdcon5	= 0x00014b02,
-		}
+		.lcdcon1	= 0x00000176,
+		.lcdcon2	= 0x1d77c7c2,
+		.lcdcon4	= 0x00000057,
+		.lcdcon5	= 0x00014b02,
 	},
 };
 
diff -puN arch/arm/mach-s3c2410/mach-h1940.c~s3c2410fb-remove-lcdcon3-register-from-s3c2410fb_display arch/arm/mach-s3c2410/mach-h1940.c
--- a/arch/arm/mach-s3c2410/mach-h1940.c~s3c2410fb-remove-lcdcon3-register-from-s3c2410fb_display
+++ a/arch/arm/mach-s3c2410/mach-h1940.c
@@ -134,27 +134,21 @@ static struct s3c2410_udc_mach_info h194
  * Set lcd on or off
  **/
 static struct s3c2410fb_display h1940_lcd __initdata = {
-	.regs={
-		.lcdcon1=	S3C2410_LCDCON1_TFT16BPP | \
-				S3C2410_LCDCON1_TFT | \
-				S3C2410_LCDCON1_CLKVAL(0x0C),
-
-		.lcdcon2=	S3C2410_LCDCON2_VBPD(7) | \
-				S3C2410_LCDCON2_LINEVAL(319) | \
-				S3C2410_LCDCON2_VFPD(6) | \
-				S3C2410_LCDCON2_VSPW(0),
-
-		.lcdcon3=	S3C2410_LCDCON3_HBPD(19) | \
-				S3C2410_LCDCON3_HOZVAL(239) | \
-				S3C2410_LCDCON3_HFPD(7),
-
-		.lcdcon4=	S3C2410_LCDCON4_MVAL(0) | \
-				S3C2410_LCDCON4_HSPW(3),
-
-		.lcdcon5=	S3C2410_LCDCON5_FRM565 | \
-				S3C2410_LCDCON5_INVVLINE | \
-				S3C2410_LCDCON5_HWSWP,
-	},
+	.lcdcon1=	S3C2410_LCDCON1_TFT16BPP | \
+			S3C2410_LCDCON1_TFT | \
+			S3C2410_LCDCON1_CLKVAL(0x0C),
+
+	.lcdcon2=	S3C2410_LCDCON2_VBPD(7) | \
+			S3C2410_LCDCON2_LINEVAL(319) | \
+			S3C2410_LCDCON2_VFPD(6) | \
+			S3C2410_LCDCON2_VSPW(0),
+
+	.lcdcon4=	S3C2410_LCDCON4_MVAL(0) | \
+			S3C2410_LCDCON4_HSPW(3),
+
+	.lcdcon5=	S3C2410_LCDCON5_FRM565 | \
+			S3C2410_LCDCON5_INVVLINE | \
+			S3C2410_LCDCON5_HWSWP,
 
 	.type =		S3C2410_LCDCON1_TFT,
 	.width =	240,
diff -puN arch/arm/mach-s3c2410/mach-qt2410.c~s3c2410fb-remove-lcdcon3-register-from-s3c2410fb_display arch/arm/mach-s3c2410/mach-qt2410.c
--- a/arch/arm/mach-s3c2410/mach-qt2410.c~s3c2410fb-remove-lcdcon3-register-from-s3c2410fb_display
+++ a/arch/arm/mach-s3c2410/mach-qt2410.c
@@ -98,30 +98,23 @@ static struct s3c2410_uartcfg smdk2410_u
 static struct s3c2410fb_display qt2410_lcd_cfg[] __initdata = {
 	{
 		/* Configuration for 640x480 SHARP LQ080V3DG01 */
-		.regs	= {
-
-			.lcdcon1 = S3C2410_LCDCON1_TFT16BPP |
-				   S3C2410_LCDCON1_TFT |
-				   S3C2410_LCDCON1_CLKVAL(0x01), /* HCLK/4 */
-
-			.lcdcon2 = S3C2410_LCDCON2_VBPD(18) |	/* 19 */
-				   S3C2410_LCDCON2_LINEVAL(479) |
-				   S3C2410_LCDCON2_VFPD(10) |	/* 11 */
-				   S3C2410_LCDCON2_VSPW(14),	/* 15 */
-
-			.lcdcon3 = S3C2410_LCDCON3_HBPD(43) |	/* 44 */
-				   S3C2410_LCDCON3_HOZVAL(639) | /* 640 */
-				   S3C2410_LCDCON3_HFPD(115),	/* 116 */
-
-			.lcdcon4 = S3C2410_LCDCON4_MVAL(0) |
-				   S3C2410_LCDCON4_HSPW(95),	/* 96 */
-
-			.lcdcon5 = S3C2410_LCDCON5_FRM565 |
-				   S3C2410_LCDCON5_INVVLINE |
-				   S3C2410_LCDCON5_INVVFRAME |
-				   S3C2410_LCDCON5_PWREN |
-				   S3C2410_LCDCON5_HWSWP,
-		},
+		.lcdcon1 = S3C2410_LCDCON1_TFT16BPP |
+			   S3C2410_LCDCON1_TFT |
+			   S3C2410_LCDCON1_CLKVAL(0x01), /* HCLK/4 */
+
+		.lcdcon2 = S3C2410_LCDCON2_VBPD(18) |	/* 19 */
+			   S3C2410_LCDCON2_LINEVAL(479) |
+			   S3C2410_LCDCON2_VFPD(10) |	/* 11 */
+			   S3C2410_LCDCON2_VSPW(14),	/* 15 */
+
+		.lcdcon4 = S3C2410_LCDCON4_MVAL(0) |
+			   S3C2410_LCDCON4_HSPW(95),	/* 96 */
+
+		.lcdcon5 = S3C2410_LCDCON5_FRM565 |
+			   S3C2410_LCDCON5_INVVLINE |
+			   S3C2410_LCDCON5_INVVFRAME |
+			   S3C2410_LCDCON5_PWREN |
+			   S3C2410_LCDCON5_HWSWP,
 
 		.type		= S3C2410_LCDCON1_TFT,
 		.width		= 640,
@@ -135,30 +128,23 @@ static struct s3c2410fb_display qt2410_l
 	},
 	{
 		/* Configuration for 480x640 toppoly TD028TTEC1 */
-		.regs	= {
-
-			.lcdcon1 = S3C2410_LCDCON1_TFT16BPP |
-				   S3C2410_LCDCON1_TFT |
-				   S3C2410_LCDCON1_CLKVAL(0x01), /* HCLK/4 */
-
-			.lcdcon2 = S3C2410_LCDCON2_VBPD(1) |	/* 2 */
-				   S3C2410_LCDCON2_LINEVAL(639) |/* 640 */
-				   S3C2410_LCDCON2_VFPD(3) |	/* 4 */
-				   S3C2410_LCDCON2_VSPW(1),	/* 2 */
-
-			.lcdcon3 = S3C2410_LCDCON3_HBPD(7) |	/* 8 */
-				   S3C2410_LCDCON3_HOZVAL(479) | /* 479 */
-				   S3C2410_LCDCON3_HFPD(23),	/* 24 */
-
-			.lcdcon4 = S3C2410_LCDCON4_MVAL(0) |
-				   S3C2410_LCDCON4_HSPW(7),	/* 8 */
-
-			.lcdcon5 = S3C2410_LCDCON5_FRM565 |
-				   S3C2410_LCDCON5_INVVLINE |
-				   S3C2410_LCDCON5_INVVFRAME |
-				   S3C2410_LCDCON5_PWREN |
-				   S3C2410_LCDCON5_HWSWP,
-		},
+		.lcdcon1 = S3C2410_LCDCON1_TFT16BPP |
+			   S3C2410_LCDCON1_TFT |
+			   S3C2410_LCDCON1_CLKVAL(0x01), /* HCLK/4 */
+
+		.lcdcon2 = S3C2410_LCDCON2_VBPD(1) |	/* 2 */
+			   S3C2410_LCDCON2_LINEVAL(639) |/* 640 */
+			   S3C2410_LCDCON2_VFPD(3) |	/* 4 */
+			   S3C2410_LCDCON2_VSPW(1),	/* 2 */
+
+		.lcdcon4 = S3C2410_LCDCON4_MVAL(0) |
+			   S3C2410_LCDCON4_HSPW(7),	/* 8 */
+
+		.lcdcon5 = S3C2410_LCDCON5_FRM565 |
+			   S3C2410_LCDCON5_INVVLINE |
+			   S3C2410_LCDCON5_INVVFRAME |
+			   S3C2410_LCDCON5_PWREN |
+			   S3C2410_LCDCON5_HWSWP,
 
 		.type		= S3C2410_LCDCON1_TFT,
 		.width		= 480,
@@ -171,30 +157,23 @@ static struct s3c2410fb_display qt2410_l
 	},
 	{
 		/* Config for 240x320 LCD */
-		.regs	= {
-
-			.lcdcon1 = S3C2410_LCDCON1_TFT16BPP |
-				   S3C2410_LCDCON1_TFT |
-				   S3C2410_LCDCON1_CLKVAL(0x04),
-
-			.lcdcon2 = S3C2410_LCDCON2_VBPD(1) |
-				   S3C2410_LCDCON2_LINEVAL(319) |
-				   S3C2410_LCDCON2_VFPD(6) |
-				   S3C2410_LCDCON2_VSPW(3),
-
-			.lcdcon3 = S3C2410_LCDCON3_HBPD(12) |
-				   S3C2410_LCDCON3_HOZVAL(239) |
-				   S3C2410_LCDCON3_HFPD(7),
-
-			.lcdcon4 = S3C2410_LCDCON4_MVAL(0) |
-				   S3C2410_LCDCON4_HSPW(3),
-
-			.lcdcon5 = S3C2410_LCDCON5_FRM565 |
-				   S3C2410_LCDCON5_INVVLINE |
-				   S3C2410_LCDCON5_INVVFRAME |
-				   S3C2410_LCDCON5_PWREN |
-				   S3C2410_LCDCON5_HWSWP,
-		},
+		.lcdcon1 = S3C2410_LCDCON1_TFT16BPP |
+			   S3C2410_LCDCON1_TFT |
+			   S3C2410_LCDCON1_CLKVAL(0x04),
+
+		.lcdcon2 = S3C2410_LCDCON2_VBPD(1) |
+			   S3C2410_LCDCON2_LINEVAL(319) |
+			   S3C2410_LCDCON2_VFPD(6) |
+			   S3C2410_LCDCON2_VSPW(3),
+
+		.lcdcon4 = S3C2410_LCDCON4_MVAL(0) |
+			   S3C2410_LCDCON4_HSPW(3),
+
+		.lcdcon5 = S3C2410_LCDCON5_FRM565 |
+			   S3C2410_LCDCON5_INVVLINE |
+			   S3C2410_LCDCON5_INVVFRAME |
+			   S3C2410_LCDCON5_PWREN |
+			   S3C2410_LCDCON5_HWSWP,
 
 		.type		= S3C2410_LCDCON1_TFT,
 		.width		= 240,
diff -puN arch/arm/mach-s3c2440/mach-rx3715.c~s3c2410fb-remove-lcdcon3-register-from-s3c2410fb_display arch/arm/mach-s3c2440/mach-rx3715.c
--- a/arch/arm/mach-s3c2440/mach-rx3715.c~s3c2410fb-remove-lcdcon3-register-from-s3c2410fb_display
+++ a/arch/arm/mach-s3c2440/mach-rx3715.c
@@ -111,27 +111,21 @@ static struct s3c2410_uartcfg rx3715_uar
 /* framebuffer lcd controller information */
 
 static struct s3c2410fb_display rx3715_lcdcfg __initdata = {
-	.regs	= {
-		.lcdcon1 =	S3C2410_LCDCON1_TFT16BPP | \
-				S3C2410_LCDCON1_TFT | \
-				S3C2410_LCDCON1_CLKVAL(0x0C),
-
-		.lcdcon2 =	S3C2410_LCDCON2_VBPD(5) | \
-				S3C2410_LCDCON2_LINEVAL(319) | \
-				S3C2410_LCDCON2_VFPD(6) | \
-				S3C2410_LCDCON2_VSPW(2),
-
-		.lcdcon3 =	S3C2410_LCDCON3_HBPD(35) | \
-				S3C2410_LCDCON3_HOZVAL(239) | \
-				S3C2410_LCDCON3_HFPD(35),
-
-		.lcdcon4 =	S3C2410_LCDCON4_MVAL(0) | \
-				S3C2410_LCDCON4_HSPW(7),
-
-		.lcdcon5 =	S3C2410_LCDCON5_INVVLINE |
-				S3C2410_LCDCON5_FRM565 |
-				S3C2410_LCDCON5_HWSWP,
-	},
+	.lcdcon1 =	S3C2410_LCDCON1_TFT16BPP | \
+			S3C2410_LCDCON1_TFT | \
+			S3C2410_LCDCON1_CLKVAL(0x0C),
+
+	.lcdcon2 =	S3C2410_LCDCON2_VBPD(5) | \
+			S3C2410_LCDCON2_LINEVAL(319) | \
+			S3C2410_LCDCON2_VFPD(6) | \
+			S3C2410_LCDCON2_VSPW(2),
+
+	.lcdcon4 =	S3C2410_LCDCON4_MVAL(0) | \
+			S3C2410_LCDCON4_HSPW(7),
+
+	.lcdcon5 =	S3C2410_LCDCON5_INVVLINE |
+			S3C2410_LCDCON5_FRM565 |
+			S3C2410_LCDCON5_HWSWP,
 
 	.type		= S3C2410_LCDCON1_TFT,
 	.width		= 240,
diff -puN arch/arm/mach-s3c2440/mach-smdk2440.c~s3c2410fb-remove-lcdcon3-register-from-s3c2410fb_display arch/arm/mach-s3c2440/mach-smdk2440.c
--- a/arch/arm/mach-s3c2440/mach-smdk2440.c~s3c2410fb-remove-lcdcon3-register-from-s3c2410fb_display
+++ a/arch/arm/mach-s3c2440/mach-smdk2440.c
@@ -104,30 +104,24 @@ static struct s3c2410_uartcfg smdk2440_u
 /* LCD driver info */
 
 static struct s3c2410fb_display smdk2440_lcd_cfg __initdata = {
-	.regs	= {
 
-		.lcdcon1	= S3C2410_LCDCON1_TFT16BPP |
-				  S3C2410_LCDCON1_TFT |
-				  S3C2410_LCDCON1_CLKVAL(0x04),
-
-		.lcdcon2	= S3C2410_LCDCON2_VBPD(7) |
-				  S3C2410_LCDCON2_LINEVAL(319) |
-				  S3C2410_LCDCON2_VFPD(6) |
-				  S3C2410_LCDCON2_VSPW(3),
-
-		.lcdcon3	= S3C2410_LCDCON3_HBPD(19) |
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
+	.lcdcon1	= S3C2410_LCDCON1_TFT16BPP |
+			  S3C2410_LCDCON1_TFT |
+			  S3C2410_LCDCON1_CLKVAL(0x04),
+
+	.lcdcon2	= S3C2410_LCDCON2_VBPD(7) |
+			  S3C2410_LCDCON2_LINEVAL(319) |
+			  S3C2410_LCDCON2_VFPD(6) |
+			  S3C2410_LCDCON2_VSPW(3),
+
+	.lcdcon4	= S3C2410_LCDCON4_MVAL(0) |
+			  S3C2410_LCDCON4_HSPW(3),
+
+	.lcdcon5	= S3C2410_LCDCON5_FRM565 |
+			  S3C2410_LCDCON5_INVVLINE |
+			  S3C2410_LCDCON5_INVVFRAME |
+			  S3C2410_LCDCON5_PWREN |
+			  S3C2410_LCDCON5_HWSWP,
 
 	.type		= S3C2410_LCDCON1_TFT16BPP,
 
diff -puN drivers/video/s3c2410fb.c~s3c2410fb-remove-lcdcon3-register-from-s3c2410fb_display drivers/video/s3c2410fb.c
--- a/drivers/video/s3c2410fb.c~s3c2410fb-remove-lcdcon3-register-from-s3c2410fb_display
+++ a/drivers/video/s3c2410fb.c
@@ -245,7 +245,7 @@ static int s3c2410fb_check_var(struct fb
 
 	default:
 	case 16:
-		if (display->regs.lcdcon5 & S3C2410_LCDCON5_FRM565) {
+		if (display->lcdcon5 & S3C2410_LCDCON5_FRM565) {
 			/* 16 bpp, 565 format */
 			var->red.offset		= 11;
 			var->green.offset	= 5;
@@ -796,7 +796,6 @@ static int __init s3c2410fb_probe(struct
 	struct s3c2410fb_info *info;
 	struct s3c2410fb_display *display;
 	struct fb_info *fbinfo;
-	struct s3c2410fb_hw *mregs;
 	struct resource *res;
 	int ret;
 	int irq;
@@ -812,7 +811,6 @@ static int __init s3c2410fb_probe(struct
 	}
 
 	display = mach_info->displays + mach_info->default_display;
-	mregs = &display->regs;
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
@@ -855,7 +853,10 @@ static int __init s3c2410fb_probe(struct
 
 	strcpy(fbinfo->fix.id, driver_name);
 
-	memcpy(&info->regs, &display->regs, sizeof(info->regs));
+	info->regs.lcdcon1 = display->lcdcon1;
+	info->regs.lcdcon2 = display->lcdcon2;
+	info->regs.lcdcon4 = display->lcdcon4;
+	info->regs.lcdcon5 = display->lcdcon5;
 
 	/* Stop the video and unset ENVID if set */
 	info->regs.lcdcon1 &= ~S3C2410_LCDCON1_ENVID;
@@ -892,14 +893,14 @@ static int __init s3c2410fb_probe(struct
 	fbinfo->var.right_margin    = display->right_margin;
 
 	fbinfo->var.upper_margin    =
-				S3C2410_LCDCON2_GET_VBPD(mregs->lcdcon2) + 1;
+				S3C2410_LCDCON2_GET_VBPD(display->lcdcon2) + 1;
 	fbinfo->var.lower_margin    =
-				S3C2410_LCDCON2_GET_VFPD(mregs->lcdcon2) + 1;
+				S3C2410_LCDCON2_GET_VFPD(display->lcdcon2) + 1;
 	fbinfo->var.vsync_len	    =
-				S3C2410_LCDCON2_GET_VSPW(mregs->lcdcon2) + 1;
+				S3C2410_LCDCON2_GET_VSPW(display->lcdcon2) + 1;
 
 	fbinfo->var.hsync_len	    =
-				S3C2410_LCDCON4_GET_HSPW(mregs->lcdcon4) + 1;
+				S3C2410_LCDCON4_GET_HSPW(display->lcdcon4) + 1;
 
 	fbinfo->var.red.offset      = 11;
 	fbinfo->var.green.offset    = 5;
diff -puN include/asm-arm/arch-s3c2410/fb.h~s3c2410fb-remove-lcdcon3-register-from-s3c2410fb_display include/asm-arm/arch-s3c2410/fb.h
--- a/include/asm-arm/arch-s3c2410/fb.h~s3c2410fb-remove-lcdcon3-register-from-s3c2410fb_display
+++ a/include/asm-arm/arch-s3c2410/fb.h
@@ -44,7 +44,10 @@ struct s3c2410fb_display {
 	unsigned short vsync_len;	/* value in lines (TFT) or 0 (STN) */
 
 	/* lcd configuration registers */
-	struct s3c2410fb_hw  regs;
+	unsigned long	lcdcon1;
+	unsigned long	lcdcon2;
+	unsigned long	lcdcon4;
+	unsigned long	lcdcon5;
 };
 
 struct s3c2410fb_mach_info {
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
