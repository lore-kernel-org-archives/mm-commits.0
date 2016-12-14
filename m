From: akpm@linux-foundation.org
Subject: [patch 024/114] arch/powerpc: add option to skip DMA sync as a
 part of mapping
Date: Wed, 14 Dec 2016 15:05:09 -0800
Message-ID: <5851d025.q/c7qXY1EZ9oj3NS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34494 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933408AbcLNXF1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 18:05:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, alexander.h.duyck@intel.com, mpe@ellerman.id.au

From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: arch/powerpc: add option to skip DMA sync as a part of mapping

This change allows us to pass DMA_ATTR_SKIP_CPU_SYNC which allows us to
avoid invoking cache line invalidation if the driver will just handle it
via a sync_for_cpu or sync_for_device call.

Link: http://lkml.kernel.org/r/20161110113534.76501.86492.stgit@ahduyck-blue-test.jf.intel.com
Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/dma.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN arch/powerpc/kernel/dma.c~arch-powerpc-add-option-to-skip-dma-sync-as-a-part-of-mapping arch/powerpc/kernel/dma.c
--- a/arch/powerpc/kernel/dma.c~arch-powerpc-add-option-to-skip-dma-sync-as-a-part-of-mapping
+++ a/arch/powerpc/kernel/dma.c
@@ -203,6 +203,10 @@ static int dma_direct_map_sg(struct devi
 	for_each_sg(sgl, sg, nents, i) {
 		sg->dma_address = sg_phys(sg) + get_dma_offset(dev);
 		sg->dma_length = sg->length;
+
+		if (attrs & DMA_ATTR_SKIP_CPU_SYNC)
+			continue;
+
 		__dma_sync_page(sg_page(sg), sg->offset, sg->length, direction);
 	}
 
@@ -235,7 +239,10 @@ static inline dma_addr_t dma_direct_map_
 					     unsigned long attrs)
 {
 	BUG_ON(dir == DMA_NONE);
-	__dma_sync_page(page, offset, size, dir);
+
+	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC))
+		__dma_sync_page(page, offset, size, dir);
+
 	return page_to_phys(page) + offset + get_dma_offset(dev);
 }
 
_
