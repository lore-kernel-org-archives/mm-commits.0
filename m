From: akpm@linux-foundation.org
Subject: +
 slab-use-slab_post_alloc_hook-in-slab-allocator-shared-with-slub.patch
 added to -mm tree
Date: Tue, 26 Jan 2016 19:29:11 -0800
Message-ID: <56a83987.oaF0jYMFKBPBbJTz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55781 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbcA0D3M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jan 2016 22:29:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brouer@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: use slab_post_alloc_hook in SLAB allocator shared with SLUB
has been added to the -mm tree.  Its filename is
     slab-use-slab_post_alloc_hook-in-slab-allocator-shared-with-slub.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-use-slab_post_alloc_hook-in-slab-allocator-shared-with-slub.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slab-use-slab_post_alloc_hook-in-slab-allocator-shared-with-slub.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -3175,16 +3175,11 @@ slab_alloc_node(struct kmem_cache *cache
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
 
@@ -3235,17 +3230,12 @@ slab_alloc(struct kmem_cache *cachep, gf
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

slub-cleanup-code-for-kmem-cgroup-support-to-kmem_cache_free_bulk.patch
mm-slab-move-slub-alloc-hooks-to-common-mm-slabh.patch
mm-fault-inject-take-over-bootstrap-kmem_cache-check.patch
slab-use-slab_pre_alloc_hook-in-slab-allocator-shared-with-slub.patch
mm-kmemcheck-skip-object-if-slab-allocation-failed.patch
slab-use-slab_post_alloc_hook-in-slab-allocator-shared-with-slub.patch
slab-implement-bulk-alloc-in-slab-allocator.patch
slab-avoid-running-debug-slab-code-with-irqs-disabled-for-alloc_bulk.patch
slab-implement-bulk-free-in-slab-allocator.patch
mm-new-api-kfree_bulk-for-slabslub-allocators.patch
mm-fix-some-spelling.patch

