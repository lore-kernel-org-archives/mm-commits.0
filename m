From: akpm@linux-foundation.org
Subject: [merged]
 mm-workingset-make-shadow-node-shrinker-memcg-aware.patch removed from -mm
 tree
Date: Mon, 21 Mar 2016 11:39:00 -0700
Message-ID: <56f03fc4.CT6QItgHGiqMBZMC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53453 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932479AbcCUT4c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: workingset: make shadow node shrinker memcg aware
has been removed from the -mm tree.  Its filename was
     mm-workingset-make-shadow-node-shrinker-memcg-aware.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm: workingset: make shadow node shrinker memcg aware

Workingset code was recently made memcg aware, but shadow node shrinker is
still global.  As a result, one small cgroup can consume all memory
available for shadow nodes, possibly hurting other cgroups by reclaiming
their shadow nodes, even though reclaim distances stored in its shadow
nodes have no effect.  To avoid this, we need to make shadow node shrinker
memcg aware.

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   10 ++++++++++
 mm/memcontrol.c            |    5 ++---
 mm/workingset.c            |   10 +++++++---
 3 files changed, 19 insertions(+), 6 deletions(-)

diff -puN include/linux/memcontrol.h~mm-workingset-make-shadow-node-shrinker-memcg-aware include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-workingset-make-shadow-node-shrinker-memcg-aware
+++ a/include/linux/memcontrol.h
@@ -403,6 +403,9 @@ int mem_cgroup_select_victim_node(struct
 void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
 		int nr_pages);
 
+unsigned long mem_cgroup_node_nr_lru_pages(struct mem_cgroup *memcg,
+					   int nid, unsigned int lru_mask);
+
 static inline
 unsigned long mem_cgroup_get_lru_size(struct lruvec *lruvec, enum lru_list lru)
 {
@@ -661,6 +664,13 @@ mem_cgroup_update_lru_size(struct lruvec
 {
 }
 
+static inline unsigned long
+mem_cgroup_node_nr_lru_pages(struct mem_cgroup *memcg,
+			     int nid, unsigned int lru_mask)
+{
+	return 0;
+}
+
 static inline void
 mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
 {
diff -puN mm/memcontrol.c~mm-workingset-make-shadow-node-shrinker-memcg-aware mm/memcontrol.c
--- a/mm/memcontrol.c~mm-workingset-make-shadow-node-shrinker-memcg-aware
+++ a/mm/memcontrol.c
@@ -638,9 +638,8 @@ static void mem_cgroup_charge_statistics
 	__this_cpu_add(memcg->stat->nr_page_events, nr_pages);
 }
 
-static unsigned long mem_cgroup_node_nr_lru_pages(struct mem_cgroup *memcg,
-						  int nid,
-						  unsigned int lru_mask)
+unsigned long mem_cgroup_node_nr_lru_pages(struct mem_cgroup *memcg,
+					   int nid, unsigned int lru_mask)
 {
 	unsigned long nr = 0;
 	int zid;
diff -puN mm/workingset.c~mm-workingset-make-shadow-node-shrinker-memcg-aware mm/workingset.c
--- a/mm/workingset.c~mm-workingset-make-shadow-node-shrinker-memcg-aware
+++ a/mm/workingset.c
@@ -349,8 +349,12 @@ static unsigned long count_shadow_nodes(
 	shadow_nodes = list_lru_shrink_count(&workingset_shadow_nodes, sc);
 	local_irq_enable();
 
-	pages = node_page_state(sc->nid, NR_ACTIVE_FILE) +
-		node_page_state(sc->nid, NR_INACTIVE_FILE);
+	if (memcg_kmem_enabled())
+		pages = mem_cgroup_node_nr_lru_pages(sc->memcg, sc->nid,
+						     LRU_ALL_FILE);
+	else
+		pages = node_page_state(sc->nid, NR_ACTIVE_FILE) +
+			node_page_state(sc->nid, NR_INACTIVE_FILE);
 
 	/*
 	 * Active cache pages are limited to 50% of memory, and shadow
@@ -460,7 +464,7 @@ static struct shrinker workingset_shadow
 	.count_objects = count_shadow_nodes,
 	.scan_objects = scan_shadow_nodes,
 	.seeks = DEFAULT_SEEKS,
-	.flags = SHRINKER_NUMA_AWARE,
+	.flags = SHRINKER_NUMA_AWARE | SHRINKER_MEMCG_AWARE,
 };
 
 /*
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

mm-oom_reaper-implement-oom-victims-queuing-fix.patch

