From: akpm@linux-foundation.org
Subject: [merged] cris-convert-to-dma_map_ops.patch removed from -mm tree
Date: Thu, 21 Jan 2016 15:28:54 -0800
Message-ID: <56a169b6.G8Tb6P5UBK/WLOU6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36230 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbcAUX2y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 18:28:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, borntraeger@de.ibm.com, jesper.nilsson@axis.com, jroedel@suse.de, sebott@linux.vnet.ibm.com, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cris: convert to dma_map_ops
has been removed from the -mm tree.  Its filename was
     cris-convert-to-dma_map_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: cris: convert to dma_map_ops

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/Kconfig                    |    1 
 arch/cris/arch-v32/drivers/pci/dma.c |   54 ++++++--
 arch/cris/include/asm/dma-mapping.h  |  161 +------------------------
 3 files changed, 51 insertions(+), 165 deletions(-)

diff -puN arch/cris/Kconfig~cris-convert-to-dma_map_ops arch/cris/Kconfig
--- a/arch/cris/Kconfig~cris-convert-to-dma_map_ops
+++ a/arch/cris/Kconfig
@@ -54,6 +54,7 @@ config CRIS
 	select GENERIC_ATOMIC64
 	select HAVE_UID16
 	select VIRT_TO_BUS
+	select HAVE_DMA_ATTRS
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IOMAP
diff -puN arch/cris/arch-v32/drivers/pci/dma.c~cris-convert-to-dma_map_ops arch/cris/arch-v32/drivers/pci/dma.c
--- a/arch/cris/arch-v32/drivers/pci/dma.c~cris-convert-to-dma_map_ops
+++ a/arch/cris/arch-v32/drivers/pci/dma.c
@@ -16,21 +16,18 @@
 #include <linux/gfp.h>
 #include <asm/io.h>
 
-void *dma_alloc_coherent(struct device *dev, size_t size,
-			   dma_addr_t *dma_handle, gfp_t gfp)
+static void *v32_dma_alloc(struct device *dev, size_t size,
+		dma_addr_t *dma_handle, gfp_t gfp,  struct dma_attrs *attrs)
 {
 	void *ret;
-	int order = get_order(size);
+
 	/* ignore region specifiers */
 	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM);
 
-	if (dma_alloc_from_coherent(dev, size, dma_handle, &ret))
-		return ret;
-
 	if (dev == NULL || (dev->coherent_dma_mask < 0xffffffff))
 		gfp |= GFP_DMA;
 
-	ret = (void *)__get_free_pages(gfp, order);
+	ret = (void *)__get_free_pages(gfp,  get_order(size));
 
 	if (ret != NULL) {
 		memset(ret, 0, size);
@@ -39,12 +36,45 @@ void *dma_alloc_coherent(struct device *
 	return ret;
 }
 
-void dma_free_coherent(struct device *dev, size_t size,
-			 void *vaddr, dma_addr_t dma_handle)
+static void v32_dma_free(struct device *dev, size_t size, void *vaddr,
+		dma_addr_t dma_handle, struct dma_attrs *attrs)
+{
+	free_pages((unsigned long)vaddr, get_order(size));
+}
+
+static inline dma_addr_t v32_dma_map_page(struct device *dev,
+		struct page *page, unsigned long offset, size_t size,
+		enum dma_data_direction direction,
+		struct dma_attrs *attrs)
 {
-	int order = get_order(size);
+	return page_to_phys(page) + offset;
+}
 
-	if (!dma_release_from_coherent(dev, order, vaddr))
-		free_pages((unsigned long)vaddr, order);
+static inline int v32_dma_map_sg(struct device *dev, struct scatterlist *sg,
+		int nents, enum dma_data_direction direction,
+		struct dma_attrs *attrs)
+{
+	printk("Map sg\n");
+	return nents;
+}
+
+static inline int v32_dma_supported(struct device *dev, u64 mask)
+{
+        /*
+         * we fall back to GFP_DMA when the mask isn't all 1s,
+         * so we can't guarantee allocations that must be
+         * within a tighter range than GFP_DMA..
+         */
+        if (mask < 0x00ffffff)
+                return 0;
+	return 1;
 }
 
+struct dma_map_ops v32_dma_ops = {
+	.alloc			= v32_dma_alloc,
+	.free			= v32_dma_free,
+	.map_page		= v32_dma_map_page,
+	.map_sg                 = v32_dma_map_sg,
+	.dma_supported		= v32_dma_supported,
+};
+EXPORT_SYMBOL(v32_dma_ops);
diff -puN arch/cris/include/asm/dma-mapping.h~cris-convert-to-dma_map_ops arch/cris/include/asm/dma-mapping.h
--- a/arch/cris/include/asm/dma-mapping.h~cris-convert-to-dma_map_ops
+++ a/arch/cris/include/asm/dma-mapping.h
@@ -1,156 +1,22 @@
-/* DMA mapping. Nothing tricky here, just virt_to_phys */
-
 #ifndef _ASM_CRIS_DMA_MAPPING_H
 #define _ASM_CRIS_DMA_MAPPING_H
 
-#include <linux/mm.h>
-#include <linux/kernel.h>
-#include <linux/scatterlist.h>
-
-#include <asm/cache.h>
-#include <asm/io.h>
-
-#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
-#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-
 #ifdef CONFIG_PCI
-#include <asm-generic/dma-coherent.h>
-
-void *dma_alloc_coherent(struct device *dev, size_t size,
-			   dma_addr_t *dma_handle, gfp_t flag);
+extern struct dma_map_ops v32_dma_ops;
 
-void dma_free_coherent(struct device *dev, size_t size,
-			 void *vaddr, dma_addr_t dma_handle);
-#else
-static inline void *
-dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
-                   gfp_t flag)
+static inline struct dma_map_ops *get_dma_ops(struct device *dev)
 {
-        BUG();
-        return NULL;
+	return &v32_dma_ops;
 }
