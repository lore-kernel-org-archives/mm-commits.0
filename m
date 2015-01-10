From: akpm@linux-foundation.org
Subject: + vmscan-per-memory-cgroup-slab-shrinkers.patch added to -mm tree
Date: Fri, 09 Jan 2015 16:12:26 -0800
Message-ID: <54b06e6a.7+GqhXoQIWWyTcjR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38792 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbbAJAM1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jan 2015 19:12:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, david@fromorbit.com, glommer@gmail.com, gthelen@google.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, tj@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan: per memory cgroup slab shrinkers
has been added to the -mm tree.  Its filename is
     vmscan-per-memory-cgroup-slab-shrinkers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmscan-per-memory-cgroup-slab-shrinkers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmscan-per-memory-cgroup-slab-shrinkers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: vmscan: per memory cgroup slab shrinkers

This patch adds SHRINKER_MEMCG_AWARE flag.  If a shrinker has this flag
set, it will be called per memory cgroup.  The memory cgroup to scan
objects from is passed in shrink_control->memcg.  If the memory cgroup is
NULL, a memcg aware shrinker is supposed to scan objects from the global
list.  Unaware shrinkers are only called on global pressure with
memcg=NULL.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Greg Thelen <gthelen@google.com>
Cc: Glauber Costa <glommer@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/drop_caches.c           |   14 -----
 include/linux/memcontrol.h |    7 ++
 include/linux/mm.h         |    5 --
 include/linux/shrinker.h   |    6 ++
 mm/memcontrol.c            |    2 
 mm/memory-failure.c        |   11 ----
 mm/vmscan.c                |   86 +++++++++++++++++++++++++----------
 7 files changed, 80 insertions(+), 51 deletions(-)

diff -puN fs/drop_caches.c~vmscan-per-memory-cgroup-slab-shrinkers fs/drop_caches.c
--- a/fs/drop_caches.c~vmscan-per-memory-cgroup-slab-shrinkers
+++ a/fs/drop_caches.c
@@ -37,20 +37,6 @@ static void drop_pagecache_sb(struct sup
 	iput(toput_inode);
 }
 
-static void drop_slab(void)
-{
-	int nr_objects;
-
-	do {
-		int nid;
-
-		nr_objects = 0;
-		for_each_online_node(nid)
-			nr_objects += shrink_node_slabs(GFP_KERNEL, nid,
-							1000, 1000);
-	} while (nr_objects > 10);
-}
-
 int drop_caches_sysctl_handler(struct ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
diff -puN include/linux/memcontrol.h~vmscan-per-memory-cgroup-slab-shrinkers include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~vmscan-per-memory-cgroup-slab-shrinkers
+++ a/include/linux/memcontrol.h
@@ -375,6 +375,8 @@ static inline bool memcg_kmem_enabled(vo
 	return static_key_false(&memcg_kmem_enabled_key);
 }
 
+bool memcg_kmem_is_active(struct mem_cgroup *memcg);
+
 /*
  * In general, we'll do everything in our power to not incur in any overhead
  * for non-memcg users for the kmem functions. Not even a function call, if we
@@ -503,6 +505,11 @@ static inline bool memcg_kmem_enabled(vo
 {
 	return false;
 }
+
+static inline bool memcg_kmem_is_active(struct mem_cgroup *memcg)
+{
+	return false;
+}
 
 static inline bool
 memcg_kmem_newpage_charge(gfp_t gfp, struct mem_cgroup **memcg, int order)
diff -puN include/linux/mm.h~vmscan-per-memory-cgroup-slab-shrinkers include/linux/mm.h
--- a/include/linux/mm.h~vmscan-per-memory-cgroup-slab-shrinkers
+++ a/include/linux/mm.h
@@ -2095,9 +2095,8 @@ int drop_caches_sysctl_handler(struct ct
 					void __user *, size_t *, loff_t *);
 #endif
 
-unsigned long shrink_node_slabs(gfp_t gfp_mask, int nid,
-				unsigned long nr_scanned,
-				unsigned long nr_eligible);
+void drop_slab(void);
+void drop_slab_node(int nid);
 
 #ifndef CONFIG_MMU
 #define randomize_va_space 0
diff -puN include/linux/shrinker.h~vmscan-per-memory-cgroup-slab-shrinkers include/linux/shrinker.h
--- a/include/linux/shrinker.h~vmscan-per-memory-cgroup-slab-shrinkers
+++ a/include/linux/shrinker.h
@@ -20,6 +20,9 @@ struct shrink_control {
 
 	/* current node being shrunk (for NUMA aware shrinkers) */
 	int nid;
+
+	/* current memcg being shrunk (for memcg aware shrinkers) */
+	struct mem_cgroup *memcg;
 };
 
 #define SHRINK_STOP (~0UL)
