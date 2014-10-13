From: akpm@linux-foundation.org
Subject: [merged] mm-slab-use-percpu-allocator-for-cpu-cache.patch removed from -mm tree
Date: Mon, 13 Oct 2014 11:18:57 -0700
Message-ID: <543c1791.d58gj243uSYfRYq6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60187 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690AbaJMSS5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:18:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cl@linux.com, jmmahler@gmail.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: use percpu allocator for cpu cache
has been removed from the -mm tree.  Its filename was
     mm-slab-use-percpu-allocator-for-cpu-cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slab: use percpu allocator for cpu cache

Because of chicken and egg problem, initialization of SLAB is really
complicated.  We need to allocate cpu cache through SLAB to make the
kmem_cache work, but before initialization of kmem_cache, allocation
through SLAB is impossible.

On the other hand, SLUB does initialization in a more simple way.  It uses
percpu allocator to allocate cpu cache so there is no chicken and egg
problem.

So, this patch try to use percpu allocator in SLAB.  This simplifies the
initialization step in SLAB so that we could maintain SLAB code more
easily.

In my testing there is no performance difference.

This implementation relies on percpu allocator.  Because percpu allocator
uses vmalloc address space, vmalloc address space could be exhausted by
this change on many cpu system with *32 bit* kernel.  This implementation
can cover 1024 cpus in worst case by following calculation.

Worst: 1024 cpus * 4 bytes for pointer * 300 kmem_caches *
	120 objects per cpu_cache = 140 MB
Normal: 1024 cpus * 4 bytes for pointer * 150 kmem_caches(slab merge) *
	80 objects per cpu_cache = 46 MB

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Jeremiah Mahler <jmmahler@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab_def.h |   20 ---
 mm/slab.c                |  241 +++++++++++--------------------------
 mm/slab.h                |    1 
 3 files changed, 79 insertions(+), 183 deletions(-)

