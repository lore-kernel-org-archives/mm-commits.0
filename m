From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-slab-improve-performance-of-gathering-slabinfo-stats.patch removed from
 -mm tree
Date: Tue, 30 Aug 2016 15:15:48 -0700
Message-ID: <57c60594.38QBYGrUFlRd4vkC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46054 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754146AbcH3WPt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 Aug 2016 18:15:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aruna.ramakrishna@oracle.com, cl@linux.com, iamjoonsoo.kim@lge.com, mike.kravetz@oracle.com, penberg@kernel.org, rientjes@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: improve performance of gathering slabinfo stats
has been removed from the -mm tree.  Its filename was
     mm-slab-improve-performance-of-gathering-slabinfo-stats.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
Subject: mm/slab: improve performance of gathering slabinfo stats

On large systems, when some slab caches grow to millions of objects (and
many gigabytes), running 'cat /proc/slabinfo' can take up to 1-2 seconds. 
During this time, interrupts are disabled while walking the slab lists
(slabs_full, slabs_partial, and slabs_free) for each node, and this
sometimes causes timeouts in other drivers (for instance, Infiniband).

This patch optimizes 'cat /proc/slabinfo' by maintaining a counter for
total number of allocated slabs per node, per cache.  This counter is
updated when a slab is created or destroyed.  This enables us to skip
traversing the slabs_full list while gathering slabinfo statistics, and
since slabs_full tends to be the biggest list when the cache is large, it
results in a dramatic performance improvement.  Getting slabinfo
statistics now only requires walking the slabs_free and slabs_partial
lists, and those lists are usually much smaller than slabs_full.  We
tested this after growing the dentry cache to 70GB, and the performance
improved from 2s to 5ms.

Link: http://lkml.kernel.org/r/1470337273-6700-1-git-send-email-aruna.ramakrishna@oracle.com
Signed-off-by: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   25 ++++++++++++++++---------
 mm/slab.h |   15 ++++++++++++++-
 mm/slub.c |   19 +------------------
 3 files changed, 31 insertions(+), 28 deletions(-)

diff -puN mm/slab.c~mm-slab-improve-performance-of-gathering-slabinfo-stats mm/slab.c
--- a/mm/slab.c~mm-slab-improve-performance-of-gathering-slabinfo-stats
+++ a/mm/slab.c
@@ -233,6 +233,7 @@ static void kmem_cache_node_init(struct
 	spin_lock_init(&parent->list_lock);
 	parent->free_objects = 0;
 	parent->free_touched = 0;
+	atomic_long_set(&parent->nr_slabs, 0);
 }
 
 #define MAKE_LIST(cachep, listp, slab, nodeid)				\
@@ -2333,6 +2334,7 @@ static int drain_freelist(struct kmem_ca
 		n->free_objects -= cache->num;
 		spin_unlock_irq(&n->list_lock);
 		slab_destroy(cache, page);
+		atomic_long_dec(&n->nr_slabs);
 		nr_freed++;
 	}
 out:
@@ -2736,6 +2738,8 @@ static struct page *cache_grow_begin(str
 	if (gfpflags_allow_blocking(local_flags))
 		local_irq_disable();
 
+	atomic_long_inc(&n->nr_slabs);
+
 	return page;
 
 opps1:
@@ -3455,6 +3459,7 @@ static void free_block(struct kmem_cache
 
 		page = list_last_entry(&n->slabs_free, struct page, lru);
 		list_move(&page->lru, list);
+		atomic_long_dec(&n->nr_slabs);
 	}
 }
 
