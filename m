From: akpm@linux-foundation.org
Subject: + i-oat-clean-up-error-handling-and-some-print-messages.patch added to -mm tree
Date: Wed, 17 Oct 2007 17:30:52 -0700
Message-ID: <200710180030.l9I0Uq5q015939@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43148 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762809AbXJRAaz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Oct 2007 20:30:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shannon.nelson@intel.com, dan.j.williams@intel.com


The patch titled
     I/OAT: clean up error handling and some print messages
has been added to the -mm tree.  Its filename is
     i-oat-clean-up-error-handling-and-some-print-messages.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: I/OAT: clean up error handling and some print messages
From: Shannon Nelson <shannon.nelson@intel.com>

Make better use of dev_err(), and catch an error where the transaction
creation might fail.

Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/ioat.c     |    3 ++-
 drivers/dma/ioat_dca.c |   12 ++++++------
 drivers/dma/ioat_dma.c |   32 +++++++++++++++++++++-----------
 drivers/dma/ioatdma.h  |    2 ++
 4 files changed, 31 insertions(+), 18 deletions(-)

diff -puN drivers/dma/ioat.c~i-oat-clean-up-error-handling-and-some-print-messages drivers/dma/ioat.c
--- a/drivers/dma/ioat.c~i-oat-clean-up-error-handling-and-some-print-messages
+++ a/drivers/dma/ioat.c
@@ -34,7 +34,7 @@
 #include "ioatdma_registers.h"
 #include "ioatdma_hw.h"
 
-MODULE_VERSION("1.24");
+MODULE_VERSION(IOAT_DMA_VERSION);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Intel Corporation");
 
