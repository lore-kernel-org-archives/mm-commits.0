From: akpm@linux-foundation.org
Subject: [merged] slab-reorganize-memcg_cache_params.patch removed from
 -mm tree
Date: Thu, 23 Feb 2017 13:12:28 -0800
Message-ID: <58af503c.nho/EuLaUghEKPwS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39396 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751295AbdBWVM3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:12:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: reorganize memcg_cache_params
has been removed from the -mm tree.  Its filename was
     slab-reorganize-memcg_cache_params.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: slab: reorganize memcg_cache_params

We're going to change how memcg caches are iterated.  In preparation,
clean up and reorganize memcg_cache_params.

* The shared ->list is replaced by ->children in root and
  ->children_node in children.

* ->is_root_cache is removed.  Instead ->root_cache is moved out of
  the child union and now used by both root and children.  NULL
  indicates root cache.  Non-NULL a memcg one.

This patch doesn't cause any observable behavior changes.

Link: http://lkml.kernel.org/r/20170117235411.9408-5-tj@kernel.org
Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |   33 ++++++++++++++++++++++++---------
 mm/slab.h            |    6 +++---
 mm/slab_common.c     |   25 +++++++++++++------------
 3 files changed, 40 insertions(+), 24 deletions(-)

diff -puN include/linux/slab.h~slab-reorganize-memcg_cache_params include/linux/slab.h
--- a/include/linux/slab.h~slab-reorganize-memcg_cache_params
+++ a/include/linux/slab.h
@@ -545,22 +545,37 @@ struct memcg_cache_array {
  * array to be accessed without taking any locks, on relocation we free the old
  * version only after a grace period.
  *
- * Child caches will hold extra metadata needed for its operation. Fields are:
+ * Root and child caches hold different metadata.
  *
- * @memcg: pointer to the memcg this cache belongs to
- * @root_cache: pointer to the global, root cache, this cache was derived from
+ * @root_cache:	Common to root and child caches.  NULL for root, pointer to
+ *		the root cache for children.
  *
- * Both root and child caches of the same kind are linked into a list chained
- * through @list.
+ * The following fields are specific to root caches.
+ *
+ * @memcg_caches: kmemcg ID indexed table of child caches.  This table is
+ *		used to index child cachces during allocation and cleared
+ *		early during shutdown.
+ *
+ * @children:	List of all child caches.  While the child caches are also
+ *		reachable through @memcg_caches, a child cache remains on
+ *		this list until it is actually destroyed.
+ *
+ * The following fields are specific to child caches.
+ *
+ * @memcg:	Pointer to the memcg this cache belongs to.
+ *
+ * @children_node: List node for @root_cache->children list.
  */
 struct memcg_cache_params {
-	bool is_root_cache;
-	struct list_head list;
+	struct kmem_cache *root_cache;
 	union {
-		struct memcg_cache_array __rcu *memcg_caches;
+		struct {
+			struct memcg_cache_array __rcu *memcg_caches;
+			struct list_head children;
+		};
 		struct {
 			struct mem_cgroup *memcg;
-			struct kmem_cache *root_cache;
+			struct list_head children_node;
 		};
 	};
 };
diff -puN mm/slab.h~slab-reorganize-memcg_cache_params mm/slab.h
--- a/mm/slab.h~slab-reorganize-memcg_cache_params
+++ a/mm/slab.h
@@ -206,12 +206,12 @@ int __kmem_cache_alloc_bulk(struct kmem_
  * slab_mutex.
  */
 #define for_each_memcg_cache(iter, root) \
-	list_for_each_entry(iter, &(root)->memcg_params.list, \
-			    memcg_params.list)
+	list_for_each_entry(iter, &(root)->memcg_params.children, \
+			    memcg_params.children_node)
 
 static inline bool is_root_cache(struct kmem_cache *s)
 {
-	return s->memcg_params.is_root_cache;
+	return !s->memcg_params.root_cache;
 }
 
 static inline bool slab_equal_or_root(struct kmem_cache *s,
diff -puN mm/slab_common.c~slab-reorganize-memcg_cache_params mm/slab_common.c
--- a/mm/slab_common.c~slab-reorganize-memcg_cache_params
+++ a/mm/slab_common.c
@@ -140,9 +140,9 @@ int __kmem_cache_alloc_bulk(struct kmem_
 #if defined(CONFIG_MEMCG) && !defined(CONFIG_SLOB)
 void slab_init_memcg_params(struct kmem_cache *s)
 {
-	s->memcg_params.is_root_cache = true;
-	INIT_LIST_HEAD(&s->memcg_params.list);
+	s->memcg_params.root_cache = NULL;
 	RCU_INIT_POINTER(s->memcg_params.memcg_caches, NULL);
+	INIT_LIST_HEAD(&s->memcg_params.children);
 }
 
 static int init_memcg_params(struct kmem_cache *s,
@@ -150,10 +150,10 @@ static int init_memcg_params(struct kmem
 {
 	struct memcg_cache_array *arr;
 
-	if (memcg) {
-		s->memcg_params.is_root_cache = false;
-		s->memcg_params.memcg = memcg;
+	if (root_cache) {
 		s->memcg_params.root_cache = root_cache;
+		s->memcg_params.memcg = memcg;
+		INIT_LIST_HEAD(&s->memcg_params.children_node);
 		return 0;
 	}
 
@@ -223,7 +223,7 @@ int memcg_update_all_caches(int num_memc
 
 static void unlink_memcg_cache(struct kmem_cache *s)
 {
-	list_del(&s->memcg_params.list);
+	list_del(&s->memcg_params.children_node);
 }
 #else
 static inline int init_memcg_params(struct kmem_cache *s,
@@ -594,7 +594,8 @@ void memcg_create_kmem_cache(struct mem_
 		goto out_unlock;
 	}
 
-	list_add(&s->memcg_params.list, &root_cache->memcg_params.list);
+	list_add(&s->memcg_params.children_node,
+		 &root_cache->memcg_params.children);
 
 	/*
 	 * Since readers won't lock (see cache_from_memcg_idx()), we need a
@@ -690,7 +691,7 @@ static int shutdown_memcg_caches(struct
 			 * list so as not to try to destroy it for a second
 			 * time while iterating over inactive caches below.
 			 */
-			list_move(&c->memcg_params.list, &busy);
+			list_move(&c->memcg_params.children_node, &busy);
 		else
 			/*
 			 * The cache is empty and will be destroyed soon. Clear
@@ -705,17 +706,17 @@ static int shutdown_memcg_caches(struct
 	 * Second, shutdown all caches left from memory cgroups that are now
 	 * offline.
 	 */
-	list_for_each_entry_safe(c, c2, &s->memcg_params.list,
-				 memcg_params.list)
+	list_for_each_entry_safe(c, c2, &s->memcg_params.children,
+				 memcg_params.children_node)
 		shutdown_cache(c);
 
-	list_splice(&busy, &s->memcg_params.list);
+	list_splice(&busy, &s->memcg_params.children);
 
 	/*
 	 * A cache being destroyed must be empty. In particular, this means
 	 * that all per memcg caches attached to it must be empty too.
 	 */
-	if (!list_empty(&s->memcg_params.list))
+	if (!list_empty(&s->memcg_params.children))
 		return -EBUSY;
 	return 0;
 }
_

Patches currently in -mm which might be from tj@kernel.org are


