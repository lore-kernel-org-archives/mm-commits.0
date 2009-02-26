From: akpm@linux-foundation.org
Subject: + nand-fix-raw-reads-with-ecc-syndrome-layouts.patch added to -mm tree
Date: Thu, 26 Feb 2009 12:34:36 -0800
Message-ID: <200902262034.n1QKYaPS019765@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43399 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754482AbZBZUfV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Feb 2009 15:35:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, dwmw2@infradead.org


The patch titled
     NAND: fix "raw" reads with ECC syndrome layouts
has been added to the -mm tree.  Its filename is
     nand-fix-raw-reads-with-ecc-syndrome-layouts.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

 drivers/mtd/nand/nand_base.c |  101 +++++++++++++++++++++++++++++++--
 1 file changed, 97 insertions(+), 4 deletions(-)

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
@@ -758,6 +760,48 @@ static int nand_read_page_raw(struct mtd
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
+	int temp;
+
+	temp = chip->ecc.steps;
+	do {
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
+	} while (--temp);
+
+	temp = mtd->oobsize - (oob - chip->oob_poi);
+	if (temp)
+		chip->read_buf(mtd, oob, temp);
+
+	return 0;
+}
+
+/**
  * nand_read_page_swecc - [REPLACABLE] software ecc based page read function
  * @mtd:	mtd info structure
  * @chip:	nand chip info structure
@@ -1482,6 +1526,8 @@ static int nand_read_oob(struct mtd_info
  * @mtd:	mtd info structure
  * @chip:	nand chip info structure
  * @buf:	data buffer
+ *
+ * Not for syndrome calculating ecc controllers, which use a special oob layout
  */
 static void nand_write_page_raw(struct mtd_info *mtd, struct nand_chip *chip,
 				const uint8_t *buf)
@@ -1491,6 +1537,45 @@ static void nand_write_page_raw(struct m
 }
 
 /**
+ * nand_write_page_raw_syndrome - [Intern] raw page write function
+ * @mtd:	mtd info structure
+ * @chip:	nand chip info structure
+ * @buf:	data buffer
+ *
+ * We need a special oob layout and handling even when ECC isn't used.
+ */
+static void nand_write_page_raw_syndrome(struct mtd_info *mtd, struct nand_chip *chip,
+				const uint8_t *buf)
+{
+	int eccsize = chip->ecc.size;
+	int eccbytes = chip->ecc.bytes;
+	uint8_t *oob = chip->oob_poi;
+	int temp;
+
+	temp = chip->ecc.steps;
+	do {
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
+	} while (--temp);
+
+	temp = mtd->oobsize - (oob - chip->oob_poi);
+	if (temp)
+		chip->write_buf(mtd, oob, temp);
+}
+/**
  * nand_write_page_swecc - [REPLACABLE] software ecc based page write function
  * @mtd:	mtd info structure
  * @chip:	nand chip info structure
@@ -2569,10 +2654,6 @@ int nand_scan_tail(struct mtd_info *mtd)
 	 * check ECC mode, default to software if 3byte/512byte hardware ECC is
 	 * selected and we have 256 byte pagesize fallback to software ECC
 	 */
-	if (!chip->ecc.read_page_raw)
-		chip->ecc.read_page_raw = nand_read_page_raw;
-	if (!chip->ecc.write_page_raw)
-		chip->ecc.write_page_raw = nand_write_page_raw;
 
 	switch (chip->ecc.mode) {
 	case NAND_ECC_HW:
@@ -2581,6 +2662,10 @@ int nand_scan_tail(struct mtd_info *mtd)
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
@@ -2602,6 +2687,10 @@ int nand_scan_tail(struct mtd_info *mtd)
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
@@ -2620,6 +2709,8 @@ int nand_scan_tail(struct mtd_info *mtd)
 		chip->ecc.read_page = nand_read_page_swecc;
 		chip->ecc.read_subpage = nand_read_subpage;
 		chip->ecc.write_page = nand_write_page_swecc;
+		chip->ecc.read_page_raw = nand_read_page_raw;
+		chip->ecc.write_page_raw = nand_write_page_raw;
 		chip->ecc.read_oob = nand_read_oob_std;
 		chip->ecc.write_oob = nand_write_oob_std;
 		chip->ecc.size = 256;
@@ -2632,6 +2723,8 @@ int nand_scan_tail(struct mtd_info *mtd)
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

linux-next.patch
nand-fix-raw-reads-with-ecc-syndrome-layouts.patch
nand-davinci_nand-driver.patch
nand-fix-broken-debug-messages.patch
mtd-we-dont-need-no-misc-devices.patch
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

