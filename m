From: akpm@linux-foundation.org
Subject: + mm-vmscan-push-lruvec-pointer-into-get_scan_count.patch added to -mm tree
Date: Wed, 02 May 2012 14:21:32 -0700
Message-ID: <20120502212132.8A8C8A0413@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:47594 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab2EBVVd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 May 2012 17:21:33 -0400
Received: by mail-gy0-f202.google.com with SMTP id z15so123744ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 02 May 2012 14:21:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie


The patch titled
     Subject: mm/vmscan: push lruvec pointer into get_scan_count()
has been added to the -mm tree.  Its filename is
     mm-vmscan-push-lruvec-pointer-into-get_scan_count.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm/vmscan: push lruvec pointer into get_scan_count()

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-push-lruvec-pointer-into-get_scan_count mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-push-lruvec-pointer-into-get_scan_count
+++ a/mm/vmscan.c
@@ -150,11 +150,6 @@ static bool global_reclaim(struct scan_c
 }
 #endif
 
-static struct zone_reclaim_stat *get_reclaim_stat(struct mem_cgroup_zone *mz)
-{
-	return &mem_cgroup_zone_lruvec(mz->zone, mz->mem_cgroup)->reclaim_stat;
-}
-
 static unsigned long get_lruvec_size(struct lruvec *lruvec, enum lru_list lru)
 {
 	if (!mem_cgroup_disabled())
@@ -1581,20 +1576,18 @@ static int vmscan_swappiness(struct scan
  *
  * nr[0] = anon pages to scan; nr[1] = file pages to scan
  */
-static void get_scan_count(struct mem_cgroup_zone *mz, struct scan_control *sc,
+static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
 			   unsigned long *nr)
 {
 	unsigned long anon, file, free;
 	unsigned long anon_prio, file_prio;
 	unsigned long ap, fp;
-	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(mz);
+	struct zone_reclaim_stat *reclaim_stat = &lruvec->reclaim_stat;
 	u64 fraction[2], denominator;
 	enum lru_list lru;
 	int noswap = 0;
 	bool force_scan = false;
-	struct lruvec *lruvec;
-
-	lruvec = mem_cgroup_zone_lruvec(mz->zone, mz->mem_cgroup);
+	struct zone *zone = lruvec_zone(lruvec);
 
 	/*
 	 * If the zone or memcg is small, nr[l] can be 0.  This
@@ -1606,7 +1599,7 @@ static void get_scan_count(struct mem_cg
 	 * latencies, so it's better to scan a minimum amount there as
 	 * well.
 	 */
-	if (current_is_kswapd() && mz->zone->all_unreclaimable)
+	if (current_is_kswapd() && zone->all_unreclaimable)
 		force_scan = true;
 	if (!global_reclaim(sc))
 		force_scan = true;
@@ -1626,10 +1619,10 @@ static void get_scan_count(struct mem_cg
 		get_lruvec_size(lruvec, LRU_INACTIVE_FILE);
 
 	if (global_reclaim(sc)) {
-		free  = zone_page_state(mz->zone, NR_FREE_PAGES);
+		free  = zone_page_state(zone, NR_FREE_PAGES);
 		/* If we have very few page cache pages,
 		   force-scan anon pages. */
-		if (unlikely(file + free <= high_wmark_pages(mz->zone))) {
+		if (unlikely(file + free <= high_wmark_pages(zone))) {
 			fraction[0] = 1;
 			fraction[1] = 0;
 			denominator = 1;
@@ -1655,7 +1648,7 @@ static void get_scan_count(struct mem_cg
 	 *
 	 * anon in [0], file in [1]
 	 */
-	spin_lock_irq(&mz->zone->lru_lock);
+	spin_lock_irq(&zone->lru_lock);
 	if (unlikely(reclaim_stat->recent_scanned[0] > anon / 4)) {
 		reclaim_stat->recent_scanned[0] /= 2;
 		reclaim_stat->recent_rotated[0] /= 2;
@@ -1676,7 +1669,7 @@ static void get_scan_count(struct mem_cg
 
 	fp = (file_prio + 1) * (reclaim_stat->recent_scanned[1] + 1);
 	fp /= reclaim_stat->recent_rotated[1] + 1;
-	spin_unlock_irq(&mz->zone->lru_lock);
+	spin_unlock_irq(&zone->lru_lock);
 
 	fraction[0] = ap;
 	fraction[1] = fp;
@@ -1794,7 +1787,7 @@ static void shrink_mem_cgroup_zone(struc
 restart:
 	nr_reclaimed = 0;
 	nr_scanned = sc->nr_scanned;
-	get_scan_count(mz, sc, nr);
+	get_scan_count(lruvec, sc, nr);
 
 	blk_start_plug(&plug);
 	while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
_
Subject: Subject: mm/vmscan: push lruvec pointer into get_scan_count()

Patches currently in -mm which might be from khlebnikov@openvz.org are

linux-next.patch
proc-pagemap-correctly-report-non-present-ptes-and-holes-between-vmas.patch
mm-remove-swap-token-code.patch
mm-vmscan-remove-lumpy-reclaim.patch
mm-vmscan-do-not-stall-on-writeback-during-memory-compaction.patch
mm-vmscan-remove-reclaim_mode_t.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
kernel-cgroup-push-rcu-read-locking-from-css_is_ancestor-to-callsite.patch
mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy.patch
mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy-fix.patch
bug-introduce-build_bug_on_invalid-macro.patch
bug-completely-remove-code-generated-by-disabled-vm_bug_on.patch
mm-memcg-scanning_global_lru-means-mem_cgroup_disabled.patch
mm-memcg-move-reclaim_stat-into-lruvec.patch
mm-push-lru-index-into-shrink_active_list.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
mm-mark-mm-inline-functions-as-__always_inline.patch
mm-remove-lru-type-checks-from-__isolate_lru_page.patch
mm-memcg-kill-mem_cgroup_lru_del.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup.patch
mm-vmscan-store-priority-in-struct-scan_control.patch
mm-add-link-from-struct-lruvec-to-struct-zone.patch
mm-vmscan-push-lruvec-pointer-into-isolate_lru_pages.patch
mm-vmscan-push-zone-pointer-into-shrink_page_list.patch
mm-vmscan-remove-update_isolated_counts.patch
mm-vmscan-push-lruvec-pointer-into-putback_inactive_pages.patch
mm-vmscan-replace-zone_nr_lru_pages-with-get_lruvec_size.patch
mm-vmscan-push-lruvec-pointer-into-inactive_list_is_low.patch
mm-vmscan-push-lruvec-pointer-into-shrink_list.patch
mm-vmscan-push-lruvec-pointer-into-get_scan_count.patch
mm-vmscan-push-lruvec-pointer-into-should_continue_reclaim.patch
mm-vmscan-kill-struct-mem_cgroup_zone.patch
proc-report-file-anon-bit-in-proc-pid-pagemap.patch
proc-smaps-carefully-handle-migration-entries.patch
proc-smaps-show-amount-of-nonlinear-ptes-in-vma.patch
proc-smaps-show-amount-of-hwpoison-pages.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch

