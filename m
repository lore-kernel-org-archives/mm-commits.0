From: akpm@linux-foundation.org
Subject: [merged] mtd-nand-dont-walk-past-end-of-oobfree.patch removed from -mm tree
Date: Tue, 09 Jun 2009 11:11:59 -0700
Message-ID: <200906091811.n59IBxKe018243@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38248 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757568AbZFISMT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jun 2009 14:12:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbrownell@users.sourceforge.net, dwmw2@infradead.org, nsnehaprabha@ti.com, mm-commits@vger.kernel.org


The patch titled
     mtd: nand: don't walk past end of oobfree[]
has been removed from the -mm tree.  Its filename was
     mtd-nand-dont-walk-past-end-of-oobfree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd: nand: don't walk past end of oobfree[]
From: David Brownell <dbrownell@users.sourceforge.net>

Resolve issue noted by Sneha: when computing oobavail from the list of
free areas in the OOB, don't assume there will always be an unused slot at
the end.  With ECC_HW_SYNDROME and 4KB page chips, it's fairly likely
there *won't* be one.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: "Narnakaje, Snehaprabha" <nsnehaprabha@ti.com>"
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/nand_base.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/mtd/nand/nand_base.c~mtd-nand-dont-walk-past-end-of-oobfree drivers/mtd/nand/nand_base.c
--- a/drivers/mtd/nand/nand_base.c~mtd-nand-dont-walk-past-end-of-oobfree
+++ a/drivers/mtd/nand/nand_base.c
@@ -2756,7 +2756,8 @@ int nand_scan_tail(struct mtd_info *mtd)
 	 * the out of band area
 	 */
 	chip->ecc.layout->oobavail = 0;
-	for (i = 0; chip->ecc.layout->oobfree[i].length; i++)
+	for (i = 0; chip->ecc.layout->oobfree[i].length
+			&& i < ARRAY_SIZE(chip->ecc.layout->oobfree); i++)
 		chip->ecc.layout->oobavail +=
 			chip->ecc.layout->oobfree[i].length;
 	mtd->oobavail = chip->ecc.layout->oobavail;
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

