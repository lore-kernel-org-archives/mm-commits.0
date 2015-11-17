From: akpm@linux-foundation.org
Subject: + frv-convert-to-dma_map_ops.patch added to -mm tree
Date: Tue, 17 Nov 2015 13:38:06 -0800
Message-ID: <564b9e3e.Ec5DBmYddZLuhr/n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45029 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbbKQViG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Nov 2015 16:38:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: frv: convert to dma_map_ops
has been added to the -mm tree.  Its filename is
     frv-convert-to-dma_map_ops.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/frv-convert-to-dma_map_ops.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/frv-convert-to-dma_map_ops.patch

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
Subject: frv: convert to dma_map_ops

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/Kconfig                      |    2 
 arch/frv/include/asm/dma-mapping.h    |  132 ------------------------
 arch/frv/mb93090-mb00/pci-dma-nommu.c |   72 ++++++++-----
 arch/frv/mb93090-mb00/pci-dma.c       |   74 ++++++++-----
 4 files changed, 101 insertions(+), 179 deletions(-)

diff -puN arch/frv/Kconfig~frv-convert-to-dma_map_ops arch/frv/Kconfig
--- a/arch/frv/Kconfig~frv-convert-to-dma_map_ops
+++ a/arch/frv/Kconfig
@@ -14,6 +14,8 @@ config FRV
 	select OLD_SIGSUSPEND3
 	select OLD_SIGACTION
 	select HAVE_DEBUG_STACKOVERFLOW
+	select ARCH_NO_COHERENT_DMA_MMAP
+	select HAVE_DMA_ATTRS
 
 config ZONE_DMA
 	bool
diff -puN arch/frv/include/asm/dma-mapping.h~frv-convert-to-dma_map_ops arch/frv/include/asm/dma-mapping.h
--- a/arch/frv/include/asm/dma-mapping.h~frv-convert-to-dma_map_ops
+++ a/arch/frv/include/asm/dma-mapping.h
@@ -1,128 +1,17 @@
 #ifndef _ASM_DMA_MAPPING_H
 #define _ASM_DMA_MAPPING_H
 
-#include <linux/device.h>
-#include <linux/scatterlist.h>
 #include <asm/cache.h>
 #include <asm/cacheflush.h>
-#include <asm/io.h>
-
-/*
- * See Documentation/DMA-API.txt for the description of how the
- * following DMA API should work.
- */
-
-#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
-#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
 
 extern unsigned long __nongprelbss dma_coherent_mem_start;
 extern unsigned long __nongprelbss dma_coherent_mem_end;
 
-void *dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle, gfp_t gfp);
-void dma_free_coherent(struct device *dev, size_t size, void *vaddr, dma_addr_t dma_handle);
-
-extern dma_addr_t dma_map_single(struct device *dev, void *ptr, size_t size,
-				 enum dma_data_direction direction);
-
-static inline
-void dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
-		      enum dma_data_direction direction)
-{
-	BUG_ON(direction == DMA_NONE);
-}
-
-extern int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
-		      enum dma_data_direction direction);
-
-static inline
-void dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
-	     enum dma_data_direction direction)
-{
-	BUG_ON(direction == DMA_NONE);
-}
-
-extern
-dma_addr_t dma_map_page(struct device *dev, struct page *page, unsigned long offset,
-			size_t size, enum dma_data_direction direction);
-
-static inline
-void dma_unmap_page(struct device *dev, dma_addr_t dma_address, size_t size,
-		    enum dma_data_direction direction)
-{
-	BUG_ON(direction == DMA_NONE);
-}
-
-
-static inline
-void dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle, size_t size,
-			     enum dma_data_direction direction)
-{
-}
-
-static inline
-void dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle, size_t size,
-				enum dma_data_direction direction)
-{
-	flush_write_buffers();
-}
+extern struct dma_map_ops frv_dma_ops;
 
-static inline
-void dma_sync_single_range_for_cpu(struct device *dev, dma_addr_t dma_handle,
-				   unsigned long offset, size_t size,
-				   enum dma_data_direction direction)
+static inline struct dma_map_ops *get_dma_ops(struct device *dev)
 {
-}
-
-static inline
-void dma_sync_single_range_for_device(struct device *dev, dma_addr_t dma_handle,
-				      unsigned long offset, size_t size,
-				      enum dma_data_direction direction)
-{
-	flush_write_buffers();
-}
-
-static inline
-void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nelems,
-			 enum dma_data_direction direction)
-{
-}
-
-static inline
-void dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg, int nelems,
-			    enum dma_data_direction direction)
-{
-	flush_write_buffers();
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
-        /*
-         * we fall back to GFP_DMA when the mask isn't all 1s,
-         * so we can't guarantee allocations that must be
-         * within a tighter range than GFP_DMA..
-         */
-        if (mask < 0x00ffffff)
-                return 0;
-
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
-
-	return 0;
+	return &frv_dma_ops;
 }
 
 static inline
