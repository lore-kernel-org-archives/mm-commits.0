From: akpm@linux-foundation.org
Subject: [merged] nand-fix-raw-reads-with-ecc-syndrome-layouts.patch removed from -mm tree
Date: Mon, 30 Mar 2009 12:05:51 -0700
Message-ID: <200903301905.n2UJ5p8D018785@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52866 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757986AbZC3TKH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 15:10:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbrownell@users.sourceforge.net, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     NAND: fix "raw" reads with ECC syndrome layouts
has been removed from the -mm tree.  Its filename was
     nand-fix-raw-reads-with-ecc-syndrome-layouts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: NAND: fix "raw" reads with ECC syndrome layouts
From: David Brownell <dbrownell@users.sourceforge.net>

The syndrome based page read/write routines store ECC, and possibly other
"OOB" data, right after each chunk of ECC'd data.  With ECC chunk size of
512 bytes and a large page (2KB) NAND, the layout is:

  data-0 OOB-0 data-1 OOB-1 data-2 OOB-2 data-3 OOB-3 OOB-leftover

Where OOBx is (prepad, ECC, postpad).  However, the current "raw" routines
use a traditional layout -- data OOB, disregarding the prepad and postpad
values -- so when they're used with that type of ECC hardware, those calls
mix up the data and OOB.  Which means, in particular, that bad block
tables won't be found on startup, with data corruption and related chaos
ensuing.

The current syndrome-based drivers in mainline all seem to use one chunk
per page; presumably they haven't noticed such bugs.

Fix this, by adding read/write page_raw_syndrome() routines as siblings of
the existing non-raw routines; "raw" just means to bypass the ECC
computations, not change data and OOB layout.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/nand_base.c |   99 +++++++++++++++++++++++++++++++--
 1 file changed, 95 insertions(+), 4 deletions(-)

