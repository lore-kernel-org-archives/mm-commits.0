From: akpm@linux-foundation.org
Subject: [merged] sparc-remove-dma-mapping_3264h.patch removed from -mm tree
Date: Tue, 16 Jun 2009 15:44:04 -0700
Message-ID: <200906162244.n5GMi4lf005857@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42300 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757122AbZFPWog (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Jun 2009 18:44:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, reif@earthlink.net, mm-commits@vger.kernel.org


The patch titled
     sparc: remove dma-mapping_{32|64}.h
has been removed from the -mm tree.  Its filename was
     sparc-remove-dma-mapping_3264h.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sparc: remove dma-mapping_{32|64}.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

This modifies SPARC32 to use struct dma_map ops.  It means that we can
remove dma-mapping_{32|64}.h.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Tested-by: Robert Reif <reif@earthlink.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/dma-mapping.h    |  148 +++++++++++++++++++---
 arch/sparc/include/asm/dma-mapping_32.h |   42 ------
 arch/sparc/include/asm/dma-mapping_64.h |  121 -----------------
 arch/sparc/kernel/dma.c                 |   99 +++++---------
 4 files changed, 172 insertions(+), 238 deletions(-)

diff -puN arch/sparc/include/asm/dma-mapping.h~sparc-remove-dma-mapping_3264h arch/sparc/include/asm/dma-mapping.h
--- a/arch/sparc/include/asm/dma-mapping.h~sparc-remove-dma-mapping_3264h
+++ a/arch/sparc/include/asm/dma-mapping.h
@@ -1,33 +1,134 @@
 #ifndef ___ASM_SPARC_DMA_MAPPING_H
 #define ___ASM_SPARC_DMA_MAPPING_H
-#if defined(__sparc__) && defined(__arch64__)
-#include <asm/dma-mapping_64.h>
-#else
-#include <asm/dma-mapping_32.h>
-#endif
+
+#include <linux/scatterlist.h>
+#include <linux/mm.h>
 
 #define DMA_ERROR_CODE	(~(dma_addr_t)0x0)
 
 extern int dma_supported(struct device *dev, u64 mask);
 extern int dma_set_mask(struct device *dev, u64 dma_mask);
 
-static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
+#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
+#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
+#define dma_is_consistent(d, h)	(1)
+
+struct dma_ops {
+	void *(*alloc_coherent)(struct device *dev, size_t size,
+				dma_addr_t *dma_handle, gfp_t flag);
+	void (*free_coherent)(struct device *dev, size_t size,
+			      void *cpu_addr, dma_addr_t dma_handle);
+	dma_addr_t (*map_page)(struct device *dev, struct page *page,
+			       unsigned long offset, size_t size,
+			       enum dma_data_direction direction);
+	void (*unmap_page)(struct device *dev, dma_addr_t dma_addr,
+			   size_t size,
+			   enum dma_data_direction direction);
+	int (*map_sg)(struct device *dev, struct scatterlist *sg, int nents,
+		      enum dma_data_direction direction);
+	void (*unmap_sg)(struct device *dev, struct scatterlist *sg,
+			 int nhwentries,
+			 enum dma_data_direction direction);
+	void (*sync_single_for_cpu)(struct device *dev,
+				    dma_addr_t dma_handle, size_t size,
+				    enum dma_data_direction direction);
+	void (*sync_single_for_device)(struct device *dev,
+				       dma_addr_t dma_handle, size_t size,
+				       enum dma_data_direction direction);
+	void (*sync_sg_for_cpu)(struct device *dev, struct scatterlist *sg,
+				int nelems,
+				enum dma_data_direction direction);
+	void (*sync_sg_for_device)(struct device *dev,
+				   struct scatterlist *sg, int nents,
+				   enum dma_data_direction dir);
+};
+extern const struct dma_ops *dma_ops;
+
+static inline void *dma_alloc_coherent(struct device *dev, size_t size,
+				       dma_addr_t *dma_handle, gfp_t flag)
 {
-	return (dma_addr == DMA_ERROR_CODE);
+	return dma_ops->alloc_coherent(dev, size, dma_handle, flag);
 }
 
-static inline int dma_get_cache_alignment(void)
+static inline void dma_free_coherent(struct device *dev, size_t size,
+				     void *cpu_addr, dma_addr_t dma_handle)
 {
-	/*
-	 * no easy way to get cache size on all processors, so return
-	 * the maximum possible, to be safe
-	 */
-	return (1 << INTERNODE_CACHE_SHIFT);
+	dma_ops->free_coherent(dev, size, cpu_addr, dma_handle);
 }
 
-#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
-#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-#define dma_is_consistent(d, h)	(1)
+static inline dma_addr_t dma_map_single(struct device *dev, void *cpu_addr,
+					size_t size,
+					enum dma_data_direction direction)
+{
+	return dma_ops->map_page(dev, virt_to_page(cpu_addr),
+				 (unsigned long)cpu_addr & ~PAGE_MASK, size,
+				 direction);
+}
+
+static inline void dma_unmap_single(struct device *dev, dma_addr_t dma_addr,
+				    size_t size,
+				    enum dma_data_direction direction)
+{
+	dma_ops->unmap_page(dev, dma_addr, size, direction);
+}
+
+static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
+				      unsigned long offset, size_t size,
+				      enum dma_data_direction direction)
+{
+	return dma_ops->map_page(dev, page, offset, size, direction);
+}
+
+static inline void dma_unmap_page(struct device *dev, dma_addr_t dma_address,
+				  size_t size,
+				  enum dma_data_direction direction)
+{
+	dma_ops->unmap_page(dev, dma_address, size, direction);
+}
+
+static inline int dma_map_sg(struct device *dev, struct scatterlist *sg,
+			     int nents, enum dma_data_direction direction)
+{
+	return dma_ops->map_sg(dev, sg, nents, direction);
+}
+
+static inline void dma_unmap_sg(struct device *dev, struct scatterlist *sg,
+				int nents, enum dma_data_direction direction)
+{
+	dma_ops->unmap_sg(dev, sg, nents, direction);
+}
+
+static inline void dma_sync_single_for_cpu(struct device *dev,
+					   dma_addr_t dma_handle, size_t size,
+					   enum dma_data_direction direction)
+{
+	dma_ops->sync_single_for_cpu(dev, dma_handle, size, direction);
+}
+
+static inline void dma_sync_single_for_device(struct device *dev,
+					      dma_addr_t dma_handle,
+					      size_t size,
+					      enum dma_data_direction direction)
+{
+	if (dma_ops->sync_single_for_device)
+		dma_ops->sync_single_for_device(dev, dma_handle, size,
+						direction);
+}
+
+static inline void dma_sync_sg_for_cpu(struct device *dev,
+				       struct scatterlist *sg, int nelems,
+				       enum dma_data_direction direction)
+{
+	dma_ops->sync_sg_for_cpu(dev, sg, nelems, direction);
+}
+
+static inline void dma_sync_sg_for_device(struct device *dev,
+					  struct scatterlist *sg, int nelems,
+					  enum dma_data_direction direction)
+{
+	if (dma_ops->sync_sg_for_device)
+		dma_ops->sync_sg_for_device(dev, sg, nelems, direction);
+}
 
 static inline void dma_sync_single_range_for_cpu(struct device *dev,
 						 dma_addr_t dma_handle,
@@ -47,4 +148,19 @@ static inline void dma_sync_single_range
 	dma_sync_single_for_device(dev, dma_handle+offset, size, dir);
 }
 
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
 #endif
