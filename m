From: akpm@linux-foundation.org
Subject: - s3c2410fb-add-vertical-margins-fields-to-s3c2410fb_display.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:43:17 -0700
Message-ID: <200710162043.l9GKhHMl016030@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33890 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753886AbXJPVNA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:13:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     s3c2410fb: add vertical margins fields to s3c2410fb_display
has been removed from the -mm tree.  Its filename was
     s3c2410fb-add-vertical-margins-fields-to-s3c2410fb_display.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: s3c2410fb: add vertical margins fields to s3c2410fb_display
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch adds vertical margins values to all
s3c24xx platform.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-s3c2410/mach-amlm5900.c |    2 ++
 arch/arm/mach-s3c2410/mach-bast.c     |   19 +++++++++++++++++++
 arch/arm/mach-s3c2410/mach-h1940.c    |    2 ++
 arch/arm/mach-s3c2410/mach-qt2410.c   |    6 ++++++
 arch/arm/mach-s3c2440/mach-rx3715.c   |    2 ++
 arch/arm/mach-s3c2440/mach-smdk2440.c |    2 ++
 6 files changed, 33 insertions(+)

diff -puN arch/arm/mach-s3c2410/mach-amlm5900.c~s3c2410fb-add-vertical-margins-fields-to-s3c2410fb_display arch/arm/mach-s3c2410/mach-amlm5900.c
--- a/arch/arm/mach-s3c2410/mach-amlm5900.c~s3c2410fb-add-vertical-margins-fields-to-s3c2410fb_display
+++ a/arch/arm/mach-s3c2410/mach-amlm5900.c
@@ -179,6 +179,8 @@ static struct s3c2410fb_display __initda
 	.bpp		= 4,
 	.left_margin	= 1 << (4 + 3),
 	.right_margin	= 8 << 3,
+	.upper_margin	= 0,
+	.lower_margin	= 0,
 
 	.lcdcon1	= 0x00008225,
 	.lcdcon2	= 0x0027c000,
diff -puN arch/arm/mach-s3c2410/mach-bast.c~s3c2410fb-add-vertical-margins-fields-to-s3c2410fb_display arch/arm/mach-s3c2410/mach-bast.c
--- a/arch/arm/mach-s3c2410/mach-bast.c~s3c2410fb-add-vertical-margins-fields-to-s3c2410fb_display
+++ a/arch/arm/mach-s3c2410/mach-bast.c
@@ -472,10 +472,13 @@ static struct s3c2410fb_display __initda
 		.type		= S3C2410_LCDCON1_TFT,
 		.width		= 640,
 		.height		= 480,
+
 		.xres		= 320,
 		.yres		= 240,
 		.left_margin	= 40,
 		.right_margin	= 20,
+		.upper_margin	= 30,
+		.lower_margin	= 32,
 
 		.bpp		= 4,
 
@@ -494,6 +497,8 @@ static struct s3c2410fb_display __initda
 		.bpp		= 4,
 		.left_margin	= 40,
 		.right_margin	= 20,
+		.upper_margin	= 30,
+		.lower_margin	= 32,
 
 		.lcdcon1	= 0x00000176,
 		.lcdcon2	= 0x1d77c7c2,
@@ -510,6 +515,8 @@ static struct s3c2410fb_display __initda
 		.bpp		= 4,
 		.left_margin	= 40,
 		.right_margin	= 20,
+		.upper_margin	= 30,
+		.lower_margin	= 32,
 
 		.lcdcon1	= 0x00000176,
 		.lcdcon2	= 0x1d77c7c2,
@@ -526,6 +533,8 @@ static struct s3c2410fb_display __initda
 		.bpp		= 8,
 		.left_margin	= 40,
 		.right_margin	= 20,
+		.upper_margin	= 30,
+		.lower_margin	= 32,
 
 		.lcdcon1	= 0x00000176,
 		.lcdcon2	= 0x1d77c7c2,
@@ -542,6 +551,8 @@ static struct s3c2410fb_display __initda
 		.bpp		= 8,
 		.left_margin	= 40,
 		.right_margin	= 20,
+		.upper_margin	= 30,
+		.lower_margin	= 32,
 
 		.lcdcon1	= 0x00000176,
 		.lcdcon2	= 0x1d77c7c2,
@@ -558,6 +569,8 @@ static struct s3c2410fb_display __initda
 		.bpp		= 8,
 		.left_margin	= 40,
 		.right_margin	= 20,
+		.upper_margin	= 30,
+		.lower_margin	= 32,
 
 		.lcdcon1	= 0x00000176,
 		.lcdcon2	= 0x1d77c7c2,
@@ -574,6 +587,8 @@ static struct s3c2410fb_display __initda
 		.bpp		= 16,
 		.left_margin	= 40,
 		.right_margin	= 20,
