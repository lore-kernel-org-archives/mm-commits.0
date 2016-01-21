From: akpm@linux-foundation.org
Subject: [merged] mn10300-convert-to-dma_map_ops.patch removed from -mm
 tree
Date: Thu, 21 Jan 2016 15:29:02 -0800
Message-ID: <56a169be.kxHkjMw1m7GBhFZU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36254 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbcAUX3D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 18:29:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, borntraeger@de.ibm.com, dhowells@redhat.com, jroedel@suse.de, sebott@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mn10300: convert to dma_map_ops
has been removed from the -mm tree.  Its filename was
     mn10300-convert-to-dma_map_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mn10300: convert to dma_map_ops

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: David Howells <dhowells@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/Kconfig                   |    2 
 arch/mn10300/include/asm/dma-mapping.h |  161 -----------------------
 arch/mn10300/mm/dma-alloc.c            |   67 ++++++++-
 3 files changed, 67 insertions(+), 163 deletions(-)

diff -puN arch/mn10300/Kconfig~mn10300-convert-to-dma_map_ops arch/mn10300/Kconfig
--- a/arch/mn10300/Kconfig~mn10300-convert-to-dma_map_ops
+++ a/arch/mn10300/Kconfig
@@ -14,6 +14,8 @@ config MN10300
 	select OLD_SIGSUSPEND3
 	select OLD_SIGACTION
 	select HAVE_DEBUG_STACKOVERFLOW
+	select ARCH_NO_COHERENT_DMA_MMAP
+	select HAVE_DMA_ATTRS
 
 config AM33_2
 	def_bool n
diff -puN arch/mn10300/include/asm/dma-mapping.h~mn10300-convert-to-dma_map_ops arch/mn10300/include/asm/dma-mapping.h
--- a/arch/mn10300/include/asm/dma-mapping.h~mn10300-convert-to-dma_map_ops
+++ a/arch/mn10300/include/asm/dma-mapping.h
@@ -11,154 +11,14 @@
 #ifndef _ASM_DMA_MAPPING_H
 #define _ASM_DMA_MAPPING_H
 
-#include <linux/mm.h>
-#include <linux/scatterlist.h>
-
 #include <asm/cache.h>
 #include <asm/io.h>
 
-/*
- * See Documentation/DMA-API.txt for the description of how the
- * following DMA API should work.
- */
-
-extern void *dma_alloc_coherent(struct device *dev, size_t size,
-				dma_addr_t *dma_handle, int flag);
-
-extern void dma_free_coherent(struct device *dev, size_t size,
-			      void *vaddr, dma_addr_t dma_handle);
-
-#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent((d), (s), (h), (f))
-#define dma_free_noncoherent(d, s, v, h)  dma_free_coherent((d), (s), (v), (h))
-
-static inline
-dma_addr_t dma_map_single(struct device *dev, void *ptr, size_t size,
-			  enum dma_data_direction direction)
-{
-	BUG_ON(direction == DMA_NONE);
-	mn10300_dcache_flush_inv();
-	return virt_to_bus(ptr);
-}
-
-static inline
-void dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
-		      enum dma_data_direction direction)
-{
-	BUG_ON(direction == DMA_NONE);
-}
+extern struct dma_map_ops mn10300_dma_ops;
 
-static inline
-int dma_map_sg(struct device *dev, struct scatterlist *sglist, int nents,
-	       enum dma_data_direction direction)
+static inline struct dma_map_ops *get_dma_ops(struct device *dev)
 {
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
-	}
-
-	mn10300_dcache_flush_inv();
-	return nents;
-}
-
-static inline
-void dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
-		  enum dma_data_direction direction)
-{
-	BUG_ON(!valid_dma_direction(direction));
-}
-
-static inline
-dma_addr_t dma_map_page(struct device *dev, struct page *page,
-			unsigned long offset, size_t size,
-			enum dma_data_direction direction)
-{
-	BUG_ON(direction == DMA_NONE);
-	return page_to_bus(page) + offset;
-}
-
-static inline
-void dma_unmap_page(struct device *dev, dma_addr_t dma_address, size_t size,
-		    enum dma_data_direction direction)
-{
-	BUG_ON(direction == DMA_NONE);
-}
-
-static inline
-void dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
-			     size_t size, enum dma_data_direction direction)
-{
-}
-
-static inline
-void dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle,
-				size_t size, enum dma_data_direction direction)
-{
-	mn10300_dcache_flush_inv();
-}
-
-static inline
-void dma_sync_single_range_for_cpu(struct device *dev, dma_addr_t dma_handle,
-				   unsigned long offset, size_t size,
-				   enum dma_data_direction direction)
-{
-}
-
-static inline void
-dma_sync_single_range_for_device(struct device *dev, dma_addr_t dma_handle,
-				 unsigned long offset, size_t size,
-				 enum dma_data_direction direction)
-{
-	mn10300_dcache_flush_inv();
-}
-
-
-static inline
-void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
-			 int nelems, enum dma_data_direction direction)
-{
-}
-
-static inline
-void dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
-			    int nelems, enum dma_data_direction direction)
-{
-	mn10300_dcache_flush_inv();
-}
-
-static inline
-int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
-{
-	return 0;
-}
-
-static inline
-int dma_supported(struct device *dev, u64 mask)
-{
-	/*
-	 * we fall back to GFP_DMA when the mask isn't all 1s, so we can't
-	 * guarantee allocations that must be within a tighter range than
-	 * GFP_DMA
-	 */
-	if (mask < 0x00ffffff)
-		return 0;
-	return 1;
-}
-
-static inline
-int dma_set_mask(struct device *dev, u64 mask)
-{
-	if (!dev->dma_mask || !dma_supported(dev, mask))
-		return -EIO;
-
-	*dev->dma_mask = mask;
-	return 0;
+	return &mn10300_dma_ops;
 }
 
 static inline