@@ -85,6 +85,7 @@ static void ioat_shutdown_functionality(
 {
 	struct ioat_device *device = pci_get_drvdata(pdev);
 
+	dev_err(&pdev->dev, "Removing dma and dca services\n");
 	if (device->dca) {
 		unregister_dca_provider(device->dca);
 		free_dca_provider(device->dca);
diff -puN drivers/dma/ioat_dca.c~i-oat-clean-up-error-handling-and-some-print-messages drivers/dma/ioat_dca.c
--- a/drivers/dma/ioat_dca.c~i-oat-clean-up-error-handling-and-some-print-messages
+++ a/drivers/dma/ioat_dca.c
@@ -65,7 +65,7 @@ static inline u16 dcaid_from_pcidev(stru
 	return (pci->bus->number << 8) | pci->devfn;
 }
 
-static int dca_enabled_in_bios(void)
+static int dca_enabled_in_bios(struct pci_dev *pdev)
 {
 	/* CPUID level 9 returns DCA configuration */
 	/* Bit 0 indicates DCA enabled by the BIOS */
@@ -75,17 +75,17 @@ static int dca_enabled_in_bios(void)
 	cpuid_level_9 = cpuid_eax(9);
 	res = test_bit(0, &cpuid_level_9);
 	if (!res)
-		printk(KERN_ERR "ioat dma: DCA is disabled in BIOS\n");
+		dev_err(&pdev->dev, "DCA is disabled in BIOS\n");
 
 	return res;
 }
 
-static int system_has_dca_enabled(void)
+static int system_has_dca_enabled(struct pci_dev *pdev)
 {
 	if (boot_cpu_has(X86_FEATURE_DCA))
-		return dca_enabled_in_bios();
+		return dca_enabled_in_bios(pdev);
 
-	printk(KERN_ERR "ioat dma: boot cpu doesn't have X86_FEATURE_DCA\n");
+	dev_err(&pdev->dev, "boot cpu doesn't have X86_FEATURE_DCA\n");
 	return 0;
 }
 
@@ -208,7 +208,7 @@ struct dca_provider *ioat_dca_init(struc
 	int i;
 	int err;
 
-	if (!system_has_dca_enabled())
+	if (!system_has_dca_enabled(pdev))
 		return NULL;
 
 	/* I/OAT v1 systems must have a known tag_map to support DCA */
diff -puN drivers/dma/ioat_dma.c~i-oat-clean-up-error-handling-and-some-print-messages drivers/dma/ioat_dma.c
--- a/drivers/dma/ioat_dma.c~i-oat-clean-up-error-handling-and-some-print-messages
+++ a/drivers/dma/ioat_dma.c
@@ -267,7 +267,7 @@ static int ioat_dma_alloc_chan_resources
 	chanerr = readl(ioat_chan->reg_base + IOAT_CHANERR_OFFSET);
 	if (chanerr) {
 		dev_err(&ioat_chan->device->pdev->dev,
-			"ioatdma: CHANERR = %x, clearing\n", chanerr);
+			"CHANERR = %x, clearing\n", chanerr);
 		writel(chanerr, ioat_chan->reg_base + IOAT_CHANERR_OFFSET);
 	}
 
@@ -276,7 +276,7 @@ static int ioat_dma_alloc_chan_resources
 		desc = ioat_dma_alloc_descriptor(ioat_chan, GFP_KERNEL);
 		if (!desc) {
 			dev_err(&ioat_chan->device->pdev->dev,
-				"ioatdma: Only %d initial descriptors\n", i);
+				"Only %d initial descriptors\n", i);
 			break;
 		}
 		list_add_tail(&desc->node, &tmp_list);
@@ -342,7 +342,7 @@ static void ioat_dma_free_chan_resources
 	/* one is ok since we left it on there on purpose */
 	if (in_use_descs > 1)
 		dev_err(&ioat_chan->device->pdev->dev,
-			"ioatdma: Freeing %d in use descriptors!\n",
+			"Freeing %d in use descriptors!\n",
 			in_use_descs - 1);
 
 	ioat_chan->last_completion = ioat_chan->completion_addr = 0;
@@ -482,7 +482,7 @@ static void ioat_dma_memcpy_cleanup(stru
 	if ((ioat_chan->completion_virt->full & IOAT_CHANSTS_DMA_TRANSFER_STATUS) ==
 				IOAT_CHANSTS_DMA_TRANSFER_STATUS_HALTED) {
 		dev_err(&ioat_chan->device->pdev->dev,
-			"ioatdma: Channel halted, chanerr = %x\n",
+			"Channel halted, chanerr = %x\n",
 			readl(ioat_chan->reg_base + IOAT_CHANERR_OFFSET));
 
 		/* TODO do something to salvage the situation */
@@ -643,7 +643,7 @@ static int ioat_dma_self_test(struct ioa
 	u8 *src;
 	u8 *dest;
 	struct dma_chan *dma_chan;
-	struct dma_async_tx_descriptor *tx;
+	struct dma_async_tx_descriptor *tx = NULL;
 	dma_addr_t addr;
 	dma_cookie_t cookie;
 	int err = 0;
@@ -673,6 +673,13 @@ static int ioat_dma_self_test(struct ioa
 	}
 
 	tx = ioat_dma_prep_memcpy(dma_chan, IOAT_TEST_SIZE, 0);
+	if (!tx) {
+		dev_err(&device->pdev->dev,
+			"Self-test prep failed, disabling\n");
+		err = -ENODEV;
+		goto free_resources;
+	}
+
 	async_tx_ack(tx);
 	addr = dma_map_single(dma_chan->device->dev, src, IOAT_TEST_SIZE,
 			DMA_TO_DEVICE);
@@ -686,13 +693,13 @@ static int ioat_dma_self_test(struct ioa
 
 	if (ioat_dma_is_complete(dma_chan, cookie, NULL, NULL) != DMA_SUCCESS) {
 		dev_err(&device->pdev->dev,
-			"ioatdma: Self-test copy timed out, disabling\n");
+			"Self-test copy timed out, disabling\n");
 		err = -ENODEV;
 		goto free_resources;
 	}
 	if (memcmp(src, dest, IOAT_TEST_SIZE)) {
 		dev_err(&device->pdev->dev,
-			"ioatdma: Self-test copy failed compare, disabling\n");
+			"Self-test copy failed compare, disabling\n");
 		err = -ENODEV;
 		goto free_resources;
 	}
@@ -730,6 +737,9 @@ static int ioat_dma_setup_interrupts(str
 		goto msi;
 	if (!strcmp(ioat_interrupt_style, "intx"))
 		goto intx;
+	dev_err(&device->pdev->dev, "invalid ioat_interrupt_style %s\n",
+		ioat_interrupt_style);
+	goto err_no_irq;
 
 msix:
 	/* The number of MSI-X vectors should equal the number of channels */
@@ -906,9 +916,9 @@ struct ioatdma_device *ioat_dma_probe(st
 	device->common.device_dependency_added = ioat_dma_dependency_added;
 	device->common.dev = &pdev->dev;
 	dev_err(&device->pdev->dev,
-		"ioatdma: Intel(R) I/OAT DMA Engine found,"
-		" %d channels, device version 0x%02x\n",
-		device->common.chancnt, device->version);
+		"Intel(R) I/OAT DMA Engine found,"
+		" %d channels, device version 0x%02x, driver version %s\n",
+		device->common.chancnt, device->version, IOAT_DMA_VERSION);
 
 	err = ioat_dma_setup_interrupts(device);
 	if (err)
@@ -932,7 +942,7 @@ err_dma_pool:
 	kfree(device);
 err_kzalloc:
 	dev_err(&device->pdev->dev,
-		"ioatdma: Intel(R) I/OAT DMA Engine initialization failed\n");
+		"Intel(R) I/OAT DMA Engine initialization failed\n");
 	return NULL;
 }
 
diff -puN drivers/dma/ioatdma.h~i-oat-clean-up-error-handling-and-some-print-messages drivers/dma/ioatdma.h
--- a/drivers/dma/ioatdma.h~i-oat-clean-up-error-handling-and-some-print-messages
+++ a/drivers/dma/ioatdma.h
@@ -28,6 +28,8 @@
 #include <linux/cache.h>
 #include <linux/pci_ids.h>
 
+#define IOAT_DMA_VERSION "1.26"
+
 enum ioat_interrupt {
 	none = 0,
 	msix_multi_vector = 1,
_

Patches currently in -mm which might be from shannon.nelson@intel.com are

origin.patch
remove-unsafe-from-module-struct.patch
i-oat-cleanup-pci-issues.patch
i-oat-clean-up-of-dca-provider-start-and-stop.patch
i-oat-clean-up-error-handling-and-some-print-messages.patch
i-oat-tighten-descriptor-setup-performance.patch
