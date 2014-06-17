From: akpm@linux-foundation.org
Subject: +
 slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails.patch added to -mm tree
Date: Tue, 17 Jun 2014 14:44:25 -0700
Message-ID: <53a0b6b9.UyDjn2ze529GRz8S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57451 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964931AbaFQVo0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jun 2014 17:44:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, penberg@kernel.org, mhocko@suse.cz, iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, cl@linux.com, vdavydov@parallels.com


The patch titled
     Subject: slub: don't fail kmem_cache_shrink if slab placement optimization fails
has been added to the -mm tree.  Its filename is
     slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: slub: don't fail kmem_cache_shrink if slab placement optimization fails

SLUB's kmem_cache_shrink not only removes empty slabs from the cache, but
also sorts slabs by the number of objects in-use to cope with
fragmentation.  To achieve that, it tries to allocate a temporary array. 
If it fails, it will abort the whole procedure.

This is unacceptable for kmemcg, where we want to be sure that all empty
slabs are removed from the cache on memcg offline, so let's just skip the
slab placement optimization step if the allocation fails, but still get
rid of empty slabs.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff -puN mm/slub.c~slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails mm/slub.c
--- a/mm/slub.c~slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails
+++ a/mm/slub.c
@@ -3392,12 +3392,20 @@ int __kmem_cache_shrink(struct kmem_cach
 	struct page *page;
 	struct page *t;
 	int objects = oo_objects(s->max);
+	struct list_head empty_slabs;
 	struct list_head *slabs_by_inuse =
 		kmalloc(sizeof(struct list_head) * objects, GFP_KERNEL);
 	unsigned long flags;
 
-	if (!slabs_by_inuse)
-		return -ENOMEM;
+	if (!slabs_by_inuse) {
+		/*
+		 * Do not fail shrinking empty slabs if allocation of the
+		 * temporary array failed. Just skip the slab placement
+		 * optimization then.
+		 */
+		slabs_by_inuse = &empty_slabs;
+		objects = 1;
+	}
 
 	flush_all(s);
 	for_each_kmem_cache_node(s, node, n) {
@@ -3416,7 +3424,9 @@ int __kmem_cache_shrink(struct kmem_cach
 		 * list_lock. page->inuse here is the upper limit.
 		 */
 		list_for_each_entry_safe(page, t, &n->partial, lru) {
-			list_move(&page->lru, slabs_by_inuse + page->inuse);
+			if (page->inuse < objects)
+				list_move(&page->lru,
+					  slabs_by_inuse + page->inuse);
 			if (!page->inuse)
 				n->nr_partial--;
 		}
@@ -3435,7 +3445,8 @@ int __kmem_cache_shrink(struct kmem_cach
 			discard_slab(s, page);
 	}
 
-	kfree(slabs_by_inuse);
+	if (slabs_by_inuse != &empty_slabs)
+		kfree(slabs_by_inuse);
 	return 0;
 }
 
_

Patches currently in -mm which might be from vdavydov@parallels.com are

slab-fix-oops-when-reading-proc-slab_allocators.patch
memcg-cleanup-memcg_cache_params-refcnt-usage.patch
memcg-destroy-kmem-caches-when-last-slab-is-freed.patch
memcg-mark-caches-that-belong-to-offline-memcgs-as-dead.patch
slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails.patch
slub-make-slab_free-non-preemptable.patch
memcg-wait-for-kfrees-to-finish-before-destroying-cache.patch
slub-make-dead-memcg-caches-discard-free-slabs-immediately.patch
slab-do-not-keep-free-objects-slabs-on-dead-memcg-caches.patch
linux-next.patch

