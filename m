From: akpm@linux-foundation.org
Subject: [patch 019/114] arch/microblaze: add option to skip DMA sync as a part of map and unmap
Date: Wed, 14 Dec 2016 15:04:55 -0800
Message-ID: <5851d017.I0/Cy0HPBDUb5y6V%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34410 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754707AbcLNXF0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 18:05:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, alexander.h.duyck@intel.com, monstr@monstr.eu

From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: arch/microblaze: add option to skip DMA sync as a part of map and unmap

This change allows us to pass DMA_ATTR_SKIP_CPU_SYNC which allows us to
avoid invoking cache line invalidation if the driver will just handle it
via a sync_for_cpu or sync_for_device call.

Link: http://lkml.kernel.org/r/20161110113508.76501.77583.stgit@ahduyck-blue-test.jf.intel.com
Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: Michal Simek <monstr@monstr.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/kernel/dma.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN arch/microblaze/kernel/dma.c~arch-microblaze-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap arch/microblaze/kernel/dma.c
--- a/arch/microblaze/kernel/dma.c~arch-microblaze-add-option-to-skip-dma-sync-as-a-part-of-map-and-unmap
+++ a/arch/microblaze/kernel/dma.c
@@ -61,6 +61,10 @@ static int dma_direct_map_sg(struct devi
 	/* FIXME this part of code is untested */
 	for_each_sg(sgl, sg, nents, i) {
 		sg->dma_address = sg_phys(sg);
+
+		if (attrs & DMA_ATTR_SKIP_CPU_SYNC)
+			continue;
+
 		__dma_sync(page_to_phys(sg_page(sg)) + sg->offset,
 							sg->length, direction);
 	}
@@ -80,7 +84,8 @@ static inline dma_addr_t dma_direct_map_
 					     enum dma_data_direction direction,
 					     unsigned long attrs)
 {
-	__dma_sync(page_to_phys(page) + offset, size, direction);
+	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC))
+		__dma_sync(page_to_phys(page) + offset, size, direction);
 	return page_to_phys(page) + offset;
 }
 
@@ -95,7 +100,8 @@ static inline void dma_direct_unmap_page
  * phys_to_virt is here because in __dma_sync_page is __virt_to_phys and
  * dma_address is physical address
  */
-	__dma_sync(dma_address, size, direction);
+	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC))
+		__dma_sync(dma_address, size, direction);
 }
 
 static inline void
_
