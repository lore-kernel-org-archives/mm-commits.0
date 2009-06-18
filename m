From: akpm@linux-foundation.org
Subject: [merged] dma-mapping-x86-use-asm-generic-dma-mapping-commonh.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:48:15 -0700
Message-ID: <200906182248.n5IMmFKh007324@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33685 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756107AbZFRWtE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:49:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, arnd@arndb.de, catalin.marinas@arm.com, davem@davemloft.net, joerg.roedel@amd.com, mingo@elte.hu, tony.luck@intel


The patch titled
     dma-mapping: x86: use asm-generic/dma-mapping-common.h
has been removed from the -mm tree.  Its filename was
     dma-mapping-x86-use-asm-generic-dma-mapping-commonh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dma-mapping: x86: use asm-generic/dma-mapping-common.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Joerg Roedel <joerg.roedel@amd.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig                   |    1 
 arch/x86/include/asm/dma-mapping.h |  173 ---------------------------
 2 files changed, 3 insertions(+), 171 deletions(-)

diff -puN arch/x86/Kconfig~dma-mapping-x86-use-asm-generic-dma-mapping-commonh arch/x86/Kconfig
--- a/arch/x86/Kconfig~dma-mapping-x86-use-asm-generic-dma-mapping-commonh
+++ a/arch/x86/Kconfig
@@ -28,6 +28,7 @@ config X86
 	select HAVE_KPROBES
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARCH_WANT_FRAME_POINTERS
+	select HAVE_DMA_ATTRS
 	select HAVE_KRETPROBES
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_DYNAMIC_FTRACE
diff -puN arch/x86/include/asm/dma-mapping.h~dma-mapping-x86-use-asm-generic-dma-mapping-commonh arch/x86/include/asm/dma-mapping.h
--- a/arch/x86/include/asm/dma-mapping.h~dma-mapping-x86-use-asm-generic-dma-mapping-commonh
+++ a/arch/x86/include/asm/dma-mapping.h
@@ -33,6 +33,8 @@ static inline struct dma_map_ops *get_dm
 #endif
 }
 
+#include <asm-generic/dma-mapping-common.h>
+
 /* Make sure we keep the same behaviour */
 static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
