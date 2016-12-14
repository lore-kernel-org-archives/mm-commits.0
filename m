From: akpm@linux-foundation.org
Subject: [patch 020/114] arch/mips: add option to skip DMA sync as a part
 of map and unmap
Date: Wed, 14 Dec 2016 15:04:58 -0800
Message-ID: <5851d01a.gfhbVLShd7siRJJM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34420 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754712AbcLNXF0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 18:05:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, alexander.h.duyck@intel.com, keguang.zhang@gmail.com, ralf@linux-mips.org

From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: arch/mips: add option to skip DMA sync as a part of map and unmap

This change allows us to pass DMA_ATTR_SKIP_CPU_SYNC which allows us to
avoid invoking cache line invalidation if the driver will just handle it
via a sync_for_cpu or sync_for_device call.

Link: http://lkml.kernel.org/r/20161110113513.76501.32321.stgit@ahduyck-blue-test.jf.intel.com
Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Keguang Zhang <keguang.zhang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/loongson64/common/dma-swiotlb.c |    2 +-
 arch/mips/mm/dma-default.c                |    8 +++++---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff -puN arch/mips/loongson64/common/dma-swiotlb.c~arch-mips-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap arch/mips/loongson64/common/dma-swiotlb.c
--- a/arch/mips/loongson64/common/dma-swiotlb.c~arch-mips-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap
+++ a/arch/mips/loongson64/common/dma-swiotlb.c
@@ -61,7 +61,7 @@ static int loongson_dma_map_sg(struct de
 				int nents, enum dma_data_direction dir,
 				unsigned long attrs)
 {
-	int r = swiotlb_map_sg_attrs(dev, sg, nents, dir, 0);
+	int r = swiotlb_map_sg_attrs(dev, sg, nents, dir, attrs);
 	mb();
 
 	return r;
diff -puN arch/mips/mm/dma-default.c~arch-mips-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap arch/mips/mm/dma-default.c
--- a/arch/mips/mm/dma-default.c~arch-mips-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap
+++ a/arch/mips/mm/dma-default.c
@@ -293,7 +293,7 @@ static inline void __dma_sync(struct pag
 static void mips_dma_unmap_page(struct device *dev, dma_addr_t dma_addr,
 	size_t size, enum dma_data_direction direction, unsigned long attrs)
 {
-	if (cpu_needs_post_dma_flush(dev))
+	if (cpu_needs_post_dma_flush(dev) && !(attrs & DMA_ATTR_SKIP_CPU_SYNC))
 		__dma_sync(dma_addr_to_page(dev, dma_addr),
 			   dma_addr & ~PAGE_MASK, size, direction);
 	plat_post_dma_flush(dev);
@@ -307,7 +307,8 @@ static int mips_dma_map_sg(struct device
 	struct scatterlist *sg;
 
 	for_each_sg(sglist, sg, nents, i) {
-		if (!plat_device_is_coherent(dev))
+		if (!plat_device_is_coherent(dev) &&
+		    !(attrs & DMA_ATTR_SKIP_CPU_SYNC))
 			__dma_sync(sg_page(sg), sg->offset, sg->length,
 				   direction);
 #ifdef CONFIG_NEED_SG_DMA_LENGTH
@@ -324,7 +325,7 @@ static dma_addr_t mips_dma_map_page(stru
 	unsigned long offset, size_t size, enum dma_data_direction direction,
 	unsigned long attrs)
 {
-	if (!plat_device_is_coherent(dev))
+	if (!plat_device_is_coherent(dev) && !(attrs & DMA_ATTR_SKIP_CPU_SYNC))
 		__dma_sync(page, offset, size, direction);
 
 	return plat_map_dma_mem_page(dev, page) + offset;
@@ -339,6 +340,7 @@ static void mips_dma_unmap_sg(struct dev
 
 	for_each_sg(sglist, sg, nhwentries, i) {
 		if (!plat_device_is_coherent(dev) &&
+		    !(attrs & DMA_ATTR_SKIP_CPU_SYNC) &&
 		    direction != DMA_TO_DEVICE)
 			__dma_sync(sg_page(sg), sg->offset, sg->length,
 				   direction);
_
