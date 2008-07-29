From: akpm@linux-foundation.org
Subject: + blackfin-nfc-driver-cleanup-the-error-exit-path-of-bf5xx_nand_probe-function.patch added to -mm tree
Date: Tue, 29 Jul 2008 15:09:45 -0700
Message-ID: <200807292209.m6TM9jSD024208@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53518 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754765AbYG2WKY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 18:10:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cooloney@kernel.org, vapier.adi@gmail.com


The patch titled
     Blackfin NFC Driver: Cleanup the error exit path of bf5xx_nand_probe function
has been added to the -mm tree.  Its filename is
     blackfin-nfc-driver-cleanup-the-error-exit-path-of-bf5xx_nand_probe-function.patch

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
Subject: Blackfin NFC Driver: Cleanup the error exit path of bf5xx_nand_probe function
From: Bryan Wu <cooloney@kernel.org>

Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/bf5xx_nand.c |   38 ++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff -puN drivers/mtd/nand/bf5xx_nand.c~blackfin-nfc-driver-cleanup-the-error-exit-path-of-bf5xx_nand_probe-function drivers/mtd/nand/bf5xx_nand.c
--- a/drivers/mtd/nand/bf5xx_nand.c~blackfin-nfc-driver-cleanup-the-error-exit-path-of-bf5xx_nand_probe-function
+++ a/drivers/mtd/nand/bf5xx_nand.c
@@ -549,7 +549,6 @@ static void bf5xx_nand_dma_write_buf(str
 /*
  * System initialization functions
  */
-
 static int bf5xx_nand_dma_init(struct bf5xx_nand_info *info)
 {
 	int ret;
@@ -582,6 +581,13 @@ static int bf5xx_nand_dma_init(struct bf
 	return 0;
 }
 
+static void bf5xx_nand_dma_remove(struct bf5xx_nand_info *info)
+{
+	/* Free NFC DMA channel */
+	if (hardware_ecc)
+		free_dma(CH_NFC);
+}
+
 /*
  * BF5XX NFC hardware initialization
  *  - pin mux setup
@@ -658,6 +664,7 @@ static int __devexit bf5xx_nand_remove(s
 	}
 
 	peripheral_free_list(bfin_nfc_pin_req);
+	bf5xx_nand_dma_remove(info);
 
 	/* free the common resources */
 	kfree(info);
@@ -683,21 +690,21 @@ static int __devinit bf5xx_nand_probe(st
 
 	dev_dbg(&pdev->dev, "(%p)\n", pdev);
 
+	if (!plat) {
+		dev_err(&pdev->dev, "no platform specific information\n");
+		return -EINVAL;
+	}
+
 	if (peripheral_request_list(bfin_nfc_pin_req, DRV_NAME)) {
 		dev_err(&pdev->dev, "requesting Peripherals failed\n");
 		return -EFAULT;
 	}
 
-	if (!plat) {
-		dev_err(&pdev->dev, "no platform specific information\n");
-		goto exit_error;
-	}
-
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
 	if (info == NULL) {
 		dev_err(&pdev->dev, "no memory for flash info\n");
 		err = -ENOMEM;
-		goto exit_error;
+		goto out_err_kzalloc;
 	}
 
 	platform_set_drvdata(pdev, info);
@@ -741,8 +748,8 @@ static int __devinit bf5xx_nand_probe(st
 
 	/* initialise the hardware */
 	err = bf5xx_nand_hw_init(info);
-	if (err != 0)
-		goto exit_error;
+	if (err)
+		goto out_err_hw_init;
 
 	/* setup hardware ECC data struct */
 	if (hardware_ecc) {
@@ -772,7 +779,7 @@ static int __devinit bf5xx_nand_probe(st
 	/* scan hardware nand chip and setup mtd info data struct */
 	if (nand_scan(mtd, 1)) {
 		err = -ENXIO;
-		goto exit_error;
+		goto out_err_nand_scan;
 	}
 
 	/* add NAND partition */
@@ -781,11 +788,14 @@ static int __devinit bf5xx_nand_probe(st
 	dev_dbg(&pdev->dev, "initialised ok\n");
 	return 0;
 
-exit_error:
-	bf5xx_nand_remove(pdev);
+out_err_nand_scan:
+	bf5xx_nand_dma_remove(info);
+out_err_hw_init:
+	platform_set_drvdata(pdev, NULL);
+	kfree(info);
+out_err_kzalloc:
+	peripheral_free_list(bfin_nfc_pin_req);
 
-	if (err == 0)
-		err = -EINVAL;
 	return err;
 }
 
_

Patches currently in -mm which might be from cooloney@kernel.org are

git-alsa-tiwai.patch
blackfin-nfc-driver-fix-bug-do-not-clobber-the-status-from-the-first-256-bytes-if-operating-on-512-pages.patch
blackfin-nfc-driver-fix-bug-hw-ecc-calc-by-making-sure-we-extract-11-bits-from-each-register-instead-of-10.patch
blackfin-nfc-driver-add-support-for-the-ecc-layout-the-blackfin-bootrom-uses.patch
blackfin-nfc-driver-add-proper-devinit-devexit-markings-to-probe-remove-functions.patch
blackfin-nfc-driver-enable-blackfin-nand-hwecc-support-by-default.patch
blackfin-nfc-driver-use-standard-dev_err-rather-than-printk.patch
blackfin-nfc-driver-cleanup-the-error-exit-path-of-bf5xx_nand_probe-function.patch

