From: akpm@linux-foundation.org
Subject: + blackfin-convert-to-dma_map_ops.patch added to -mm tree
Date: Tue, 17 Nov 2015 13:38:03 -0800
Message-ID: <564b9e3b.aNGVSLtoTAp20DKQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45018 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbbKQViE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Nov 2015 16:38:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, realmz6@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: blackfin: convert to dma_map_ops
has been added to the -mm tree.  Its filename is
     blackfin-convert-to-dma_map_ops.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/blackfin-convert-to-dma_map_ops.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/blackfin-convert-to-dma_map_ops.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: blackfin: convert to dma_map_ops

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Steven Miao <realmz6@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/Kconfig                   |    1 
 arch/blackfin/include/asm/dma-mapping.h |  127 ----------------------
 arch/blackfin/kernel/dma-mapping.c      |   52 ++++++---
 3 files changed, 43 insertions(+), 137 deletions(-)

diff -puN arch/blackfin/Kconfig~blackfin-convert-to-dma_map_ops arch/blackfin/Kconfig
--- a/arch/blackfin/Kconfig~blackfin-convert-to-dma_map_ops
+++ a/arch/blackfin/Kconfig
@@ -40,6 +40,7 @@ config BLACKFIN
 	select HAVE_MOD_ARCH_SPECIFIC
 	select MODULES_USE_ELF_RELA
 	select HAVE_DEBUG_STACKOVERFLOW
+	select HAVE_DMA_ATTRS
 
 config GENERIC_CSUM
 	def_bool y
diff -puN arch/blackfin/include/asm/dma-mapping.h~blackfin-convert-to-dma_map_ops arch/blackfin/include/asm/dma-mapping.h
--- a/arch/blackfin/include/asm/dma-mapping.h~blackfin-convert-to-dma_map_ops
+++ a/arch/blackfin/include/asm/dma-mapping.h
@@ -8,36 +8,6 @@
 #define _BLACKFIN_DMA_MAPPING_H
 
 #include <asm/cacheflush.h>
-struct scatterlist;
-
-void *dma_alloc_coherent(struct device *dev, size_t size,
-			 dma_addr_t *dma_handle, gfp_t gfp);
-void dma_free_coherent(struct device *dev, size_t size, void *vaddr,
-		       dma_addr_t dma_handle);
-
-/*
- * Now for the API extensions over the pci_ one
- */
-#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
-#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-#define dma_supported(d, m)         (1)
-
-static inline int
-dma_set_mask(struct device *dev, u64 dma_mask)
-{
-	if (!dev->dma_mask || !dma_supported(dev, dma_mask))
-		return -EIO;
-
-	*dev->dma_mask = dma_mask;
-
-	return 0;
-}
-
-static inline int
-dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
-{
-	return 0;
-}
 
 extern void
 __dma_sync(dma_addr_t addr, size_t size, enum dma_data_direction dir);
@@ -66,102 +36,13 @@ _dma_sync(dma_addr_t addr, size_t size,
 		__dma_sync(addr, size, dir);
 }
 
-static inline dma_addr_t
-dma_map_single(struct device *dev, void *ptr, size_t size,
-	       enum dma_data_direction dir)
-{
-	_dma_sync((dma_addr_t)ptr, size, dir);
-	return (dma_addr_t) ptr;
-}
-
-static inline dma_addr_t
-dma_map_page(struct device *dev, struct page *page,
-	     unsigned long offset, size_t size,
-	     enum dma_data_direction dir)
-{
-	return dma_map_single(dev, page_address(page) + offset, size, dir);
-}
-
-static inline void
-dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
-		 enum dma_data_direction dir)
-{
-	BUG_ON(!valid_dma_direction(dir));
-}
+extern struct dma_map_ops bfin_dma_ops;
 
-static inline void
-dma_unmap_page(struct device *dev, dma_addr_t dma_addr, size_t size,
-	       enum dma_data_direction dir)
+static inline struct dma_map_ops *get_dma_ops(struct device *dev)
 {
-	dma_unmap_single(dev, dma_addr, size, dir);
+	return &bfin_dma_ops;
 }
 
-extern int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
-		      enum dma_data_direction dir);
-
-static inline void
-dma_unmap_sg(struct device *dev, struct scatterlist *sg,
-	     int nhwentries, enum dma_data_direction dir)
-{
-	BUG_ON(!valid_dma_direction(dir));
-}
-
-static inline void
-dma_sync_single_range_for_cpu(struct device *dev, dma_addr_t handle,
-			      unsigned long offset, size_t size,
-			      enum dma_data_direction dir)
-{
-	BUG_ON(!valid_dma_direction(dir));
-}
-
-static inline void
-dma_sync_single_range_for_device(struct device *dev, dma_addr_t handle,
-				 unsigned long offset, size_t size,
-				 enum dma_data_direction dir)
-{
-	_dma_sync(handle + offset, size, dir);
-}
-
-static inline void
-dma_sync_single_for_cpu(struct device *dev, dma_addr_t handle, size_t size,
-			enum dma_data_direction dir)
-{
-	dma_sync_single_range_for_cpu(dev, handle, 0, size, dir);
-}
-
-static inline void
-dma_sync_single_for_device(struct device *dev, dma_addr_t handle, size_t size,
-			   enum dma_data_direction dir)
-{
-	dma_sync_single_range_for_device(dev, handle, 0, size, dir);
-}
-
-static inline void
-dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nents,
-		    enum dma_data_direction dir)
-{
-	BUG_ON(!valid_dma_direction(dir));
-}
-
-extern void
-dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
-		       int nents, enum dma_data_direction dir);
-
-static inline void
-dma_cache_sync(struct device *dev, void *vaddr, size_t size,
-	       enum dma_data_direction dir)
-{
-	_dma_sync((dma_addr_t)vaddr, size, dir);
-}
-
-/* drivers/base/dma-mapping.c */
-extern int dma_common_mmap(struct device *dev, struct vm_area_struct *vma,
-			   void *cpu_addr, dma_addr_t dma_addr, size_t size);
-extern int dma_common_get_sgtable(struct device *dev, struct sg_table *sgt,
-				  void *cpu_addr, dma_addr_t dma_addr,
-				  size_t size);
-
-#define dma_mmap_coherent(d, v, c, h, s) dma_common_mmap(d, v, c, h, s)
-#define dma_get_sgtable(d, t, v, h, s) dma_common_get_sgtable(d, t, v, h, s)
+#include <asm-generic/dma-mapping-common.h>
 
 #endif				/* _BLACKFIN_DMA_MAPPING_H */
