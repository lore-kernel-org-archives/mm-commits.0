From: akpm@osdl.org
Subject: - cciss-remove-calls-to-pci_disable_device.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:06:18 -0800
Message-ID: <200612140606.kBE66I1a001868@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51892 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864AbWLNGGk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:06:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.miller@hp.com, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     cciss: remove calls to pci_disable_device
has been removed from the -mm tree.  Its filename was
     cciss-remove-calls-to-pci_disable_device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cciss: remove calls to pci_disable_device
From: Mike Miller <mike.miller@hp.com>

Remove calls to pci_disable_device except in fail_all_cmds.  The
pci_disable_device function does something nasty to Smart Array controllers
that pci_enable_device does not undo.  So if the driver is unloaded it
cannot be reloaded.

Also, customers can disable any pci device via the ROM Based Setup Utility
(RBSU).  If the customer has disabled the controller we should not try to
blindly enable the card from the driver.  Please consider this for
inclusion.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/block/cciss.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff -puN drivers/block/cciss.c~cciss-remove-calls-to-pci_disable_device drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-remove-calls-to-pci_disable_device
+++ a/drivers/block/cciss.c
@@ -2837,7 +2837,7 @@ static int cciss_pci_init(ctlr_info_t *c
 	if (err) {
 		printk(KERN_ERR "cciss: Cannot obtain PCI resources, "
 		       "aborting\n");
-		goto err_out_disable_pdev;
+		return err;
 	}
 
 	subsystem_vendor_id = pdev->subsystem_vendor;
@@ -3005,10 +3005,11 @@ static int cciss_pci_init(ctlr_info_t *c
 	return 0;
 
       err_out_free_res:
+	/*
+	 * Deliberately omit pci_disable_device(): it does something nasty to
+	 * Smart Array controllers that pci_enable_device does not undo
+	 */
 	pci_release_regions(pdev);
-
-      err_out_disable_pdev:
-	pci_disable_device(pdev);
 	return err;
 }
 
@@ -3382,8 +3383,11 @@ static int __devinit cciss_init_one(stru
 		if (drv->queue)
 			blk_cleanup_queue(drv->queue);
 	}
+	/*
+	 * Deliberately omit pci_disable_device(): it does something nasty to
+	 * Smart Array controllers that pci_enable_device does not undo
+	 */
 	pci_release_regions(pdev);
-	pci_disable_device(pdev);
 	pci_set_drvdata(pdev, NULL);
 	free_hba(i);
 	return -1;
@@ -3452,8 +3456,11 @@ static void __devexit cciss_remove_one(s
 #ifdef CONFIG_CISS_SCSI_TAPE
 	kfree(hba[i]->scsi_rejects.complete);
 #endif
+	/*
+	 * Deliberately omit pci_disable_device(): it does something nasty to
+	 * Smart Array controllers that pci_enable_device does not undo
+	 */
 	pci_release_regions(pdev);
-	pci_disable_device(pdev);
 	pci_set_drvdata(pdev, NULL);
 	free_hba(i);
 }
_

Patches currently in -mm which might be from mike.miller@hp.com are


