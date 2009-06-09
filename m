From: akpm@linux-foundation.org
Subject: [merged] mtd-nand-minor-davinci_nand-cleanup.patch removed from -mm tree
Date: Tue, 09 Jun 2009 11:12:01 -0700
Message-ID: <200906091812.n59IC1Aq018329@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58302 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758810AbZFISMT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jun 2009 14:12:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbrownell@users.sourceforge.net, dwmw2@infradead.org, khilman@deeprootsystems.com, mm-commits@vger.kernel.org


The patch titled
     mtd: nand: minor davinci_nand cleanup
has been removed from the -mm tree.  Its filename was
     mtd-nand-minor-davinci_nand-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd: nand: minor davinci_nand cleanup
From: David Brownell <dbrownell@users.sourceforge.net>

Make the DaVinci NAND driver require platform_data with board-specific
configuration.  We can't actually do any kind of sane job of configuring
it otherwise.

Also fix the comment about picking the "best" ECC mode.

We can't do those any more; that relied on knowing what kind of CPU we're
using (they don't all support 4-bit ECC), and current policy is that
drivers not have cpu_is_*() checks.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Acked-by: Kevin Hilman <khilman@deeprootsystems.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/davinci_nand.c |   27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff -puN drivers/mtd/nand/davinci_nand.c~mtd-nand-minor-davinci_nand-cleanup drivers/mtd/nand/davinci_nand.c
--- a/drivers/mtd/nand/davinci_nand.c~mtd-nand-minor-davinci_nand-cleanup
+++ a/drivers/mtd/nand/davinci_nand.c
@@ -306,6 +306,10 @@ static int __init nand_davinci_probe(str
 	uint32_t			val;
 	nand_ecc_modes_t		ecc_mode;
 
+	/* insist on board-specific configuration */
+	if (!pdata)
+		return -ENODEV;
+
 	/* which external chipselect will we be managing? */
 	if (pdev->id < 0 || pdev->id > 3)
 		return -ENODEV;
@@ -351,7 +355,7 @@ static int __init nand_davinci_probe(str
 	info->chip.select_chip	= nand_davinci_select_chip;
 
 	/* options such as NAND_USE_FLASH_BBT or 16-bit widths */
-	info->chip.options	= pdata ? pdata->options : 0;
+	info->chip.options	= pdata->options;
 
 	info->ioaddr		= (uint32_t __force) vaddr;
 
@@ -360,14 +364,8 @@ static int __init nand_davinci_probe(str
 	info->mask_chipsel	= pdata->mask_chipsel;
 
 	/* use nandboot-capable ALE/CLE masks by default */
-	if (pdata && pdata->mask_ale)
-		info->mask_ale	= pdata->mask_cle;
-	else
-		info->mask_ale	= MASK_ALE;
-	if (pdata && pdata->mask_cle)
-		info->mask_cle	= pdata->mask_cle;
-	else
-		info->mask_cle	= MASK_CLE;
+	info->mask_ale		= pdata->mask_cle ? : MASK_ALE;
+	info->mask_cle		= pdata->mask_cle ? : MASK_CLE;
 
 	/* Set address of hardware control function */
 	info->chip.cmd_ctrl	= nand_davinci_hwcontrol;
@@ -377,11 +375,8 @@ static int __init nand_davinci_probe(str
 	info->chip.read_buf     = nand_davinci_read_buf;
 	info->chip.write_buf    = nand_davinci_write_buf;
 
-	/* use board-specific ECC config; else, the best available */
-	if (pdata)
-		ecc_mode = pdata->ecc_mode;
-	else
-		ecc_mode = NAND_ECC_HW;
+	/* Use board-specific ECC config */
+	ecc_mode		= pdata->ecc_mode;
 
 	switch (ecc_mode) {
 	case NAND_ECC_NONE:
@@ -469,7 +464,7 @@ static int __init nand_davinci_probe(str
 			info->mtd.name = master_name;
 		}
 
-		if (mtd_parts_nb <= 0 && pdata) {
+		if (mtd_parts_nb <= 0) {
 			mtd_parts = pdata->parts;
 			mtd_parts_nb = pdata->nr_parts;
 		}
@@ -482,7 +477,7 @@ static int __init nand_davinci_probe(str
 				info->partitioned = true;
 		}
 
-	} else if (pdata && pdata->nr_parts) {
+	} else if (pdata->nr_parts) {
 		dev_warn(&pdev->dev, "ignoring %d default partitions on %s\n",
 				pdata->nr_parts, info->mtd.name);
 	}
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

origin.patch
linux-next.patch
mmc_spi-use-eilseq-for-possible-transmission-errors.patch
spi_bfin5xx-limit-reaches-1.patch
spi-move-common-spi_setup-functionality-into-core.patch
spi-move-more-spi_setup-functionality-into-core.patch
mpc52xx_psc_spi-convert-to-cs_control-callback.patch
pxa2xx_spi-fix-for-spi_cs_high.patch
rtc-rtc-ds1307-add-ds3231.patch