diff -puN arch/sparc/include/asm/dma-mapping_32.h~sparc-remove-dma-mapping_3264h /dev/null
--- a/arch/sparc/include/asm/dma-mapping_32.h
+++ /dev/null
@@ -1,42 +0,0 @@
-#ifndef _ASM_SPARC_DMA_MAPPING_H
-#define _ASM_SPARC_DMA_MAPPING_H
-
-#include <linux/types.h>
-
-struct device;
-struct scatterlist;
-struct page;
-
-extern void *dma_alloc_coherent(struct device *dev, size_t size,
-				dma_addr_t *dma_handle, gfp_t flag);
-extern void dma_free_coherent(struct device *dev, size_t size,
-			      void *cpu_addr, dma_addr_t dma_handle);
-extern dma_addr_t dma_map_single(struct device *dev, void *cpu_addr,
-				 size_t size,
-				 enum dma_data_direction direction);
-extern void dma_unmap_single(struct device *dev, dma_addr_t dma_addr,
-			     size_t size,
-			     enum dma_data_direction direction);
-extern dma_addr_t dma_map_page(struct device *dev, struct page *page,
-			       unsigned long offset, size_t size,
-			       enum dma_data_direction direction);
-extern void dma_unmap_page(struct device *dev, dma_addr_t dma_address,
-			   size_t size, enum dma_data_direction direction);
-extern int dma_map_sg(struct device *dev, struct scatterlist *sg,
-		      int nents, enum dma_data_direction direction);
-extern void dma_unmap_sg(struct device *dev, struct scatterlist *sg,
-			 int nents, enum dma_data_direction direction);
-extern void dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
-				    size_t size,
-				    enum dma_data_direction direction);
-extern void dma_sync_single_for_device(struct device *dev,
-				       dma_addr_t dma_handle,
-				       size_t size,
-				       enum dma_data_direction direction);
-extern void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
-				int nelems, enum dma_data_direction direction);
-extern void dma_sync_sg_for_device(struct device *dev,
-				   struct scatterlist *sg, int nelems,
-				   enum dma_data_direction direction);
-
-#endif /* _ASM_SPARC_DMA_MAPPING_H */
diff -puN arch/sparc/include/asm/dma-mapping_64.h~sparc-remove-dma-mapping_3264h /dev/null
--- a/arch/sparc/include/asm/dma-mapping_64.h
+++ /dev/null
@@ -1,121 +0,0 @@
-#ifndef _ASM_SPARC64_DMA_MAPPING_H
-#define _ASM_SPARC64_DMA_MAPPING_H
-
-#include <linux/scatterlist.h>
-#include <linux/mm.h>
-
-struct dma_ops {
-	void *(*alloc_coherent)(struct device *dev, size_t size,
-				dma_addr_t *dma_handle, gfp_t flag);
-	void (*free_coherent)(struct device *dev, size_t size,
-			      void *cpu_addr, dma_addr_t dma_handle);
-	dma_addr_t (*map_page)(struct device *dev, struct page *page,
-			       unsigned long offset, size_t size,
-			       enum dma_data_direction direction);
-	void (*unmap_page)(struct device *dev, dma_addr_t dma_addr,
-			   size_t size,
-			   enum dma_data_direction direction);
-	int (*map_sg)(struct device *dev, struct scatterlist *sg, int nents,
-		      enum dma_data_direction direction);
-	void (*unmap_sg)(struct device *dev, struct scatterlist *sg,
-			 int nhwentries,
-			 enum dma_data_direction direction);
-	void (*sync_single_for_cpu)(struct device *dev,
-				    dma_addr_t dma_handle, size_t size,
-				    enum dma_data_direction direction);
-	void (*sync_single_for_device)(struct device *dev,
-				       dma_addr_t dma_handle, size_t size,
-				       enum dma_data_direction direction);
-	void (*sync_sg_for_cpu)(struct device *dev, struct scatterlist *sg,
-				int nelems,
-				enum dma_data_direction direction);
-	void (*sync_sg_for_device)(struct device *dev,
-				   struct scatterlist *sg, int nents,
-				   enum dma_data_direction dir);
-};
-extern const struct dma_ops *dma_ops;
-
-static inline void *dma_alloc_coherent(struct device *dev, size_t size,
-				       dma_addr_t *dma_handle, gfp_t flag)
-{
-	return dma_ops->alloc_coherent(dev, size, dma_handle, flag);
-}
-
-static inline void dma_free_coherent(struct device *dev, size_t size,
-				     void *cpu_addr, dma_addr_t dma_handle)
-{
-	dma_ops->free_coherent(dev, size, cpu_addr, dma_handle);
-}
-
-static inline dma_addr_t dma_map_single(struct device *dev, void *cpu_addr,
-					size_t size,
-					enum dma_data_direction direction)
-{
-	return dma_ops->map_page(dev, virt_to_page(cpu_addr),
-				 (unsigned long)cpu_addr & ~PAGE_MASK, size,
-				 direction);
-}
-
-static inline void dma_unmap_single(struct device *dev, dma_addr_t dma_addr,
-				    size_t size,
-				    enum dma_data_direction direction)
-{
-	dma_ops->unmap_page(dev, dma_addr, size, direction);
-}
-
-static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
-				      unsigned long offset, size_t size,
-				      enum dma_data_direction direction)
-{
-	return dma_ops->map_page(dev, page, offset, size, direction);
-}
-
-static inline void dma_unmap_page(struct device *dev, dma_addr_t dma_address,
-				  size_t size,
-				  enum dma_data_direction direction)
-{
-	dma_ops->unmap_page(dev, dma_address, size, direction);
-}
-
-static inline int dma_map_sg(struct device *dev, struct scatterlist *sg,
-			     int nents, enum dma_data_direction direction)
-{
-	return dma_ops->map_sg(dev, sg, nents, direction);
-}
-
-static inline void dma_unmap_sg(struct device *dev, struct scatterlist *sg,
-				int nents, enum dma_data_direction direction)
-{
-	dma_ops->unmap_sg(dev, sg, nents, direction);
-}
-
-static inline void dma_sync_single_for_cpu(struct device *dev,
-					   dma_addr_t dma_handle, size_t size,
-					   enum dma_data_direction direction)
-{
-	dma_ops->sync_single_for_cpu(dev, dma_handle, size, direction);
-}
-
-static inline void dma_sync_single_for_device(struct device *dev,
-					      dma_addr_t dma_handle,
-					      size_t size,
-					      enum dma_data_direction direction)
-{
-	/* No flushing needed to sync cpu writes to the device.  */
-}
-
-static inline void dma_sync_sg_for_cpu(struct device *dev,
-				       struct scatterlist *sg, int nelems,
-				       enum dma_data_direction direction)
-{
-	dma_ops->sync_sg_for_cpu(dev, sg, nelems, direction);
-}
-
-static inline void dma_sync_sg_for_device(struct device *dev,
-					  struct scatterlist *sg, int nelems,
-					  enum dma_data_direction direction)
-{
-	/* No flushing needed to sync cpu writes to the device.  */
-}
-
-#endif /* _ASM_SPARC64_DMA_MAPPING_H */
diff -puN arch/sparc/kernel/dma.c~sparc-remove-dma-mapping_3264h arch/sparc/kernel/dma.c
--- a/arch/sparc/kernel/dma.c~sparc-remove-dma-mapping_3264h
+++ a/arch/sparc/kernel/dma.c
@@ -35,8 +35,8 @@ int dma_set_mask(struct device *dev, u64
 }
 EXPORT_SYMBOL(dma_set_mask);
 
