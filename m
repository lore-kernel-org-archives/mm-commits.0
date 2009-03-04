From: akpm@linux-foundation.org
Subject: [folded] nand-davinci_nand-driver-fixes.patch removed from -mm tree
Date: Wed, 04 Mar 2009 11:48:53 -0800
Message-ID: <200903041948.n24JmrJP027330@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38977 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755880AbZCDTtM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2009 14:49:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     nand-davinci_nand-driver-fixes
has been removed from the -mm tree.  Its filename was
     nand-davinci_nand-driver-fixes.patch

This patch was dropped because it was folded into nand-davinci_nand-driver.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nand-davinci_nand-driver-fixes
From: David Brownell <david-b@pacbell.net>

Minor fixes to the davinci-nand driver patch.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/davinci_nand.c |   35 +++++++++++++-----------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff -puN drivers/mtd/nand/davinci_nand.c~nand-davinci_nand-driver-fixes drivers/mtd/nand/davinci_nand.c
--- a/drivers/mtd/nand/davinci_nand.c~nand-davinci_nand-driver-fixes
+++ a/drivers/mtd/nand/davinci_nand.c
@@ -161,7 +161,7 @@ static inline u32 nand_davinci_readecc_1
 static void nand_davinci_hwctl_1bit(struct mtd_info *mtd, int mode)
 {
 	struct davinci_nand_info *info;
-	u32 retval;
+	u32 nandcfr;
 	unsigned long flags;
 
 	info = to_davinci_nand(mtd);
@@ -172,9 +172,9 @@ static void nand_davinci_hwctl_1bit(stru
 	spin_lock_irqsave(&davinci_nand_lock, flags);
 
 	/* Restart ECC hardware */
-	retval = davinci_nand_readl(info, NANDFCR_OFFSET);
-	retval |= BIT(8 + info->core_chipsel);
-	davinci_nand_writel(info, NANDFCR_OFFSET, retval);
+	nandcfr = davinci_nand_readl(info, NANDFCR_OFFSET);
+	nandcfr |= BIT(8 + info->core_chipsel);
+	davinci_nand_writel(info, NANDFCR_OFFSET, nandcfr);
 
 	spin_unlock_irqrestore(&davinci_nand_lock, flags);
 }
@@ -186,13 +186,13 @@ static int nand_davinci_calculate_1bit(s
 				      const u_char *dat, u_char *ecc_code)
 {
 	unsigned int ecc_val = nand_davinci_readecc_1bit(mtd);
-	unsigned int tmp = (ecc_val & 0x0fff) | ((ecc_val & 0x0fff0000) >> 4);
+	unsigned int ecc24 = (ecc_val & 0x0fff) | ((ecc_val & 0x0fff0000) >> 4);
 
 	/* invert so that erased block ecc is correct */
-	tmp = ~tmp;
-	ecc_code[0] = (u_char)(tmp);
-	ecc_code[1] = (u_char)(tmp >> 8);
-	ecc_code[2] = (u_char)(tmp >> 16);
+	ecc24 = ~ecc24;
+	ecc_code[0] = (u_char)(ecc24);
+	ecc_code[1] = (u_char)(ecc24 >> 8);
+	ecc_code[2] = (u_char)(ecc24 >> 16);
 
 	return 0;
 }
@@ -278,7 +278,7 @@ static int nand_davinci_dev_ready(struct
 
 static void __init nand_dm6446evm_flash_init(struct davinci_nand_info *info)
 {
-	u32 regval, tmp;
+	u32 regval, a1cr;
 
 	/*
 	 * NAND FLASH timings @ PLL1 == 459 MHz
@@ -297,11 +297,11 @@ static void __init nand_dm6446evm_flash_
 		| (3 << 2)            /* turnAround      ?? ns */
 		| (0 << 0)            /* asyncSize       8-bit bus */
 		;
-	tmp = davinci_nand_readl(info, A1CR_OFFSET);
-	if (tmp != regval) {
+	a1cr = davinci_nand_readl(info, A1CR_OFFSET);
+	if (a1cr != regval) {
 		dev_dbg(info->dev, "Warning: NAND config: Set A1CR " \
 		       "reg to 0x%08x, was 0x%08x, should be done by " \
-		       "bootloader.\n", regval, tmp);
+		       "bootloader.\n", regval, a1cr);
 		davinci_nand_writel(info, A1CR_OFFSET, regval);
 	}
 }
@@ -338,7 +338,7 @@ static int __init nand_davinci_probe(str
 	if (!res1 || !res2) {
 		dev_err(&pdev->dev, "resource missing\n");
 		ret = -EINVAL;
-		goto err_res;
+		goto err_nomem;
 	}
 
 	vaddr = ioremap(res1->start, res1->end - res1->start);
@@ -347,7 +347,6 @@ static int __init nand_davinci_probe(str
 		dev_err(&pdev->dev, "ioremap failed\n");
 		ret = -EINVAL;
 		goto err_ioremap;
-
 	}
 
 	info->dev		= &pdev->dev;
@@ -525,16 +524,14 @@ err_clk_enable:
 
 err_ecc:
 err_clk:
+err_ioremap:
 	if (base)
 		iounmap(base);
 	if (vaddr)
 		iounmap(vaddr);
 
-err_ioremap:
-	kfree(info);
-
 err_nomem:
-err_res:
+	kfree(info);
 	return ret;
 }
 
_

Patches currently in -mm which might be from david-b@pacbell.net are

linux-next.patch
early-platform-driver-v3.patch
input-ads7846-introduce-platform-specific-way-to-synchronize-sampling.patch
nand-davinci_nand-driver.patch
nand-davinci_nand-driver-fixes.patch
mtd-nand-drop-usage-of-cpu_is_-macro.patch
rtc-add-ds1685-ds1687-rtc-driver.patch
bcm47xx-fix-gpio-api-return-codes.patch
spi_mpc83xx-fix-sparse-warnings.patch
spi_mpc83xx-rework-chip-selects-handling.patch
spi_mpc83xx-add-of-platform-driver-bindings.patch
powerpc-add-mmc-spi-slot-bindings.patch
powerpc-83xx-add-mmc-spi-support-via-the-device-tree-for-mpc8323e-rdb.patch
powerpc-fsl_soc-isolate-legacy-fsl_spi-support-to-mpc832x_rdb-boards.patch
blackfin-spi-driver-ensure-cache-coherency-before-doing-dma.patch
blackfin-spi-driver-fix-erroneous-spi-clock-divisor-calculation.patch
blackfin-spi-driver-remove-useless-asm-cplbinith.patch
blackfin-spi-driver-use-len_in_bytes-when-we-care-about-the-number-of-bytes-transferred.patch
blackfin-spi-driver-pass-dma-overflow-error-to-the-higher-level.patch
blackfin-spi-driver-unify-duplicated-code-in-dma-read-write-paths.patch
blackfin-spi-driver-drop-bogus-cast-and-touchup-dma-label.patch
blackfin-spi-driver-add-a-few-more-dma-debug-messages.patch
blackfin-spi-driver-do-not-check-for-spi-errors-if-dma-itself-did-not-flag-any.patch
blackfin-spi-driver-use-the-properl-bit_ctl_xxx-defines.patch
blackfin-spi-driver-spi-slave-select-code-cleanup.patch
blackfin-spi-driver-get-dma-working-for-spi-flashes.patch
blackfin-spi-driver-add-timeout-while-waiting-for-spif-in-dma-irq-handler.patch
blackfin-spi-driver-tweak-magic-spi-dma-sequence-to-get-it-working-on-bf54x.patch
blackfin-spi-driver-fix-bug-spi-controller-driver-does-not-assert-deassert-cs-correctly.patch
blackfin-spi-driver-fix-bug-correct-usage-of-struct-spi_transfercs_change.patch
blackfin-spi-driver-use-bfin_spi_-prefix-on-all-functions.patch
blackfin-spi-driver-fix-null-pointer-crash.patch
blackfin-spi-driver-add-gpio-controlled-spi-slave-select-support.patch
blackfin-spi-driver-make-mmc_spi-driver-work-on-blackfin.patch
spi-pxa2xx_spi-introduces-chipselect-gpio-to-simplify-the-common-cases.patch
spi_bfin5xx-remove-unused-is_dma_aligned-macro.patch
spi-add-dma_alignment-field-to-spi_master.patch
pxa2xx_spi-set-spi_masterdma_alignment-=-8.patch
spi_imx-set-spi_masterdma_alignment-=-4.patch
rtc-convert-wm8350-use-new-alarm-and-update-operations.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi.patch
rtc-add-platform-driver-for-efi-fix.patch
rtc-add-epson-rx8025-support-to-ds1307-rtc-driver.patch
rtc-v3020-coding-style-cleanup.patch
rtc-v3020-add-ability-to-access-v3020-chip-with-gpios.patch
rtc-v3020-add-ability-to-access-v3020-chip-with-gpios-fix.patch
rtc-test-before-subtraction-on-unsigned.patch
rtc-test-before-subtraction-on-unsigned-fix.patch
gpiolib-allow-gpios-to-be-named.patch
cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support.patch
alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization.patch
spi-gpio-allow-operation-without-cs-signal.patch