diff -puN drivers/mtd/nand/nand_base.c~nand-fix-raw-reads-with-ecc-syndrome-layouts drivers/mtd/nand/nand_base.c
--- a/drivers/mtd/nand/nand_base.c~nand-fix-raw-reads-with-ecc-syndrome-layouts
+++ a/drivers/mtd/nand/nand_base.c
@@ -748,6 +748,8 @@ static int nand_wait(struct mtd_info *mt
  * @mtd:	mtd info structure
  * @chip:	nand chip info structure
  * @buf:	buffer to store read data
+ *
+ * Not for syndrome calculating ecc controllers, which use a special oob layout
  */
 static int nand_read_page_raw(struct mtd_info *mtd, struct nand_chip *chip,
 			      uint8_t *buf)
@@ -758,6 +760,47 @@ static int nand_read_page_raw(struct mtd
 }
 
 /**
+ * nand_read_page_raw_syndrome - [Intern] read raw page data without ecc
+ * @mtd:	mtd info structure
+ * @chip:	nand chip info structure
+ * @buf:	buffer to store read data
+ *
+ * We need a special oob layout and handling even when OOB isn't used.
+ */
+static int nand_read_page_raw_syndrome(struct mtd_info *mtd, struct nand_chip *chip,
+			      uint8_t *buf)
+{
+	int eccsize = chip->ecc.size;
+	int eccbytes = chip->ecc.bytes;
+	uint8_t *oob = chip->oob_poi;
+	int steps, size;
+
+	for (steps = chip->ecc.steps; steps > 0; steps--) {
+		chip->read_buf(mtd, buf, eccsize);
+		buf += eccsize;
+
+		if (chip->ecc.prepad) {
+			chip->read_buf(mtd, oob, chip->ecc.prepad);
+			oob += chip->ecc.prepad;
+		}
+
+		chip->read_buf(mtd, oob, eccbytes);
+		oob += eccbytes;
+
+		if (chip->ecc.postpad) {
+			chip->read_buf(mtd, oob, chip->ecc.postpad);
+			oob += chip->ecc.postpad;
+		}
+	}
+
+	size = mtd->oobsize - (oob - chip->oob_poi);
+	if (size)
+		chip->read_buf(mtd, oob, size);
+
+	return 0;
+}
+
+/**
  * nand_read_page_swecc - [REPLACABLE] software ecc based page read function
  * @mtd:	mtd info structure
  * @chip:	nand chip info structure
@@ -1482,6 +1525,8 @@ static int nand_read_oob(struct mtd_info
  * @mtd:	mtd info structure
  * @chip:	nand chip info structure
  * @buf:	data buffer
+ *
+ * Not for syndrome calculating ecc controllers, which use a special oob layout
  */
 static void nand_write_page_raw(struct mtd_info *mtd, struct nand_chip *chip,
 				const uint8_t *buf)
@@ -1491,6 +1536,44 @@ static void nand_write_page_raw(struct m
 }
 
 /**
+ * nand_write_page_raw_syndrome - [Intern] raw page write function
+ * @mtd:	mtd info structure
+ * @chip:	nand chip info structure
+ * @buf:	data buffer
+ *
+ * We need a special oob layout and handling even when ECC isn't checked.
+ */
+static void nand_write_page_raw_syndrome(struct mtd_info *mtd, struct nand_chip *chip,
+				const uint8_t *buf)
+{
+	int eccsize = chip->ecc.size;
+	int eccbytes = chip->ecc.bytes;
+	uint8_t *oob = chip->oob_poi;
+	int steps, size;
+
+	for (steps = chip->ecc.steps; steps > 0; steps--) {
+		chip->write_buf(mtd, buf, eccsize);
+		buf += eccsize;
+
+		if (chip->ecc.prepad) {
+			chip->write_buf(mtd, oob, chip->ecc.prepad);
+			oob += chip->ecc.prepad;
+		}
+
+		chip->read_buf(mtd, oob, eccbytes);
+		oob += eccbytes;
+
+		if (chip->ecc.postpad) {
+			chip->write_buf(mtd, oob, chip->ecc.postpad);
+			oob += chip->ecc.postpad;
+		}
+	}
+
+	size = mtd->oobsize - (oob - chip->oob_poi);
+	if (size)
+		chip->write_buf(mtd, oob, size);
+}
+/**
  * nand_write_page_swecc - [REPLACABLE] software ecc based page write function
  * @mtd:	mtd info structure
  * @chip:	nand chip info structure
@@ -2569,10 +2652,6 @@ int nand_scan_tail(struct mtd_info *mtd)
 	 * check ECC mode, default to software if 3byte/512byte hardware ECC is
 	 * selected and we have 256 byte pagesize fallback to software ECC
 	 */
-	if (!chip->ecc.read_page_raw)
-		chip->ecc.read_page_raw = nand_read_page_raw;
-	if (!chip->ecc.write_page_raw)
-		chip->ecc.write_page_raw = nand_write_page_raw;
 
 	switch (chip->ecc.mode) {
 	case NAND_ECC_HW:
@@ -2581,6 +2660,10 @@ int nand_scan_tail(struct mtd_info *mtd)
 			chip->ecc.read_page = nand_read_page_hwecc;
 		if (!chip->ecc.write_page)
 			chip->ecc.write_page = nand_write_page_hwecc;
+		if (!chip->ecc.read_page_raw)
+			chip->ecc.read_page_raw = nand_read_page_raw;
+		if (!chip->ecc.write_page_raw)
+			chip->ecc.write_page_raw = nand_write_page_raw;
 		if (!chip->ecc.read_oob)
 			chip->ecc.read_oob = nand_read_oob_std;
 		if (!chip->ecc.write_oob)
@@ -2602,6 +2685,10 @@ int nand_scan_tail(struct mtd_info *mtd)
 			chip->ecc.read_page = nand_read_page_syndrome;
 		if (!chip->ecc.write_page)
 			chip->ecc.write_page = nand_write_page_syndrome;
+		if (!chip->ecc.read_page_raw)
+			chip->ecc.read_page_raw = nand_read_page_raw_syndrome;
+		if (!chip->ecc.write_page_raw)
+			chip->ecc.write_page_raw = nand_write_page_raw_syndrome;
 		if (!chip->ecc.read_oob)
 			chip->ecc.read_oob = nand_read_oob_syndrome;
 		if (!chip->ecc.write_oob)
@@ -2620,6 +2707,8 @@ int nand_scan_tail(struct mtd_info *mtd)
 		chip->ecc.read_page = nand_read_page_swecc;
 		chip->ecc.read_subpage = nand_read_subpage;
 		chip->ecc.write_page = nand_write_page_swecc;
+		chip->ecc.read_page_raw = nand_read_page_raw;
+		chip->ecc.write_page_raw = nand_write_page_raw;
 		chip->ecc.read_oob = nand_read_oob_std;
 		chip->ecc.write_oob = nand_write_oob_std;
 		chip->ecc.size = 256;
@@ -2632,6 +2721,8 @@ int nand_scan_tail(struct mtd_info *mtd)
 		chip->ecc.read_page = nand_read_page_raw;
 		chip->ecc.write_page = nand_write_page_raw;
 		chip->ecc.read_oob = nand_read_oob_std;
+		chip->ecc.read_page_raw = nand_read_page_raw;
+		chip->ecc.write_page_raw = nand_write_page_raw;
 		chip->ecc.write_oob = nand_write_oob_std;
 		chip->ecc.size = mtd->writesize;
 		chip->ecc.bytes = 0;
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

origin.patch
linux-next.patch
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

