From: akpm@linux-foundation.org
Subject: - i-oat-cleanup-pci-issues.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:46:29 -0700
Message-ID: <200710190346.l9J3kTX5013332@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46729 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752604AbXJSD4W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:56:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shannon.nelson@intel.com, dan.j.williams@intel.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     I/OAT: cleanup pci issues
has been removed from the -mm tree.  Its filename was
     i-oat-cleanup-pci-issues.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: I/OAT: cleanup pci issues
From: Shannon Nelson <shannon.nelson@intel.com>

Reorder the pci release actions
    Letting go of the resources in the right order helps get rid of
    occasional kernel complaints.

Fix the pci_driver object name [Randy Dunlap]
    Rename the struct pci_driver data so that false section mismatch
    warnings won't be produced.

Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/ioat.c     |   23 ++++++-----------------
 drivers/dma/ioat_dma.c |    5 ++++-
 2 files changed, 10 insertions(+), 18 deletions(-)

diff -puN drivers/dma/ioat.c~i-oat-cleanup-pci-issues drivers/dma/ioat.c
--- a/drivers/dma/ioat.c~i-oat-cleanup-pci-issues
+++ a/drivers/dma/ioat.c
@@ -55,9 +55,7 @@ struct ioat_device {
 
 static int __devinit ioat_probe(struct pci_dev *pdev,
 				const struct pci_device_id *id);
-#ifdef IOAT_DMA_REMOVE
 static void __devexit ioat_remove(struct pci_dev *pdev);
-#endif
 
 static int ioat_dca_enabled = 1;
 module_param(ioat_dca_enabled, int, 0644);
@@ -100,14 +98,12 @@ static void ioat_shutdown_functionality(
 
 }
 
-static struct pci_driver ioat_pci_drv = {
+static struct pci_driver ioat_pci_driver = {
 	.name		= "ioatdma",
 	.id_table	= ioat_pci_tbl,
 	.probe		= ioat_probe,
 	.shutdown	= ioat_shutdown_functionality,
-#ifdef IOAT_DMA_REMOVE
 	.remove		= __devexit_p(ioat_remove),
-#endif
 };
 
 static int __devinit ioat_probe(struct pci_dev *pdev,
@@ -122,7 +118,7 @@ static int __devinit ioat_probe(struct p
 	if (err)
 		goto err_enable_device;
 
-	err = pci_request_regions(pdev, ioat_pci_drv.name);
+	err = pci_request_regions(pdev, ioat_pci_driver.name);
 	if (err)
 		goto err_request_regions;
 
@@ -176,13 +172,11 @@ err_enable_device:
 	return err;
 }
 
-#ifdef IOAT_DMA_REMOVE
 /*
  * It is unsafe to remove this module: if removed while a requested
  * dma is outstanding, esp. from tcp, it is possible to hang while
- * waiting for something that will never finish, thus hanging at
- * least one cpu.  However, if you're feeling lucky and need to do
- * some testing, this usually works just fine.
+ * waiting for something that will never finish.  However, if you're
+ * feeling lucky, this usually works just fine.
  */
 static void __devexit ioat_remove(struct pci_dev *pdev)
 {
@@ -191,21 +185,16 @@ static void __devexit ioat_remove(struct
 	ioat_shutdown_functionality(pdev);
 
 	kfree(device);
-
-	iounmap(device->iobase);
-	pci_release_regions(pdev);
-	pci_disable_device(pdev);
 }
-#endif
 
 static int __init ioat_init_module(void)
 {
-	return pci_register_driver(&ioat_pci_drv);
+	return pci_register_driver(&ioat_pci_driver);
 }
 module_init(ioat_init_module);
 
 static void __exit ioat_exit_module(void)
 {
-	pci_unregister_driver(&ioat_pci_drv);
+	pci_unregister_driver(&ioat_pci_driver);
 }
 module_exit(ioat_exit_module);
diff -puN drivers/dma/ioat_dma.c~i-oat-cleanup-pci-issues drivers/dma/ioat_dma.c
--- a/drivers/dma/ioat_dma.c~i-oat-cleanup-pci-issues
+++ a/drivers/dma/ioat_dma.c
@@ -931,7 +931,6 @@ err_completion_pool:
 err_dma_pool:
 	kfree(device);
 err_kzalloc:
-	iounmap(iobase);
 	dev_err(&device->pdev->dev,
 		"ioatdma: Intel(R) I/OAT DMA Engine initialization failed\n");
 	return NULL;
@@ -949,6 +948,10 @@ void ioat_dma_remove(struct ioatdma_devi
 	pci_pool_destroy(device->dma_pool);
 	pci_pool_destroy(device->completion_pool);
 
+	iounmap(device->reg_base);
+	pci_release_regions(device->pdev);
+	pci_disable_device(device->pdev);
+
 	list_for_each_entry_safe(chan, _chan,
 				 &device->common.channels, device_node) {
 		ioat_chan = to_ioat_chan(chan);
_

Patches currently in -mm which might be from shannon.nelson@intel.com are

origin.patch
