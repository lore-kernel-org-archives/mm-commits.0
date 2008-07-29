From: akpm@linux-foundation.org
Subject: + blackfin-nfc-driver-add-proper-devinit-devexit-markings-to-probe-remove-functions.patch added to -mm tree
Date: Tue, 29 Jul 2008 15:09:39 -0700
Message-ID: <200807292209.m6TM9dXi024194@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754828AbYG2WKS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 18:10:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier.adi@gmail.com, cooloney@kernel.org


The patch titled
     Blackfin NFC Driver: add proper devinit/devexit markings to probe/remove functions
has been added to the -mm tree.  Its filename is
     blackfin-nfc-driver-add-proper-devinit-devexit-markings-to-probe-remove-functions.patch

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
Subject: Blackfin NFC Driver: add proper devinit/devexit markings to probe/remove functions
From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/bf5xx_nand.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/mtd/nand/bf5xx_nand.c~blackfin-nfc-driver-add-proper-devinit-devexit-markings-to-probe-remove-functions drivers/mtd/nand/bf5xx_nand.c
--- a/drivers/mtd/nand/bf5xx_nand.c~blackfin-nfc-driver-add-proper-devinit-devexit-markings-to-probe-remove-functions
+++ a/drivers/mtd/nand/bf5xx_nand.c
@@ -640,7 +640,7 @@ static int bf5xx_nand_add_partition(stru
 #endif
 }
 
-static int bf5xx_nand_remove(struct platform_device *pdev)
+static int __devexit bf5xx_nand_remove(struct platform_device *pdev)
 {
 	struct bf5xx_nand_info *info = to_nand_info(pdev);
 	struct mtd_info *mtd = NULL;
@@ -673,7 +673,7 @@ static int bf5xx_nand_remove(struct plat
  * it can allocate all necessary resources then calls the
  * nand layer to look for devices
  */
-static int bf5xx_nand_probe(struct platform_device *pdev)
+static int __devinit bf5xx_nand_probe(struct platform_device *pdev)
 {
 	struct bf5xx_nand_platform *plat = to_nand_plat(pdev);
 	struct bf5xx_nand_info *info = NULL;
@@ -815,7 +815,7 @@ static int bf5xx_nand_resume(struct plat
 /* driver device registration */
 static struct platform_driver bf5xx_nand_driver = {
 	.probe		= bf5xx_nand_probe,
-	.remove		= bf5xx_nand_remove,
+	.remove		= __devexit_p(bf5xx_nand_remove),
 	.suspend	= bf5xx_nand_suspend,
 	.resume		= bf5xx_nand_resume,
 	.driver		= {
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

blackfin-nfc-driver-fix-bug-do-not-clobber-the-status-from-the-first-256-bytes-if-operating-on-512-pages.patch
blackfin-nfc-driver-fix-bug-hw-ecc-calc-by-making-sure-we-extract-11-bits-from-each-register-instead-of-10.patch
blackfin-nfc-driver-add-support-for-the-ecc-layout-the-blackfin-bootrom-uses.patch
blackfin-nfc-driver-add-proper-devinit-devexit-markings-to-probe-remove-functions.patch
blackfin-nfc-driver-enable-blackfin-nand-hwecc-support-by-default.patch
blackfin-nfc-driver-use-standard-dev_err-rather-than-printk.patch
blackfin-nfc-driver-cleanup-the-error-exit-path-of-bf5xx_nand_probe-function.patch

