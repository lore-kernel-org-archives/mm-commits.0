From: akpm@linux-foundation.org
Subject: [merged] mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:11:14 -0700
Message-ID: <20121009181115.418BB20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:62261 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756772Ab2JISLR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:11:17 -0400
Received: by mail-fa0-f74.google.com with SMTP id t1so360435fae.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:11:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, kyungmin.park@samsung.com, m.szyprowski@samsung.com, mgorman@suse.de, mina86@mina86.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: discard clean pages during contiguous allocation instead of migration
has been removed from the -mm tree.  Its filename was
     mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: cma: discard clean pages during contiguous allocation instead of migration

Drop clean cache pages instead of migration during alloc_contig_range() to
minimise allocation latency by reducing the amount of migration that is
necessary.  It's useful for CMA because latency of migration is more
important than evicting the background process's working set.  In
addition, as pages are reclaimed then fewer free pages for migration
targets are required so it avoids memory reclaiming to get free pages,
which is a contributory factor to increased latency.

I measured elapsed time of __alloc_contig_migrate_range() which migrates
10M in 40M movable zone in QEMU machine.

Before - 146ms, After - 7ms

[akpm@linux-foundation.org: fix nommu build]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Mel Gorman <mgorman@suse.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Rik van Riel <riel@redhat.com>
Tested-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |   21 ++++++++++----------
 mm/internal.h        |    3 +-
 mm/page_alloc.c      |    2 +
 mm/vmscan.c          |   43 +++++++++++++++++++++++++++++++++++------
 4 files changed, 52 insertions(+), 17 deletions(-)

diff -puN include/linux/rmap.h~mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration include/linux/rmap.h
--- a/include/linux/rmap.h~mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration
+++ a/include/linux/rmap.h
@@ -71,6 +71,17 @@ struct anon_vma_chain {
 #endif
 };
 
