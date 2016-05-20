From: akpm@linux-foundation.org
Subject: [merged] mm-slab-clean-up-kmem_cache_node-setup.patch removed
 from -mm tree
Date: Fri, 20 May 2016 14:03:24 -0700
Message-ID: <573f7b9c.6N+w5Eh30zdbXghO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46812 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbcETVDZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:03:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, brouer@redhat.com, cl@linux.com, jonathanh@nvidia.com, nm@ti.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: clean-up kmem_cache_node setup
has been removed from the -mm tree.  Its filename was
     mm-slab-clean-up-kmem_cache_node-setup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slab: clean-up kmem_cache_node setup

There are mostly same code for setting up kmem_cache_node either in
cpuup_prepare() or alloc_kmem_cache_node().  Factor out and clean-up them.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Tested-by: Nishanth Menon <nm@ti.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |  168 +++++++++++++++++++++-------------------------------
 1 file changed, 68 insertions(+), 100 deletions(-)

diff -puN mm/slab.c~mm-slab-clean-up-kmem_cache_node-setup mm/slab.c
--- a/mm/slab.c~mm-slab-clean-up-kmem_cache_node-setup
+++ a/mm/slab.c
@@ -911,6 +911,63 @@ static int init_cache_node_node(int node
 	return 0;
 }
 
