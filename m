From: akpm@linux-foundation.org
Subject: [patch 024/117] mm/slab: drain the free slab as much as possible
Date: Thu, 19 May 2016 17:10:08 -0700
Message-ID: <573e55e0.b5noL2iSsG2MHFLy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45955 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561AbcETAKJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:10:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, brouer@redhat.com, cl@linux.com, penberg@kernel.org, rientjes@google.com

From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slab: drain the free slab as much as possible

slabs_tofree() implies freeing all free slab. We can do it with
just providing INT_MAX.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff -puN mm/slab.c~mm-slab-drain-the-free-slab-as-much-as-possible mm/slab.c
--- a/mm/slab.c~mm-slab-drain-the-free-slab-as-much-as-possible
+++ a/mm/slab.c
@@ -895,12 +895,6 @@ static int init_cache_node_node(int node
 	return 0;
 }
 
-static inline int slabs_tofree(struct kmem_cache *cachep,
-						struct kmem_cache_node *n)
-{
-	return (n->free_objects + cachep->num - 1) / cachep->num;
-}
-
 static void cpuup_canceled(long cpu)
 {
 	struct kmem_cache *cachep;
@@ -965,7 +959,7 @@ free_slab:
 		n = get_node(cachep, node);
 		if (!n)
 			continue;
-		drain_freelist(cachep, n, slabs_tofree(cachep, n));
+		drain_freelist(cachep, n, INT_MAX);
 	}
 }
 
@@ -1117,7 +1111,7 @@ static int __meminit drain_cache_node_no
 		if (!n)
 			continue;
 
-		drain_freelist(cachep, n, slabs_tofree(cachep, n));
+		drain_freelist(cachep, n, INT_MAX);
 
 		if (!list_empty(&n->slabs_full) ||
 		    !list_empty(&n->slabs_partial)) {
@@ -2311,7 +2305,7 @@ int __kmem_cache_shrink(struct kmem_cach
 
 	check_irq_on();
 	for_each_kmem_cache_node(cachep, node, n) {
-		drain_freelist(cachep, n, slabs_tofree(cachep, n));
+		drain_freelist(cachep, n, INT_MAX);
 
 		ret += !list_empty(&n->slabs_full) ||
 			!list_empty(&n->slabs_partial);
_
