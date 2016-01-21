From: akpm@linux-foundation.org
Subject: [merged] c6x-convert-to-dma_map_ops.patch removed from -mm tree
Date: Thu, 21 Jan 2016 15:28:52 -0800
Message-ID: <56a169b4.598Gh9Yb+V0vfjrD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36224 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbcAUX2x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 18:28:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, a-jacquiot@ti.com, borntraeger@de.ibm.com, jroedel@suse.de, msalter@redhat.com, sebott@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: c6x: convert to dma_map_ops
has been removed from the -mm tree.  Its filename was
     c6x-convert-to-dma_map_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: c6x: convert to dma_map_ops

[dan.carpenter@oracle.com: C6X: fix build breakage]
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Mark Salter <msalter@redhat.com>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/c6x/Kconfig                   |    2 
 arch/c6x/include/asm/dma-mapping.h |   98 ++-------------------------
 arch/c6x/kernel/dma.c              |   95 +++++++++++---------------
 arch/c6x/mm/dma-coherent.c         |   10 +-
 4 files changed, 58 insertions(+), 147 deletions(-)

diff -puN arch/c6x/Kconfig~c6x-convert-to-dma_map_ops arch/c6x/Kconfig
--- a/arch/c6x/Kconfig~c6x-convert-to-dma_map_ops
+++ a/arch/c6x/Kconfig
@@ -17,6 +17,8 @@ config C6X
 	select OF_EARLY_FLATTREE
 	select GENERIC_CLOCKEVENTS
 	select MODULES_USE_ELF_RELA
+	select ARCH_NO_COHERENT_DMA_MMAP
+	select HAVE_DMA_ATTRS
 
 config MMU
 	def_bool n
diff -puN arch/c6x/include/asm/dma-mapping.h~c6x-convert-to-dma_map_ops arch/c6x/include/asm/dma-mapping.h
--- a/arch/c6x/include/asm/dma-mapping.h~c6x-convert-to-dma_map_ops
+++ a/arch/c6x/include/asm/dma-mapping.h
@@ -12,104 +12,24 @@
 #ifndef _ASM_C6X_DMA_MAPPING_H
 #define _ASM_C6X_DMA_MAPPING_H
 
-#include <linux/dma-debug.h>
-#include <asm-generic/dma-coherent.h>
-
-#define dma_supported(d, m)	1
-
-static inline void dma_sync_single_range_for_device(struct device *dev,
-						    dma_addr_t addr,
-						    unsigned long offset,
-						    size_t size,
-						    enum dma_data_direction dir)
-{
-}
-
-static inline int dma_set_mask(struct device *dev, u64 dma_mask)
-{
-	if (!dev->dma_mask || !dma_supported(dev, dma_mask))
-		return -EIO;
-
-	*dev->dma_mask = dma_mask;
-
-	return 0;
-}
-
 /*
  * DMA errors are defined by all-bits-set in the DMA address.
  */
-static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
-{
-	debug_dma_mapping_error(dev, dma_addr);
-	return dma_addr == ~0;
-}
-
-extern dma_addr_t dma_map_single(struct device *dev, void *cpu_addr,
-				 size_t size, enum dma_data_direction dir);
-
-extern void dma_unmap_single(struct device *dev, dma_addr_t handle,
-			     size_t size, enum dma_data_direction dir);
-
-extern int dma_map_sg(struct device *dev, struct scatterlist *sglist,
-		      int nents, enum dma_data_direction direction);
-
-extern void dma_unmap_sg(struct device *dev, struct scatterlist *sglist,
-			 int nents, enum dma_data_direction direction);
+#define DMA_ERROR_CODE ~0
 
-static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
-				      unsigned long offset, size_t size,
-				      enum dma_data_direction dir)
-{
-	dma_addr_t handle;
-
-	handle = dma_map_single(dev, page_address(page) + offset, size, dir);
-
-	debug_dma_map_page(dev, page, offset, size, dir, handle, false);
-
-	return handle;
-}
+extern struct dma_map_ops c6x_dma_ops;
 
-static inline void dma_unmap_page(struct device *dev, dma_addr_t handle,
-		size_t size, enum dma_data_direction dir)
+static inline struct dma_map_ops *get_dma_ops(struct device *dev)
 {
-	dma_unmap_single(dev, handle, size, dir);
-
-	debug_dma_unmap_page(dev, handle, size, dir, false);
+	return &c6x_dma_ops;
 }
 
-extern void dma_sync_single_for_cpu(struct device *dev, dma_addr_t handle,
-				    size_t size, enum dma_data_direction dir);
-
-extern void dma_sync_single_for_device(struct device *dev, dma_addr_t handle,
-				       size_t size,
-				       enum dma_data_direction dir);
-
-extern void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
-				int nents, enum dma_data_direction dir);
-
-extern void dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
-				   int nents, enum dma_data_direction dir);
+#include <asm-generic/dma-mapping-common.h>
 
 extern void coherent_mem_init(u32 start, u32 size);
