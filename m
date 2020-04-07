From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 022/166] mm: code cleanup for MADV_FREE
Date: Mon, 06 Apr 2020 20:04:41 -0700
Message-ID: <20200407030441.ImU66HuCM%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726637AbgDGDEn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:04:43 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave.hansen@linux.intel.com, david@redhat.com, hannes@cmpxchg.org, hughd@google.com, linux-mm@kvack.org, mgorman@suse.de, mhocko@kernel.org, minchan@kernel.org, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, riel@surriel.com, rientjes@google.com, torvalds@linux-foundation.org, vbabka@suse.cz, ying.huang@intel.com

From: Huang Ying <ying.huang@intel.com>
Subject: mm: code cleanup for MADV_FREE

Some comments for MADV_FREE is revised and added to help people understand
the MADV_FREE code, especially the page flag, PG_swapbacked.  This makes
page_is_file_cache() isn't consistent with its comments.  So the function
is renamed to page_is_file_lru() to make them consistent again.  All these
are put in one patch as one logical change.

Link: http://lkml.kernel.org/r/20200317100342.2730705-1-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: David Rientjes <rientjes@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Michal Hocko <mhocko@kernel.org>
Acked-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h     |   15 ++++++++-------
 include/linux/page-flags.h    |    5 +++++
 include/trace/events/vmscan.h |    2 +-
 mm/compaction.c               |    2 +-
 mm/gup.c                      |    2 +-
 mm/khugepaged.c               |    4 ++--
 mm/memory-failure.c           |    2 +-
 mm/memory_hotplug.c           |    2 +-
 mm/mempolicy.c                |    2 +-
 mm/migrate.c                  |   16 ++++++++--------
 mm/mprotect.c                 |    2 +-
 mm/swap.c                     |   16 ++++++++--------
 mm/vmscan.c                   |   12 ++++++------
 13 files changed, 44 insertions(+), 38 deletions(-)

--- a/include/linux/mm_inline.h~mm-code-cleanup-for-madv_free
+++ a/include/linux/mm_inline.h
@@ -6,19 +6,20 @@
 #include <linux/swap.h>
 
 /**
- * page_is_file_cache - should the page be on a file LRU or anon LRU?
+ * page_is_file_lru - should the page be on a file LRU or anon LRU?
  * @page: the page to test
  *
- * Returns 1 if @page is page cache page backed by a regular filesystem,
- * or 0 if @page is anonymous, tmpfs or otherwise ram or swap backed.
- * Used by functions that manipulate the LRU lists, to sort a page
- * onto the right LRU list.
+ * Returns 1 if @page is a regular filesystem backed page cache page or a lazily
+ * freed anonymous page (e.g. via MADV_FREE).  Returns 0 if @page is a normal
+ * anonymous page, a tmpfs page or otherwise ram or swap backed page.  Used by
+ * functions that manipulate the LRU lists, to sort a page onto the right LRU
+ * list.
  *
  * We would like to get this info without a page flag, but the state
  * needs to survive until the page is last deleted from the LRU, which
  * could be as far down as __page_cache_release.
  */
-static inline int page_is_file_cache(struct page *page)
+static inline int page_is_file_lru(struct page *page)
 {
 	return !PageSwapBacked(page);
 }
@@ -75,7 +76,7 @@ static __always_inline void del_page_fro
  */
 static inline enum lru_list page_lru_base_type(struct page *page)
 {
-	if (page_is_file_cache(page))
+	if (page_is_file_lru(page))
 		return LRU_INACTIVE_FILE;
 	return LRU_INACTIVE_ANON;
 }
--- a/include/linux/page-flags.h~mm-code-cleanup-for-madv_free
+++ a/include/linux/page-flags.h
@@ -63,6 +63,11 @@
  * page_waitqueue(page) is a wait queue of all tasks waiting for the page
  * to become unlocked.
  *
+ * PG_swapbacked is set when a page uses swap as a backing storage.  This are
+ * usually PageAnon or shmem pages but please note that even anonymous pages
+ * might lose their PG_swapbacked flag when they simply can be dropped (e.g. as
+ * a result of MADV_FREE).
+ *
  * PG_uptodate tells whether the page's contents is valid.  When a read
  * completes, the page becomes uptodate, unless a disk I/O error happened.
  *
