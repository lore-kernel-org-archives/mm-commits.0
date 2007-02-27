From: akpm@linux-foundation.org
Subject: + cciss-supercedes-add-shutdown-support-replaces-reboot-notifier.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:58:03 -0800
Message-ID: <200702272058.l1RKw7HM028365@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52056 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610AbXB0VBV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 16:01:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mikem@beardog.cca.cpqcorp.net, mike.miller@hp.com


The patch titled
     cciss: supercedes add shutdown support
has been added to the -mm tree.  Its filename is
     cciss-supercedes-add-shutdown-support-replaces-reboot-notifier.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cciss: supercedes add shutdown support
From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>

Signed-off-by: Mike Miller <mike.miller@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/block/cciss.c~cciss-supercedes-add-shutdown-support-replaces-reboot-notifier drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-supercedes-add-shutdown-support-replaces-reboot-notifier
+++ a/drivers/block/cciss.c
@@ -3398,7 +3398,7 @@ static int __devinit cciss_init_one(stru
 	return -1;
 }
 
-static void __devexit cciss_remove_one(struct pci_dev *pdev)
+static void cciss_remove_one(struct pci_dev *pdev)
 {
 	ctlr_info_t *tmp_ptr;
 	int i, j;
@@ -3423,8 +3423,7 @@ static void __devexit cciss_remove_one(s
 	return_code = sendcmd(CCISS_CACHE_FLUSH, i, flush_buf, 4, 0, 0, 0, NULL,
 			      TYPE_CMD);
 	if (return_code != IO_OK) {
-		printk(KERN_WARNING "Error Flushing cache on controller %d\n",
-		       i);
+		printk(KERN_WARNING "Error flushing cache on controller %d\n", i);
 	}
 	free_irq(hba[i]->intr[2], hba[i]);
 
@@ -3475,6 +3474,7 @@ static struct pci_driver cciss_pci_drive
 	.probe = cciss_init_one,
 	.remove = __devexit_p(cciss_remove_one),
 	.id_table = cciss_pci_device_id,	/* id_table */
+	.shutdown = cciss_remove_one,
 };
 
 /*
_

Patches currently in -mm which might be from mikem@beardog.cca.cpqcorp.net are

cciss-fix-for-2tb-support.patch
cciss-fix-for-2tb-support-again.patch
cciss-supercedes-add-shutdown-support-replaces-reboot-notifier.patch
