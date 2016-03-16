From: akpm@linux-foundation.org
Subject: [merged]
 mm-slab-remove-the-checks-for-slab-implementation-bug.patch removed from
 -mm tree
Date: Wed, 16 Mar 2016 12:54:11 -0700
Message-ID: <56e9b9e3.BcIt92h6jFn9AriM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38503 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190AbcCPTyM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:54:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, brouer@redhat.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: remove the checks for slab implementation bug
has been removed from the -mm tree.  Its filename was
     mm-slab-remove-the-checks-for-slab-implementation-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slab: remove the checks for slab implementation bug

Some of "#if DEBUG" are for reporting slab implementation bug rather than
user usecase bug.  It's not really needed because slab is stable for a
quite long time and it makes code too dirty.  This patch remove it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   29 +++++++----------------------
 1 file changed, 7 insertions(+), 22 deletions(-)

diff -puN mm/slab.c~mm-slab-remove-the-checks-for-slab-implementation-bug mm/slab.c
--- a/mm/slab.c~mm-slab-remove-the-checks-for-slab-implementation-bug
+++ a/mm/slab.c
@@ -2110,8 +2110,6 @@ __kmem_cache_create (struct kmem_cache *
 	if (!(flags & SLAB_DESTROY_BY_RCU))
 		flags |= SLAB_POISON;
 #endif
-	if (flags & SLAB_DESTROY_BY_RCU)
-		BUG_ON(flags & SLAB_POISON);
 #endif
 
 	/*
@@ -2368,9 +2366,6 @@ static int drain_freelist(struct kmem_ca
 		}
 
 		page = list_entry(p, struct page, lru);
-#if DEBUG
-		BUG_ON(page->active);
-#endif
 		list_del(&page->lru);
 		/*
 		 * Safe to drop the lock. The slab is no longer linked
@@ -2528,30 +2523,23 @@ static void kmem_flagcheck(struct kmem_c
 	}
 }
 
-static void *slab_get_obj(struct kmem_cache *cachep, struct page *page,
-				int nodeid)
+static void *slab_get_obj(struct kmem_cache *cachep, struct page *page)
 {
 	void *objp;
 
 	objp = index_to_obj(cachep, page, get_free_obj(page, page->active));
 	page->active++;
-#if DEBUG
-	WARN_ON(page_to_nid(virt_to_page(objp)) != nodeid);
-#endif
 
 	return objp;
 }
 
-static void slab_put_obj(struct kmem_cache *cachep, struct page *page,
-				void *objp, int nodeid)
+static void slab_put_obj(struct kmem_cache *cachep,
+			struct page *page, void *objp)
 {
 	unsigned int objnr = obj_to_index(cachep, page, objp);
 #if DEBUG
 	unsigned int i;
 
-	/* Verify that the slab belongs to the intended node */
-	WARN_ON(page_to_nid(virt_to_page(objp)) != nodeid);
-
 	/* Verify double free bug */
 	for (i = page->active; i < cachep->num; i++) {
 		if (get_free_obj(page, i) == objnr) {
@@ -2817,8 +2805,7 @@ retry:
 			STATS_INC_ACTIVE(cachep);
 			STATS_SET_HIGH(cachep);
 
-			ac_put_obj(cachep, ac, slab_get_obj(cachep, page,
-									node));
+			ac_put_obj(cachep, ac, slab_get_obj(cachep, page));
 		}
 
 		/* move slabp to correct slabp list: */
@@ -3101,7 +3088,7 @@ retry:
 
 	BUG_ON(page->active == cachep->num);
 
-	obj = slab_get_obj(cachep, page, nodeid);
+	obj = slab_get_obj(cachep, page);
 	n->free_objects--;
 	/* move slabp to correct slabp list: */
 	list_del(&page->lru);
@@ -3252,7 +3239,7 @@ static void free_block(struct kmem_cache
 		page = virt_to_head_page(objp);
 		list_del(&page->lru);
 		check_spinlock_acquired_node(cachep, node);
-		slab_put_obj(cachep, page, objp, node);
+		slab_put_obj(cachep, page, objp);
 		STATS_DEC_ACTIVE(cachep);
 		n->free_objects++;
 
@@ -3282,9 +3269,7 @@ static void cache_flusharray(struct kmem
 	LIST_HEAD(list);
 
 	batchcount = ac->batchcount;
-#if DEBUG
-	BUG_ON(!batchcount || batchcount > ac->avail);
-#endif
+
 	check_irq_off();
 	n = get_node(cachep, node);
 	spin_lock(&n->list_lock);
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-vmalloc-query-dynamic-debug_pagealloc-setting.patch
mm-slub-query-dynamic-debug_pagealloc-setting.patch
mm-slub-query-dynamic-debug_pagealloc-setting-v2.patch
sound-query-dynamic-debug_pagealloc-setting.patch
powerpc-query-dynamic-debug_pagealloc-setting.patch
tile-query-dynamic-debug_pagealloc-setting.patch
mm-introduce-page-reference-manipulation-functions.patch
mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation.patch
mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-3.patch