@@ -4111,6 +4116,8 @@ void get_slabinfo(struct kmem_cache *cac
 	unsigned long num_objs;
 	unsigned long active_slabs = 0;
 	unsigned long num_slabs, free_objects = 0, shared_avail = 0;
+	unsigned long num_slabs_partial = 0, num_slabs_free = 0;
+	unsigned long num_slabs_full = 0;
 	const char *name;
 	char *error = NULL;
 	int node;
@@ -4120,36 +4127,36 @@ void get_slabinfo(struct kmem_cache *cac
 	num_slabs = 0;
 	for_each_kmem_cache_node(cachep, node, n) {
 
+		num_slabs += node_nr_slabs(n);
 		check_irq_on();
 		spin_lock_irq(&n->list_lock);
 
-		list_for_each_entry(page, &n->slabs_full, lru) {
-			if (page->active != cachep->num && !error)
-				error = "slabs_full accounting error";
-			active_objs += cachep->num;
-			active_slabs++;
-		}
 		list_for_each_entry(page, &n->slabs_partial, lru) {
 			if (page->active == cachep->num && !error)
 				error = "slabs_partial accounting error";
 			if (!page->active && !error)
 				error = "slabs_partial accounting error";
 			active_objs += page->active;
-			active_slabs++;
+			num_slabs_partial++;
 		}
+
 		list_for_each_entry(page, &n->slabs_free, lru) {
 			if (page->active && !error)
 				error = "slabs_free accounting error";
-			num_slabs++;
+			num_slabs_free++;
 		}
+
 		free_objects += n->free_objects;
 		if (n->shared)
 			shared_avail += n->shared->avail;
 
 		spin_unlock_irq(&n->list_lock);
 	}
-	num_slabs += active_slabs;
 	num_objs = num_slabs * cachep->num;
+	active_slabs = num_slabs - num_slabs_free;
+	num_slabs_full = num_slabs - (num_slabs_partial + num_slabs_free);
+	active_objs += (num_slabs_full * cachep->num);
+
 	if (num_objs - active_objs != free_objects && !error)
 		error = "free_objects accounting error";
 
diff -puN mm/slab.h~mm-slab-improve-performance-of-gathering-slabinfo-stats mm/slab.h
--- a/mm/slab.h~mm-slab-improve-performance-of-gathering-slabinfo-stats
+++ a/mm/slab.h
@@ -427,6 +427,7 @@ static inline void slab_post_alloc_hook(
  */
 struct kmem_cache_node {
 	spinlock_t list_lock;
+	atomic_long_t nr_slabs;
 
 #ifdef CONFIG_SLAB
 	struct list_head slabs_partial;	/* partial list first, better asm code */
@@ -445,7 +446,6 @@ struct kmem_cache_node {
 	unsigned long nr_partial;
 	struct list_head partial;
 #ifdef CONFIG_SLUB_DEBUG
-	atomic_long_t nr_slabs;
 	atomic_long_t total_objects;
 	struct list_head full;
 #endif
@@ -458,6 +458,19 @@ static inline struct kmem_cache_node *ge
 	return s->node[node];
 }
 
+/* Tracking of the number of slabs for /proc/slabinfo and debugging purposes */
+static inline unsigned long slabs_node(struct kmem_cache *s, int node)
+{
+	struct kmem_cache_node *n = get_node(s, node);
+
+	return atomic_long_read(&n->nr_slabs);
+}
+
+static inline unsigned long node_nr_slabs(struct kmem_cache_node *n)
+{
+	return atomic_long_read(&n->nr_slabs);
+}
+
 /*
  * Iterator over all nodes. The body will be executed for each node that has
  * a kmem_cache_node structure allocated (which is true for all online nodes)
diff -puN mm/slub.c~mm-slab-improve-performance-of-gathering-slabinfo-stats mm/slub.c
--- a/mm/slub.c~mm-slab-improve-performance-of-gathering-slabinfo-stats
+++ a/mm/slub.c
@@ -1006,19 +1006,6 @@ static void remove_full(struct kmem_cach
 	list_del(&page->lru);
 }
 
-/* Tracking of the number of slabs for debugging purposes */
-static inline unsigned long slabs_node(struct kmem_cache *s, int node)
-{
-	struct kmem_cache_node *n = get_node(s, node);
-
-	return atomic_long_read(&n->nr_slabs);
-}
-
-static inline unsigned long node_nr_slabs(struct kmem_cache_node *n)
-{
-	return atomic_long_read(&n->nr_slabs);
-}
-
 static inline void inc_slabs_node(struct kmem_cache *s, int node, int objects)
 {
 	struct kmem_cache_node *n = get_node(s, node);
@@ -1297,10 +1284,6 @@ unsigned long kmem_cache_flags(unsigned
 
 #define disable_higher_order_debug 0
 
-static inline unsigned long slabs_node(struct kmem_cache *s, int node)
-							{ return 0; }
-static inline unsigned long node_nr_slabs(struct kmem_cache_node *n)
-							{ return 0; }
 static inline void inc_slabs_node(struct kmem_cache *s, int node,
 							int objects) {}
 static inline void dec_slabs_node(struct kmem_cache *s, int node,
@@ -3258,8 +3241,8 @@ init_kmem_cache_node(struct kmem_cache_n
 	n->nr_partial = 0;
 	spin_lock_init(&n->list_lock);
 	INIT_LIST_HEAD(&n->partial);
-#ifdef CONFIG_SLUB_DEBUG
 	atomic_long_set(&n->nr_slabs, 0);
+#ifdef CONFIG_SLUB_DEBUG
 	atomic_long_set(&n->total_objects, 0);
 	INIT_LIST_HEAD(&n->full);
 #endif
_

Patches currently in -mm which might be from aruna.ramakrishna@oracle.com are


