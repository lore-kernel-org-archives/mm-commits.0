From: akpm@linux-foundation.org
Subject: - i-oat-clean-up-of-dca-provider-start-and-stop.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:46:31 -0700
Message-ID: <200710190346.l9J3kViG013337@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48484 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966045AbXJSDzW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shannon.nelson@intel.com, dan.j.williams@intel.com, mm-commits@vger.kernel.org


The patch titled
     I/OAT: clean up of dca provider start and stop
has been removed from the -mm tree.  Its filename was
     i-oat-clean-up-of-dca-provider-start-and-stop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: I/OAT: clean up of dca provider start and stop
From: Shannon Nelson <shannon.nelson@intel.com>

Don't start ioat_dca if ioat_dma didn't start, and then stop ioat_dca
before stopping ioat_dma.  Since the ioat_dma side does the pci device
work, This takes care of ioat_dca trying to use a bad device reference.

Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/ioat.c     |   11 +++++------
 drivers/dma/ioat_dma.c |    4 ++--
 2 files changed, 7 insertions(+), 8 deletions(-)

diff -puN drivers/dma/ioat.c~i-oat-clean-up-of-dca-provider-start-and-stop drivers/dma/ioat.c
--- a/drivers/dma/ioat.c~i-oat-clean-up-of-dca-provider-start-and-stop
+++ a/drivers/dma/ioat.c
@@ -71,7 +71,7 @@ static int ioat_setup_functionality(stru
 	switch (version) {
 	case IOAT_VER_1_2:
 		device->dma = ioat_dma_probe(pdev, iobase);
-		if (ioat_dca_enabled)
+		if (device->dma && ioat_dca_enabled)
 			device->dca = ioat_dca_init(pdev, iobase);
 		break;
 	default:
@@ -85,17 +85,16 @@ static void ioat_shutdown_functionality(
 {
 	struct ioat_device *device = pci_get_drvdata(pdev);
 
-	if (device->dma) {
-		ioat_dma_remove(device->dma);
-		device->dma = NULL;
-	}
-
 	if (device->dca) {
 		unregister_dca_provider(device->dca);
 		free_dca_provider(device->dca);
 		device->dca = NULL;
 	}
 
+	if (device->dma) {
+		ioat_dma_remove(device->dma);
+		device->dma = NULL;
+	}
 }
 
 static struct pci_driver ioat_pci_driver = {
diff -puN drivers/dma/ioat_dma.c~i-oat-clean-up-of-dca-provider-start-and-stop drivers/dma/ioat_dma.c
--- a/drivers/dma/ioat_dma.c~i-oat-clean-up-of-dca-provider-start-and-stop
+++ a/drivers/dma/ioat_dma.c
@@ -941,10 +941,10 @@ void ioat_dma_remove(struct ioatdma_devi
 	struct dma_chan *chan, *_chan;
 	struct ioat_dma_chan *ioat_chan;
 
-	dma_async_device_unregister(&device->common);
-
 	ioat_dma_remove_interrupts(device);
 
+	dma_async_device_unregister(&device->common);
+
 	pci_pool_destroy(device->dma_pool);
 	pci_pool_destroy(device->completion_pool);
 
_

Patches currently in -mm which might be from shannon.nelson@intel.com are

origin.patch
