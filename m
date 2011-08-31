From: akpm@linux-foundation.org
Subject: + memcg-skip-scanning-active-lists-based-on-individual-size.patch added to -mm tree
Date: Wed, 31 Aug 2011 16:33:47 -0700
Message-ID: <201108312333.p7VNXl7n001837@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60193 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752307Ab1HaXej (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Aug 2011 19:34:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jweiner@redhat.com, bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp, riel@redhat.com, yinghan@google.com


The patch titled
     memcg: skip scanning active lists based on individual size
has been added to the -mm tree.  Its filename is
     memcg-skip-scanning-active-lists-based-on-individual-size.patch

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
Subject: memcg: skip scanning active lists based on individual size
From: Johannes Weiner <jweiner@redhat.com>

Reclaim decides to skip scanning an active list when the corresponding
inactive list is above a certain size in comparison to leave the assumed
working set alone while there are still enough reclaim candidates around.

The memcg implementation of comparing those lists instead reports whether
the whole memcg is low on the requested type of inactive pages,
considering all nodes and zones.

This can lead to an oversized active list not being scanned because of the
state of the other lists in the memcg, as well as an active list being
scanned while its corresponding inactive list has enough pages.

Not only is this wrong, it's also a scalability hazard, because the global
memory state over all nodes and zones has to be gathered for each memcg
and zone scanned.

Make these calculations purely based on the size of the two LRU lists
that are actually affected by the outcome of the decision.

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <bsingharora@gmail.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   10 ++++--
 mm/memcontrol.c            |   51 +++++++++++------------------------
 mm/vmscan.c                |    4 +-
 3 files changed, 25 insertions(+), 40 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-skip-scanning-active-lists-based-on-individual-size include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-skip-scanning-active-lists-based-on-individual-size
+++ a/include/linux/memcontrol.h
@@ -116,8 +116,10 @@ extern void mem_cgroup_end_migration(str
 /*
  * For memory reclaim.
  */
-int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg);
-int mem_cgroup_inactive_file_is_low(struct mem_cgroup *memcg);
+int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg,
+				    struct zone *zone);
+int mem_cgroup_inactive_file_is_low(struct mem_cgroup *memcg,
+				    struct zone *zone);
 int mem_cgroup_select_victim_node(struct mem_cgroup *memcg);
 unsigned long mem_cgroup_zone_nr_lru_pages(struct mem_cgroup *memcg,
 					int nid, int zid, unsigned int lrumask);
@@ -314,13 +316,13 @@ static inline bool mem_cgroup_disabled(v
 }
 
 static inline int
-mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg)
+mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg, struct zone *zone)
 {
 	return 1;
 }
 
 static inline int
-mem_cgroup_inactive_file_is_low(struct mem_cgroup *memcg)
+mem_cgroup_inactive_file_is_low(struct mem_cgroup *memcg, struct zone *zone)
 {
 	return 1;
 }
diff -puN mm/memcontrol.c~memcg-skip-scanning-active-lists-based-on-individual-size mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-skip-scanning-active-lists-based-on-individual-size
+++ a/mm/memcontrol.c
@@ -1146,15 +1146,19 @@ int task_in_mem_cgroup(struct task_struc
 	return ret;
 }
 
