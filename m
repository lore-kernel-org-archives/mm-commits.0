From: akpm@linux-foundation.org
Subject: + memcg-add-stats-to-monitor-soft_limit-reclaim.patch added to -mm tree
Date: Tue, 29 Mar 2011 14:53:03 -0700
Message-ID: <201103292153.p2TLr3wm007582@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49972 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751852Ab1C2VxX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Mar 2011 17:53:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghan@google.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp, riel@redhat.com


The patch titled
     memcg: add stats to monitor soft_limit reclaim
has been added to the -mm tree.  Its filename is
     memcg-add-stats-to-monitor-soft_limit-reclaim.patch

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
Subject: memcg: add stats to monitor soft_limit reclaim
From: Ying Han <yinghan@google.com>

The stat is added:

/dev/cgroup/*/memory.stat
soft_steal:        - # of pages reclaimed from soft_limit hierarchical reclaim
soft_scan:         - # of pages scanned from soft_limit hierarchical reclaim
total_soft_steal:  - # sum of all children's "soft_steal"
total_soft_scan:   - # sum of all children's "soft_scan"

Signed-off-by: Ying Han <yinghan@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |    4 ++++
 include/linux/memcontrol.h       |    1 -
 mm/memcontrol.c                  |   25 +++++++++++++++++++++++++
 3 files changed, 29 insertions(+), 1 deletion(-)

diff -puN Documentation/cgroups/memory.txt~memcg-add-stats-to-monitor-soft_limit-reclaim Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-add-stats-to-monitor-soft_limit-reclaim
+++ a/Documentation/cgroups/memory.txt
@@ -385,6 +385,8 @@ mapped_file	- # of bytes of mapped file 
 pgpgin		- # of pages paged in (equivalent to # of charging events).
 pgpgout		- # of pages paged out (equivalent to # of uncharging events).
 swap		- # of bytes of swap usage
+soft_steal	- # of pages reclaimed from global hierarchical reclaim
+soft_scan	- # of pages scanned from global hierarchical reclaim
 inactive_anon	- # of bytes of anonymous memory and swap cache memory on
 		LRU list.
 active_anon	- # of bytes of anonymous and swap cache memory on active
@@ -406,6 +408,8 @@ total_mapped_file	- sum of all children'
 total_pgpgin		- sum of all children's "pgpgin"
 total_pgpgout		- sum of all children's "pgpgout"
 total_swap		- sum of all children's "swap"
+total_soft_steal	- sum of all children's "soft_steal"
+total_soft_scan		- sum of all children's "soft_scan"
 total_inactive_anon	- sum of all children's "inactive_anon"
 total_active_anon	- sum of all children's "active_anon"
 total_inactive_file	- sum of all children's "inactive_file"
diff -puN include/linux/memcontrol.h~memcg-add-stats-to-monitor-soft_limit-reclaim include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-add-stats-to-monitor-soft_limit-reclaim
+++ a/include/linux/memcontrol.h
@@ -115,7 +115,6 @@ struct zone_reclaim_stat*
 mem_cgroup_get_reclaim_stat_from_page(struct page *page);
 extern void mem_cgroup_print_oom_info(struct mem_cgroup *memcg,
 					struct task_struct *p);
-
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
 extern int do_swap_account;
 #endif
diff -puN mm/memcontrol.c~memcg-add-stats-to-monitor-soft_limit-reclaim mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-stats-to-monitor-soft_limit-reclaim
+++ a/mm/memcontrol.c
@@ -94,6 +94,10 @@ enum mem_cgroup_events_index {
 	MEM_CGROUP_EVENTS_PGPGIN,	/* # of pages paged in */
 	MEM_CGROUP_EVENTS_PGPGOUT,	/* # of pages paged out */
 	MEM_CGROUP_EVENTS_COUNT,	/* # of pages paged in/out */
+	MEM_CGROUP_EVENTS_SOFT_STEAL,	/* # of pages reclaimed from */
+					/* soft reclaim               */
+	MEM_CGROUP_EVENTS_SOFT_SCAN,	/* # of pages scanned from */
+					/* soft reclaim               */
 	MEM_CGROUP_EVENTS_NSTATS,
 };
 /*
@@ -624,6 +628,16 @@ static void mem_cgroup_charge_statistics
 	preempt_enable();
 }
 
+static void mem_cgroup_soft_steal(struct mem_cgroup *mem, int val)
+{
+	this_cpu_add(mem->stat->events[MEM_CGROUP_EVENTS_SOFT_STEAL], val);
+}
+
+static void mem_cgroup_soft_scan(struct mem_cgroup *mem, int val)
+{
+	this_cpu_add(mem->stat->events[MEM_CGROUP_EVENTS_SOFT_SCAN], val);
+}
+
 static unsigned long mem_cgroup_get_local_zonestat(struct mem_cgroup *mem,
 					enum lru_list idx)
 {
@@ -1491,6 +1505,8 @@ static int mem_cgroup_hierarchical_recla
 				noswap, get_swappiness(victim), zone,
 				&nr_scanned);
 			*total_scanned += nr_scanned;
+			mem_cgroup_soft_steal(victim, ret);
+			mem_cgroup_soft_scan(victim, nr_scanned);
 		} else
 			ret = try_to_free_mem_cgroup_pages(victim, gfp_mask,
 						noswap, get_swappiness(victim));
@@ -3326,6 +3342,7 @@ unsigned long mem_cgroup_soft_limit_recl
 						&nr_scanned);
 		nr_reclaimed += reclaimed;
 		*total_scanned += nr_scanned;
+
 		spin_lock(&mctz->lock);
 
 		/*
@@ -3783,6 +3800,8 @@ enum {
 	MCS_PGPGIN,
 	MCS_PGPGOUT,
 	MCS_SWAP,
+	MCS_SOFT_STEAL,
+	MCS_SOFT_SCAN,
 	MCS_INACTIVE_ANON,
 	MCS_ACTIVE_ANON,
 	MCS_INACTIVE_FILE,
@@ -3805,6 +3824,8 @@ struct {
 	{"pgpgin", "total_pgpgin"},
 	{"pgpgout", "total_pgpgout"},
 	{"swap", "total_swap"},
+	{"soft_steal", "total_soft_steal"},
+	{"soft_scan", "total_soft_scan"},
 	{"inactive_anon", "total_inactive_anon"},
 	{"active_anon", "total_active_anon"},
 	{"inactive_file", "total_inactive_file"},
@@ -3833,6 +3854,10 @@ mem_cgroup_get_local_stat(struct mem_cgr
 		val = mem_cgroup_read_stat(mem, MEM_CGROUP_STAT_SWAPOUT);
 		s->stat[MCS_SWAP] += val * PAGE_SIZE;
 	}
+	val = mem_cgroup_read_events(mem, MEM_CGROUP_EVENTS_SOFT_STEAL);
+	s->stat[MCS_SOFT_STEAL] += val;
+	val = mem_cgroup_read_events(mem, MEM_CGROUP_EVENTS_SOFT_SCAN);
+	s->stat[MCS_SOFT_SCAN] += val;
 
 	/* per zone stat */
 	val = mem_cgroup_get_local_zonestat(mem, LRU_INACTIVE_ANON);
_

Patches currently in -mm which might be from yinghan@google.com are

memcg-count-the-soft_limit-reclaim-in-global-background-reclaim.patch
memcg-add-stats-to-monitor-soft_limit-reclaim.patch
add-the-pagefault-count-into-memcg-stats.patch