-extern void *dma_alloc_coherent(struct device *, size_t, dma_addr_t *, gfp_t);
-extern void dma_free_coherent(struct device *, size_t, void *, dma_addr_t);
-
-#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent((d), (s), (h), (f))
-#define dma_free_noncoherent(d, s, v, h)  dma_free_coherent((d), (s), (v), (h))
-
-/* Not supported for now */
-static inline int dma_mmap_coherent(struct device *dev,
-				    struct vm_area_struct *vma, void *cpu_addr,
-				    dma_addr_t dma_addr, size_t size)
-{
-	return -EINVAL;
-}
-
-static inline int dma_get_sgtable(struct device *dev, struct sg_table *sgt,
-				  void *cpu_addr, dma_addr_t dma_addr,
-				  size_t size)
-{
-	return -EINVAL;
-}
+void *c6x_dma_alloc(struct device *dev, size_t size, dma_addr_t *handle,
+		gfp_t gfp, struct dma_attrs *attrs);
+void c6x_dma_free(struct device *dev, size_t size, void *vaddr,
+		dma_addr_t dma_handle, struct dma_attrs *attrs);
 
 #endif	/* _ASM_C6X_DMA_MAPPING_H */
diff -puN arch/c6x/kernel/dma.c~c6x-convert-to-dma_map_ops arch/c6x/kernel/dma.c
--- a/arch/c6x/kernel/dma.c~c6x-convert-to-dma_map_ops
+++ a/arch/c6x/kernel/dma.c
@@ -36,110 +36,101 @@ static void c6x_dma_sync(dma_addr_t hand
 	}
 }
 
-dma_addr_t dma_map_single(struct device *dev, void *ptr, size_t size,
-			  enum dma_data_direction dir)
+static dma_addr_t c6x_dma_map_page(struct device *dev, struct page *page,
+		unsigned long offset, size_t size, enum dma_data_direction dir,
+		struct dma_attrs *attrs)
 {
-	dma_addr_t addr = virt_to_phys(ptr);
+	dma_addr_t handle = virt_to_phys(page_address(page) + offset);
 
-	c6x_dma_sync(addr, size, dir);
-
-	debug_dma_map_page(dev, virt_to_page(ptr),
-			   (unsigned long)ptr & ~PAGE_MASK, size,
-			   dir, addr, true);
-	return addr;
+	c6x_dma_sync(handle, size, dir);
+	return handle;
 }
-EXPORT_SYMBOL(dma_map_single);
-
 
-void dma_unmap_single(struct device *dev, dma_addr_t handle,
-		      size_t size, enum dma_data_direction dir)
+static void c6x_dma_unmap_page(struct device *dev, dma_addr_t handle,
+		size_t size, enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	c6x_dma_sync(handle, size, dir);
-
-	debug_dma_unmap_page(dev, handle, size, dir, true);
 }
-EXPORT_SYMBOL(dma_unmap_single);
-
 
-int dma_map_sg(struct device *dev, struct scatterlist *sglist,
-	       int nents, enum dma_data_direction dir)
+static int c6x_dma_map_sg(struct device *dev, struct scatterlist *sglist,
+		int nents, enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	struct scatterlist *sg;
 	int i;
 
-	for_each_sg(sglist, sg, nents, i)
-		sg->dma_address = dma_map_single(dev, sg_virt(sg), sg->length,
-						 dir);
-
-	debug_dma_map_sg(dev, sglist, nents, nents, dir);
+	for_each_sg(sglist, sg, nents, i) {
+		sg->dma_address = sg_phys(sg);
+		c6x_dma_sync(sg->dma_address, sg->length, dir);
+	}
 
 	return nents;
 }
-EXPORT_SYMBOL(dma_map_sg);
-
 
-void dma_unmap_sg(struct device *dev, struct scatterlist *sglist,
-		  int nents, enum dma_data_direction dir)
+static void c6x_dma_unmap_sg(struct device *dev, struct scatterlist *sglist,
+		  int nents, enum dma_data_direction dir,
+		  struct dma_attrs *attrs)
 {
 	struct scatterlist *sg;
 	int i;
 
 	for_each_sg(sglist, sg, nents, i)
-		dma_unmap_single(dev, sg_dma_address(sg), sg->length, dir);
+		c6x_dma_sync(sg_dma_address(sg), sg->length, dir);
 
-	debug_dma_unmap_sg(dev, sglist,	nents, dir);
 }
-EXPORT_SYMBOL(dma_unmap_sg);
 
-void dma_sync_single_for_cpu(struct device *dev, dma_addr_t handle,
-			     size_t size, enum dma_data_direction dir)
+static void c6x_dma_sync_single_for_cpu(struct device *dev, dma_addr_t handle,
+		size_t size, enum dma_data_direction dir)
 {
 	c6x_dma_sync(handle, size, dir);
 
-	debug_dma_sync_single_for_cpu(dev, handle, size, dir);
 }
