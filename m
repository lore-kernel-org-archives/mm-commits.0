From: akpm@linux-foundation.org
Subject: [merged] mm-cma-fix-accounting-of-cma-pages-placed-in-high-memory.patch removed from -mm tree
Date: Wed, 13 Feb 2013 12:36:07 -0800
Message-ID: <20130213203608.0520D5A41B5@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:51018 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934006Ab3BMUgJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Feb 2013 15:36:09 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so165023vea.0
        for <mm-commits@vger.kernel.org>; Wed, 13 Feb 2013 12:36:08 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.szyprowski@samsung.com, kyungmin.park@samsung.com, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: fix accounting of CMA pages placed in high memory
has been removed from the -mm tree.  Its filename was
     mm-cma-fix-accounting-of-cma-pages-placed-in-high-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: mm: cma: fix accounting of CMA pages placed in high memory

The total number of low memory pages is determined as totalram_pages -
totalhigh_pages, so without this patch all CMA pageblocks placed in
highmem were accounted to low memory.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/page_alloc.c~mm-cma-fix-accounting-of-cma-pages-placed-in-high-memory mm/page_alloc.c
--- a/mm/page_alloc.c~mm-cma-fix-accounting-of-cma-pages-placed-in-high-memory
+++ a/mm/page_alloc.c
@@ -773,6 +773,10 @@ void __init init_cma_reserved_pageblock(
 	set_pageblock_migratetype(page, MIGRATE_CMA);
 	__free_pages(page, pageblock_order);
 	totalram_pages += pageblock_nr_pages;
+#ifdef CONFIG_HIGHMEM
+	if (PageHighMem(page))
+		totalhigh_pages += pageblock_nr_pages;
+#endif
 }
 #endif
 
_

Patches currently in -mm which might be from m.szyprowski@samsung.com are

origin.patch
linux-next.patch
cma-make-putback_lru_pages-call-conditional.patch
cma-make-putback_lru_pages-call-conditional-fix.patch

