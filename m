From: akpm@linux-foundation.org
Subject: + iommu-sg-powerpc-convert-iommu-to-use-the-iommu-helper.patch added to -mm tree
Date: Fri, 07 Dec 2007 14:12:22 -0800
Message-ID: <200712072212.lB7MCNNw006199@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36651 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750767AbXLGWNc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Dec 2007 17:13:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tomof@acm.org, James.Bottomley@steeleye.com, benh@kernel.crashing.org, fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org, jens.axboe@oracle.com, paulus@samba.org


The patch titled
     iommu sg: powerpc: convert iommu to use the IOMMU helper
has been added to the -mm tree.  Its filename is
     iommu-sg-powerpc-convert-iommu-to-use-the-iommu-helper.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: iommu sg: powerpc: convert iommu to use the IOMMU helper
From: FUJITA Tomonori <tomof@acm.org>

This patch converts PPC's IOMMU to use the IOMMU helper functions.  The IOMMU
doesn't allocate a memory area spanning LLD's segment boundary anymore.

iseries_hv_alloc and iseries_hv_map don't have proper device
struct. 4GB boundary is used for them.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig                   |    3 +
 arch/powerpc/kernel/dma_64.c           |    6 +-
 arch/powerpc/kernel/iommu.c            |   65 +++++++++++------------
 arch/powerpc/platforms/iseries/iommu.c |    4 -
 include/asm-powerpc/iommu.h            |   10 +--
 5 files changed, 45 insertions(+), 43 deletions(-)

diff -puN arch/powerpc/Kconfig~iommu-sg-powerpc-convert-iommu-to-use-the-iommu-helper arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~iommu-sg-powerpc-convert-iommu-to-use-the-iommu-helper
+++ a/arch/powerpc/Kconfig
@@ -227,6 +227,9 @@ config IOMMU_VMERGE
 
 	  Most drivers don't have this problem; it is safe to say Y here.
 
+config IOMMU_HELPER
+	def_bool PPC64
+
 config HOTPLUG_CPU
 	bool "Support for enabling/disabling CPUs"
 	depends on SMP && HOTPLUG && EXPERIMENTAL && (PPC_PSERIES || PPC_PMAC)
