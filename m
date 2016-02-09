From: akpm@linux-foundation.org
Subject: + mm-workingset-make-shadow-node-shrinker-memcg-aware.patch added to -mm tree
Date: Tue, 09 Feb 2016 13:18:15 -0800
Message-ID: <56ba5797.iQ93u+n4LYW2dFok%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49161 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142AbcBIVSQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Feb 2016 16:18:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: workingset: make shadow node shrinker memcg aware
has been added to the -mm tree.  Its filename is
     mm-workingset-make-shadow-node-shrinker-memcg-aware.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-workingset-make-shadow-node-shrinker-memcg-aware.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-workingset-make-shadow-node-shrinker-memcg-aware.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Johannes Weiner <hannes@cmpxchg.org>
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

mm-vmscan-do-not-clear-shrinker_numa_aware-if-nr_node_ids-==-1.patch
mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages-fix-2.patch
mm-memcontrol-do-not-bypass-slab-charge-if-memcg-is-offline.patch
mm-memcontrol-make-tree_statevents-fetch-all-stats.patch
mm-memcontrol-make-tree_statevents-fetch-all-stats-fix.patch
mm-memcontrol-report-slab-usage-in-cgroup2-memorystat.patch
mm-memcontrol-report-kernel-stack-usage-in-cgroup2-memorystat.patch
mm-memcontrol-report-kernel-stack-usage-in-cgroup2-memorystat-v2.patch
proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages-fix.patch
tools-vm-page-typesc-add-memory-cgroup-dumping-and-filtering-fix.patch
mm-memcontrol-enable-kmem-accounting-for-all-cgroups-in-the-legacy-hierarchy.patch
mm-vmscan-pass-root_mem_cgroup-instead-of-null-to-memcg-aware-shrinker.patch
mm-memcontrol-zap-memcg_kmem_online-helper.patch
radix-tree-account-radix_tree_node-to-memory-cgroup.patch
mm-workingset-size-shadow-nodes-lru-basing-on-file-cache-size.patch
mm-workingset-make-shadow-node-shrinker-memcg-aware.patch