-
-static inline void
-dma_free_coherent(struct device *dev, size_t size, void *cpu_addr,
-                    dma_addr_t dma_handle)
+#else
+static inline struct dma_map_ops *get_dma_ops(struct device *dev)
 {
-        BUG();
+	BUG();
+	return NULL;
 }
 #endif
-static inline dma_addr_t
-dma_map_single(struct device *dev, void *ptr, size_t size,
-	       enum dma_data_direction direction)
-{
-	BUG_ON(direction == DMA_NONE);
-	return virt_to_phys(ptr);
-}
-
-static inline void
-dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
-		 enum dma_data_direction direction)
-{
-	BUG_ON(direction == DMA_NONE);
-}
-
-static inline int
-dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
-	   enum dma_data_direction direction)
-{
-	printk("Map sg\n");
-	return nents;
-}
-
-static inline dma_addr_t
-dma_map_page(struct device *dev, struct page *page, unsigned long offset,
-	     size_t size, enum dma_data_direction direction)
-{
-	BUG_ON(direction == DMA_NONE);
-	return page_to_phys(page) + offset;
-}
-
-static inline void
-dma_unmap_page(struct device *dev, dma_addr_t dma_address, size_t size,
-	       enum dma_data_direction direction)
-{
-	BUG_ON(direction == DMA_NONE);
-}
-
-
-static inline void
-dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
-	     enum dma_data_direction direction)
-{
-	BUG_ON(direction == DMA_NONE);
-}
-
-static inline void
-dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle, size_t size,
-			enum dma_data_direction direction)
-{
-}
-
-static inline void
-dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle, size_t size,
-			enum dma_data_direction direction)
-{
-}
-
-static inline void
-dma_sync_single_range_for_cpu(struct device *dev, dma_addr_t dma_handle,
-			      unsigned long offset, size_t size,
-			      enum dma_data_direction direction)
-{
-}
 
-static inline void
-dma_sync_single_range_for_device(struct device *dev, dma_addr_t dma_handle,
-				 unsigned long offset, size_t size,
-				 enum dma_data_direction direction)
-{
-}
-
-static inline void
-dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nelems,
-		    enum dma_data_direction direction)
-{
-}
-
-static inline void
-dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg, int nelems,
-		    enum dma_data_direction direction)
-{
-}
-
-static inline int
-dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
-{
-	return 0;
-}
-
-static inline int
-dma_supported(struct device *dev, u64 mask)
-{
-        /*
-         * we fall back to GFP_DMA when the mask isn't all 1s,
-         * so we can't guarantee allocations that must be
-         * within a tighter range than GFP_DMA..
-         */
-        if(mask < 0x00ffffff)
-                return 0;
-
-	return 1;
-}
-
-static inline int
-dma_set_mask(struct device *dev, u64 mask)
-{
-	if(!dev->dma_mask || !dma_supported(dev, mask))
-		return -EIO;
-
-	*dev->dma_mask = mask;
-
-	return 0;
-}
+#include <asm-generic/dma-mapping-common.h>
 
 static inline void
 dma_cache_sync(struct device *dev, void *vaddr, size_t size,
@@ -158,15 +24,4 @@ dma_cache_sync(struct device *dev, void
 {
 }
 
-/* drivers/base/dma-mapping.c */
-extern int dma_common_mmap(struct device *dev, struct vm_area_struct *vma,
-			   void *cpu_addr, dma_addr_t dma_addr, size_t size);
-extern int dma_common_get_sgtable(struct device *dev, struct sg_table *sgt,
-				  void *cpu_addr, dma_addr_t dma_addr,
-				  size_t size);
-
-#define dma_mmap_coherent(d, v, c, h, s) dma_common_mmap(d, v, c, h, s)
-#define dma_get_sgtable(d, t, v, h, s) dma_common_get_sgtable(d, t, v, h, s)
-
