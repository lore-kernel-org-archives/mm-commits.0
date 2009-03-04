From: akpm@linux-foundation.org
Subject: [folded] nand-fix-raw-reads-with-ecc-syndrome-layouts-cleanups.patch removed from -mm tree
Date: Wed, 04 Mar 2009 12:00:41 -0800
Message-ID: <200903042000.n24K0fta028674@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47333 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756826AbZCDUBj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2009 15:01:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbrownell@users.sourceforge.net, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Cosmetic fixes to the patch fixing raw HW_SYNDROME read/write.
has been removed from the -mm tree.  Its filename was
     nand-fix-raw-reads-with-ecc-syndrome-layouts-cleanups.patch

This patch was dropped because it was folded into nand-fix-raw-reads-with-ecc-syndrome-layouts.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Cosmetic fixes to the patch fixing raw HW_SYNDROME read/write.
From: David Brownell <dbrownell@users.sourceforge.net>

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/nand_base.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff -puN drivers/mtd/nand/nand_base.c~nand-fix-raw-reads-with-ecc-syndrome-layouts-cleanups drivers/mtd/nand/nand_base.c
--- a/drivers/mtd/nand/nand_base.c~nand-fix-raw-reads-with-ecc-syndrome-layouts-cleanups
+++ a/drivers/mtd/nand/nand_base.c
@@ -773,10 +773,9 @@ static int nand_read_page_raw_syndrome(s
 	int eccsize = chip->ecc.size;
 	int eccbytes = chip->ecc.bytes;
 	uint8_t *oob = chip->oob_poi;
-	int temp;
+	int steps, size;
 
-	temp = chip->ecc.steps;
-	do {
+	for (steps = chip->ecc.steps; steps > 0; steps--) {
 		chip->read_buf(mtd, buf, eccsize);
 		buf += eccsize;
 
@@ -792,11 +791,11 @@ static int nand_read_page_raw_syndrome(s
 			chip->read_buf(mtd, oob, chip->ecc.postpad);
 			oob += chip->ecc.postpad;
 		}
-	} while (--temp);
+	}
 
-	temp = mtd->oobsize - (oob - chip->oob_poi);
-	if (temp)
-		chip->read_buf(mtd, oob, temp);
+	size = mtd->oobsize - (oob - chip->oob_poi);
+	if (size)
+		chip->read_buf(mtd, oob, size);
 
 	return 0;
 }
@@ -1542,7 +1541,7 @@ static void nand_write_page_raw(struct m
  * @chip:	nand chip info structure
  * @buf:	data buffer
  *
- * We need a special oob layout and handling even when ECC isn't used.
+ * We need a special oob layout and handling even when ECC isn't checked.
  */
 static void nand_write_page_raw_syndrome(struct mtd_info *mtd, struct nand_chip *chip,
 				const uint8_t *buf)
@@ -1550,10 +1549,9 @@ static void nand_write_page_raw_syndrome
 	int eccsize = chip->ecc.size;
 	int eccbytes = chip->ecc.bytes;
 	uint8_t *oob = chip->oob_poi;
-	int temp;
+	int steps, size;
 
-	temp = chip->ecc.steps;
-	do {
+	for (steps = chip->ecc.steps; steps > 0; steps--) {
 		chip->write_buf(mtd, buf, eccsize);
 		buf += eccsize;
 
@@ -1569,11 +1567,11 @@ static void nand_write_page_raw_syndrome
 			chip->write_buf(mtd, oob, chip->ecc.postpad);
 			oob += chip->ecc.postpad;
 		}
-	} while (--temp);
+	}
 
-	temp = mtd->oobsize - (oob - chip->oob_poi);
-	if (temp)
-		chip->write_buf(mtd, oob, temp);
+	size = mtd->oobsize - (oob - chip->oob_poi);
+	if (size)
+		chip->write_buf(mtd, oob, size);
 }
 /**
  * nand_write_page_swecc - [REPLACABLE] software ecc based page write function
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

linux-next.patch
nand-fix-raw-reads-with-ecc-syndrome-layouts.patch
nand-fix-raw-reads-with-ecc-syndrome-layouts-cleanups.patch
nand-davinci_nand-driver.patch
nand-fix-broken-debug-messages.patch
mtd-we-dont-need-no-misc-devices.patch
mtd-partitioning-utility-predicates.patch
blackfin-spi-driver-fix-erroneous-spi-clock-divisor-calculation.patch
blackfin-spi-driver-remove-useless-asm-cplbinith.patch
blackfin-spi-driver-use-len_in_bytes-when-we-care-about-the-number-of-bytes-transferred.patch
blackfin-spi-driver-pass-dma-overflow-error-to-the-higher-level.patch
blackfin-spi-driver-unify-duplicated-code-in-dma-read-write-paths.patch
blackfin-spi-driver-drop-bogus-cast-and-touchup-dma-label.patch
blackfin-spi-driver-get-dma-working-for-spi-flashes.patch
blackfin-spi-driver-fix-bug-spi-controller-driver-does-not-assert-deassert-cs-correctly.patch
blackfin-spi-driver-fix-bug-correct-usage-of-struct-spi_transfercs_change.patch
spi-limit-reaches-1-tested-0.patch
rtc-ds1307-true-smbus-compatibility.patch
gpio-gpio_requestfree-now-required-feature-removal.patch