diff -puN include/linux/slab_def.h~mm-slab-use-percpu-allocator-for-cpu-cache include/linux/slab_def.h
--- a/include/linux/slab_def.h~mm-slab-use-percpu-allocator-for-cpu-cache
+++ a/include/linux/slab_def.h
@@ -8,6 +8,8 @@
  */
 
 struct kmem_cache {
+	struct array_cache __percpu *cpu_cache;
+
 /* 1) Cache tunables. Protected by slab_mutex */
 	unsigned int batchcount;
 	unsigned int limit;
@@ -71,23 +73,7 @@ struct kmem_cache {
 	struct memcg_cache_params *memcg_params;
 #endif
 
-/* 6) per-cpu/per-node data, touched during every alloc/free */
-	/*
-	 * We put array[] at the end of kmem_cache, because we want to size
-	 * this array to nr_cpu_ids slots instead of NR_CPUS
-	 * (see kmem_cache_init())
-	 * We still use [NR_CPUS] and not [1] or [0] because cache_cache
-	 * is statically defined, so we reserve the max number of cpus.
-	 *
-	 * We also need to guarantee that the list is able to accomodate a
-	 * pointer for each node since "nodelists" uses the remainder of
-	 * available pointers.
-	 */
-	struct kmem_cache_node **node;
-	struct array_cache *array[NR_CPUS + MAX_NUMNODES];
-	/*
-	 * Do not add fields after array[]
-	 */
+	struct kmem_cache_node *node[MAX_NUMNODES];
 };
 
 #endif	/* _LINUX_SLAB_DEF_H */
diff -puN mm/slab.c~mm-slab-use-percpu-allocator-for-cpu-cache mm/slab.c
--- a/mm/slab.c~mm-slab-use-percpu-allocator-for-cpu-cache
+++ a/mm/slab.c
@@ -237,11 +237,10 @@ struct arraycache_init {
 /*
  * Need this for bootstrapping a per node allocator.
  */
-#define NUM_INIT_LISTS (3 * MAX_NUMNODES)
+#define NUM_INIT_LISTS (2 * MAX_NUMNODES)
 static struct kmem_cache_node __initdata init_kmem_cache_node[NUM_INIT_LISTS];
 #define	CACHE_CACHE 0
-#define	SIZE_AC MAX_NUMNODES
-#define	SIZE_NODE (2 * MAX_NUMNODES)
+#define	SIZE_NODE (MAX_NUMNODES)
 
 static int drain_freelist(struct kmem_cache *cache,
 			struct kmem_cache_node *n, int tofree);
@@ -253,7 +252,6 @@ static void cache_reap(struct work_struc
 
 static int slab_early_init = 1;
 
-#define INDEX_AC kmalloc_index(sizeof(struct arraycache_init))
 #define INDEX_NODE kmalloc_index(sizeof(struct kmem_cache_node))
 
 static void kmem_cache_node_init(struct kmem_cache_node *parent)
@@ -458,9 +456,6 @@ static inline unsigned int obj_to_index(
 	return reciprocal_divide(offset, cache->reciprocal_buffer_size);
 }
 
-static struct arraycache_init initarray_generic =
-    { {0, BOOT_CPUCACHE_ENTRIES, 1, 0} };
-
 /* internal cache of cache description objs */
 static struct kmem_cache kmem_cache_boot = {
 	.batchcount = 1,
@@ -476,7 +471,7 @@ static DEFINE_PER_CPU(struct delayed_wor
 
 static inline struct array_cache *cpu_cache_get(struct kmem_cache *cachep)
 {
-	return cachep->array[smp_processor_id()];
+	return this_cpu_ptr(cachep->cpu_cache);
 }
 
 static size_t calculate_freelist_size(int nr_objs, size_t align)
@@ -1096,24 +1091,25 @@ static void cpuup_canceled(long cpu)
 		struct alien_cache **alien;
 		LIST_HEAD(list);
 
-		/* cpu is dead; no one can alloc from it. */
-		nc = cachep->array[cpu];
-		cachep->array[cpu] = NULL;
 		n = get_node(cachep, node);
-
 		if (!n)
-			goto free_array_cache;
+			continue;
 
 		spin_lock_irq(&n->list_lock);
 
 		/* Free limit for this kmem_cache_node */
 		n->free_limit -= cachep->batchcount;
-		if (nc)
+
+		/* cpu is dead; no one can alloc from it. */
+		nc = per_cpu_ptr(cachep->cpu_cache, cpu);
+		if (nc) {
 			free_block(cachep, nc->entry, nc->avail, node, &list);
+			nc->avail = 0;
+		}
 
 		if (!cpumask_empty(mask)) {
 			spin_unlock_irq(&n->list_lock);
-			goto free_array_cache;
+			goto free_slab;
 		}
 
 		shared = n->shared;
@@ -1133,9 +1129,9 @@ static void cpuup_canceled(long cpu)
 			drain_alien_cache(cachep, alien);
 			free_alien_cache(alien);
 		}
-free_array_cache:
+
+free_slab:
 		slabs_destroy(cachep, &list);
-		kfree(nc);
 	}
 	/*
 	 * In the previous loop, all the objects were freed to
@@ -1172,32 +1168,23 @@ static int cpuup_prepare(long cpu)
 	 * array caches
 	 */
 	list_for_each_entry(cachep, &slab_caches, list) {
-		struct array_cache *nc;
 		struct array_cache *shared = NULL;
 		struct alien_cache **alien = NULL;
 
-		nc = alloc_arraycache(node, cachep->limit,
-					cachep->batchcount, GFP_KERNEL);
-		if (!nc)
-			goto bad;
 		if (cachep->shared) {
 			shared = alloc_arraycache(node,
 				cachep->shared * cachep->batchcount,
 				0xbaadf00d, GFP_KERNEL);
-			if (!shared) {
-				kfree(nc);
+			if (!shared)
 				goto bad;
-			}
 		}
 		if (use_alien_caches) {
 			alien = alloc_alien_cache(node, cachep->limit, GFP_KERNEL);
 			if (!alien) {
 				kfree(shared);
-				kfree(nc);
 				goto bad;
 			}
 		}
-		cachep->array[cpu] = nc;
 		n = get_node(cachep, node);
 		BUG_ON(!n);
 
@@ -1389,15 +1376,6 @@ static void __init set_up_node(struct km
 }
 
 /*
- * The memory after the last cpu cache pointer is used for the
- * the node pointer.
- */
-static void setup_node_pointer(struct kmem_cache *cachep)
-{
-	cachep->node = (struct kmem_cache_node **)&cachep->array[nr_cpu_ids];
-}
-
-/*
  * Initialisation.  Called after the page allocator have been initialised and
  * before smp_init().
  */
@@ -1408,7 +1386,6 @@ void __init kmem_cache_init(void)
 	BUILD_BUG_ON(sizeof(((struct page *)NULL)->lru) <
 					sizeof(struct rcu_head));
 	kmem_cache = &kmem_cache_boot;
-	setup_node_pointer(kmem_cache);
 
 	if (num_possible_nodes() == 1)
 		use_alien_caches = 0;
@@ -1416,8 +1393,6 @@ void __init kmem_cache_init(void)
 	for (i = 0; i < NUM_INIT_LISTS; i++)
 		kmem_cache_node_init(&init_kmem_cache_node[i]);
 
-	set_up_node(kmem_cache, CACHE_CACHE);
-
 	/*
 	 * Fragmentation resistance on low memory - only use bigger
 	 * page orders on machines with more than 32MB of memory if
@@ -1452,49 +1427,22 @@ void __init kmem_cache_init(void)
 	 * struct kmem_cache size depends on nr_node_ids & nr_cpu_ids
 	 */
 	create_boot_cache(kmem_cache, "kmem_cache",
-		offsetof(struct kmem_cache, array[nr_cpu_ids]) +
+		offsetof(struct kmem_cache, node) +
 				  nr_node_ids * sizeof(struct kmem_cache_node *),
 				  SLAB_HWCACHE_ALIGN);
 	list_add(&kmem_cache->list, &slab_caches);
-
-	/* 2+3) create the kmalloc caches */
+	slab_state = PARTIAL;
 
 	/*
-	 * Initialize the caches that provide memory for the array cache and the
-	 * kmem_cache_node structures first.  Without this, further allocations will
-	 * bug.
+	 * Initialize the caches that provide memory for the  kmem_cache_node
+	 * structures first.  Without this, further allocations will bug.
 	 */
-
-	kmalloc_caches[INDEX_AC] = create_kmalloc_cache("kmalloc-ac",
-					kmalloc_size(INDEX_AC), ARCH_KMALLOC_FLAGS);
-
-	if (INDEX_AC != INDEX_NODE)
-		kmalloc_caches[INDEX_NODE] =
-			create_kmalloc_cache("kmalloc-node",
+	kmalloc_caches[INDEX_NODE] = create_kmalloc_cache("kmalloc-node",
 				kmalloc_size(INDEX_NODE), ARCH_KMALLOC_FLAGS);
+	slab_state = PARTIAL_NODE;
 
 	slab_early_init = 0;
 
-	/* 4) Replace the bootstrap head arrays */
-	{
-		struct array_cache *ptr;
-
-		ptr = kmalloc(sizeof(struct arraycache_init), GFP_NOWAIT);
-
-		memcpy(ptr, cpu_cache_get(kmem_cache),
-		       sizeof(struct arraycache_init));
-
-		kmem_cache->array[smp_processor_id()] = ptr;
-
-		ptr = kmalloc(sizeof(struct arraycache_init), GFP_NOWAIT);
-
-		BUG_ON(cpu_cache_get(kmalloc_caches[INDEX_AC])
-		       != &initarray_generic.cache);
-		memcpy(ptr, cpu_cache_get(kmalloc_caches[INDEX_AC]),
-		       sizeof(struct arraycache_init));
-
-		kmalloc_caches[INDEX_AC]->array[smp_processor_id()] = ptr;
-	}
 	/* 5) Replace the bootstrap kmem_cache_node */
 	{
 		int nid;
@@ -1502,13 +1450,8 @@ void __init kmem_cache_init(void)
 		for_each_online_node(nid) {
 			init_list(kmem_cache, &init_kmem_cache_node[CACHE_CACHE + nid], nid);
 
-			init_list(kmalloc_caches[INDEX_AC],
-				  &init_kmem_cache_node[SIZE_AC + nid], nid);
-
-			if (INDEX_AC != INDEX_NODE) {
-				init_list(kmalloc_caches[INDEX_NODE],
+			init_list(kmalloc_caches[INDEX_NODE],
 					  &init_kmem_cache_node[SIZE_NODE + nid], nid);
-			}
 		}
 	}
 
@@ -2041,56 +1984,53 @@ static size_t calculate_slab_order(struc
 	return left_over;
 }
 
+static struct array_cache __percpu *alloc_kmem_cache_cpus(
+		struct kmem_cache *cachep, int entries, int batchcount)
+{
+	int cpu;
+	size_t size;
+	struct array_cache __percpu *cpu_cache;
+
+	size = sizeof(void *) * entries + sizeof(struct array_cache);
+	cpu_cache = __alloc_percpu(size, 0);
+
+	if (!cpu_cache)
+		return NULL;
+
+	for_each_possible_cpu(cpu) {
+		init_arraycache(per_cpu_ptr(cpu_cache, cpu),
+				entries, batchcount);
+	}
+
+	return cpu_cache;
+}
+
 static int __init_refok setup_cpu_cache(struct kmem_cache *cachep, gfp_t gfp)
 {
 	if (slab_state >= FULL)
 		return enable_cpucache(cachep, gfp);
 
+	cachep->cpu_cache = alloc_kmem_cache_cpus(cachep, 1, 1);
+	if (!cachep->cpu_cache)
+		return 1;
+
 	if (slab_state == DOWN) {
-		/*
-		 * Note: Creation of first cache (kmem_cache).
-		 * The setup_node is taken care
-		 * of by the caller of __kmem_cache_create
-		 */
-		cachep->array[smp_processor_id()] = &initarray_generic.cache;
-		slab_state = PARTIAL;
+		/* Creation of first cache (kmem_cache). */
+		set_up_node(kmem_cache, CACHE_CACHE);
 	} else if (slab_state == PARTIAL) {
-		/*
-		 * Note: the second kmem_cache_create must create the cache
-		 * that's used by kmalloc(24), otherwise the creation of
-		 * further caches will BUG().
-		 */
-		cachep->array[smp_processor_id()] = &initarray_generic.cache;
-
-		/*
-		 * If the cache that's used by kmalloc(sizeof(kmem_cache_node)) is
-		 * the second cache, then we need to set up all its node/,
-		 * otherwise the creation of further caches will BUG().
-		 */
-		set_up_node(cachep, SIZE_AC);
-		if (INDEX_AC == INDEX_NODE)
-			slab_state = PARTIAL_NODE;
-		else
-			slab_state = PARTIAL_ARRAYCACHE;
+		/* For kmem_cache_node */
+		set_up_node(cachep, SIZE_NODE);
 	} else {
-		/* Remaining boot caches */
-		cachep->array[smp_processor_id()] =
-			kmalloc(sizeof(struct arraycache_init), gfp);
-
-		if (slab_state == PARTIAL_ARRAYCACHE) {
-			set_up_node(cachep, SIZE_NODE);
-			slab_state = PARTIAL_NODE;
-		} else {
-			int node;
-			for_each_online_node(node) {
-				cachep->node[node] =
-				    kmalloc_node(sizeof(struct kmem_cache_node),
-						gfp, node);
-				BUG_ON(!cachep->node[node]);
-				kmem_cache_node_init(cachep->node[node]);
-			}
+		int node;
+
+		for_each_online_node(node) {
+			cachep->node[node] = kmalloc_node(
+				sizeof(struct kmem_cache_node), gfp, node);
+			BUG_ON(!cachep->node[node]);
+			kmem_cache_node_init(cachep->node[node]);
 		}
 	}
+
 	cachep->node[numa_mem_id()]->next_reap =
 			jiffies + REAPTIMEOUT_NODE +
 			((unsigned long)cachep) % REAPTIMEOUT_NODE;
@@ -2213,7 +2153,6 @@ __kmem_cache_create (struct kmem_cache *
 	else
 		gfp = GFP_NOWAIT;
 
-	setup_node_pointer(cachep);
 #if DEBUG
 
 	/*
@@ -2470,8 +2409,7 @@ int __kmem_cache_shutdown(struct kmem_ca
 	if (rc)
 		return rc;
 
-	for_each_online_cpu(i)
-	    kfree(cachep->array[i]);
+	free_percpu(cachep->cpu_cache);
 
 	/* NUMA: free the node structures */
 	for_each_kmem_cache_node(cachep, i, n) {
@@ -3719,72 +3657,45 @@ fail:
 	return -ENOMEM;
 }
 
-struct ccupdate_struct {
-	struct kmem_cache *cachep;
-	struct array_cache *new[0];
-};
-
-static void do_ccupdate_local(void *info)
-{
-	struct ccupdate_struct *new = info;
-	struct array_cache *old;
-
-	check_irq_off();
-	old = cpu_cache_get(new->cachep);
-
-	new->cachep->array[smp_processor_id()] = new->new[smp_processor_id()];
-	new->new[smp_processor_id()] = old;
-}
-
 /* Always called with the slab_mutex held */
 static int __do_tune_cpucache(struct kmem_cache *cachep, int limit,
 				int batchcount, int shared, gfp_t gfp)
 {
-	struct ccupdate_struct *new;
-	int i;
+	struct array_cache __percpu *cpu_cache, *prev;
+	int cpu;
 
-	new = kzalloc(sizeof(*new) + nr_cpu_ids * sizeof(struct array_cache *),
-		      gfp);
-	if (!new)
+	cpu_cache = alloc_kmem_cache_cpus(cachep, limit, batchcount);
+	if (!cpu_cache)
 		return -ENOMEM;
 
-	for_each_online_cpu(i) {
-		new->new[i] = alloc_arraycache(cpu_to_mem(i), limit,
-						batchcount, gfp);
-		if (!new->new[i]) {
-			for (i--; i >= 0; i--)
-				kfree(new->new[i]);
-			kfree(new);
-			return -ENOMEM;
-		}
-	}
-	new->cachep = cachep;
-
-	on_each_cpu(do_ccupdate_local, (void *)new, 1);
+	prev = cachep->cpu_cache;
+	cachep->cpu_cache = cpu_cache;
+	kick_all_cpus_sync();
 
 	check_irq_on();
 	cachep->batchcount = batchcount;
 	cachep->limit = limit;
 	cachep->shared = shared;
 
-	for_each_online_cpu(i) {
+	if (!prev)
+		goto alloc_node;
+
+	for_each_online_cpu(cpu) {
 		LIST_HEAD(list);
-		struct array_cache *ccold = new->new[i];
 		int node;
 		struct kmem_cache_node *n;
+		struct array_cache *ac = per_cpu_ptr(prev, cpu);
 
-		if (!ccold)
-			continue;
-
-		node = cpu_to_mem(i);
+		node = cpu_to_mem(cpu);
 		n = get_node(cachep, node);
 		spin_lock_irq(&n->list_lock);
-		free_block(cachep, ccold->entry, ccold->avail, node, &list);
+		free_block(cachep, ac->entry, ac->avail, node, &list);
 		spin_unlock_irq(&n->list_lock);
 		slabs_destroy(cachep, &list);
-		kfree(ccold);
 	}
-	kfree(new);
+	free_percpu(prev);
+
+alloc_node:
 	return alloc_kmem_cache_node(cachep, gfp);
 }
 
diff -puN mm/slab.h~mm-slab-use-percpu-allocator-for-cpu-cache mm/slab.h
--- a/mm/slab.h~mm-slab-use-percpu-allocator-for-cpu-cache
+++ a/mm/slab.h
@@ -50,7 +50,6 @@ struct kmem_cache {
 enum slab_state {
 	DOWN,			/* No slab functionality yet */
 	PARTIAL,		/* SLUB: kmem_cache_node available */
-	PARTIAL_ARRAYCACHE,	/* SLAB: kmalloc size for arraycache available */
 	PARTIAL_NODE,		/* SLAB: kmalloc size for node struct available */
 	UP,			/* Slab caches usable but not all extras yet */
 	FULL			/* Everything is working */
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
drivers-dma-coherent-add-initialization-from-device-tree.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-checkpatch-fixes.patch
drivers-dma-contiguous-add-initialization-from-device-tree.patch
page-owners-correct-page-order-when-to-free-page.patch

