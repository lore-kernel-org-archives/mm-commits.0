From: akpm@linux-foundation.org
Subject: - blackfin-nfc-driver-cleanup-the-error-exit-path-of-bf5xx_nand_probe-function.patch removed from -mm tree
Date: Mon, 04 Aug 2008 13:06:55 -0700
Message-ID: <200808042006.m74K6tOB027733@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48307 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759589AbYHDUHE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 16:07:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cooloney@kernel.org, vapier.adi@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Blackfin NFC Driver: Cleanup the error exit path of bf5xx_nand_probe function
has been removed from the -mm tree.  Its filename was
     blackfin-nfc-driver-cleanup-the-error-exit-path-of-bf5xx_nand_probe-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
git-alsa-tiwai.patch
blackfin-rtc-driver-if-we-dont-define-irq_set_freq-the-common-rtc-dev-layer-will-give-us-the-same-behavior-of-returning-enotty.patch
blackfin-rtc-driver-fix-bug-only-rtc-interrupt-can-wake-up-deeper-sleep-core.patch
blackfin-rtc-driver-add-support-for-power-management-framework.patch
blackfin-rtc-driver-dont-bother-passing-the-rtc-struct-down-to-bfin_rtc_int_setclear-since-it-isnt-needed-shaves-off-100bytes.patch
blackfin-rtc-driver-disable-the-write-complete-irq-upon-close.patch
blackfin-rtc-driver-wait-for-the-write-complete-interrupt-complete-before-sleeping.patch
blackfin-rtc-driver-convert-pie-handling-to-irq_set_state-as-pointed-out-by-david-brownell.patch
blackfin-rtc-driver-drop-pie-stopwatch-code-since-the-hardware-can-only-do-a-max-of-1hz-and-this-same-functionality-is-provided-by-uie.patch

