From: akpm@linux-foundation.org
Subject: + memcg-break-out-event-counters-from-other-stats.patch added to -mm tree
Date: Mon, 08 Nov 2010 15:29:17 -0800
Message-ID: <201011082329.oA8NTHY3016156@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59282 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753728Ab0KHXaK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Nov 2010 18:30:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, arighi@develer.com, balbir@linux.vnet.ibm.com, fengguang.wu@intel.com, gthelen@google.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: break out event counters from other stats
has been added to the -mm tree.  Its filename is
     memcg-break-out-event-counters-from-other-stats.patch

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
Subject: memcg: break out event counters from other stats
From: Johannes Weiner <hannes@cmpxchg.org>

For increasing and decreasing per-cpu cgroup usage counters it makes sense
to use signed types, as single per-cpu values might go negative during
updates.  But this is not the case for only-ever-increasing event
counters.

All the counters have been signed 64-bit so far, which was enough to count
events even with the sign bit wasted.

The next patch narrows the usage counters type (on 32-bit CPUs, that is),
though, so break out the event counters and make them unsigned words as
they should have been from the start.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrea Righi <arighi@develer.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   49 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 37 insertions(+), 12 deletions(-)

diff -puN mm/memcontrol.c~memcg-break-out-event-counters-from-other-stats mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-break-out-event-counters-from-other-stats
+++ a/mm/memcontrol.c
@@ -85,21 +85,23 @@ enum mem_cgroup_stat_index {
 	 */
 	MEM_CGROUP_STAT_CACHE, 	   /* # of pages charged as cache */
 	MEM_CGROUP_STAT_RSS,	   /* # of pages charged as anon rss */
-	MEM_CGROUP_STAT_PGPGIN_COUNT,	/* # of pages paged in */
-	MEM_CGROUP_STAT_PGPGOUT_COUNT,	/* # of pages paged out */
 	MEM_CGROUP_STAT_SWAPOUT, /* # of pages, swapped out */
 	MEM_CGROUP_STAT_FILE_MAPPED,  /* # of pages charged as file rss */
 	MEM_CGROUP_STAT_FILE_DIRTY,	/* # of dirty pages in page cache */
 	MEM_CGROUP_STAT_FILE_WRITEBACK,		/* # of pages under writeback */
 	MEM_CGROUP_STAT_FILE_UNSTABLE_NFS,	/* # of NFS unstable pages */
 	MEM_CGROUP_STAT_DATA, /* end of data requires synchronization */
-	/* incremented at every  pagein/pageout */
-	MEM_CGROUP_EVENTS = MEM_CGROUP_STAT_DATA,
 	MEM_CGROUP_ON_MOVE,	/* someone is moving account between groups */
-
 	MEM_CGROUP_STAT_NSTATS,
 };
 
