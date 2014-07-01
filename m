From: akpm@linux-foundation.org
Subject: + slab-defer-slab_destroy-in-free_block.patch added to -mm tree
Date: Tue, 01 Jul 2014 15:16:45 -0700
Message-ID: <53b3334d.OXpRayH49fKl0CwT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:49143 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879AbaGAWQq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2014 18:16:46 -0400
Received: by mail-yh0-f73.google.com with SMTP id f10so1118453yha.2
        for <mm-commits@vger.kernel.org>; Tue, 01 Jul 2014 15:16:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: defer slab_destroy in free_block()
has been added to the -mm tree.  Its filename is
     slab-defer-slab_destroy-in-free_block.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-defer-slab_destroy-in-free_block.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slab-defer-slab_destroy-in-free_block.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   63 +++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 43 insertions(+), 20 deletions(-)

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
@@ -1184,6 +1189,7 @@ static void cpuup_canceled(long cpu)
 		struct array_cache *nc;
 		struct array_cache *shared;
 		struct array_cache **alien;
+		LIST_HEAD(list);
 
 		/* cpu is dead; no one can alloc from it. */
 		nc = cachep->array[cpu];
@@ -1199,7 +1205,7 @@ static void cpuup_canceled(long cpu)
 		if (!memcg_cache_dead(cachep))
 			n->free_limit -= cachep->batchcount;
 		if (nc)
-			free_block(cachep, nc->entry, nc->avail, node);
+			free_block(cachep, nc->entry, nc->avail, node, &list);
 
 		if (!cpumask_empty(mask)) {
 			spin_unlock_irq(&n->list_lock);
@@ -1209,7 +1215,7 @@ static void cpuup_canceled(long cpu)
 		shared = n->shared;
 		if (shared) {
 			free_block(cachep, shared->entry,
-				   shared->avail, node);
+				   shared->avail, node, &list);
 			n->shared = NULL;
 		}
 
@@ -1224,6 +1230,7 @@ static void cpuup_canceled(long cpu)
 			free_alien_cache(alien);
 		}
 free_array_cache:
+		slabs_destroy(cachep, &list);
 		kfree(nc);
 	}
 	/*
@@ -2062,6 +2069,16 @@ static void slab_destroy(struct kmem_cac
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
@@ -2465,6 +2482,7 @@ static void do_drain(void *arg)
 	struct array_cache *ac;
 	int node = numa_mem_id();
 	struct kmem_cache_node *n;
+	LIST_HEAD(list);
 
 	check_irq_off();
 	ac = cpu_cache_get(cachep);
@@ -2473,8 +2491,9 @@ static void do_drain(void *arg)
 
 	n = get_node(cachep, node);
 	spin_lock(&n->list_lock);
-	free_block(cachep, ac->entry, ac->avail, node);
+	free_block(cachep, ac->entry, ac->avail, node, &list);
 	spin_unlock(&n->list_lock);
+	slabs_destroy(cachep, &list);
 	ac->avail = 0;
 	if (memcg_cache_dead(cachep)) {
 		cachep->array[smp_processor_id()] = NULL;
@@ -3413,8 +3432,8 @@ slab_alloc(struct kmem_cache *cachep, gf
 /*
  * Caller needs to acquire correct kmem_cache_node's list_lock
  */
