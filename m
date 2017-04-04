From: akpm@linux-foundation.org
Subject: + mm-memcontrol-clean-up-memoryevents-counting-function.patch
 added to -mm tree
Date: Tue, 04 Apr 2017 15:12:19 -0700
Message-ID: <58e41a43.GZtApUMtC1trJvHY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33928 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754147AbdDDWMU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 4 Apr 2017 18:12:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: clean up memory.events counting function
has been added to the -mm tree.  Its filename is
     mm-memcontrol-clean-up-memoryevents-counting-function.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-clean-up-memoryevents-counting-function.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-clean-up-memoryevents-counting-function.patch

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
Subject: mm: memcontrol: clean up memory.events counting function

We only ever count single events, drop the @nr parameter. Rename the
function accordingly. Remove low-information kerneldoc.

Link: http://lkml.kernel.org/r/20170404220148.28338-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   18 +++++-------------
 mm/memcontrol.c            |    8 ++++----
 mm/vmscan.c                |    2 +-
 3 files changed, 10 insertions(+), 18 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcontrol-clean-up-memoryevents-counting-function include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-clean-up-memoryevents-counting-function
+++ a/include/linux/memcontrol.h
@@ -287,17 +287,10 @@ static inline bool mem_cgroup_disabled(v
 	return !cgroup_subsys_enabled(memory_cgrp_subsys);
 }
 
-/**
- * mem_cgroup_events - count memory events against a cgroup
- * @memcg: the memory cgroup
- * @idx: the event index
- * @nr: the number of events to account for
- */
-static inline void mem_cgroup_events(struct mem_cgroup *memcg,
-		       enum mem_cgroup_events_index idx,
-		       unsigned int nr)
+static inline void mem_cgroup_event(struct mem_cgroup *memcg,
+				    enum mem_cgroup_events_index idx)
 {
-	this_cpu_add(memcg->stat->events[idx], nr);
+	this_cpu_inc(memcg->stat->events[idx]);
 	cgroup_file_notify(&memcg->events_file);
 }
 
@@ -614,9 +607,8 @@ static inline bool mem_cgroup_disabled(v
 	return true;
 }
 
-static inline void mem_cgroup_events(struct mem_cgroup *memcg,
-				     enum mem_cgroup_events_index idx,
-				     unsigned int nr)
+static inline void mem_cgroup_event(struct mem_cgroup *memcg,
+				    enum mem_cgroup_events_index idx)
 {
 }
 
diff -puN mm/memcontrol.c~mm-memcontrol-clean-up-memoryevents-counting-function mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-clean-up-memoryevents-counting-function
+++ a/mm/memcontrol.c
@@ -1825,7 +1825,7 @@ static void reclaim_high(struct mem_cgro
 	do {
 		if (page_counter_read(&memcg->memory) <= memcg->high)
 			continue;
-		mem_cgroup_events(memcg, MEMCG_HIGH, 1);
+		mem_cgroup_event(memcg, MEMCG_HIGH);
 		try_to_free_mem_cgroup_pages(memcg, nr_pages, gfp_mask, true);
 	} while ((memcg = parent_mem_cgroup(memcg)));
 }
@@ -1916,7 +1916,7 @@ retry:
 	if (!gfpflags_allow_blocking(gfp_mask))
 		goto nomem;
 
-	mem_cgroup_events(mem_over_limit, MEMCG_MAX, 1);
+	mem_cgroup_event(mem_over_limit, MEMCG_MAX);
 
 	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
 						    gfp_mask, may_swap);
@@ -1959,7 +1959,7 @@ retry:
 	if (fatal_signal_pending(current))
 		goto force;
 
-	mem_cgroup_events(mem_over_limit, MEMCG_OOM, 1);
+	mem_cgroup_event(mem_over_limit, MEMCG_OOM);
 
 	mem_cgroup_oom(mem_over_limit, gfp_mask,
 		       get_order(nr_pages * PAGE_SIZE));
@@ -5142,7 +5142,7 @@ static ssize_t memory_max_write(struct k
 			continue;
 		}
 
-		mem_cgroup_events(memcg, MEMCG_OOM, 1);
+		mem_cgroup_event(memcg, MEMCG_OOM);
 		if (!mem_cgroup_out_of_memory(memcg, GFP_KERNEL, 0))
 			break;
 	}
diff -puN mm/vmscan.c~mm-memcontrol-clean-up-memoryevents-counting-function mm/vmscan.c
--- a/mm/vmscan.c~mm-memcontrol-clean-up-memoryevents-counting-function
+++ a/mm/vmscan.c
@@ -2526,7 +2526,7 @@ static bool shrink_node(pg_data_t *pgdat
 					sc->memcg_low_skipped = 1;
 					continue;
 				}
-				mem_cgroup_events(memcg, MEMCG_LOW, 1);
+				mem_cgroup_event(memcg, MEMCG_LOW);
 			}
 
 			reclaimed = sc->nr_reclaimed;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes.patch
mm-fix-100%-cpu-kswapd-busyloop-on-unreclaimable-nodes-fix.patch
mm-fix-check-for-reclaimable-pages-in-pf_memalloc-reclaim-throttling.patch
mm-remove-seemingly-spurious-reclaimability-check-from-laptop_mode-gating.patch
mm-remove-unnecessary-reclaimability-check-from-numa-balancing-target.patch
mm-dont-avoid-high-priority-reclaim-on-unreclaimable-nodes.patch
mm-dont-avoid-high-priority-reclaim-on-memcg-limit-reclaim.patch
mm-delete-nr_pages_scanned-and-pgdat_reclaimable.patch
revert-mm-vmscan-account-for-skipped-pages-as-a-partial-scan.patch
mm-remove-unnecessary-back-off-function-when-retrying-page-reclaim.patch
mm-memcontrol-provide-shmem-statistics.patch
mm-page_alloc-__gfp_nowarn-shouldnt-suppress-stall-warnings.patch
mm-vmscan-fix-io-refault-regression-in-cache-workingset-transition.patch
mm-memcontrol-clean-up-memoryevents-counting-function.patch
mm-memcontrol-re-use-global-vm-event-enum.patch
mm-memcontrol-re-use-node-vm-page-state-enum.patch
mm-memcontrol-use-node-page-state-naming-scheme-for-memcg.patch

