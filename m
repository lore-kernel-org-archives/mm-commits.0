From: akpm@linux-foundation.org
Subject: + vmscan-set-up-pagevec-as-late-as-possible-in-shrink_inactive_list.patch added to -mm tree
Date: Fri, 02 Jul 2010 13:06:59 -0700
Message-ID: <201007022006.o62K6x28024264@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34879 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757575Ab0GBUH1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jul 2010 16:07:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, aarcange@redhat.com, chris.mason@oracle.com, david@fromorbit.com, hannes@cmpxchg.org, hch@infradead.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mrubin@google.com, npiggin@suse.de, riel@redhat.com


The patch titled
     vmscan: set up pagevec as late as possible in shrink_inactive_list()
has been added to the -mm tree.  Its filename is
     vmscan-set-up-pagevec-as-late-as-possible-in-shrink_inactive_list.patch

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
Subject: vmscan: set up pagevec as late as possible in shrink_inactive_list()
From: Mel Gorman <mel@csn.ul.ie>

shrink_inactive_list() sets up a pagevec to release unfreeable pages.  It
uses significant amounts of stack doing this.  This patch splits
shrink_inactive_list() to take the stack usage out of the main path so
that callers to writepage() do not contain an unused pagevec on the stack.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michael Rubin <mrubin@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   99 ++++++++++++++++++++++++++++----------------------
 1 file changed, 56 insertions(+), 43 deletions(-)

diff -puN mm/vmscan.c~vmscan-set-up-pagevec-as-late-as-possible-in-shrink_inactive_list mm/vmscan.c
--- a/mm/vmscan.c~vmscan-set-up-pagevec-as-late-as-possible-in-shrink_inactive_list
+++ a/mm/vmscan.c
@@ -1131,19 +1131,65 @@ static int too_many_isolated(struct zone
 }
 
 /*
+ * TODO: Try merging with migrations version of putback_lru_pages
+ */
+static noinline_for_stack void
+putback_lru_pages(struct zone *zone, struct zone_reclaim_stat *reclaim_stat,
+				unsigned long nr_anon, unsigned long nr_file,
+				struct list_head *page_list)
+{
+	struct page *page;
+	struct pagevec pvec;
+
+	pagevec_init(&pvec, 1);
+
+	/*
+	 * Put back any unfreeable pages.
+	 */
+	spin_lock(&zone->lru_lock);
+	while (!list_empty(page_list)) {
+		int lru;
+		page = lru_to_page(page_list);
+		VM_BUG_ON(PageLRU(page));
+		list_del(&page->lru);
+		if (unlikely(!page_evictable(page, NULL))) {
+			spin_unlock_irq(&zone->lru_lock);
+			putback_lru_page(page);
+			spin_lock_irq(&zone->lru_lock);
+			continue;
+		}
+		SetPageLRU(page);
+		lru = page_lru(page);
+		add_page_to_lru_list(zone, page, lru);
+		if (is_active_lru(lru)) {
+			int file = is_file_lru(lru);
+			reclaim_stat->recent_rotated[file]++;
+		}
+		if (!pagevec_add(&pvec, page)) {
+			spin_unlock_irq(&zone->lru_lock);
+			__pagevec_release(&pvec);
+			spin_lock_irq(&zone->lru_lock);
+		}
+	}
+	__mod_zone_page_state(zone, NR_ISOLATED_ANON, -nr_anon);
+	__mod_zone_page_state(zone, NR_ISOLATED_FILE, -nr_file);
+
+	spin_unlock_irq(&zone->lru_lock);
+	pagevec_release(&pvec);
+}
+
+/*
  * shrink_inactive_list() is a helper for shrink_zone().  It returns the number
  * of reclaimed pages
  */
-static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
-			struct zone *zone, struct scan_control *sc,
-			int priority, int file)
+static noinline_for_stack unsigned long
+shrink_inactive_list(unsigned long nr_to_scan, struct zone *zone,
+			struct scan_control *sc, int priority, int file)
 {
 	LIST_HEAD(page_list);
-	struct pagevec pvec;
 	unsigned long nr_scanned;
 	unsigned long nr_reclaimed = 0;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
-	struct page *page;
 	unsigned long nr_taken;
 	unsigned long nr_active;
 	unsigned int count[NR_LRU_LISTS] = { 0, };
@@ -1159,8 +1205,6 @@ static unsigned long shrink_inactive_lis
 	}
 
 
