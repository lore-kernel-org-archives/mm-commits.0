From: akpm@linux-foundation.org
Subject: - fbcon-convert-struct-font_desc-to-use-iso-c-initializers.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:43:33 -0700
Message-ID: <200710162043.l9GKhXhW016059@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53714 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965806AbXJPVO7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:14:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ralf@linux-mips.org, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fbcon: Convert struct font_desc to use ISO C initializers
has been removed from the -mm tree.  Its filename was
     fbcon-convert-struct-font_desc-to-use-iso-c-initializers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fbcon: Convert struct font_desc to use ISO C initializers
From: Ralf Baechle <ralf@linux-mips.org>

Akpm's patch "newport_con warning fix" got me to look at the console drivers
again and one thing that I noticed was that none of the fonts was using ISO
initializers for it's fonts.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/font_10x18.c     |   14 +++++++-------
 drivers/video/console/font_6x11.c      |   13 +++++++------
 drivers/video/console/font_7x14.c      |   12 ++++++------
 drivers/video/console/font_8x16.c      |   12 ++++++------
 drivers/video/console/font_8x8.c       |   12 ++++++------
 drivers/video/console/font_acorn_8x8.c |   14 +++++++-------
 drivers/video/console/font_mini_4x6.c  |   12 ++++++------
 drivers/video/console/font_pearl_8x8.c |   12 ++++++------
 drivers/video/console/font_sun12x22.c  |   14 +++++++-------
 drivers/video/console/font_sun8x16.c   |   14 +++++++-------
 10 files changed, 65 insertions(+), 64 deletions(-)

diff -puN drivers/video/console/font_10x18.c~fbcon-convert-struct-font_desc-to-use-iso-c-initializers drivers/video/console/font_10x18.c
--- a/drivers/video/console/font_10x18.c~fbcon-convert-struct-font_desc-to-use-iso-c-initializers
+++ a/drivers/video/console/font_10x18.c
@@ -5133,14 +5133,14 @@ static const unsigned char fontdata_10x1
 
 
 const struct font_desc font_10x18 = {
-	FONT10x18_IDX,
-	"10x18",
-	10,
-	18,
-	fontdata_10x18,
+	.idx	= FONT10x18_IDX,
+	.name	= "10x18",
+	.width	= 10,
+	.height	= 18,
+	.data	= fontdata_10x18,
 #ifdef __sparc__
-	5
+	.pref	= 5,
 #else
-	-1
+	.pref	= -1,
 #endif
 };
diff -puN drivers/video/console/font_6x11.c~fbcon-convert-struct-font_desc-to-use-iso-c-initializers drivers/video/console/font_6x11.c
--- a/drivers/video/console/font_6x11.c~fbcon-convert-struct-font_desc-to-use-iso-c-initializers
+++ a/drivers/video/console/font_6x11.c
@@ -3342,10 +3342,11 @@ static const unsigned char fontdata_6x11
 
 
 const struct font_desc font_vga_6x11 = {
-	VGA6x11_IDX,
-	"ProFont6x11",
-	6,
-	11,
-	fontdata_6x11,
-	-2000	/* Try avoiding this font if possible unless on MAC */
+	.idx	= VGA6x11_IDX,
+	.name	= "ProFont6x11",
+	.width	= 6,
+	.height	= 11,
+	.data	= fontdata_6x11,
+	/* Try avoiding this font if possible unless on MAC */
+	.pref	= -2000,
 };
diff -puN drivers/video/console/font_7x14.c~fbcon-convert-struct-font_desc-to-use-iso-c-initializers drivers/video/console/font_7x14.c
--- a/drivers/video/console/font_7x14.c~fbcon-convert-struct-font_desc-to-use-iso-c-initializers
+++ a/drivers/video/console/font_7x14.c
@@ -4109,10 +4109,10 @@ static const unsigned char fontdata_7x14
 
 
 const struct font_desc font_7x14 = {
-	FONT7x14_IDX,
-	"7x14",
-	7,
-	14,
-	fontdata_7x14,
-	0
+	.idx	= FONT7x14_IDX,
+	.name	= "7x14",
+	.width	= 7,
+	.height	= 14,
+	.data	= fontdata_7x14,
+	.pref	= 0,
 };
diff -puN drivers/video/console/font_8x16.c~fbcon-convert-struct-font_desc-to-use-iso-c-initializers drivers/video/console/font_8x16.c
--- a/drivers/video/console/font_8x16.c~fbcon-convert-struct-font_desc-to-use-iso-c-initializers
+++ a/drivers/video/console/font_8x16.c
@@ -4622,10 +4622,10 @@ static const unsigned char fontdata_8x16
 
 
 const struct font_desc font_vga_8x16 = {
-	VGA8x16_IDX,
-	"VGA8x16",
-	8,
-	16,
-	fontdata_8x16,
-	0
+	.idx	= VGA8x16_IDX,
+	.name	= "VGA8x16",
+	.width	= 8,
+	.height	= 16,
+	.data	= fontdata_8x16,
+	.pref	= 0,
 };
