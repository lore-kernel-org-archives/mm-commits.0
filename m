From: akpm@linux-foundation.org
Subject: [merged] sparc-move-the-duplication-in-dma-mapping_3264h-to-dma-mappingh.patch removed from -mm tree
Date: Tue, 16 Jun 2009 15:43:55 -0700
Message-ID: <200906162243.n5GMhtjU005700@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38489 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763110AbZFPWo1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Jun 2009 18:44:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, reif@earthlink.net, mm-commits@vger.kernel.org


The patch titled
     sparc: move the duplication in dma-mapping_{32|64}.h to dma-mapping.h
has been removed from the -mm tree.  Its filename was
     sparc-move-the-duplication-in-dma-mapping_3264h-to-dma-mappingh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sparc: move the duplication in dma-mapping_{32|64}.h to dma-mapping.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

This patchset unifies dma-mapping_32.h and dma-mapping_64.h, that is,
it uses dma-mapping.h instead and removes dma-mapping_32.h and
dma-mapping_64.h.

In short, this patchset modifies SPARC32 to use struct dma_map
ops.

I like to see architectures implement the dma API in the similar way.


This patch:

Move the duplication in dma-mapping_{32|64}.h to dma-mapping.h.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Tested-by: Robert Reif <reif@earthlink.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/dma-mapping.h    |   42 ++++++++++++++++++++++
 arch/sparc/include/asm/dma-mapping_32.h |   18 ---------
 arch/sparc/include/asm/dma-mapping_64.h |   40 --------------------
 arch/sparc/kernel/dma.c                 |   30 ---------------
 4 files changed, 42 insertions(+), 88 deletions(-)

diff -puN arch/sparc/include/asm/dma-mapping.h~sparc-move-the-duplication-in-dma-mapping_3264h-to-dma-mappingh arch/sparc/include/asm/dma-mapping.h
--- a/arch/sparc/include/asm/dma-mapping.h~sparc-move-the-duplication-in-dma-mapping_3264h-to-dma-mappingh
+++ a/arch/sparc/include/asm/dma-mapping.h
@@ -5,4 +5,46 @@
 #else
 #include <asm/dma-mapping_32.h>
 #endif
+
+#define DMA_ERROR_CODE	(~(dma_addr_t)0x0)
+
+extern int dma_supported(struct device *dev, u64 mask);
+extern int dma_set_mask(struct device *dev, u64 dma_mask);
+
+static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
+{
+	return (dma_addr == DMA_ERROR_CODE);
+}
+
+static inline int dma_get_cache_alignment(void)
+{
+	/*
+	 * no easy way to get cache size on all processors, so return
+	 * the maximum possible, to be safe
+	 */
+	return (1 << INTERNODE_CACHE_SHIFT);
+}
+
+#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
+#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
+#define dma_is_consistent(d, h)	(1)
+
+static inline void dma_sync_single_range_for_cpu(struct device *dev,
+						 dma_addr_t dma_handle,
+						 unsigned long offset,
+						 size_t size,
+						 enum dma_data_direction dir)
+{
+	dma_sync_single_for_cpu(dev, dma_handle+offset, size, dir);
+}
+
+static inline void dma_sync_single_range_for_device(struct device *dev,
+						    dma_addr_t dma_handle,
+						    unsigned long offset,
+						    size_t size,
+						    enum dma_data_direction dir)
+{
+	dma_sync_single_for_device(dev, dma_handle+offset, size, dir);
+}
+
 #endif
diff -puN arch/sparc/include/asm/dma-mapping_32.h~sparc-move-the-duplication-in-dma-mapping_3264h-to-dma-mappingh arch/sparc/include/asm/dma-mapping_32.h
--- a/arch/sparc/include/asm/dma-mapping_32.h~sparc-move-the-duplication-in-dma-mapping_3264h-to-dma-mappingh
+++ a/arch/sparc/include/asm/dma-mapping_32.h
@@ -7,10 +7,6 @@ struct device;
 struct scatterlist;
 struct page;
 
-#define DMA_ERROR_CODE	(~(dma_addr_t)0x0)
-
-extern int dma_supported(struct device *dev, u64 mask);
-extern int dma_set_mask(struct device *dev, u64 dma_mask);
 extern void *dma_alloc_coherent(struct device *dev, size_t size,
 				dma_addr_t *dma_handle, gfp_t flag);
 extern void dma_free_coherent(struct device *dev, size_t size,
@@ -37,24 +33,10 @@ extern void dma_sync_single_for_device(s
 				       dma_addr_t dma_handle,
 				       size_t size,
 				       enum dma_data_direction direction);
-extern void dma_sync_single_range_for_cpu(struct device *dev,
-					  dma_addr_t dma_handle,
-					  unsigned long offset,
-					  size_t size,
-					  enum dma_data_direction direction);
-extern void dma_sync_single_range_for_device(struct device *dev,
-					     dma_addr_t dma_handle,
-					     unsigned long offset, size_t size,
-					     enum dma_data_direction direction);
 extern void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
 				int nelems, enum dma_data_direction direction);
 extern void dma_sync_sg_for_device(struct device *dev,
 				   struct scatterlist *sg, int nelems,
 				   enum dma_data_direction direction);
