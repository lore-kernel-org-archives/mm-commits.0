From: akpm@linux-foundation.org
Subject: [merged]
 slab-use-slab_post_alloc_hook-in-slab-allocator-shared-with-slub.patch
 removed from -mm tree
Date: Wed, 16 Mar 2016 12:53:47 -0700
Message-ID: <56e9b9cb.wOYj/NMqyZp7lekw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38449 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335AbcCPTxs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:53:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brouer@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: use slab_post_alloc_hook in SLAB allocator shared with SLUB
has been removed from the -mm tree.  Its filename was
     slab-use-slab_post_alloc_hook-in-slab-allocator-shared-with-slub.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: slab: use slab_post_alloc_hook in SLAB allocator shared with SLUB

Reviewers notice that the order in slab_post_alloc_hook() of
kmemcheck_slab_alloc() and kmemleak_alloc_recursive() gets swapped
compared to slab.c / SLAB allocator.

Also notice memset now occurs before calling kmemcheck_slab_alloc()
and kmemleak_alloc_recursive().

I assume this reordering of kmemcheck, kmemleak and memset is okay because
this is the order they are used by the SLUB allocator.

This patch completes the sharing of alloc_hook's between SLUB and SLAB.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff -puN mm/slab.c~slab-use-slab_post_alloc_hook-in-slab-allocator-shared-with-slub mm/slab.c
--- a/mm/slab.c~slab-use-slab_post_alloc_hook-in-slab-allocator-shared-with-slub
+++ a/mm/slab.c
@@ -3176,16 +3176,11 @@ slab_alloc_node(struct kmem_cache *cache
   out:
 	local_irq_restore(save_flags);
 	ptr = cache_alloc_debugcheck_after(cachep, flags, ptr, caller);
-	kmemleak_alloc_recursive(ptr, cachep->object_size, 1, cachep->flags,
-				 flags);
 
-	if (likely(ptr)) {
-		kmemcheck_slab_alloc(cachep, flags, ptr, cachep->object_size);
-		if (unlikely(flags & __GFP_ZERO))
-			memset(ptr, 0, cachep->object_size);
-	}
+	if (unlikely(flags & __GFP_ZERO) && ptr)
+		memset(ptr, 0, cachep->object_size);
 
-	memcg_kmem_put_cache(cachep);
+	slab_post_alloc_hook(cachep, flags, 1, &ptr);
 	return ptr;
 }
 
@@ -3237,17 +3232,12 @@ slab_alloc(struct kmem_cache *cachep, gf
 	objp = __do_cache_alloc(cachep, flags);
 	local_irq_restore(save_flags);
 	objp = cache_alloc_debugcheck_after(cachep, flags, objp, caller);
-	kmemleak_alloc_recursive(objp, cachep->object_size, 1, cachep->flags,
-				 flags);
 	prefetchw(objp);
 
-	if (likely(objp)) {
-		kmemcheck_slab_alloc(cachep, flags, objp, cachep->object_size);
-		if (unlikely(flags & __GFP_ZERO))
-			memset(objp, 0, cachep->object_size);
-	}
+	if (unlikely(flags & __GFP_ZERO) && objp)
+		memset(objp, 0, cachep->object_size);
 
-	memcg_kmem_put_cache(cachep);
+	slab_post_alloc_hook(cachep, flags, 1, &objp);
 	return objp;
 }
 
_

Patches currently in -mm which might be from brouer@redhat.com are


