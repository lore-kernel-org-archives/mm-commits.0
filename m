From: akpm@osdl.org
Subject: + cciss-remove-calls-to-pci_disable_device.patch added to -mm tree
Date: Tue, 12 Dec 2006 17:00:03 -0800
Message-ID: <200612130100.kBD1030b023273@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:35546 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964855AbWLMBAP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Dec 2006 20:00:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mike.miller@hp.com, alan@redhat.com


The patch titled
     cciss: remove calls to pci_disable_device
has been added to the -mm tree.  Its filename is
     cciss-remove-calls-to-pci_disable_device.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 drivers/block/cciss.c |    6 +-----
 1 files changed, 1 insertion(+), 5 deletions(-)

diff -puN drivers/block/cciss.c~cciss-remove-calls-to-pci_disable_device drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-remove-calls-to-pci_disable_device
+++ a/drivers/block/cciss.c
@@ -3006,10 +3006,8 @@ static int cciss_pci_init(ctlr_info_t *c
 
       err_out_free_res:
 	pci_release_regions(pdev);
-
-      err_out_disable_pdev:
-	pci_disable_device(pdev);
 	return err;
+
 }
 
 /*
@@ -3383,7 +3381,6 @@ static int __devinit cciss_init_one(stru
 			blk_cleanup_queue(drv->queue);
 	}
 	pci_release_regions(pdev);
-	pci_disable_device(pdev);
 	pci_set_drvdata(pdev, NULL);
 	free_hba(i);
 	return -1;
@@ -3453,7 +3450,6 @@ static void __devexit cciss_remove_one(s
 	kfree(hba[i]->scsi_rejects.complete);
 #endif
 	pci_release_regions(pdev);
-	pci_disable_device(pdev);
 	pci_set_drvdata(pdev, NULL);
 	free_hba(i);
 }
_

Patches currently in -mm which might be from mike.miller@hp.com are

origin.patch
cciss-map-out-more-memory-for-config-table.patch
cciss-remove-calls-to-pci_disable_device.patch

