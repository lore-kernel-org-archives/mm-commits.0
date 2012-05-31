From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-push-lruvec-pointer-into-isolate_lru_pages.patch removed from -mm tree
Date: Thu, 31 May 2012 12:17:19 -0700
Message-ID: <20120531191719.5F587A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:35579 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932980Ab2EaTRU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:17:20 -0400
Received: by ggeh3 with SMTP id h3so135653gge.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:17:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: push lruvec pointer into isolate_lru_pages()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-push-lruvec-pointer-into-isolate_lru_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm/vmscan: push lruvec pointer into isolate_lru_pages()

Move the mem_cgroup_zone_lruvec() call from isolate_lru_pages() into
shrink_[in]active_list().  Further patches push it to shrink_zone() step
by step.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-push-lruvec-pointer-into-isolate_lru_pages mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-push-lruvec-pointer-into-isolate_lru_pages
+++ a/mm/vmscan.c
@@ -1027,7 +1027,7 @@ int __isolate_lru_page(struct page *page
  * Appropriate locks must be held before calling this function.
  *
  * @nr_to_scan:	The number of pages to look through on the list.
- * @mz:		The mem_cgroup_zone to pull pages from.
+ * @lruvec:	The LRU vector to pull pages from.
  * @dst:	The temp list to put pages on to.
  * @nr_scanned:	The number of pages that were scanned.
  * @sc:		The scan_control struct for this reclaim session
@@ -1037,17 +1037,15 @@ int __isolate_lru_page(struct page *page
  * returns how many pages were moved onto *@dst.
  */
 static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
-		struct mem_cgroup_zone *mz, struct list_head *dst,
+		struct lruvec *lruvec, struct list_head *dst,
 		unsigned long *nr_scanned, struct scan_control *sc,
 		isolate_mode_t mode, enum lru_list lru)
 {
-	struct lruvec *lruvec;
 	struct list_head *src;
 	unsigned long nr_taken = 0;
 	unsigned long scan;
 	int file = is_file_lru(lru);
 
-	lruvec = mem_cgroup_zone_lruvec(mz->zone, mz->mem_cgroup);
 	src = &lruvec->lists[lru];
 
 	for (scan = 0; scan < nr_to_scan && !list_empty(src); scan++) {
@@ -1274,6 +1272,7 @@ shrink_inactive_list(unsigned long nr_to
 	int file = is_file_lru(lru);
 	struct zone *zone = mz->zone;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(mz);
+	struct lruvec *lruvec = mem_cgroup_zone_lruvec(zone, mz->mem_cgroup);
 
 	while (unlikely(too_many_isolated(zone, file, sc))) {
 		congestion_wait(BLK_RW_ASYNC, HZ/10);
@@ -1292,8 +1291,8 @@ shrink_inactive_list(unsigned long nr_to
 
 	spin_lock_irq(&zone->lru_lock);
 
-	nr_taken = isolate_lru_pages(nr_to_scan, mz, &page_list, &nr_scanned,
-				     sc, isolate_mode, lru);
+	nr_taken = isolate_lru_pages(nr_to_scan, lruvec, &page_list,
+				     &nr_scanned, sc, isolate_mode, lru);
 	if (global_reclaim(sc)) {
 		zone->pages_scanned += nr_scanned;
 		if (current_is_kswapd())
@@ -1444,6 +1443,7 @@ static void shrink_active_list(unsigned 
 	isolate_mode_t isolate_mode = 0;
 	int file = is_file_lru(lru);
 	struct zone *zone = mz->zone;
+	struct lruvec *lruvec = mem_cgroup_zone_lruvec(zone, mz->mem_cgroup);
 
 	lru_add_drain();
 
@@ -1454,8 +1454,8 @@ static void shrink_active_list(unsigned 
 
 	spin_lock_irq(&zone->lru_lock);
 
-	nr_taken = isolate_lru_pages(nr_to_scan, mz, &l_hold, &nr_scanned, sc,
-				     isolate_mode, lru);
+	nr_taken = isolate_lru_pages(nr_to_scan, lruvec, &l_hold,
+				     &nr_scanned, sc, isolate_mode, lru);
 	if (global_reclaim(sc))
 		zone->pages_scanned += nr_scanned;
 
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
linux-next.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
proc-report-file-anon-bit-in-proc-pid-pagemap.patch
proc-smaps-carefully-handle-migration-entries.patch
proc-smaps-show-amount-of-nonlinear-ptes-in-vma.patch
proc-smaps-show-amount-of-hwpoison-pages.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch

