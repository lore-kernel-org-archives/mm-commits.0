From: akpm@linux-foundation.org
Subject: [merged] slab-remove-a-useless-lockdep-annotation.patch removed
 from -mm tree
Date: Thu, 07 Aug 2014 13:03:17 -0700
Message-ID: <53e3db85./dDZZ0/6jFPlxlKi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:43719 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbaHGUDS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:03:18 -0400
Received: by mail-ob0-f202.google.com with SMTP id wp18so843751obc.5
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:03:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: remove a useless lockdep annotation
has been removed from the -mm tree.  Its filename was
     slab-remove-a-useless-lockdep-annotation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: slab: remove a useless lockdep annotation

Now, there is no code to hold two lock simultaneously, since we don't call
slab_destroy() with holding any lock.  So, lockdep annotation is useless
now.  Remove it.

v2: don't remove BAD_ALIEN_MAGIC in this patch. It will be removed
    in the following patch.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |  153 ----------------------------------------------------
 1 file changed, 153 deletions(-)

diff -puN mm/slab.c~slab-remove-a-useless-lockdep-annotation mm/slab.c
--- a/mm/slab.c~slab-remove-a-useless-lockdep-annotation
+++ a/mm/slab.c
@@ -472,139 +472,6 @@ static struct kmem_cache kmem_cache_boot
 
 #define BAD_ALIEN_MAGIC 0x01020304ul
 
-#ifdef CONFIG_LOCKDEP
-
-/*
- * Slab sometimes uses the kmalloc slabs to store the slab headers
- * for other slabs "off slab".
- * The locking for this is tricky in that it nests within the locks
- * of all other slabs in a few places; to deal with this special
- * locking we put on-slab caches into a separate lock-class.
- *
- * We set lock class for alien array caches which are up during init.
- * The lock annotation will be lost if all cpus of a node goes down and
- * then comes back up during hotplug
- */
-static struct lock_class_key on_slab_l3_key;
-static struct lock_class_key on_slab_alc_key;
-
-static struct lock_class_key debugobj_l3_key;
-static struct lock_class_key debugobj_alc_key;
-
-static void slab_set_lock_classes(struct kmem_cache *cachep,
-		struct lock_class_key *l3_key, struct lock_class_key *alc_key,
-		struct kmem_cache_node *n)
-{
-	struct alien_cache **alc;
-	int r;
-
-	lockdep_set_class(&n->list_lock, l3_key);
-	alc = n->alien;
-	/*
-	 * FIXME: This check for BAD_ALIEN_MAGIC
-	 * should go away when common slab code is taught to
-	 * work even without alien caches.
-	 * Currently, non NUMA code returns BAD_ALIEN_MAGIC
-	 * for alloc_alien_cache,
-	 */
-	if (!alc || (unsigned long)alc == BAD_ALIEN_MAGIC)
-		return;
-	for_each_node(r) {
-		if (alc[r])
-			lockdep_set_class(&(alc[r]->lock), alc_key);
-	}
-}
-
-static void slab_set_debugobj_lock_classes_node(struct kmem_cache *cachep,
-	struct kmem_cache_node *n)
-{
-	slab_set_lock_classes(cachep, &debugobj_l3_key, &debugobj_alc_key, n);
-}
-
-static void slab_set_debugobj_lock_classes(struct kmem_cache *cachep)
-{
-	int node;
-	struct kmem_cache_node *n;
-
-	for_each_kmem_cache_node(cachep, node, n)
-		slab_set_debugobj_lock_classes_node(cachep, n);
-}
-
-static void init_node_lock_keys(int q)
-{
-	int i;
-
-	if (slab_state < UP)
-		return;
-
-	for (i = 1; i <= KMALLOC_SHIFT_HIGH; i++) {
-		struct kmem_cache_node *n;
-		struct kmem_cache *cache = kmalloc_caches[i];
-
-		if (!cache)
-			continue;
-
-		n = get_node(cache, q);
-		if (!n || OFF_SLAB(cache))
-			continue;
-
-		slab_set_lock_classes(cache, &on_slab_l3_key,
-				&on_slab_alc_key, n);
-	}
-}
-
-static void on_slab_lock_classes_node(struct kmem_cache *cachep,
-	struct kmem_cache_node *n)
-{
-	slab_set_lock_classes(cachep, &on_slab_l3_key,
-			&on_slab_alc_key, n);
-}
-
-static inline void on_slab_lock_classes(struct kmem_cache *cachep)
-{
-	int node;
-	struct kmem_cache_node *n;
-
-	VM_BUG_ON(OFF_SLAB(cachep));
-	for_each_kmem_cache_node(cachep, node, n)
-		on_slab_lock_classes_node(cachep, n);
-}
-
-static inline void __init init_lock_keys(void)
-{
-	int node;
-
-	for_each_node(node)
-		init_node_lock_keys(node);
-}
-#else
-static void __init init_node_lock_keys(int q)
-{
-}
-
-static inline void init_lock_keys(void)
-{
-}
-
-static inline void on_slab_lock_classes(struct kmem_cache *cachep)
-{
-}
-
-static inline void on_slab_lock_classes_node(struct kmem_cache *cachep,
-	struct kmem_cache_node *n)
-{
-}
-
-static void slab_set_debugobj_lock_classes_node(struct kmem_cache *cachep,
-	struct kmem_cache_node *n)
-{
-}
-
-static void slab_set_debugobj_lock_classes(struct kmem_cache *cachep)
-{
-}
-#endif
-
 static DEFINE_PER_CPU(struct delayed_work, slab_reap_work);
 
 static inline struct array_cache *cpu_cache_get(struct kmem_cache *cachep)
@@ -1348,13 +1215,7 @@ static int cpuup_prepare(long cpu)
 		spin_unlock_irq(&n->list_lock);
 		kfree(shared);
 		free_alien_cache(alien);
-		if (cachep->flags & SLAB_DEBUG_OBJECTS)
-			slab_set_debugobj_lock_classes_node(cachep, n);
-		else if (!OFF_SLAB(cachep) &&
-			 !(cachep->flags & SLAB_DESTROY_BY_RCU))
-			on_slab_lock_classes_node(cachep, n);
 	}
-	init_node_lock_keys(node);
 
 	return 0;
 bad:
@@ -1663,9 +1524,6 @@ void __init kmem_cache_init_late(void)
 			BUG();
 	mutex_unlock(&slab_mutex);
 
-	/* Annotate slab for lockdep -- annotate the malloc caches */
-	init_lock_keys();
-
 	/* Done! */
 	slab_state = FULL;
 
@@ -2446,17 +2304,6 @@ __kmem_cache_create (struct kmem_cache *
 		return err;
 	}
 
-	if (flags & SLAB_DEBUG_OBJECTS) {
-		/*
-		 * Would deadlock through slab_destroy()->call_rcu()->
-		 * debug_object_activate()->kmem_cache_alloc().
-		 */
-		WARN_ON_ONCE(flags & SLAB_DESTROY_BY_RCU);
-
-		slab_set_debugobj_lock_classes(cachep);
-	} else if (!OFF_SLAB(cachep) && !(flags & SLAB_DESTROY_BY_RCU))
-		on_slab_lock_classes(cachep);
