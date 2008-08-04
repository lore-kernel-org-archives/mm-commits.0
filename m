From: akpm@linux-foundation.org
Subject: - blackfin-nfc-driver-use-standard-dev_err-rather-than-printk.patch removed from -mm tree
Date: Mon, 04 Aug 2008 13:06:53 -0700
Message-ID: <200808042006.m74K6r3Y027730@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38895 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758295AbYHDUHD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 16:07:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, cooloney@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Blackfin NFC Driver: use standard dev_err() rather than printk()
has been removed from the -mm tree.  Its filename was
     blackfin-nfc-driver-use-standard-dev_err-rather-than-printk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Blackfin NFC Driver: use standard dev_err() rather than printk()
From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/bf5xx_nand.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/mtd/nand/bf5xx_nand.c~blackfin-nfc-driver-use-standard-dev_err-rather-than-printk drivers/mtd/nand/bf5xx_nand.c
--- a/drivers/mtd/nand/bf5xx_nand.c~blackfin-nfc-driver-use-standard-dev_err-rather-than-printk
+++ a/drivers/mtd/nand/bf5xx_nand.c
@@ -684,8 +684,7 @@ static int __devinit bf5xx_nand_probe(st
 	dev_dbg(&pdev->dev, "(%p)\n", pdev);
 
 	if (peripheral_request_list(bfin_nfc_pin_req, DRV_NAME)) {
-		printk(KERN_ERR DRV_NAME
-		": Requesting Peripherals failed\n");
+		dev_err(&pdev->dev, "requesting Peripherals failed\n");
 		return -EFAULT;
 	}
 
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

origin.patch
blackfin-rtc-driver-add-support-for-power-management-framework.patch
blackfin-rtc-driver-dont-bother-passing-the-rtc-struct-down-to-bfin_rtc_int_setclear-since-it-isnt-needed-shaves-off-100bytes.patch
blackfin-rtc-driver-disable-the-write-complete-irq-upon-close.patch
blackfin-rtc-driver-wait-for-the-write-complete-interrupt-complete-before-sleeping.patch
blackfin-rtc-driver-convert-pie-handling-to-irq_set_state-as-pointed-out-by-david-brownell.patch
blackfin-rtc-driver-drop-pie-stopwatch-code-since-the-hardware-can-only-do-a-max-of-1hz-and-this-same-functionality-is-provided-by-uie.patch