@@ -53,177 +55,6 @@ extern int dma_set_mask(struct device *d
 extern void *dma_generic_alloc_coherent(struct device *dev, size_t size,
 					dma_addr_t *dma_addr, gfp_t flag);
 
-static inline dma_addr_t
-dma_map_single(struct device *hwdev, void *ptr, size_t size,
-	       enum dma_data_direction dir)
-{
-	struct dma_map_ops *ops = get_dma_ops(hwdev);
-	dma_addr_t addr;
-
-	BUG_ON(!valid_dma_direction(dir));
-	kmemcheck_mark_initialized(ptr, size);
-	addr = ops->map_page(hwdev, virt_to_page(ptr),
-			     (unsigned long)ptr & ~PAGE_MASK, size,
-			     dir, NULL);
-	debug_dma_map_page(hwdev, virt_to_page(ptr),
-			   (unsigned long)ptr & ~PAGE_MASK, size,
-			   dir, addr, true);
-	return addr;
-}
-
-static inline void
-dma_unmap_single(struct device *dev, dma_addr_t addr, size_t size,
-		 enum dma_data_direction dir)
-{
-	struct dma_map_ops *ops = get_dma_ops(dev);
-
-	BUG_ON(!valid_dma_direction(dir));
-	if (ops->unmap_page)
-		ops->unmap_page(dev, addr, size, dir, NULL);
-	debug_dma_unmap_page(dev, addr, size, dir, true);
-}
-
-static inline int
-dma_map_sg(struct device *hwdev, struct scatterlist *sg,
-	   int nents, enum dma_data_direction dir)
-{
-	struct dma_map_ops *ops = get_dma_ops(hwdev);
-	int ents;
-	struct scatterlist *s;
-	int i;
-
-	BUG_ON(!valid_dma_direction(dir));
-	for_each_sg(sg, s, nents, i)
-		kmemcheck_mark_initialized(sg_virt(s), s->length);
-	ents = ops->map_sg(hwdev, sg, nents, dir, NULL);
-	debug_dma_map_sg(hwdev, sg, nents, ents, dir);
-
-	return ents;
-}
-
-static inline void
-dma_unmap_sg(struct device *hwdev, struct scatterlist *sg, int nents,
-	     enum dma_data_direction dir)
-{
-	struct dma_map_ops *ops = get_dma_ops(hwdev);
-
-	BUG_ON(!valid_dma_direction(dir));
-	debug_dma_unmap_sg(hwdev, sg, nents, dir);
-	if (ops->unmap_sg)
-		ops->unmap_sg(hwdev, sg, nents, dir, NULL);
-}
-
-static inline void
-dma_sync_single_for_cpu(struct device *hwdev, dma_addr_t dma_handle,
-			size_t size, enum dma_data_direction dir)
-{
-	struct dma_map_ops *ops = get_dma_ops(hwdev);
-
-	BUG_ON(!valid_dma_direction(dir));
-	if (ops->sync_single_for_cpu)
-		ops->sync_single_for_cpu(hwdev, dma_handle, size, dir);
-	debug_dma_sync_single_for_cpu(hwdev, dma_handle, size, dir);
-	flush_write_buffers();
-}
-
-static inline void
-dma_sync_single_for_device(struct device *hwdev, dma_addr_t dma_handle,
-			   size_t size, enum dma_data_direction dir)
-{
-	struct dma_map_ops *ops = get_dma_ops(hwdev);
-
-	BUG_ON(!valid_dma_direction(dir));
-	if (ops->sync_single_for_device)
-		ops->sync_single_for_device(hwdev, dma_handle, size, dir);
-	debug_dma_sync_single_for_device(hwdev, dma_handle, size, dir);
-	flush_write_buffers();
-}
-
-static inline void
-dma_sync_single_range_for_cpu(struct device *hwdev, dma_addr_t dma_handle,
-			      unsigned long offset, size_t size,
-			      enum dma_data_direction dir)
-{
-	struct dma_map_ops *ops = get_dma_ops(hwdev);
-
-	BUG_ON(!valid_dma_direction(dir));
-	if (ops->sync_single_range_for_cpu)
-		ops->sync_single_range_for_cpu(hwdev, dma_handle, offset,
-					       size, dir);
-	debug_dma_sync_single_range_for_cpu(hwdev, dma_handle,
-					    offset, size, dir);
-	flush_write_buffers();
-}
-
-static inline void
-dma_sync_single_range_for_device(struct device *hwdev, dma_addr_t dma_handle,
-				 unsigned long offset, size_t size,
-				 enum dma_data_direction dir)
-{
-	struct dma_map_ops *ops = get_dma_ops(hwdev);
-
-	BUG_ON(!valid_dma_direction(dir));
-	if (ops->sync_single_range_for_device)
-		ops->sync_single_range_for_device(hwdev, dma_handle,
-						  offset, size, dir);
-	debug_dma_sync_single_range_for_device(hwdev, dma_handle,
-					       offset, size, dir);
-	flush_write_buffers();
-}
-
-static inline void
-dma_sync_sg_for_cpu(struct device *hwdev, struct scatterlist *sg,
-		    int nelems, enum dma_data_direction dir)
-{
-	struct dma_map_ops *ops = get_dma_ops(hwdev);
-
-	BUG_ON(!valid_dma_direction(dir));
-	if (ops->sync_sg_for_cpu)
-		ops->sync_sg_for_cpu(hwdev, sg, nelems, dir);
-	debug_dma_sync_sg_for_cpu(hwdev, sg, nelems, dir);
-	flush_write_buffers();
-}
-
-static inline void
-dma_sync_sg_for_device(struct device *hwdev, struct scatterlist *sg,
-		       int nelems, enum dma_data_direction dir)
-{
-	struct dma_map_ops *ops = get_dma_ops(hwdev);
-
-	BUG_ON(!valid_dma_direction(dir));
-	if (ops->sync_sg_for_device)
-		ops->sync_sg_for_device(hwdev, sg, nelems, dir);
-	debug_dma_sync_sg_for_device(hwdev, sg, nelems, dir);
-
-	flush_write_buffers();
-}
-
-static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
-				      size_t offset, size_t size,
-				      enum dma_data_direction dir)
-{
-	struct dma_map_ops *ops = get_dma_ops(dev);
-	dma_addr_t addr;
-
-	BUG_ON(!valid_dma_direction(dir));
-	kmemcheck_mark_initialized(page_address(page) + offset, size);
-	addr = ops->map_page(dev, page, offset, size, dir, NULL);
-	debug_dma_map_page(dev, page, offset, size, dir, addr, false);
-
-	return addr;
-}
-
-static inline void dma_unmap_page(struct device *dev, dma_addr_t addr,
-				  size_t size, enum dma_data_direction dir)
-{
-	struct dma_map_ops *ops = get_dma_ops(dev);
-
-	BUG_ON(!valid_dma_direction(dir));
-	if (ops->unmap_page)
-		ops->unmap_page(dev, addr, size, dir, NULL);
-	debug_dma_unmap_page(dev, addr, size, dir, false);
-}
