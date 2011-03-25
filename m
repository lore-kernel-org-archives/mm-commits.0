From: akpm@linux-foundation.org
Subject: [merged] memcg-break-out-event-counters-from-other-stats.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:25:04 -0700
Message-ID: <201103250724.p2P7Ow0J025981@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48725 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933830Ab1CYHZO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:25:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, balbir@linux.vnet.ibm.com, gthelen@google.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: break out event counters from other stats
has been removed from the -mm tree.  Its filename was
     memcg-break-out-event-counters-from-other-stats.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

This patch:
- divides s64 counters into signed usage counters and unsigned
  monotonically increasing event counters.
- converts unsigned event counters into 'unsigned long' rather than
  'u64'.  This matches the type used by the /proc/vmstat event counters.

The next patch narrows the signed usage counters type (on 32-bit CPUs,
that is).

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Greg Thelen <gthelen@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   49 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 37 insertions(+), 12 deletions(-)

diff -puN mm/memcontrol.c~memcg-break-out-event-counters-from-other-stats mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-break-out-event-counters-from-other-stats
+++ a/mm/memcontrol.c
@@ -93,19 +93,22 @@ enum mem_cgroup_stat_index {
 	MEM_CGROUP_STAT_CACHE, 	   /* # of pages charged as cache */
 	MEM_CGROUP_STAT_RSS,	   /* # of pages charged as anon rss */
 	MEM_CGROUP_STAT_FILE_MAPPED,  /* # of pages charged as file rss */
-	MEM_CGROUP_STAT_PGPGIN_COUNT,	/* # of pages paged in */
-	MEM_CGROUP_STAT_PGPGOUT_COUNT,	/* # of pages paged out */
 	MEM_CGROUP_STAT_SWAPOUT, /* # of pages, swapped out */
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
 struct mem_cgroup_stat_cpu {
 	s64 count[MEM_CGROUP_STAT_NSTATS];
+	unsigned long events[MEM_CGROUP_EVENTS_NSTATS];
 };
 
 /*
@@ -577,6 +580,22 @@ static void mem_cgroup_swap_statistics(s
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
 					 bool file, int nr_pages)
 {
@@ -589,13 +608,13 @@ static void mem_cgroup_charge_statistics
 
 	/* pagein of a big page is an event. So, ignore page size */
 	if (nr_pages > 0)
-		__this_cpu_inc(mem->stat->count[MEM_CGROUP_STAT_PGPGIN_COUNT]);
+		__this_cpu_inc(mem->stat->events[MEM_CGROUP_EVENTS_PGPGIN]);
 	else {
-		__this_cpu_inc(mem->stat->count[MEM_CGROUP_STAT_PGPGOUT_COUNT]);
+		__this_cpu_inc(mem->stat->events[MEM_CGROUP_EVENTS_PGPGOUT]);
 		nr_pages = -nr_pages; /* for event */
 	}
 
-	__this_cpu_add(mem->stat->count[MEM_CGROUP_EVENTS], nr_pages);
+	__this_cpu_add(mem->stat->events[MEM_CGROUP_EVENTS_COUNT], nr_pages);
 
 	preempt_enable();
 }
@@ -617,9 +636,9 @@ static unsigned long mem_cgroup_get_loca
 
 static bool __memcg_event_check(struct mem_cgroup *mem, int event_mask_shift)
 {
-	s64 val;
+	unsigned long val;
 
-	val = this_cpu_read(mem->stat->count[MEM_CGROUP_EVENTS]);
+	val = this_cpu_read(mem->stat->events[MEM_CGROUP_EVENTS_COUNT]);
 
 	return !(val & ((1 << event_mask_shift) - 1));
 }
@@ -1773,6 +1792,12 @@ static void mem_cgroup_drain_pcp_counter
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
@@ -3725,9 +3750,9 @@ mem_cgroup_get_local_stat(struct mem_cgr
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

origin.patch
mm-add-vm-counters-for-transparent-hugepages.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-add-dirty-page-accounting-infrastructure.patch
memcg-add-kernel-calls-for-memcg-dirty-page-stats.patch
memcg-add-dirty-limits-to-mem_cgroup.patch
memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch
memcg-add-dirty-limiting-routines.patch
memcg-check-memcg-dirty-limits-in-page-writeback.patch
memcg-make-background-writeback-memcg-aware.patch

