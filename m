From: akpm@linux-foundation.org
Subject: +
 slab-use-the-lock-on-alien_cache-instead-of-the-lock-on-array_cache.patch
 added to -mm tree
Date: Tue, 01 Jul 2014 15:16:48 -0700
Message-ID: <53b33350.JjvdtiqnRgeSTnhF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:37011 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759045AbaGAWQt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2014 18:16:49 -0400
Received: by mail-yh0-f73.google.com with SMTP id f10so1118459yha.2
        for <mm-commits@vger.kernel.org>; Tue, 01 Jul 2014 15:16:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: use the lock on alien_cache, instead of the lock on array_cache
has been added to the -mm tree.  Its filename is
     slab-use-the-lock-on-alien_cache-instead-of-the-lock-on-array_cache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-use-the-lock-on-alien_cache-instead-of-the-lock-on-array_cache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slab-use-the-lock-on-alien_cache-instead-of-the-lock-on-array_cache.patch

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
Subject: slab: use the lock on alien_cache, instead of the lock on array_cache

Now, we have separate alien_cache structure, so it'd be better to hold the
lock on alien_cache while manipulating alien_cache.  After that, we don't
need the lock on array_cache, so remove it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff -puN mm/slab.c~slab-use-the-lock-on-alien_cache-instead-of-the-lock-on-array_cache mm/slab.c
--- a/mm/slab.c~slab-use-the-lock-on-alien_cache-instead-of-the-lock-on-array_cache
+++ a/mm/slab.c
@@ -191,7 +191,6 @@ struct array_cache {
 	unsigned int limit;
 	unsigned int batchcount;
 	unsigned int touched;
-	spinlock_t lock;
 	void *entry[];	/*
 			 * Must have this definition in here for the proper
 			 * alignment of array_cache. Also simplifies accessing
@@ -512,7 +511,7 @@ static void slab_set_lock_classes(struct
 		return;
 	for_each_node(r) {
 		if (alc[r])
-			lockdep_set_class(&(alc[r]->ac.lock), alc_key);
+			lockdep_set_class(&(alc[r]->lock), alc_key);
 	}
 }
 
@@ -811,7 +810,6 @@ static void init_arraycache(struct array
 		ac->limit = limit;
 		ac->batchcount = batch;
 		ac->touched = 0;
-		spin_lock_init(&ac->lock);
 	}
 }
 
@@ -1010,6 +1008,7 @@ static struct alien_cache *__alloc_alien
 
 	alc = kmalloc_node(memsize, gfp, node);
 	init_arraycache(&alc->ac, entries, batch);
+	spin_lock_init(&alc->lock);
 	return alc;
 }
 
@@ -1086,9 +1085,9 @@ static void reap_alien(struct kmem_cache
 
 		if (alc) {
 			ac = &alc->ac;
-			if (ac->avail && spin_trylock_irq(&ac->lock)) {
+			if (ac->avail && spin_trylock_irq(&alc->lock)) {
 				__drain_alien_cache(cachep, ac, node);
-				spin_unlock_irq(&ac->lock);
+				spin_unlock_irq(&alc->lock);
 			}
 		}
 	}
@@ -1106,9 +1105,9 @@ static void drain_alien_cache(struct kme
 		alc = alien[i];
 		if (alc) {
 			ac = &alc->ac;
-			spin_lock_irqsave(&ac->lock, flags);
+			spin_lock_irqsave(&alc->lock, flags);
 			__drain_alien_cache(cachep, ac, i);
-			spin_unlock_irqrestore(&ac->lock, flags);
+			spin_unlock_irqrestore(&alc->lock, flags);
 		}
 	}
 }
@@ -1136,13 +1135,13 @@ static inline int cache_free_alien(struc
 	if (n->alien && n->alien[nodeid]) {
 		alien = n->alien[nodeid];
 		ac = &alien->ac;
-		spin_lock(&ac->lock);
+		spin_lock(&alien->lock);
 		if (unlikely(ac->avail == ac->limit)) {
 			STATS_INC_ACOVERFLOW(cachep);
 			__drain_alien_cache(cachep, ac, nodeid);
 		}
 		ac_put_obj(cachep, ac, objp);
-		spin_unlock(&ac->lock);
+		spin_unlock(&alien->lock);
 	} else {
 		n = get_node(cachep, nodeid);
 		spin_lock(&n->list_lock);
@@ -1619,10 +1618,6 @@ void __init kmem_cache_init(void)
 
 		memcpy(ptr, cpu_cache_get(kmem_cache),
 		       sizeof(struct arraycache_init));
-		/*
-		 * Do not assume that spinlocks can be initialized via memcpy:
-		 */
-		spin_lock_init(&ptr->lock);
 
 		kmem_cache->array[smp_processor_id()] = ptr;
 
@@ -1632,10 +1627,6 @@ void __init kmem_cache_init(void)
 		       != &initarray_generic.cache);
 		memcpy(ptr, cpu_cache_get(kmalloc_caches[INDEX_AC]),
 		       sizeof(struct arraycache_init));
-		/*
-		 * Do not assume that spinlocks can be initialized via memcpy:
-		 */
-		spin_lock_init(&ptr->lock);
 
 		kmalloc_caches[INDEX_AC]->array[smp_processor_id()] = ptr;
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

