From: akpm@linux-foundation.org
Subject: + dma-mapping-x86-use-asm-generic-dma-mapping-commonh.patch added to -mm tree
Date: Thu, 28 May 2009 00:20:38 -0700
Message-ID: <200905280720.n4S7KcEx008389@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50699 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757231AbZE1HVJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 May 2009 03:21:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, arnd@arndb.de, davem@davemloft.net, joerg.roedel@amd.com, mingo@elte.hu, tony.luck@intel.com


The patch titled
     dma-mapping: x86: use asm-generic/dma-mapping-common.h
has been added to the -mm tree.  Its filename is
     dma-mapping-x86-use-asm-generic-dma-mapping-commonh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dma-mapping: x86: use asm-generic/dma-mapping-common.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc; "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig                   |    1 
 arch/x86/include/asm/dma-mapping.h |  167 ---------------------------
 2 files changed, 3 insertions(+), 165 deletions(-)

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
@@ -32,6 +32,8 @@ static inline struct dma_map_ops *get_dm
 #endif
 }
 
+#include <asm-generic/dma-mapping-common.h>
+
 /* Make sure we keep the same behaviour */
 static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
@@ -52,171 +54,6 @@ extern int dma_set_mask(struct device *d
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
-
-	BUG_ON(!valid_dma_direction(dir));
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
