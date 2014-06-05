From: akpm@linux-foundation.org
Subject: [merged]
 mm-slab-suppress-out-of-memory-warning-unless-debug-is-enabled.patch
 removed from -mm tree
Date: Thu, 05 Jun 2014 12:43:16 -0700
Message-ID: <5390c854.PQJumjFZTUfSauH5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55668 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbaFETnR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:43:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penberg@kernel.org, cl@linux.com, rientjes@google.com

Subject: [merged] mm-slab-suppress-out-of-memory-warning-unless-debug-is-enabled.patch removed from -mm tree
To: rientjes@google.com,cl@linux.com,penberg@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:43:16 -0700


The patch titled
     Subject: mm, slab: suppress out of memory warning unless debug is enabled
has been removed from the -mm tree.  Its filename was
     mm-slab-suppress-out-of-memory-warning-unless-debug-is-enabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, slab: suppress out of memory warning unless debug is enabled

When the slab or slub allocators cannot allocate additional slab pages,
they emit diagnostic information to the kernel log such as current number
of slabs, number of objects, active objects, etc.  This is always coupled
with a page allocation failure warning since it is controlled by
!__GFP_NOWARN.

Suppress this out of memory warning if the allocator is configured without
debug supported.  The page allocation failure warning will indicate it is
a failed slab allocation, the order, and the gfp mask, so this is only
useful to diagnose allocator issues.

Since CONFIG_SLUB_DEBUG is already enabled by default for the slub
allocator, there is no functional change with this patch.  If debug is
disabled, however, the warnings are now suppressed.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   10 ++++++++--
 mm/slub.c |   29 +++++++++++++++++------------
 2 files changed, 25 insertions(+), 14 deletions(-)

diff -puN mm/slab.c~mm-slab-suppress-out-of-memory-warning-unless-debug-is-enabled mm/slab.c
--- a/mm/slab.c~mm-slab-suppress-out-of-memory-warning-unless-debug-is-enabled
+++ a/mm/slab.c
@@ -1621,10 +1621,16 @@ __initcall(cpucache_init);
 static noinline void
 slab_out_of_memory(struct kmem_cache *cachep, gfp_t gfpflags, int nodeid)
 {
+#if DEBUG
 	struct kmem_cache_node *n;
 	struct page *page;
 	unsigned long flags;
 	int node;
+	static DEFINE_RATELIMIT_STATE(slab_oom_rs, DEFAULT_RATELIMIT_INTERVAL,
+				      DEFAULT_RATELIMIT_BURST);
+
+	if ((gfpflags & __GFP_NOWARN) || !__ratelimit(&slab_oom_rs))
+		return;
 
 	printk(KERN_WARNING
 		"SLAB: Unable to allocate memory on node %d (gfp=0x%x)\n",
@@ -1662,6 +1668,7 @@ slab_out_of_memory(struct kmem_cache *ca
 			node, active_slabs, num_slabs, active_objs, num_objs,
 			free_objects);
 	}
+#endif
 }
 
 /*
@@ -1683,8 +1690,7 @@ static struct page *kmem_getpages(struct
 
 	page = alloc_pages_exact_node(nodeid, flags | __GFP_NOTRACK, cachep->gfporder);
 	if (!page) {
-		if (!(flags & __GFP_NOWARN) && printk_ratelimit())
-			slab_out_of_memory(cachep, flags, nodeid);
+		slab_out_of_memory(cachep, flags, nodeid);
 		return NULL;
 	}
 
diff -puN mm/slub.c~mm-slab-suppress-out-of-memory-warning-unless-debug-is-enabled mm/slub.c
--- a/mm/slub.c~mm-slab-suppress-out-of-memory-warning-unless-debug-is-enabled
+++ a/mm/slub.c
@@ -2119,11 +2119,19 @@ static inline int node_match(struct page
 	return 1;
 }
 
+#ifdef CONFIG_SLUB_DEBUG
 static int count_free(struct page *page)
 {
 	return page->objects - page->inuse;
 }
 
+static inline unsigned long node_nr_objs(struct kmem_cache_node *n)
+{
+	return atomic_long_read(&n->total_objects);
+}
+#endif /* CONFIG_SLUB_DEBUG */
+
+#if defined(CONFIG_SLUB_DEBUG) || defined(CONFIG_SYSFS)
 static unsigned long count_partial(struct kmem_cache_node *n,
 					int (*get_count)(struct page *))
 {
@@ -2137,21 +2145,19 @@ static unsigned long count_partial(struc
 	spin_unlock_irqrestore(&n->list_lock, flags);
 	return x;
 }
-
-static inline unsigned long node_nr_objs(struct kmem_cache_node *n)
-{
-#ifdef CONFIG_SLUB_DEBUG
-	return atomic_long_read(&n->total_objects);
-#else
-	return 0;
-#endif
-}
+#endif /* CONFIG_SLUB_DEBUG || CONFIG_SYSFS */
 
 static noinline void
 slab_out_of_memory(struct kmem_cache *s, gfp_t gfpflags, int nid)
 {
+#ifdef CONFIG_SLUB_DEBUG
+	static DEFINE_RATELIMIT_STATE(slub_oom_rs, DEFAULT_RATELIMIT_INTERVAL,
+				      DEFAULT_RATELIMIT_BURST);
 	int node;
 
+	if ((gfpflags & __GFP_NOWARN) || !__ratelimit(&slub_oom_rs))
+		return;
+
 	pr_warn("SLUB: Unable to allocate memory on node %d (gfp=0x%x)\n",
 		nid, gfpflags);
 	pr_warn("  cache: %s, object size: %d, buffer size: %d, default order: %d, min order: %d\n",
@@ -2178,6 +2184,7 @@ slab_out_of_memory(struct kmem_cache *s,
 		pr_warn("  node %d: slabs: %ld, objs: %ld, free: %ld\n",
 			node, nr_slabs, nr_objs, nr_free);
 	}
+#endif
 }
 
 static inline void *new_slab_objects(struct kmem_cache *s, gfp_t flags,
@@ -2356,9 +2363,7 @@ new_slab:
 	freelist = new_slab_objects(s, gfpflags, node, &c);
 
 	if (unlikely(!freelist)) {
-		if (!(gfpflags & __GFP_NOWARN) && printk_ratelimit())
-			slab_out_of_memory(s, gfpflags, node);
