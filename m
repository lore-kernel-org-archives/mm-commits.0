From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-get_lru_size-not-get_lruvec_size.patch removed from -mm tree
Date: Thu, 31 May 2012 12:18:07 -0700
Message-ID: <20120531191807.6D24DA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:40976 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933002Ab2EaTSK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 May 2012 15:18:10 -0400
Received: by lagr15 with SMTP id r15so75779lag.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:18:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, khlebnikov@openvz.org, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: get_lru_size not get_lruvec_size
has been removed from the -mm tree.  Its filename was
     mm-memcg-get_lru_size-not-get_lruvec_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -121,7 +121,7 @@ void mem_cgroup_iter_break(struct mem_cg
 int mem_cgroup_inactive_anon_is_low(struct lruvec *lruvec);
 int mem_cgroup_inactive_file_is_low(struct lruvec *lruvec);
 int mem_cgroup_select_victim_node(struct mem_cgroup *memcg);
-unsigned long mem_cgroup_get_lruvec_size(struct lruvec *lruvec, enum lru_list);
+unsigned long mem_cgroup_get_lru_size(struct lruvec *lruvec, enum lru_list);
 struct zone_reclaim_stat*
 mem_cgroup_get_reclaim_stat_from_page(struct page *page);
 extern void mem_cgroup_print_oom_info(struct mem_cgroup *memcg,
@@ -340,7 +340,7 @@ mem_cgroup_inactive_file_is_low(struct l
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
@@ -737,7 +737,7 @@ static void mem_cgroup_charge_statistics
 }
 
 unsigned long
-mem_cgroup_get_lruvec_size(struct lruvec *lruvec, enum lru_list lru)
+mem_cgroup_get_lru_size(struct lruvec *lruvec, enum lru_list lru)
 {
 	struct mem_cgroup_per_zone *mz;
 
@@ -1229,8 +1229,8 @@ int mem_cgroup_inactive_anon_is_low(stru
 	unsigned long active;
 	unsigned long gb;
 
-	inactive = mem_cgroup_get_lruvec_size(lruvec, LRU_INACTIVE_ANON);
-	active = mem_cgroup_get_lruvec_size(lruvec, LRU_ACTIVE_ANON);
+	inactive = mem_cgroup_get_lru_size(lruvec, LRU_INACTIVE_ANON);
+	active = mem_cgroup_get_lru_size(lruvec, LRU_ACTIVE_ANON);
 
 	gb = (inactive + active) >> (30 - PAGE_SHIFT);
 	if (gb)
@@ -1246,8 +1246,8 @@ int mem_cgroup_inactive_file_is_low(stru
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
 		if (sc->priority || noswap || !vmscan_swappiness(sc)) {
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

