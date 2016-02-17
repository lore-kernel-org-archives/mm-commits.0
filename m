From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-slab-free-kmem_cache_node-after-destroy-sysfs-file-v9.patch removed from -mm tree
Date: Wed, 17 Feb 2016 10:57:38 -0800
Message-ID: <56c4c2a2.icy1miBgfm4u3cVE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42081 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965208AbcBQS5j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Feb 2016 13:57:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dsafonov@virtuozzo.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: slab: free kmem_cache_node after destroy sysfs file
has been removed from the -mm tree.  Its filename was
     mm-slab-free-kmem_cache_node-after-destroy-sysfs-file-v9.patch

This patch was dropped because it was folded into mm-slab-free-kmem_cache_node-after-destroy-sysfs-file.patch

------------------------------------------------------
From: Dmitry Safonov <dsafonov@virtuozzo.com>
Subject: mm: slab: free kmem_cache_node after destroy sysfs file

v8: reintroduce locking in free_partial & nits from Vladimir
v9: zapped __remove_partial and spin_lock_irq instead of spin_lock_irqsave
    (added BUG_ON(irqs_disabled()) to be sure)

Signed-off-by: Dmitry Safonov <dsafonov@virtuozzo.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    9 ++-------
 mm/slub.c |   36 ++++++++++++++++++------------------
 2 files changed, 20 insertions(+), 25 deletions(-)

diff -puN mm/slab.c~mm-slab-free-kmem_cache_node-after-destroy-sysfs-file-v9 mm/slab.c
--- a/mm/slab.c~mm-slab-free-kmem_cache_node-after-destroy-sysfs-file-v9
+++ a/mm/slab.c
@@ -2275,7 +2275,7 @@ __kmem_cache_create (struct kmem_cache *
 
 	err = setup_cpu_cache(cachep, gfp);
 	if (err) {
-		__kmem_cache_shutdown(cachep);
+		__kmem_cache_release(cachep);
 		return err;
 	}
 
@@ -2414,12 +2414,7 @@ int __kmem_cache_shrink(struct kmem_cach
 
 int __kmem_cache_shutdown(struct kmem_cache *cachep)
 {
-	int rc = __kmem_cache_shrink(cachep, false);
-
-	if (rc)
-		return rc;
-
-	return 0;
+	return __kmem_cache_shrink(cachep, false);
 }
 
 void __kmem_cache_release(struct kmem_cache *cachep)
diff -puN mm/slub.c~mm-slab-free-kmem_cache_node-after-destroy-sysfs-file-v9 mm/slub.c
--- a/mm/slub.c~mm-slab-free-kmem_cache_node-after-destroy-sysfs-file-v9
+++ a/mm/slub.c
@@ -1592,18 +1592,12 @@ static inline void add_partial(struct km
 	__add_partial(n, page, tail);
 }
 
-static inline void
-__remove_partial(struct kmem_cache_node *n, struct page *page)
-{
-	list_del(&page->lru);
-	n->nr_partial--;
-}
-
 static inline void remove_partial(struct kmem_cache_node *n,
 					struct page *page)
 {
 	lockdep_assert_held(&n->list_lock);
-	__remove_partial(n, page);
+	list_del(&page->lru);
+	n->nr_partial--;
 }
 
 /*
@@ -3173,18 +3167,23 @@ static void early_kmem_cache_node_alloc(
 	__add_partial(n, page, DEACTIVATE_TO_HEAD);
 }
 
-void __kmem_cache_release(struct kmem_cache *s)
+static void free_kmem_cache_nodes(struct kmem_cache *s)
 {
 	int node;
 	struct kmem_cache_node *n;
 
-	free_percpu(s->cpu_slab);
 	for_each_kmem_cache_node(s, node, n) {
 		kmem_cache_free(kmem_cache_node, n);
 		s->node[node] = NULL;
 	}
 }
 
+void __kmem_cache_release(struct kmem_cache *s)
+{
+	free_percpu(s->cpu_slab);
+	free_kmem_cache_nodes(s);
+}
+
 static int init_kmem_cache_nodes(struct kmem_cache *s)
 {
 	int node;
@@ -3200,7 +3199,7 @@ static int init_kmem_cache_nodes(struct
 						GFP_KERNEL, node);
 
 		if (!n) {
-			__kmem_cache_release(s);
+			free_kmem_cache_nodes(s);
 			return 0;
 		}
 
@@ -3406,7 +3405,7 @@ static int kmem_cache_open(struct kmem_c
 	if (alloc_kmem_cache_cpus(s))
 		return 0;
 
-	__kmem_cache_release(s);
+	free_kmem_cache_nodes(s);
 error:
 	if (flags & SLAB_PANIC)
 		panic("Cannot create slab %s size=%lu realsize=%u "
@@ -3444,22 +3443,25 @@ static void list_slab_objects(struct kme
 
 /*
  * Attempt to free all partial slabs on a node.
- * This is called from __kmem_cache_shutdown(). We must be the last thread
- * using the cache and therefore we do not need to lock anymore.
+ * This is called from __kmem_cache_shutdown(). We must take list_lock
+ * because sysfs file might still access partial list after the shutdowning.
  */
 static void free_partial(struct kmem_cache *s, struct kmem_cache_node *n)
 {
 	struct page *page, *h;
 
+	BUG_ON(irqs_disabled());
+	spin_lock_irq(&n->list_lock);
 	list_for_each_entry_safe(page, h, &n->partial, lru) {
 		if (!page->inuse) {
-			__remove_partial(n, page);
+			remove_partial(n, page);
 			discard_slab(s, page);
 		} else {
 			list_slab_objects(s, page,
 			"Objects remaining in %s on __kmem_cache_shutdown()");
 		}
 	}
+	spin_unlock_irq(&n->list_lock);
 }
 
 /*
@@ -3973,10 +3975,8 @@ int __kmem_cache_create(struct kmem_cach
 
 	memcg_propagate_slab_attrs(s);
 	err = sysfs_slab_add(s);
-	if (err) {
-		__kmem_cache_shutdown(s);
+	if (err)
 		__kmem_cache_release(s);
-	}
 
 	return err;
 }
_

Patches currently in -mm which might be from dsafonov@virtuozzo.com are

mm-slab-free-kmem_cache_node-after-destroy-sysfs-file.patch

