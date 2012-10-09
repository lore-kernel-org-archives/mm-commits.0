From: akpm@linux-foundation.org
Subject: [merged] mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:12:48 -0700
Message-ID: <20121009181252.363915C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:33217 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756748Ab2JISMz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:12:55 -0400
Received: by mail-ee0-f74.google.com with SMTP id b57so363327eek.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:12:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, isimatu.yasuaki@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, m.szyprowski@samsung.com, mina86@mina86.com, rientjes@google.com, wency@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: refactor out __alloc_contig_migrate_alloc()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm/page_alloc: refactor out __alloc_contig_migrate_alloc()

__alloc_contig_migrate_alloc() can be used by memory-hotplug so refactor
it out (move + rename as a common name) into page_isolation.c.

[akpm@linux-foundation.org: checkpatch fixes]
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-isolation.h |    3 ++-
 mm/page_alloc.c                |   14 +-------------
 mm/page_isolation.c            |   11 +++++++++++
 3 files changed, 14 insertions(+), 14 deletions(-)

diff -puN include/linux/page-isolation.h~mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc include/linux/page-isolation.h
--- a/include/linux/page-isolation.h~mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc
+++ a/include/linux/page-isolation.h
@@ -41,6 +41,7 @@ int test_pages_isolated(unsigned long st
  */
 int set_migratetype_isolate(struct page *page);
 void unset_migratetype_isolate(struct page *page, unsigned migratetype);
-
+struct page *alloc_migrate_target(struct page *page, unsigned long private,
+				int **resultp);
 
 #endif
diff -puN mm/page_alloc.c~mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc
+++ a/mm/page_alloc.c
@@ -5667,18 +5667,6 @@ static unsigned long pfn_max_align_up(un
 				pageblock_nr_pages));
 }
 
-static struct page *
-__alloc_contig_migrate_alloc(struct page *page, unsigned long private,
-			     int **resultp)
-{
-	gfp_t gfp_mask = GFP_USER | __GFP_MOVABLE;
-
-	if (PageHighMem(page))
-		gfp_mask |= __GFP_HIGHMEM;
-
-	return alloc_page(gfp_mask);
-}
-
 /* [start, end) must belong to a single zone. */
 static int __alloc_contig_migrate_range(struct compact_control *cc,
 					unsigned long start, unsigned long end)
@@ -5714,7 +5702,7 @@ static int __alloc_contig_migrate_range(
 		reclaim_clean_pages_from_list(cc->zone, &cc->migratepages);
 
 		ret = migrate_pages(&cc->migratepages,
-				    __alloc_contig_migrate_alloc,
+				    alloc_migrate_target,
 				    0, false, MIGRATE_SYNC);
 	}
 
diff -puN mm/page_isolation.c~mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc mm/page_isolation.c
--- a/mm/page_isolation.c~mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc
+++ a/mm/page_isolation.c
@@ -255,3 +255,14 @@ int test_pages_isolated(unsigned long st
 	spin_unlock_irqrestore(&zone->lock, flags);
 	return ret ? 0 : -EBUSY;
 }
+
+struct page *alloc_migrate_target(struct page *page, unsigned long private,
+				  int **resultp)
+{
+	gfp_t gfp_mask = GFP_USER | __GFP_MOVABLE;
+
+	if (PageHighMem(page))
+		gfp_mask |= __GFP_HIGHMEM;
+
+	return alloc_page(gfp_mask);
+}
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
mm-memblock-reduce-overhead-in-binary-search.patch

