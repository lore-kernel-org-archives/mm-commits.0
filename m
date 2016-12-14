From: akpm@linux-foundation.org
Subject: [patch 013/114] arch/blackfin: add option to skip sync on DMA map
Date: Wed, 14 Dec 2016 15:04:38 -0800
Message-ID: <5851d006.B0HLMiltJ677Q/aR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34378 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754700AbcLNXEm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 18:04:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, alexander.h.duyck@intel.com, realmz6@gmail.com

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
