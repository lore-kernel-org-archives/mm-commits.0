From: akpm@linux-foundation.org
Subject: + mtd-nand-davinci-add-4-bit-ecc-support-for-large-page-nand-chips.patch added to -mm tree
Date: Thu, 16 Jul 2009 15:28:37 -0700
Message-ID: <200907162228.n6GMScYb006517@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36423 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933478AbZGPW3G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Jul 2009 18:29:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nsnehaprabha@ti.com, dbrownell@users.sourceforge.net, dwmw2@infradead.org, s-paulraj@ti.com, tglx@linutronix.de


The patch titled
     mtd-nand: DaVinci: Add 4-bit ECC support for large page NAND chips
has been added to the -mm tree.  Its filename is
     mtd-nand-davinci-add-4-bit-ecc-support-for-large-page-nand-chips.patch

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
Subject: mtd-nand: DaVinci: Add 4-bit ECC support for large page NAND chips
From: Sneha Narnakaje <nsnehaprabha@ti.com>

This patch adds 4-bit ECC support for large page NAND chips using the new
ECC mode NAND_ECC_HW_OOB_FIRST.  The platform data from board-dm355-evm
has been adjusted to use this mode.

The patches have been verified on DM355 device with 2K Micron devices
using mtd-tests and JFFS2.  Error correction upto 4-bits has also been
verified using nandwrite/nanddump utilities.

Reviewed-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Sneha Narnakaje <nsnehaprabha@ti.com>
Signed-off-by: Sandeep Paulraj <s-paulraj@ti.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/davinci_nand.c |   45 ++++++++++++++++++++++++++----
 1 file changed, 39 insertions(+), 6 deletions(-)

diff -puN drivers/mtd/nand/davinci_nand.c~mtd-nand-davinci-add-4-bit-ecc-support-for-large-page-nand-chips drivers/mtd/nand/davinci_nand.c
--- a/drivers/mtd/nand/davinci_nand.c~mtd-nand-davinci-add-4-bit-ecc-support-for-large-page-nand-chips
+++ a/drivers/mtd/nand/davinci_nand.c
@@ -348,6 +348,12 @@ compare:
 	if (!(syndrome[0] | syndrome[1] | syndrome[2] | syndrome[3]))
 		return 0;
 
+	/*
+	 * Clear any previous address calculation by doing a dummy read of an
+	 * error address register.
+	 */
+	davinci_nand_readl(info, NAND_ERR_ADD1_OFFSET);
+
 	/* Start address calculation, and wait for it to complete.
 	 * We _could_ start reading more data while this is working,
 	 * to speed up the overall page read.
@@ -359,8 +365,10 @@ compare:
 
 		switch ((fsr >> 8) & 0x0f) {
 		case 0:		/* no error, should not happen */
+			davinci_nand_readl(info, NAND_ERR_ERRVAL1_OFFSET);
 			return 0;
 		case 1:		/* five or more errors detected */
+			davinci_nand_readl(info, NAND_ERR_ERRVAL1_OFFSET);
 			return -EIO;
 		case 2:		/* error addresses computed */
 		case 3:
@@ -500,6 +508,26 @@ static struct nand_ecclayout hwecc4_smal
 	},
 };
 
+/* An ECC layout for using 4-bit ECC with large-page (2048bytes) flash,
+ * storing ten ECC bytes plus the manufacturer's bad block marker byte,
+ * and not overlapping the default BBT markers.
+ */
+static struct nand_ecclayout hwecc4_2048 __initconst = {
+	.eccbytes = 40,
+	.eccpos = {
+		/* at the end of spare sector */
+		24, 25, 26, 27, 28, 29,	30, 31, 32, 33,
+		34, 35, 36, 37, 38, 39,	40, 41, 42, 43,
+		44, 45, 46, 47, 48, 49, 50, 51, 52, 53,
+		54, 55, 56, 57, 58, 59, 60, 61, 62, 63,
+		},
+	.oobfree = {
+		/* 1 byte at offset 0 holds manufacturer badblock marker */
+		{.offset = 1, .length = 23, },
+		/* 5 bytes at offset 8 hold BBT markers */
+		/* 8 bytes at offset 16 hold JFFS2 clean markers */
+	},
+};
 
 static int __init nand_davinci_probe(struct platform_device *pdev)
 {
@@ -690,15 +718,20 @@ static int __init nand_davinci_probe(str
 				info->mtd.oobsize - 16;
 			goto syndrome_done;
 		}
+		if (chunks == 4) {
+			info->ecclayout = hwecc4_2048;
+			info->chip.ecc.mode = NAND_ECC_HW_OOB_FIRST;
+			goto syndrome_done;
+		}
 
-		/* For large page chips we'll be wanting to use a
-		 * not-yet-implemented mode that reads OOB data
-		 * before reading the body of the page, to avoid
-		 * the "infix OOB" model of NAND_ECC_HW_SYNDROME
-		 * (and preserve manufacturer badblock markings).
+		/* 4K page chips are not yet supported. The eccpos from
+		 * nand_ecclayout cannot hold 80 bytes and change to eccpos[]
+		 * breaks userspace ioctl interface with mtd-utils. Once we
+		 * resolve this issue, NAND_ECC_HW_OOB_FIRST mode can be used
+		 * for the 4K page chips.
 		 */
 		dev_warn(&pdev->dev, "no 4-bit ECC support yet "
-				"for large page NAND\n");
+				"for 4K page NAND\n");
 		ret = -EIO;
 		goto err_scan;
 
_

Patches currently in -mm which might be from nsnehaprabha@ti.com are

mtd-nand-add-page-parameter-to-all-read_page-read_page_raw-apis.patch
mtd-nand-add-new-ecc-mode-ecc_hw_oob_first.patch
mtd-nand-davinci-add-4-bit-ecc-support-for-large-page-nand-chips.patch