--- a/include/trace/events/vmscan.h~mm-code-cleanup-for-madv_free
+++ a/include/trace/events/vmscan.h
@@ -323,7 +323,7 @@ TRACE_EVENT(mm_vmscan_writepage,
 	TP_fast_assign(
 		__entry->pfn = page_to_pfn(page);
 		__entry->reclaim_flags = trace_reclaim_flags(
-						page_is_file_cache(page));
+						page_is_file_lru(page));
 	),
 
 	TP_printk("page=%p pfn=%lu flags=%s",
--- a/mm/compaction.c~mm-code-cleanup-for-madv_free
+++ a/mm/compaction.c
@@ -989,7 +989,7 @@ isolate_migratepages_block(struct compac
 		/* Successfully isolated */
 		del_page_from_lru_list(page, lruvec, page_lru(page));
 		mod_node_page_state(page_pgdat(page),
-				NR_ISOLATED_ANON + page_is_file_cache(page),
+				NR_ISOLATED_ANON + page_is_file_lru(page),
 				hpage_nr_pages(page));
 
 isolate_success:
--- a/mm/gup.c~mm-code-cleanup-for-madv_free
+++ a/mm/gup.c
@@ -1677,7 +1677,7 @@ check_again:
 					list_add_tail(&head->lru, &cma_page_list);
 					mod_node_page_state(page_pgdat(head),
 							    NR_ISOLATED_ANON +
-							    page_is_file_cache(head),
+							    page_is_file_lru(head),
 							    hpage_nr_pages(head));
 				}
 			}
--- a/mm/khugepaged.c~mm-code-cleanup-for-madv_free
+++ a/mm/khugepaged.c
@@ -511,7 +511,7 @@ void __khugepaged_exit(struct mm_struct
 
 static void release_pte_page(struct page *page)
 {
-	dec_node_page_state(page, NR_ISOLATED_ANON + page_is_file_cache(page));
+	dec_node_page_state(page, NR_ISOLATED_ANON + page_is_file_lru(page));
 	unlock_page(page);
 	putback_lru_page(page);
 }
@@ -611,7 +611,7 @@ static int __collapse_huge_page_isolate(
 			goto out;
 		}
 		inc_node_page_state(page,
-				NR_ISOLATED_ANON + page_is_file_cache(page));
+				NR_ISOLATED_ANON + page_is_file_lru(page));
 		VM_BUG_ON_PAGE(!PageLocked(page), page);
 		VM_BUG_ON_PAGE(PageLRU(page), page);
 
--- a/mm/memory-failure.c~mm-code-cleanup-for-madv_free
+++ a/mm/memory-failure.c
@@ -1810,7 +1810,7 @@ static int __soft_offline_page(struct pa
 		 */
 		if (!__PageMovable(page))
 			inc_node_page_state(page, NR_ISOLATED_ANON +
-						page_is_file_cache(page));
+						page_is_file_lru(page));
 		list_add(&page->lru, &pagelist);
 		ret = migrate_pages(&pagelist, new_page, NULL, MPOL_MF_MOVE_ALL,
 					MIGRATE_SYNC, MR_MEMORY_FAILURE);