-static int calc_inactive_ratio(struct mem_cgroup *memcg, unsigned long *present_pages)
+int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg, struct zone *zone)
 {
-	unsigned long active;
+	unsigned long inactive_ratio;
+	int nid = zone_to_nid(zone);
+	int zid = zone_idx(zone);
 	unsigned long inactive;
+	unsigned long active;
 	unsigned long gb;
-	unsigned long inactive_ratio;
 
-	inactive = mem_cgroup_nr_lru_pages(memcg, BIT(LRU_INACTIVE_ANON));
-	active = mem_cgroup_nr_lru_pages(memcg, BIT(LRU_ACTIVE_ANON));
+	inactive = mem_cgroup_zone_nr_lru_pages(memcg, nid, zid,
+						BIT(LRU_INACTIVE_ANON));
+	active = mem_cgroup_zone_nr_lru_pages(memcg, nid, zid,
+					      BIT(LRU_ACTIVE_ANON));
 
 	gb = (inactive + active) >> (30 - PAGE_SHIFT);
 	if (gb)
@@ -1162,39 +1166,20 @@ static int calc_inactive_ratio(struct me
 	else
 		inactive_ratio = 1;
 
-	if (present_pages) {
-		present_pages[0] = inactive;
-		present_pages[1] = active;
-	}
-
-	return inactive_ratio;
+	return inactive * inactive_ratio < active;
 }
 
-int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg)
-{
-	unsigned long active;
-	unsigned long inactive;
-	unsigned long present_pages[2];
-	unsigned long inactive_ratio;
-
-	inactive_ratio = calc_inactive_ratio(memcg, present_pages);
-
-	inactive = present_pages[0];
-	active = present_pages[1];
-
-	if (inactive * inactive_ratio < active)
-		return 1;
-
-	return 0;
-}
-
-int mem_cgroup_inactive_file_is_low(struct mem_cgroup *memcg)
+int mem_cgroup_inactive_file_is_low(struct mem_cgroup *memcg, struct zone *zone)
 {
 	unsigned long active;
 	unsigned long inactive;
+	int zid = zone_idx(zone);
+	int nid = zone_to_nid(zone);
 
-	inactive = mem_cgroup_nr_lru_pages(memcg, BIT(LRU_INACTIVE_FILE));
-	active = mem_cgroup_nr_lru_pages(memcg, BIT(LRU_ACTIVE_FILE));
+	inactive = mem_cgroup_zone_nr_lru_pages(memcg, nid, zid,
+						BIT(LRU_INACTIVE_FILE));
+	active = mem_cgroup_zone_nr_lru_pages(memcg, nid, zid,
+					      BIT(LRU_ACTIVE_FILE));
 
 	return (active > inactive);
 }
@@ -4293,8 +4278,6 @@ static int mem_control_stat_show(struct 
 	}
 
 #ifdef CONFIG_DEBUG_VM
-	cb->fill(cb, "inactive_ratio", calc_inactive_ratio(mem_cont, NULL));
-
 	{
 		int nid, zid;
 		struct mem_cgroup_per_zone *mz;
diff -puN mm/vmscan.c~memcg-skip-scanning-active-lists-based-on-individual-size mm/vmscan.c
--- a/mm/vmscan.c~memcg-skip-scanning-active-lists-based-on-individual-size
+++ a/mm/vmscan.c
@@ -1763,7 +1763,7 @@ static int inactive_anon_is_low(struct z
 	if (scanning_global_lru(sc))
 		low = inactive_anon_is_low_global(zone);
 	else
-		low = mem_cgroup_inactive_anon_is_low(sc->mem_cgroup);
+		low = mem_cgroup_inactive_anon_is_low(sc->mem_cgroup, zone);
 	return low;
 }
 #else
@@ -1806,7 +1806,7 @@ static int inactive_file_is_low(struct z
 	if (scanning_global_lru(sc))
 		low = inactive_file_is_low_global(zone);
 	else
-		low = mem_cgroup_inactive_file_is_low(sc->mem_cgroup);
+		low = mem_cgroup_inactive_file_is_low(sc->mem_cgroup, zone);
 	return low;
 }
 
_

Patches currently in -mm which might be from jweiner@redhat.com are

mm-change-isolate-mode-from-define-to-bitwise-type-fix.patch
mm-page-writebackc-document-bdi_min_ratio.patch
mm-vmscan-fix-force-scanning-small-targets-without-swap.patch
mm-vmscan-fix-force-scanning-small-targets-without-swap-fix.patch
mm-vmscan-drop-nr_force_scan-from-get_scan_count.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
mm-vmscan-remove-dead-code-related-to-lumpy-reclaim-waiting-on-pages-under-writeback.patch
xfs-warn-if-direct-reclaim-tries-to-writeback-pages.patch
ext4-warn-if-direct-reclaim-tries-to-writeback-pages.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-kswapd-except-in-high-priority.patch
mm-vmscan-throttle-reclaim-if-encountering-too-many-dirty-pages-under-writeback.patch
mm-vmscan-immediately-reclaim-end-of-lru-dirty-pages-when-writeback-completes.patch
mremap-check-for-overflow-using-deltas.patch
mremap-avoid-sending-one-ipi-per-page.patch
thp-mremap-support-and-tlb-optimization.patch
thp-mremap-support-and-tlb-optimization-fix.patch
thp-mremap-support-and-tlb-optimization-fix-fix.patch
mm-compaction-compact-unevictable-pages.patch
mm-compaction-accounting-fix.patch
memcg-remove-unneeded-preempt_disable.patch
memcg-skip-scanning-active-lists-based-on-individual-size.patch