diff -puN arch/blackfin/kernel/dma-mapping.c~blackfin-convert-to-dma_map_ops arch/blackfin/kernel/dma-mapping.c
--- a/arch/blackfin/kernel/dma-mapping.c~blackfin-convert-to-dma_map_ops
+++ a/arch/blackfin/kernel/dma-mapping.c
@@ -78,8 +78,8 @@ static void __free_dma_pages(unsigned lo
 	spin_unlock_irqrestore(&dma_page_lock, flags);
 }
 
-void *dma_alloc_coherent(struct device *dev, size_t size,
-			 dma_addr_t *dma_handle, gfp_t gfp)
+static void *bfin_dma_alloc(struct device *dev, size_t size,
+		dma_addr_t *dma_handle, gfp_t gfp, struct dma_attrs *attrs)
 {
 	void *ret;
 
@@ -92,15 +92,12 @@ void *dma_alloc_coherent(struct device *
 
 	return ret;
 }
-EXPORT_SYMBOL(dma_alloc_coherent);
 
-void
-dma_free_coherent(struct device *dev, size_t size, void *vaddr,
-		  dma_addr_t dma_handle)
+static void bfin_dma_free(struct device *dev, size_t size, void *vaddr,
+		  dma_addr_t dma_handle, struct dma_attrs *attrs)
 {
 	__free_dma_pages((unsigned long)vaddr, get_pages(size));
 }
-EXPORT_SYMBOL(dma_free_coherent);
 
 /*
  * Streaming DMA mappings
@@ -112,9 +109,9 @@ void __dma_sync(dma_addr_t addr, size_t
 }
 EXPORT_SYMBOL(__dma_sync);
 
-int
-dma_map_sg(struct device *dev, struct scatterlist *sg_list, int nents,
-	   enum dma_data_direction direction)
+static int bfin_dma_map_sg(struct device *dev, struct scatterlist *sg_list,
+		int nents, enum dma_data_direction direction,
+		struct dma_attrs *attrs)
 {
 	struct scatterlist *sg;
 	int i;
@@ -126,10 +123,10 @@ dma_map_sg(struct device *dev, struct sc
 
 	return nents;
 }
-EXPORT_SYMBOL(dma_map_sg);
 
-void dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg_list,
-			    int nelems, enum dma_data_direction direction)
+static void bfin_dma_sync_sg_for_device(struct device *dev,
+		struct scatterlist *sg_list, int nelems,
+		enum dma_data_direction direction)
 {
 	struct scatterlist *sg;
 	int i;
@@ -139,4 +136,31 @@ void dma_sync_sg_for_device(struct devic
 		__dma_sync(sg_dma_address(sg), sg_dma_len(sg), direction);
 	}
 }
-EXPORT_SYMBOL(dma_sync_sg_for_device);
+
+static dma_addr_t bfin_dma_map_page(struct device *dev, struct page *page,
+		unsigned long offset, size_t size, enum dma_data_direction dir,
+		struct dma_attrs *attrs)
+{
+	dma_addr_t handle = (dma_addr_t)(page_address(page) + offset);
+
+	_dma_sync(handle, size, dir);
+	return handle;
+}
+
+static inline void bfin_dma_sync_single_for_device(struct device *dev,
+		dma_addr_t handle, size_t size, enum dma_data_direction dir)
+{
+	_dma_sync(handle, size, dir);
+}
+
+struct dma_map_ops bfin_dma_ops = {
+	.alloc			= bfin_dma_alloc,
+	.free			= bfin_dma_free,
+
+	.map_page		= bfin_dma_map_page,
+	.map_sg			= bfin_dma_map_sg,
+
+	.sync_single_for_device	= bfin_dma_sync_single_for_device,
+	.sync_sg_for_device	= bfin_dma_sync_sg_for_device,
+};
+EXPORT_SYMBOL(bfin_dma_ops);
_

Patches currently in -mm which might be from hch@lst.de are

dma-mapping-make-the-generic-coherent-dma-mmap-implementation-optional.patch
arc-convert-to-dma_map_ops.patch
avr32-convert-to-dma_map_ops.patch
blackfin-convert-to-dma_map_ops.patch
c6x-convert-to-dma_map_ops.patch
cris-convert-to-dma_map_ops.patch
nios2-convert-to-dma_map_ops.patch
frv-convert-to-dma_map_ops.patch
parisc-convert-to-dma_map_ops.patch
mn10300-convert-to-dma_map_ops.patch
m68k-convert-to-dma_map_ops.patch
metag-convert-to-dma_map_ops.patch
sparc-use-generic-dma_set_mask.patch
tile-uninline-dma_set_mask.patch
dma-mapping-always-provide-the-dma_map_ops-based-implementation.patch
dma-mapping-remove-asm-generic-dma-coherenth.patch

