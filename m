From: akpm@linux-foundation.org
Subject: [merged] mm-cma-fix-alignment-requirements-for-contiguous-regions.patch removed from -mm tree
Date: Tue, 04 Sep 2012 12:26:27 -0700
Message-ID: <20120904192628.157CE20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:40424 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757651Ab2IDT0a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Sep 2012 15:26:30 -0400
Received: by weyr1 with SMTP id r1so368595wey.1
        for <mm-commits@vger.kernel.org>; Tue, 04 Sep 2012 12:26:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.szyprowski@samsung.com, mina86@mina86.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: fix alignment requirements for contiguous regions
has been removed from the -mm tree.  Its filename was
     mm-cma-fix-alignment-requirements-for-contiguous-regions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: mm: cma: fix alignment requirements for contiguous regions

Contiguous Memory Allocator requires each of its regions to be aligned in
such a way that it is possible to change migration type for all pageblocks
holding it and then isolate page of largest possible order from the buddy
allocator (which is MAX_ORDER-1).  This patch relaxes alignment
requirements by one order, because MAX_ORDER alignment is not really
needed.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/dma-contiguous.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/base/dma-contiguous.c~mm-cma-fix-alignment-requirements-for-contiguous-regions drivers/base/dma-contiguous.c
--- a/drivers/base/dma-contiguous.c~mm-cma-fix-alignment-requirements-for-contiguous-regions
+++ a/drivers/base/dma-contiguous.c
@@ -250,7 +250,7 @@ int __init dma_declare_contiguous(struct
 		return -EINVAL;
 
 	/* Sanitise input arguments */
-	alignment = PAGE_SIZE << max(MAX_ORDER, pageblock_order);
+	alignment = PAGE_SIZE << max(MAX_ORDER - 1, pageblock_order);
 	base = ALIGN(base, alignment);
 	size = ALIGN(size, alignment);
 	limit &= ~(alignment - 1);
_

Patches currently in -mm which might be from m.szyprowski@samsung.com are

linux-next.patch