-static void free_block(struct kmem_cache *cachep, void **objpp, int nr_objects,
-		       int node)
+static void free_block(struct kmem_cache *cachep, void **objpp,
+			int nr_objects, int node, struct list_head *list)
 {
 	int i;
 	struct kmem_cache_node *n = get_node(cachep, node);
@@ -3437,13 +3456,7 @@ static void free_block(struct kmem_cache
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
@@ -3462,6 +3475,7 @@ static void cache_flusharray(struct kmem
 	int batchcount;
 	struct kmem_cache_node *n;
 	int node = numa_mem_id();
+	LIST_HEAD(list);
 
 	batchcount = ac->batchcount;
 #if DEBUG
@@ -3483,7 +3497,7 @@ static void cache_flusharray(struct kmem
 		}
 	}
 
-	free_block(cachep, ac->entry, batchcount, node);
+	free_block(cachep, ac->entry, batchcount, node, &list);
 free_done:
 #if STATS
 	{
@@ -3504,6 +3518,7 @@ free_done:
 	}
 #endif
 	spin_unlock(&n->list_lock);
+	slabs_destroy(cachep, &list);
 	ac->avail -= batchcount;
 	memmove(ac->entry, &(ac->entry[batchcount]), sizeof(void *)*ac->avail);
 }
@@ -3531,11 +3546,13 @@ static inline void __cache_free(struct k
 
 #ifdef CONFIG_MEMCG_KMEM
 	if (unlikely(!ac)) {
+		LIST_HEAD(list);
 		int nodeid = page_to_nid(virt_to_page(objp));
 
 		spin_lock(&cachep->node[nodeid]->list_lock);
-		free_block(cachep, &objp, 1, nodeid);
+		free_block(cachep, &objp, 1, nodeid, &list);
 		spin_unlock(&cachep->node[nodeid]->list_lock);
+		slabs_destroy(cachep, &list);
 		return;
 	}
 #endif
@@ -3801,12 +3818,13 @@ static int alloc_kmem_cache_node(struct
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
@@ -3816,6 +3834,7 @@ static int alloc_kmem_cache_node(struct
 			n->free_limit = (1 + nr_cpus_node(node)) *
 					cachep->batchcount + cachep->num;
 			spin_unlock_irq(&n->list_lock);
+			slabs_destroy(cachep, &list);
 			kfree(shared);
 			free_alien_cache(new_alien);
 			continue;
@@ -3908,6 +3927,7 @@ static int __do_tune_cpucache(struct kme
 	cachep->shared = shared;
 
 	for_each_online_cpu(i) {
+		LIST_HEAD(list);
 		struct array_cache *ccold = new->new[i];
 		int node;
 		struct kmem_cache_node *n;
@@ -3918,8 +3938,9 @@ static int __do_tune_cpucache(struct kme
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
@@ -4027,6 +4048,7 @@ skip_setup:
 static void drain_array(struct kmem_cache *cachep, struct kmem_cache_node *n,
 			 struct array_cache *ac, int force, int node)
 {
+	LIST_HEAD(list);
 	int tofree;
 
 	if (!ac || !ac->avail)
@@ -4039,12 +4061,13 @@ static void drain_array(struct kmem_cach
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

slub-fix-off-by-one-in-number-of-slab-tests.patch
mm-slabc-add-__init-to-init_lock_keys.patch
slab-common-add-functions-for-kmem_cache_node-access.patch
slub-use-new-node-functions.patch
slub-use-new-node-functions-fix.patch
slab-use-get_node-and-kmem_cache_node-functions.patch
slab-use-get_node-and-kmem_cache_node-functions-fix.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
mm-slabh-wrap-the-whole-file-with-guarding-macro.patch
mm-slub-mark-resiliency_test-as-init-text.patch
mm-slub-slub_debug=n-use-the-same-alloc-free-hooks-as-for-slub_debug=y.patch
memcg-cleanup-memcg_cache_params-refcnt-usage.patch
memcg-destroy-kmem-caches-when-last-slab-is-freed.patch
memcg-mark-caches-that-belong-to-offline-memcgs-as-dead.patch
slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails.patch
slub-make-slab_free-non-preemptable.patch
memcg-wait-for-kfrees-to-finish-before-destroying-cache.patch
slub-make-dead-memcg-caches-discard-free-slabs-immediately.patch
slub-kmem_cache_shrink-check-if-partial-list-is-empty-under-list_lock.patch
slab-do-not-keep-free-objects-slabs-on-dead-memcg-caches.patch
slab-set-free_limit-for-dead-caches-to-0.patch
slab-add-unlikely-macro-to-help-compiler.patch
slab-move-up-code-to-get-kmem_cache_node-in-free_block.patch
slab-defer-slab_destroy-in-free_block.patch
slab-factor-out-initialization-of-arracy-cache.patch
slab-introduce-alien_cache.patch
slab-use-the-lock-on-alien_cache-instead-of-the-lock-on-array_cache.patch
slab-destroy-a-slab-without-holding-any-alien-cache-lock.patch
slab-remove-a-useless-lockdep-annotation.patch
slab-remove-bad_alien_magic.patch
slub-reduce-duplicate-creation-on-the-first-object.patch
vmalloc-use-rcu-list-iterator-to-reduce-vmap_area_lock-contention.patch
dma-cma-separate-core-cma-management-codes-from-dma-apis.patch
dma-cma-support-alignment-constraint-on-cma-region.patch
dma-cma-support-arbitrary-bitmap-granularity.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
cma-generalize-cma-reserved-area-management-functionality.patch
cma-generalize-cma-reserved-area-management-functionality-fix.patch
ppc-kvm-cma-use-general-cma-reserved-area-management-framework.patch
ppc-kvm-cma-use-general-cma-reserved-area-management-framework-fix.patch
mm-cma-clean-up-cma-allocation-error-path.patch
mm-cma-change-cma_declare_contiguous-to-obey-coding-convention.patch
mm-cma-clean-up-log-message.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
page-owners-correct-page-order-when-to-free-page.patch

