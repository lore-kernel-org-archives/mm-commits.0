From: akpm@linux-foundation.org
Subject: + mm-trivial-cleanups-in-vmscanc.patch added to -mm tree
Date: Tue, 15 May 2012 15:39:28 -0700
Message-ID: <20120515223928.E7C3BA0444@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:50541 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966244Ab2EOWjb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 May 2012 18:39:31 -0400
Received: by eaao13 with SMTP id o13so3597eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 15 May 2012 15:39:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, khlebnikov@openvz.org, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     Subject: mm: trivial cleanups in vmscan.c
has been added to the -mm tree.  Its filename is
     mm-trivial-cleanups-in-vmscanc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: mm: trivial cleanups in vmscan.c

Patches currently in -mm which might be from hughd@google.com are

linux-next.patch
mm-remove-swap-token-code.patch
mm-vmscan-remove-lumpy-reclaim.patch
mm-vmscan-do-not-stall-on-writeback-during-memory-compaction.patch
mm-vmscan-remove-reclaim_mode_t.patch
mm-mmapc-find_vma-remove-unnecessary-ifmm-check.patch
mm-mmapc-find_vma-remove-unnecessary-ifmm-check-fix.patch
mm-fork-fix-overflow-in-vma-length-when-copying-mmap-on-clone.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
bug-introduce-build_bug_on_invalid-macro.patch
bug-completely-remove-code-generated-by-disabled-vm_bug_on.patch
shmem-replace-page-if-mapping-excludes-its-zone.patch
tmpfs-enable-nosec-optimization.patch
tmpfs-optimize-clearing-when-writing.patch
tmpfs-support-fallocate-falloc_fl_punch_hole.patch
mm-fs-route-madv_remove-to-falloc_fl_punch_hole.patch
mm-fs-remove-truncate_range.patch
tmpfs-support-fallocate-preallocation.patch
tmpfs-undo-fallocation-on-failure.patch
tmpfs-quit-when-fallocate-fills-memory.patch
tmpfs-support-seek_data-and-seek_hole.patch
memcg-fix-change-behavior-of-shared-anon-at-moving-task.patch
memcg-swap-mem_cgroup_move_swap_account-never-needs-fixup.patch
memcg-swap-use-mem_cgroup_uncharge_swap.patch
mm-memcg-scanning_global_lru-means-mem_cgroup_disabled.patch
mm-memcg-move-reclaim_stat-into-lruvec.patch
mm-push-lru-index-into-shrink_active_list.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
mm-mark-mm-inline-functions-as-__always_inline.patch
mm-remove-lru-type-checks-from-__isolate_lru_page.patch
mm-memcg-kill-mem_cgroup_lru_del.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup.patch
memcg-add-mlock-statistic-in-memorystat.patch
memcg-add-mlock-statistic-in-memorystat-fix.patch
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
mm-memcg-get_lru_size-not-get_lruvec_size.patch
mm-trivial-cleanups-in-vmscanc.patch
mm-memcg-apply-add-del_page-to-lruvec.patch
mm-huge_memoryc-use-lockdep_assert_held.patch
proc-clean-up-proc-pid-environ-handling.patch
proc-remove-mm_for_maps.patch
proc-use-mm_access-instead-of-ptrace_may_access.patch
proc-report-file-anon-bit-in-proc-pid-pagemap.patch
proc-use-is_err_or_null.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
prio_tree-debugging-patch.patch

