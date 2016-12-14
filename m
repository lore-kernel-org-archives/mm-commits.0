From: akpm@linux-foundation.org
Subject: [patch 027/114] arch/tile: add option to skip DMA sync as a part
 of map and unmap
Date: Wed, 14 Dec 2016 15:05:18 -0800
Message-ID: <5851d02e.qYCLUKpu27o356Gd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34498 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933483AbcLNXF1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 18:05:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, alexander.h.duyck@intel.com, cmetcalf@mellanox.com

From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: arch/tile: add option to skip DMA sync as a part of map and unmap

This change allows us to pass DMA_ATTR_SKIP_CPU_SYNC which allows us to
avoid invoking cache line invalidation if the driver will just handle it
via a sync_for_cpu or sync_for_device call.

Link: http://lkml.kernel.org/r/20161110113550.76501.73060.stgit@ahduyck-blue-test.jf.intel.com
Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: Chris Metcalf <cmetcalf@mellanox.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/kernel/pci-dma.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN arch/tile/kernel/pci-dma.c~arch-tile-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap arch/tile/kernel/pci-dma.c
--- a/arch/tile/kernel/pci-dma.c~arch-tile-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap
+++ a/arch/tile/kernel/pci-dma.c
@@ -213,10 +213,12 @@ static int tile_dma_map_sg(struct device
 
 	for_each_sg(sglist, sg, nents, i) {
 		sg->dma_address = sg_phys(sg);
-		__dma_prep_pa_range(sg->dma_address, sg->length, direction);
 #ifdef CONFIG_NEED_SG_DMA_LENGTH
 		sg->dma_length = sg->length;
 #endif
+		if (attrs & DMA_ATTR_SKIP_CPU_SYNC)
+			continue;
+		__dma_prep_pa_range(sg->dma_address, sg->length, direction);
 	}
 
 	return nents;
@@ -232,6 +234,8 @@ static void tile_dma_unmap_sg(struct dev
 	BUG_ON(!valid_dma_direction(direction));
 	for_each_sg(sglist, sg, nents, i) {
 		sg->dma_address = sg_phys(sg);
+		if (attrs & DMA_ATTR_SKIP_CPU_SYNC)
+			continue;
 		__dma_complete_pa_range(sg->dma_address, sg->length,
 					direction);
 	}
@@ -245,7 +249,8 @@ static dma_addr_t tile_dma_map_page(stru
 	BUG_ON(!valid_dma_direction(direction));
 
 	BUG_ON(offset + size > PAGE_SIZE);
-	__dma_prep_page(page, offset, size, direction);
+	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC))
+		__dma_prep_page(page, offset, size, direction);
 
 	return page_to_pa(page) + offset;
 }
@@ -256,6 +261,9 @@ static void tile_dma_unmap_page(struct d
 {
 	BUG_ON(!valid_dma_direction(direction));
 
+	if (attrs & DMA_ATTR_SKIP_CPU_SYNC)
+		return;
+
 	__dma_complete_page(pfn_to_page(PFN_DOWN(dma_address)),
 			    dma_address & (PAGE_SIZE - 1), size, direction);
 }
_