+enum ttu_flags {
+	TTU_UNMAP = 0,			/* unmap mode */
+	TTU_MIGRATION = 1,		/* migration mode */
+	TTU_MUNLOCK = 2,		/* munlock mode */
+	TTU_ACTION_MASK = 0xff,
+
+	TTU_IGNORE_MLOCK = (1 << 8),	/* ignore mlock */
+	TTU_IGNORE_ACCESS = (1 << 9),	/* don't age */
+	TTU_IGNORE_HWPOISON = (1 << 10),/* corrupted page is recoverable */
+};
+
 #ifdef CONFIG_MMU
 static inline void get_anon_vma(struct anon_vma *anon_vma)
 {
@@ -164,16 +175,6 @@ int page_referenced(struct page *, int i
 int page_referenced_one(struct page *, struct vm_area_struct *,
 	unsigned long address, unsigned int *mapcount, unsigned long *vm_flags);
 
-enum ttu_flags {
-	TTU_UNMAP = 0,			/* unmap mode */
-	TTU_MIGRATION = 1,		/* migration mode */
-	TTU_MUNLOCK = 2,		/* munlock mode */
-	TTU_ACTION_MASK = 0xff,
-
-	TTU_IGNORE_MLOCK = (1 << 8),	/* ignore mlock */
-	TTU_IGNORE_ACCESS = (1 << 9),	/* don't age */
-	TTU_IGNORE_HWPOISON = (1 << 10),/* corrupted page is recoverable */
-};
 #define TTU_ACTION(x) ((x) & TTU_ACTION_MASK)
 
 int try_to_unmap(struct page *, enum ttu_flags flags);
diff -puN mm/internal.h~mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration mm/internal.h
--- a/mm/internal.h~mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration
+++ a/mm/internal.h
@@ -356,5 +356,6 @@ extern unsigned long vm_mmap_pgoff(struc
         unsigned long, unsigned long);
 
 extern void set_pageblock_order(void);
-
+unsigned long reclaim_clean_pages_from_list(struct zone *zone,
+					    struct list_head *page_list);
 #endif	/* __MM_INTERNAL_H */
diff -puN mm/page_alloc.c~mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration mm/page_alloc.c
--- a/mm/page_alloc.c~mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration
+++ a/mm/page_alloc.c
@@ -5700,6 +5700,8 @@ static int __alloc_contig_migrate_range(
 			break;
 		}
 
+		reclaim_clean_pages_from_list(cc.zone, &cc.migratepages);
+
 		ret = migrate_pages(&cc.migratepages,
 				    __alloc_contig_migrate_alloc,
 				    0, false, MIGRATE_SYNC);
diff -puN mm/vmscan.c~mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration mm/vmscan.c
--- a/mm/vmscan.c~mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration
+++ a/mm/vmscan.c
@@ -674,8 +674,10 @@ static enum page_references page_check_r
 static unsigned long shrink_page_list(struct list_head *page_list,
 				      struct zone *zone,
 				      struct scan_control *sc,
+				      enum ttu_flags ttu_flags,
 				      unsigned long *ret_nr_dirty,
-				      unsigned long *ret_nr_writeback)
+				      unsigned long *ret_nr_writeback,
+				      bool force_reclaim)
 {
 	LIST_HEAD(ret_pages);
 	LIST_HEAD(free_pages);
@@ -689,10 +691,10 @@ static unsigned long shrink_page_list(st
 
 	mem_cgroup_uncharge_start();
 	while (!list_empty(page_list)) {
-		enum page_references references;
 		struct address_space *mapping;
 		struct page *page;
 		int may_enter_fs;
+		enum page_references references = PAGEREF_RECLAIM_CLEAN;
 
 		cond_resched();
 
@@ -758,7 +760,9 @@ static unsigned long shrink_page_list(st
 			wait_on_page_writeback(page);
 		}
 
-		references = page_check_references(page, sc);
+		if (!force_reclaim)
+			references = page_check_references(page, sc);
+
 		switch (references) {
 		case PAGEREF_ACTIVATE:
 			goto activate_locked;
@@ -788,7 +792,7 @@ static unsigned long shrink_page_list(st
 		 * processes. Try to unmap it here.
 		 */
 		if (page_mapped(page) && mapping) {
-			switch (try_to_unmap(page, TTU_UNMAP)) {
+			switch (try_to_unmap(page, ttu_flags)) {
 			case SWAP_FAIL:
 				goto activate_locked;
 			case SWAP_AGAIN:
@@ -960,6 +964,33 @@ keep:
 	return nr_reclaimed;
 }
 
+unsigned long reclaim_clean_pages_from_list(struct zone *zone,
+					    struct list_head *page_list)
+{
+	struct scan_control sc = {
+		.gfp_mask = GFP_KERNEL,
+		.priority = DEF_PRIORITY,
+		.may_unmap = 1,
+	};
+	unsigned long ret, dummy1, dummy2;
+	struct page *page, *next;
+	LIST_HEAD(clean_pages);
+
+	list_for_each_entry_safe(page, next, page_list, lru) {
+		if (page_is_file_cache(page) && !PageDirty(page)) {
+			ClearPageActive(page);
+			list_move(&page->lru, &clean_pages);
+		}
+	}
+
+	ret = shrink_page_list(&clean_pages, zone, &sc,
+				TTU_UNMAP|TTU_IGNORE_ACCESS,
+				&dummy1, &dummy2, true);
+	list_splice(&clean_pages, page_list);
+	__mod_zone_page_state(zone, NR_ISOLATED_FILE, -ret);
+	return ret;
+}
+
 /*
  * Attempt to remove the specified page from its LRU.  Only take this page
  * if it is of the appropriate PageActive status.  Pages which are being
@@ -1278,8 +1309,8 @@ shrink_inactive_list(unsigned long nr_to
 	if (nr_taken == 0)
 		return 0;
 
-	nr_reclaimed = shrink_page_list(&page_list, zone, sc,
-						&nr_dirty, &nr_writeback);
+	nr_reclaimed = shrink_page_list(&page_list, zone, sc, TTU_UNMAP,
+					&nr_dirty, &nr_writeback, false);
 
 	spin_lock_irq(&zone->lru_lock);
 
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
mm-memblock-reduce-overhead-in-binary-search.patch

