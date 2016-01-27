From: akpm@linux-foundation.org
Subject: + mm-slab-remove-the-checks-for-slab-implementation-bug.patch
 added to -mm tree
Date: Tue, 26 Jan 2016 21:30:18 -0800
Message-ID: <56a855ea.PerQOutZg07iuZJI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36793 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbcA0FaU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jan 2016 00:30:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, brouer@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: remove the checks for slab implementation bug
has been added to the -mm tree.  Its filename is
     mm-slab-remove-the-checks-for-slab-implementation-bug.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-remove-the-checks-for-slab-implementation-bug.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-remove-the-checks-for-slab-implementation-bug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: mm/slab: remove the checks for slab implementation bug

Some of "#if DEBUG" are for reporting slab implementation bug rather than
user usecase bug.  It's not really needed because slab is stable for a
quite long time and it makes code too dirty.  This patch remove it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
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
@@ -3250,7 +3237,7 @@ static void free_block(struct kmem_cache
 		page = virt_to_head_page(objp);
 		list_del(&page->lru);
 		check_spinlock_acquired_node(cachep, node);
-		slab_put_obj(cachep, page, objp, node);
+		slab_put_obj(cachep, page, objp);
 		STATS_DEC_ACTIVE(cachep);
 		n->free_objects++;
 
@@ -3280,9 +3267,7 @@ static void cache_flusharray(struct kmem
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

Patches currently in -mm which might be from js1304@gmail.com are

mm-slab-fix-stale-code-comment.patch
mm-slab-remove-useless-structure-define.patch
mm-slab-remove-the-checks-for-slab-implementation-bug.patch
mm-slab-activate-debug_pagealloc-in-slab-when-it-is-actually-enabled.patch
mm-slab-use-more-appropriate-condition-check-for-debug_pagealloc.patch
mm-slab-clean-up-debug_pagealloc-processing-code.patch
mm-slab-alternative-implementation-for-debug_slab_leak.patch
mm-slab-remove-object-status-buffer-for-debug_slab_leak.patch
mm-slab-put-the-freelist-at-the-end-of-slab-page.patch
mm-slab-align-cache-size-first-before-determination-of-off_slab-candidate.patch
mm-slab-clean-up-cache-type-determination.patch
mm-slab-do-not-change-cache-size-if-debug-pagealloc-isnt-possible.patch
mm-slab-make-criteria-for-off-slab-determination-robust-and-simple.patch
mm-slab-factor-out-slab-list-fixup-code.patch
mm-slab-factor-out-debugging-initialization-in-cache_init_objs.patch
mm-slab-introduce-new-slab-management-type-objfreelist_slab.patch

