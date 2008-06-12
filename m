From: akpm@linux-foundation.org
Subject: + dma-mapping-x86-per-device-dma_mapping_ops-support-fix-2.patch added to -mm tree
Date: Thu, 12 Jun 2008 01:32:04 -0700
Message-ID: <200806120832.m5C8W4Q2010005@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55954 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754060AbYFLIeV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 04:34:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, andi@firstfloor.org, avi@qumranet.com, mingo@elte.hu, muli@il.ibm.com, tglx@linutronix.de


The patch titled
     fix per-device dma_mapping_ops support
has been added to the -mm tree.  Its filename is
     dma-mapping-x86-per-device-dma_mapping_ops-support-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -318,6 +318,8 @@ static int dma_release_coherent(struct d
 
 int dma_supported(struct device *dev, u64 mask)
 {
+	struct dma_mapping_ops *ops = get_dma_ops(dev);
+
 #ifdef CONFIG_PCI
 	if (mask > 0xffffffff && forbid_dac > 0) {
 		dev_info(dev, "PCI: Disallowing DAC for device\n");
@@ -325,8 +327,8 @@ int dma_supported(struct device *dev, u6
 	}
 #endif
 
-	if (dma_ops->dma_supported)
-		return dma_ops->dma_supported(dev, mask);
+	if (ops->dma_supported)
+		return ops->dma_supported(dev, mask);
 
 	/* Copied from i386. Doesn't make much sense, because it will
 	   only work for pci_alloc_coherent.
@@ -373,6 +375,7 @@ void *
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

linux-next.patch
block-add-blk_queue_update_dma_pad.patch
ide-use-the-dma-safe-check-for-req_type_ata_pc.patch
block-blk_rq_map_kern-uses-the-bounce-buffers-for-stack-buffers.patch
ide-avoid-dma-on-the-stack-for-req_type_ata_pc.patch
scsi-sr-avoids-useless-buffer-allocation.patch
cdrom-revert-commit-22a9189-cdrom-use-kmalloced-buffers-instead-of-buffers-on-stack.patch
add-a-helper-function-to-test-if-an-object-is-on-the-stack.patch
clean-up-duplicated-alloc-free_thread_info.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sge-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-svc_rdma-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-bnx2x.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sparc32.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-b34-fix.patch
dma-mapping-x86-per-device-dma_mapping_ops-support.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix-2.patch