diff -puN drivers/video/console/font_8x8.c~fbcon-convert-struct-font_desc-to-use-iso-c-initializers drivers/video/console/font_8x8.c
--- a/drivers/video/console/font_8x8.c~fbcon-convert-struct-font_desc-to-use-iso-c-initializers
+++ a/drivers/video/console/font_8x8.c
@@ -2574,10 +2574,10 @@ static const unsigned char fontdata_8x8[
 
 
 const struct font_desc font_vga_8x8 = {
-	VGA8x8_IDX,
-	"VGA8x8",
-	8,
-	8,
-	fontdata_8x8,
-	0
+	.idx	= VGA8x8_IDX,
+	.name	= "VGA8x8",
+	.width	= 8,
+	.height	= 8,
+	.data	= fontdata_8x8,
+	.pref	= 0,
 };
diff -puN drivers/video/console/font_acorn_8x8.c~fbcon-convert-struct-font_desc-to-use-iso-c-initializers drivers/video/console/font_acorn_8x8.c
--- a/drivers/video/console/font_acorn_8x8.c~fbcon-convert-struct-font_desc-to-use-iso-c-initializers
+++ a/drivers/video/console/font_acorn_8x8.c
@@ -262,14 +262,14 @@ static const unsigned char acorndata_8x8
 };
 
 const struct font_desc font_acorn_8x8 = {
-	ACORN8x8_IDX,
-	"Acorn8x8",
-	8,
-	8,
-	acorndata_8x8,
+	.idx	= ACORN8x8_IDX,
+	.name	= "Acorn8x8",
+	.width	= 8,
+	.height	= 8,
+	.data	= acorndata_8x8,
 #ifdef CONFIG_ARCH_ACORN
-	20
+	.pref	= 20,
 #else
-	0
+	.pref	= 0,
 #endif
 };
diff -puN drivers/video/console/font_mini_4x6.c~fbcon-convert-struct-font_desc-to-use-iso-c-initializers drivers/video/console/font_mini_4x6.c
--- a/drivers/video/console/font_mini_4x6.c~fbcon-convert-struct-font_desc-to-use-iso-c-initializers
+++ a/drivers/video/console/font_mini_4x6.c
@@ -2148,11 +2148,11 @@ static const unsigned char fontdata_mini
 };
 
 const struct font_desc font_mini_4x6 = {
-	MINI4x6_IDX,
-	"MINI4x6",
-	4,
-	6,
-	fontdata_mini_4x6,
-	3
+	.idx	= MINI4x6_IDX,
+	.name	= "MINI4x6",
+	.width	= 4,
+	.height	= 6,
+	.data	= fontdata_mini_4x6,
+	.pref	= 3,
 };
 
diff -puN drivers/video/console/font_pearl_8x8.c~fbcon-convert-struct-font_desc-to-use-iso-c-initializers drivers/video/console/font_pearl_8x8.c
--- a/drivers/video/console/font_pearl_8x8.c~fbcon-convert-struct-font_desc-to-use-iso-c-initializers
+++ a/drivers/video/console/font_pearl_8x8.c
@@ -2578,10 +2578,10 @@ static const unsigned char fontdata_pear
 };
 
 const struct font_desc font_pearl_8x8 = {
-	PEARL8x8_IDX,
-	"PEARL8x8",
-	8,
-	8,
-	fontdata_pearl8x8,
-	2
+	.idx	= PEARL8x8_IDX,
+	.name	= "PEARL8x8",
+	.width	= 8,
+	.height	= 8,
+	.data	= fontdata_pearl8x8,
+	.pref	= 2,
 };
diff -puN drivers/video/console/font_sun12x22.c~fbcon-convert-struct-font_desc-to-use-iso-c-initializers drivers/video/console/font_sun12x22.c
--- a/drivers/video/console/font_sun12x22.c~fbcon-convert-struct-font_desc-to-use-iso-c-initializers
+++ a/drivers/video/console/font_sun12x22.c
@@ -6152,14 +6152,14 @@ static const unsigned char fontdata_sun1
 
 
 const struct font_desc font_sun_12x22 = {
-	SUN12x22_IDX,
-	"SUN12x22",
-	12,
-	22,
-	fontdata_sun12x22,
+	.idx	= SUN12x22_IDX,
+	.name	= "SUN12x22",
+	.width	= 12,
+	.height	= 22,
+	.data	= fontdata_sun12x22,
 #ifdef __sparc__
-	5
+	.pref	= 5,
 #else
-	-1
+	.pref	= -1,
 #endif
 };
diff -puN drivers/video/console/font_sun8x16.c~fbcon-convert-struct-font_desc-to-use-iso-c-initializers drivers/video/console/font_sun8x16.c
--- a/drivers/video/console/font_sun8x16.c~fbcon-convert-struct-font_desc-to-use-iso-c-initializers
+++ a/drivers/video/console/font_sun8x16.c
@@ -262,14 +262,14 @@ static const unsigned char fontdata_sun8
 };
 
 const struct font_desc font_sun_8x16 = {
-	SUN8x16_IDX,
-	"SUN8x16",
-	8,
-	16,
-	fontdata_sun8x16,
+	.idx	= SUN8x16_IDX,
+	.name	= "SUN8x16",
+	.width	= 8,
+	.height	= 16,
+	.data	= fontdata_sun8x16,
 #ifdef __sparc__
-	10
+	.pref	= 10,
 #else
-	-1
+	.pref	= -1,
 #endif
 };
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
clean-up-duplicate-includes-in-drivers-char.patch
spelling-fix-weired-weird.patch
remove-dma_cache_wbackinvwback_inv-functions.patch
lk201-remove-obsolete-driver.patch
fix-wrong-filename-reference-in-drivers-testingtxt.patch
completely-remove-deprecated-irq-flags-sa_.patch
compile-handle_percpu_irq-even-for-uniprocessor-kernels.patch
break-elf_platform-and-stack-pointer-randomization-dependency.patch
add-a-00-index-file-to-documentation-mips.patch
define-global-bit-macro.patch
bitops-introduce-lock-ops.patch
mips-fix-bitops.patch
mips-lock-bitops.patch
replace-__attribute_pure__-with-__pure.patch
