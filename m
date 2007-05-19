From: akpm@linux-foundation.org
Subject: - cciss-fix-pci_drivershutdown-while-device-is-still-active.patch removed from -mm tree
Date: Sat, 19 May 2007 10:18:22 -0700
Message-ID: <200705191718.l4JHILKW007005@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44834 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756115AbXESRVx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 19 May 2007 13:21:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gbritton@alum.mit.edu, mike.miller@hp.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     cciss: fix pci_driver.shutdown while device is still active
has been removed from the -mm tree.  Its filename was
     cciss-fix-pci_drivershutdown-while-device-is-still-active.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cciss: fix pci_driver.shutdown while device is still active
From: Gerald Britton <gbritton@alum.mit.edu>

Fix an Oops in the cciss driver caused by system shutdown while a
filesystem on a cciss device is still active.  The cciss_remove_one
function only properly removes the device if the device has been cleanly
released by its users, which is not the case when the pci_driver.shutdown
method is called.

This patch adds a new cciss_shutdown function to better match the pattern
used by various SCSI drivers: deactivate device interrupts and flush
caches.  It also alters the cciss_remove_one function to match and readds
the __devexit annotation that was removed when cciss_remove_one was serving
as the pci_driver.shutdown method.

Signed-off-by: Gerald Britton <gbritton@alum.mit.edu>
Acked-by: Mike Miller <mike.miller@hp.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |   45 ++++++++++++++++++++++++++--------------
 1 files changed, 30 insertions(+), 15 deletions(-)

diff -puN drivers/block/cciss.c~cciss-fix-pci_drivershutdown-while-device-is-still-active drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-fix-pci_drivershutdown-while-device-is-still-active
+++ a/drivers/block/cciss.c
@@ -3469,13 +3469,39 @@ static int __devinit cciss_init_one(stru
 	return -1;
 }
 
-static void cciss_remove_one(struct pci_dev *pdev)
+static void cciss_shutdown(struct pci_dev *pdev)
 {
 	ctlr_info_t *tmp_ptr;
-	int i, j;
+	int i;
 	char flush_buf[4];
 	int return_code;
 
+	tmp_ptr = pci_get_drvdata(pdev);
+	if (tmp_ptr == NULL)
+		return;
+	i = tmp_ptr->ctlr;
+	if (hba[i] == NULL)
+		return;
+
+	/* Turn board interrupts off  and send the flush cache command */
+	/* sendcmd will turn off interrupt, and send the flush...
+	 * To write all data in the battery backed cache to disks */
+	memset(flush_buf, 0, 4);
+	return_code = sendcmd(CCISS_CACHE_FLUSH, i, flush_buf, 4, 0, 0, 0, NULL,
+			      TYPE_CMD);
+	if (return_code == IO_OK) {
+		printk(KERN_INFO "Completed flushing cache on controller %d\n", i);
+	} else {
+		printk(KERN_WARNING "Error flushing cache on controller %d\n", i);
+	}
+	free_irq(hba[i]->intr[2], hba[i]);
+}
+
+static void __devexit cciss_remove_one(struct pci_dev *pdev)
+{
+	ctlr_info_t *tmp_ptr;
+	int i, j;
+
 	if (pci_get_drvdata(pdev) == NULL) {
 		printk(KERN_ERR "cciss: Unable to remove device \n");
 		return;
@@ -3506,18 +3532,7 @@ static void cciss_remove_one(struct pci_
 
 	cciss_unregister_scsi(i);	/* unhook from SCSI subsystem */
 
-	/* Turn board interrupts off  and send the flush cache command */
-	/* sendcmd will turn off interrupt, and send the flush...
-	 * To write all data in the battery backed cache to disks */
-	memset(flush_buf, 0, 4);
-	return_code = sendcmd(CCISS_CACHE_FLUSH, i, flush_buf, 4, 0, 0, 0, NULL,
-			      TYPE_CMD);
-	if (return_code == IO_OK) {
-		printk(KERN_INFO "Completed flushing cache on controller %d\n", i);
-	} else {
-		printk(KERN_WARNING "Error flushing cache on controller %d\n", i);
-	}
-	free_irq(hba[i]->intr[2], hba[i]);
+	cciss_shutdown(pdev);
 
 #ifdef CONFIG_PCI_MSI
 	if (hba[i]->msix_vector)
@@ -3550,7 +3565,7 @@ static struct pci_driver cciss_pci_drive
 	.probe = cciss_init_one,
 	.remove = __devexit_p(cciss_remove_one),
 	.id_table = cciss_pci_device_id,	/* id_table */
-	.shutdown = cciss_remove_one,
+	.shutdown = cciss_shutdown,
 };
 
 /*
_

Patches currently in -mm which might be from gbritton@alum.mit.edu are
