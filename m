From: akpm@linux-foundation.org
Subject: + mm-isolate-pages-for-immediate-reclaim-on-their-own-lru.patch added to -mm tree
Date: Fri, 16 Dec 2011 15:30:17 -0800
Message-ID: <20111216233017.D940F20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:39570 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab1LPXaU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2011 18:30:20 -0500
Received: by mail-fx0-f74.google.com with SMTP id r15so138261faa.1
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2011 15:30:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, aarcange@redhat.com, adi@hexapodia.org, davej@redhat.com, jack@suse.cz, jweiner@redhat.com, minchan.kim@gmail.com, nai.xia@gmail.com, riel@redhat.com


The patch titled
     Subject: mm: isolate pages for immediate reclaim on their own LRU
has been added to the -mm tree.  Its filename is
     mm-isolate-pages-for-immediate-reclaim-on-their-own-lru.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: isolate pages for immediate reclaim on their own LRU

It was observed that scan rates from direct reclaim during tests writing
to both fast and slow storage were extraordinarily high.  The problem was
that while pages were being marked for immediate reclaim when writeback
completed, the same pages were being encountered over and over again
during LRU scanning.

This patch isolates file-backed pages that are to be reclaimed when
clean on their own LRU list.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Andy Isaacson <adi@hexapodia.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Nai Xia <nai.xia@gmail.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h        |    2 
 include/linux/vm_event_item.h |    1 
 mm/page_alloc.c               |    5 +-
 mm/swap.c                     |   74 +++++++++++++++++++++++++++++---
 mm/vmscan.c                   |   11 ++++
 mm/vmstat.c                   |    2 
 6 files changed, 89 insertions(+), 6 deletions(-)