diff -puN arch/powerpc/kernel/dma_64.c~iommu-sg-powerpc-convert-iommu-to-use-the-iommu-helper arch/powerpc/kernel/dma_64.c
--- a/arch/powerpc/kernel/dma_64.c~iommu-sg-powerpc-convert-iommu-to-use-the-iommu-helper
+++ a/arch/powerpc/kernel/dma_64.c
@@ -31,8 +31,8 @@ static inline unsigned long device_to_ma
 static void *dma_iommu_alloc_coherent(struct device *dev, size_t size,
 				      dma_addr_t *dma_handle, gfp_t flag)
 {
-	return iommu_alloc_coherent(dev->archdata.dma_data, size, dma_handle,
-				    device_to_mask(dev), flag,
+	return iommu_alloc_coherent(dev, dev->archdata.dma_data, size,
+				    dma_handle, device_to_mask(dev), flag,
 				    dev->archdata.numa_node);
 }
 
@@ -52,7 +52,7 @@ static dma_addr_t dma_iommu_map_single(s
 				       size_t size,
 				       enum dma_data_direction direction)
 {
-	return iommu_map_single(dev->archdata.dma_data, vaddr, size,
+	return iommu_map_single(dev, dev->archdata.dma_data, vaddr, size,
 			        device_to_mask(dev), direction);
 }
 
diff -puN arch/powerpc/kernel/iommu.c~iommu-sg-powerpc-convert-iommu-to-use-the-iommu-helper arch/powerpc/kernel/iommu.c
--- a/arch/powerpc/kernel/iommu.c~iommu-sg-powerpc-convert-iommu-to-use-the-iommu-helper
+++ a/arch/powerpc/kernel/iommu.c
@@ -31,6 +31,7 @@
 #include <linux/string.h>
 #include <linux/dma-mapping.h>
 #include <linux/bitops.h>
+#include <linux/iommu-helper.h>
 #include <asm/io.h>
 #include <asm/prom.h>
 #include <asm/iommu.h>
@@ -81,17 +82,19 @@ static int __init setup_iommu(char *str)
 __setup("protect4gb=", setup_protect4gb);
 __setup("iommu=", setup_iommu);
 
-static unsigned long iommu_range_alloc(struct iommu_table *tbl,
+static unsigned long iommu_range_alloc(struct device *dev,
+				       struct iommu_table *tbl,
                                        unsigned long npages,
                                        unsigned long *handle,
                                        unsigned long mask,
                                        unsigned int align_order)
 { 
-	unsigned long n, end, i, start;
+	unsigned long n, end, start;
 	unsigned long limit;
 	int largealloc = npages > 15;
 	int pass = 0;
 	unsigned long align_mask;
+	unsigned long boundary_size;
 
 	align_mask = 0xffffffffffffffffl >> (64 - align_order);
 
@@ -136,14 +139,17 @@ static unsigned long iommu_range_alloc(s
 			start &= mask;
 	}
 
-	n = find_next_zero_bit(tbl->it_map, limit, start);
-
-	/* Align allocation */
-	n = (n + align_mask) & ~align_mask;
-
-	end = n + npages;
+	if (dev)
+		boundary_size = ALIGN(dma_get_seg_boundary(dev) + 1,
+				      1 << IOMMU_PAGE_SHIFT);
+	else
+		boundary_size = ALIGN(1UL << 32, 1 << IOMMU_PAGE_SHIFT);
+	/* 4GB boundary for iseries_hv_alloc and iseries_hv_map */
 
-	if (unlikely(end >= limit)) {
+	n = iommu_area_alloc(tbl->it_map, limit, start, npages,
+			     tbl->it_offset, boundary_size >> IOMMU_PAGE_SHIFT,
+			     align_mask);
+	if (n == -1) {
 		if (likely(pass < 2)) {
 			/* First failure, just rescan the half of the table.
 			 * Second failure, rescan the other half of the table.
@@ -158,14 +164,7 @@ static unsigned long iommu_range_alloc(s
 		}
 	}
 
-	for (i = n; i < end; i++)
-		if (test_bit(i, tbl->it_map)) {
-			start = i+1;
-			goto again;
-		}
-
-	for (i = n; i < end; i++)
-		__set_bit(i, tbl->it_map);
+	end = n + npages;
 
 	/* Bump the hint to a new block for small allocs. */
 	if (largealloc) {
@@ -184,16 +183,17 @@ static unsigned long iommu_range_alloc(s
 	return n;
 }
 
-static dma_addr_t iommu_alloc(struct iommu_table *tbl, void *page,
-		       unsigned int npages, enum dma_data_direction direction,
-		       unsigned long mask, unsigned int align_order)
+static dma_addr_t iommu_alloc(struct device *dev, struct iommu_table *tbl,
+			      void *page, unsigned int npages,
+			      enum dma_data_direction direction,
+			      unsigned long mask, unsigned int align_order)
 {
 	unsigned long entry, flags;
 	dma_addr_t ret = DMA_ERROR_CODE;
 
 	spin_lock_irqsave(&(tbl->it_lock), flags);
 
-	entry = iommu_range_alloc(tbl, npages, NULL, mask, align_order);
+	entry = iommu_range_alloc(dev, tbl, npages, NULL, mask, align_order);
 
 	if (unlikely(entry == DMA_ERROR_CODE)) {
 		spin_unlock_irqrestore(&(tbl->it_lock), flags);
@@ -224,7 +224,6 @@ static void __iommu_free(struct iommu_ta
 			 unsigned int npages)
 {
 	unsigned long entry, free_entry;
-	unsigned long i;
 
 	entry = dma_addr >> IOMMU_PAGE_SHIFT;
 	free_entry = entry - tbl->it_offset;
@@ -246,9 +245,7 @@ static void __iommu_free(struct iommu_ta
 	}
 
 	ppc_md.tce_free(tbl, entry, npages);
-	
-	for (i = 0; i < npages; i++)
-		__clear_bit(free_entry+i, tbl->it_map);
+	iommu_area_free(tbl->it_map, free_entry, npages);
 }
 
 static void iommu_free(struct iommu_table *tbl, dma_addr_t dma_addr,
@@ -312,7 +309,8 @@ int iommu_map_sg(struct device *dev, str
 		/* Allocate iommu entries for that segment */
 		vaddr = (unsigned long) sg_virt(s);
 		npages = iommu_num_pages(vaddr, slen);
-		entry = iommu_range_alloc(tbl, npages, &handle, mask >> IOMMU_PAGE_SHIFT, 0);
+		entry = iommu_range_alloc(dev, tbl, npages, &handle,
+					  mask >> IOMMU_PAGE_SHIFT, 0);
 
 		DBG("  - vaddr: %lx, size: %lx\n", vaddr, slen);
 
@@ -570,9 +568,9 @@ void iommu_free_table(struct device_node
  * need not be page aligned, the dma_addr_t returned will point to the same
  * byte within the page as vaddr.
  */
-dma_addr_t iommu_map_single(struct iommu_table *tbl, void *vaddr,
-		size_t size, unsigned long mask,
-		enum dma_data_direction direction)
+dma_addr_t iommu_map_single(struct device *dev, struct iommu_table *tbl,
+			    void *vaddr, size_t size, unsigned long mask,
+			    enum dma_data_direction direction)
 {
 	dma_addr_t dma_handle = DMA_ERROR_CODE;
 	unsigned long uaddr;
@@ -584,7 +582,7 @@ dma_addr_t iommu_map_single(struct iommu
 	npages = iommu_num_pages(uaddr, size);
 
 	if (tbl) {
-		dma_handle = iommu_alloc(tbl, vaddr, npages, direction,
+		dma_handle = iommu_alloc(dev, tbl, vaddr, npages, direction,
 					 mask >> IOMMU_PAGE_SHIFT, 0);
 		if (dma_handle == DMA_ERROR_CODE) {
 			if (printk_ratelimit())  {
@@ -616,8 +614,9 @@ void iommu_unmap_single(struct iommu_tab
  * Returns the virtual address of the buffer and sets dma_handle
  * to the dma address (mapping) of the first page.
  */
-void *iommu_alloc_coherent(struct iommu_table *tbl, size_t size,
-		dma_addr_t *dma_handle, unsigned long mask, gfp_t flag, int node)
+void *iommu_alloc_coherent(struct device *dev, struct iommu_table *tbl,
+			   size_t size,	dma_addr_t *dma_handle,
+			   unsigned long mask, gfp_t flag, int node)
 {
 	void *ret = NULL;
 	dma_addr_t mapping;
@@ -651,7 +650,7 @@ void *iommu_alloc_coherent(struct iommu_
 	/* Set up tces to cover the allocated range */
 	nio_pages = size >> IOMMU_PAGE_SHIFT;
 	io_order = get_iommu_order(size);
-	mapping = iommu_alloc(tbl, ret, nio_pages, DMA_BIDIRECTIONAL,
+	mapping = iommu_alloc(dev, tbl, ret, nio_pages, DMA_BIDIRECTIONAL,
 			      mask >> IOMMU_PAGE_SHIFT, io_order);
 	if (mapping == DMA_ERROR_CODE) {
 		free_pages((unsigned long)ret, order);
diff -puN arch/powerpc/platforms/iseries/iommu.c~iommu-sg-powerpc-convert-iommu-to-use-the-iommu-helper arch/powerpc/platforms/iseries/iommu.c
--- a/arch/powerpc/platforms/iseries/iommu.c~iommu-sg-powerpc-convert-iommu-to-use-the-iommu-helper
+++ a/arch/powerpc/platforms/iseries/iommu.c
@@ -197,7 +197,7 @@ static struct iommu_table vio_iommu_tabl
 
 void *iseries_hv_alloc(size_t size, dma_addr_t *dma_handle, gfp_t flag)
 {
-	return iommu_alloc_coherent(&vio_iommu_table, size, dma_handle,
+	return iommu_alloc_coherent(NULL, &vio_iommu_table, size, dma_handle,
 				DMA_32BIT_MASK, flag, -1);
 }
 EXPORT_SYMBOL_GPL(iseries_hv_alloc);
@@ -211,7 +211,7 @@ EXPORT_SYMBOL_GPL(iseries_hv_free);
 dma_addr_t iseries_hv_map(void *vaddr, size_t size,
 			enum dma_data_direction direction)
 {
-	return iommu_map_single(&vio_iommu_table, vaddr, size,
+	return iommu_map_single(NULL, &vio_iommu_table, vaddr, size,
 				DMA_32BIT_MASK, direction);
 }
 
diff -puN include/asm-powerpc/iommu.h~iommu-sg-powerpc-convert-iommu-to-use-the-iommu-helper include/asm-powerpc/iommu.h
--- a/include/asm-powerpc/iommu.h~iommu-sg-powerpc-convert-iommu-to-use-the-iommu-helper
+++ a/include/asm-powerpc/iommu.h
@@ -86,13 +86,13 @@ extern int iommu_map_sg(struct device *d
 extern void iommu_unmap_sg(struct iommu_table *tbl, struct scatterlist *sglist,
 			   int nelems, enum dma_data_direction direction);
 
-extern void *iommu_alloc_coherent(struct iommu_table *tbl, size_t size,
-				  dma_addr_t *dma_handle, unsigned long mask,
-				  gfp_t flag, int node);
+extern void *iommu_alloc_coherent(struct device *dev, struct iommu_table *tbl,
+				  size_t size, dma_addr_t *dma_handle,
+				  unsigned long mask, gfp_t flag, int node);
 extern void iommu_free_coherent(struct iommu_table *tbl, size_t size,
 				void *vaddr, dma_addr_t dma_handle);
-extern dma_addr_t iommu_map_single(struct iommu_table *tbl, void *vaddr,
-				   size_t size, unsigned long mask,
+extern dma_addr_t iommu_map_single(struct device *dev, struct iommu_table *tbl,
+				   void *vaddr, size_t size, unsigned long mask,
 				   enum dma_data_direction direction);
 extern void iommu_unmap_single(struct iommu_table *tbl, dma_addr_t dma_handle,
 			       size_t size, enum dma_data_direction direction);
_

Patches currently in -mm which might be from tomof@acm.org are

git-scsi-misc.patch
iommu-sg-merging-add-device_dma_parameters-structure.patch
iommu-sg-merging-pci-add-device_dma_parameters-support.patch
iommu-sg-merging-x86-make-pci-gart-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-ppc-make-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-ia64-make-sba_iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-alpha-make-pci_iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-sparc64-make-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-parisc-make-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-call-blk_queue_segment_boundary-in-__scsi_alloc_queue.patch
iommu-sg-merging-sata_inic162x-use-pci_set_dma_max_seg_size.patch
iommu-sg-merging-aacraid-use-pci_set_dma_max_seg_size.patch
iommu-sg-add-iommu-helper-functions-for-the-free-area-management.patch
iommu-sg-powerpc-convert-iommu-to-use-the-iommu-helper.patch
iommu-sg-powerpc-remove-dma-4gb-boundary-protection.patch
iommu-sg-x86-convert-calgary-iommu-to-use-the-iommu-helper.patch
iommu-sg-x86-convert-gart-iommu-to-use-the-iommu-helper.patch
iommu-sg-kill-__clear_bit_string-and-find_next_zero_string.patch
add-accessors-for-segment_boundary_mask-in.patch
pci-add-dma-segment-boundary-support.patch
swiotlb-respect-the-segment-boundary-limits.patch
call-dma_set_seg_boundary-in-__scsi_alloc_queue.patch
alpha-kill-deprecated-virt_to_bus.patch
