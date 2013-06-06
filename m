From: akpm@linux-foundation.org
Subject: [to-be-updated] memcg-scan-cache-objects-hierarchically.patch
 removed from -mm tree
Date: Thu, 06 Jun 2013 12:35:19 -0700
Message-ID: <51b0e477.f4WNhzOjoaSfGBIZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51998 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296Ab3FFTfU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jun 2013 15:35:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dchinner@redhat.com, glommer@openvz.org

Subject: [to-be-updated] memcg-scan-cache-objects-hierarchically.patch removed from -mm tree
To: glommer@openvz.org,dchinner@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 06 Jun 2013 12:35:19 -0700


The patch titled
     Subject: memcg: scan cache objects hierarchically
has been removed from the -mm tree.  Its filename was
     memcg-scan-cache-objects-hierarchically.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Glauber Costa <glommer@openvz.org>
Subject: memcg: scan cache objects hierarchically

When reaching shrink_slab, we should descent in children memcg searching
for objects that could be shrunk.  This is true even if the memcg does not
have kmem limits on, since the kmem res_counter will also be billed
against the user res_counter of the parent.

It is possible that we will free objects and not free any pages, that will
just harm the child groups without helping the parent group at all.  But
at this point, we basically are prepared to pay the price.

Cc: Glauber Costa <glommer@openvz.org>
Cc: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 ++
 mm/memcontrol.c            |   13 +++++
 mm/vmscan.c                |   81 +++++++++++++++++++++++++++--------
 3 files changed, 82 insertions(+), 18 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-scan-cache-objects-hierarchically include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-scan-cache-objects-hierarchically
+++ a/include/linux/memcontrol.h
@@ -441,6 +441,7 @@ static inline bool memcg_kmem_enabled(vo
 	return static_key_false(&memcg_kmem_enabled_key);
 }
 
+bool memcg_kmem_should_reclaim(struct mem_cgroup *memcg);
 bool memcg_kmem_is_active(struct mem_cgroup *memcg);
 
 /*
@@ -585,6 +586,11 @@ memcg_kmem_get_cache(struct kmem_cache *
 }
 #else
 
+static inline bool memcg_kmem_should_reclaim(struct mem_cgroup *memcg)
+{
+	return false;
+}
+
 static inline bool memcg_kmem_is_active(struct mem_cgroup *memcg)
 {
 	return false;
diff -puN mm/memcontrol.c~memcg-scan-cache-objects-hierarchically mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-scan-cache-objects-hierarchically
+++ a/mm/memcontrol.c
@@ -3069,6 +3069,19 @@ static void __mem_cgroup_commit_charge(s
 }
 
 #ifdef CONFIG_MEMCG_KMEM
+bool memcg_kmem_should_reclaim(struct mem_cgroup *memcg)
+{
+	struct mem_cgroup *iter;
+
+	for_each_mem_cgroup_tree(iter, memcg) {
+		if (memcg_kmem_is_active(iter)) {
+			mem_cgroup_iter_break(memcg, iter);
+			return true;
+		}
+	}
+	return false;
+}
+
 static inline bool memcg_can_account_kmem(struct mem_cgroup *memcg)
 {
 	return !mem_cgroup_disabled() && !mem_cgroup_is_root(memcg) &&
diff -puN mm/vmscan.c~memcg-scan-cache-objects-hierarchically mm/vmscan.c
--- a/mm/vmscan.c~memcg-scan-cache-objects-hierarchically
+++ a/mm/vmscan.c
@@ -148,7 +148,7 @@ static bool global_reclaim(struct scan_c
 static bool has_kmem_reclaim(struct scan_control *sc)
 {
 	return !sc->target_mem_cgroup ||
-		memcg_kmem_is_active(sc->target_mem_cgroup);
+		memcg_kmem_should_reclaim(sc->target_mem_cgroup);
 }
 
 static unsigned long
@@ -346,12 +346,39 @@ shrink_slab_node(struct shrink_control *
  *
  * Returns the number of slab objects which we shrunk.
  */
+static unsigned long
+shrink_slab_one(struct shrink_control *shrinkctl, struct shrinker *shrinker,
+		unsigned long nr_pages_scanned, unsigned long lru_pages)
+{
+	unsigned long freed = 0;
+
+	if (!(shrinker->flags & SHRINKER_NUMA_AWARE)) {
+		shrinkctl->nid = 0;
+
+		return shrink_slab_node(shrinkctl, shrinker,
+			 nr_pages_scanned, lru_pages,
+			 &shrinker->nr_deferred);
+	}
+
+	for_each_node_mask(shrinkctl->nid, shrinkctl->nodes_to_scan) {
+		if (!node_online(shrinkctl->nid))
+			continue;
+
+		freed += shrink_slab_node(shrinkctl, shrinker,
+			 nr_pages_scanned, lru_pages,
+			 &shrinker->nr_deferred_node[shrinkctl->nid]);
+	}
+
+	return freed;
+}
+
 unsigned long shrink_slab(struct shrink_control *shrinkctl,
 			  unsigned long nr_pages_scanned,
 			  unsigned long lru_pages)
 {
 	struct shrinker *shrinker;
 	unsigned long freed = 0;
+	struct mem_cgroup *root = shrinkctl->target_mem_cgroup;
 
 	if (nr_pages_scanned == 0)
 		nr_pages_scanned = SWAP_CLUSTER_MAX;
@@ -368,27 +395,45 @@ unsigned long shrink_slab(struct shrink_
 		 * Otherwise we will limit our scan to shrinkers marked as
 		 * memcg aware
 		 */
-		if (shrinkctl->target_mem_cgroup &&
-		    !(shrinker->flags & SHRINKER_MEMCG_AWARE))
+		if (!(shrinker->flags & SHRINKER_MEMCG_AWARE) &&
+			shrinkctl->target_mem_cgroup)
 			continue;
 
-		if (!(shrinker->flags & SHRINKER_NUMA_AWARE)) {
-			shrinkctl->nid = 0;
+		/*
+		 * In a hierarchical chain, it might be that not all memcgs are
+		 * kmem active. kmemcg design mandates that when one memcg is
+		 * active, its children will be active as well. But it is
+		 * perfectly possible that its parent is not.
+		 *
+		 * We also need to make sure we scan at least once, for the
+		 * global case. So if we don't have a target memcg (saved in
+		 * root), we proceed normally and expect to break in the next
+		 * round.
+		 */
+		do {
+			struct mem_cgroup *memcg = shrinkctl->target_mem_cgroup;
 
-			freed += shrink_slab_node(shrinkctl, shrinker,
-				 nr_pages_scanned, lru_pages,
-				 &shrinker->nr_deferred);
-			continue;
-		}
+			if (!memcg || memcg_kmem_is_active(memcg))
+				freed += shrink_slab_one(shrinkctl, shrinker,
+					 nr_pages_scanned, lru_pages);
+
+			/*
+			 * For non-memcg aware shrinkers, we will arrive here
+			 * at first pass because we need to scan the root
+			 * memcg.  We need to bail out, since exactly because
+			 * they are not memcg aware, instead of noticing they
+			 * have nothing to shrink, they will just shrink again,
+			 * and deplete too many objects.
+			 */
+			if (!(shrinker->flags & SHRINKER_MEMCG_AWARE))
+				break;
+
+			shrinkctl->target_mem_cgroup =
+				mem_cgroup_iter(root, memcg, NULL);
+		} while (shrinkctl->target_mem_cgroup);
 
-		for_each_node_mask(shrinkctl->nid, shrinkctl->nodes_to_scan) {
-			if (!node_online(shrinkctl->nid))
-				continue;