-void *dma_alloc_coherent(struct device *dev, size_t size,
-			 dma_addr_t *dma_handle, gfp_t flag)
+static void *dma32_alloc_coherent(struct device *dev, size_t size,
+				  dma_addr_t *dma_handle, gfp_t flag)
 {
 #ifdef CONFIG_PCI
 	if (dev->bus == &pci_bus_type)
@@ -44,10 +44,9 @@ void *dma_alloc_coherent(struct device *
 #endif
 	return sbus_alloc_consistent(dev, size, dma_handle);
 }
-EXPORT_SYMBOL(dma_alloc_coherent);
 
-void dma_free_coherent(struct device *dev, size_t size,
-		       void *cpu_addr, dma_addr_t dma_handle)
+static void dma32_free_coherent(struct device *dev, size_t size,
+				void *cpu_addr, dma_addr_t dma_handle)
 {
 #ifdef CONFIG_PCI
 	if (dev->bus == &pci_bus_type) {
@@ -58,38 +57,10 @@ void dma_free_coherent(struct device *de
 #endif
 	sbus_free_consistent(dev, size, cpu_addr, dma_handle);
 }
-EXPORT_SYMBOL(dma_free_coherent);
 
-dma_addr_t dma_map_single(struct device *dev, void *cpu_addr,
-			  size_t size, enum dma_data_direction direction)
-{
-#ifdef CONFIG_PCI
-	if (dev->bus == &pci_bus_type)
-		return pci_map_single(to_pci_dev(dev), cpu_addr,
-				      size, (int)direction);
-#endif
-	return sbus_map_single(dev, cpu_addr, size, (int)direction);
-}
-EXPORT_SYMBOL(dma_map_single);
-
-void dma_unmap_single(struct device *dev, dma_addr_t dma_addr,
-		      size_t size,
-		      enum dma_data_direction direction)
-{
-#ifdef CONFIG_PCI
-	if (dev->bus == &pci_bus_type) {
-		pci_unmap_single(to_pci_dev(dev), dma_addr,
-				 size, (int)direction);
-		return;
-	}
-#endif
-	sbus_unmap_single(dev, dma_addr, size, (int)direction);
-}
-EXPORT_SYMBOL(dma_unmap_single);
-
-dma_addr_t dma_map_page(struct device *dev, struct page *page,
-			unsigned long offset, size_t size,
-			enum dma_data_direction direction)
+static dma_addr_t dma32_map_page(struct device *dev, struct page *page,
+				 unsigned long offset, size_t size,
+				 enum dma_data_direction direction)
 {
 #ifdef CONFIG_PCI
 	if (dev->bus == &pci_bus_type)
@@ -99,10 +70,9 @@ dma_addr_t dma_map_page(struct device *d
 	return sbus_map_single(dev, page_address(page) + offset,
 			       size, (int)direction);
 }
-EXPORT_SYMBOL(dma_map_page);
 
-void dma_unmap_page(struct device *dev, dma_addr_t dma_address,
-		    size_t size, enum dma_data_direction direction)
+static void dma32_unmap_page(struct device *dev, dma_addr_t dma_address,
+			     size_t size, enum dma_data_direction direction)
 {
 #ifdef CONFIG_PCI
 	if (dev->bus == &pci_bus_type) {
@@ -113,10 +83,9 @@ void dma_unmap_page(struct device *dev, 
 #endif
 	sbus_unmap_single(dev, dma_address, size, (int)direction);
 }
-EXPORT_SYMBOL(dma_unmap_page);
 
-int dma_map_sg(struct device *dev, struct scatterlist *sg,
-			     int nents, enum dma_data_direction direction)
+static int dma32_map_sg(struct device *dev, struct scatterlist *sg,
+			int nents, enum dma_data_direction direction)
 {
 #ifdef CONFIG_PCI
 	if (dev->bus == &pci_bus_type)
@@ -124,10 +93,9 @@ int dma_map_sg(struct device *dev, struc
 #endif
 	return sbus_map_sg(dev, sg, nents, direction);
 }
-EXPORT_SYMBOL(dma_map_sg);
 
-void dma_unmap_sg(struct device *dev, struct scatterlist *sg,
-		  int nents, enum dma_data_direction direction)
+void dma32_unmap_sg(struct device *dev, struct scatterlist *sg,
+		    int nents, enum dma_data_direction direction)
 {
 #ifdef CONFIG_PCI
 	if (dev->bus == &pci_bus_type) {
@@ -137,10 +105,10 @@ void dma_unmap_sg(struct device *dev, st
 #endif
 	sbus_unmap_sg(dev, sg, nents, (int)direction);
 }
-EXPORT_SYMBOL(dma_unmap_sg);
 
-void dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
-			     size_t size, enum dma_data_direction direction)
+static void dma32_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
+				      size_t size,
+				      enum dma_data_direction direction)
 {
 #ifdef CONFIG_PCI
 	if (dev->bus == &pci_bus_type) {
@@ -151,10 +119,10 @@ void dma_sync_single_for_cpu(struct devi
 #endif
 	sbus_dma_sync_single_for_cpu(dev, dma_handle, size, (int) direction);
 }
-EXPORT_SYMBOL(dma_sync_single_for_cpu);
 
-void dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle,
-				size_t size, enum dma_data_direction direction)
+static void dma32_sync_single_for_device(struct device *dev,
+					 dma_addr_t dma_handle, size_t size,
+					 enum dma_data_direction direction)
 {
 #ifdef CONFIG_PCI
 	if (dev->bus == &pci_bus_type) {
@@ -165,10 +133,9 @@ void dma_sync_single_for_device(struct d
 #endif
 	sbus_dma_sync_single_for_device(dev, dma_handle, size, (int) direction);
 }
-EXPORT_SYMBOL(dma_sync_single_for_device);
 
-void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
-			 int nelems, enum dma_data_direction direction)
+static void dma32_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
+				  int nelems, enum dma_data_direction direction)
 {
 #ifdef CONFIG_PCI
 	if (dev->bus == &pci_bus_type) {
@@ -179,11 +146,10 @@ void dma_sync_sg_for_cpu(struct device *
 #endif
 	BUG();
 }
-EXPORT_SYMBOL(dma_sync_sg_for_cpu);
 
-void dma_sync_sg_for_device(struct device *dev,
-			    struct scatterlist *sg, int nelems,
-			    enum dma_data_direction direction)
+static void dma32_sync_sg_for_device(struct device *dev,
+				     struct scatterlist *sg, int nelems,
+				     enum dma_data_direction direction)
 {
 #ifdef CONFIG_PCI
 	if (dev->bus == &pci_bus_type) {
@@ -194,4 +160,19 @@ void dma_sync_sg_for_device(struct devic
 #endif
 	BUG();
 }
-EXPORT_SYMBOL(dma_sync_sg_for_device);
+
+static const struct dma_ops dma32_dma_ops = {
+	.alloc_coherent		= dma32_alloc_coherent,
+	.free_coherent		= dma32_free_coherent,
+	.map_page		= dma32_map_page,
+	.unmap_page		= dma32_unmap_page,
+	.map_sg			= dma32_map_sg,
+	.unmap_sg		= dma32_unmap_sg,
+	.sync_single_for_cpu	= dma32_sync_single_for_cpu,
+	.sync_single_for_device	= dma32_sync_single_for_device,
+	.sync_sg_for_cpu	= dma32_sync_sg_for_cpu,
+	.sync_sg_for_device	= dma32_sync_sg_for_device,
+};
+
+const struct dma_ops *dma_ops = &dma32_dma_ops;
+EXPORT_SYMBOL(dma_ops);
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

origin.patch
linux-next.patch
ib-mthca-replace-dma_sync_single-with-dma_sync_single_for_cpu.patch
dma-mapping-mark-dma_nbits_mask-as-deprecated.patch
dma-mapping-mark-dma_sync_single-and-dma_sync_sg-as-deprecated.patch
dma-mapping-add-asm-generic-dma-mapping-commonh.patch
dma-mapping-x86-use-asm-generic-dma-mapping-commonh.patch
dma-mapping-ia64-use-asm-generic-dma-mapping-commonh.patch
dma-mapping-ia64-add-config_dma_api_debug-support.patch
dma-mapping-dma-debug-fix-compiler-warnings-on-ia64.patch

