From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-do-not-filter-reclaimable-nodes-in-numa-round-robin.patch
 added to -mm tree
Date: Thu, 23 Oct 2014 13:14:35 -0700
Message-ID: <544961ab.kqkzTv9aCRA9DSOG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45986 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560AbaJWUOf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Oct 2014 16:14:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: do not filter reclaimable nodes in NUMA round-robin
has been added to the -mm tree.  Its filename is
     mm-memcontrol-do-not-filter-reclaimable-nodes-in-numa-round-robin.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-do-not-filter-reclaimable-nodes-in-numa-round-robin.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-do-not-filter-reclaimable-nodes-in-numa-round-robin.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: do not filter reclaimable nodes in NUMA round-robin

The round-robin node reclaim currently tries to include only nodes that
have memory of the memcg in question, which is quite elaborate.

Just use plain round-robin over the nodes that are allowed by the task's
cpuset, which are the most likely to contain that memcg's memory.  But
even if zones without memcg memory are encountered, direct reclaim will
skip over them without too much hassle.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   97 ++--------------------------------------------
 1 file changed, 5 insertions(+), 92 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-do-not-filter-reclaimable-nodes-in-numa-round-robin mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-do-not-filter-reclaimable-nodes-in-numa-round-robin
+++ a/mm/memcontrol.c
@@ -54,6 +54,7 @@
 #include <linux/page_cgroup.h>
 #include <linux/cpu.h>
 #include <linux/oom.h>
+#include <linux/cpuset.h>
 #include <linux/lockdep.h>
 #include <linux/file.h>
 #include "internal.h"
@@ -129,12 +130,10 @@ static const char * const mem_cgroup_lru
 enum mem_cgroup_events_target {
 	MEM_CGROUP_TARGET_THRESH,
 	MEM_CGROUP_TARGET_SOFTLIMIT,
-	MEM_CGROUP_TARGET_NUMAINFO,
 	MEM_CGROUP_NTARGETS,
 };
 #define THRESHOLDS_EVENTS_TARGET 128
 #define SOFTLIMIT_EVENTS_TARGET 1024
-#define NUMAINFO_EVENTS_TARGET	1024
 
 struct mem_cgroup_stat_cpu {
 	long count[MEM_CGROUP_STAT_NSTATS];
@@ -352,11 +351,6 @@ struct mem_cgroup {
 #endif
 
 	int last_scanned_node;
-#if MAX_NUMNODES > 1
-	nodemask_t	scan_nodes;
-	atomic_t	numainfo_events;
-	atomic_t	numainfo_updating;
-#endif
 
 	/* List of events which userspace want to receive */
 	struct list_head event_list;
@@ -965,9 +959,6 @@ static bool mem_cgroup_event_ratelimit(s
 		case MEM_CGROUP_TARGET_SOFTLIMIT:
 			next = val + SOFTLIMIT_EVENTS_TARGET;
 			break;
-		case MEM_CGROUP_TARGET_NUMAINFO:
-			next = val + NUMAINFO_EVENTS_TARGET;
-			break;
 		default:
 			break;
 		}
@@ -986,22 +977,10 @@ static void memcg_check_events(struct me
 	/* threshold event is triggered in finer grain than soft limit */
 	if (unlikely(mem_cgroup_event_ratelimit(memcg,
 						MEM_CGROUP_TARGET_THRESH))) {
-		bool do_softlimit;
-		bool do_numainfo __maybe_unused;
-
-		do_softlimit = mem_cgroup_event_ratelimit(memcg,
-						MEM_CGROUP_TARGET_SOFTLIMIT);
-#if MAX_NUMNODES > 1
-		do_numainfo = mem_cgroup_event_ratelimit(memcg,
-						MEM_CGROUP_TARGET_NUMAINFO);
-#endif
 		mem_cgroup_threshold(memcg);
-		if (unlikely(do_softlimit))
+		if (mem_cgroup_event_ratelimit(memcg,
+					       MEM_CGROUP_TARGET_SOFTLIMIT))
 			mem_cgroup_update_tree(memcg, page);
-#if MAX_NUMNODES > 1
-		if (unlikely(do_numainfo))
-			atomic_inc(&memcg->numainfo_events);
-#endif
 	}
 }
 
@@ -1654,61 +1633,7 @@ static void mem_cgroup_out_of_memory(str
 			 NULL, "Memory cgroup out of memory");
 }
 
-/**
- * test_mem_cgroup_node_reclaimable
- * @memcg: the target memcg
- * @nid: the node ID to be checked.
- * @noswap : specify true here if the user wants flle only information.
- *
- * This function returns whether the specified memcg contains any
- * reclaimable pages on a node. Returns true if there are any reclaimable
- * pages in the node.
- */
-static bool test_mem_cgroup_node_reclaimable(struct mem_cgroup *memcg,
-		int nid, bool noswap)
-{
-	if (mem_cgroup_node_nr_lru_pages(memcg, nid, LRU_ALL_FILE))
-		return true;
-	if (noswap || !total_swap_pages)
-		return false;
-	if (mem_cgroup_node_nr_lru_pages(memcg, nid, LRU_ALL_ANON))
-		return true;
-	return false;
-
-}
 #if MAX_NUMNODES > 1
-
-/*
- * Always updating the nodemask is not very good - even if we have an empty
- * list or the wrong list here, we can start from some node and traverse all
- * nodes based on the zonelist. So update the list loosely once per 10 secs.
- *
- */
-static void mem_cgroup_may_update_nodemask(struct mem_cgroup *memcg)
-{
-	int nid;
-	/*
-	 * numainfo_events > 0 means there was at least NUMAINFO_EVENTS_TARGET
-	 * pagein/pageout changes since the last update.
-	 */
-	if (!atomic_read(&memcg->numainfo_events))
-		return;
-	if (atomic_inc_return(&memcg->numainfo_updating) > 1)
-		return;
-
-	/* make a nodemask where this memcg uses memory from */
-	memcg->scan_nodes = node_states[N_MEMORY];
-
-	for_each_node_mask(nid, node_states[N_MEMORY]) {
-
-		if (!test_mem_cgroup_node_reclaimable(memcg, nid, false))
-			node_clear(nid, memcg->scan_nodes);
-	}
-
-	atomic_set(&memcg->numainfo_events, 0);
-	atomic_set(&memcg->numainfo_updating, 0);
-}
-
 /*
  * Selecting a node where we start reclaim from. Because what we need is just
  * reducing usage counter, start from anywhere is O,K. Considering
@@ -1725,21 +1650,9 @@ int mem_cgroup_select_victim_node(struct
 {
 	int node;
 
-	mem_cgroup_may_update_nodemask(memcg);
-	node = memcg->last_scanned_node;
-
-	node = next_node(node, memcg->scan_nodes);
+	node = next_node(memcg->last_scanned_node, cpuset_current_mems_allowed);
 	if (node == MAX_NUMNODES)
-		node = first_node(memcg->scan_nodes);
-	/*
-	 * We call this when we hit limit, not when pages are added to LRU.
-	 * No LRU may hold pages because all pages are UNEVICTABLE or
-	 * memcg is too small and all pages are not on LRU. In that case,
-	 * we use curret node.
-	 */
-	if (unlikely(node == MAX_NUMNODES))
-		node = numa_node_id();
-
+		node = first_node(cpuset_current_mems_allowed);
 	memcg->last_scanned_node = node;
 	return node;
 }
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

