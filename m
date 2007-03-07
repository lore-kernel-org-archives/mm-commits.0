From: akpm@linux-foundation.org
Subject: - cciss-add-struct-pci_driver-shutdown-support-replaces-reboot-notifier.patch removed from -mm tree
Date: Tue, 06 Mar 2007 20:21:37 -0800
Message-ID: <200703070421.l274Lb8t018912@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47258 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932690AbXCGEYv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 23:24:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mikem@beardog.cca.cpqcorp.net, mike.miller@hp.com, mm-commits@vger.kernel.org


The patch titled
     cciss: add struct pci_driver shutdown support (replaces reboot notifier)
has been removed from the -mm tree.  Its filename was
     cciss-add-struct-pci_driver-shutdown-support-replaces-reboot-notifier.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cciss: add struct pci_driver shutdown support (replaces reboot notifier)
From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>

This patch adds support for the struct pci_driver shutdown method to cciss.
 We require notification of an impending reboot or shutdown so that we can
flush the battery backed write cache (BBWC) on the Smart Array controller. 

Signed-off-by: Mike Miller <mike.miller@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/block/cciss.c~cciss-add-struct-pci_driver-shutdown-support-replaces-reboot-notifier drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-add-struct-pci_driver-shutdown-support-replaces-reboot-notifier
+++ a/drivers/block/cciss.c
@@ -3404,7 +3404,7 @@ static int __devinit cciss_init_one(stru
 	return -1;
 }
 
-static void __devexit cciss_remove_one(struct pci_dev *pdev)
+static void cciss_remove_one(struct pci_dev *pdev)
 {
 	ctlr_info_t *tmp_ptr;
 	int i, j;
@@ -3428,9 +3428,10 @@ static void __devexit cciss_remove_one(s
 	memset(flush_buf, 0, 4);
 	return_code = sendcmd(CCISS_CACHE_FLUSH, i, flush_buf, 4, 0, 0, 0, NULL,
 			      TYPE_CMD);
-	if (return_code != IO_OK) {
-		printk(KERN_WARNING "Error Flushing cache on controller %d\n",
-		       i);
+	if (return_code == IO_OK) {
+		printk(KERN_INFO "Completed flushing cache on controller %d\n", i);
+	} else {
+		printk(KERN_WARNING "Error flushing cache on controller %d\n", i);
 	}
 	free_irq(hba[i]->intr[2], hba[i]);
 
@@ -3481,6 +3482,7 @@ static struct pci_driver cciss_pci_drive
 	.probe = cciss_init_one,
 	.remove = __devexit_p(cciss_remove_one),
 	.id_table = cciss_pci_device_id,	/* id_table */
+	.shutdown = cciss_remove_one,
 };
 
 /*
_

Patches currently in -mm which might be from mikem@beardog.cca.cpqcorp.net are

origin.patch
