From: akpm@linux-foundation.org
Subject: + atmel_lcdfb-validate-display-timings.patch added to -mm tree
Date: Wed, 05 Dec 2007 15:51:50 -0800
Message-ID: <200712052351.lB5Npol6031282@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48734 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751004AbXLEXwc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Dec 2007 18:52:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hskinnemoen@atmel.com, adaplas@pol.net


The patch titled
     atmel_lcdfb: validate display timings
has been added to the -mm tree.  Its filename is
     atmel_lcdfb-validate-display-timings.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: atmel_lcdfb: validate display timings
From: Haavard Skinnemoen <hskinnemoen@atmel.com>

Setting a display timing parameter too high or too low may cause it to
wrap around and thus become completely wrong. Validate the timings in
atmel_lcdfb_check_var() and saturate to the highest or lowest possible
value if necessary.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/atmel_lcdfb.c |   20 ++++++++++++++++++++
 include/video/atmel_lcdc.h  |   14 +++++++-------
 2 files changed, 27 insertions(+), 7 deletions(-)

diff -puN drivers/video/atmel_lcdfb.c~atmel_lcdfb-validate-display-timings drivers/video/atmel_lcdfb.c
--- a/drivers/video/atmel_lcdfb.c~atmel_lcdfb-validate-display-timings
+++ a/drivers/video/atmel_lcdfb.c
@@ -203,6 +203,26 @@ static int atmel_lcdfb_check_var(struct 
 	var->transp.offset = var->transp.length = 0;
 	var->xoffset = var->yoffset = 0;
 
+	/* Saturate vertical and horizontal timings at maximum values */
+	var->vsync_len = min_t(u32, var->vsync_len,
+			(ATMEL_LCDC_VPW >> ATMEL_LCDC_VPW_OFFSET) + 1);
+	var->upper_margin = min_t(u32, var->upper_margin,
+			ATMEL_LCDC_VBP >> ATMEL_LCDC_VBP_OFFSET);
+	var->lower_margin = min_t(u32, var->lower_margin,
+			ATMEL_LCDC_VFP);
+	var->right_margin = min_t(u32, var->right_margin,
+			(ATMEL_LCDC_HFP >> ATMEL_LCDC_HFP_OFFSET) + 1);
+	var->hsync_len = min_t(u32, var->hsync_len,
+			(ATMEL_LCDC_HPW >> ATMEL_LCDC_HPW_OFFSET) + 1);
+	var->left_margin = min_t(u32, var->left_margin,
+			ATMEL_LCDC_HBP + 1);
+
+	/* Some parameters can't be zero */
+	var->vsync_len = max_t(u32, var->vsync_len, 1);
+	var->right_margin = max_t(u32, var->right_margin, 1);
+	var->hsync_len = max_t(u32, var->hsync_len, 1);
+	var->left_margin = max_t(u32, var->left_margin, 1);
+
 	switch (var->bits_per_pixel) {
 	case 1:
 	case 2:
diff -puN include/video/atmel_lcdc.h~atmel_lcdfb-validate-display-timings include/video/atmel_lcdc.h
--- a/include/video/atmel_lcdc.h~atmel_lcdfb-validate-display-timings
+++ a/include/video/atmel_lcdc.h
@@ -115,20 +115,20 @@ struct atmel_lcdfb_info {
 #define		ATMEL_LCDC_MEMOR_LITTLE		(1 << 31)
 
 #define ATMEL_LCDC_TIM1		0x0808
-#define	ATMEL_LCDC_VFP		(0xff <<  0)
+#define	ATMEL_LCDC_VFP		(0xffU <<  0)
 #define	ATMEL_LCDC_VBP_OFFSET		8
-#define	ATMEL_LCDC_VBP		(0xff <<  ATMEL_LCDC_VBP_OFFSET)
+#define	ATMEL_LCDC_VBP		(0xffU <<  ATMEL_LCDC_VBP_OFFSET)
 #define	ATMEL_LCDC_VPW_OFFSET		16
-#define	ATMEL_LCDC_VPW		(0x3f << ATMEL_LCDC_VPW_OFFSET)
+#define	ATMEL_LCDC_VPW		(0x3fU << ATMEL_LCDC_VPW_OFFSET)
 #define	ATMEL_LCDC_VHDLY_OFFSET		24
-#define	ATMEL_LCDC_VHDLY	(0xf  << ATMEL_LCDC_VHDLY_OFFSET)
+#define	ATMEL_LCDC_VHDLY	(0xfU  << ATMEL_LCDC_VHDLY_OFFSET)
 
 #define ATMEL_LCDC_TIM2		0x080c
-#define	ATMEL_LCDC_HBP		(0xff  <<  0)
+#define	ATMEL_LCDC_HBP		(0xffU  <<  0)
 #define	ATMEL_LCDC_HPW_OFFSET		8
-#define	ATMEL_LCDC_HPW		(0x3f  <<  ATMEL_LCDC_HPW_OFFSET)
+#define	ATMEL_LCDC_HPW		(0x3fU  <<  ATMEL_LCDC_HPW_OFFSET)
 #define	ATMEL_LCDC_HFP_OFFSET		21
-#define	ATMEL_LCDC_HFP		(0x7ff << ATMEL_LCDC_HFP_OFFSET)
+#define	ATMEL_LCDC_HFP		(0x7ffU << ATMEL_LCDC_HFP_OFFSET)
 
 #define ATMEL_LCDC_LCDFRMCFG	0x0810
 #define	ATMEL_LCDC_LINEVAL	(0x7ff <<  0)
_

Patches currently in -mm which might be from hskinnemoen@atmel.com are

git-avr32.patch
git-avr32-fixup.patch
git-mtd.patch
read_current_time-cleanups.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
atmel_spi-throughput-improvement.patch
atmel_spi-chain-dma-transfers.patch
atmel_spi-fix-dmachain-oops-with-debug-enabled.patch
generic-gpio-gpio_chip-support.patch
avr32-uses-gpio_chip.patch
mcp23s08-spi-gpio-expander.patch
mcp23s08-spi-gpio-expander-checkpatch-fixes.patch
atmel_lcdfb-validate-display-timings.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg_local-to-avr32.patch
tty-let-architectures-override-the-user-kernel-macros.patch
