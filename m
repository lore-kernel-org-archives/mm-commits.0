From: akpm@linux-foundation.org
Subject: [merged] metag-convert-to-dma_map_ops.patch removed from -mm tree
Date: Thu, 21 Jan 2016 15:29:06 -0800
Message-ID: <56a169c2.1PIG/0OR2ikXGXRb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36271 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbcAUX3H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 18:29:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, borntraeger@de.ibm.com, james.hogan@imgtec.com, jroedel@suse.de, sebott@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: metag: convert to dma_map_ops
has been removed from the -mm tree.  Its filename was
     metag-convert-to-dma_map_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: metag: convert to dma_map_ops

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/metag/Kconfig                   |    1 
 arch/metag/include/asm/dma-mapping.h |  179 -------------------------
 arch/metag/kernel/dma.c              |  146 +++++++++++++++-----
 3 files changed, 117 insertions(+), 209 deletions(-)

diff -puN arch/metag/Kconfig~metag-convert-to-dma_map_ops arch/metag/Kconfig
--- a/arch/metag/Kconfig~metag-convert-to-dma_map_ops
+++ a/arch/metag/Kconfig
@@ -29,6 +29,7 @@ config METAG
 	select OF
 	select OF_EARLY_FLATTREE
 	select SPARSE_IRQ
+	select HAVE_DMA_ATTRS
 
 config STACKTRACE_SUPPORT
 	def_bool y
diff -puN arch/metag/include/asm/dma-mapping.h~metag-convert-to-dma_map_ops arch/metag/include/asm/dma-mapping.h
--- a/arch/metag/include/asm/dma-mapping.h~metag-convert-to-dma_map_ops
+++ a/arch/metag/include/asm/dma-mapping.h
@@ -1,178 +1,14 @@
 #ifndef _ASM_METAG_DMA_MAPPING_H
 #define _ASM_METAG_DMA_MAPPING_H
 
-#include <linux/mm.h>
+extern struct dma_map_ops metag_dma_ops;
 
-#include <asm/cache.h>
-#include <asm/io.h>
-#include <linux/scatterlist.h>
-#include <asm/bug.h>
-
-#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
-#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-
-void *dma_alloc_coherent(struct device *dev, size_t size,
-			 dma_addr_t *dma_handle, gfp_t flag);
-
-void dma_free_coherent(struct device *dev, size_t size,
-		       void *vaddr, dma_addr_t dma_handle);
-
-void dma_sync_for_device(void *vaddr, size_t size, int dma_direction);
-void dma_sync_for_cpu(void *vaddr, size_t size, int dma_direction);
-
-int dma_mmap_coherent(struct device *dev, struct vm_area_struct *vma,
-		      void *cpu_addr, dma_addr_t dma_addr, size_t size);
-
-int dma_mmap_writecombine(struct device *dev, struct vm_area_struct *vma,
-			  void *cpu_addr, dma_addr_t dma_addr, size_t size);
-
-static inline dma_addr_t
-dma_map_single(struct device *dev, void *ptr, size_t size,
-	       enum dma_data_direction direction)
-{
-	BUG_ON(!valid_dma_direction(direction));
-	WARN_ON(size == 0);
-	dma_sync_for_device(ptr, size, direction);
-	return virt_to_phys(ptr);
-}
-
-static inline void
-dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
-		 enum dma_data_direction direction)
-{
-	BUG_ON(!valid_dma_direction(direction));
-	dma_sync_for_cpu(phys_to_virt(dma_addr), size, direction);
-}
-
-static inline int
-dma_map_sg(struct device *dev, struct scatterlist *sglist, int nents,
-	   enum dma_data_direction direction)
-{
-	struct scatterlist *sg;
-	int i;
-
-	BUG_ON(!valid_dma_direction(direction));
-	WARN_ON(nents == 0 || sglist[0].length == 0);
-
-	for_each_sg(sglist, sg, nents, i) {
-		BUG_ON(!sg_page(sg));
-
-		sg->dma_address = sg_phys(sg);
-		dma_sync_for_device(sg_virt(sg), sg->length, direction);
-	}
-
-	return nents;
-}
-
-static inline dma_addr_t
-dma_map_page(struct device *dev, struct page *page, unsigned long offset,
-	     size_t size, enum dma_data_direction direction)
-{
-	BUG_ON(!valid_dma_direction(direction));
-	dma_sync_for_device((void *)(page_to_phys(page) + offset), size,
-			    direction);
-	return page_to_phys(page) + offset;
-}
-
-static inline void
-dma_unmap_page(struct device *dev, dma_addr_t dma_address, size_t size,
-	       enum dma_data_direction direction)
+static inline struct dma_map_ops *get_dma_ops(struct device *dev)
 {
-	BUG_ON(!valid_dma_direction(direction));
-	dma_sync_for_cpu(phys_to_virt(dma_address), size, direction);
+	return &metag_dma_ops;
 }
 
