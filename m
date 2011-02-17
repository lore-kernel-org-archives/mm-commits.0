From: akpm@linux-foundation.org
Subject: + memcg-use-native-word-page-statistics-counters.patch added to -mm tree
Date: Thu, 17 Feb 2011 15:00:22 -0800
Message-ID: <201102172300.p1HN0MSr021071@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59316 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751169Ab1BQXBU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Feb 2011 18:01:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, balbir@linux.vnet.ibm.com, gthelen@google.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: use native word page statistics counters
has been added to the -mm tree.  Its filename is
     memcg-use-native-word-page-statistics-counters.patch

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
Subject: memcg: use native word page statistics counters
From: Johannes Weiner <hannes@cmpxchg.org>

The statistic counters are in units of pages, there is no reason to make
them 64-bit wide on 32-bit machines.

Make them native words.  Since they are signed, this leaves 31 bit on
32-bit machines, which can represent roughly 8TB assuming a page size of
4k.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Greg Thelen <gthelen@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff -puN mm/memcontrol.c~memcg-use-native-word-page-statistics-counters mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-use-native-word-page-statistics-counters
+++ a/mm/memcontrol.c
@@ -107,7 +107,7 @@ enum mem_cgroup_events_index {
 };
 
 struct mem_cgroup_stat_cpu {
-	s64 count[MEM_CGROUP_STAT_NSTATS];
+	long count[MEM_CGROUP_STAT_NSTATS];
 	unsigned long events[MEM_CGROUP_EVENTS_NSTATS];
 };
 
@@ -546,11 +546,11 @@ mem_cgroup_largest_soft_limit_node(struc
  * common workload, threashold and synchonization as vmstat[] should be
  * implemented.
  */
-static s64 mem_cgroup_read_stat(struct mem_cgroup *mem,
-		enum mem_cgroup_stat_index idx)
+static long mem_cgroup_read_stat(struct mem_cgroup *mem,
+				 enum mem_cgroup_stat_index idx)
 {
+	long val = 0;
 	int cpu;
-	s64 val = 0;
 
 	get_online_cpus();
 	for_each_online_cpu(cpu)
@@ -564,9 +564,9 @@ static s64 mem_cgroup_read_stat(struct m
 	return val;
 }
 
-static s64 mem_cgroup_local_usage(struct mem_cgroup *mem)
+static long mem_cgroup_local_usage(struct mem_cgroup *mem)
 {
-	s64 ret;
+	long ret;
 
 	ret = mem_cgroup_read_stat(mem, MEM_CGROUP_STAT_RSS);
 	ret += mem_cgroup_read_stat(mem, MEM_CGROUP_STAT_CACHE);
@@ -1761,7 +1761,7 @@ static void mem_cgroup_drain_pcp_counter
 
 	spin_lock(&mem->pcp_counter_lock);
 	for (i = 0; i < MEM_CGROUP_STAT_DATA; i++) {
-		s64 x = per_cpu(mem->stat->count[i], cpu);
+		long x = per_cpu(mem->stat->count[i], cpu);
 
 		per_cpu(mem->stat->count[i], cpu) = 0;
 		mem->nocpu_base.count[i] += x;
@@ -3473,13 +3473,13 @@ static int mem_cgroup_hierarchy_write(st
 }
 
 
-static u64 mem_cgroup_get_recursive_idx_stat(struct mem_cgroup *mem,
-				enum mem_cgroup_stat_index idx)
+static unsigned long mem_cgroup_recursive_stat(struct mem_cgroup *mem,
+					       enum mem_cgroup_stat_index idx)
 {
 	struct mem_cgroup *iter;
-	s64 val = 0;
+	long val = 0;
 
-	/* each per cpu's value can be minus.Then, use s64 */
+	/* Per-cpu values can be negative, use a signed accumulator */
 	for_each_mem_cgroup_tree(iter, mem)
 		val += mem_cgroup_read_stat(iter, idx);
 
@@ -3499,12 +3499,11 @@ static inline u64 mem_cgroup_usage(struc
 			return res_counter_read_u64(&mem->memsw, RES_USAGE);
 	}
 
-	val = mem_cgroup_get_recursive_idx_stat(mem, MEM_CGROUP_STAT_CACHE);
-	val += mem_cgroup_get_recursive_idx_stat(mem, MEM_CGROUP_STAT_RSS);
+	val = mem_cgroup_recursive_stat(mem, MEM_CGROUP_STAT_CACHE);
+	val += mem_cgroup_recursive_stat(mem, MEM_CGROUP_STAT_RSS);
 
 	if (swap)
-		val += mem_cgroup_get_recursive_idx_stat(mem,
-				MEM_CGROUP_STAT_SWAPOUT);
+		val += mem_cgroup_recursive_stat(mem, MEM_CGROUP_STAT_SWAPOUT);
 
 	return val << PAGE_SHIFT;
 }
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