+enum mem_cgroup_events_index {
+	MEM_CGROUP_EVENTS_PGPGIN,	/* # of pages paged in */
+	MEM_CGROUP_EVENTS_PGPGOUT,	/* # of pages paged out */
+	MEM_CGROUP_EVENTS_COUNT,	/* # of pages paged in/out */
+	MEM_CGROUP_EVENTS_NSTATS,
+};
+
 enum {
 	MEM_CGROUP_DIRTY_RATIO,
 	MEM_CGROUP_DIRTY_LIMIT_IN_BYTES,
@@ -109,6 +111,7 @@ enum {
 
 struct mem_cgroup_stat_cpu {
 	s64 count[MEM_CGROUP_STAT_NSTATS];
+	unsigned long events[MEM_CGROUP_EVENTS_NSTATS];
 };
 
 /*
@@ -612,6 +615,22 @@ static void mem_cgroup_swap_statistics(s
 	this_cpu_add(mem->stat->count[MEM_CGROUP_STAT_SWAPOUT], val);
 }
 
+static unsigned long mem_cgroup_read_events(struct mem_cgroup *mem,
+					    enum mem_cgroup_events_index idx)
+{
+	unsigned long val = 0;
+	int cpu;
+
+	for_each_online_cpu(cpu)
+		val += per_cpu(mem->stat->events[idx], cpu);
+#ifdef CONFIG_HOTPLUG_CPU
+	spin_lock(&mem->pcp_counter_lock);
+	val += mem->nocpu_base.events[idx];
+	spin_unlock(&mem->pcp_counter_lock);
+#endif
+	return val;
+}
+
 static void mem_cgroup_charge_statistics(struct mem_cgroup *mem,
 					 struct page_cgroup *pc,
 					 bool charge)
@@ -626,10 +645,10 @@ static void mem_cgroup_charge_statistics
 		__this_cpu_add(mem->stat->count[MEM_CGROUP_STAT_RSS], val);
 
 	if (charge)
-		__this_cpu_inc(mem->stat->count[MEM_CGROUP_STAT_PGPGIN_COUNT]);
+		__this_cpu_inc(mem->stat->events[MEM_CGROUP_EVENTS_PGPGIN]);
 	else
-		__this_cpu_inc(mem->stat->count[MEM_CGROUP_STAT_PGPGOUT_COUNT]);
-	__this_cpu_inc(mem->stat->count[MEM_CGROUP_EVENTS]);
+		__this_cpu_inc(mem->stat->events[MEM_CGROUP_EVENTS_PGPGOUT]);
+	__this_cpu_inc(mem->stat->events[MEM_CGROUP_EVENTS_COUNT]);
 
 	preempt_enable();
 }
@@ -651,9 +670,9 @@ static unsigned long mem_cgroup_get_loca
 
 static bool __memcg_event_check(struct mem_cgroup *mem, int event_mask_shift)
 {
-	s64 val;
+	unsigned long val;
 
-	val = this_cpu_read(mem->stat->count[MEM_CGROUP_EVENTS]);
+	val = this_cpu_read(mem->stat->events[MEM_CGROUP_EVENTS_COUNT]);
 
 	return !(val & ((1 << event_mask_shift) - 1));
 }
@@ -2055,6 +2074,12 @@ static void mem_cgroup_drain_pcp_counter
 		per_cpu(mem->stat->count[i], cpu) = 0;
 		mem->nocpu_base.count[i] += x;
 	}
+	for (i = 0; i < MEM_CGROUP_EVENTS_NSTATS; i++) {
+		unsigned long x = per_cpu(mem->stat->events[i], cpu);
+
+		per_cpu(mem->stat->events[i], cpu) = 0;
+		mem->nocpu_base.events[i] += x;
+	}
 	/* need to clear ON_MOVE value, works as a kind of lock. */
 	per_cpu(mem->stat->count[MEM_CGROUP_ON_MOVE], cpu) = 0;
 	spin_unlock(&mem->pcp_counter_lock);
@@ -3892,9 +3917,9 @@ mem_cgroup_get_local_stat(struct mem_cgr
 	s->stat[MCS_RSS] += val * PAGE_SIZE;
 	val = mem_cgroup_read_stat(mem, MEM_CGROUP_STAT_FILE_MAPPED);
 	s->stat[MCS_FILE_MAPPED] += val * PAGE_SIZE;
-	val = mem_cgroup_read_stat(mem, MEM_CGROUP_STAT_PGPGIN_COUNT);
+	val = mem_cgroup_read_events(mem, MEM_CGROUP_EVENTS_PGPGIN);
 	s->stat[MCS_PGPGIN] += val;
-	val = mem_cgroup_read_stat(mem, MEM_CGROUP_STAT_PGPGOUT_COUNT);
+	val = mem_cgroup_read_events(mem, MEM_CGROUP_EVENTS_PGPGOUT);
 	s->stat[MCS_PGPGOUT] += val;
 	if (do_swap_account) {
 		val = mem_cgroup_read_stat(mem, MEM_CGROUP_STAT_SWAPOUT);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

memcg-add-dirty-limits-to-mem_cgroup-use-native-word-to-represent-dirtyable-pages.patch
memcg-add-dirty-limits-to-mem_cgroup-catch-negative-per-cpu-sums-in-dirty-info.patch
memcg-break-out-event-counters-from-other-stats.patch
memcg-use-native-word-page-statistics-counters.patch

