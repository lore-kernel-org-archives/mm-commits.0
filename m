From: akpm@linux-foundation.org
Subject: [patch 025/114] arch/sh: add option to skip DMA sync as a part of mapping
Date: Wed, 14 Dec 2016 15:05:12 -0800
Message-ID: <5851d028.qDpil/Z3XSUu0xu0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34496 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933454AbcLNXF1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 18:05:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, alexander.h.duyck@intel.com, dalias@libc.org, ysato@users.sourceforge.jp

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
