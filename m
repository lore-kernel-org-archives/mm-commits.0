From: akpm@linux-foundation.org
Subject: + mm-isolate-pages-for-immediate-reclaim-on-their-own-lru-fix.patch added to -mm tree
Date: Mon, 19 Dec 2011 13:54:09 -0800
Message-ID: <20111219215410.5B7BD10008C@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:64334 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325Ab1LSVyL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Dec 2011 16:54:11 -0500
Received: by ggnv2 with SMTP id v2so770368ggn.1
        for <mm-commits@vger.kernel.org>; Mon, 19 Dec 2011 13:54:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, aarcange@redhat.com, adi@hexapodia.org, davej@redhat.com, jack@suse.cz, jweiner@redhat.com, minchan.kim@gmail.com, nai.xia@gmail.com, riel@redhat.com


The patch titled
     Subject: mm: isolate pages for immediate reclaim on their own LRU fix
has been added to the -mm tree.  Its filename is
     mm-isolate-pages-for-immediate-reclaim-on-their-own-lru-fix.patch

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
Subject: mm: isolate pages for immediate reclaim on their own LRU fix

Rename pagevec_putback_immediate_fn to pagevec_putback_from_immediate_fn
for clarity and alter flow of rotate_reclaimable_page() slightly to avoid
an unnecessary list reference.

This is a fix to the patch
mm-isolate-pages-for-immediate-reclaim-on-their-own-lru.patch in mmotm.

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

 mm/swap.c |   30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff -puN mm/swap.c~mm-isolate-pages-for-immediate-reclaim-on-their-own-lru-fix mm/swap.c
--- a/mm/swap.c~mm-isolate-pages-for-immediate-reclaim-on-their-own-lru-fix
+++ a/mm/swap.c
@@ -262,7 +262,7 @@ static void pagevec_move_tail(struct pag
  * moving a page from the LRU_IMMEDIATE to one of the [in]active_[file|anon]
  * lists
  */
-static void pagevec_putback_immediate_fn(struct page *page, void *arg)
+static void pagevec_putback_from_immediate_fn(struct page *page, void *arg)
 {
 	struct zone *zone = page_zone(page);
 
@@ -272,9 +272,9 @@ static void pagevec_putback_immediate_fn
 	}
 }
 
-static void pagevec_putback_immediate(struct pagevec *pvec)
+static void pagevec_putback_from_immediate(struct pagevec *pvec)
 {
-	pagevec_lru_move_fn(pvec, pagevec_putback_immediate_fn, NULL);
+	pagevec_lru_move_fn(pvec, pagevec_putback_from_immediate_fn, NULL);
 }
 
 /*
@@ -285,7 +285,7 @@ static void pagevec_putback_immediate(st
 void rotate_reclaimable_page(struct page *page)
 {
 	struct zone *zone = page_zone(page);
-	struct list_head *page_list;
+	struct list_head *list;
 	struct pagevec *pvec;
 	unsigned long flags;
 
@@ -302,7 +302,7 @@ void rotate_reclaimable_page(struct page
 	} else {
 		pvec = &__get_cpu_var(lru_putback_immediate_pvecs);
 		if (!pagevec_add(pvec, page))
-			pagevec_putback_immediate(pvec);
+			pagevec_putback_from_immediate(pvec);
 	}
 
 	/*
@@ -318,17 +318,21 @@ void rotate_reclaimable_page(struct page
 	 * problematic due to the problem of deciding when the right time
 	 * to scan this list is.
 	 */
-	page_list = &zone->lru[LRU_IMMEDIATE].list;
-	if (!zone_page_state(zone, NR_IMMEDIATE) && !list_empty(page_list)) {
+	if (!zone_page_state(zone, NR_IMMEDIATE)) {
 		struct page *page;
+		list = &zone->lru[LRU_IMMEDIATE].list;
 
-		spin_lock(&zone->lru_lock);
-		while (!list_empty(page_list)) {
-			page = list_entry(page_list->prev, struct page, lru);
-			list_move(&page->lru, &zone->lru[page_lru(page)].list);
-			__count_vm_event(PGRESCUED);
+		if (!list_empty(list)) {
+			spin_lock(&zone->lru_lock);
+			while (!list_empty(list)) {
+				int lru;
+				page = list_entry(list->prev, struct page, lru);
+				lru = page_lru(page);
+				list_move(&page->lru, &zone->lru[lru].list);
+				__count_vm_event(PGRESCUED);
+			}
+			spin_unlock(&zone->lru_lock);
 		}
-		spin_unlock(&zone->lru_lock);
 	}
 
 	local_irq_restore(flags);
_
Subject: Subject: mm: isolate pages for immediate reclaim on their own LRU fix

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
mm-isolate-pages-for-immediate-reclaim-on-their-own-lru-fix.patch