+		.upper_margin	= 30,
+		.lower_margin	= 32,
 
 		.lcdcon1	= 0x00000176,
 		.lcdcon2	= 0x1d77c7c2,
@@ -590,6 +605,8 @@ static struct s3c2410fb_display __initda
 		.bpp		= 16,
 		.left_margin	= 40,
 		.right_margin	= 20,
+		.upper_margin	= 30,
+		.lower_margin	= 32,
 
 		.lcdcon1	= 0x00000176,
 		.lcdcon2	= 0x1d77c7c2,
@@ -606,6 +623,8 @@ static struct s3c2410fb_display __initda
 		.bpp		= 16,
 		.left_margin	= 40,
 		.right_margin	= 20,
+		.upper_margin	= 30,
+		.lower_margin	= 32,
 
 		.lcdcon1	= 0x00000176,
 		.lcdcon2	= 0x1d77c7c2,
diff -puN arch/arm/mach-s3c2410/mach-h1940.c~s3c2410fb-add-vertical-margins-fields-to-s3c2410fb_display arch/arm/mach-s3c2410/mach-h1940.c
--- a/arch/arm/mach-s3c2410/mach-h1940.c~s3c2410fb-add-vertical-margins-fields-to-s3c2410fb_display
+++ a/arch/arm/mach-s3c2410/mach-h1940.c
@@ -158,6 +158,8 @@ static struct s3c2410fb_display h1940_lc
 	.bpp =		16,
 	.left_margin =	20,
 	.right_margin =	8,
+	.upper_margin =	8,
+	.lower_margin = 7,
 };
 
 static struct s3c2410fb_mach_info h1940_fb_info __initdata = {
diff -puN arch/arm/mach-s3c2410/mach-qt2410.c~s3c2410fb-add-vertical-margins-fields-to-s3c2410fb_display arch/arm/mach-s3c2410/mach-qt2410.c
--- a/arch/arm/mach-s3c2410/mach-qt2410.c~s3c2410fb-add-vertical-margins-fields-to-s3c2410fb_display
+++ a/arch/arm/mach-s3c2410/mach-qt2410.c
@@ -125,6 +125,8 @@ static struct s3c2410fb_display qt2410_l
 		.bpp		= 16,
 		.left_margin	= 44,
 		.right_margin	= 116,
+		.upper_margin	= 19,
+		.lower_margin	= 11,
 	},
 	{
 		/* Configuration for 480x640 toppoly TD028TTEC1 */
@@ -154,6 +156,8 @@ static struct s3c2410fb_display qt2410_l
 		.bpp		= 16,
 		.left_margin	= 8,
 		.right_margin	= 24,
+		.upper_margin	= 2,
+		.lower_margin	= 4,
 	},
 	{
 		/* Config for 240x320 LCD */
@@ -183,6 +187,8 @@ static struct s3c2410fb_display qt2410_l
 		.bpp		= 16,
 		.left_margin	= 13,
 		.right_margin	= 8,
+		.upper_margin	= 2,
+		.lower_margin	= 7,
 	},
 };
 
diff -puN arch/arm/mach-s3c2440/mach-rx3715.c~s3c2410fb-add-vertical-margins-fields-to-s3c2410fb_display arch/arm/mach-s3c2440/mach-rx3715.c
--- a/arch/arm/mach-s3c2440/mach-rx3715.c~s3c2410fb-add-vertical-margins-fields-to-s3c2410fb_display
+++ a/arch/arm/mach-s3c2440/mach-rx3715.c
@@ -136,6 +136,8 @@ static struct s3c2410fb_display rx3715_l
 	.bpp		= 16,
 	.left_margin	= 36,
 	.right_margin	= 36,
+	.upper_margin	= 6,
+	.lower_margin	= 7,
 };
 
 static struct s3c2410fb_mach_info rx3715_fb_info __initdata = {
diff -puN arch/arm/mach-s3c2440/mach-smdk2440.c~s3c2410fb-add-vertical-margins-fields-to-s3c2410fb_display arch/arm/mach-s3c2440/mach-smdk2440.c
--- a/arch/arm/mach-s3c2440/mach-smdk2440.c~s3c2410fb-add-vertical-margins-fields-to-s3c2410fb_display
+++ a/arch/arm/mach-s3c2440/mach-smdk2440.c
@@ -133,6 +133,8 @@ static struct s3c2410fb_display smdk2440
 	.bpp		= 16,
 	.left_margin	= 20,
 	.right_margin	= 8,
+	.upper_margin	= 8,
+	.lower_margin	= 7,
 };
 
 static struct s3c2410fb_mach_info smdk2440_fb_info __initdata = {
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
git-alsa.patch
cyber2000fb-checkpatch-fixes.patch
