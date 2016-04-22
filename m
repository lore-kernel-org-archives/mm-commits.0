From: akpm@linux-foundation.org
Subject: + mm-slab-clean-up-kmem_cache_node-setup.patch added to -mm tree
Date: Fri, 22 Apr 2016 15:02:01 -0700
Message-ID: <571a9f59.I3r1pWyOzGkU9Tit%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38062 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbcDVWCC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2016 18:02:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, brouer@redhat.com, cl@linux.com, jonathanh@nvidia.com, nm@ti.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: clean-up kmem_cache_node setup
has been added to the -mm tree.  Its filename is
     mm-slab-clean-up-kmem_cache_node-setup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-clean-up-kmem_cache_node-setup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-clean-up-kmem_cache_node-setup.patch

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
@@ -905,6 +905,63 @@ static int init_cache_node_node(int node
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
@@ -976,7 +1033,6 @@ free_slab:
 static int cpuup_prepare(long cpu)
 {
 	struct kmem_cache *cachep;
-	struct kmem_cache_node *n = NULL;
 	int node = cpu_to_mem(cpu);
 	int err;
 
@@ -995,44 +1051,9 @@ static int cpuup_prepare(long cpu)
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
@@ -3672,72 +3693,19 @@ EXPORT_SYMBOL(kfree);
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
@@ -3779,7 +3747,7 @@ static int __do_tune_cpucache(struct kme
 	cachep->shared = shared;
 
 	if (!prev)
-		goto alloc_node;
+		goto setup_node;
 
 	for_each_online_cpu(cpu) {
 		LIST_HEAD(list);
@@ -3796,8 +3764,8 @@ static int __do_tune_cpucache(struct kme
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

mm-slab-fix-the-theoretical-race-by-holding-proper-lock.patch
mm-slab-remove-bad_alien_magic-again.patch
mm-slab-drain-the-free-slab-as-much-as-possible.patch
mm-slab-factor-out-kmem_cache_node-initialization-code.patch
mm-slab-clean-up-kmem_cache_node-setup.patch
mm-slab-dont-keep-free-slabs-if-free_objects-exceeds-free_limit.patch
mm-slab-racy-access-modify-the-slab-color.patch
mm-slab-make-cache_grow-handle-the-page-allocated-on-arbitrary-node.patch
mm-slab-separate-cache_grow-to-two-parts.patch
mm-slab-refill-cpu-cache-through-a-new-slab-without-holding-a-node-lock.patch
mm-slab-lockless-decision-to-grow-cache.patch
mm-page_ref-use-page_ref-helper-instead-of-direct-modification-of-_count.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix-fix.patch
mm-hugetlb-add-same-zone-check-in-pfn_range_valid_gigantic.patch
mm-memory_hotplug-add-comment-to-some-functions-related-to-memory-hotplug.patch
mm-vmstat-add-zone-range-overlapping-check.patch
mm-page_owner-add-zone-range-overlapping-check.patch
power-add-zone-range-overlapping-check.patch
mm-writeback-correct-dirty-page-calculation-for-highmem.patch
mm-page_alloc-correct-highmem-memory-statistics.patch
mm-highmem-make-nr_free_highpages-handles-all-highmem-zones-by-itself.patch
mm-vmstat-make-node_page_state-handles-all-zones-by-itself.patch

