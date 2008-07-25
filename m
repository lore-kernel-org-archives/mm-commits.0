From: akpm@linux-foundation.org
Subject: - dma-mapping-x86-per-device-dma_mapping_ops-support-fix-2.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:39:49 -0700
Message-ID: <200807252339.m6PNdnKD005485@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45105 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754132AbYGYXlH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:41:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, andi@firstfloor.org, avi@qumranet.com, mingo@elte.hu, muli@il.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     fix per-device dma_mapping_ops support
has been removed from the -mm tree.  Its filename was
     dma-mapping-x86-per-device-dma_mapping_ops-support-fix-2.patch

This patch was dropped because it was folded into dma-mapping-add-the-device-argument-to-dma_mapping_error.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix per-device dma_mapping_ops support
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On x86, pci_dma_supported, pci_alloc_consistent, and pci_free_consistent
don't call DMA APIs directly (the majority of platforms do).  per-device
dma_mapping_ops support patch needs to modify pci-dma.c.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/pci-dma.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff -puN arch/x86/kernel/pci-dma.c~dma-mapping-x86-per-device-dma_mapping_ops-support-fix-2 arch/x86/kernel/pci-dma.c
--- a/arch/x86/kernel/pci-dma.c~dma-mapping-x86-per-device-dma_mapping_ops-support-fix-2
+++ a/arch/x86/kernel/pci-dma.c
@@ -312,6 +312,8 @@ static int dma_release_coherent(struct d
 
 int dma_supported(struct device *dev, u64 mask)
 {
+	struct dma_mapping_ops *ops = get_dma_ops(dev);
+
 #ifdef CONFIG_PCI
 	if (mask > 0xffffffff && forbid_dac > 0) {
 		dev_info(dev, "PCI: Disallowing DAC for device\n");
@@ -319,8 +321,8 @@ int dma_supported(struct device *dev, u6
 	}
 #endif
 
-	if (dma_ops->dma_supported)
-		return dma_ops->dma_supported(dev, mask);
+	if (ops->dma_supported)
+		return ops->dma_supported(dev, mask);
 
 	/* Copied from i386. Doesn't make much sense, because it will
 	   only work for pci_alloc_coherent.
@@ -367,6 +369,7 @@ void *
 dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
 		   gfp_t gfp)
 {
+	struct dma_mapping_ops *ops = get_dma_ops(dev);
 	void *memory = NULL;
 	struct page *page;
 	unsigned long dma_mask = 0;
@@ -435,8 +438,8 @@ dma_alloc_coherent(struct device *dev, s
 			/* Let low level make its own zone decisions */
 			gfp &= ~(GFP_DMA32|GFP_DMA);
 
-			if (dma_ops->alloc_coherent)
-				return dma_ops->alloc_coherent(dev, size,
+			if (ops->alloc_coherent)
+				return ops->alloc_coherent(dev, size,
 							   dma_handle, gfp);
 			return NULL;
 		}
@@ -448,14 +451,14 @@ dma_alloc_coherent(struct device *dev, s
 		}
 	}
 
-	if (dma_ops->alloc_coherent) {
+	if (ops->alloc_coherent) {
 		free_pages((unsigned long)memory, get_order(size));
 		gfp &= ~(GFP_DMA|GFP_DMA32);
-		return dma_ops->alloc_coherent(dev, size, dma_handle, gfp);
+		return ops->alloc_coherent(dev, size, dma_handle, gfp);
 	}
 
-	if (dma_ops->map_simple) {
-		*dma_handle = dma_ops->map_simple(dev, virt_to_phys(memory),
+	if (ops->map_simple) {
+		*dma_handle = ops->map_simple(dev, virt_to_phys(memory),
 					      size,
 					      PCI_DMA_BIDIRECTIONAL);
 		if (*dma_handle != bad_dma_address)
@@ -477,12 +480,14 @@ EXPORT_SYMBOL(dma_alloc_coherent);
 void dma_free_coherent(struct device *dev, size_t size,
 			 void *vaddr, dma_addr_t bus)
 {
+	struct dma_mapping_ops *ops = get_dma_ops(dev);
+
 	int order = get_order(size);
 	WARN_ON(irqs_disabled());	/* for portability */
 	if (dma_release_coherent(dev, order, vaddr))
 		return;
-	if (dma_ops->unmap_single)
-		dma_ops->unmap_single(dev, bus, size, 0);
+	if (ops->unmap_single)
+		ops->unmap_single(dev, bus, size, 0);
 	free_pages((unsigned long)vaddr, order);
 }
 EXPORT_SYMBOL(dma_free_coherent);
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

origin.patch
block-blk-mapc-use-the-new-object_is_on_stack-helper.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix-2.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sdhci-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-infiniband.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-more-sparc.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-ibmvscsi.patch
x86-calgary-fix-handling-of-devices-that-arent-behind-the-calgary.patch
x86-calgary-fix-handling-of-devices-that-arent-behind-the-calgary-checkpatch-fixes.patch