+static int setup_kmem_cache_node(struct kmem_cache *cachep,
+				int node, gfp_t gfp, bool force_change)
+{
+	int ret = -ENOMEM;
+	struct kmem_cache_node *n;
+	struct array_cache *old_shared = NULL;
+	struct array_cache *new_shared = NULL;
+	struct alien_cache **new_alien = NULL;
+	LIST_HEAD(list);
+
+	if (use_alien_caches) {
+		new_alien = alloc_alien_cache(node, cachep->limit, gfp);
+		if (!new_alien)
+			goto fail;
+	}
+
+	if (cachep->shared) {
+		new_shared = alloc_arraycache(node,
+			cachep->shared * cachep->batchcount, 0xbaadf00d, gfp);
+		if (!new_shared)
+			goto fail;
+	}
+
+	ret = init_cache_node(cachep, node, gfp);
+	if (ret)
+		goto fail;
+
+	n = get_node(cachep, node);
+	spin_lock_irq(&n->list_lock);
+	if (n->shared && force_change) {
+		free_block(cachep, n->shared->entry,
+				n->shared->avail, node, &list);
+		n->shared->avail = 0;
+	}
+
+	if (!n->shared || force_change) {
+		old_shared = n->shared;
+		n->shared = new_shared;
+		new_shared = NULL;
+	}
+
+	if (!n->alien) {
+		n->alien = new_alien;
+		new_alien = NULL;
+	}
+
+	spin_unlock_irq(&n->list_lock);
+	slabs_destroy(cachep, &list);
+
+fail:
+	kfree(old_shared);
+	kfree(new_shared);
+	free_alien_cache(new_alien);
+
+	return ret;
+}
+
 static void cpuup_canceled(long cpu)
 {
 	struct kmem_cache *cachep;
@@ -982,7 +1039,6 @@ free_slab:
 static int cpuup_prepare(long cpu)
 {
 	struct kmem_cache *cachep;
-	struct kmem_cache_node *n = NULL;
 	int node = cpu_to_mem(cpu);
 	int err;
 
@@ -1001,44 +1057,9 @@ static int cpuup_prepare(long cpu)
 	 * array caches
 	 */
 	list_for_each_entry(cachep, &slab_caches, list) {
-		struct array_cache *shared = NULL;
-		struct alien_cache **alien = NULL;
-
-		if (cachep->shared) {
-			shared = alloc_arraycache(node,
-				cachep->shared * cachep->batchcount,
-				0xbaadf00d, GFP_KERNEL);
-			if (!shared)
-				goto bad;
-		}
-		if (use_alien_caches) {
-			alien = alloc_alien_cache(node, cachep->limit, GFP_KERNEL);
-			if (!alien) {
-				kfree(shared);
-				goto bad;
-			}
-		}
-		n = get_node(cachep, node);
-		BUG_ON(!n);
-
-		spin_lock_irq(&n->list_lock);
-		if (!n->shared) {
-			/*
-			 * We are serialised from CPU_DEAD or
-			 * CPU_UP_CANCELLED by the cpucontrol lock
-			 */
-			n->shared = shared;
-			shared = NULL;
-		}
-#ifdef CONFIG_NUMA
-		if (!n->alien) {
-			n->alien = alien;
-			alien = NULL;
-		}
-#endif
-		spin_unlock_irq(&n->list_lock);
-		kfree(shared);
-		free_alien_cache(alien);
+		err = setup_kmem_cache_node(cachep, node, GFP_KERNEL, false);
+		if (err)
+			goto bad;
 	}
 
 	return 0;
@@ -3678,72 +3699,19 @@ EXPORT_SYMBOL(kfree);
 /*
  * This initializes kmem_cache_node or resizes various caches for all nodes.
  */
-static int alloc_kmem_cache_node(struct kmem_cache *cachep, gfp_t gfp)
+static int setup_kmem_cache_nodes(struct kmem_cache *cachep, gfp_t gfp)
 {
+	int ret;
 	int node;
 	struct kmem_cache_node *n;
-	struct array_cache *new_shared;
-	struct alien_cache **new_alien = NULL;
 
 	for_each_online_node(node) {
-
-		if (use_alien_caches) {
-			new_alien = alloc_alien_cache(node, cachep->limit, gfp);
-			if (!new_alien)
-				goto fail;
-		}
-
-		new_shared = NULL;
-		if (cachep->shared) {
-			new_shared = alloc_arraycache(node,
-				cachep->shared*cachep->batchcount,
-					0xbaadf00d, gfp);
-			if (!new_shared) {
-				free_alien_cache(new_alien);
-				goto fail;
-			}
-		}
-
-		n = get_node(cachep, node);
-		if (n) {
-			struct array_cache *shared = n->shared;
-			LIST_HEAD(list);
-
-			spin_lock_irq(&n->list_lock);
-
-			if (shared)
-				free_block(cachep, shared->entry,
-						shared->avail, node, &list);
-
-			n->shared = new_shared;
-			if (!n->alien) {
-				n->alien = new_alien;
-				new_alien = NULL;
-			}
-			n->free_limit = (1 + nr_cpus_node(node)) *
-					cachep->batchcount + cachep->num;
-			spin_unlock_irq(&n->list_lock);
-			slabs_destroy(cachep, &list);
-			kfree(shared);
-			free_alien_cache(new_alien);
-			continue;
-		}
-		n = kmalloc_node(sizeof(struct kmem_cache_node), gfp, node);
-		if (!n) {
-			free_alien_cache(new_alien);
-			kfree(new_shared);
+		ret = setup_kmem_cache_node(cachep, node, gfp, true);
+		if (ret)
 			goto fail;
-		}
 
-		kmem_cache_node_init(n);
-		n->next_reap = jiffies + REAPTIMEOUT_NODE +
-				((unsigned long)cachep) % REAPTIMEOUT_NODE;
-		n->shared = new_shared;
-		n->alien = new_alien;
-		n->free_limit = (1 + nr_cpus_node(node)) *
-					cachep->batchcount + cachep->num;
-		cachep->node[node] = n;
 	}
+
 	return 0;
 
 fail:
@@ -3785,7 +3753,7 @@ static int __do_tune_cpucache(struct kme
 	cachep->shared = shared;
 
 	if (!prev)
-		goto alloc_node;
+		goto setup_node;
 
 	for_each_online_cpu(cpu) {
 		LIST_HEAD(list);
@@ -3802,8 +3770,8 @@ static int __do_tune_cpucache(struct kme
 	}
 	free_percpu(prev);
 
-alloc_node:
-	return alloc_kmem_cache_node(cachep, gfp);
+setup_node:
+	return setup_kmem_cache_nodes(cachep, gfp);
 }
 
 static int do_tune_cpucache(struct kmem_cache *cachep, int limit,
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are


