From: akpm@linux-foundation.org
Subject: + dma-mapping-ia64-use-asm-generic-dma-mapping-commonh.patch added to -mm tree
Date: Thu, 28 May 2009 00:20:40 -0700
Message-ID: <200905280720.n4S7KedH008392@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54310 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756153AbZE1HUz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 May 2009 03:20:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, arnd@arndb.de, davem@davemloft.net, joerg.roedel@amd.com, mingo@elte.hu, tony.luck@intel.com


The patch titled
     dma-mapping: ia64: use asm-generic/dma-mapping-common.h
has been added to the -mm tree.  Its filename is
     dma-mapping-ia64-use-asm-generic-dma-mapping-commonh.patch

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
Subject: dma-mapping: ia64: use asm-generic/dma-mapping-common.h
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

 arch/ia64/include/asm/dma-mapping.h |  102 --------------------------
 1 file changed, 3 insertions(+), 99 deletions(-)

diff -puN arch/ia64/include/asm/dma-mapping.h~dma-mapping-ia64-use-asm-generic-dma-mapping-commonh arch/ia64/include/asm/dma-mapping.h
--- a/arch/ia64/include/asm/dma-mapping.h~dma-mapping-ia64-use-asm-generic-dma-mapping-commonh
+++ a/arch/ia64/include/asm/dma-mapping.h
@@ -37,82 +37,10 @@ static inline void dma_free_coherent(str
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
 
-static inline dma_addr_t dma_map_single_attrs(struct device *dev,
-					      void *caddr, size_t size,
-					      enum dma_data_direction dir,
-					      struct dma_attrs *attrs)
-{
-	struct dma_map_ops *ops = platform_dma_get_ops(dev);
-	return ops->map_page(dev, virt_to_page(caddr),
-			     (unsigned long)caddr & ~PAGE_MASK, size,
-			     dir, attrs);
-}
-
-static inline void dma_unmap_single_attrs(struct device *dev, dma_addr_t daddr,
-					  size_t size,
-					  enum dma_data_direction dir,
-					  struct dma_attrs *attrs)
-{
-	struct dma_map_ops *ops = platform_dma_get_ops(dev);
-	ops->unmap_page(dev, daddr, size, dir, attrs);
-}
-
-#define dma_map_single(d, a, s, r) dma_map_single_attrs(d, a, s, r, NULL)
-#define dma_unmap_single(d, a, s, r) dma_unmap_single_attrs(d, a, s, r, NULL)
-
-static inline int dma_map_sg_attrs(struct device *dev, struct scatterlist *sgl,
-				   int nents, enum dma_data_direction dir,
-				   struct dma_attrs *attrs)
-{
-	struct dma_map_ops *ops = platform_dma_get_ops(dev);
-	return ops->map_sg(dev, sgl, nents, dir, attrs);
-}
-
-static inline void dma_unmap_sg_attrs(struct device *dev,
-				      struct scatterlist *sgl, int nents,
-				      enum dma_data_direction dir,
-				      struct dma_attrs *attrs)
-{
-	struct dma_map_ops *ops = platform_dma_get_ops(dev);
-	ops->unmap_sg(dev, sgl, nents, dir, attrs);
-}
-
-#define dma_map_sg(d, s, n, r) dma_map_sg_attrs(d, s, n, r, NULL)
-#define dma_unmap_sg(d, s, n, r) dma_unmap_sg_attrs(d, s, n, r, NULL)
-
-static inline void dma_sync_single_for_cpu(struct device *dev, dma_addr_t daddr,
-					   size_t size,
-					   enum dma_data_direction dir)
-{
-	struct dma_map_ops *ops = platform_dma_get_ops(dev);
-	ops->sync_single_for_cpu(dev, daddr, size, dir);
-}
-
-static inline void dma_sync_sg_for_cpu(struct device *dev,
-				       struct scatterlist *sgl,
-				       int nents, enum dma_data_direction dir)
-{
-	struct dma_map_ops *ops = platform_dma_get_ops(dev);
-	ops->sync_sg_for_cpu(dev, sgl, nents, dir);
-}
+#define get_dma_ops(dev) platform_dma_get_ops(dev)
+#define flush_write_buffers()
 
-static inline void dma_sync_single_for_device(struct device *dev,
-					      dma_addr_t daddr,
-					      size_t size,
-					      enum dma_data_direction dir)
-{
-	struct dma_map_ops *ops = platform_dma_get_ops(dev);
-	ops->sync_single_for_device(dev, daddr, size, dir);
-}
-
-static inline void dma_sync_sg_for_device(struct device *dev,
-					  struct scatterlist *sgl,
-					  int nents,
-					  enum dma_data_direction dir)
-{
-	struct dma_map_ops *ops = platform_dma_get_ops(dev);
-	ops->sync_sg_for_device(dev, sgl, nents, dir);
-}
+#include <asm-generic/dma-mapping-common.h>
 
 static inline int dma_mapping_error(struct device *dev, dma_addr_t daddr)
 {
@@ -120,30 +48,6 @@ static inline int dma_mapping_error(stru
 	return ops->mapping_error(dev, daddr);
 }
 
-static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
-				      size_t offset, size_t size,
-				      enum dma_data_direction dir)
-{
-	struct dma_map_ops *ops = platform_dma_get_ops(dev);
-	return ops->map_page(dev, page, offset, size, dir, NULL);
-}
-
-static inline void dma_unmap_page(struct device *dev, dma_addr_t addr,
-				  size_t size, enum dma_data_direction dir)
-{
-	dma_unmap_single(dev, addr, size, dir);
-}
-
-/*
- * Rest of this file is part of the "Advanced DMA API".  Use at your own risk.
- * See Documentation/DMA-API.txt for details.
- */
-
-#define dma_sync_single_range_for_cpu(dev, dma_handle, offset, size, dir)	\
-	dma_sync_single_for_cpu(dev, dma_handle, size, dir)
-#define dma_sync_single_range_for_device(dev, dma_handle, offset, size, dir)	\
-	dma_sync_single_for_device(dev, dma_handle, size, dir)
