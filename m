From: akpm@linux-foundation.org
Subject: [patch 020/102] mm: move MADV_FREE pages into
 LRU_INACTIVE_FILE list
Date: Wed, 03 May 2017 14:52:29 -0700
Message-ID: <20170503215229.9qsyObJhS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47416 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752340AbdECVwa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:52:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, hughd@google.com, mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, riel@redhat.com, shli@fb.com, torvalds@linux-foundation.org

From: Shaohua Li <shli@fb.com>
Subject: mm: move MADV_FREE pages into LRU_INACTIVE_FILE list

madv()'s MADV_FREE indicate pages are 'lazyfree'.  They are still
anonymous pages, but they can be freed without pageout.  To distinguish
these from normal anonymous pages, we clear their SwapBacked flag.

MADV_FREE pages could be freed without pageout, so they pretty much like
used once file pages. For such pages, we'd like to reclaim them once
there is memory pressure. Also it might be unfair reclaiming MADV_FREE
pages always before used once file pages and we definitively want to
reclaim the pages before other anonymous and file pages.

To speed up MADV_FREE pages reclaim, we put the pages into
LRU_INACTIVE_FILE list. The rationale is LRU_INACTIVE_FILE list is tiny
nowadays and should be full of used once file pages. Reclaiming
MADV_FREE pages will not have much interfere of anonymous and active
file pages. And the inactive file pages and MADV_FREE pages will be
reclaimed according to their age, so we don't reclaim too many MADV_FREE
pages too. Putting the MADV_FREE pages into LRU_INACTIVE_FILE_LIST also
means we can reclaim the pages without swap support. This idea is
suggested by Johannes.

This patch doesn't move MADV_FREE pages to LRU_INACTIVE_FILE list yet to
avoid bisect failure, next patch will do it.

The patch is based on Minchan's original patch.

[akpm@linux-foundation.org: coding-style fixes]
Link: http://lkml.kernel.org/r/2f87063c1e9354677b7618c647abde77b07561e5.1487965799.git.shli@fb.com
Signed-off-by: Shaohua Li <shli@fb.com>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h          |    2 -
 include/linux/vm_event_item.h |    2 -
 mm/huge_memory.c              |    3 -
 mm/madvise.c                  |    2 -
 mm/swap.c                     |   49 ++++++++++++++++++--------------
 mm/vmstat.c                   |    1 
 6 files changed, 31 insertions(+), 28 deletions(-)

diff -puN include/linux/swap.h~mm-move-madv_free-pages-into-lru_inactive_file-list include/linux/swap.h
--- a/include/linux/swap.h~mm-move-madv_free-pages-into-lru_inactive_file-list
+++ a/include/linux/swap.h
@@ -279,7 +279,7 @@ extern void lru_add_drain_cpu(int cpu);
 extern void lru_add_drain_all(void);
 extern void rotate_reclaimable_page(struct page *page);
 extern void deactivate_file_page(struct page *page);
-extern void deactivate_page(struct page *page);
+extern void mark_page_lazyfree(struct page *page);
 extern void swap_setup(void);
 
 extern void add_page_to_unevictable_list(struct page *page);
diff -puN include/linux/vm_event_item.h~mm-move-madv_free-pages-into-lru_inactive_file-list include/linux/vm_event_item.h
--- a/include/linux/vm_event_item.h~mm-move-madv_free-pages-into-lru_inactive_file-list
+++ a/include/linux/vm_event_item.h
@@ -25,7 +25,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		FOR_ALL_ZONES(PGALLOC),
 		FOR_ALL_ZONES(ALLOCSTALL),
 		FOR_ALL_ZONES(PGSCAN_SKIP),
-		PGFREE, PGACTIVATE, PGDEACTIVATE,
+		PGFREE, PGACTIVATE, PGDEACTIVATE, PGLAZYFREE,
 		PGFAULT, PGMAJFAULT,
 		PGLAZYFREED,
 		PGREFILL,
