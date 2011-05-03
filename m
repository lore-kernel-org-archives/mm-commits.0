From: akpm@linux-foundation.org
Subject: + memcg-add-stats-to-monitor-soft_limit-reclaim-v2.patch added to -mm tree
Date: Tue, 03 May 2011 16:14:01 -0700
Message-ID: <201105032314.p43NE1Ae016380@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754331Ab1ECXOu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 May 2011 19:14:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghan@google.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp, riel@redhat.com


The patch titled
     memcg-add-stats-to-monitor-soft_limit-reclaim-v2
has been added to the -mm tree.  Its filename is
     memcg-add-stats-to-monitor-soft_limit-reclaim-v2.patch

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
Subject: memcg-add-stats-to-monitor-soft_limit-reclaim-v2
From: Ying Han <yinghan@google.com>

Extend the soft_limit reclaim stats to both global background reclaim and
global direct reclaim.

The following stats are renamed and added:

$cat /dev/cgroup/memory/A/memory.stat
soft_kswapd_steal 1053626
soft_kswapd_scan 1053693
soft_direct_steal 1481810
soft_direct_scan 1481996

changelog v2..v1:
1. rename the stats on soft_kswapd/direct_steal/scan.
2. fix the documentation to match the stat name.

Signed-off-by: Ying Han <yinghan@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |   16 +++++--
 mm/memcontrol.c                  |   64 +++++++++++++++++++++--------
 2 files changed, 59 insertions(+), 21 deletions(-)

diff -puN Documentation/cgroups/memory.txt~memcg-add-stats-to-monitor-soft_limit-reclaim-v2 Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-add-stats-to-monitor-soft_limit-reclaim-v2
+++ a/Documentation/cgroups/memory.txt
@@ -387,8 +387,14 @@ mapped_file	- # of bytes of mapped file 
 pgpgin		- # of pages paged in (equivalent to # of charging events).
 pgpgout		- # of pages paged out (equivalent to # of uncharging events).
 swap		- # of bytes of swap usage
-soft_steal	- # of pages reclaimed from global hierarchical reclaim
-soft_scan	- # of pages scanned from global hierarchical reclaim
+soft_kswapd_steal- # of pages reclaimed in global hierarchical reclaim from
+		background reclaim
+soft_kswapd_scan - # of pages scanned in global hierarchical reclaim from
+		background reclaim
+soft_direct_steal- # of pages reclaimed in global hierarchical reclaim from
+		direct reclaim
+soft_direct_scan- # of pages scanned in global hierarchical reclaim from
+		direct reclaim
 inactive_anon	- # of bytes of anonymous memory and swap cache memory on
 		LRU list.
 active_anon	- # of bytes of anonymous and swap cache memory on active
@@ -410,8 +416,10 @@ total_mapped_file	- sum of all children'
 total_pgpgin		- sum of all children's "pgpgin"
 total_pgpgout		- sum of all children's "pgpgout"
 total_swap		- sum of all children's "swap"
-total_soft_steal	- sum of all children's "soft_steal"
-total_soft_scan		- sum of all children's "soft_scan"
+total_soft_kswapd_steal	- sum of all children's "soft_kswapd_steal"
+total_soft_kswapd_scan	- sum of all children's "soft_kswapd_scan"
+total_soft_direct_steal	- sum of all children's "soft_direct_steal"
+total_soft_direct_scan	- sum of all children's "soft_direct_scan"
 total_inactive_anon	- sum of all children's "inactive_anon"
 total_active_anon	- sum of all children's "active_anon"
 total_inactive_file	- sum of all children's "inactive_file"
