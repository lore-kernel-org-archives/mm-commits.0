From: akpm@linux-foundation.org
Subject: [patch 06/20] mm/slab: improve performance of gathering slabinfo
 stats
Date: Thu, 27 Oct 2016 17:46:32 -0700
Message-ID: <58129fe8.ggKjymzil9e9OyQJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57816 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936219AbcJ1Aqe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2016 20:46:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, aruna.ramakrishna@oracle.com, cl@linux.com, iamjoonsoo.kim@lge.com, mike.kravetz@oracle.com, penberg@kernel.org, rientjes@google.com

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

Link: http://lkml.kernel.org/r/1472517876-26814-1-git-send-email-aruna.ramakrishna@oracle.com
Signed-off-by: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   43 +++++++++++++++++++++++++++----------------
 mm/slab.h |    1 +
 2 files changed, 28 insertions(+), 16 deletions(-)

diff -puN mm/slab.c~mm-slab-improve-performance-of-gathering-slabinfo-stats mm/slab.c
--- a/mm/slab.c~mm-slab-improve-performance-of-gathering-slabinfo-stats
+++ a/mm/slab.c
@@ -233,6 +233,7 @@ static void kmem_cache_node_init(struct
 	spin_lock_init(&parent->list_lock);
 	parent->free_objects = 0;
 	parent->free_touched = 0;
+	parent->num_slabs = 0;
 }
 
 #define MAKE_LIST(cachep, listp, slab, nodeid)				\
@@ -1382,24 +1383,27 @@ slab_out_of_memory(struct kmem_cache *ca
 	for_each_kmem_cache_node(cachep, node, n) {
 		unsigned long active_objs = 0, num_objs = 0, free_objects = 0;
 		unsigned long active_slabs = 0, num_slabs = 0;
+		unsigned long num_slabs_partial = 0, num_slabs_free = 0;
+		unsigned long num_slabs_full;
 
 		spin_lock_irqsave(&n->list_lock, flags);
-		list_for_each_entry(page, &n->slabs_full, lru) {
-			active_objs += cachep->num;
-			active_slabs++;
-		}
+		num_slabs = n->num_slabs;
 		list_for_each_entry(page, &n->slabs_partial, lru) {
 			active_objs += page->active;
-			active_slabs++;
+			num_slabs_partial++;
 		}
 		list_for_each_entry(page, &n->slabs_free, lru)
-			num_slabs++;
+			num_slabs_free++;
 
 		free_objects += n->free_objects;
 		spin_unlock_irqrestore(&n->list_lock, flags);
 
-		num_slabs += active_slabs;
 		num_objs = num_slabs * cachep->num;
+		active_slabs = num_slabs - num_slabs_free;
+		num_slabs_full = num_slabs -
+			(num_slabs_partial + num_slabs_free);
+		active_objs += (num_slabs_full * cachep->num);
+
 		pr_warn("  node %d: slabs: %ld/%ld, objs: %ld/%ld, free: %ld\n",
 			node, active_slabs, num_slabs, active_objs, num_objs,
 			free_objects);
@@ -2314,6 +2318,7 @@ static int drain_freelist(struct kmem_ca
 
 		page = list_entry(p, struct page, lru);
 		list_del(&page->lru);
+		n->num_slabs--;
 		/*
 		 * Safe to drop the lock. The slab is no longer linked
 		 * to the cache.
@@ -2752,6 +2757,8 @@ static void cache_grow_end(struct kmem_c
 		list_add_tail(&page->lru, &(n->slabs_free));
 	else
 		fixup_slab_list(cachep, n, page, &list);
+
+	n->num_slabs++;
 	STATS_INC_GROWN(cachep);
 	n->free_objects += cachep->num - page->active;
 	spin_unlock(&n->list_lock);
@@ -3443,6 +3450,7 @@ static void free_block(struct kmem_cache
 
 		page = list_last_entry(&n->slabs_free, struct page, lru);
 		list_move(&page->lru, list);
+		n->num_slabs--;
 	}
 }
 
@@ -4099,6 +4107,8 @@ void get_slabinfo(struct kmem_cache *cac
 	unsigned long num_objs;
 	unsigned long active_slabs = 0;
 	unsigned long num_slabs, free_objects = 0, shared_avail = 0;
+	unsigned long num_slabs_partial = 0, num_slabs_free = 0;
+	unsigned long num_slabs_full = 0;
 	const char *name;
 	char *error = NULL;
 	int node;
@@ -4111,33 +4121,34 @@ void get_slabinfo(struct kmem_cache *cac
 		check_irq_on();
 		spin_lock_irq(&n->list_lock);
 
-		list_for_each_entry(page, &n->slabs_full, lru) {
-			if (page->active != cachep->num && !error)
-				error = "slabs_full accounting error";
-			active_objs += cachep->num;
-			active_slabs++;
-		}
+		num_slabs += n->num_slabs;
+
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
@@ -432,6 +432,7 @@ struct kmem_cache_node {
 	struct list_head slabs_partial;	/* partial list first, better asm code */
 	struct list_head slabs_full;
 	struct list_head slabs_free;
+	unsigned long num_slabs;
 	unsigned long free_objects;
 	unsigned int free_limit;
 	unsigned int colour_next;	/* Per-node cache coloring */
_
