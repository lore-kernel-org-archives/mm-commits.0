From: akpm@linux-foundation.org
Subject: [patch 018/114] arch/metag: add option to skip DMA sync as a part of map and unmap
Date: Wed, 14 Dec 2016 15:04:52 -0800
Message-ID: <5851d014.tX5e/WLKkIt0zYSm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34402 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754639AbcLNXF0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 18:05:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, alexander.h.duyck@intel.com, james.hogan@imgtec.com

From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: arch/metag: add option to skip DMA sync as a part of map and unmap

This change allows us to pass DMA_ATTR_SKIP_CPU_SYNC which allows us to
avoid invoking cache line invalidation if the driver will just handle it
via a sync_for_cpu or sync_for_device call.

Link: http://lkml.kernel.org/r/20161110113503.76501.80809.stgit@ahduyck-blue-test.jf.intel.com
Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: James Hogan <james.hogan@imgtec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/metag/kernel/dma.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff -puN arch/metag/kernel/dma.c~arch-metag-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap arch/metag/kernel/dma.c
--- a/arch/metag/kernel/dma.c~arch-metag-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap
+++ a/arch/metag/kernel/dma.c
@@ -484,8 +484,9 @@ static dma_addr_t metag_dma_map_page(str
 		unsigned long offset, size_t size,
 		enum dma_data_direction direction, unsigned long attrs)
 {
-	dma_sync_for_device((void *)(page_to_phys(page) + offset), size,
-			    direction);
+	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC))
+		dma_sync_for_device((void *)(page_to_phys(page) + offset),
+				    size, direction);
 	return page_to_phys(page) + offset;
 }
 
@@ -493,7 +494,8 @@ static void metag_dma_unmap_page(struct
 		size_t size, enum dma_data_direction direction,
 		unsigned long attrs)
 {
-	dma_sync_for_cpu(phys_to_virt(dma_address), size, direction);
+	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC))
+		dma_sync_for_cpu(phys_to_virt(dma_address), size, direction);
 }
 
 static int metag_dma_map_sg(struct device *dev, struct scatterlist *sglist,
@@ -507,6 +509,10 @@ static int metag_dma_map_sg(struct devic
 		BUG_ON(!sg_page(sg));
 
 		sg->dma_address = sg_phys(sg);
+
+		if (attrs & DMA_ATTR_SKIP_CPU_SYNC)
+			continue;
+
 		dma_sync_for_device(sg_virt(sg), sg->length, direction);
 	}
 
@@ -525,6 +531,10 @@ static void metag_dma_unmap_sg(struct de
 		BUG_ON(!sg_page(sg));
 
 		sg->dma_address = sg_phys(sg);
+
+		if (attrs & DMA_ATTR_SKIP_CPU_SYNC)
+			continue;
+
 		dma_sync_for_cpu(sg_virt(sg), sg->length, direction);
 	}
 }
_
