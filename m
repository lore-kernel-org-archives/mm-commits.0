From: akpm@linux-foundation.org
Subject: [merged] mm-remove-free_page_mlock.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:13:46 -0700
Message-ID: <20121009181346.C533A1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:39481 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756819Ab2JISNr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:13:47 -0400
Received: by mail-yh0-f74.google.com with SMTP id 10so574501yhl.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:13:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, hannes@cmpxchg.org, mel@csn.ul.ie, riel@redhat.com, walken@google.com, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove free_page_mlock
has been removed from the -mm tree.  Its filename was
     mm-remove-free_page_mlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: remove free_page_mlock

We should not be seeing non-0 unevictable_pgs_mlockfreed any longer.  So
remove free_page_mlock() from the page freeing paths: __PG_MLOCKED is
already in PAGE_FLAGS_CHECK_AT_FREE, so free_pages_check() will now be
checking it, reporting "BUG: Bad page state" if it's ever found set. 
Comment UNEVICTABLE_MLOCKFREED and unevictable_pgs_mlockfreed always 0.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vm_event_item.h |    2 +-
 mm/page_alloc.c               |   17 -----------------
 mm/vmstat.c                   |    2 +-
 3 files changed, 2 insertions(+), 19 deletions(-)

diff -puN include/linux/vm_event_item.h~mm-remove-free_page_mlock include/linux/vm_event_item.h
--- a/include/linux/vm_event_item.h~mm-remove-free_page_mlock
+++ a/include/linux/vm_event_item.h
@@ -52,7 +52,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		UNEVICTABLE_PGMUNLOCKED,
 		UNEVICTABLE_PGCLEARED,	/* on COW, page truncate */
 		UNEVICTABLE_PGSTRANDED,	/* unable to isolate on unlock */
-		UNEVICTABLE_MLOCKFREED,
+		UNEVICTABLE_MLOCKFREED,	/* no longer useful: always zero */
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 		THP_FAULT_ALLOC,
 		THP_FAULT_FALLBACK,
diff -puN mm/page_alloc.c~mm-remove-free_page_mlock mm/page_alloc.c
--- a/mm/page_alloc.c~mm-remove-free_page_mlock
+++ a/mm/page_alloc.c
@@ -598,17 +598,6 @@ out:
 	zone->free_area[order].nr_free++;
 }
 
-/*
- * free_page_mlock() -- clean up attempts to free and mlocked() page.
- * Page should not be on lru, so no need to fix that up.
- * free_pages_check() will verify...
- */
-static inline void free_page_mlock(struct page *page)
-{
-	__dec_zone_page_state(page, NR_MLOCK);
-	__count_vm_event(UNEVICTABLE_MLOCKFREED);
-}
-
 static inline int free_pages_check(struct page *page)
 {
 	if (unlikely(page_mapcount(page) |
@@ -728,15 +717,12 @@ static bool free_pages_prepare(struct pa
 static void __free_pages_ok(struct page *page, unsigned int order)
 {
 	unsigned long flags;
-	int wasMlocked = __TestClearPageMlocked(page);
 	int migratetype;
 
 	if (!free_pages_prepare(page, order))
 		return;
 
 	local_irq_save(flags);
-	if (unlikely(wasMlocked))
-		free_page_mlock(page);
 	__count_vm_events(PGFREE, 1 << order);
 	migratetype = get_pageblock_migratetype(page);
 	set_freepage_migratetype(page, migratetype);
@@ -1310,7 +1296,6 @@ void free_hot_cold_page(struct page *pag
 	struct per_cpu_pages *pcp;
 	unsigned long flags;
 	int migratetype;
-	int wasMlocked = __TestClearPageMlocked(page);
 
 	if (!free_pages_prepare(page, 0))
 		return;
@@ -1318,8 +1303,6 @@ void free_hot_cold_page(struct page *pag
 	migratetype = get_pageblock_migratetype(page);
 	set_freepage_migratetype(page, migratetype);
 	local_irq_save(flags);
-	if (unlikely(wasMlocked))
-		free_page_mlock(page);
 	__count_vm_event(PGFREE);
 
 	/*
diff -puN mm/vmstat.c~mm-remove-free_page_mlock mm/vmstat.c
--- a/mm/vmstat.c~mm-remove-free_page_mlock
+++ a/mm/vmstat.c
@@ -782,7 +782,7 @@ const char * const vmstat_text[] = {
 	"unevictable_pgs_munlocked",
 	"unevictable_pgs_cleared",
 	"unevictable_pgs_stranded",
-	"unevictable_pgs_mlockfreed",
+	"unevictable_pgs_mlockfreed",	/* no longer useful: always zero */
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	"thp_fault_alloc",
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
linux-next.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch

