From: akpm@linux-foundation.org
Subject: + slab-introduce-alien_cache.patch added to -mm tree
Date: Tue, 01 Jul 2014 15:16:47 -0700
Message-ID: <53b3334f.u7MYbM2Kf/wsg/XW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:45542 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879AbaGAWQs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2014 18:16:48 -0400
Received: by mail-ob0-f202.google.com with SMTP id va2so2375169obc.5
        for <mm-commits@vger.kernel.org>; Tue, 01 Jul 2014 15:16:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: introduce alien_cache
has been added to the -mm tree.  Its filename is
     slab-introduce-alien_cache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-introduce-alien_cache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slab-introduce-alien_cache.patch

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
Subject: slab: introduce alien_cache

Currently, we use array_cache for alien_cache.  Although they are mostly
similar, there is one difference, that is, need for spinlock.  We don't
need spinlock for array_cache itself, but to use array_cache for
alien_cache, array_cache structure should have spinlock.  This is needless
overhead, so removing it would be better.  This patch prepare it by
introducing alien_cache and using it.  In the following patch, we remove
spinlock in array_cache.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |  106 ++++++++++++++++++++++++++++++++--------------------
 mm/slab.h |    2 
 2 files changed, 67 insertions(+), 41 deletions(-)

diff -puN mm/slab.c~slab-introduce-alien_cache mm/slab.c
--- a/mm/slab.c~slab-introduce-alien_cache
+++ a/mm/slab.c
@@ -203,6 +203,11 @@ struct array_cache {
 			 */
 };
 
+struct alien_cache {
+	spinlock_t lock;
+	struct array_cache ac;
+};
+
 #define SLAB_OBJ_PFMEMALLOC	1
 static inline bool is_obj_pfmemalloc(void *objp)
 {
@@ -491,7 +496,7 @@ static void slab_set_lock_classes(struct
 		struct lock_class_key *l3_key, struct lock_class_key *alc_key,
 		struct kmem_cache_node *n)
 {
-	struct array_cache **alc;
+	struct alien_cache **alc;
 	int r;
 
 	lockdep_set_class(&n->list_lock, l3_key);
@@ -507,7 +512,7 @@ static void slab_set_lock_classes(struct
 		return;
 	for_each_node(r) {
 		if (alc[r])
-			lockdep_set_class(&alc[r]->lock, alc_key);
+			lockdep_set_class(&(alc[r]->ac.lock), alc_key);
 	}
 }
 
@@ -965,12 +970,13 @@ static int transfer_objects(struct array
 #define drain_alien_cache(cachep, alien) do { } while (0)
 #define reap_alien(cachep, n) do { } while (0)
 
-static inline struct array_cache **alloc_alien_cache(int node, int limit, gfp_t gfp)
+static inline struct alien_cache **alloc_alien_cache(int node,
+						int limit, gfp_t gfp)
 {
-	return (struct array_cache **)BAD_ALIEN_MAGIC;
+	return (struct alien_cache **)BAD_ALIEN_MAGIC;
 }
 
-static inline void free_alien_cache(struct array_cache **ac_ptr)
+static inline void free_alien_cache(struct alien_cache **ac_ptr)
 {
 }
 
@@ -996,40 +1002,52 @@ static inline void *____cache_alloc_node
 static void *____cache_alloc_node(struct kmem_cache *, gfp_t, int);
 static void *alternate_node_alloc(struct kmem_cache *, gfp_t);
 
-static struct array_cache **alloc_alien_cache(int node, int limit, gfp_t gfp)
+static struct alien_cache *__alloc_alien_cache(int node, int entries,
+						int batch, gfp_t gfp)
 {
-	struct array_cache **ac_ptr;
+	int memsize = sizeof(void *) * entries + sizeof(struct alien_cache);
+	struct alien_cache *alc = NULL;
+
+	alc = kmalloc_node(memsize, gfp, node);
+	init_arraycache(&alc->ac, entries, batch);
+	return alc;
+}
+
+static struct alien_cache **alloc_alien_cache(int node, int limit, gfp_t gfp)
+{
+	struct alien_cache **alc_ptr;
 	int memsize = sizeof(void *) * nr_node_ids;
 	int i;
 
 	if (limit > 1)
 		limit = 12;
-	ac_ptr = kzalloc_node(memsize, gfp, node);
-	if (ac_ptr) {
-		for_each_node(i) {
-			if (i == node || !node_online(i))
-				continue;
-			ac_ptr[i] = alloc_arraycache(node, limit, 0xbaadf00d, gfp);
-			if (!ac_ptr[i]) {
-				for (i--; i >= 0; i--)
-					kfree(ac_ptr[i]);
-				kfree(ac_ptr);
-				return NULL;
-			}
+	alc_ptr = kzalloc_node(memsize, gfp, node);
+	if (!alc_ptr)
+		return NULL;
+
+	for_each_node(i) {
+		if (i == node || !node_online(i))
+			continue;
+		alc_ptr[i] = __alloc_alien_cache(node, limit, 0xbaadf00d, gfp);
+		if (!alc_ptr[i]) {
+			for (i--; i >= 0; i--)
+				kfree(alc_ptr[i]);
+			kfree(alc_ptr);
+			return NULL;
 		}
 	}
-	return ac_ptr;
+	return alc_ptr;
 }
 
-static void free_alien_cache(struct array_cache **ac_ptr)
+static void free_alien_cache(struct alien_cache **alc_ptr)
 {
 	int i;
 
-	if (!ac_ptr)
+	if (!alc_ptr)
 		return;
 	for_each_node(i)
-	    kfree(ac_ptr[i]);
-	kfree(ac_ptr);
+	    kfree(alc_ptr[i]);
+	kfree(alc_ptr);
 }
 
 static void __drain_alien_cache(struct kmem_cache *cachep,
@@ -1063,25 +1081,31 @@ static void reap_alien(struct kmem_cache
 	int node = __this_cpu_read(slab_reap_node);
 
 	if (n->alien) {
-		struct array_cache *ac = n->alien[node];
+		struct alien_cache *alc = n->alien[node];
+		struct array_cache *ac;
 
-		if (ac && ac->avail && spin_trylock_irq(&ac->lock)) {
-			__drain_alien_cache(cachep, ac, node);
-			spin_unlock_irq(&ac->lock);
+		if (alc) {
+			ac = &alc->ac;
+			if (ac->avail && spin_trylock_irq(&ac->lock)) {
+				__drain_alien_cache(cachep, ac, node);
+				spin_unlock_irq(&ac->lock);
+			}
 		}
 	}
 }
 
 static void drain_alien_cache(struct kmem_cache *cachep,
-				struct array_cache **alien)
+				struct alien_cache **alien)
 {
 	int i = 0;
+	struct alien_cache *alc;
 	struct array_cache *ac;
 	unsigned long flags;
 
 	for_each_online_node(i) {
-		ac = alien[i];
-		if (ac) {
+		alc = alien[i];
+		if (alc) {
+			ac = &alc->ac;
 			spin_lock_irqsave(&ac->lock, flags);
 			__drain_alien_cache(cachep, ac, i);
 			spin_unlock_irqrestore(&ac->lock, flags);
@@ -1093,7 +1117,8 @@ static inline int cache_free_alien(struc
 {
 	int nodeid = page_to_nid(virt_to_page(objp));
 	struct kmem_cache_node *n;
-	struct array_cache *alien = NULL;
+	struct alien_cache *alien = NULL;
+	struct array_cache *ac;
 	int node;
 	LIST_HEAD(list);
 
@@ -1110,13 +1135,14 @@ static inline int cache_free_alien(struc
 	STATS_INC_NODEFREES(cachep);
 	if (n->alien && n->alien[nodeid]) {
 		alien = n->alien[nodeid];
-		spin_lock(&alien->lock);
-		if (unlikely(alien->avail == alien->limit)) {
+		ac = &alien->ac;
+		spin_lock(&ac->lock);
+		if (unlikely(ac->avail == ac->limit)) {
 			STATS_INC_ACOVERFLOW(cachep);
-			__drain_alien_cache(cachep, alien, nodeid);
+			__drain_alien_cache(cachep, ac, nodeid);
 		}
-		ac_put_obj(cachep, alien, objp);
-		spin_unlock(&alien->lock);
+		ac_put_obj(cachep, ac, objp);
+		spin_unlock(&ac->lock);
 	} else {
 		n = get_node(cachep, nodeid);
 		spin_lock(&n->list_lock);
@@ -1193,7 +1219,7 @@ static void cpuup_canceled(long cpu)
 	list_for_each_entry(cachep, &slab_caches, list) {
 		struct array_cache *nc;
 		struct array_cache *shared;
-		struct array_cache **alien;
+		struct alien_cache **alien;
 		LIST_HEAD(list);
 
 		/* cpu is dead; no one can alloc from it. */
@@ -1275,7 +1301,7 @@ static int cpuup_prepare(long cpu)
 	list_for_each_entry(cachep, &slab_caches, list) {
 		struct array_cache *nc;
 		struct array_cache *shared = NULL;
-		struct array_cache **alien = NULL;
+		struct alien_cache **alien = NULL;
 
 		if (memcg_cache_dead(cachep))
 			continue;
@@ -3799,7 +3825,7 @@ static int alloc_kmem_cache_node(struct
 	int node;
 	struct kmem_cache_node *n;
 	struct array_cache *new_shared;
-	struct array_cache **new_alien = NULL;
+	struct alien_cache **new_alien = NULL;
 
 	for_each_online_node(node) {
 
diff -puN mm/slab.h~slab-introduce-alien_cache mm/slab.h
--- a/mm/slab.h~slab-introduce-alien_cache
+++ a/mm/slab.h
@@ -301,7 +301,7 @@ struct kmem_cache_node {
 	unsigned int free_limit;
 	unsigned int colour_next;	/* Per-node cache coloring */
 	struct array_cache *shared;	/* shared per node */
-	struct array_cache **alien;	/* on other nodes */
+	struct alien_cache **alien;	/* on other nodes */
 	unsigned long next_reap;	/* updated without locking */
 	int free_touched;		/* updated without locking */
 #endif
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