-
-static inline void
-dma_unmap_sg(struct device *dev, struct scatterlist *sglist, int nhwentries,
-	     enum dma_data_direction direction)
-{
-	struct scatterlist *sg;
-	int i;
-
-	BUG_ON(!valid_dma_direction(direction));
-	WARN_ON(nhwentries == 0 || sglist[0].length == 0);
-
-	for_each_sg(sglist, sg, nhwentries, i) {
-		BUG_ON(!sg_page(sg));
-
-		sg->dma_address = sg_phys(sg);
-		dma_sync_for_cpu(sg_virt(sg), sg->length, direction);
-	}
-}
-
-static inline void
-dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle, size_t size,
-			enum dma_data_direction direction)
-{
-	dma_sync_for_cpu(phys_to_virt(dma_handle), size, direction);
-}
-
-static inline void
-dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle,
-			   size_t size, enum dma_data_direction direction)
-{
-	dma_sync_for_device(phys_to_virt(dma_handle), size, direction);
-}
-
-static inline void
-dma_sync_single_range_for_cpu(struct device *dev, dma_addr_t dma_handle,
-			      unsigned long offset, size_t size,
-			      enum dma_data_direction direction)
-{
-	dma_sync_for_cpu(phys_to_virt(dma_handle)+offset, size,
-			 direction);
-}
-
-static inline void
-dma_sync_single_range_for_device(struct device *dev, dma_addr_t dma_handle,
-				 unsigned long offset, size_t size,
-				 enum dma_data_direction direction)
-{
-	dma_sync_for_device(phys_to_virt(dma_handle)+offset, size,
-			    direction);
-}
-
-static inline void
-dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sglist, int nelems,
-		    enum dma_data_direction direction)
-{
-	int i;
-	struct scatterlist *sg;
-
-	for_each_sg(sglist, sg, nelems, i)
-		dma_sync_for_cpu(sg_virt(sg), sg->length, direction);
-}
-
-static inline void
-dma_sync_sg_for_device(struct device *dev, struct scatterlist *sglist,
-		       int nelems, enum dma_data_direction direction)
-{
-	int i;
-	struct scatterlist *sg;
-
-	for_each_sg(sglist, sg, nelems, i)
-		dma_sync_for_device(sg_virt(sg), sg->length, direction);
-}
-
-static inline int
-dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
-{
-	return 0;
-}
-
-#define dma_supported(dev, mask)        (1)
-
-static inline int
-dma_set_mask(struct device *dev, u64 mask)
-{
-	if (!dev->dma_mask || !dma_supported(dev, mask))
-		return -EIO;
-
-	*dev->dma_mask = mask;
-
-	return 0;
-}
+#include <asm-generic/dma-mapping-common.h>
 
 /*
  * dma_alloc_noncoherent() returns non-cacheable memory, so there's no need to
@@ -184,11 +20,4 @@ dma_cache_sync(struct device *dev, void
 {
 }
 
-/* drivers/base/dma-mapping.c */
-extern int dma_common_get_sgtable(struct device *dev, struct sg_table *sgt,
-				  void *cpu_addr, dma_addr_t dma_addr,
-				  size_t size);
-
-#define dma_get_sgtable(d, t, v, h, s) dma_common_get_sgtable(d, t, v, h, s)
-
 #endif