-EXPORT_SYMBOL(dma_sync_single_for_cpu);
 
-
-void dma_sync_single_for_device(struct device *dev, dma_addr_t handle,
-				size_t size, enum dma_data_direction dir)
+static void c6x_dma_sync_single_for_device(struct device *dev,
+		dma_addr_t handle, size_t size, enum dma_data_direction dir)
 {
 	c6x_dma_sync(handle, size, dir);
 
-	debug_dma_sync_single_for_device(dev, handle, size, dir);
 }
-EXPORT_SYMBOL(dma_sync_single_for_device);
-
 
-void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sglist,
-			 int nents, enum dma_data_direction dir)
+static void c6x_dma_sync_sg_for_cpu(struct device *dev,
+		struct scatterlist *sglist, int nents,
+		enum dma_data_direction dir)
 {
 	struct scatterlist *sg;
 	int i;
 
 	for_each_sg(sglist, sg, nents, i)
-		dma_sync_single_for_cpu(dev, sg_dma_address(sg),
+		c6x_dma_sync_single_for_cpu(dev, sg_dma_address(sg),
 					sg->length, dir);
 
-	debug_dma_sync_sg_for_cpu(dev, sglist, nents, dir);
 }
-EXPORT_SYMBOL(dma_sync_sg_for_cpu);
-
 
-void dma_sync_sg_for_device(struct device *dev, struct scatterlist *sglist,
-			    int nents, enum dma_data_direction dir)
+static void c6x_dma_sync_sg_for_device(struct device *dev,
+		struct scatterlist *sglist, int nents,
+		enum dma_data_direction dir)
 {
 	struct scatterlist *sg;
 	int i;
 
 	for_each_sg(sglist, sg, nents, i)
-		dma_sync_single_for_device(dev, sg_dma_address(sg),
+		c6x_dma_sync_single_for_device(dev, sg_dma_address(sg),
 					   sg->length, dir);
 
-	debug_dma_sync_sg_for_device(dev, sglist, nents, dir);
 }
-EXPORT_SYMBOL(dma_sync_sg_for_device);
 
+struct dma_map_ops c6x_dma_ops = {
+	.alloc			= c6x_dma_alloc,
+	.free			= c6x_dma_free,
+	.map_page		= c6x_dma_map_page,
+	.unmap_page		= c6x_dma_unmap_page,
+	.map_sg			= c6x_dma_map_sg,
+	.unmap_sg		= c6x_dma_unmap_sg,
+	.sync_single_for_device	= c6x_dma_sync_single_for_device,
+	.sync_single_for_cpu	= c6x_dma_sync_single_for_cpu,
+	.sync_sg_for_device	= c6x_dma_sync_sg_for_device,
+	.sync_sg_for_cpu	= c6x_dma_sync_sg_for_cpu,
+};
+EXPORT_SYMBOL(c6x_dma_ops);
 
 /* Number of entries preallocated for DMA-API debugging */
 #define PREALLOC_DMA_DEBUG_ENTRIES (1 << 16)
diff -puN arch/c6x/mm/dma-coherent.c~c6x-convert-to-dma_map_ops arch/c6x/mm/dma-coherent.c
--- a/arch/c6x/mm/dma-coherent.c~c6x-convert-to-dma_map_ops
+++ a/arch/c6x/mm/dma-coherent.c
@@ -73,8 +73,8 @@ static void __free_dma_pages(u32 addr, i
  * Allocate DMA coherent memory space and return both the kernel
  * virtual and DMA address for that space.
  */
-void *dma_alloc_coherent(struct device *dev, size_t size,
-			 dma_addr_t *handle, gfp_t gfp)
+void *c6x_dma_alloc(struct device *dev, size_t size, dma_addr_t *handle,
+		gfp_t gfp, struct dma_attrs *attrs)
 {
 	u32 paddr;
 	int order;
@@ -94,13 +94,12 @@ void *dma_alloc_coherent(struct device *
 
 	return phys_to_virt(paddr);
 }
-EXPORT_SYMBOL(dma_alloc_coherent);
 
 /*
  * Free DMA coherent memory as defined by the above mapping.
  */
-void dma_free_coherent(struct device *dev, size_t size, void *vaddr,
-		       dma_addr_t dma_handle)
+void c6x_dma_free(struct device *dev, size_t size, void *vaddr,
+		dma_addr_t dma_handle, struct dma_attrs *attrs)
 {
 	int order;
 
@@ -111,7 +110,6 @@ void dma_free_coherent(struct device *de
 
 	__free_dma_pages(virt_to_phys(vaddr), order);
 }
-EXPORT_SYMBOL(dma_free_coherent);
 
 /*
  * Initialise the coherent DMA memory allocator using the given uncached region.
_

Patches currently in -mm which might be from hch@lst.de are


