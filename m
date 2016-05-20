From: akpm@linux-foundation.org
Subject: [merged]
 mm-slab-factor-out-kmem_cache_node-initialization-code.patch removed from
 -mm tree
Date: Fri, 20 May 2016 14:03:22 -0700
Message-ID: <573f7b9a.b4fX54U1NpenL8ts%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46807 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbcETVDX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:03:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, brouer@redhat.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: factor out kmem_cache_node initialization code
has been removed from the -mm tree.  Its filename was
     mm-slab-factor-out-kmem_cache_node-initialization-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 mm/slab.c |   74 +++++++++++++++++++++++++++++++---------------------
 1 file changed, 45 insertions(+), 29 deletions(-)

diff -puN mm/slab.c~mm-slab-factor-out-kmem_cache_node-initialization-code mm/slab.c
--- a/mm/slab.c~mm-slab-factor-out-kmem_cache_node-initialization-code
+++ a/mm/slab.c
@@ -848,6 +848,46 @@ static inline gfp_t gfp_exact_node(gfp_t
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
+	if (n) {
+		spin_lock_irq(&n->list_lock);
+		n->free_limit = (1 + nr_cpus_node(node)) * cachep->batchcount +
+				cachep->num;
+		spin_unlock_irq(&n->list_lock);
+
+		return 0;
+	}
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
@@ -859,39 +899,15 @@ static inline gfp_t gfp_exact_node(gfp_t
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