@@ -61,7 +64,8 @@ struct shrinker {
 #define DEFAULT_SEEKS 2 /* A good number if you don't know better. */
 
 /* Flags */
-#define SHRINKER_NUMA_AWARE (1 << 0)
+#define SHRINKER_NUMA_AWARE	(1 << 0)
+#define SHRINKER_MEMCG_AWARE	(1 << 1)
 
 extern int register_shrinker(struct shrinker *);
 extern void unregister_shrinker(struct shrinker *);
diff -puN mm/memcontrol.c~vmscan-per-memory-cgroup-slab-shrinkers mm/memcontrol.c
--- a/mm/memcontrol.c~vmscan-per-memory-cgroup-slab-shrinkers
+++ a/mm/memcontrol.c
@@ -365,7 +365,7 @@ struct mem_cgroup {
 };
 
 #ifdef CONFIG_MEMCG_KMEM
-static bool memcg_kmem_is_active(struct mem_cgroup *memcg)
+bool memcg_kmem_is_active(struct mem_cgroup *memcg)
 {
 	return memcg->kmemcg_id >= 0;
 }
diff -puN mm/memory-failure.c~vmscan-per-memory-cgroup-slab-shrinkers mm/memory-failure.c
--- a/mm/memory-failure.c~vmscan-per-memory-cgroup-slab-shrinkers
+++ a/mm/memory-failure.c
@@ -242,15 +242,8 @@ void shake_page(struct page *p, int acce
 	 * Only call shrink_node_slabs here (which would also shrink
 	 * other caches) if access is not potentially fatal.
 	 */
-	if (access) {
-		int nr;
-		int nid = page_to_nid(p);
-		do {
-			nr = shrink_node_slabs(GFP_KERNEL, nid, 1000, 1000);
-			if (page_count(p) == 1)
-				break;
-		} while (nr > 10);
-	}
+	if (access)
+		drop_slab_node(page_to_nid(p));
 }
 EXPORT_SYMBOL_GPL(shake_page);
 
diff -puN mm/vmscan.c~vmscan-per-memory-cgroup-slab-shrinkers mm/vmscan.c
--- a/mm/vmscan.c~vmscan-per-memory-cgroup-slab-shrinkers
+++ a/mm/vmscan.c
@@ -229,10 +229,10 @@ EXPORT_SYMBOL(unregister_shrinker);
 
 #define SHRINK_BATCH 128
 
-static unsigned long shrink_slabs(struct shrink_control *shrinkctl,
-				  struct shrinker *shrinker,
-				  unsigned long nr_scanned,
-				  unsigned long nr_eligible)
+static unsigned long do_shrink_slab(struct shrink_control *shrinkctl,
+				    struct shrinker *shrinker,
+				    unsigned long nr_scanned,
+				    unsigned long nr_eligible)
 {
 	unsigned long freed = 0;
 	unsigned long long delta;
@@ -341,9 +341,10 @@ static unsigned long shrink_slabs(struct
 }
 
 /**
- * shrink_node_slabs - shrink slab caches of a given node
+ * shrink_slab - shrink slab caches
  * @gfp_mask: allocation context
  * @nid: node whose slab caches to target
+ * @memcg: memory cgroup whose slab caches to target
  * @nr_scanned: pressure numerator
  * @nr_eligible: pressure denominator
  *
@@ -352,6 +353,12 @@ static unsigned long shrink_slabs(struct
  * @nid is passed along to shrinkers with SHRINKER_NUMA_AWARE set,
  * unaware shrinkers will receive a node id of 0 instead.
  *
+ * @memcg specifies the memory cgroup to target. If it is not NULL,
+ * only shrinkers with SHRINKER_MEMCG_AWARE set will be called to scan
+ * objects from the memory cgroup specified. Otherwise all shrinkers
+ * are called, and memcg aware shrinkers are supposed to scan the
+ * global list then.
+ *
  * @nr_scanned and @nr_eligible form a ratio that indicate how much of
  * the available objects should be scanned.  Page reclaim for example
  * passes the number of pages scanned and the number of pages on the
@@ -362,13 +369,17 @@ static unsigned long shrink_slabs(struct
  *
  * Returns the number of reclaimed slab objects.
  */
-unsigned long shrink_node_slabs(gfp_t gfp_mask, int nid,
-				unsigned long nr_scanned,
-				unsigned long nr_eligible)
+static unsigned long shrink_slab(gfp_t gfp_mask, int nid,
+				 struct mem_cgroup *memcg,
+				 unsigned long nr_scanned,
+				 unsigned long nr_eligible)
 {
 	struct shrinker *shrinker;
 	unsigned long freed = 0;
 
+	if (memcg && !memcg_kmem_is_active(memcg))
+		return 0;
+
 	if (nr_scanned == 0)
 		nr_scanned = SWAP_CLUSTER_MAX;
 
@@ -387,12 +398,16 @@ unsigned long shrink_node_slabs(gfp_t gf
 		struct shrink_control sc = {
 			.gfp_mask = gfp_mask,
 			.nid = nid,
+			.memcg = memcg,
 		};
 
+		if (memcg && !(shrinker->flags & SHRINKER_MEMCG_AWARE))
+			continue;
+
 		if (!(shrinker->flags & SHRINKER_NUMA_AWARE))
 			sc.nid = 0;
 
-		freed += shrink_slabs(&sc, shrinker, nr_scanned, nr_eligible);
+		freed += do_shrink_slab(&sc, shrinker, nr_scanned, nr_eligible);
 	}
 
 	up_read(&shrinker_rwsem);
@@ -401,6 +416,29 @@ out:
 	return freed;
 }
 
+void drop_slab_node(int nid)
+{
+	unsigned long freed;
+
+	do {
+		struct mem_cgroup *memcg = NULL;
+
+		freed = 0;
+		do {
+			freed += shrink_slab(GFP_KERNEL, nid, memcg,
+					     1000, 1000);
+		} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
+	} while (freed > 10);
+}
+
+void drop_slab(void)
+{
+	int nid;
+
+	for_each_online_node(nid)
+		drop_slab_node(nid);
+}
+
 static inline int is_page_cache_freeable(struct page *page)
 {
 	/*
@@ -2269,6 +2307,7 @@ static inline bool should_continue_recla
 static bool shrink_zone(struct zone *zone, struct scan_control *sc,
 			bool is_classzone)
 {
+	struct reclaim_state *reclaim_state = current->reclaim_state;
 	unsigned long nr_reclaimed, nr_scanned;
 	bool reclaimable = false;
 
@@ -2286,16 +2325,22 @@ static bool shrink_zone(struct zone *zon
 
 		memcg = mem_cgroup_iter(root, NULL, &reclaim);
 		do {
-			unsigned long lru_pages;
+			unsigned long lru_pages, scanned;
 			struct lruvec *lruvec;
 			int swappiness;
 
 			lruvec = mem_cgroup_zone_lruvec(zone, memcg);
 			swappiness = mem_cgroup_swappiness(memcg);
+			scanned = sc->nr_scanned;
 
 			shrink_lruvec(lruvec, swappiness, sc, &lru_pages);
 			zone_lru_pages += lru_pages;
 
+			if (memcg && is_classzone)
+				shrink_slab(sc->gfp_mask, zone_to_nid(zone),
+					    memcg, sc->nr_scanned - scanned,
+					    lru_pages);
+
 			/*
 			 * Direct reclaim and kswapd have to scan all memory
 			 * cgroups to fulfill the overall scan target for the
@@ -2318,19 +2363,14 @@ static bool shrink_zone(struct zone *zon
 		 * Shrink the slab caches in the same proportion that
 		 * the eligible LRU pages were scanned.
 		 */
-		if (global_reclaim(sc) && is_classzone) {
-			struct reclaim_state *reclaim_state;
-
-			shrink_node_slabs(sc->gfp_mask, zone_to_nid(zone),
-					  sc->nr_scanned - nr_scanned,
-					  zone_lru_pages);
-
-			reclaim_state = current->reclaim_state;
-			if (reclaim_state) {
-				sc->nr_reclaimed +=
-					reclaim_state->reclaimed_slab;
-				reclaim_state->reclaimed_slab = 0;
-			}
+		if (global_reclaim(sc) && is_classzone)
+			shrink_slab(sc->gfp_mask, zone_to_nid(zone), NULL,
+				    sc->nr_scanned - nr_scanned,
+				    zone_lru_pages);
+
+		if (reclaim_state) {
+			sc->nr_reclaimed += reclaim_state->reclaimed_slab;
+			reclaim_state->reclaimed_slab = 0;
 		}
 
 		vmpressure(sc->gfp_mask, sc->target_mem_cgroup,
_

Patches currently in -mm which might be from vdavydov@parallels.com are

mm-memcontrol-switch-soft-limit-default-back-to-infinity.patch
memcg-fix-destination-cgroup-leak-on-task-charges-migration.patch
mm-vmscan-prevent-kswapd-livelock-due-to-pfmemalloc-throttled-process-being-killed.patch
memcg-zap-__memcg_chargeuncharge_slab.patch
memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache.patch
memcg-zap-memcg_slab_caches-and-memcg_slab_mutex.patch
swap-remove-unused-mem_cgroup_uncharge_swapcache-declaration.patch
mm-memcontrol-track-move_lock-state-internally.patch
mm-vmscan-wake-up-all-pfmemalloc-throttled-processes-at-once.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch

