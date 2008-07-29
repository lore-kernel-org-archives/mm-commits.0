From: akpm@linux-foundation.org
Subject: + blackfin-nfc-driver-fix-bug-hw-ecc-calc-by-making-sure-we-extract-11-bits-from-each-register-instead-of-10.patch added to -mm tree
Date: Tue, 29 Jul 2008 15:09:35 -0700
Message-ID: <200807292209.m6TM9ZNd024188@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57459 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754610AbYG2WKP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 18:10:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier.adi@gmail.com, cooloney@kernel.org


The patch titled
     Blackfin NFC Driver: fix bug - hw ecc calc by making sure we extract 11 bits from each register instead of 10
has been added to the -mm tree.  Its filename is
     blackfin-nfc-driver-fix-bug-hw-ecc-calc-by-making-sure-we-extract-11-bits-from-each-register-instead-of-10.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Blackfin NFC Driver: fix bug - hw ecc calc by making sure we extract 11 bits from each register instead of 10
From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/bf5xx_nand.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/mtd/nand/bf5xx_nand.c~blackfin-nfc-driver-fix-bug-hw-ecc-calc-by-making-sure-we-extract-11-bits-from-each-register-instead-of-10 drivers/mtd/nand/bf5xx_nand.c
--- a/drivers/mtd/nand/bf5xx_nand.c~blackfin-nfc-driver-fix-bug-hw-ecc-calc-by-making-sure-we-extract-11-bits-from-each-register-instead-of-10
+++ a/drivers/mtd/nand/bf5xx_nand.c
@@ -298,7 +298,7 @@ static int bf5xx_nand_calculate_ecc(stru
 	ecc0 = bfin_read_NFC_ECC0();
 	ecc1 = bfin_read_NFC_ECC1();
 
-	code[0] = (ecc0 & 0x3FF) | ((ecc1 & 0x3FF) << 11);
+	code[0] = (ecc0 & 0x7ff) | ((ecc1 & 0x7ff) << 11);
 
 	dev_dbg(info->device, "returning ecc 0x%08x\n", code[0]);
 
@@ -310,7 +310,7 @@ static int bf5xx_nand_calculate_ecc(stru
 	if (page_size == 512) {
 		ecc0 = bfin_read_NFC_ECC2();
 		ecc1 = bfin_read_NFC_ECC3();
-		code[1] = (ecc0 & 0x3FF) | ((ecc1 & 0x3FF) << 11);
+		code[1] = (ecc0 & 0x7ff) | ((ecc1 & 0x7ff) << 11);
 
 		/* second 3 bytes in ecc_code for second 256
 		 * bytes of 512 page size
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

blackfin-nfc-driver-fix-bug-do-not-clobber-the-status-from-the-first-256-bytes-if-operating-on-512-pages.patch
blackfin-nfc-driver-fix-bug-hw-ecc-calc-by-making-sure-we-extract-11-bits-from-each-register-instead-of-10.patch
blackfin-nfc-driver-add-support-for-the-ecc-layout-the-blackfin-bootrom-uses.patch
blackfin-nfc-driver-add-proper-devinit-devexit-markings-to-probe-remove-functions.patch
blackfin-nfc-driver-enable-blackfin-nand-hwecc-support-by-default.patch
blackfin-nfc-driver-use-standard-dev_err-rather-than-printk.patch
blackfin-nfc-driver-cleanup-the-error-exit-path-of-bf5xx_nand_probe-function.patch

