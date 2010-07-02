From: akpm@linux-foundation.org
Subject: + vmscan-update-isolated-page-counters-outside-of-main-path-in-shrink_inactive_list.patch added to -mm tree
Date: Fri, 02 Jul 2010 13:07:07 -0700
Message-ID: <201007022007.o62K77C4024281@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50743 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757575Ab0GBUHz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jul 2010 16:07:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, aarcange@redhat.com, chris.mason@oracle.com, david@fromorbit.com, hannes@cmpxchg.org, hch@infradead.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mrubin@google.com, npiggin@suse.de, riel@redhat.com


The patch titled
     vmscan: update isolated page counters outside of main path in shrink_inactive_list()
has been added to the -mm tree.  Its filename is
     vmscan-update-isolated-page-counters-outside-of-main-path-in-shrink_inactive_list.patch

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
Subject: vmscan: update isolated page counters outside of main path in shrink_inactive_list()
From: Mel Gorman <mel@csn.ul.ie>

When shrink_inactive_list() isolates pages, it updates a number of
counters using temporary variables to gather them.  These consume stack
and it's in the main path that calls ->writepage().  This patch moves the
accounting updates outside of the main path to reduce stack usage.

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

 mm/vmscan.c |   63 ++++++++++++++++++++++++++++++--------------------
 1 file changed, 38 insertions(+), 25 deletions(-)

diff -puN mm/vmscan.c~vmscan-update-isolated-page-counters-outside-of-main-path-in-shrink_inactive_list mm/vmscan.c
--- a/mm/vmscan.c~vmscan-update-isolated-page-counters-outside-of-main-path-in-shrink_inactive_list
+++ a/mm/vmscan.c
@@ -1074,7 +1074,8 @@ static unsigned long clear_active_flags(
 			ClearPageActive(page);
 			nr_active++;
 		}
-		count[lru]++;
+		if (count)
+			count[lru]++;
 	}
 
 	return nr_active;
@@ -1154,12 +1155,13 @@ static int too_many_isolated(struct zone
  * TODO: Try merging with migrations version of putback_lru_pages
  */
 static noinline_for_stack void
-putback_lru_pages(struct zone *zone, struct zone_reclaim_stat *reclaim_stat,
+putback_lru_pages(struct zone *zone, struct scan_control *sc,
 				unsigned long nr_anon, unsigned long nr_file,
 				struct list_head *page_list)
 {
 	struct page *page;
 	struct pagevec pvec;
+	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
 
 	pagevec_init(&pvec, 1);
 
@@ -1198,6 +1200,37 @@ putback_lru_pages(struct zone *zone, str
 	pagevec_release(&pvec);
 }
 
+static noinline_for_stack void update_isolated_counts(struct zone *zone,
+					struct scan_control *sc,
+					unsigned long *nr_anon,
+					unsigned long *nr_file,
+					struct list_head *isolated_list)
+{
+	unsigned long nr_active;
+	unsigned int count[NR_LRU_LISTS] = { 0, };
+	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
+
+	nr_active = clear_active_flags(isolated_list, count);
+	__count_vm_events(PGDEACTIVATE, nr_active);
+
+	__mod_zone_page_state(zone, NR_ACTIVE_FILE,
+			      -count[LRU_ACTIVE_FILE]);
+	__mod_zone_page_state(zone, NR_INACTIVE_FILE,
+			      -count[LRU_INACTIVE_FILE]);
+	__mod_zone_page_state(zone, NR_ACTIVE_ANON,
+			      -count[LRU_ACTIVE_ANON]);
+	__mod_zone_page_state(zone, NR_INACTIVE_ANON,
+			      -count[LRU_INACTIVE_ANON]);
+
+	*nr_anon = count[LRU_ACTIVE_ANON] + count[LRU_INACTIVE_ANON];
+	*nr_file = count[LRU_ACTIVE_FILE] + count[LRU_INACTIVE_FILE];
+	__mod_zone_page_state(zone, NR_ISOLATED_ANON, *nr_anon);
+	__mod_zone_page_state(zone, NR_ISOLATED_FILE, *nr_file);
+
+	reclaim_stat->recent_scanned[0] += *nr_anon;
+	reclaim_stat->recent_scanned[1] += *nr_file;
+}
+
 /*
  * shrink_inactive_list() is a helper for shrink_zone().  It returns the number
  * of reclaimed pages
@@ -1209,10 +1242,8 @@ shrink_inactive_list(unsigned long nr_to
 	LIST_HEAD(page_list);
 	unsigned long nr_scanned;
 	unsigned long nr_reclaimed = 0;
-	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
 	unsigned long nr_taken;
 	unsigned long nr_active;
-	unsigned int count[NR_LRU_LISTS] = { 0, };
 	unsigned long nr_anon;
 	unsigned long nr_file;
 
@@ -1259,25 +1290,7 @@ shrink_inactive_list(unsigned long nr_to
 		return 0;
 	}
 
-	nr_active = clear_active_flags(&page_list, count);
-	__count_vm_events(PGDEACTIVATE, nr_active);
-
-	__mod_zone_page_state(zone, NR_ACTIVE_FILE,
-					-count[LRU_ACTIVE_FILE]);
-	__mod_zone_page_state(zone, NR_INACTIVE_FILE,
-					-count[LRU_INACTIVE_FILE]);
-	__mod_zone_page_state(zone, NR_ACTIVE_ANON,
-					-count[LRU_ACTIVE_ANON]);
-	__mod_zone_page_state(zone, NR_INACTIVE_ANON,
-					-count[LRU_INACTIVE_ANON]);
-
-	nr_anon = count[LRU_ACTIVE_ANON] + count[LRU_INACTIVE_ANON];
-	nr_file = count[LRU_ACTIVE_FILE] + count[LRU_INACTIVE_FILE];
-	__mod_zone_page_state(zone, NR_ISOLATED_ANON, nr_anon);
-	__mod_zone_page_state(zone, NR_ISOLATED_FILE, nr_file);
-
-	reclaim_stat->recent_scanned[0] += nr_anon;
-	reclaim_stat->recent_scanned[1] += nr_file;
+	update_isolated_counts(zone, sc, &nr_anon, &nr_file, &page_list);
 
 	spin_unlock_irq(&zone->lru_lock);
 
@@ -1297,7 +1310,7 @@ shrink_inactive_list(unsigned long nr_to
 		 * The attempt at page out may have made some
 		 * of the pages active, mark them inactive again.
 		 */
-		nr_active = clear_active_flags(&page_list, count);
+		nr_active = clear_active_flags(&page_list, NULL);
 		count_vm_events(PGDEACTIVATE, nr_active);
 
 		nr_reclaimed += shrink_page_list(&page_list, sc, PAGEOUT_IO_SYNC);
@@ -1308,7 +1321,7 @@ shrink_inactive_list(unsigned long nr_to
 		__count_vm_events(KSWAPD_STEAL, nr_reclaimed);
 	__count_zone_vm_events(PGSTEAL, zone, nr_reclaimed);
 
-	putback_lru_pages(zone, reclaim_stat, nr_anon, nr_file, &page_list);
+	putback_lru_pages(zone, sc, nr_anon, nr_file, &page_list);
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

