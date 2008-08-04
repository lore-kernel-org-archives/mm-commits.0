From: akpm@linux-foundation.org
Subject: - blackfin-nfc-driver-add-proper-devinit-devexit-markings-to-probe-remove-functions.patch removed from -mm tree
Date: Mon, 04 Aug 2008 13:06:49 -0700
Message-ID: <200808042006.m74K6nnL027724@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60444 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759555AbYHDUG6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 16:06:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, cooloney@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Blackfin NFC Driver: add proper devinit/devexit markings to probe/remove functions
has been removed from the -mm tree.  Its filename was
     blackfin-nfc-driver-add-proper-devinit-devexit-markings-to-probe-remove-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
blackfin-rtc-driver-add-support-for-power-management-framework.patch
blackfin-rtc-driver-dont-bother-passing-the-rtc-struct-down-to-bfin_rtc_int_setclear-since-it-isnt-needed-shaves-off-100bytes.patch
blackfin-rtc-driver-disable-the-write-complete-irq-upon-close.patch
blackfin-rtc-driver-wait-for-the-write-complete-interrupt-complete-before-sleeping.patch
blackfin-rtc-driver-convert-pie-handling-to-irq_set_state-as-pointed-out-by-david-brownell.patch
blackfin-rtc-driver-drop-pie-stopwatch-code-since-the-hardware-can-only-do-a-max-of-1hz-and-this-same-functionality-is-provided-by-uie.patch

