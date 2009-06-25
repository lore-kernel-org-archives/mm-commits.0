From: akpm@linux-foundation.org
Subject: + nand-add-new-ecc-mode-ecc_hw_oob_first.patch added to -mm tree
Date: Thu, 25 Jun 2009 11:38:49 -0700
Message-ID: <200906251838.n5PIcnSr001040@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53285 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751820AbZFYSjO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jun 2009 14:39:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: s-paulraj@ti.com, dbrownell@users.sourceforge.net, dwmw2@infradead.org, nsnehaprabha@ti.com, tglx@linutronix.de


The patch titled
     nand: add new ECC mode - ECC_HW_OOB_FIRST
has been added to the -mm tree.  Its filename is
     nand-add-new-ecc-mode-ecc_hw_oob_first.patch

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
Subject: nand: add new ECC mode - ECC_HW_OOB_FIRST
From: Sandeep Paulraj <s-paulraj@ti.com>

tAdd adds the new mode NAND_ECC_HW_OOB_FIRST in the nand code to support
4-bit ECC on TI DaVinci devices with large page (up to 4K) NAND chips. 
This ECC mode is similar to NAND_ECC_HW, with the exception of read_page
API that first reads the OOB area, reads the data in chunks, feeds the ECC
from OOB area to the ECC hw engine and perform any correction on the data
as per the ECC status reported by the engine.

"ECC_HW_OOB_FIRST" name suggested by Thomas Gleixner

Reviewed-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Sneha Narnakaje <nsnehaprabha@ti.com>
Signed-off-by: Sandeep Paulraj <s-paulraj@ti.com
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/nand_base.c |   59 +++++++++++++++++++++++++++++++++
 include/linux/mtd/nand.h     |    1 
 2 files changed, 60 insertions(+)

diff -puN drivers/mtd/nand/nand_base.c~nand-add-new-ecc-mode-ecc_hw_oob_first drivers/mtd/nand/nand_base.c
--- a/drivers/mtd/nand/nand_base.c~nand-add-new-ecc-mode-ecc_hw_oob_first
+++ a/drivers/mtd/nand/nand_base.c
@@ -980,6 +980,54 @@ static int nand_read_page_hwecc(struct m
 }
 
 /**
+ * nand_read_page_hwecc_oob_first - [REPLACABLE] hw ecc, read oob first
+ * @mtd:	mtd info structure
+ * @chip:	nand chip info structure
+ * @buf:	buffer to store read data
+ *
+ * Hardware ECC for large page chips, require OOB to be read first.
+ * For this ECC mode, the write_page method is re-used from ECC_HW.
+ * These methods read/write ECC from the OOB area, unlike the
+ * ECC_HW_SYNDROME support with multiple ECC steps, follows the
+ * "infix ECC" scheme and reads/writes ECC from the data area, by
+ * overwriting the NAND manufacturer bad block markings.
+ */
+static int nand_read_page_hwecc_oob_first(struct mtd_info *mtd,
+	struct nand_chip *chip, uint8_t *buf, int page)
+{
+	int i, eccsize = chip->ecc.size;
+	int eccbytes = chip->ecc.bytes;
+	int eccsteps = chip->ecc.steps;
+	uint8_t *p = buf;
+	uint8_t *ecc_code = chip->buffers->ecccode;
+	uint32_t *eccpos = chip->ecc.layout->eccpos;
+	uint8_t *ecc_calc = chip->buffers->ecccalc;
+
+	/* Read the OOB area first */
+	chip->cmdfunc(mtd, NAND_CMD_READOOB, 0, page);
+	chip->read_buf(mtd, chip->oob_poi, mtd->oobsize);
+	chip->cmdfunc(mtd, NAND_CMD_READ0, 0, page);
+
+	for (i = 0; i < chip->ecc.total; i++)
+		ecc_code[i] = chip->oob_poi[eccpos[i]];
+
+	for (i = 0; eccsteps; eccsteps--, i += eccbytes, p += eccsize) {
+		int stat;
+
+		chip->ecc.hwctl(mtd, NAND_ECC_READ);
+		chip->read_buf(mtd, p, eccsize);
+		chip->ecc.calculate(mtd, p, &ecc_calc[i]);
+
+		stat = chip->ecc.correct(mtd, p, &ecc_code[i], NULL);
+		if (stat < 0)
+			mtd->ecc_stats.failed++;
+		else
+			mtd->ecc_stats.corrected += stat;
+	}
+	return 0;
+}
+
+/**
  * nand_read_page_syndrome - [REPLACABLE] hardware ecc syndrom based page read
  * @mtd:	mtd info structure
  * @chip:	nand chip info structure
@@ -2671,6 +2719,17 @@ int nand_scan_tail(struct mtd_info *mtd)
 	 */
 
 	switch (chip->ecc.mode) {
+	case NAND_ECC_HW_OOB_FIRST:
+		/* Similar to NAND_ECC_HW, but a separate read_page handle */
+		if (!chip->ecc.calculate || !chip->ecc.correct ||
+		     !chip->ecc.hwctl) {
+			printk(KERN_WARNING "No ECC functions supplied, "
+			       "Hardware ECC not possible\n");
+			BUG();
+		}
+		if (!chip->ecc.read_page)
+			chip->ecc.read_page = nand_read_page_hwecc_oob_first;
+
 	case NAND_ECC_HW:
 		/* Use standard hwecc read page function ? */
 		if (!chip->ecc.read_page)
diff -puN include/linux/mtd/nand.h~nand-add-new-ecc-mode-ecc_hw_oob_first include/linux/mtd/nand.h
--- a/include/linux/mtd/nand.h~nand-add-new-ecc-mode-ecc_hw_oob_first
+++ a/include/linux/mtd/nand.h
@@ -121,6 +121,7 @@ typedef enum {
 	NAND_ECC_SOFT,
 	NAND_ECC_HW,
 	NAND_ECC_HW_SYNDROME,
+	NAND_ECC_HW_OOB_FIRST,
 } nand_ecc_modes_t;
 
 /*
_

Patches currently in -mm which might be from s-paulraj@ti.com are

nand-add-new-ecc-mode-ecc_hw_oob_first.patch
spi-new-spi-mode-bits.patch

