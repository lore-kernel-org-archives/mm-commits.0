From: akpm@linux-foundation.org
Subject: - intel-iommu-iova-allocation-and-management-routines-fix-2.patch removed from -mm tree
Date: Mon, 09 Jul 2007 16:48:03 -0700
Message-ID: <200707092348.l69Nm39D021343@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42029 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757560AbXGIXsL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 19:48:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anil.s.keshavamurthy@intel.com, mm-commits@vger.kernel.org


The patch titled
     intel-iommu-iova-allocation-and-management-routines-fix 2
has been removed from the -mm tree.  Its filename was
     intel-iommu-iova-allocation-and-management-routines-fix-2.patch

This patch was dropped because it was folded into intel-iommu-iova-allocation-and-management-routines.patch

------------------------------------------------------
Subject: intel-iommu-iova-allocation-and-management-routines-fix 2
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>

Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/iova.c |   22 ++++++++++++++--------
 drivers/pci/iova.h |    4 ++--
 2 files changed, 16 insertions(+), 10 deletions(-)

diff -puN drivers/pci/iova.c~intel-iommu-iova-allocation-and-management-routines-fix-2 drivers/pci/iova.c
--- a/drivers/pci/iova.c~intel-iommu-iova-allocation-and-management-routines-fix-2
+++ a/drivers/pci/iova.c
@@ -166,6 +166,7 @@ struct iova *find_iova(struct iova_domai
 	unsigned long flags;
 	struct rb_node *node;
 
+	/* Take the lock so that no other thread is manipulating the rbtree */
 	spin_lock_irqsave(&iovad->iova_rbtree_lock, flags);
 	node = iovad->rbroot.rb_node;
 	while (node) {
@@ -174,6 +175,12 @@ struct iova *find_iova(struct iova_domai
 		/* If pfn falls within iova's range, return iova */
 		if ((pfn >= iova->pfn_lo) && (pfn <= iova->pfn_hi)) {
 			spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
+			/* We are not holding the lock while this iova
+			 * is referenced by the caller as the same thread
+			 * which called this function also calls __free_iova()
+			 * and it is by desing that only one thread can possibly
+			 * reference a particular iova and hence no conflict.
+			 */
 			return iova;
 		}
 
@@ -198,13 +205,11 @@ __free_iova(struct iova_domain *iovad, s
 {
 	unsigned long flags;
 
-	if (iova) {
-		spin_lock_irqsave(&iovad->iova_rbtree_lock, flags);
-		__cached_rbnode_delete_update(iovad, iova);
-		rb_erase(&iova->node, &iovad->rbroot);
-		spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
-		free_iova_mem(iova);
-	}
+	spin_lock_irqsave(&iovad->iova_rbtree_lock, flags);
+	__cached_rbnode_delete_update(iovad, iova);
+	rb_erase(&iova->node, &iovad->rbroot);
+	spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
+	free_iova_mem(iova);
 }
 
 /**
@@ -218,7 +223,8 @@ void
 free_iova(struct iova_domain *iovad, unsigned long pfn)
 {
 	struct iova *iova = find_iova(iovad, pfn);
-	__free_iova(iovad, iova);
+	if (iova)
+		__free_iova(iovad, iova);
 
 }
 
diff -puN drivers/pci/iova.h~intel-iommu-iova-allocation-and-management-routines-fix-2 drivers/pci/iova.h
--- a/drivers/pci/iova.h~intel-iommu-iova-allocation-and-management-routines-fix-2
+++ a/drivers/pci/iova.h
@@ -24,8 +24,8 @@
 #define PAGE_MASK_4K		(((u64)-1) << PAGE_SHIFT_4K)
 #define PAGE_ALIGN_4K(addr)	(((addr) + PAGE_SIZE_4K - 1) & PAGE_MASK_4K)
 
-#define IOVA_START_ADDR		(0x1000)
-#define IOVA_START_PFN		(IOVA_START_ADDR >> PAGE_SHIFT_4K)
+/* IO virtual address start page frame number */
+#define IOVA_START_PFN		(1)
 
 #define IOVA_PFN(addr)		((addr) >> PAGE_SHIFT_4K)
 #define DMA_32BIT_PFN	IOVA_PFN(DMA_32BIT_MASK)
_

Patches currently in -mm which might be from anil.s.keshavamurthy@intel.com are

jprobes-make-struct-jprobeentry-a-void.patch
jprobes-remove-jprobe_entry.patch
jprobes-make-jprobes-a-little-safer-for-users.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-iova-allocation-and-management-routines-fix-2.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-intel-iommu-driver-fix.patch
intel-iommu-intel-iommu-driver-fix-2.patch
intel-iommu-intel-iommu-driver-fix-duplicate-config_dmar-makefile-line.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
intel-iommu-iommu-floppy-workaround-fix.patch
intel-iommu-iommu-floppy-workaround-fix-fix.patch
