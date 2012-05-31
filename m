From: akpm@linux-foundation.org
Subject: [merged] mm-trivial-cleanups-in-vmscanc.patch removed from -mm tree
Date: Thu, 31 May 2012 12:18:09 -0700
Message-ID: <20120531191809.6ABF0A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:57611 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933011Ab2EaTSK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:18:10 -0400
Received: by ghbz15 with SMTP id z15so134752ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:18:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, khlebnikov@openvz.org, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: trivial cleanups in vmscan.c
has been removed from the -mm tree.  Its filename was
     mm-trivial-cleanups-in-vmscanc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: trivial cleanups in vmscan.c

Utter trivia in mm/vmscan.c, mostly just reducing the linecount slightly;
most exciting change being get_scan_count() calling vmscan_swappiness()
once instead of twice.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   31 ++++++++++---------------------
 1 file changed, 10 insertions(+), 21 deletions(-)

diff -puN mm/vmscan.c~mm-trivial-cleanups-in-vmscanc mm/vmscan.c
--- a/mm/vmscan.c~mm-trivial-cleanups-in-vmscanc
+++ a/mm/vmscan.c
@@ -1025,12 +1025,9 @@ static unsigned long isolate_lru_pages(u
 		unsigned long *nr_scanned, struct scan_control *sc,
 		isolate_mode_t mode, enum lru_list lru)
 {
-	struct list_head *src;
+	struct list_head *src = &lruvec->lists[lru];
 	unsigned long nr_taken = 0;
 	unsigned long scan;
-	int file = is_file_lru(lru);
-
-	src = &lruvec->lists[lru];
 
 	for (scan = 0; scan < nr_to_scan && !list_empty(src); scan++) {
 		struct page *page;
@@ -1058,11 +1055,8 @@ static unsigned long isolate_lru_pages(u
 	}
 
 	*nr_scanned = scan;
-
-	trace_mm_vmscan_lru_isolate(sc->order,
-			nr_to_scan, scan,
-			nr_taken,
-			mode, file);
+	trace_mm_vmscan_lru_isolate(sc->order, nr_to_scan, scan,
+				    nr_taken, mode, is_file_lru(lru));
 	return nr_taken;
 }
 
@@ -1140,8 +1134,7 @@ static int too_many_isolated(struct zone
 }
 
 static noinline_for_stack void
-putback_inactive_pages(struct lruvec *lruvec,
-		       struct list_head *page_list)
+putback_inactive_pages(struct lruvec *lruvec, struct list_head *page_list)
 {
 	struct zone_reclaim_stat *reclaim_stat = &lruvec->reclaim_stat;
 	struct zone *zone = lruvec_zone(lruvec);
@@ -1235,11 +1228,9 @@ shrink_inactive_list(unsigned long nr_to
 	if (global_reclaim(sc)) {
 		zone->pages_scanned += nr_scanned;
 		if (current_is_kswapd())
-			__count_zone_vm_events(PGSCAN_KSWAPD, zone,
-					       nr_scanned);
+			__count_zone_vm_events(PGSCAN_KSWAPD, zone, nr_scanned);
 		else
-			__count_zone_vm_events(PGSCAN_DIRECT, zone,
-					       nr_scanned);
+			__count_zone_vm_events(PGSCAN_DIRECT, zone, nr_scanned);
 	}
 	spin_unlock_irq(&zone->lru_lock);
 
@@ -1534,9 +1525,9 @@ static int inactive_file_is_low(struct l
 	return inactive_file_is_low_global(lruvec_zone(lruvec));
 }
 
-static int inactive_list_is_low(struct lruvec *lruvec, int file)
+static int inactive_list_is_low(struct lruvec *lruvec, enum lru_list lru)
 {
-	if (file)
+	if (is_file_lru(lru))
 		return inactive_file_is_low(lruvec);
 	else
 		return inactive_anon_is_low(lruvec);
@@ -1545,10 +1536,8 @@ static int inactive_list_is_low(struct l
 static unsigned long shrink_list(enum lru_list lru, unsigned long nr_to_scan,
 				 struct lruvec *lruvec, struct scan_control *sc)
 {
-	int file = is_file_lru(lru);
-
 	if (is_active_lru(lru)) {
-		if (inactive_list_is_low(lruvec, file))
+		if (inactive_list_is_low(lruvec, lru))
 			shrink_active_list(nr_to_scan, lruvec, sc, lru);
 		return 0;
 	}
@@ -1630,7 +1619,7 @@ static void get_scan_count(struct lruvec
 	 * This scanning priority is essentially the inverse of IO cost.
 	 */
 	anon_prio = vmscan_swappiness(sc);
-	file_prio = 200 - vmscan_swappiness(sc);
+	file_prio = 200 - anon_prio;
 
 	/*
 	 * OK, so we have swap space and a fair amount of page cache
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
linux-next.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
proc-clean-up-proc-pid-environ-handling.patch
proc-remove-mm_for_maps.patch
proc-use-mm_access-instead-of-ptrace_may_access.patch
proc-report-file-anon-bit-in-proc-pid-pagemap.patch
proc-use-is_err_or_null.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
prio_tree-debugging-patch.patch

