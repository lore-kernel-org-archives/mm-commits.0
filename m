From: akpm@linux-foundation.org
Subject: + mtd-nand-add-page-parameter-to-all-read_page-read_page_raw-apis.patch added to -mm tree
Date: Thu, 16 Jul 2009 15:28:31 -0700
Message-ID: <200907162228.n6GMSW6V006406@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38711 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933476AbZGPW3B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Jul 2009 18:29:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nsnehaprabha@ti.com, dbrownell@users.sourceforge.net, dwmw2@infradead.org, s-paulraj@ti.com, tglx@linutronix.de


The patch titled
     mtd-nand: add "page" parameter to all read_page/read_page_raw APIs
has been added to the -mm tree.  Its filename is
     mtd-nand-add-page-parameter-to-all-read_page-read_page_raw-apis.patch

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
Subject: mtd-nand: add "page" parameter to all read_page/read_page_raw APIs
From: Sneha Narnakaje <nsnehaprabha@ti.com>

This patch adds a new "page" parameter to all NAND read_page/read_page_raw
APIs.  The read_page API for the new mode ECC_HW_OOB_FIRST requires the
page information to send the READOOB command and read the OOB area before
the data area.

Reviewed-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Sneha Narnakaje <nsnehaprabha@ti.com>
Signed-off-by: Sandeep Paulraj <s-paulraj@ti.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/atmel_nand.c    |    2 +-
 drivers/mtd/nand/cafe_nand.c     |    2 +-
 drivers/mtd/nand/fsl_elbc_nand.c |    3 ++-
 drivers/mtd/nand/nand_base.c     |   18 ++++++++++--------
 drivers/mtd/nand/sh_flctl.c      |    2 +-
 include/linux/mtd/nand.h         |    4 ++--
 6 files changed, 17 insertions(+), 14 deletions(-)

