From: akpm@linux-foundation.org
Subject: + slab-use-get_node-and-kmem_cache_node-functions.patch added to
 -mm tree
Date: Tue, 17 Jun 2014 14:17:59 -0700
Message-ID: <53a0b087.wnG1kbVc7rR1HVE1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57115 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964907AbaFQVSA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jun 2014 17:18:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, penberg@kernel.org, iamjoonsoo.kim@lge.com, cl@linux.com


The patch titled
     Subject: slab: use get_node() and kmem_cache_node() functions
has been added to the -mm tree.  Its filename is
     slab-use-get_node-and-kmem_cache_node-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-use-get_node-and-kmem_cache_node-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slab-use-get_node-and-kmem_cache_node-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: slab: use get_node() and kmem_cache_node() functions

Use the two functions to simplify the code avoiding numerous explicit
checks coded checking for a certain node to be online.

Get rid of various repeated calculations of kmem_cache_node structures.

Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |  167 +++++++++++++++++++++++-----------------------------
 1 file changed, 77 insertions(+), 90 deletions(-)

diff -puN mm/slab.c~slab-use-get_node-and-kmem_cache_node-functions mm/slab.c
--- a/mm/slab.c~slab-use-get_node-and-kmem_cache_node-functions
+++ a/mm/slab.c
@@ -267,7 +267,7 @@ static void kmem_cache_node_init(struct
 #define MAKE_LIST(cachep, listp, slab, nodeid)				\
 	do {								\
 		INIT_LIST_HEAD(listp);					\
-		list_splice(&(cachep->node[nodeid]->slab), listp);	\
+		list_splice(&get_node(cachep, nodeid)->slab, listp);	\
 	} while (0)
 
 #define	MAKE_ALL_LISTS(cachep, ptr, nodeid)				\
@@ -488,16 +488,11 @@ static struct lock_class_key debugobj_al
 
 static void slab_set_lock_classes(struct kmem_cache *cachep,
 		struct lock_class_key *l3_key, struct lock_class_key *alc_key,
-		int q)
+		struct kmem_cache_node *n)
 {
 	struct array_cache **alc;
-	struct kmem_cache_node *n;
 	int r;
 
-	n = cachep->node[q];
-	if (!n)
-		return;
-
 	lockdep_set_class(&n->list_lock, l3_key);
 	alc = n->alien;
 	/*
@@ -515,17 +510,19 @@ static void slab_set_lock_classes(struct
 	}
 }
 
-static void slab_set_debugobj_lock_classes_node(struct kmem_cache *cachep, int node)
+static void slab_set_debugobj_lock_classes_node(struct kmem_cache *cachep,
+	struct kmem_cache_node *n)
 {
-	slab_set_lock_classes(cachep, &debugobj_l3_key, &debugobj_alc_key, node);
+	slab_set_lock_classes(cachep, &debugobj_l3_key, &debugobj_alc_key, n);
 }
 
 static void slab_set_debugobj_lock_classes(struct kmem_cache *cachep)
 {
 	int node;
+	struct kmem_cache_node *n;
 
-	for_each_online_node(node)
-		slab_set_debugobj_lock_classes_node(cachep, node);
+	for_each_kmem_cache_node(cachep, node, h)
+		slab_set_debugobj_lock_classes_node(cachep, n);
 }
 
 static void init_node_lock_keys(int q)
@@ -542,31 +539,30 @@ static void init_node_lock_keys(int q)
 		if (!cache)
 			continue;
 
-		n = cache->node[q];
+		n = get_node(cache, q);
 		if (!n || OFF_SLAB(cache))
 			continue;
 
 		slab_set_lock_classes(cache, &on_slab_l3_key,
-				&on_slab_alc_key, q);
+				&on_slab_alc_key, n);
 	}
 }
 
-static void on_slab_lock_classes_node(struct kmem_cache *cachep, int q)
+static void on_slab_lock_classes_node(struct kmem_cache *cachep,
+	struct kmem_cache_node *n)
 {
-	if (!cachep->node[q])
-		return;
-
 	slab_set_lock_classes(cachep, &on_slab_l3_key,
-			&on_slab_alc_key, q);
+			&on_slab_alc_key, n);
 }
 
 static inline void on_slab_lock_classes(struct kmem_cache *cachep)
 {
 	int node;
+	struct kmem_cache_node *n;
 
 	VM_BUG_ON(OFF_SLAB(cachep));
-	for_each_node(node)
-		on_slab_lock_classes_node(cachep, node);
+	for_each_kmem_cache_node(cachep, node, h)
+		on_slab_lock_classes_node(cachep, h);
 }
 
 static inline void __init init_lock_keys(void)
@@ -589,7 +585,8 @@ static inline void on_slab_lock_classes(
 {
 }
 
-static inline void on_slab_lock_classes_node(struct kmem_cache *cachep, int node)
+static inline void on_slab_lock_classes_node(struct kmem_cache *cachep,
+	int node, struct kmem_cache_node *n)
 {
 }
 
@@ -826,7 +823,7 @@ static inline bool is_slab_pfmemalloc(st
 static void recheck_pfmemalloc_active(struct kmem_cache *cachep,
 						struct array_cache *ac)
 {
-	struct kmem_cache_node *n = cachep->node[numa_mem_id()];
+	struct kmem_cache_node *n = get_node(cachep,numa_mem_id());
 	struct page *page;
 	unsigned long flags;
 
@@ -881,7 +878,7 @@ static void *__ac_get_obj(struct kmem_ca
 		 * If there are empty slabs on the slabs_free list and we are
 		 * being forced to refill the cache, mark this one !pfmemalloc.
 		 */
-		n = cachep->node[numa_mem_id()];
+		n = get_node(cachep, numa_mem_id());
 		if (!list_empty(&n->slabs_free) && force_refill) {
 			struct page *page = virt_to_head_page(objp);
 			ClearPageSlabPfmemalloc(page);
@@ -1031,7 +1028,7 @@ static void free_alien_cache(struct arra
 static void __drain_alien_cache(struct kmem_cache *cachep,
 				struct array_cache *ac, int node)
 {
-	struct kmem_cache_node *n = cachep->node[node];
+	struct kmem_cache_node *n = get_node(cachep, node);
 
 	if (ac->avail) {
 		spin_lock(&n->list_lock);
@@ -1099,7 +1096,7 @@ static inline int cache_free_alien(struc
 	if (likely(nodeid == node))
 		return 0;
 
-	n = cachep->node[node];
+	n = get_node(cachep, node);
 	STATS_INC_NODEFREES(cachep);
 	if (n->alien && n->alien[nodeid]) {
 		alien = n->alien[nodeid];
@@ -1111,9 +1108,10 @@ static inline int cache_free_alien(struc
 		ac_put_obj(cachep, alien, objp);
 		spin_unlock(&alien->lock);
 	} else {
-		spin_lock(&(cachep->node[nodeid])->list_lock);
+		n = get_node(cachep, nodeid);
+		spin_lock(&n->list_lock);
 		free_block(cachep, &objp, 1, nodeid);
-		spin_unlock(&(cachep->node[nodeid])->list_lock);
+		spin_unlock(&n->list_lock);
 	}
 	return 1;
 }
@@ -1140,7 +1138,8 @@ static int init_cache_node_node(int node
 		 * begin anything. Make sure some other cpu on this
 		 * node has not already allocated this
 		 */
-		if (!cachep->node[node]) {
+		n = get_node(cachep, node);
+		if (!n) {
 			n = kmalloc_node(memsize, GFP_KERNEL, node);
 			if (!n)
 				return -ENOMEM;
@@ -1156,11 +1155,11 @@ static int init_cache_node_node(int node
 			cachep->node[node] = n;
 		}
 
-		spin_lock_irq(&cachep->node[node]->list_lock);
-		cachep->node[node]->free_limit =
+		spin_lock_irq(&n->list_lock);
+		n->free_limit =
 			(1 + nr_cpus_node(node)) *
 			cachep->batchcount + cachep->num;
-		spin_unlock_irq(&cachep->node[node]->list_lock);
+		spin_unlock_irq(&n->list_lock);
 	}
 	return 0;
 }
@@ -1186,7 +1185,7 @@ static void cpuup_canceled(long cpu)
 		/* cpu is dead; no one can alloc from it. */
 		nc = cachep->array[cpu];
 		cachep->array[cpu] = NULL;
-		n = cachep->node[node];
+		n = get_node(cachep, node);
 
 		if (!n)
 			goto free_array_cache;
@@ -1229,7 +1228,7 @@ free_array_cache:
 	 * shrink each nodelist to its limit.
 	 */
 	list_for_each_entry(cachep, &slab_caches, list) {
-		n = cachep->node[node];
+		n = get_node(cachep, node);
 		if (!n)
 			continue;
 		drain_freelist(cachep, n, slabs_tofree(cachep, n));
@@ -1284,7 +1283,7 @@ static int cpuup_prepare(long cpu)
 			}
 		}
 		cachep->array[cpu] = nc;
-		n = cachep->node[node];
+		n = get_node(cachep, node);
 		BUG_ON(!n);
 
 		spin_lock_irq(&n->list_lock);
@@ -1309,7 +1308,7 @@ static int cpuup_prepare(long cpu)
 			slab_set_debugobj_lock_classes_node(cachep, node);
 		else if (!OFF_SLAB(cachep) &&
 			 !(cachep->flags & SLAB_DESTROY_BY_RCU))
-			on_slab_lock_classes_node(cachep, node);
+			on_slab_lock_classes_node(cachep, node, n);
 	}
 	init_node_lock_keys(node);
 
@@ -1395,7 +1394,7 @@ static int __meminit drain_cache_node_no
 	list_for_each_entry(cachep, &slab_caches, list) {
 		struct kmem_cache_node *n;
 
-		n = cachep->node[node];
+		n = get_node(cachep, node);
 		if (!n)
 			continue;
 
@@ -1690,14 +1689,10 @@ slab_out_of_memory(struct kmem_cache *ca
 	printk(KERN_WARNING "  cache: %s, object size: %d, order: %d\n",
 		cachep->name, cachep->size, cachep->gfporder);
 
-	for_each_online_node(node) {
+	for_each_kmem_cache_node(cachep, node, n) {
 		unsigned long active_objs = 0, num_objs = 0, free_objects = 0;
 		unsigned long active_slabs = 0, num_slabs = 0;
 
-		n = cachep->node[node];
-		if (!n)
-			continue;
-
 		spin_lock_irqsave(&n->list_lock, flags);
 		list_for_each_entry(page, &n->slabs_full, lru) {
 			active_objs += cachep->num;
@@ -2431,7 +2426,7 @@ static void check_spinlock_acquired(stru
 {
 #ifdef CONFIG_SMP
 	check_irq_off();
-	assert_spin_locked(&cachep->node[numa_mem_id()]->list_lock);
+	assert_spin_locked(&get_node(cachep, numa_mem_id())->list_lock);
 #endif
 }
 
@@ -2439,7 +2434,7 @@ static void check_spinlock_acquired_node
 {
 #ifdef CONFIG_SMP
 	check_irq_off();
-	assert_spin_locked(&cachep->node[node]->list_lock);
+	assert_spin_locked(&get_node(cachep, node)->list_lock);
 #endif
 }
 
@@ -2459,12 +2454,14 @@ static void do_drain(void *arg)
 	struct kmem_cache *cachep = arg;
 	struct array_cache *ac;
 	int node = numa_mem_id();
+	struct kmem_cache_node *n;
 
 	check_irq_off();
 	ac = cpu_cache_get(cachep);
-	spin_lock(&cachep->node[node]->list_lock);
+	n = get_node(cachep, node);
+	spin_lock(&n->list_lock);
 	free_block(cachep, ac->entry, ac->avail, node);
-	spin_unlock(&cachep->node[node]->list_lock);
+	spin_unlock(&n->list_lock);
 	ac->avail = 0;
 }
 
@@ -2475,17 +2472,12 @@ static void drain_cpu_caches(struct kmem
 
 	on_each_cpu(do_drain, cachep, 1);
 	check_irq_on();
-	for_each_online_node(node) {
-		n = cachep->node[node];
-		if (n && n->alien)
+	for_each_kmem_cache_node(cachep, node, n)
+		if (n->alien)
 			drain_alien_cache(cachep, n->alien);
-	}
 
-	for_each_online_node(node) {
-		n = cachep->node[node];
-		if (n)
-			drain_array(cachep, n, n->shared, 1, node);
-	}
+	for_each_kmem_cache_node(cachep, node, n)
+		drain_array(cachep, n, n->shared, 1, node);
 }
 
 /*
@@ -2531,17 +2523,14 @@ out:
 
 int __kmem_cache_shrink(struct kmem_cache *cachep)
 {
-	int ret = 0, i = 0;
+	int ret = 0;
+	int node;
 	struct kmem_cache_node *n;
 
 	drain_cpu_caches(cachep);
 
 	check_irq_on();
-	for_each_online_node(i) {
-		n = cachep->node[i];
-		if (!n)
-			continue;
-
+	for_each_kmem_cache_node(cachep, node, n) {
 		drain_freelist(cachep, n, slabs_tofree(cachep, n));
 
 		ret += !list_empty(&n->slabs_full) ||
@@ -2563,13 +2552,11 @@ int __kmem_cache_shutdown(struct kmem_ca
 	    kfree(cachep->array[i]);
 
 	/* NUMA: free the node structures */
-	for_each_online_node(i) {
-		n = cachep->node[i];
-		if (n) {
-			kfree(n->shared);
-			free_alien_cache(n->alien);
-			kfree(n);
-		}
+	for_each_kmem_cache_node(cachep, i, n) {
+		kfree(n->shared);
+		free_alien_cache(n->alien);
+		kfree(n);
+		cachep->node[i] = NULL;
 	}
 	return 0;
 }
@@ -2748,7 +2735,7 @@ static int cache_grow(struct kmem_cache
 
 	/* Take the node list lock to change the colour_next on this node */
 	check_irq_off();
-	n = cachep->node[nodeid];
+	n = get_node(cachep, nodeid);
 	spin_lock(&n->list_lock);
 
 	/* Get colour for the slab, and cal the next value. */
@@ -2917,7 +2904,7 @@ retry:
 		 */
 		batchcount = BATCHREFILL_LIMIT;
 	}
-	n = cachep->node[node];
+	n = get_node(cachep, node);
 
 	BUG_ON(ac->avail > 0 || !n);
 	spin_lock(&n->list_lock);
@@ -3166,8 +3153,8 @@ retry:
 		nid = zone_to_nid(zone);
 
 		if (cpuset_zone_allowed_hardwall(zone, flags) &&
-			cache->node[nid] &&
-			cache->node[nid]->free_objects) {
+			get_node(cache, nid) &&
+			get_node(cache, nid)->free_objects) {
 				obj = ____cache_alloc_node(cache,
 					flags | GFP_THISNODE, nid);
 				if (obj)
@@ -3230,7 +3217,7 @@ static void *____cache_alloc_node(struct
 	int x;
 
 	VM_BUG_ON(nodeid > num_online_nodes());
-	n = cachep->node[nodeid];
+	n = get_node(cachep, nodeid);
 	BUG_ON(!n);
 
 retry:
@@ -3301,7 +3288,7 @@ slab_alloc_node(struct kmem_cache *cache
 	if (nodeid == NUMA_NO_NODE)
 		nodeid = slab_node;
 
-	if (unlikely(!cachep->node[nodeid])) {
+	if (unlikely(!get_node(cachep, nodeid))) {
 		/* Node not bootstrapped yet */
 		ptr = fallback_alloc(cachep, flags);
 		goto out;
@@ -3417,7 +3404,7 @@ static void free_block(struct kmem_cache
 		objp = objpp[i];
 
 		page = virt_to_head_page(objp);
-		n = cachep->node[node];
+		n = get_node(cachep, node);
 		list_del(&page->lru);
 		check_spinlock_acquired_node(cachep, node);
 		slab_put_obj(cachep, page, objp, node);
@@ -3459,7 +3446,7 @@ static void cache_flusharray(struct kmem
 	BUG_ON(!batchcount || batchcount > ac->avail);
 #endif
 	check_irq_off();
-	n = cachep->node[node];
+	n = get_node(cachep, node);
 	spin_lock(&n->list_lock);
 	if (n->shared) {
 		struct array_cache *shared_array = n->shared;
@@ -3772,7 +3759,7 @@ static int alloc_kmem_cache_node(struct
 			}
 		}
 
-		n = cachep->node[node];
+		n = get_node(cachep, node);
 		if (n) {
 			struct array_cache *shared = n->shared;
 
@@ -3817,8 +3804,8 @@ fail:
 		/* Cache is not active yet. Roll back what we did */
 		node--;
 		while (node >= 0) {
-			if (cachep->node[node]) {
-				n = cachep->node[node];
+			if (get_node(cachep, node)) {
+				n = get_node(cachep, node);
 
 				kfree(n->shared);
 				free_alien_cache(n->alien);
@@ -3881,11 +3868,17 @@ static int __do_tune_cpucache(struct kme
 
 	for_each_online_cpu(i) {
 		struct array_cache *ccold = new->new[i];
+		int node;
+		struct kmem_cache_node *n;
+
 		if (!ccold)
 			continue;
-		spin_lock_irq(&cachep->node[cpu_to_mem(i)]->list_lock);
-		free_block(cachep, ccold->entry, ccold->avail, cpu_to_mem(i));
-		spin_unlock_irq(&cachep->node[cpu_to_mem(i)]->list_lock);
+
+		node = cpu_to_mem(i);
+		n = get_node(cachep, node);
+		spin_lock_irq(&n->list_lock);
+		free_block(cachep, ccold->entry, ccold->avail, node);
+		spin_unlock_irq(&n->list_lock);
 		kfree(ccold);
 	}
 	kfree(new);
@@ -4045,7 +4038,7 @@ static void cache_reap(struct work_struc
 		 * have established with reasonable certainty that
 		 * we can do some work if the lock was obtained.
 		 */
-		n = searchp->node[node];
+		n = get_node(searchp, node);
 
 		reap_alien(searchp, n);
 
@@ -4097,10 +4090,7 @@ void get_slabinfo(struct kmem_cache *cac
 
 	active_objs = 0;
 	num_slabs = 0;
-	for_each_online_node(node) {
-		n = cachep->node[node];
-		if (!n)
-			continue;
+	for_each_kmem_cache_node(cachep, node, n) {
 
 		check_irq_on();
 		spin_lock_irq(&n->list_lock);
@@ -4325,10 +4315,7 @@ static int leaks_show(struct seq_file *m
 
 	x[1] = 0;
 
-	for_each_online_node(node) {
-		n = cachep->node[node];
-		if (!n)
-			continue;
+	for_each_kmem_cache_node(cachep, node, n) {
 
 		check_irq_on();
 		spin_lock_irq(&n->list_lock);
_

Patches currently in -mm which might be from cl@linux.com are

hugetlb-fix-copy_hugetlb_page_range-to-handle-migration-hwpoisoned-entry.patch
slab-maintainer-update.patch
slab-fix-oops-when-reading-proc-slab_allocators.patch
mm-slabc-add-__init-to-init_lock_keys.patch
slab-common-add-functions-for-kmem_cache_node-access.patch
slub-use-new-node-functions.patch
slub-use-new-node-functions-fix.patch
slab-use-get_node-and-kmem_cache_node-functions.patch
slab-use-get_node-and-kmem_cache_node-functions-fix.patch
linux-next.patch

