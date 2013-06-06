From: akpm@linux-foundation.org
Subject: [to-be-updated] vmscan-also-shrink-slab-in-memcg-pressure.patch
 removed from -mm tree
Date: Thu, 06 Jun 2013 12:35:09 -0700
Message-ID: <51b0e46d.pk+0gU1tlyEzn71o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51983 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656Ab3FFTfK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jun 2013 15:35:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dchinner@redhat.com, glommer@openvz.org

Subject: [to-be-updated] vmscan-also-shrink-slab-in-memcg-pressure.patch removed from -mm tree
To: glommer@openvz.org,dchinner@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 06 Jun 2013 12:35:09 -0700


The patch titled
     Subject: vmscan: also shrink slab in memcg pressure
has been removed from the -mm tree.  Its filename was
     vmscan-also-shrink-slab-in-memcg-pressure.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Glauber Costa <glommer@openvz.org>
Subject: vmscan: also shrink slab in memcg pressure

Without the surrounding infrastructure, this patch is a bit of a hammer:
it will basically shrink objects from all memcgs under memcg pressure.  At
least, however, we will keep the scan limited to the shrinkers marked as
per-memcg.

Future patches will implement the in-shrinker logic to filter objects
based on its memcg association.

Cc: Glauber Costa <glommer@openvz.org>
Cc: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   17 ++++++++++++
 include/linux/shrinker.h   |    6 +++-
 mm/memcontrol.c            |   16 +++++++++++-
 mm/vmscan.c                |   46 ++++++++++++++++++++++++++++++++---
 4 files changed, 80 insertions(+), 5 deletions(-)

diff -puN include/linux/memcontrol.h~vmscan-also-shrink-slab-in-memcg-pressure include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~vmscan-also-shrink-slab-in-memcg-pressure
+++ a/include/linux/memcontrol.h
@@ -200,6 +200,9 @@ void mem_cgroup_split_huge_fixup(struct
 bool mem_cgroup_bad_page_check(struct page *page);
 void mem_cgroup_print_bad_page(struct page *page);
 #endif
+
+unsigned long
+memcg_zone_reclaimable_pages(struct mem_cgroup *memcg, struct zone *zone);
 #else /* CONFIG_MEMCG */
 struct mem_cgroup;
 
@@ -378,6 +381,12 @@ static inline void mem_cgroup_replace_pa
 				struct page *newpage)
 {
 }
+
+static inline unsigned long
+memcg_zone_reclaimable_pages(struct mem_cgroup *memcg, struct zone *zone)
+{
+	return 0;
+}
 #endif /* CONFIG_MEMCG */
 
 #if !defined(CONFIG_MEMCG) || !defined(CONFIG_DEBUG_VM)
@@ -430,6 +439,8 @@ static inline bool memcg_kmem_enabled(vo
 	return static_key_false(&memcg_kmem_enabled_key);
 }
 
+bool memcg_kmem_is_active(struct mem_cgroup *memcg);
+
 /*
  * In general, we'll do everything in our power to not incur in any overhead
  * for non-memcg users for the kmem functions. Not even a function call, if we
@@ -563,6 +574,12 @@ memcg_kmem_get_cache(struct kmem_cache *
 	return __memcg_kmem_get_cache(cachep, gfp);
 }
 #else
+
+static inline bool memcg_kmem_is_active(struct mem_cgroup *memcg)
+{
+	return false;
+}
+
 #define for_each_memcg_cache_index(_idx)	\
 	for (; NULL; )
 
diff -puN include/linux/shrinker.h~vmscan-also-shrink-slab-in-memcg-pressure include/linux/shrinker.h
--- a/include/linux/shrinker.h~vmscan-also-shrink-slab-in-memcg-pressure
+++ a/include/linux/shrinker.h
@@ -22,6 +22,9 @@ struct shrink_control {
 	nodemask_t nodes_to_scan;
 	/* current node being shrunk (for NUMA aware shrinkers) */
 	int nid;
+
+	/* reclaim from this memcg only (if not NULL) */
+	struct mem_cgroup *target_mem_cgroup;
 };
 
 /*
@@ -75,7 +78,8 @@ struct shrinker {
 #define DEFAULT_SEEKS 2 /* A good number if you don't know better. */
 
 /* Flags */
-#define SHRINKER_NUMA_AWARE (1 << 0)
+#define SHRINKER_NUMA_AWARE	(1 << 0)
+#define SHRINKER_MEMCG_AWARE	(1 << 1)
 
 extern int register_shrinker(struct shrinker *);
 extern void unregister_shrinker(struct shrinker *);
diff -puN mm/memcontrol.c~vmscan-also-shrink-slab-in-memcg-pressure mm/memcontrol.c
--- a/mm/memcontrol.c~vmscan-also-shrink-slab-in-memcg-pressure
+++ a/mm/memcontrol.c
@@ -465,7 +465,7 @@ static inline void memcg_kmem_set_active
 	set_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_account_flags);
 }
 