@@ -132,19 +21,6 @@ void dma_cache_sync(struct device *dev,
 	flush_write_buffers();
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
 
 #endif  /* _ASM_DMA_MAPPING_H */
diff -puN arch/frv/mb93090-mb00/pci-dma-nommu.c~frv-convert-to-dma_map_ops arch/frv/mb93090-mb00/pci-dma-nommu.c
--- a/arch/frv/mb93090-mb00/pci-dma-nommu.c~frv-convert-to-dma_map_ops
+++ a/arch/frv/mb93090-mb00/pci-dma-nommu.c
@@ -34,7 +34,8 @@ struct dma_alloc_record {
 static DEFINE_SPINLOCK(dma_alloc_lock);
 static LIST_HEAD(dma_alloc_list);
 
-void *dma_alloc_coherent(struct device *hwdev, size_t size, dma_addr_t *dma_handle, gfp_t gfp)
+static void *frv_dma_alloc(struct device *hwdev, size_t size, dma_addr_t *dma_handle,
+		gfp_t gfp, struct dma_attrs *attrs)
 {
 	struct dma_alloc_record *new;
 	struct list_head *this = &dma_alloc_list;
@@ -84,9 +85,8 @@ void *dma_alloc_coherent(struct device *
 	return NULL;
 }
 
-EXPORT_SYMBOL(dma_alloc_coherent);
-
-void dma_free_coherent(struct device *hwdev, size_t size, void *vaddr, dma_addr_t dma_handle)
+static void frv_dma_free(struct device *hwdev, size_t size, void *vaddr,
+		dma_addr_t dma_handle, struct dma_attrs *attrs)
 {
 	struct dma_alloc_record *rec;
 	unsigned long flags;
@@ -105,22 +105,9 @@ void dma_free_coherent(struct device *hw
 	BUG();
 }
 
-EXPORT_SYMBOL(dma_free_coherent);
-
-dma_addr_t dma_map_single(struct device *dev, void *ptr, size_t size,
-			  enum dma_data_direction direction)
-{
-	BUG_ON(direction == DMA_NONE);
-
-	frv_cache_wback_inv((unsigned long) ptr, (unsigned long) ptr + size);
-
-	return virt_to_bus(ptr);
-}
-
-EXPORT_SYMBOL(dma_map_single);
-
-int dma_map_sg(struct device *dev, struct scatterlist *sglist, int nents,
-	       enum dma_data_direction direction)
+static int frv_dma_map_sg(struct device *dev, struct scatterlist *sglist,
+		int nents, enum dma_data_direction direction,
+		struct dma_attrs *attrs)
 {
 	int i;
 	struct scatterlist *sg;
@@ -135,14 +122,49 @@ int dma_map_sg(struct device *dev, struc
 	return nents;
 }
 
-EXPORT_SYMBOL(dma_map_sg);
-
-dma_addr_t dma_map_page(struct device *dev, struct page *page, unsigned long offset,
-			size_t size, enum dma_data_direction direction)
+static dma_addr_t frv_dma_map_page(struct device *dev, struct page *page,
+		unsigned long offset, size_t size,
+		enum dma_data_direction direction, struct dma_attrs *attrs)
 {
 	BUG_ON(direction == DMA_NONE);
 	flush_dcache_page(page);
 	return (dma_addr_t) page_to_phys(page) + offset;
 }
 
-EXPORT_SYMBOL(dma_map_page);
+static void frv_dma_sync_single_for_device(struct device *dev,
+		dma_addr_t dma_handle, size_t size,
+		enum dma_data_direction direction)
+{
+	flush_write_buffers();
+}
+
+static void frv_dma_sync_sg_for_device(struct device *dev,
+		struct scatterlist *sg, int nelems,
+		enum dma_data_direction direction)
+{
+	flush_write_buffers();
+}
+
+
+static int frv_dma_supported(struct device *dev, u64 mask)
+{
+        /*
+         * we fall back to GFP_DMA when the mask isn't all 1s,
+         * so we can't guarantee allocations that must be
+         * within a tighter range than GFP_DMA..
+         */
+        if (mask < 0x00ffffff)
+                return 0;
+	return 1;
+}
+
+struct dma_map_ops frv_dma_ops = {
+	.alloc			= frv_dma_alloc,
+	.free			= frv_dma_free,
+	.map_page		= frv_dma_map_page,
+	.map_sg			= frv_dma_map_sg,
+	.sync_single_for_device	= frv_dma_sync_single_for_device,
+	.sync_sg_for_device	= frv_dma_sync_sg_for_device,
+	.dma_supported		= frv_dma_supported,
+};
+EXPORT_SYMBOL(frv_dma_ops);
diff -puN arch/frv/mb93090-mb00/pci-dma.c~frv-convert-to-dma_map_ops arch/frv/mb93090-mb00/pci-dma.c
--- a/arch/frv/mb93090-mb00/pci-dma.c~frv-convert-to-dma_map_ops
+++ a/arch/frv/mb93090-mb00/pci-dma.c
@@ -18,7 +18,9 @@
 #include <linux/scatterlist.h>
 #include <asm/io.h>
 
-void *dma_alloc_coherent(struct device *hwdev, size_t size, dma_addr_t *dma_handle, gfp_t gfp)
+static void *frv_dma_alloc(struct device *hwdev, size_t size,
+		dma_addr_t *dma_handle, gfp_t gfp,
+		struct dma_attrs *attrs)
 {
 	void *ret;
 
@@ -29,29 +31,15 @@ void *dma_alloc_coherent(struct device *
 	return ret;
 }
 
-EXPORT_SYMBOL(dma_alloc_coherent);
-
-void dma_free_coherent(struct device *hwdev, size_t size, void *vaddr, dma_addr_t dma_handle)
+static void frv_dma_free(struct device *hwdev, size_t size, void *vaddr,
+		dma_addr_t dma_handle, struct dma_attrs *attrs)
 {
 	consistent_free(vaddr);
 }
 
-EXPORT_SYMBOL(dma_free_coherent);
-
-dma_addr_t dma_map_single(struct device *dev, void *ptr, size_t size,
-			  enum dma_data_direction direction)
-{
-	BUG_ON(direction == DMA_NONE);
-
-	frv_cache_wback_inv((unsigned long) ptr, (unsigned long) ptr + size);
-
-	return virt_to_bus(ptr);
-}
-
-EXPORT_SYMBOL(dma_map_single);
-
-int dma_map_sg(struct device *dev, struct scatterlist *sglist, int nents,
-	       enum dma_data_direction direction)
+static int frv_dma_map_sg(struct device *dev, struct scatterlist *sglist,
+		int nents, enum dma_data_direction direction,
+		struct dma_attrs *attrs)
 {
 	unsigned long dampr2;
 	void *vaddr;
@@ -79,14 +67,48 @@ int dma_map_sg(struct device *dev, struc
 	return nents;
 }
 
-EXPORT_SYMBOL(dma_map_sg);
-
-dma_addr_t dma_map_page(struct device *dev, struct page *page, unsigned long offset,
-			size_t size, enum dma_data_direction direction)
+static dma_addr_t frv_dma_map_page(struct device *dev, struct page *page,
+		unsigned long offset, size_t size,
+		enum dma_data_direction direction, struct dma_attrs *attrs)
 {
-	BUG_ON(direction == DMA_NONE);
 	flush_dcache_page(page);
 	return (dma_addr_t) page_to_phys(page) + offset;
 }
 
-EXPORT_SYMBOL(dma_map_page);
+static void frv_dma_sync_single_for_device(struct device *dev,
+		dma_addr_t dma_handle, size_t size,
+		enum dma_data_direction direction)
+{
+	flush_write_buffers();
+}
+
+static void frv_dma_sync_sg_for_device(struct device *dev,
+		struct scatterlist *sg, int nelems,
+		enum dma_data_direction direction)
+{
+	flush_write_buffers();
+}
+
+
+static int frv_dma_supported(struct device *dev, u64 mask)
+{
+        /*
+         * we fall back to GFP_DMA when the mask isn't all 1s,
+         * so we can't guarantee allocations that must be
+         * within a tighter range than GFP_DMA..
+         */
+        if (mask < 0x00ffffff)
+                return 0;
+	return 1;
+}
+
+struct dma_map_ops frv_dma_ops = {
+	.alloc			= frv_dma_alloc,
+	.free			= frv_dma_free,
+	.map_page		= frv_dma_map_page,
+	.map_sg			= frv_dma_map_sg,
+	.sync_single_for_device	= frv_dma_sync_single_for_device,
+	.sync_sg_for_device	= frv_dma_sync_sg_for_device,
+	.dma_supported		= frv_dma_supported,
+};
+EXPORT_SYMBOL(frv_dma_ops);
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

