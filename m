From: akpm@linux-foundation.org
Subject: [merged] arch-blackfin-add-option-to-skip-sync-on-dma-map.patch
 removed from -mm tree
Date: Thu, 15 Dec 2016 10:45:26 -0800
Message-ID: <5852e4c6.6xmaT2PIeij0OFRz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48436 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754157AbcLOSp1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:45:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.h.duyck@intel.com, realmz6@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/blackfin: add option to skip sync on DMA map
has been removed from the -mm tree.  Its filename was
     arch-blackfin-add-option-to-skip-sync-on-dma-map.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: arch/blackfin: add option to skip sync on DMA map

The use of DMA_ATTR_SKIP_CPU_SYNC was not consistent across all of the DMA
APIs in the arch/arm folder.  This change is meant to correct that so that
we get consistent behavior.

Link: http://lkml.kernel.org/r/20161110113436.76501.13386.stgit@ahduyck-blue-test.jf.intel.com
Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: Steven Miao <realmz6@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/kernel/dma-mapping.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN arch/blackfin/kernel/dma-mapping.c~arch-blackfin-add-option-to-skip-sync-on-dma-map arch/blackfin/kernel/dma-mapping.c
--- a/arch/blackfin/kernel/dma-mapping.c~arch-blackfin-add-option-to-skip-sync-on-dma-map
+++ a/arch/blackfin/kernel/dma-mapping.c
@@ -118,6 +118,10 @@ static int bfin_dma_map_sg(struct device
 
 	for_each_sg(sg_list, sg, nents, i) {
 		sg->dma_address = (dma_addr_t) sg_virt(sg);
+
+		if (attrs & DMA_ATTR_SKIP_CPU_SYNC)
+			continue;
+
 		__dma_sync(sg_dma_address(sg), sg_dma_len(sg), direction);
 	}
 
@@ -143,7 +147,9 @@ static dma_addr_t bfin_dma_map_page(stru
 {
 	dma_addr_t handle = (dma_addr_t)(page_address(page) + offset);
 
-	_dma_sync(handle, size, dir);
+	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC))
+		_dma_sync(handle, size, dir);
+
 	return handle;
 }
 
_

Patches currently in -mm which might be from alexander.h.duyck@intel.com are