-static bool memcg_kmem_is_active(struct mem_cgroup *memcg)
+bool memcg_kmem_is_active(struct mem_cgroup *memcg)
 {
 	return test_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_account_flags);
 }
@@ -1044,6 +1044,20 @@ mem_cgroup_zone_nr_lru_pages(struct mem_
 	return ret;
 }
 
+unsigned long
+memcg_zone_reclaimable_pages(struct mem_cgroup *memcg, struct zone *zone)
+{
+	int nid = zone_to_nid(zone);
+	int zid = zone_idx(zone);
+	unsigned long val;
+
+	val = mem_cgroup_zone_nr_lru_pages(memcg, nid, zid, LRU_ALL_FILE);
+	if (do_swap_account)
+		val += mem_cgroup_zone_nr_lru_pages(memcg, nid, zid,
+						    LRU_ALL_ANON);
+	return val;
+}
+
 static unsigned long
 mem_cgroup_node_nr_lru_pages(struct mem_cgroup *memcg,
 			int nid, unsigned int lru_mask)
diff -puN mm/vmscan.c~vmscan-also-shrink-slab-in-memcg-pressure mm/vmscan.c
--- a/mm/vmscan.c~vmscan-also-shrink-slab-in-memcg-pressure
+++ a/mm/vmscan.c
@@ -139,11 +139,42 @@ static bool global_reclaim(struct scan_c
 {
 	return !sc->target_mem_cgroup;
 }
+
+/*
+ * kmem reclaim should usually not be triggered when we are doing targetted
+ * reclaim. It is only valid when global reclaim is triggered, or when the
+ * underlying memcg has kmem objects.
+ */
+static bool has_kmem_reclaim(struct scan_control *sc)
+{
+	return !sc->target_mem_cgroup ||
+		memcg_kmem_is_active(sc->target_mem_cgroup);
+}
+
+static unsigned long
+zone_nr_reclaimable_pages(struct scan_control *sc, struct zone *zone)
+{
+	if (global_reclaim(sc))
+		return zone_reclaimable_pages(zone);
+	return memcg_zone_reclaimable_pages(sc->target_mem_cgroup, zone);
+}
+
 #else
 static bool global_reclaim(struct scan_control *sc)
 {
 	return true;
 }
+
+static bool has_kmem_reclaim(struct scan_control *sc)
+{
+	return true;
+}
+
+static unsigned long
+zone_nr_reclaimable_pages(struct scan_control *sc, struct zone *zone)
+{
+	return zone_reclaimable_pages(zone);
+}
 #endif
 
 static unsigned long get_lru_size(struct lruvec *lruvec, enum lru_list lru)
@@ -332,6 +363,14 @@ unsigned long shrink_slab(struct shrink_
 	}
 
 	list_for_each_entry(shrinker, &shrinker_list, list) {
+		/*
+		 * If we don't have a target mem cgroup, we scan them all.
+		 * Otherwise we will limit our scan to shrinkers marked as
+		 * memcg aware
+		 */
+		if (shrinkctl->target_mem_cgroup &&
+		    !(shrinker->flags & SHRINKER_MEMCG_AWARE))
+			continue;
 
 		if (!(shrinker->flags & SHRINKER_NUMA_AWARE)) {
 			shrinkctl->nid = 0;
@@ -2402,9 +2441,9 @@ static unsigned long do_try_to_free_page
 
 		/*
 		 * Don't shrink slabs when reclaiming memory from
-		 * over limit cgroups
+		 * over limit cgroups, unless we know they have kmem objects
 		 */
-		if (global_reclaim(sc)) {
+		if (has_kmem_reclaim(sc)) {
 			unsigned long lru_pages = 0;
 
 			nodes_clear(shrink->nodes_to_scan);
@@ -2413,7 +2452,7 @@ static unsigned long do_try_to_free_page
 				if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
 					continue;
 
-				lru_pages += zone_reclaimable_pages(zone);
+				lru_pages += zone_nr_reclaimable_pages(sc, zone);
 				node_set(zone_to_nid(zone),
 					 shrink->nodes_to_scan);
 			}
@@ -2670,6 +2709,7 @@ unsigned long try_to_free_mem_cgroup_pag
 	};
 	struct shrink_control shrink = {
 		.gfp_mask = sc.gfp_mask,
+		.target_mem_cgroup = memcg,
 	};
 
 	/*
_

Patches currently in -mm which might be from glommer@openvz.org are

memcglist_lru-duplicate-lrus-upon-kmemcg-creation.patch
lru-add-an-element-to-a-memcg-list.patch
list_lru-per-memcg-walks.patch
memcg-per-memcg-kmem-shrinking.patch
memcg-scan-cache-objects-hierarchically.patch
vmscan-take-at-least-one-pass-with-shrinkers.patch
super-targeted-memcg-reclaim.patch
memcg-move-initialization-to-memcg-creation.patch
vmpressure-in-kernel-notifications.patch
memcg-reap-dead-memcgs-upon-global-memory-pressure.patch