diff -puN arch/metag/kernel/dma.c~metag-convert-to-dma_map_ops arch/metag/kernel/dma.c
--- a/arch/metag/kernel/dma.c~metag-convert-to-dma_map_ops
+++ a/arch/metag/kernel/dma.c
@@ -171,8 +171,8 @@ out:
  * Allocate DMA-coherent memory space and return both the kernel remapped
  * virtual and bus address for that space.
  */
-void *dma_alloc_coherent(struct device *dev, size_t size,
-			 dma_addr_t *handle, gfp_t gfp)
+static void *metag_dma_alloc(struct device *dev, size_t size,
+		dma_addr_t *handle, gfp_t gfp, struct dma_attrs *attrs)
 {
 	struct page *page;
 	struct metag_vm_region *c;
@@ -263,13 +263,12 @@ void *dma_alloc_coherent(struct device *
 no_page:
 	return NULL;
 }
-EXPORT_SYMBOL(dma_alloc_coherent);
 
 /*
  * free a page as defined by the above mapping.
  */
-void dma_free_coherent(struct device *dev, size_t size,
-		       void *vaddr, dma_addr_t dma_handle)
+static void metag_dma_free(struct device *dev, size_t size, void *vaddr,
+		dma_addr_t dma_handle, struct dma_attrs *attrs)
 {
 	struct metag_vm_region *c;
 	unsigned long flags, addr;
@@ -329,16 +328,19 @@ no_area:
 	       __func__, vaddr);
 	dump_stack();
 }
-EXPORT_SYMBOL(dma_free_coherent);
 
