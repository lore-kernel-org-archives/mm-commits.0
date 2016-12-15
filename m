From: akpm@linux-foundation.org
Subject: [merged]
 arch-sh-add-option-to-skip-dma-sync-as-a-part-of-mapping.patch removed from -mm tree
Date: Thu, 15 Dec 2016 10:45:50 -0800
Message-ID: <5852e4de.JrdOFLtLMv2WCY9F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48760 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754527AbcLOSqu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:46:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.h.duyck@intel.com, dalias@libc.org, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/sh: add option to skip DMA sync as a part of mapping
has been removed from the -mm tree.  Its filename was
     arch-sh-add-option-to-skip-dma-sync-as-a-part-of-mapping.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: arch/sh: add option to skip DMA sync as a part of mapping

This change allows us to pass DMA_ATTR_SKIP_CPU_SYNC which allows us to
avoid invoking cache line invalidation if the driver will just handle it
via a sync_for_cpu or sync_for_device call.

Link: http://lkml.kernel.org/r/20161110113539.76501.6539.stgit@ahduyck-blue-test.jf.intel.com
Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/kernel/dma-nommu.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN arch/sh/kernel/dma-nommu.c~arch-sh-add-option-to-skip-dma-sync-as-a-part-of-mapping arch/sh/kernel/dma-nommu.c
--- a/arch/sh/kernel/dma-nommu.c~arch-sh-add-option-to-skip-dma-sync-as-a-part-of-mapping
+++ a/arch/sh/kernel/dma-nommu.c
@@ -18,7 +18,9 @@ static dma_addr_t nommu_map_page(struct
 	dma_addr_t addr = page_to_phys(page) + offset;
 
 	WARN_ON(size == 0);
-	dma_cache_sync(dev, page_address(page) + offset, size, dir);
+
+	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC))
+		dma_cache_sync(dev, page_address(page) + offset, size, dir);
 
 	return addr;
 }
@@ -35,7 +37,8 @@ static int nommu_map_sg(struct device *d
 	for_each_sg(sg, s, nents, i) {
 		BUG_ON(!sg_page(s));
 
-		dma_cache_sync(dev, sg_virt(s), s->length, dir);
+		if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC))
+			dma_cache_sync(dev, sg_virt(s), s->length, dir);
 
 		s->dma_address = sg_phys(s);
 		s->dma_length = s->length;
_

Patches currently in -mm which might be from alexander.h.duyck@intel.com are