diff -puN drivers/mtd/nand/atmel_nand.c~mtd-nand-add-page-parameter-to-all-read_page-read_page_raw-apis drivers/mtd/nand/atmel_nand.c
--- a/drivers/mtd/nand/atmel_nand.c~mtd-nand-add-page-parameter-to-all-read_page-read_page_raw-apis
+++ a/drivers/mtd/nand/atmel_nand.c
@@ -218,7 +218,7 @@ static int atmel_nand_calculate(struct m
  * buf:        buffer to store read data
  */
 static int atmel_nand_read_page(struct mtd_info *mtd,
-		struct nand_chip *chip, uint8_t *buf)
+		struct nand_chip *chip, uint8_t *buf, int page)
 {
 	int eccsize = chip->ecc.size;
 	int eccbytes = chip->ecc.bytes;
diff -puN drivers/mtd/nand/cafe_nand.c~mtd-nand-add-page-parameter-to-all-read_page-read_page_raw-apis drivers/mtd/nand/cafe_nand.c
--- a/drivers/mtd/nand/cafe_nand.c~mtd-nand-add-page-parameter-to-all-read_page-read_page_raw-apis
+++ a/drivers/mtd/nand/cafe_nand.c
@@ -381,7 +381,7 @@ static int cafe_nand_read_oob(struct mtd
  * we need a special oob layout and handling.
  */
 static int cafe_nand_read_page(struct mtd_info *mtd, struct nand_chip *chip,
-			       uint8_t *buf)
+			       uint8_t *buf, int page)
 {
 	struct cafe_priv *cafe = mtd->priv;
 
diff -puN drivers/mtd/nand/fsl_elbc_nand.c~mtd-nand-add-page-parameter-to-all-read_page-read_page_raw-apis drivers/mtd/nand/fsl_elbc_nand.c
--- a/drivers/mtd/nand/fsl_elbc_nand.c~mtd-nand-add-page-parameter-to-all-read_page-read_page_raw-apis
+++ a/drivers/mtd/nand/fsl_elbc_nand.c
@@ -739,7 +739,8 @@ static int fsl_elbc_chip_init_tail(struc
 
 static int fsl_elbc_read_page(struct mtd_info *mtd,
                               struct nand_chip *chip,
-                              uint8_t *buf)
+			      uint8_t *buf,
+			      int page)
 {
 	fsl_elbc_read_buf(mtd, buf, mtd->writesize);
 	fsl_elbc_read_buf(mtd, chip->oob_poi, mtd->oobsize);
diff -puN drivers/mtd/nand/nand_base.c~mtd-nand-add-page-parameter-to-all-read_page-read_page_raw-apis drivers/mtd/nand/nand_base.c
--- a/drivers/mtd/nand/nand_base.c~mtd-nand-add-page-parameter-to-all-read_page-read_page_raw-apis
+++ a/drivers/mtd/nand/nand_base.c
@@ -766,7 +766,7 @@ static int nand_wait(struct mtd_info *mt
  * Not for syndrome calculating ecc controllers, which use a special oob layout
  */
 static int nand_read_page_raw(struct mtd_info *mtd, struct nand_chip *chip,
-			      uint8_t *buf)
+			      uint8_t *buf, int page)
 {
 	chip->read_buf(mtd, buf, mtd->writesize);
 	chip->read_buf(mtd, chip->oob_poi, mtd->oobsize);
@@ -782,7 +782,7 @@ static int nand_read_page_raw(struct mtd
  * We need a special oob layout and handling even when OOB isn't used.
  */
 static int nand_read_page_raw_syndrome(struct mtd_info *mtd, struct nand_chip *chip,
-			      uint8_t *buf)
+			      uint8_t *buf, int page)
 {
 	int eccsize = chip->ecc.size;
 	int eccbytes = chip->ecc.bytes;
@@ -821,7 +821,7 @@ static int nand_read_page_raw_syndrome(s
  * @buf:	buffer to store read data
  */
 static int nand_read_page_swecc(struct mtd_info *mtd, struct nand_chip *chip,
-				uint8_t *buf)
+				uint8_t *buf, int page)
 {
 	int i, eccsize = chip->ecc.size;
 	int eccbytes = chip->ecc.bytes;
@@ -831,7 +831,7 @@ static int nand_read_page_swecc(struct m
 	uint8_t *ecc_code = chip->buffers->ecccode;
 	uint32_t *eccpos = chip->ecc.layout->eccpos;
 
-	chip->ecc.read_page_raw(mtd, chip, buf);
+	chip->ecc.read_page_raw(mtd, chip, buf, page);
 
 	for (i = 0; eccsteps; eccsteps--, i += eccbytes, p += eccsize)
 		chip->ecc.calculate(mtd, p, &ecc_calc[i]);
@@ -944,7 +944,7 @@ static int nand_read_subpage(struct mtd_
  * Not for syndrome calculating ecc controllers which need a special oob layout
  */
 static int nand_read_page_hwecc(struct mtd_info *mtd, struct nand_chip *chip,
-				uint8_t *buf)
+				uint8_t *buf, int page)
 {
 	int i, eccsize = chip->ecc.size;
 	int eccbytes = chip->ecc.bytes;
@@ -989,7 +989,7 @@ static int nand_read_page_hwecc(struct m
  * we need a special oob layout and handling.
  */
 static int nand_read_page_syndrome(struct mtd_info *mtd, struct nand_chip *chip,
-				   uint8_t *buf)
+				   uint8_t *buf, int page)
 {
 	int i, eccsize = chip->ecc.size;
 	int eccbytes = chip->ecc.bytes;
@@ -1131,11 +1131,13 @@ static int nand_do_read_ops(struct mtd_i
 
 			/* Now read the page into the buffer */
 			if (unlikely(ops->mode == MTD_OOB_RAW))
-				ret = chip->ecc.read_page_raw(mtd, chip, bufpoi);
+				ret = chip->ecc.read_page_raw(mtd, chip,
+							      bufpoi, page);
 			else if (!aligned && NAND_SUBPAGE_READ(chip) && !oob)
 				ret = chip->ecc.read_subpage(mtd, chip, col, bytes, bufpoi);
 			else
-				ret = chip->ecc.read_page(mtd, chip, bufpoi);
+				ret = chip->ecc.read_page(mtd, chip, bufpoi,
+							  page);
 			if (ret < 0)
 				break;
 
diff -puN drivers/mtd/nand/sh_flctl.c~mtd-nand-add-page-parameter-to-all-read_page-read_page_raw-apis drivers/mtd/nand/sh_flctl.c
--- a/drivers/mtd/nand/sh_flctl.c~mtd-nand-add-page-parameter-to-all-read_page-read_page_raw-apis
+++ a/drivers/mtd/nand/sh_flctl.c
@@ -329,7 +329,7 @@ static void set_cmd_regs(struct mtd_info
 }
 
 static int flctl_read_page_hwecc(struct mtd_info *mtd, struct nand_chip *chip,
-				uint8_t *buf)
+				uint8_t *buf, int page)
 {
 	int i, eccsize = chip->ecc.size;
 	int eccbytes = chip->ecc.bytes;
diff -puN include/linux/mtd/nand.h~mtd-nand-add-page-parameter-to-all-read_page-read_page_raw-apis include/linux/mtd/nand.h
--- a/include/linux/mtd/nand.h~mtd-nand-add-page-parameter-to-all-read_page-read_page_raw-apis
+++ a/include/linux/mtd/nand.h
@@ -271,13 +271,13 @@ struct nand_ecc_ctrl {
 					   uint8_t *calc_ecc);
 	int			(*read_page_raw)(struct mtd_info *mtd,
 						 struct nand_chip *chip,
-						 uint8_t *buf);
+						 uint8_t *buf, int page);
 	void			(*write_page_raw)(struct mtd_info *mtd,
 						  struct nand_chip *chip,
 						  const uint8_t *buf);
 	int			(*read_page)(struct mtd_info *mtd,
 					     struct nand_chip *chip,
-					     uint8_t *buf);
+					     uint8_t *buf, int page);
 	int			(*read_subpage)(struct mtd_info *mtd,
 					     struct nand_chip *chip,
 					     uint32_t offs, uint32_t len,
_

Patches currently in -mm which might be from nsnehaprabha@ti.com are

mtd-nand-add-page-parameter-to-all-read_page-read_page_raw-apis.patch
mtd-nand-add-new-ecc-mode-ecc_hw_oob_first.patch
mtd-nand-davinci-add-4-bit-ecc-support-for-large-page-nand-chips.patch