diff -puN include/linux/mmzone.h~mm-isolate-pages-for-immediate-reclaim-on-their-own-lru include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-isolate-pages-for-immediate-reclaim-on-their-own-lru
+++ a/include/linux/mmzone.h
@@ -84,6 +84,7 @@ enum zone_stat_item {
 	NR_ACTIVE_ANON,		/*  "     "     "   "       "         */
 	NR_INACTIVE_FILE,	/*  "     "     "   "       "         */
 	NR_ACTIVE_FILE,		/*  "     "     "   "       "         */
+	NR_IMMEDIATE,		/*  "     "     "   "       "         */
 	NR_UNEVICTABLE,		/*  "     "     "   "       "         */
 	NR_MLOCK,		/* mlock()ed pages found and moved off LRU */
 	NR_ANON_PAGES,	/* Mapped anonymous pages */
@@ -136,6 +137,7 @@ enum lru_list {
 	LRU_ACTIVE_ANON = LRU_BASE + LRU_ACTIVE,
 	LRU_INACTIVE_FILE = LRU_BASE + LRU_FILE,
 	LRU_ACTIVE_FILE = LRU_BASE + LRU_FILE + LRU_ACTIVE,
+	LRU_IMMEDIATE,
 	LRU_UNEVICTABLE,
 	NR_LRU_LISTS
 };
diff -puN include/linux/vm_event_item.h~mm-isolate-pages-for-immediate-reclaim-on-their-own-lru include/linux/vm_event_item.h
--- a/include/linux/vm_event_item.h~mm-isolate-pages-for-immediate-reclaim-on-their-own-lru
+++ a/include/linux/vm_event_item.h
@@ -36,6 +36,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		KSWAPD_LOW_WMARK_HIT_QUICKLY, KSWAPD_HIGH_WMARK_HIT_QUICKLY,
 		KSWAPD_SKIP_CONGESTION_WAIT,
 		PAGEOUTRUN, ALLOCSTALL, PGROTATED,
+		PGRESCUED,
 #ifdef CONFIG_COMPACTION
 		COMPACTBLOCKS, COMPACTPAGES, COMPACTPAGEFAILED,
 		COMPACTSTALL, COMPACTFAIL, COMPACTSUCCESS,
diff -puN mm/page_alloc.c~mm-isolate-pages-for-immediate-reclaim-on-their-own-lru mm/page_alloc.c
--- a/mm/page_alloc.c~mm-isolate-pages-for-immediate-reclaim-on-their-own-lru
+++ a/mm/page_alloc.c
@@ -2698,7 +2698,7 @@ void show_free_areas(unsigned int filter
 
 	printk("active_anon:%lu inactive_anon:%lu isolated_anon:%lu\n"
 		" active_file:%lu inactive_file:%lu isolated_file:%lu\n"
-		" unevictable:%lu"
+		" immediate:%lu unevictable:%lu"
 		" dirty:%lu writeback:%lu unstable:%lu\n"
 		" free:%lu slab_reclaimable:%lu slab_unreclaimable:%lu\n"
 		" mapped:%lu shmem:%lu pagetables:%lu bounce:%lu\n",
@@ -2708,6 +2708,7 @@ void show_free_areas(unsigned int filter
 		global_page_state(NR_ACTIVE_FILE),
 		global_page_state(NR_INACTIVE_FILE),
 		global_page_state(NR_ISOLATED_FILE),
+		global_page_state(NR_IMMEDIATE),
 		global_page_state(NR_UNEVICTABLE),
 		global_page_state(NR_FILE_DIRTY),
 		global_page_state(NR_WRITEBACK),
@@ -2735,6 +2736,7 @@ void show_free_areas(unsigned int filter
 			" inactive_anon:%lukB"
 			" active_file:%lukB"
 			" inactive_file:%lukB"
+			" immediate:%lukB"
 			" unevictable:%lukB"
 			" isolated(anon):%lukB"
 			" isolated(file):%lukB"
@@ -2763,6 +2765,7 @@ void show_free_areas(unsigned int filter
 			K(zone_page_state(zone, NR_INACTIVE_ANON)),
 			K(zone_page_state(zone, NR_ACTIVE_FILE)),
 			K(zone_page_state(zone, NR_INACTIVE_FILE)),
+			K(zone_page_state(zone, NR_IMMEDIATE)),
 			K(zone_page_state(zone, NR_UNEVICTABLE)),
 			K(zone_page_state(zone, NR_ISOLATED_ANON)),
 			K(zone_page_state(zone, NR_ISOLATED_FILE)),
diff -puN mm/swap.c~mm-isolate-pages-for-immediate-reclaim-on-their-own-lru mm/swap.c
--- a/mm/swap.c~mm-isolate-pages-for-immediate-reclaim-on-their-own-lru
+++ a/mm/swap.c
@@ -39,6 +39,7 @@ int page_cluster;
 
 static DEFINE_PER_CPU(struct pagevec[NR_LRU_LISTS], lru_add_pvecs);
 static DEFINE_PER_CPU(struct pagevec, lru_rotate_pvecs);
+static DEFINE_PER_CPU(struct pagevec, lru_putback_immediate_pvecs);
 static DEFINE_PER_CPU(struct pagevec, lru_deactivate_pvecs);
 
 /*
@@ -255,24 +256,80 @@ static void pagevec_move_tail(struct pag
 }
 
 /*
+ * Similar pair of functions to pagevec_move_tail except it is called when
+ * moving a page from the LRU_IMMEDIATE to one of the [in]active_[file|anon]
+ * lists
+ */
+static void pagevec_putback_immediate_fn(struct page *page, void *arg)
+{
+	struct zone *zone = page_zone(page);
+
+	if (PageLRU(page)) {
+		enum lru_list lru = page_lru(page);
+		list_move(&page->lru, &zone->lru[lru].list);
+	}
+}
+
+static void pagevec_putback_immediate(struct pagevec *pvec)
+{
+	pagevec_lru_move_fn(pvec, pagevec_putback_immediate_fn, NULL);
+}
+
+/*
  * Writeback is about to end against a page which has been marked for immediate
  * reclaim.  If it still appears to be reclaimable, move it to the tail of the
  * inactive list.
  */
 void rotate_reclaimable_page(struct page *page)
 {
+	struct zone *zone = page_zone(page);
+	struct list_head *page_list;
+	struct pagevec *pvec;
+	unsigned long flags;
+
+	page_cache_get(page);
+	local_irq_save(flags);
+	__mod_zone_page_state(zone, NR_IMMEDIATE, -1);
+
 	if (!PageLocked(page) && !PageDirty(page) && !PageActive(page) &&
 	    !PageUnevictable(page) && PageLRU(page)) {
-		struct pagevec *pvec;
-		unsigned long flags;
 
-		page_cache_get(page);
-		local_irq_save(flags);
 		pvec = &__get_cpu_var(lru_rotate_pvecs);
 		if (!pagevec_add(pvec, page))
 			pagevec_move_tail(pvec);
-		local_irq_restore(flags);
+	} else {
+		pvec = &__get_cpu_var(lru_putback_immediate_pvecs);
+		if (!pagevec_add(pvec, page))
+			pagevec_putback_immediate(pvec);
+	}
+
+	/*
+	 * There is a potential race that if a page is set PageReclaim
+	 * and moved to the LRU_IMMEDIATE list after writeback completed,
+	 * it can be left on the LRU_IMMEDATE list with no way for
+	 * reclaim to find it.
+	 *
+	 * This race should be very rare but count how often it happens.
+	 * If it is a continual race, then it's very unsatisfactory as there
+	 * is no guarantee that rotate_reclaimable_page() will be called
+	 * to rescue these pages but finding them in page reclaim is also
+	 * problematic due to the problem of deciding when the right time
+	 * to scan this list is.
+	 */
+	page_list = &zone->lru[LRU_IMMEDIATE].list;
+	if (!zone_page_state(zone, NR_IMMEDIATE) && !list_empty(page_list)) {
+		struct page *page;
+
+		spin_lock(&zone->lru_lock);
+		while (!list_empty(page_list)) {
+			page = list_entry(page_list->prev, struct page, lru);
+			list_move(&page->lru, &zone->lru[page_lru(page)].list);
+			__count_vm_event(PGRESCUED);
+		}
+		spin_unlock(&zone->lru_lock);
 	}
+
+	local_irq_restore(flags);
 }
 
 static void update_page_reclaim_stat(struct zone *zone, struct page *page,
@@ -475,6 +532,13 @@ static void lru_deactivate_fn(struct pag
 		 * is _really_ small and  it's non-critical problem.
 		 */
 		SetPageReclaim(page);
+
+		/*
+		 * Move to the LRU_IMMEDIATE list to avoid being scanned
+		 * by page reclaim uselessly.
+		 */
+		list_move_tail(&page->lru, &zone->lru[LRU_IMMEDIATE].list);
+		__mod_zone_page_state(zone, NR_IMMEDIATE, 1);
 	} else {
 		/*
 		 * The page's writeback ends up during pagevec
diff -puN mm/vmscan.c~mm-isolate-pages-for-immediate-reclaim-on-their-own-lru mm/vmscan.c
--- a/mm/vmscan.c~mm-isolate-pages-for-immediate-reclaim-on-their-own-lru
+++ a/mm/vmscan.c
@@ -1392,6 +1392,17 @@ putback_lru_pages(struct zone *zone, str
 		}
 		SetPageLRU(page);
 		lru = page_lru(page);
+
+		/*
+		 * If reclaim has tagged a file page reclaim, move it to
+		 * a separate LRU lists to avoid it being scanned by other
+		 * users. It is expected that as writeback completes that
+		 * they are taken back off and moved to the normal LRU
+		 */
+		if (lru == LRU_INACTIVE_FILE &&
+				PageReclaim(page) && PageWriteback(page))
+			lru = LRU_IMMEDIATE;
+
 		add_page_to_lru_list(zone, page, lru);
 		if (is_active_lru(lru)) {
 			int file = is_file_lru(lru);
diff -puN mm/vmstat.c~mm-isolate-pages-for-immediate-reclaim-on-their-own-lru mm/vmstat.c
--- a/mm/vmstat.c~mm-isolate-pages-for-immediate-reclaim-on-their-own-lru
+++ a/mm/vmstat.c
@@ -688,6 +688,7 @@ const char * const vmstat_text[] = {
 	"nr_active_anon",
 	"nr_inactive_file",
 	"nr_active_file",
+	"nr_immediate",
 	"nr_unevictable",
 	"nr_mlock",
 	"nr_anon_pages",
@@ -756,6 +757,7 @@ const char * const vmstat_text[] = {
 	"allocstall",
 
 	"pgrotated",
+	"pgrescued",
 
 #ifdef CONFIG_COMPACTION
 	"compact_blocks_moved",
_
Subject: Subject: mm: isolate pages for immediate reclaim on their own LRU

Patches currently in -mm which might be from mgorman@suse.de are

linux-next.patch
mm-page-writebackc-make-determine_dirtyable_memory-static-again.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes-checkpatch-fixes.patch
mm-avoid-livelock-on-__gfp_fs-allocations-v2.patch
mm-more-intensive-memory-corruption-debug.patch
mm-more-intensive-memory-corruption-debug-fix.patch
pm-hibernate-do-not-count-debug-pages-as-savable.patch
slub-min-order-when-debug_guardpage_minorder-0.patch
mm-debug-test-for-online-nid-when-allocating-on-single-node.patch
mm-exclude-reserved-pages-from-dirtyable-memory.patch
mm-exclude-reserved-pages-from-dirtyable-memory-fix.patch
mm-try-to-distribute-dirty-pages-fairly-across-zones.patch
mm-filemap-pass-__gfp_write-from-grab_cache_page_write_begin.patch
btrfs-pass-__gfp_write-for-buffered-write-page-allocations.patch
mm-compaction-push-isolate-search-base-of-compact-control-one-pfn-ahead.patch
mm-fix-off-by-two-in-__zone_watermark_ok.patch
mremap-enforce-rmap-src-dst-vma-ordering-in-case-of-vma_merge-succeeding-in-copy_vma.patch
mremap-enforce-rmap-src-dst-vma-ordering-in-case-of-vma_merge-succeeding-in-copy_vma-update.patch
mm-do-not-stall-in-synchronous-compaction-for-thp-allocations.patch
revert-mm-do-not-stall-in-synchronous-compaction-for-thp-allocations.patch
mm-compaction-allow-compaction-to-isolate-dirty-pages.patch
mm-compaction-use-synchronous-compaction-for-proc-sys-vm-compact_memory.patch
mm-vmscan-check-if-we-isolated-a-compound-page-during-lumpy-scan.patch
mm-vmscan-do-not-oom-if-aborting-reclaim-to-start-compaction.patch
mm-compaction-determine-if-dirty-pages-can-be-migrated-without-blocking-within-migratepage.patch
mm-compaction-make-isolate_lru_page-filter-aware-again.patch
mm-page-allocator-do-not-call-direct-reclaim-for-thp-allocations-while-compaction-is-deferred.patch
mm-compaction-introduce-sync-light-migration-for-use-by-compaction.patch
mm-vmscan-when-reclaiming-for-compaction-ensure-there-are-sufficient-free-pages-available.patch
mm-vmscan-check-if-reclaim-should-really-abort-even-if-compaction_ready-is-true-for-one-zone.patch
mm-isolate-pages-for-immediate-reclaim-on-their-own-lru.patch