diff -puN mm/memcontrol.c~memcg-add-stats-to-monitor-soft_limit-reclaim-v2 mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-stats-to-monitor-soft_limit-reclaim-v2
+++ a/mm/memcontrol.c
@@ -94,10 +94,14 @@ enum mem_cgroup_events_index {
 	MEM_CGROUP_EVENTS_PGPGIN,	/* # of pages paged in */
 	MEM_CGROUP_EVENTS_PGPGOUT,	/* # of pages paged out */
 	MEM_CGROUP_EVENTS_COUNT,	/* # of pages paged in/out */
-	MEM_CGROUP_EVENTS_SOFT_STEAL,	/* # of pages reclaimed from */
-					/* soft reclaim               */
-	MEM_CGROUP_EVENTS_SOFT_SCAN,	/* # of pages scanned from */
-					/* soft reclaim               */
+	MEM_CGROUP_EVENTS_SOFT_KSWAPD_STEAL, /* # of pages reclaimed from */
+					/* soft reclaim in background reclaim */
+	MEM_CGROUP_EVENTS_SOFT_KSWAPD_SCAN, /* # of pages scanned from */
+					/* soft reclaim in background reclaim */
+	MEM_CGROUP_EVENTS_SOFT_DIRECT_STEAL, /* # of pages reclaimed from */
+					/* soft reclaim in direct reclaim */
+	MEM_CGROUP_EVENTS_SOFT_DIRECT_SCAN, /* # of pages scanned from */
+					/* soft reclaim in direct reclaim */
 	MEM_CGROUP_EVENTS_NSTATS,
 };
 /*
@@ -628,14 +632,30 @@ static void mem_cgroup_charge_statistics
 	preempt_enable();
 }
 
-static void mem_cgroup_soft_steal(struct mem_cgroup *mem, int val)
+static void mem_cgroup_soft_steal(struct mem_cgroup *mem, bool is_kswapd,
+				  int val)
 {
-	this_cpu_add(mem->stat->events[MEM_CGROUP_EVENTS_SOFT_STEAL], val);
+	if (is_kswapd)
+		this_cpu_add(
+			mem->stat->events[MEM_CGROUP_EVENTS_SOFT_KSWAPD_STEAL],
+									val);
+	else
+		this_cpu_add(
+			mem->stat->events[MEM_CGROUP_EVENTS_SOFT_DIRECT_STEAL],
+									val);
 }
 
-static void mem_cgroup_soft_scan(struct mem_cgroup *mem, int val)
-{
-	this_cpu_add(mem->stat->events[MEM_CGROUP_EVENTS_SOFT_SCAN], val);
+static void mem_cgroup_soft_scan(struct mem_cgroup *mem, bool is_kswapd,
+				 int val)
+{
+	if (is_kswapd)
+		this_cpu_add(
+			mem->stat->events[MEM_CGROUP_EVENTS_SOFT_KSWAPD_SCAN],
+									val);
+	else
+		this_cpu_add(
+			mem->stat->events[MEM_CGROUP_EVENTS_SOFT_DIRECT_SCAN],
+									val);
 }
 
 static unsigned long mem_cgroup_get_local_zonestat(struct mem_cgroup *mem,
@@ -1456,6 +1476,7 @@ static int mem_cgroup_hierarchical_recla
 	bool noswap = reclaim_options & MEM_CGROUP_RECLAIM_NOSWAP;
 	bool shrink = reclaim_options & MEM_CGROUP_RECLAIM_SHRINK;
 	bool check_soft = reclaim_options & MEM_CGROUP_RECLAIM_SOFT;
+	bool is_kswapd = false;
 	unsigned long excess;
 	unsigned long nr_scanned;
 
@@ -1465,6 +1486,9 @@ static int mem_cgroup_hierarchical_recla
 	if (root_mem->memsw_is_minimum)
 		noswap = true;
 
+	if (current_is_kswapd())
+		is_kswapd = true;
+
 	while (1) {
 		victim = mem_cgroup_select_victim(root_mem);
 		if (victim == root_mem) {
@@ -1505,8 +1529,8 @@ static int mem_cgroup_hierarchical_recla
 				noswap, get_swappiness(victim), zone,
 				&nr_scanned);
 			*total_scanned += nr_scanned;
-			mem_cgroup_soft_steal(victim, ret);
-			mem_cgroup_soft_scan(victim, nr_scanned);
+			mem_cgroup_soft_steal(victim, is_kswapd, ret);
+			mem_cgroup_soft_scan(victim, is_kswapd, nr_scanned);
 		} else
 			ret = try_to_free_mem_cgroup_pages(victim, gfp_mask,
 						noswap, get_swappiness(victim));
@@ -3800,8 +3824,10 @@ enum {
 	MCS_PGPGIN,
 	MCS_PGPGOUT,
 	MCS_SWAP,
-	MCS_SOFT_STEAL,
-	MCS_SOFT_SCAN,
+	MCS_SOFT_KSWAPD_STEAL,
+	MCS_SOFT_KSWAPD_SCAN,
+	MCS_SOFT_DIRECT_STEAL,
+	MCS_SOFT_DIRECT_SCAN,
 	MCS_INACTIVE_ANON,
 	MCS_ACTIVE_ANON,
 	MCS_INACTIVE_FILE,
@@ -3854,10 +3880,14 @@ mem_cgroup_get_local_stat(struct mem_cgr
 		val = mem_cgroup_read_stat(mem, MEM_CGROUP_STAT_SWAPOUT);
 		s->stat[MCS_SWAP] += val * PAGE_SIZE;
 	}
-	val = mem_cgroup_read_events(mem, MEM_CGROUP_EVENTS_SOFT_STEAL);
-	s->stat[MCS_SOFT_STEAL] += val;
-	val = mem_cgroup_read_events(mem, MEM_CGROUP_EVENTS_SOFT_SCAN);
-	s->stat[MCS_SOFT_SCAN] += val;
+	val = mem_cgroup_read_events(mem, MEM_CGROUP_EVENTS_SOFT_KSWAPD_STEAL);
+	s->stat[MCS_SOFT_KSWAPD_STEAL] += val;
+	val = mem_cgroup_read_events(mem, MEM_CGROUP_EVENTS_SOFT_KSWAPD_SCAN);
+	s->stat[MCS_SOFT_KSWAPD_SCAN] += val;
+	val = mem_cgroup_read_events(mem, MEM_CGROUP_EVENTS_SOFT_DIRECT_STEAL);
+	s->stat[MCS_SOFT_DIRECT_STEAL] += val;
+	val = mem_cgroup_read_events(mem, MEM_CGROUP_EVENTS_SOFT_DIRECT_SCAN);
+	s->stat[MCS_SOFT_DIRECT_SCAN] += val;
 
 	/* per zone stat */
 	val = mem_cgroup_get_local_zonestat(mem, LRU_INACTIVE_ANON);
_

Patches currently in -mm which might be from yinghan@google.com are

mm-check-pageunevictable-in-lru_deactivate_fn.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix-2.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-2.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-count-the-soft_limit-reclaim-in-global-background-reclaim.patch
memcg-add-the-soft_limit-reclaim-in-global-direct-reclaim.patch
memcg-add-stats-to-monitor-soft_limit-reclaim.patch
memcg-add-stats-to-monitor-soft_limit-reclaim-v2.patch
add-the-pagefault-count-into-memcg-stats.patch
add-the-pagefault-count-into-memcg-stats-fix.patch