-extern int dma_mapping_error(struct device *dev, dma_addr_t dma_addr);
-extern int dma_get_cache_alignment(void);
-
-#define dma_alloc_noncoherent	dma_alloc_coherent
-#define dma_free_noncoherent	dma_free_coherent
 
 #endif /* _ASM_SPARC_DMA_MAPPING_H */
diff -puN arch/sparc/include/asm/dma-mapping_64.h~sparc-move-the-duplication-in-dma-mapping_3264h-to-dma-mappingh arch/sparc/include/asm/dma-mapping_64.h
--- a/arch/sparc/include/asm/dma-mapping_64.h~sparc-move-the-duplication-in-dma-mapping_3264h-to-dma-mappingh
+++ a/arch/sparc/include/asm/dma-mapping_64.h
@@ -4,8 +4,6 @@
 #include <linux/scatterlist.h>
 #include <linux/mm.h>
 
-#define DMA_ERROR_CODE	(~(dma_addr_t)0x0)
-
 struct dma_ops {
 	void *(*alloc_coherent)(struct device *dev, size_t size,
 				dma_addr_t *dma_handle, gfp_t flag);
@@ -31,9 +29,6 @@ struct dma_ops {
 };
 extern const struct dma_ops *dma_ops;
 
-extern int dma_supported(struct device *dev, u64 mask);
-extern int dma_set_mask(struct device *dev, u64 dma_mask);
-
 static inline void *dma_alloc_coherent(struct device *dev, size_t size,
 				       dma_addr_t *dma_handle, gfp_t flag)
 {
@@ -102,25 +97,6 @@ static inline void dma_sync_single_for_d
 	/* No flushing needed to sync cpu writes to the device.  */
 }
 
-static inline void dma_sync_single_range_for_cpu(struct device *dev,
-						 dma_addr_t dma_handle,
-						 unsigned long offset,
-						 size_t size,
-						 enum dma_data_direction direction)
-{
-	dma_sync_single_for_cpu(dev, dma_handle+offset, size, direction);
-}
-
-static inline void dma_sync_single_range_for_device(struct device *dev,
-						    dma_addr_t dma_handle,
-						    unsigned long offset,
-						    size_t size,
-						    enum dma_data_direction direction)
-{
-	/* No flushing needed to sync cpu writes to the device.  */
-}
-
-
 static inline void dma_sync_sg_for_cpu(struct device *dev,
 				       struct scatterlist *sg, int nelems,
 				       enum dma_data_direction direction)
@@ -135,20 +111,4 @@ static inline void dma_sync_sg_for_devic
 	/* No flushing needed to sync cpu writes to the device.  */
 }
 
-static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
-{
-	return (dma_addr == DMA_ERROR_CODE);
-}
-
-static inline int dma_get_cache_alignment(void)
-{
-	/* no easy way to get cache size on all processors, so return
-	 * the maximum possible, to be safe */
-	return (1 << INTERNODE_CACHE_SHIFT);
-}
-
-#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
-#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-#define dma_is_consistent(d, h)	(1)
-
 #endif /* _ASM_SPARC64_DMA_MAPPING_H */
diff -puN arch/sparc/kernel/dma.c~sparc-move-the-duplication-in-dma-mapping_3264h-to-dma-mappingh arch/sparc/kernel/dma.c
--- a/arch/sparc/kernel/dma.c~sparc-move-the-duplication-in-dma-mapping_3264h-to-dma-mappingh
+++ a/arch/sparc/kernel/dma.c
@@ -167,24 +167,6 @@ void dma_sync_single_for_device(struct d
 }
 EXPORT_SYMBOL(dma_sync_single_for_device);
 
-void dma_sync_single_range_for_cpu(struct device *dev,
-				   dma_addr_t dma_handle,
-				   unsigned long offset,
-				   size_t size,
-				   enum dma_data_direction direction)
-{
-	dma_sync_single_for_cpu(dev, dma_handle+offset, size, direction);
-}
-EXPORT_SYMBOL(dma_sync_single_range_for_cpu);
-
-void dma_sync_single_range_for_device(struct device *dev, dma_addr_t dma_handle,
-				      unsigned long offset, size_t size,
-				      enum dma_data_direction direction)
-{
-	dma_sync_single_for_device(dev, dma_handle+offset, size, direction);
-}
-EXPORT_SYMBOL(dma_sync_single_range_for_device);
-
 void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
 			 int nelems, enum dma_data_direction direction)
 {
@@ -213,15 +195,3 @@ void dma_sync_sg_for_device(struct devic
 	BUG();
 }
 EXPORT_SYMBOL(dma_sync_sg_for_device);
-
-int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
-{
-	return (dma_addr == DMA_ERROR_CODE);
-}
-EXPORT_SYMBOL(dma_mapping_error);
