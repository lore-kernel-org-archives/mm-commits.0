From: akpm@linux-foundation.org
Subject: [merged] slab-defer-slab_destroy-in-free_block.patch removed from -mm tree
Date: Thu, 07 Aug 2014 13:03:07 -0700
Message-ID: <53e3db7b.llnv/LhlPpZZDzbN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yk0-f202.google.com ([209.85.160.202]:33212 "EHLO
	mail-yk0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288AbaHGUDI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:03:08 -0400
Received: by mail-yk0-f202.google.com with SMTP id q9so611819ykb.3
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:03:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: defer slab_destroy in free_block()
has been removed from the -mm tree.  Its filename was
     slab-defer-slab_destroy-in-free_block.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: slab: defer slab_destroy in free_block()

In free_block(), if freeing object makes new free slab and number of
free_objects exceeds free_limit, we start to destroy this new free slab
with holding the kmem_cache node lock.  Holding the lock is useless and,
generally, holding a lock as least as possible is good thing.  I never
measure performance effect of this, but we'd be better not to hold the
lock as much as possible.

Commented by Christoph:
  This is also good because kmem_cache_free is no longer called while
  holding the node lock. So we avoid one case of recursion.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   60 +++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 41 insertions(+), 19 deletions(-)

diff -puN mm/slab.c~slab-defer-slab_destroy-in-free_block mm/slab.c
--- a/mm/slab.c~slab-defer-slab_destroy-in-free_block
+++ a/mm/slab.c
@@ -242,7 +242,8 @@ static struct kmem_cache_node __initdata
 static int drain_freelist(struct kmem_cache *cache,
 			struct kmem_cache_node *n, int tofree);
 static void free_block(struct kmem_cache *cachep, void **objpp, int len,
-			int node);
+			int node, struct list_head *list);
+static void slabs_destroy(struct kmem_cache *cachep, struct list_head *list);
 static int enable_cpucache(struct kmem_cache *cachep, gfp_t gfp);
 static void cache_reap(struct work_struct *unused);
 
@@ -1030,6 +1031,7 @@ static void __drain_alien_cache(struct k
 				struct array_cache *ac, int node)
 {
 	struct kmem_cache_node *n = get_node(cachep, node);
+	LIST_HEAD(list);
 
 	if (ac->avail) {
 		spin_lock(&n->list_lock);
@@ -1041,9 +1043,10 @@ static void __drain_alien_cache(struct k
 		if (n->shared)
 			transfer_objects(n->shared, ac, ac->limit);
 
-		free_block(cachep, ac->entry, ac->avail, node);
+		free_block(cachep, ac->entry, ac->avail, node, &list);
 		ac->avail = 0;
 		spin_unlock(&n->list_lock);
+		slabs_destroy(cachep, &list);
 	}
 }
 
@@ -1087,6 +1090,7 @@ static inline int cache_free_alien(struc
 	struct kmem_cache_node *n;
 	struct array_cache *alien = NULL;
 	int node;
+	LIST_HEAD(list);
 
 	node = numa_mem_id();
 
@@ -1111,8 +1115,9 @@ static inline int cache_free_alien(struc
 	} else {
 		n = get_node(cachep, nodeid);
 		spin_lock(&n->list_lock);
-		free_block(cachep, &objp, 1, nodeid);
+		free_block(cachep, &objp, 1, nodeid, &list);
 		spin_unlock(&n->list_lock);
+		slabs_destroy(cachep, &list);
 	}
 	return 1;
 }
@@ -1182,6 +1187,7 @@ static void cpuup_canceled(long cpu)
 		struct array_cache *nc;
 		struct array_cache *shared;
 		struct array_cache **alien;
+		LIST_HEAD(list);
 
 		/* cpu is dead; no one can alloc from it. */
 		nc = cachep->array[cpu];
@@ -1196,7 +1202,7 @@ static void cpuup_canceled(long cpu)
 		/* Free limit for this kmem_cache_node */
 		n->free_limit -= cachep->batchcount;
 		if (nc)
-			free_block(cachep, nc->entry, nc->avail, node);
+			free_block(cachep, nc->entry, nc->avail, node, &list);
 
 		if (!cpumask_empty(mask)) {
 			spin_unlock_irq(&n->list_lock);
@@ -1206,7 +1212,7 @@ static void cpuup_canceled(long cpu)
 		shared = n->shared;
 		if (shared) {
 			free_block(cachep, shared->entry,
-				   shared->avail, node);
+				   shared->avail, node, &list);
 			n->shared = NULL;
 		}
 
@@ -1221,6 +1227,7 @@ static void cpuup_canceled(long cpu)
 			free_alien_cache(alien);
 		}
 free_array_cache:
