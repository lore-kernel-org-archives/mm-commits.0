From: akpm@linux-foundation.org
Subject: + x86-64-calgary-tighten-up-the-bitmap-locking.patch added to -mm tree
Date: Wed, 11 Jul 2007 17:42:54 -0700
Message-ID: <200707120042.l6C0gsJk030787@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33595 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759651AbXGLAnH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jul 2007 20:43:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: muli@il.ibm.com, ak@suse.de


The patch titled
     x86-64:  Calgary - tighten up the bitmap locking
has been added to the -mm tree.  Its filename is
     x86-64-calgary-tighten-up-the-bitmap-locking.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86-64:  Calgary - tighten up the bitmap locking
From: Muli Ben-Yehuda <muli@il.ibm.com>

Currently the IOMMU table's lock protects both the bitmap and access
to the hardware's TCE table. Access to the TCE table is synchronized
through the bitmap; therefore, only hold the lock while modifying the
bitmap. This gives a yummy 10-15% reduction in CPU utilization for
netperf on a large SMP machine.

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/pci-calgary.c |   40 ++++++++++++-----------------
 1 files changed, 17 insertions(+), 23 deletions(-)

diff -puN arch/x86_64/kernel/pci-calgary.c~x86-64-calgary-tighten-up-the-bitmap-locking arch/x86_64/kernel/pci-calgary.c
--- a/arch/x86_64/kernel/pci-calgary.c~x86-64-calgary-tighten-up-the-bitmap-locking
+++ a/arch/x86_64/kernel/pci-calgary.c
@@ -233,6 +233,7 @@ static void iommu_range_reserve(struct i
 	unsigned long index;
 	unsigned long end;
 	unsigned long badbit;
+	unsigned long flags;
 
 	index = start_addr >> PAGE_SHIFT;
 
@@ -244,6 +245,8 @@ static void iommu_range_reserve(struct i
 	if (end > tbl->it_size) /* don't go off the table */
 		end = tbl->it_size;
 
+	spin_lock_irqsave(&tbl->it_lock, flags);
+
 	badbit = verify_bit_range(tbl->it_map, 0, index, end);
 	if (badbit != ~0UL) {
 		if (printk_ratelimit())
@@ -253,15 +256,20 @@ static void iommu_range_reserve(struct i
 	}
 
 	set_bit_string(tbl->it_map, index, npages);
+
+	spin_unlock_irqrestore(&tbl->it_lock, flags);
 }
 
 static unsigned long iommu_range_alloc(struct iommu_table *tbl,
 	unsigned int npages)
 {
+	unsigned long flags;
 	unsigned long offset;
 
 	BUG_ON(npages == 0);
 
+	spin_lock_irqsave(&tbl->it_lock, flags);
+
 	offset = find_next_zero_string(tbl->it_map, tbl->it_hint,
 				       tbl->it_size, npages);
 	if (offset == ~0UL) {
@@ -270,6 +278,7 @@ static unsigned long iommu_range_alloc(s
 					       tbl->it_size, npages);
 		if (offset == ~0UL) {
 			printk(KERN_WARNING "Calgary: IOMMU full.\n");
+			spin_unlock_irqrestore(&tbl->it_lock, flags);
 			if (panic_on_overflow)
 				panic("Calgary: fix the allocator.\n");
 			else
@@ -281,17 +290,17 @@ static unsigned long iommu_range_alloc(s
 	tbl->it_hint = offset + npages;
 	BUG_ON(tbl->it_hint > tbl->it_size);
 
+	spin_unlock_irqrestore(&tbl->it_lock, flags);
+
 	return offset;
 }
 
 static dma_addr_t iommu_alloc(struct iommu_table *tbl, void *vaddr,
 	unsigned int npages, int direction)
 {
-	unsigned long entry, flags;
+	unsigned long entry;
 	dma_addr_t ret = bad_dma_address;
 
-	spin_lock_irqsave(&tbl->it_lock, flags);
-
 	entry = iommu_range_alloc(tbl, npages);
 
 	if (unlikely(entry == bad_dma_address))
@@ -304,12 +313,9 @@ static dma_addr_t iommu_alloc(struct iom
 	tce_build(tbl, entry, npages, (unsigned long)vaddr & PAGE_MASK,
 		  direction);
 
-	spin_unlock_irqrestore(&tbl->it_lock, flags);
-
 	return ret;
 
 error:
-	spin_unlock_irqrestore(&tbl->it_lock, flags);
 	printk(KERN_WARNING "Calgary: failed to allocate %u pages in "
 	       "iommu %p\n", npages, tbl);
 	return bad_dma_address;
@@ -321,6 +327,7 @@ static void __iommu_free(struct iommu_ta
 	unsigned long entry;
 	unsigned long badbit;
 	unsigned long badend;
+	unsigned long flags;
 
 	/* were we called with bad_dma_address? */
 	badend = bad_dma_address + (EMERGENCY_PAGES * PAGE_SIZE);
@@ -337,6 +344,8 @@ static void __iommu_free(struct iommu_ta
 
 	tce_free(tbl, entry, npages);
 
+	spin_lock_irqsave(&tbl->it_lock, flags);
+
 	badbit = verify_bit_range(tbl->it_map, 1, entry, entry + npages);
 	if (badbit != ~0UL) {
 		if (printk_ratelimit())
@@ -346,18 +355,14 @@ static void __iommu_free(struct iommu_ta
 	}
 
 	__clear_bit_string(tbl->it_map, entry, npages);
+
+	spin_unlock_irqrestore(&tbl->it_lock, flags);
 }
 
 static void iommu_free(struct iommu_table *tbl, dma_addr_t dma_addr,
 	unsigned int npages)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&tbl->it_lock, flags);
-
 	__iommu_free(tbl, dma_addr, npages);
-
-	spin_unlock_irqrestore(&tbl->it_lock, flags);
 }
 
 static inline struct iommu_table *find_iommu_table(struct device *dev)
@@ -402,17 +407,12 @@ static void __calgary_unmap_sg(struct io
 void calgary_unmap_sg(struct device *dev, struct scatterlist *sglist,
 		      int nelems, int direction)
 {
-	unsigned long flags;
 	struct iommu_table *tbl = find_iommu_table(dev);
 
 	if (!translate_phb(to_pci_dev(dev)))
 		return;
 
-	spin_lock_irqsave(&tbl->it_lock, flags);
-
 	__calgary_unmap_sg(tbl, sglist, nelems, direction);
-
-	spin_unlock_irqrestore(&tbl->it_lock, flags);
 }
 
 static int calgary_nontranslate_map_sg(struct device* dev,
@@ -433,7 +433,6 @@ int calgary_map_sg(struct device *dev, s
 	int nelems, int direction)
 {
 	struct iommu_table *tbl = find_iommu_table(dev);
-	unsigned long flags;
 	unsigned long vaddr;
 	unsigned int npages;
 	unsigned long entry;
@@ -442,8 +441,6 @@ int calgary_map_sg(struct device *dev, s
 	if (!translate_phb(to_pci_dev(dev)))
 		return calgary_nontranslate_map_sg(dev, sg, nelems, direction);
 
-	spin_lock_irqsave(&tbl->it_lock, flags);
-
 	for (i = 0; i < nelems; i++ ) {
 		struct scatterlist *s = &sg[i];
 		BUG_ON(!s->page);
@@ -467,8 +464,6 @@ int calgary_map_sg(struct device *dev, s
 		s->dma_length = s->length;
 	}
 
-	spin_unlock_irqrestore(&tbl->it_lock, flags);
-
 	return nelems;
 error:
 	__calgary_unmap_sg(tbl, sg, nelems, direction);
@@ -476,7 +471,6 @@ error:
 		sg[i].dma_address = bad_dma_address;
 		sg[i].dma_length = 0;
 	}
-	spin_unlock_irqrestore(&tbl->it_lock, flags);
 	return 0;
 }
 
_

Patches currently in -mm which might be from muli@il.ibm.com are

x86-64-calgary-generalize-calgary_increase_split_completion_timeout.patch
x86-64-calgary-update-copyright-notice.patch
x86-64-calgary-introduce-handle_quirks-for-various-chipset-quirks.patch
x86-64-calgary-introduce-chipset-specific-ops.patch
x86-64-calgary-abstract-how-we-find-the-iommu_table-for-a-device.patch
x86-64-calgary-introduce-calioc2-support.patch
x86-64-calgary-add-chip_ops-and-a-quirk-function-for-calioc2.patch
x86-64-calgary-implement-calioc2-tce-cache-flush-sequence.patch
x86-64-calgary-make-dump_error_regs-a-chip-op.patch
x86-64-calgary-grab-plssr-too-when-a-dma-error-occurs.patch
x86-64-calgary-reserve-tces-with-the-same-address-as-mem-regions.patch
x86-64-calgary-cleanup-of-unneeded-macros.patch
x86-64-calgary-tabify-and-trim-trailing-whitespace.patch
x86-64-calgary-only-reserve-the-first-1mb-of-io-space-for-calioc2.patch
x86-64-calgary-tidy-up-debug-printks.patch
x86-64-calgary-fix-few-style-problems-pointed-out-by-checkpatchpl.patch
x86-64-calgary-tighten-up-the-bitmap-locking.patch
x86-64-calgary-fold-in-redundant-functions.patch
x86_64-calgary-change-_map_single-etc-to-static.patch
x86-64-disable-the-gart-in-shutdown.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh.patch
oss-trident-massive-whitespace-removal.patch
oss-trident-fix-locking-around-write_voice_regs.patch
oss-trident-replace-deprecated-pci_find_device-with-pci_get_device.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
