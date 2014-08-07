From: akpm@linux-foundation.org
Subject: [merged] slab-introduce-alien_cache.patch removed from -mm tree
Date: Thu, 07 Aug 2014 13:03:11 -0700
Message-ID: <53e3db7f.V8PbJm4NXQqm9ubj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:59737 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807AbaHGUDM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:03:12 -0400
Received: by mail-pd0-f202.google.com with SMTP id w10so1176612pde.3
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:03:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: introduce alien_cache
has been removed from the -mm tree.  Its filename was
     slab-introduce-alien_cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1191,7 +1217,7 @@ static void cpuup_canceled(long cpu)
 	list_for_each_entry(cachep, &slab_caches, list) {
 		struct array_cache *nc;
 		struct array_cache *shared;
-		struct array_cache **alien;
+		struct alien_cache **alien;
 		LIST_HEAD(list);
 
 		/* cpu is dead; no one can alloc from it. */
@@ -1272,7 +1298,7 @@ static int cpuup_prepare(long cpu)
 	list_for_each_entry(cachep, &slab_caches, list) {
 		struct array_cache *nc;
 		struct array_cache *shared = NULL;
-		struct array_cache **alien = NULL;
+		struct alien_cache **alien = NULL;
 
 		nc = alloc_arraycache(node, cachep->limit,
 					cachep->batchcount, GFP_KERNEL);
@@ -3762,7 +3788,7 @@ static int alloc_kmem_cache_node(struct
 	int node;
 	struct kmem_cache_node *n;
 	struct array_cache *new_shared;
-	struct array_cache **new_alien = NULL;
+	struct alien_cache **new_alien = NULL;
 
 	for_each_online_node(node) {
 
diff -puN mm/slab.h~slab-introduce-alien_cache mm/slab.h
--- a/mm/slab.h~slab-introduce-alien_cache
+++ a/mm/slab.h
@@ -276,7 +276,7 @@ struct kmem_cache_node {
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

origin.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
page-owners-correct-page-order-when-to-free-page.patch