cgroup-kmemleak-add-kmemleak_free-for-cgroup-deallocations.patch
mm-page-writeback-inline-account_page_dirtied-into-single-caller.patch
mm-memcontrol-fix-missed-end-writeback-page-accounting.patch
mm-memcontrol-fix-missed-end-writeback-page-accounting-fix.patch
mm-rmap-split-out-page_remove_file_rmap.patch
mm-memcontrol-lockless-page-counters.patch
mm-memcontrol-lockless-page-counters-fix.patch
mm-memcontrol-lockless-page-counters-fix-fix.patch
mm-memcontrol-lockless-page-counters-fix-2.patch
mm-hugetlb_cgroup-convert-to-lockless-page-counters.patch
kernel-res_counter-remove-the-unused-api.patch
kernel-res_counter-remove-the-unused-api-fix.patch
kernel-res_counter-remove-the-unused-api-fix-2.patch
mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting.patch
mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting-fix.patch
mm-memcontrol-take-a-css-reference-for-each-charged-page.patch
mm-memcontrol-remove-obsolete-kmemcg-pinning-tricks.patch
mm-memcontrol-continue-cache-reclaim-from-offlined-groups.patch
mm-memcontrol-remove-synchroneous-stock-draining-code.patch
mm-vmscan-count-only-dirty-pages-as-congested.patch
memcg-simplify-unreclaimable-groups-handling-in-soft-limit-reclaim.patch
mm-memcontrol-update-mem_cgroup_page_lruvec-documentation.patch
mm-memcontrol-clarify-migration-where-old-page-is-uncharged.patch
memcg-remove-activate_kmem_mutex.patch
mm-memcontrol-micro-optimize-mem_cgroup_split_huge_fixup.patch
mm-memcontrol-uncharge-pages-on-swapout.patch
mm-memcontrol-uncharge-pages-on-swapout-fix.patch
mm-memcontrol-remove-unnecessary-pcg_memsw-memoryswap-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_mem-memory-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag-fix.patch
mm-memcontrol-inline-memcg-move_lock-locking.patch
mm-memcontrol-dont-pass-a-null-memcg-to-mem_cgroup_end_move.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix.patch
memcg-remove-mem_cgroup_reclaimable-check-from-soft-reclaim.patch
mm-memcontrol-do-not-filter-reclaimable-nodes-in-numa-round-robin.patch
debugging-keep-track-of-page-owners.patch

