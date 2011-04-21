From: akpm@linux-foundation.org
Subject: + mm-always-set-nodes-with-regular-memory-in-n_normal_memory.patch added to -mm tree
Date: Thu, 21 Apr 2011 14:45:44 -0700
Message-ID: <201104212145.p3LLjiZc000507@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56384 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754956Ab1DUVrE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Apr 2011 17:47:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, Lee.Schermerhorn@hp.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, tony.luck@intel.com


The patch titled
     mm: always set nodes with regular memory in N_NORMAL_MEMORY
has been added to the -mm tree.  Its filename is
     mm-always-set-nodes-with-regular-memory-in-n_normal_memory.patch

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
Subject: mm: always set nodes with regular memory in N_NORMAL_MEMORY
From: David Rientjes <rientjes@google.com>

N_NORMAL_MEMORY is intended to include all nodes that have present memory
in regular zones, that is, zones below ZONE_HIGHMEM.  This should be done
regardless of whether CONFIG_HIGHMEM is set or not.

This fixes ia64 so that the nodes get set appropriately in the nodemask
for DISCONTIGMEM and mips if it does not enable CONFIG_HIGHMEM even for
32-bit kernels.

If N_NORMAL_MEMORY is not accurate, slub may encounter errors since it
relies on this nodemask to setup kmem_cache_node data structures for each
cache.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/page_alloc.c~mm-always-set-nodes-with-regular-memory-in-n_normal_memory mm/page_alloc.c
--- a/mm/page_alloc.c~mm-always-set-nodes-with-regular-memory-in-n_normal_memory
+++ a/mm/page_alloc.c
@@ -4727,7 +4727,6 @@ out:
 /* Any regular memory on that node ? */
 static void check_for_regular_memory(pg_data_t *pgdat)
 {
-#ifdef CONFIG_HIGHMEM
 	enum zone_type zone_type;
 
 	for (zone_type = 0; zone_type <= ZONE_NORMAL; zone_type++) {
@@ -4735,7 +4734,6 @@ static void check_for_regular_memory(pg_
 		if (zone->present_pages)
 			node_set_state(zone_to_nid(zone), N_NORMAL_MEMORY);
 	}
-#endif
 }
 
 /**
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
oom-use-pte-pages-in-oom-score.patch
mm-always-set-nodes-with-regular-memory-in-n_normal_memory.patch
arch-mm-filter-disallowed-nodes-from-arch-specific-show_mem-functions.patch
mm-per-node-vmstat-show-proper-vmstats.patch
mm-increase-reclaim_distance-to-30.patch
oom-replace-pf_oom_origin-with-toggling-oom_score_adj.patch
oom-replace-pf_oom_origin-with-toggling-oom_score_adj-update.patch
mm-rename-alloc_pages_exact.patch
mm-make-new-alloc_pages_exact.patch
mm-reuse-__free_pages_exact-in-__alloc_pages_exact.patch
mm-thp-optimize-memcg-charge-in-khugepaged.patch
mm-break-out-page-allocation-warning-code.patch
mm-print-vmalloc-state-after-allocation-failures.patch
jbd-remove-dependency-on-__gfp_nofail.patch
cgroups-read-write-lock-clone_thread-forking-per-threadgroup.patch
cgroups-add-per-thread-subsystem-callbacks.patch
cgroups-make-procs-file-writable.patch
cgroups-use-flex_array-in-attach_proc.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch

