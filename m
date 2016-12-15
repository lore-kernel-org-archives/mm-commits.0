From: akpm@linux-foundation.org
Subject: [merged]
 arch-m68k-add-option-to-skip-dma-sync-as-a-part-of-mapping.patch removed
 from -mm tree
Date: Thu, 15 Dec 2016 10:45:34 -0800
Message-ID: <5852e4ce.hx/ziW/3yCTlVTj0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48462 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754157AbcLOSpf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:45:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.h.duyck@intel.com, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/m68k: add option to skip DMA sync as a part of mapping
has been removed from the -mm tree.  Its filename was
     arch-m68k-add-option-to-skip-dma-sync-as-a-part-of-mapping.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: arch/m68k: add option to skip DMA sync as a part of mapping

This change allows us to pass DMA_ATTR_SKIP_CPU_SYNC which allows us to
avoid invoking cache line invalidation if the driver will just handle it
later via a sync_for_cpu or sync_for_device call.

Link: http://lkml.kernel.org/r/20161110113457.76501.77603.stgit@ahduyck-blue-test.jf.intel.com
Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/kernel/dma.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN arch/m68k/kernel/dma.c~arch-m68k-add-option-to-skip-dma-sync-as-a-part-of-mapping arch/m68k/kernel/dma.c
--- a/arch/m68k/kernel/dma.c~arch-m68k-add-option-to-skip-dma-sync-as-a-part-of-mapping
+++ a/arch/m68k/kernel/dma.c
@@ -134,7 +134,9 @@ static dma_addr_t m68k_dma_map_page(stru
 {
 	dma_addr_t handle = page_to_phys(page) + offset;
 
-	dma_sync_single_for_device(dev, handle, size, dir);
+	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC))
+		dma_sync_single_for_device(dev, handle, size, dir);
+
 	return handle;
 }
 
@@ -146,6 +148,10 @@ static int m68k_dma_map_sg(struct device
 
 	for_each_sg(sglist, sg, nents, i) {
 		sg->dma_address = sg_phys(sg);
+
+		if (attrs & DMA_ATTR_SKIP_CPU_SYNC)
+			continue;
+
 		dma_sync_single_for_device(dev, sg->dma_address, sg->length,
 					   dir);
 	}
_

Patches currently in -mm which might be from alexander.h.duyck@intel.com are


