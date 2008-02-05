From: akpm@linux-foundation.org
Subject: - alpha-kill-deprecated-virt_to_bus.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:33:50 -0800
Message-ID: <200802052233.m15MXVxl012433@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58384 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932315AbYBEWnS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:43:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tomof@acm.org, fujita.tomonori@lab.ntt.co.jp, ink@jurassic.park.msu.ru, jens.axboe@oracle.com, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha: kill deprecated virt_to_bus
has been removed from the -mm tree.  Its filename was
     alpha-kill-deprecated-virt_to_bus.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha: kill deprecated virt_to_bus
From: FUJITA Tomonori <tomof@acm.org>

pci-noop.c doesn't use DMA mappings.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/pci-noop.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/alpha/kernel/pci-noop.c~alpha-kill-deprecated-virt_to_bus arch/alpha/kernel/pci-noop.c
--- a/arch/alpha/kernel/pci-noop.c~alpha-kill-deprecated-virt_to_bus
+++ a/arch/alpha/kernel/pci-noop.c
@@ -165,7 +165,7 @@ dma_alloc_coherent(struct device *dev, s
 	ret = (void *)__get_free_pages(gfp, get_order(size));
 	if (ret) {
 		memset(ret, 0, size);
-		*dma_handle = virt_to_bus(ret);
+		*dma_handle = virt_to_phys(ret);
 	}
 	return ret;
 }
@@ -184,7 +184,7 @@ dma_map_sg(struct device *dev, struct sc
 
 		BUG_ON(!sg_page(sg));
 		va = sg_virt(sg);
-		sg_dma_address(sg) = (dma_addr_t)virt_to_bus(va);
+		sg_dma_address(sg) = (dma_addr_t)virt_to_phys(va);
 		sg_dma_len(sg) = sg->length;
 	}
 
_

Patches currently in -mm which might be from tomof@acm.org are

origin.patch
