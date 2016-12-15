From: akpm@linux-foundation.org
Subject: [merged] arch-avr32-add-option-to-skip-sync-on-dma-map.patch
 removed from -mm tree
Date: Thu, 15 Dec 2016 10:45:24 -0800
Message-ID: <5852e4c4.EPN0k+QfjA/vwYMi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48430 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754135AbcLOSpZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:45:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.h.duyck@intel.com, egtvedt@samfundet.no, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/avr32: add option to skip sync on DMA map
has been removed from the -mm tree.  Its filename was
     arch-avr32-add-option-to-skip-sync-on-dma-map.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: arch/avr32: add option to skip sync on DMA map

The use of DMA_ATTR_SKIP_CPU_SYNC was not consistent across all of the DMA
APIs in the arch/arm folder.  This change is meant to correct that so that
we get consistent behavior.

Link: http://lkml.kernel.org/r/20161110113430.76501.79737.stgit@ahduyck-blue-test.jf.intel.com
Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Acked-by: Hans-Christian Noren Egtvedt <egtvedt@samfundet.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/mm/dma-coherent.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN arch/avr32/mm/dma-coherent.c~arch-avr32-add-option-to-skip-sync-on-dma-map arch/avr32/mm/dma-coherent.c
--- a/arch/avr32/mm/dma-coherent.c~arch-avr32-add-option-to-skip-sync-on-dma-map
+++ a/arch/avr32/mm/dma-coherent.c
@@ -146,7 +146,8 @@ static dma_addr_t avr32_dma_map_page(str
 {
 	void *cpu_addr = page_address(page) + offset;
 
-	dma_cache_sync(dev, cpu_addr, size, direction);
+	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC))
+		dma_cache_sync(dev, cpu_addr, size, direction);
 	return virt_to_bus(cpu_addr);
 }
 
@@ -162,6 +163,10 @@ static int avr32_dma_map_sg(struct devic
 
 		sg->dma_address = page_to_bus(sg_page(sg)) + sg->offset;
 		virt = sg_virt(sg);
+
+		if (attrs & DMA_ATTR_SKIP_CPU_SYNC)
+			continue;
+
 		dma_cache_sync(dev, virt, sg->length, direction);
 	}
 
_

Patches currently in -mm which might be from alexander.h.duyck@intel.com are


