From: akpm@linux-foundation.org
Subject: + mm-memcg-get_lru_size-not-get_lruvec_size.patch added to -mm tree
Date: Tue, 15 May 2012 15:39:25 -0700
Message-ID: <20120515223926.7F475A0444@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:39512 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966244Ab2EOWj2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 May 2012 18:39:28 -0400
Received: by wgbdt11 with SMTP id dt11so4173wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 15 May 2012 15:39:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, khlebnikov@openvz.org, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     Subject: mm/memcg: get_lru_size not get_lruvec_size
has been added to the -mm tree.  Its filename is
     mm-memcg-get_lru_size-not-get_lruvec_size.patch

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
Subject: mm/memcg: get_lru_size not get_lruvec_size

Konstantin just introduced mem_cgroup_get_lruvec_size() and
get_lruvec_size(), I'm about to add mem_cgroup_update_lru_size(): but
we're dealing with the same thing, lru_size[lru].  We ought to agree on
the naming, and I do think lru_size is the more correct: so rename his
ones to get_lru_size().

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 ++--
 mm/memcontrol.c            |   10 +++++-----
 mm/vmscan.c                |   19 +++++++++----------
 3 files changed, 16 insertions(+), 17 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcg-get_lru_size-not-get_lruvec_size include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcg-get_lru_size-not-get_lruvec_size
+++ a/include/linux/memcontrol.h
@@ -122,7 +122,7 @@ void mem_cgroup_iter_break(struct mem_cg
 int mem_cgroup_inactive_anon_is_low(struct lruvec *lruvec);
 int mem_cgroup_inactive_file_is_low(struct lruvec *lruvec);
 int mem_cgroup_select_victim_node(struct mem_cgroup *memcg);
-unsigned long mem_cgroup_get_lruvec_size(struct lruvec *lruvec, enum lru_list);
+unsigned long mem_cgroup_get_lru_size(struct lruvec *lruvec, enum lru_list);
 struct zone_reclaim_stat*
 mem_cgroup_get_reclaim_stat_from_page(struct page *page);
 extern void mem_cgroup_print_oom_info(struct mem_cgroup *memcg,
@@ -341,7 +341,7 @@ mem_cgroup_inactive_file_is_low(struct l
 }
 
 static inline unsigned long
-mem_cgroup_get_lruvec_size(struct lruvec *lruvec, enum lru_list lru)
+mem_cgroup_get_lru_size(struct lruvec *lruvec, enum lru_list lru)
 {
 	return 0;
 }
diff -puN mm/memcontrol.c~mm-memcg-get_lru_size-not-get_lruvec_size mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-get_lru_size-not-get_lruvec_size
+++ a/mm/memcontrol.c
@@ -758,7 +758,7 @@ static void mem_cgroup_charge_statistics
 }
 
 unsigned long
-mem_cgroup_get_lruvec_size(struct lruvec *lruvec, enum lru_list lru)
+mem_cgroup_get_lru_size(struct lruvec *lruvec, enum lru_list lru)
 {
 	struct mem_cgroup_per_zone *mz;
 
@@ -1250,8 +1250,8 @@ int mem_cgroup_inactive_anon_is_low(stru
 	unsigned long active;
 	unsigned long gb;
 
-	inactive = mem_cgroup_get_lruvec_size(lruvec, LRU_INACTIVE_ANON);
-	active = mem_cgroup_get_lruvec_size(lruvec, LRU_ACTIVE_ANON);
+	inactive = mem_cgroup_get_lru_size(lruvec, LRU_INACTIVE_ANON);
+	active = mem_cgroup_get_lru_size(lruvec, LRU_ACTIVE_ANON);
 
 	gb = (inactive + active) >> (30 - PAGE_SHIFT);
 	if (gb)
@@ -1267,8 +1267,8 @@ int mem_cgroup_inactive_file_is_low(stru
 	unsigned long active;
 	unsigned long inactive;
 
-	inactive = mem_cgroup_get_lruvec_size(lruvec, LRU_INACTIVE_FILE);
-	active = mem_cgroup_get_lruvec_size(lruvec, LRU_ACTIVE_FILE);
+	inactive = mem_cgroup_get_lru_size(lruvec, LRU_INACTIVE_FILE);
+	active = mem_cgroup_get_lru_size(lruvec, LRU_ACTIVE_FILE);
 
 	return (active > inactive);
 }
diff -puN mm/vmscan.c~mm-memcg-get_lru_size-not-get_lruvec_size mm/vmscan.c
--- a/mm/vmscan.c~mm-memcg-get_lru_size-not-get_lruvec_size
+++ a/mm/vmscan.c
@@ -145,10 +145,10 @@ static bool global_reclaim(struct scan_c
 }
 #endif
 
-static unsigned long get_lruvec_size(struct lruvec *lruvec, enum lru_list lru)
+static unsigned long get_lru_size(struct lruvec *lruvec, enum lru_list lru)
 {
 	if (!mem_cgroup_disabled())
-		return mem_cgroup_get_lruvec_size(lruvec, lru);
+		return mem_cgroup_get_lru_size(lruvec, lru);
 
 	return zone_page_state(lruvec_zone(lruvec), NR_LRU_BASE + lru);
 }
@@ -1608,10 +1608,10 @@ static void get_scan_count(struct lruvec
 		goto out;
 	}
 
-	anon  = get_lruvec_size(lruvec, LRU_ACTIVE_ANON) +
-		get_lruvec_size(lruvec, LRU_INACTIVE_ANON);
-	file  = get_lruvec_size(lruvec, LRU_ACTIVE_FILE) +
-		get_lruvec_size(lruvec, LRU_INACTIVE_FILE);
+	anon  = get_lru_size(lruvec, LRU_ACTIVE_ANON) +
+		get_lru_size(lruvec, LRU_INACTIVE_ANON);
+	file  = get_lru_size(lruvec, LRU_ACTIVE_FILE) +
+		get_lru_size(lruvec, LRU_INACTIVE_FILE);
 
 	if (global_reclaim(sc)) {
 		free  = zone_page_state(zone, NR_FREE_PAGES);
@@ -1674,7 +1674,7 @@ out:
 		int file = is_file_lru(lru);
 		unsigned long scan;
 
-		scan = get_lruvec_size(lruvec, lru);
+		scan = get_lru_size(lruvec, lru);
 		if (sc->priority || noswap) {
 			scan >>= sc->priority;
 			if (!scan && force_scan)
@@ -1743,10 +1743,9 @@ static inline bool should_continue_recla
 	 * inactive lists are large enough, continue reclaiming
 	 */
 	pages_for_compaction = (2UL << sc->order);
-	inactive_lru_pages = get_lruvec_size(lruvec, LRU_INACTIVE_FILE);
+	inactive_lru_pages = get_lru_size(lruvec, LRU_INACTIVE_FILE);
 	if (nr_swap_pages > 0)
-		inactive_lru_pages += get_lruvec_size(lruvec,
-						      LRU_INACTIVE_ANON);
+		inactive_lru_pages += get_lru_size(lruvec, LRU_INACTIVE_ANON);
 	if (sc->nr_reclaimed < pages_for_compaction &&
 			inactive_lru_pages > pages_for_compaction)
 		return true;
_
Subject: Subject: mm/memcg: get_lru_size not get_lruvec_size

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

