From: akpm@linux-foundation.org
Subject: [merged] vmscan-per-memory-cgroup-slab-shrinkers.patch removed
 from -mm tree
Date: Fri, 13 Feb 2015 12:19:48 -0800
Message-ID: <54de5c64.Wc4t/L+h/DNEh4jX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48675 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbbBMUTt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:19:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, david@fromorbit.com, glommer@gmail.com, gthelen@google.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, tj@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan: per memory cgroup slab shrinkers
has been removed from the -mm tree.  Its filename was
     vmscan-per-memory-cgroup-slab-shrinkers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 mm/vmscan.c                |   85 +++++++++++++++++++++++++----------
 7 files changed, 80 insertions(+), 50 deletions(-)

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
@@ -413,6 +413,8 @@ static inline bool memcg_kmem_enabled(vo
 	return static_key_false(&memcg_kmem_enabled_key);
 }
 
+bool memcg_kmem_is_active(struct mem_cgroup *memcg);
+
 /*
  * In general, we'll do everything in our power to not incur in any overhead
  * for non-memcg users for the kmem functions. Not even a function call, if we
@@ -541,6 +543,11 @@ static inline bool memcg_kmem_enabled(vo
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
@@ -2168,9 +2168,8 @@ int drop_caches_sysctl_handler(struct ct
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
@@ -352,7 +352,7 @@ struct mem_cgroup {
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
@@ -232,10 +232,10 @@ EXPORT_SYMBOL(unregister_shrinker);
 
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
@@ -344,9 +344,10 @@ static unsigned long shrink_slabs(struct
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
@@ -355,6 +356,12 @@ static unsigned long shrink_slabs(struct
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
@@ -365,13 +372,17 @@ static unsigned long shrink_slabs(struct
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
 
@@ -390,12 +401,16 @@ unsigned long shrink_node_slabs(gfp_t gf
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
@@ -404,6 +419,29 @@ out:
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
@@ -2276,6 +2314,7 @@ static inline bool should_continue_recla
 static bool shrink_zone(struct zone *zone, struct scan_control *sc,
 			bool is_classzone)
 {
+	struct reclaim_state *reclaim_state = current->reclaim_state;
 	unsigned long nr_reclaimed, nr_scanned;
 	bool reclaimable = false;
 
@@ -2294,6 +2333,7 @@ static bool shrink_zone(struct zone *zon
 		memcg = mem_cgroup_iter(root, NULL, &reclaim);
 		do {
 			unsigned long lru_pages;
+			unsigned long scanned;
 			struct lruvec *lruvec;
 			int swappiness;
 
@@ -2305,10 +2345,16 @@ static bool shrink_zone(struct zone *zon
 
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
@@ -2330,19 +2376,14 @@ static bool shrink_zone(struct zone *zon
 		 * Shrink the slab caches in the same proportion that
 		 * the eligible LRU pages were scanned.
 		 */
-		if (global_reclaim(sc) && is_classzone) {
-			struct reclaim_state *reclaim_state;
-
-			shrink_node_slabs(sc->gfp_mask, zone_to_nid(zone),
-					  sc->nr_scanned - nr_scanned,
-					  zone_lru_pages);