--- a/mm/memory_hotplug.c~mm-code-cleanup-for-madv_free
+++ a/mm/memory_hotplug.c
@@ -1317,7 +1317,7 @@ do_migrate_range(unsigned long start_pfn
 			list_add_tail(&page->lru, &source);
 			if (!__PageMovable(page))
 				inc_node_page_state(page, NR_ISOLATED_ANON +
-						    page_is_file_cache(page));
+						    page_is_file_lru(page));
 
 		} else {
 			pr_warn("failed to isolate pfn %lx\n", pfn);
--- a/mm/mempolicy.c~mm-code-cleanup-for-madv_free
+++ a/mm/mempolicy.c
@@ -1022,7 +1022,7 @@ static int migrate_page_add(struct page
 		if (!isolate_lru_page(head)) {
 			list_add_tail(&head->lru, pagelist);
 			mod_node_page_state(page_pgdat(head),
-				NR_ISOLATED_ANON + page_is_file_cache(head),
+				NR_ISOLATED_ANON + page_is_file_lru(head),
 				hpage_nr_pages(head));
 		} else if (flags & MPOL_MF_STRICT) {
 			/*
--- a/mm/migrate.c~mm-code-cleanup-for-madv_free
+++ a/mm/migrate.c
@@ -193,7 +193,7 @@ void putback_movable_pages(struct list_h
 			put_page(page);
 		} else {
 			mod_node_page_state(page_pgdat(page), NR_ISOLATED_ANON +
-					page_is_file_cache(page), -hpage_nr_pages(page));
+					page_is_file_lru(page), -hpage_nr_pages(page));
 			putback_lru_page(page);
 		}
 	}
@@ -1219,7 +1219,7 @@ out:
 		 */
 		if (likely(!__PageMovable(page)))
 			mod_node_page_state(page_pgdat(page), NR_ISOLATED_ANON +
-					page_is_file_cache(page), -hpage_nr_pages(page));
+					page_is_file_lru(page), -hpage_nr_pages(page));
 	}
 
 	/*
@@ -1592,7 +1592,7 @@ static int add_page_for_migration(struct
 		err = 1;
 		list_add_tail(&head->lru, pagelist);
 		mod_node_page_state(page_pgdat(head),
-			NR_ISOLATED_ANON + page_is_file_cache(head),
+			NR_ISOLATED_ANON + page_is_file_lru(head),
 			hpage_nr_pages(head));
 	}
 out_putpage:
@@ -1955,7 +1955,7 @@ static int numamigrate_isolate_page(pg_d
 		return 0;
 	}
 
-	page_lru = page_is_file_cache(page);
+	page_lru = page_is_file_lru(page);
 	mod_node_page_state(page_pgdat(page), NR_ISOLATED_ANON + page_lru,
 				hpage_nr_pages(page));
 
@@ -1991,7 +1991,7 @@ int migrate_misplaced_page(struct page *
 	 * Don't migrate file pages that are mapped in multiple processes
 	 * with execute permissions as they are probably shared libraries.
 	 */
-	if (page_mapcount(page) != 1 && page_is_file_cache(page) &&
+	if (page_mapcount(page) != 1 && page_is_file_lru(page) &&
 	    (vma->vm_flags & VM_EXEC))
 		goto out;
 
@@ -1999,7 +1999,7 @@ int migrate_misplaced_page(struct page *
 	 * Also do not migrate dirty pages as not all filesystems can move
 	 * dirty pages in MIGRATE_ASYNC mode which is a waste of cycles.
 	 */
-	if (page_is_file_cache(page) && PageDirty(page))
+	if (page_is_file_lru(page) && PageDirty(page))
 		goto out;
 
 	isolated = numamigrate_isolate_page(pgdat, page);
@@ -2014,7 +2014,7 @@ int migrate_misplaced_page(struct page *
 		if (!list_empty(&migratepages)) {
 			list_del(&page->lru);
 			dec_node_page_state(page, NR_ISOLATED_ANON +
-					page_is_file_cache(page));
+					page_is_file_lru(page));
 			putback_lru_page(page);
 		}
 		isolated = 0;
@@ -2044,7 +2044,7 @@ int migrate_misplaced_transhuge_page(str
 	pg_data_t *pgdat = NODE_DATA(node);
 	int isolated = 0;
 	struct page *new_page = NULL;
-	int page_lru = page_is_file_cache(page);
+	int page_lru = page_is_file_lru(page);
 	unsigned long start = address & HPAGE_PMD_MASK;
 
 	new_page = alloc_pages_node(node,
--- a/mm/mprotect.c~mm-code-cleanup-for-madv_free
+++ a/mm/mprotect.c
@@ -98,7 +98,7 @@ static unsigned long change_pte_range(st
 				 * it cannot move them all from MIGRATE_ASYNC
 				 * context.
 				 */
-				if (page_is_file_cache(page) && PageDirty(page))
+				if (page_is_file_lru(page) && PageDirty(page))
 					continue;
 
 				/*
--- a/mm/swap.c~mm-code-cleanup-for-madv_free
+++ a/mm/swap.c
@@ -276,7 +276,7 @@ static void __activate_page(struct page
 			    void *arg)
 {
 	if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
-		int file = page_is_file_cache(page);
+		int file = page_is_file_lru(page);
 		int lru = page_lru_base_type(page);
 
 		del_page_from_lru_list(page, lruvec, lru);
@@ -394,7 +394,7 @@ void mark_page_accessed(struct page *pag
 		else
 			__lru_cache_activate_page(page);
 		ClearPageReferenced(page);
-		if (page_is_file_cache(page))
+		if (page_is_file_lru(page))
 			workingset_activation(page);
 	}
 	if (page_is_idle(page))
@@ -515,7 +515,7 @@ static void lru_deactivate_file_fn(struc
 		return;
 
 	active = PageActive(page);
-	file = page_is_file_cache(page);
+	file = page_is_file_lru(page);
 	lru = page_lru_base_type(page);
 
 	del_page_from_lru_list(page, lruvec, lru + active);
@@ -548,7 +548,7 @@ static void lru_deactivate_fn(struct pag
 			    void *arg)
 {
 	if (PageLRU(page) && PageActive(page) && !PageUnevictable(page)) {
-		int file = page_is_file_cache(page);
+		int file = page_is_file_lru(page);
 		int lru = page_lru_base_type(page);
 
 		del_page_from_lru_list(page, lruvec, lru + LRU_ACTIVE);
@@ -573,9 +573,9 @@ static void lru_lazyfree_fn(struct page
 		ClearPageActive(page);
 		ClearPageReferenced(page);
 		/*
-		 * lazyfree pages are clean anonymous pages. They have
-		 * SwapBacked flag cleared to distinguish normal anonymous
-		 * pages
+		 * Lazyfree pages are clean anonymous pages.  They have
+		 * PG_swapbacked flag cleared, to distinguish them from normal
+		 * anonymous pages
 		 */
 		ClearPageSwapBacked(page);
 		add_page_to_lru_list(page, lruvec, LRU_INACTIVE_FILE);
@@ -962,7 +962,7 @@ static void __pagevec_lru_add_fn(struct
 
 	if (page_evictable(page)) {
 		lru = page_lru(page);
-		update_page_reclaim_stat(lruvec, page_is_file_cache(page),
+		update_page_reclaim_stat(lruvec, page_is_file_lru(page),
 					 PageActive(page));
 		if (was_unevictable)
 			count_vm_event(UNEVICTABLE_PGRESCUED);
--- a/mm/vmscan.c~mm-code-cleanup-for-madv_free
+++ a/mm/vmscan.c
@@ -919,7 +919,7 @@ static int __remove_mapping(struct addre
 		 * exceptional entries and shadow exceptional entries in the
 		 * same address_space.
 		 */
-		if (reclaimed && page_is_file_cache(page) &&
+		if (reclaimed && page_is_file_lru(page) &&
 		    !mapping_exiting(mapping) && !dax_mapping(mapping))
 			shadow = workingset_eviction(page, target_memcg);
 		__delete_from_page_cache(page, shadow);
@@ -1043,7 +1043,7 @@ static void page_check_dirty_writeback(s
 	 * Anonymous pages are not handled by flushers and must be written
 	 * from reclaim context. Do not stall reclaim based on them
 	 */
-	if (!page_is_file_cache(page) ||
+	if (!page_is_file_lru(page) ||
 	    (PageAnon(page) && !PageSwapBacked(page))) {
 		*dirty = false;
 		*writeback = false;
@@ -1315,7 +1315,7 @@ static unsigned long shrink_page_list(st
 			 * the rest of the LRU for clean pages and see
 			 * the same dirty pages again (PageReclaim).
 			 */
-			if (page_is_file_cache(page) &&
+			if (page_is_file_lru(page) &&
 			    (!current_is_kswapd() || !PageReclaim(page) ||
 			     !test_bit(PGDAT_DIRTY, &pgdat->flags))) {
 				/*
@@ -1459,7 +1459,7 @@ activate_locked:
 			try_to_free_swap(page);
 		VM_BUG_ON_PAGE(PageActive(page), page);
 		if (!PageMlocked(page)) {
-			int type = page_is_file_cache(page);
+			int type = page_is_file_lru(page);
 			SetPageActive(page);
 			stat->nr_activate[type] += nr_pages;
 			count_memcg_page_event(page, PGACTIVATE);
@@ -1497,7 +1497,7 @@ unsigned long reclaim_clean_pages_from_l
 	LIST_HEAD(clean_pages);
 
 	list_for_each_entry_safe(page, next, page_list, lru) {
-		if (page_is_file_cache(page) && !PageDirty(page) &&
+		if (page_is_file_lru(page) && !PageDirty(page) &&
 		    !__PageMovable(page) && !PageUnevictable(page)) {
 			ClearPageActive(page);
 			list_move(&page->lru, &clean_pages);
@@ -2053,7 +2053,7 @@ static void shrink_active_list(unsigned
 			 * IO, plus JVM can create lots of anon VM_EXEC pages,
 			 * so we ignore them here.
 			 */
-			if ((vm_flags & VM_EXEC) && page_is_file_cache(page)) {
+			if ((vm_flags & VM_EXEC) && page_is_file_lru(page)) {
 				list_add(&page->lru, &l_active);
 				continue;
 			}
_
