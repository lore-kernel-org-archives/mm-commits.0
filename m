From: akpm@linux-foundation.org
Subject: [merged]
 arch-hexagon-add-option-to-skip-dma-sync-as-a-part-of-mapping.patch removed from -mm tree
Date: Thu, 15 Dec 2016 10:45:32 -0800
Message-ID: <5852e4cc.A4YgXiD+ScqmqF8H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48454 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754157AbcLOSpd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:45:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.h.duyck@intel.com, rkuo@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/hexagon: Add option to skip DMA sync as a part of mapping
has been removed from the -mm tree.  Its filename was
     arch-hexagon-add-option-to-skip-dma-sync-as-a-part-of-mapping.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: arch/hexagon: Add option to skip DMA sync as a part of mapping

This change allows us to pass DMA_ATTR_SKIP_CPU_SYNC which allows us to
avoid invoking cache line invalidation if the driver will just handle it
later via a sync_for_cpu or sync_for_device call.

Link: http://lkml.kernel.org/r/20161110113452.76501.45864.stgit@ahduyck-blue-test.jf.intel.com
Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: Richard Kuo <rkuo@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/kernel/dma.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN arch/hexagon/kernel/dma.c~arch-hexagon-add-option-to-skip-dma-sync-as-a-part-of-mapping arch/hexagon/kernel/dma.c
--- a/arch/hexagon/kernel/dma.c~arch-hexagon-add-option-to-skip-dma-sync-as-a-part-of-mapping
+++ a/arch/hexagon/kernel/dma.c
@@ -119,6 +119,9 @@ static int hexagon_map_sg(struct device
 
 		s->dma_length = s->length;
 
+		if (attrs & DMA_ATTR_SKIP_CPU_SYNC)
+			continue;
+
 		flush_dcache_range(dma_addr_to_virt(s->dma_address),
 				   dma_addr_to_virt(s->dma_address + s->length));
 	}
@@ -180,7 +183,8 @@ static dma_addr_t hexagon_map_page(struc
 	if (!check_addr("map_single", dev, bus, size))
 		return bad_dma_address;
 
-	dma_sync(dma_addr_to_virt(bus), size, dir);
+	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC))
+		dma_sync(dma_addr_to_virt(bus), size, dir);
 
 	return bus;
 }
_

Patches currently in -mm which might be from alexander.h.duyck@intel.com are


