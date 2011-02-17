From: akpm@linux-foundation.org
Subject: + memcg-break-out-event-counters-from-other-stats.patch added to -mm tree
Date: Thu, 17 Feb 2011 15:00:20 -0800
Message-ID: <201102172300.p1HN0KwJ021068@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44564 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751169Ab1BQXBt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Feb 2011 18:01:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, balbir@linux.vnet.ibm.com, gthelen@google.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp


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
@@ -1747,6 +1766,12 @@ static void mem_cgroup_drain_pcp_counter
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
@@ -3699,9 +3724,9 @@ mem_cgroup_get_local_stat(struct mem_cgr
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

mm-vmscan-stop-reclaim-compaction-earlier-due-to-insufficient-progress-if-__gfp_repeat.patch
mm-introduce-delete_from_page_cache.patch
mm-hugetlbfs-change-remove_from_page_cache.patch
mm-shmem-change-remove_from_page_cache.patch
mm-truncate-change-remove_from_page_cache.patch
mm-good-bye-remove_from_page_cache.patch
mm-change-__remove_from_page_cache.patch
mm-batch-free-pcp-list-if-possible.patch
mm-batch-free-pcp-list-if-possible-fix.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path-fix.patch
memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch
memcg-fix-ugly-initialization-of-return-value-is-in-caller.patch
memcg-soft-limit-reclaim-should-end-at-limit-not-below.patch
memcg-simplify-the-way-memory-limits-are-checked.patch
memcg-remove-unused-page-flag-bitfield-defines.patch
memcg-remove-impossible-conditional-when-committing.patch
memcg-remove-null-check-from-lookup_page_cgroup-result.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update-fix.patch
memcg-no-uncharged-pages-reach-page_cgroup_zoneinfo.patch
memcg-change-page_cgroup_zoneinfo-signature.patch
memcg-fold-__mem_cgroup_move_account-into-caller.patch
memcg-condense-page_cgroup-to-page-lookup-points.patch
memcg-remove-direct-page_cgroup-to-page-pointer.patch
memcg-remove-direct-page_cgroup-to-page-pointer-fix.patch
memcg-remove-direct-page_cgroup-to-page-pointer-fix-fix.patch
memcg-charged-pages-always-have-valid-per-memcg-zone-info.patch
memcg-remove-memcg-reclaim_param_lock.patch
memcg-keep-only-one-charge-cancelling-function.patch
memcg-keep-only-one-charge-cancelling-function-fix.patch
memcg-convert-per-cpu-stock-from-bytes-to-page-granularity.patch
memcg-convert-uncharge-batching-from-bytes-to-page-granularity.patch
memcg-unify-charge-uncharge-quantities-to-units-of-pages.patch
memcg-break-out-event-counters-from-other-stats.patch
memcg-use-native-word-page-statistics-counters.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch

