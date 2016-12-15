From: akpm@linux-foundation.org
Subject: [merged]
 arch-nios2-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap.patch
 removed from -mm tree
Date: Thu, 15 Dec 2016 10:45:42 -0800
Message-ID: <5852e4d6.NZ6USchznuBtWLSu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50572 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754120AbcLOS40 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:56:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.h.duyck@intel.com, lftan@altera.com, tklauser@distanz.ch, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/nios2: add option to skip DMA sync as a part of map and unmap
has been removed from the -mm tree.  Its filename was
     arch-nios2-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: arch/nios2: add option to skip DMA sync as a part of map and unmap

This change allows us to pass DMA_ATTR_SKIP_CPU_SYNC which allows us to
avoid invoking cache line invalidation if the driver will just handle it
via a sync_for_cpu or sync_for_device call.

Link: http://lkml.kernel.org/r/20161110113518.76501.52225.stgit@ahduyck-blue-test.jf.intel.com
Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Reviewed-by: Tobias Klauser <tklauser@distanz.ch>
Cc: Ley Foon Tan <lftan@altera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/nios2/mm/dma-mapping.c |   26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff -puN arch/nios2/mm/dma-mapping.c~arch-nios2-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap arch/nios2/mm/dma-mapping.c
--- a/arch/nios2/mm/dma-mapping.c~arch-nios2-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap
+++ a/arch/nios2/mm/dma-mapping.c
@@ -98,13 +98,17 @@ static int nios2_dma_map_sg(struct devic
 	int i;
 
 	for_each_sg(sg, sg, nents, i) {
-		void *addr;
+		void *addr = sg_virt(sg);
 
-		addr = sg_virt(sg);
-		if (addr) {
-			__dma_sync_for_device(addr, sg->length, direction);
-			sg->dma_address = sg_phys(sg);
-		}
+		if (!addr)
+			continue;
+
+		sg->dma_address = sg_phys(sg);
+
+		if (attrs & DMA_ATTR_SKIP_CPU_SYNC)
+			continue;
+
+		__dma_sync_for_device(addr, sg->length, direction);
 	}
 
 	return nents;
@@ -117,7 +121,9 @@ static dma_addr_t nios2_dma_map_page(str
 {
 	void *addr = page_address(page) + offset;
 
-	__dma_sync_for_device(addr, size, direction);
+	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC))
+		__dma_sync_for_device(addr, size, direction);
+
 	return page_to_phys(page) + offset;
 }
 
@@ -125,7 +131,8 @@ static void nios2_dma_unmap_page(struct
 		size_t size, enum dma_data_direction direction,
 		unsigned long attrs)
 {
-	__dma_sync_for_cpu(phys_to_virt(dma_address), size, direction);
+	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC))
+		__dma_sync_for_cpu(phys_to_virt(dma_address), size, direction);
 }
 
 static void nios2_dma_unmap_sg(struct device *dev, struct scatterlist *sg,
@@ -138,6 +145,9 @@ static void nios2_dma_unmap_sg(struct de
 	if (direction == DMA_TO_DEVICE)
 		return;
 
+	if (attrs & DMA_ATTR_SKIP_CPU_SYNC)
+		return;
+
 	for_each_sg(sg, sg, nhwentries, i) {
 		addr = sg_virt(sg);
 		if (addr)
_

Patches currently in -mm which might be from alexander.h.duyck@intel.com are