-	pagevec_init(&pvec, 1);
-
 	lru_add_drain();
 	spin_lock_irq(&zone->lru_lock);
 
@@ -1190,8 +1234,10 @@ static unsigned long shrink_inactive_lis
 		 */
 	}
 
-	if (nr_taken == 0)
-		goto done;
+	if (nr_taken == 0) {
+		spin_unlock_irq(&zone->lru_lock);
+		return 0;
+	}
 
 	nr_active = clear_active_flags(&page_list, count);
 	__count_vm_events(PGDEACTIVATE, nr_active);
@@ -1242,40 +1288,7 @@ static unsigned long shrink_inactive_lis
 		__count_vm_events(KSWAPD_STEAL, nr_reclaimed);
 	__count_zone_vm_events(PGSTEAL, zone, nr_reclaimed);
 
-	spin_lock(&zone->lru_lock);
-	/*
-	 * Put back any unfreeable pages.
-	 */
-	while (!list_empty(&page_list)) {
-		int lru;
-		page = lru_to_page(&page_list);
-		VM_BUG_ON(PageLRU(page));
-		list_del(&page->lru);
-		if (unlikely(!page_evictable(page, NULL))) {
-			spin_unlock_irq(&zone->lru_lock);
-			putback_lru_page(page);
-			spin_lock_irq(&zone->lru_lock);
-			continue;
-		}
-		SetPageLRU(page);
-		lru = page_lru(page);
-		add_page_to_lru_list(zone, page, lru);
-		if (is_active_lru(lru)) {
-			int file = is_file_lru(lru);
-			reclaim_stat->recent_rotated[file]++;
-		}
-		if (!pagevec_add(&pvec, page)) {
-			spin_unlock_irq(&zone->lru_lock);
-			__pagevec_release(&pvec);
-			spin_lock_irq(&zone->lru_lock);
-		}
-	}
-	__mod_zone_page_state(zone, NR_ISOLATED_ANON, -nr_anon);
-	__mod_zone_page_state(zone, NR_ISOLATED_FILE, -nr_file);
-
-done:
-	spin_unlock_irq(&zone->lru_lock);
-	pagevec_release(&pvec);
+	putback_lru_pages(zone, reclaim_stat, nr_anon, nr_file, &page_list);
 	return nr_reclaimed;
 }
 
_

Patches currently in -mm which might be from mel@csn.ul.ie are

mm-vmscan-fix-mapping-use-after-free.patch
linux-next.patch
hugetlb-call-mmu-notifiers-on-hugepage-cow.patch
mm-rename-anon_vma_lock-to-vma_lock_anon_vma.patch
mm-change-direct-call-of-spin_lockanon_vma-lock-to-inline-function.patch
mm-track-the-root-oldest-anon_vma.patch
mm-always-lock-the-root-oldest-anon_vma.patch
mm-extend-ksm-refcounts-to-the-anon_vma-root.patch
mm-extend-ksm-refcounts-to-the-anon_vma-root-fix.patch
vmscan-tracing-add-trace-events-for-kswapd-wakeup-sleeping-and-direct-reclaim.patch
vmscan-tracing-add-trace-events-for-lru-page-isolation.patch
vmscan-tracing-add-trace-events-for-lru-page-isolation-checkpatch-fixes.patch
vmscan-tracing-add-trace-event-when-a-page-is-written.patch
vmscan-tracing-add-a-postprocessing-script-for-reclaim-related-ftrace-events.patch
vmscan-kill-prev_priority-completely.patch
vmscan-simplify-shrink_inactive_list.patch
vmscan-simplify-shrink_inactive_list-checkpatch-fixes.patch
vmscan-remove-unnecessary-temporary-vars-in-do_try_to_free_pages.patch
vmscan-remove-unnecessary-temporary-vars-in-do_try_to_free_pages-checkpatch-fixes.patch
vmscan-set-up-pagevec-as-late-as-possible-in-shrink_inactive_list.patch
vmscan-set-up-pagevec-as-late-as-possible-in-shrink_page_list.patch
vmscan-update-isolated-page-counters-outside-of-main-path-in-shrink_inactive_list.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
add-debugging-aid-for-memory-initialisation-problems.patch

