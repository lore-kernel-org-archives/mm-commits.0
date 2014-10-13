From: akpm@linux-foundation.org
Subject: [merged]
 mm-slab-factor-out-unlikely-part-of-cache_free_alien.patch removed from -mm tree
Date: Mon, 13 Oct 2014 11:18:40 -0700
Message-ID: <543c1780.4OlTsylBRYPwdMbt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60131 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbaJMSSk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:18:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: factor out unlikely part of cache_free_alien()
has been removed from the -mm tree.  Its filename was
     mm-slab-factor-out-unlikely-part-of-cache_free_alien.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slab: factor out unlikely part of cache_free_alien()

cache_free_alien() is rarely used function when node mismatch.  But, it is
defined with inline attribute so it is inlined to __cache_free() which is
core free function of slab allocator.  It uselessly makes
kmem_cache_free()/kfree() functions large.  What we really need to inline
is just checking node match so this patch factor out other parts of
cache_free_alien() to reduce code size of kmem_cache_free()/ kfree().

<Before>
nm -S mm/slab.o | grep -e "T kfree" -e "T kmem_cache_free"
00000000000011e0 0000000000000228 T kfree
0000000000000670 0000000000000216 T kmem_cache_free

<After>
nm -S mm/slab.o | grep -e "T kfree" -e "T kmem_cache_free"
0000000000001110 00000000000001b5 T kfree
0000000000000750 0000000000000181 T kmem_cache_free

You can see slightly reduced size of text: 0x228->0x1b5, 0x216->0x181.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   38 +++++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff -puN mm/slab.c~mm-slab-factor-out-unlikely-part-of-cache_free_alien mm/slab.c
--- a/mm/slab.c~mm-slab-factor-out-unlikely-part-of-cache_free_alien
+++ a/mm/slab.c
@@ -984,46 +984,50 @@ static void drain_alien_cache(struct kme
 	}
 }
 
-static inline int cache_free_alien(struct kmem_cache *cachep, void *objp)
+static int __cache_free_alien(struct kmem_cache *cachep, void *objp,
+				int node, int page_node)
 {
-	int nodeid = page_to_nid(virt_to_page(objp));
 	struct kmem_cache_node *n;
 	struct alien_cache *alien = NULL;
 	struct array_cache *ac;
-	int node;
 	LIST_HEAD(list);
 
-	node = numa_mem_id();
-
-	/*
-	 * Make sure we are not freeing a object from another node to the array
-	 * cache on this cpu.
-	 */
-	if (likely(nodeid == node))
-		return 0;
-
 	n = get_node(cachep, node);
 	STATS_INC_NODEFREES(cachep);
-	if (n->alien && n->alien[nodeid]) {
-		alien = n->alien[nodeid];
+	if (n->alien && n->alien[page_node]) {
+		alien = n->alien[page_node];
 		ac = &alien->ac;
 		spin_lock(&alien->lock);
 		if (unlikely(ac->avail == ac->limit)) {
 			STATS_INC_ACOVERFLOW(cachep);
-			__drain_alien_cache(cachep, ac, nodeid, &list);
+			__drain_alien_cache(cachep, ac, page_node, &list);
 		}
 		ac_put_obj(cachep, ac, objp);
 		spin_unlock(&alien->lock);
 		slabs_destroy(cachep, &list);
 	} else {
-		n = get_node(cachep, nodeid);
+		n = get_node(cachep, page_node);
 		spin_lock(&n->list_lock);
-		free_block(cachep, &objp, 1, nodeid, &list);
+		free_block(cachep, &objp, 1, page_node, &list);
 		spin_unlock(&n->list_lock);
 		slabs_destroy(cachep, &list);
 	}
 	return 1;
 }
+
+static inline int cache_free_alien(struct kmem_cache *cachep, void *objp)
+{
+	int page_node = page_to_nid(virt_to_page(objp));
+	int node = numa_mem_id();
+	/*
+	 * Make sure we are not freeing a object from another node to the array
+	 * cache on this cpu.
+	 */
+	if (likely(node == page_node))
+		return 0;
+
+	return __cache_free_alien(cachep, objp, node, page_node);
+}
 #endif
 
 /*
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
drivers-dma-coherent-add-initialization-from-device-tree.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-checkpatch-fixes.patch
drivers-dma-contiguous-add-initialization-from-device-tree.patch
page-owners-correct-page-order-when-to-free-page.patch

