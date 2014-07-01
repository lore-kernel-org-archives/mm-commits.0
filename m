From: akpm@linux-foundation.org
Subject: + slab-destroy-a-slab-without-holding-any-alien-cache-lock.patch
 added to -mm tree
Date: Tue, 01 Jul 2014 15:16:49 -0700
Message-ID: <53b33351.2DzPV9uAoDEA5Tmq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:53960 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759047AbaGAWQu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2014 18:16:50 -0400
Received: by mail-ob0-f202.google.com with SMTP id va2so2375175obc.5
        for <mm-commits@vger.kernel.org>; Tue, 01 Jul 2014 15:16:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: destroy a slab without holding any alien cache lock
has been added to the -mm tree.  Its filename is
     slab-destroy-a-slab-without-holding-any-alien-cache-lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-destroy-a-slab-without-holding-any-alien-cache-lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slab-destroy-a-slab-without-holding-any-alien-cache-lock.patch

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
Subject: slab: destroy a slab without holding any alien cache lock

I haven't heard that this alien cache lock is contended, but to reduce
chance of contention would be better generally.  And with this change, we
can simplify complex lockdep annotation in slab code.  In the following
patch, it will be implemented.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff -puN mm/slab.c~slab-destroy-a-slab-without-holding-any-alien-cache-lock mm/slab.c
--- a/mm/slab.c~slab-destroy-a-slab-without-holding-any-alien-cache-lock
+++ a/mm/slab.c
@@ -1050,10 +1050,10 @@ static void free_alien_cache(struct alie
 }
 
 static void __drain_alien_cache(struct kmem_cache *cachep,
-				struct array_cache *ac, int node)
+				struct array_cache *ac, int node,
+				struct list_head *list)
 {
 	struct kmem_cache_node *n = get_node(cachep, node);
-	LIST_HEAD(list);
 
 	if (ac->avail) {
 		spin_lock(&n->list_lock);
@@ -1065,10 +1065,9 @@ static void __drain_alien_cache(struct k
 		if (n->shared)
 			transfer_objects(n->shared, ac, ac->limit);
 
-		free_block(cachep, ac->entry, ac->avail, node, &list);
+		free_block(cachep, ac->entry, ac->avail, node, list);
 		ac->avail = 0;
 		spin_unlock(&n->list_lock);
-		slabs_destroy(cachep, &list);
 	}
 }
 
@@ -1086,8 +1085,11 @@ static void reap_alien(struct kmem_cache
 		if (alc) {
 			ac = &alc->ac;
 			if (ac->avail && spin_trylock_irq(&alc->lock)) {
-				__drain_alien_cache(cachep, ac, node);
+				LIST_HEAD(list);
+
+				__drain_alien_cache(cachep, ac, node, &list);
 				spin_unlock_irq(&alc->lock);
+				slabs_destroy(cachep, &list);
 			}
 		}
 	}
@@ -1104,10 +1106,13 @@ static void drain_alien_cache(struct kme
 	for_each_online_node(i) {
 		alc = alien[i];
 		if (alc) {
+			LIST_HEAD(list);
+
 			ac = &alc->ac;
 			spin_lock_irqsave(&alc->lock, flags);
-			__drain_alien_cache(cachep, ac, i);
+			__drain_alien_cache(cachep, ac, i, &list);
 			spin_unlock_irqrestore(&alc->lock, flags);
+			slabs_destroy(cachep, &list);
 		}
 	}
 }
@@ -1138,10 +1143,11 @@ static inline int cache_free_alien(struc
 		spin_lock(&alien->lock);
 		if (unlikely(ac->avail == ac->limit)) {
 			STATS_INC_ACOVERFLOW(cachep);
-			__drain_alien_cache(cachep, ac, nodeid);
+			__drain_alien_cache(cachep, ac, nodeid, &list);
 		}
 		ac_put_obj(cachep, ac, objp);
 		spin_unlock(&alien->lock);
+		slabs_destroy(cachep, &list);
 	} else {
 		n = get_node(cachep, nodeid);
 		spin_lock(&n->list_lock);
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