@@ -168,19 +28,6 @@ void dma_cache_sync(void *vaddr, size_t
 	mn10300_dcache_flush_inv();
 }
 
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
+#include <asm-generic/dma-mapping-common.h>
 
 #endif
diff -puN arch/mn10300/mm/dma-alloc.c~mn10300-convert-to-dma_map_ops arch/mn10300/mm/dma-alloc.c
--- a/arch/mn10300/mm/dma-alloc.c~mn10300-convert-to-dma_map_ops
+++ a/arch/mn10300/mm/dma-alloc.c
@@ -20,8 +20,8 @@
 
 static unsigned long pci_sram_allocated = 0xbc000000;
 
-void *dma_alloc_coherent(struct device *dev, size_t size,
-			 dma_addr_t *dma_handle, int gfp)
+static void *mn10300_dma_alloc(struct device *dev, size_t size,
+		dma_addr_t *dma_handle, gfp_t gfp, struct dma_attrs *attrs)
 {
 	unsigned long addr;
 	void *ret;
@@ -61,10 +61,9 @@ done:
 	printk("dma_alloc_coherent() = %p [%x]\n", ret, *dma_handle);
 	return ret;
 }
-EXPORT_SYMBOL(dma_alloc_coherent);
 
-void dma_free_coherent(struct device *dev, size_t size, void *vaddr,
-		       dma_addr_t dma_handle)
+static void mn10300_dma_free(struct device *dev, size_t size, void *vaddr,
+		dma_addr_t dma_handle, struct dma_attrs *attrs)
 {
 	unsigned long addr = (unsigned long) vaddr & ~0x20000000;
 
@@ -73,4 +72,60 @@ void dma_free_coherent(struct device *de
 
 	free_pages(addr, get_order(size));
 }
-EXPORT_SYMBOL(dma_free_coherent);
+
+static int mn10300_dma_map_sg(struct device *dev, struct scatterlist *sglist,
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
+	}
+
+	mn10300_dcache_flush_inv();
+	return nents;
+}
+
+static dma_addr_t mn10300_dma_map_page(struct device *dev, struct page *page,
+		unsigned long offset, size_t size,
+		enum dma_data_direction direction, struct dma_attrs *attrs)
+{
+	return page_to_bus(page) + offset;
+}
+
+static void mn10300_dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle,
+				size_t size, enum dma_data_direction direction)
+{
+	mn10300_dcache_flush_inv();
+}
+
+static void mn10300_dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
+			    int nelems, enum dma_data_direction direction)
+{
+	mn10300_dcache_flush_inv();
+}
+
+static int mn10300_dma_supported(struct device *dev, u64 mask)
+{
+	/*
+	 * we fall back to GFP_DMA when the mask isn't all 1s, so we can't
+	 * guarantee allocations that must be within a tighter range than
+	 * GFP_DMA
+	 */
+	if (mask < 0x00ffffff)
+		return 0;
+	return 1;
+}
+
+struct dma_map_ops mn10300_dma_ops = {
+	.alloc			= mn10300_dma_alloc,
+	.free			= mn10300_dma_free,
+	.map_page		= mn10300_dma_map_page,
+	.map_sg			= mn10300_dma_map_sg,
+	.sync_single_for_device	= mn10300_dma_sync_single_for_device,
+	.sync_sg_for_device	= mn10300_dma_sync_sg_for_device,
+};
_

Patches currently in -mm which might be from hch@lst.de are


