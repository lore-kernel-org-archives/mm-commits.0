From: akpm@linux-foundation.org
Subject: [merged] memcg-skip-scanning-active-lists-based-on-individual-size.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:27:02 -0800
Message-ID: <201111072027.pA7KR7Mr023690@hpaq11.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:47250 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab1KGU13 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:27:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jweiner@redhat.com, bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp, riel@redhat.com, yinghan


The patch titled
     Subject: memcg: skip scanning active lists based on individual size
has been removed from the -mm tree.  Its filename was
     memcg-skip-scanning-active-lists-based-on-individual-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johannes Weiner <jweiner@redhat.com>
Subject: memcg: skip scanning active lists based on individual size

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
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <bsingharora@gmail.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |    1 
 include/linux/memcontrol.h       |   10 +++--
 mm/memcontrol.c                  |   51 +++++++++--------------------
 mm/vmscan.c                      |    4 +-
 4 files changed, 25 insertions(+), 41 deletions(-)

diff -puN Documentation/cgroups/memory.txt~memcg-skip-scanning-active-lists-based-on-individual-size Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-skip-scanning-active-lists-based-on-individual-size
+++ a/Documentation/cgroups/memory.txt
@@ -418,7 +418,6 @@ total_unevictable	- sum of all children'
 
 # The following additional stats are dependent on CONFIG_DEBUG_VM.
 
-inactive_ratio		- VM internal parameter. (see mm/page_alloc.c)
 recent_rotated_anon	- VM internal parameter. (see mm/vmscan.c)
 recent_rotated_file	- VM internal parameter. (see mm/vmscan.c)
 recent_scanned_anon	- VM internal parameter. (see mm/vmscan.c)
diff -puN include/linux/memcontrol.h~memcg-skip-scanning-active-lists-based-on-individual-size include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-skip-scanning-active-lists-based-on-individual-size
+++ a/include/linux/memcontrol.h
@@ -106,8 +106,10 @@ extern void mem_cgroup_end_migration(str
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
@@ -295,13 +297,13 @@ static inline bool mem_cgroup_disabled(v
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
@@ -1104,15 +1104,19 @@ int task_in_mem_cgroup(struct task_struc
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
@@ -1120,39 +1124,20 @@ static int calc_inactive_ratio(struct me
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
@@ -4192,8 +4177,6 @@ static int mem_control_stat_show(struct 
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
@@ -1767,7 +1767,7 @@ static int inactive_anon_is_low(struct z
 	if (scanning_global_lru(sc))
 		low = inactive_anon_is_low_global(zone);
 	else
-		low = mem_cgroup_inactive_anon_is_low(sc->mem_cgroup);
+		low = mem_cgroup_inactive_anon_is_low(sc->mem_cgroup, zone);
 	return low;
 }
 #else
@@ -1810,7 +1810,7 @@ static int inactive_file_is_low(struct z
 	if (scanning_global_lru(sc))
 		low = inactive_file_is_low_global(zone);
 	else
-		low = mem_cgroup_inactive_file_is_low(sc->mem_cgroup);
+		low = mem_cgroup_inactive_file_is_low(sc->mem_cgroup, zone);
 	return low;
 }
 
_

Patches currently in -mm which might be from jweiner@redhat.com are

origin.patch
mm-add-extra-free-kbytes-tunable.patch

