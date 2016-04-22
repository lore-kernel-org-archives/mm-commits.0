From: akpm@linux-foundation.org
Subject: + mm-slab-factor-out-kmem_cache_node-initialization-code.patch
 added to -mm tree
Date: Fri, 22 Apr 2016 15:01:59 -0700
Message-ID: <571a9f57.Jd/tRqSUuRx9/d7Q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38054 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbcDVWCA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2016 18:02:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, brouer@redhat.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: factor out kmem_cache_node initialization code
has been added to the -mm tree.  Its filename is
     mm-slab-factor-out-kmem_cache_node-initialization-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-factor-out-kmem_cache_node-initialization-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-factor-out-kmem_cache_node-initialization-code.patch

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
Subject: mm/slab: factor out kmem_cache_node initialization code

It can be reused on other place, so factor out it.  Following patch will
use it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   68 +++++++++++++++++++++++++++++-----------------------
 1 file changed, 39 insertions(+), 29 deletions(-)

diff -puN mm/slab.c~mm-slab-factor-out-kmem_cache_node-initialization-code mm/slab.c
--- a/mm/slab.c~mm-slab-factor-out-kmem_cache_node-initialization-code
+++ a/mm/slab.c
@@ -848,6 +848,40 @@ static inline gfp_t gfp_exact_node(gfp_t
 }
 #endif
 
+static int init_cache_node(struct kmem_cache *cachep, int node, gfp_t gfp)
+{
+	struct kmem_cache_node *n;
+
+	/*
+	 * Set up the kmem_cache_node for cpu before we can
+	 * begin anything. Make sure some other cpu on this
+	 * node has not already allocated this
+	 */
+	n = get_node(cachep, node);
+	if (n)
+		return 0;
+
+	n = kmalloc_node(sizeof(struct kmem_cache_node), gfp, node);
+	if (!n)
+		return -ENOMEM;
+
+	kmem_cache_node_init(n);
+	n->next_reap = jiffies + REAPTIMEOUT_NODE +
+		    ((unsigned long)cachep) % REAPTIMEOUT_NODE;
+
+	n->free_limit =
+		(1 + nr_cpus_node(node)) * cachep->batchcount + cachep->num;
+
+	/*
+	 * The kmem_cache_nodes don't come and go as CPUs
+	 * come and go.  slab_mutex is sufficient
+	 * protection here.
+	 */
+	cachep->node[node] = n;
+
+	return 0;
+}
+
 /*
  * Allocates and initializes node for a node on each slab cache, used for
  * either memory or cpu hotplug.  If memory is being hot-added, the kmem_cache_node
@@ -859,39 +893,15 @@ static inline gfp_t gfp_exact_node(gfp_t
  */
 static int init_cache_node_node(int node)
 {
+	int ret;
 	struct kmem_cache *cachep;
-	struct kmem_cache_node *n;
-	const size_t memsize = sizeof(struct kmem_cache_node);
 
 	list_for_each_entry(cachep, &slab_caches, list) {
-		/*
-		 * Set up the kmem_cache_node for cpu before we can
-		 * begin anything. Make sure some other cpu on this
-		 * node has not already allocated this
-		 */
-		n = get_node(cachep, node);
-		if (!n) {
-			n = kmalloc_node(memsize, GFP_KERNEL, node);
-			if (!n)
-				return -ENOMEM;
-			kmem_cache_node_init(n);
-			n->next_reap = jiffies + REAPTIMEOUT_NODE +
-			    ((unsigned long)cachep) % REAPTIMEOUT_NODE;
-
-			/*
-			 * The kmem_cache_nodes don't come and go as CPUs
-			 * come and go.  slab_mutex is sufficient
-			 * protection here.
-			 */
-			cachep->node[node] = n;
-		}
-
-		spin_lock_irq(&n->list_lock);
-		n->free_limit =
-			(1 + nr_cpus_node(node)) *
-			cachep->batchcount + cachep->num;
-		spin_unlock_irq(&n->list_lock);
+		ret = init_cache_node(cachep, node, GFP_KERNEL);
+		if (ret)
+			return ret;
 	}
+
 	return 0;
 }
 
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

