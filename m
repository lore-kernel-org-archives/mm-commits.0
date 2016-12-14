From: akpm@linux-foundation.org
Subject: [patch 012/114] arch/avr32: add option to skip sync on DMA map
Date: Wed, 14 Dec 2016 15:04:35 -0800
Message-ID: <5851d003.xwGOyBg1ZwhZ/Ymj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34372 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754687AbcLNXEm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 18:04:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, alexander.h.duyck@intel.com, egtvedt@samfundet.no

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