+		slabs_destroy(cachep, &list);
 		kfree(nc);
 	}
 	/*
@@ -2056,6 +2063,16 @@ static void slab_destroy(struct kmem_cac
 		kmem_cache_free(cachep->freelist_cache, freelist);
 }
 
+static void slabs_destroy(struct kmem_cache *cachep, struct list_head *list)
+{
+	struct page *page, *n;
+
+	list_for_each_entry_safe(page, n, list, lru) {
+		list_del(&page->lru);
+		slab_destroy(cachep, page);
+	}
+}
+
 /**
  * calculate_slab_order - calculate size (page order) of slabs
  * @cachep: pointer to the cache that is being created
@@ -2459,13 +2476,15 @@ static void do_drain(void *arg)
 	struct array_cache *ac;
 	int node = numa_mem_id();
 	struct kmem_cache_node *n;
+	LIST_HEAD(list);
 
 	check_irq_off();
 	ac = cpu_cache_get(cachep);
 	n = get_node(cachep, node);
 	spin_lock(&n->list_lock);
-	free_block(cachep, ac->entry, ac->avail, node);
+	free_block(cachep, ac->entry, ac->avail, node, &list);
 	spin_unlock(&n->list_lock);
+	slabs_destroy(cachep, &list);
 	ac->avail = 0;
 }
 
@@ -3393,9 +3412,10 @@ slab_alloc(struct kmem_cache *cachep, gf
 
 /*
  * Caller needs to acquire correct kmem_cache_node's list_lock
+ * @list: List of detached free slabs should be freed by caller
  */
-static void free_block(struct kmem_cache *cachep, void **objpp, int nr_objects,
-		       int node)
+static void free_block(struct kmem_cache *cachep, void **objpp,
+			int nr_objects, int node, struct list_head *list)
 {
 	int i;
 	struct kmem_cache_node *n = get_node(cachep, node);
@@ -3418,13 +3438,7 @@ static void free_block(struct kmem_cache
 		if (page->active == 0) {
 			if (n->free_objects > n->free_limit) {
 				n->free_objects -= cachep->num;
-				/* No need to drop any previously held
-				 * lock here, even if we have a off-slab slab
-				 * descriptor it is guaranteed to come from
-				 * a different cache, refer to comments before
-				 * alloc_slabmgmt.
-				 */
-				slab_destroy(cachep, page);
+				list_add_tail(&page->lru, list);
 			} else {
 				list_add(&page->lru, &n->slabs_free);
 			}
@@ -3443,6 +3457,7 @@ static void cache_flusharray(struct kmem
 	int batchcount;
 	struct kmem_cache_node *n;
 	int node = numa_mem_id();
+	LIST_HEAD(list);
 
 	batchcount = ac->batchcount;
 #if DEBUG
@@ -3464,7 +3479,7 @@ static void cache_flusharray(struct kmem
 		}
 	}
 
-	free_block(cachep, ac->entry, batchcount, node);
+	free_block(cachep, ac->entry, batchcount, node, &list);
 free_done:
 #if STATS
 	{
@@ -3485,6 +3500,7 @@ free_done:
 	}
 #endif
 	spin_unlock(&n->list_lock);
+	slabs_destroy(cachep, &list);
 	ac->avail -= batchcount;
 	memmove(ac->entry, &(ac->entry[batchcount]), sizeof(void *)*ac->avail);
 }
@@ -3765,12 +3781,13 @@ static int alloc_kmem_cache_node(struct
 		n = get_node(cachep, node);
 		if (n) {
 			struct array_cache *shared = n->shared;
+			LIST_HEAD(list);
 
 			spin_lock_irq(&n->list_lock);
 
 			if (shared)
 				free_block(cachep, shared->entry,
-						shared->avail, node);
+						shared->avail, node, &list);
 
 			n->shared = new_shared;
 			if (!n->alien) {
@@ -3780,6 +3797,7 @@ static int alloc_kmem_cache_node(struct
 			n->free_limit = (1 + nr_cpus_node(node)) *
 					cachep->batchcount + cachep->num;
 			spin_unlock_irq(&n->list_lock);
+			slabs_destroy(cachep, &list);
 			kfree(shared);
 			free_alien_cache(new_alien);
 			continue;
@@ -3869,6 +3887,7 @@ static int __do_tune_cpucache(struct kme
 	cachep->shared = shared;
 
 	for_each_online_cpu(i) {
+		LIST_HEAD(list);
 		struct array_cache *ccold = new->new[i];
 		int node;
 		struct kmem_cache_node *n;
@@ -3879,8 +3898,9 @@ static int __do_tune_cpucache(struct kme
 		node = cpu_to_mem(i);
 		n = get_node(cachep, node);
 		spin_lock_irq(&n->list_lock);
-		free_block(cachep, ccold->entry, ccold->avail, node);
+		free_block(cachep, ccold->entry, ccold->avail, node, &list);
 		spin_unlock_irq(&n->list_lock);
+		slabs_destroy(cachep, &list);
 		kfree(ccold);
 	}
 	kfree(new);
@@ -3988,6 +4008,7 @@ skip_setup:
 static void drain_array(struct kmem_cache *cachep, struct kmem_cache_node *n,
 			 struct array_cache *ac, int force, int node)
 {
+	LIST_HEAD(list);
 	int tofree;
 
 	if (!ac || !ac->avail)
@@ -4000,12 +4021,13 @@ static void drain_array(struct kmem_cach
 			tofree = force ? ac->avail : (ac->limit + 4) / 5;
 			if (tofree > ac->avail)
 				tofree = (ac->avail + 1) / 2;
-			free_block(cachep, ac->entry, tofree, node);
+			free_block(cachep, ac->entry, tofree, node, &list);
 			ac->avail -= tofree;
 			memmove(ac->entry, &(ac->entry[tofree]),
 				sizeof(void *) * ac->avail);
 		}
 		spin_unlock_irq(&n->list_lock);
+		slabs_destroy(cachep, &list);
 	}
 }
 
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
page-owners-correct-page-order-when-to-free-page.patch