-
-static int dma_mmap(struct device *dev, struct vm_area_struct *vma,
-		    void *cpu_addr, dma_addr_t dma_addr, size_t size)
+static int metag_dma_mmap(struct device *dev, struct vm_area_struct *vma,
+		void *cpu_addr, dma_addr_t dma_addr, size_t size,
+		struct dma_attrs *attrs)
 {
-	int ret = -ENXIO;
-
 	unsigned long flags, user_size, kern_size;
 	struct metag_vm_region *c;
+	int ret = -ENXIO;
+
+	if (dma_get_attr(DMA_ATTR_WRITE_COMBINE, attrs))
+		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
+	else
+		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 
 	user_size = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 
@@ -364,25 +366,6 @@ static int dma_mmap(struct device *dev,
 	return ret;
 }
 
-int dma_mmap_coherent(struct device *dev, struct vm_area_struct *vma,
-		      void *cpu_addr, dma_addr_t dma_addr, size_t size)
-{
-	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-	return dma_mmap(dev, vma, cpu_addr, dma_addr, size);
-}
-EXPORT_SYMBOL(dma_mmap_coherent);
-
-int dma_mmap_writecombine(struct device *dev, struct vm_area_struct *vma,
-			  void *cpu_addr, dma_addr_t dma_addr, size_t size)
-{
-	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
-	return dma_mmap(dev, vma, cpu_addr, dma_addr, size);
-}
-EXPORT_SYMBOL(dma_mmap_writecombine);
-
-
-
-
 /*
  * Initialise the consistent memory allocation.
  */
@@ -423,7 +406,7 @@ early_initcall(dma_alloc_init);
 /*
  * make an area consistent to devices.
  */
-void dma_sync_for_device(void *vaddr, size_t size, int dma_direction)
+static void dma_sync_for_device(void *vaddr, size_t size, int dma_direction)
 {
 	/*
 	 * Ensure any writes get through the write combiner. This is necessary
@@ -465,12 +448,11 @@ void dma_sync_for_device(void *vaddr, si
 
 	wmb();
 }
-EXPORT_SYMBOL(dma_sync_for_device);
 
 /*
  * make an area consistent to the core.
  */
-void dma_sync_for_cpu(void *vaddr, size_t size, int dma_direction)
+static void dma_sync_for_cpu(void *vaddr, size_t size, int dma_direction)
 {
 	/*
 	 * Hardware L2 cache prefetch doesn't occur across 4K physical
@@ -497,4 +479,100 @@ void dma_sync_for_cpu(void *vaddr, size_
 
 	rmb();
 }
-EXPORT_SYMBOL(dma_sync_for_cpu);
+
+static dma_addr_t metag_dma_map_page(struct device *dev, struct page *page,
+		unsigned long offset, size_t size,
+		enum dma_data_direction direction, struct dma_attrs *attrs)
+{
+	dma_sync_for_device((void *)(page_to_phys(page) + offset), size,
+			    direction);
+	return page_to_phys(page) + offset;
+}
+
+static void metag_dma_unmap_page(struct device *dev, dma_addr_t dma_address,
+		size_t size, enum dma_data_direction direction,
+		struct dma_attrs *attrs)
+{
+	dma_sync_for_cpu(phys_to_virt(dma_address), size, direction);
+}
+
+static int metag_dma_map_sg(struct device *dev, struct scatterlist *sglist,
+		int nents, enum dma_data_direction direction,
+		struct dma_attrs *attrs)
+{
+	struct scatterlist *sg;
+	int i;
+
+	for_each_sg(sglist, sg, nents, i) {
+		BUG_ON(!sg_page(sg));
+
+		sg->dma_address = sg_phys(sg);
+		dma_sync_for_device(sg_virt(sg), sg->length, direction);
+	}
+
+	return nents;
+}
+
+
+static void metag_dma_unmap_sg(struct device *dev, struct scatterlist *sglist,
+		int nhwentries, enum dma_data_direction direction,
+		struct dma_attrs *attrs)
+{
+	struct scatterlist *sg;
+	int i;
+
+	for_each_sg(sglist, sg, nhwentries, i) {
+		BUG_ON(!sg_page(sg));
+
+		sg->dma_address = sg_phys(sg);
+		dma_sync_for_cpu(sg_virt(sg), sg->length, direction);
+	}
+}
+
+static void metag_dma_sync_single_for_cpu(struct device *dev,
+		dma_addr_t dma_handle, size_t size,
+		enum dma_data_direction direction)
+{
+	dma_sync_for_cpu(phys_to_virt(dma_handle), size, direction);
+}
+
+static void metag_dma_sync_single_for_device(struct device *dev,
+		dma_addr_t dma_handle, size_t size,
+		enum dma_data_direction direction)
+{
+	dma_sync_for_device(phys_to_virt(dma_handle), size, direction);
+}
+
+static void metag_dma_sync_sg_for_cpu(struct device *dev,
+		struct scatterlist *sglist, int nelems,
+		enum dma_data_direction direction)
+{
+	int i;
+	struct scatterlist *sg;
+
+	for_each_sg(sglist, sg, nelems, i)
+		dma_sync_for_cpu(sg_virt(sg), sg->length, direction);
+}
+
+static void metag_dma_sync_sg_for_device(struct device *dev,
+		struct scatterlist *sglist, int nelems,
+		enum dma_data_direction direction)
+{
+	int i;
+	struct scatterlist *sg;
+
+	for_each_sg(sglist, sg, nelems, i)
+		dma_sync_for_device(sg_virt(sg), sg->length, direction);
+}
+
+struct dma_map_ops metag_dma_ops = {
+	.alloc			= metag_dma_alloc,
+	.free			= metag_dma_free,
+	.map_page		= metag_dma_map_page,
+	.map_sg			= metag_dma_map_sg,
+	.sync_single_for_device	= metag_dma_sync_single_for_device,
+	.sync_single_for_cpu	= metag_dma_sync_single_for_cpu,
+	.sync_sg_for_cpu	= metag_dma_sync_sg_for_cpu,
+	.mmap			= metag_dma_mmap,
+};
+EXPORT_SYMBOL(metag_dma_ops);
_

Patches currently in -mm which might be from hch@lst.de are