diff -puN mm/huge_memory.c~mm-move-madv_free-pages-into-lru_inactive_file-list mm/huge_memory.c
--- a/mm/huge_memory.c~mm-move-madv_free-pages-into-lru_inactive_file-list
+++ a/mm/huge_memory.c
@@ -1564,9 +1564,6 @@ bool madvise_free_huge_pmd(struct mmu_ga
 		ClearPageDirty(page);
 	unlock_page(page);
 
-	if (PageActive(page))
-		deactivate_page(page);
-
 	if (pmd_young(orig_pmd) || pmd_dirty(orig_pmd)) {
 		pmdp_invalidate(vma, addr, pmd);
 		orig_pmd = pmd_mkold(orig_pmd);
diff -puN mm/madvise.c~mm-move-madv_free-pages-into-lru_inactive_file-list mm/madvise.c
--- a/mm/madvise.c~mm-move-madv_free-pages-into-lru_inactive_file-list
+++ a/mm/madvise.c
@@ -411,8 +411,6 @@ static int madvise_free_pte_range(pmd_t
 			ptent = pte_mkold(ptent);
 			ptent = pte_mkclean(ptent);
 			set_pte_at(mm, addr, pte, ptent);
-			if (PageActive(page))
-				deactivate_page(page);
 			tlb_remove_tlb_entry(tlb, pte, addr);
 		}
 	}
diff -puN mm/swap.c~mm-move-madv_free-pages-into-lru_inactive_file-list mm/swap.c
--- a/mm/swap.c~mm-move-madv_free-pages-into-lru_inactive_file-list
+++ a/mm/swap.c
@@ -46,7 +46,7 @@ int page_cluster;
 static DEFINE_PER_CPU(struct pagevec, lru_add_pvec);
 static DEFINE_PER_CPU(struct pagevec, lru_rotate_pvecs);
 static DEFINE_PER_CPU(struct pagevec, lru_deactivate_file_pvecs);
-static DEFINE_PER_CPU(struct pagevec, lru_deactivate_pvecs);
+static DEFINE_PER_CPU(struct pagevec, lru_lazyfree_pvecs);
 #ifdef CONFIG_SMP
 static DEFINE_PER_CPU(struct pagevec, activate_page_pvecs);
 #endif
@@ -571,20 +571,27 @@ static void lru_deactivate_file_fn(struc
 }
 
 
-static void lru_deactivate_fn(struct page *page, struct lruvec *lruvec,
+static void lru_lazyfree_fn(struct page *page, struct lruvec *lruvec,
 			    void *arg)
 {
-	if (PageLRU(page) && PageActive(page) && !PageUnevictable(page)) {
-		int file = page_is_file_cache(page);
-		int lru = page_lru_base_type(page);
+	if (PageLRU(page) && PageAnon(page) && PageSwapBacked(page) &&
+	    !PageUnevictable(page)) {
+		bool active = PageActive(page);
 
-		del_page_from_lru_list(page, lruvec, lru + LRU_ACTIVE);
+		del_page_from_lru_list(page, lruvec,
+				       LRU_INACTIVE_ANON + active);
 		ClearPageActive(page);
 		ClearPageReferenced(page);
-		add_page_to_lru_list(page, lruvec, lru);
+		/*
+		 * lazyfree pages are clean anonymous pages. They have
+		 * SwapBacked flag cleared to distinguish normal anonymous
+		 * pages
+		 */
+		ClearPageSwapBacked(page);
+		add_page_to_lru_list(page, lruvec, LRU_INACTIVE_FILE);
 
-		__count_vm_event(PGDEACTIVATE);
-		update_page_reclaim_stat(lruvec, file, 0);
+		__count_vm_events(PGLAZYFREE, hpage_nr_pages(page));
+		update_page_reclaim_stat(lruvec, 1, 0);
 	}
 }
 
@@ -614,9 +621,9 @@ void lru_add_drain_cpu(int cpu)
 	if (pagevec_count(pvec))
 		pagevec_lru_move_fn(pvec, lru_deactivate_file_fn, NULL);
 
-	pvec = &per_cpu(lru_deactivate_pvecs, cpu);
+	pvec = &per_cpu(lru_lazyfree_pvecs, cpu);
 	if (pagevec_count(pvec))
-		pagevec_lru_move_fn(pvec, lru_deactivate_fn, NULL);
+		pagevec_lru_move_fn(pvec, lru_lazyfree_fn, NULL);
 
 	activate_page_drain(cpu);
 }
@@ -648,22 +655,22 @@ void deactivate_file_page(struct page *p
 }
 
 /**
- * deactivate_page - deactivate a page
+ * mark_page_lazyfree - make an anon page lazyfree
  * @page: page to deactivate
  *
- * deactivate_page() moves @page to the inactive list if @page was on the active
- * list and was not an unevictable page.  This is done to accelerate the reclaim
- * of @page.
+ * mark_page_lazyfree() moves @page to the inactive file list.
+ * This is done to accelerate the reclaim of @page.
  */
-void deactivate_page(struct page *page)
+void mark_page_lazyfree(struct page *page)
 {
-	if (PageLRU(page) && PageActive(page) && !PageUnevictable(page)) {
-		struct pagevec *pvec = &get_cpu_var(lru_deactivate_pvecs);
+	if (PageLRU(page) && PageAnon(page) && PageSwapBacked(page) &&
+	    !PageUnevictable(page)) {
+		struct pagevec *pvec = &get_cpu_var(lru_lazyfree_pvecs);
 
 		get_page(page);
 		if (!pagevec_add(pvec, page) || PageCompound(page))
-			pagevec_lru_move_fn(pvec, lru_deactivate_fn, NULL);
-		put_cpu_var(lru_deactivate_pvecs);
+			pagevec_lru_move_fn(pvec, lru_lazyfree_fn, NULL);
+		put_cpu_var(lru_lazyfree_pvecs);
 	}
 }
 
@@ -703,7 +710,7 @@ void lru_add_drain_all(void)
 		if (pagevec_count(&per_cpu(lru_add_pvec, cpu)) ||
 		    pagevec_count(&per_cpu(lru_rotate_pvecs, cpu)) ||
 		    pagevec_count(&per_cpu(lru_deactivate_file_pvecs, cpu)) ||
-		    pagevec_count(&per_cpu(lru_deactivate_pvecs, cpu)) ||
+		    pagevec_count(&per_cpu(lru_lazyfree_pvecs, cpu)) ||
 		    need_activate_page_drain(cpu)) {
 			INIT_WORK(work, lru_add_drain_per_cpu);
 			queue_work_on(cpu, mm_percpu_wq, work);
diff -puN mm/vmstat.c~mm-move-madv_free-pages-into-lru_inactive_file-list mm/vmstat.c
--- a/mm/vmstat.c~mm-move-madv_free-pages-into-lru_inactive_file-list
+++ a/mm/vmstat.c
@@ -991,6 +991,7 @@ const char * const vmstat_text[] = {
 	"pgfree",
 	"pgactivate",
 	"pgdeactivate",
+	"pglazyfree",
 
 	"pgfault",
 	"pgmajfault",
_
