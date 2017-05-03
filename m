From: akpm@linux-foundation.org
Subject: [patch 069/102] mm: memcontrol: clean up memory.events
 counting function
Date: Wed, 03 May 2017 14:55:07 -0700
Message-ID: <20170503215507.RYuOAmbT1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50598 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751670AbdECVzp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:55:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, vdavydov.dev@gmail.com

From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: clean up memory.events counting function

We only ever count single events, drop the @nr parameter. Rename the
function accordingly. Remove low-information kerneldoc.

Link: http://lkml.kernel.org/r/20170404220148.28338-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vladimir Davydov <vdavydov.dev@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
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
