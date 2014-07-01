From: akpm@linux-foundation.org
Subject: + slab-remove-a-useless-lockdep-annotation.patch added to -mm
 tree
Date: Tue, 01 Jul 2014 15:16:50 -0700
Message-ID: <53b33352.9e2RpDXhRr+kvEQS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:50233 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879AbaGAWQv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2014 18:16:51 -0400
Received: by mail-vc0-f202.google.com with SMTP id id10so1089053vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 01 Jul 2014 15:16:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: remove a useless lockdep annotation
has been added to the -mm tree.  Its filename is
     slab-remove-a-useless-lockdep-annotation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-remove-a-useless-lockdep-annotation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slab-remove-a-useless-lockdep-annotation.patch

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
@@ -1354,13 +1221,7 @@ static int cpuup_prepare(long cpu)
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
@@ -1669,9 +1530,6 @@ void __init kmem_cache_init_late(void)
 			BUG();
 	mutex_unlock(&slab_mutex);
 
-	/* Annotate slab for lockdep -- annotate the malloc caches */
-	init_lock_keys();
-
 	/* Done! */
 	slab_state = FULL;
 
@@ -2452,17 +2310,6 @@ __kmem_cache_create (struct kmem_cache *
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
-
 	return 0;
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

