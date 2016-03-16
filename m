From: akpm@linux-foundation.org
Subject: [merged] mm-slab-factor-out-slab-list-fixup-code.patch removed
 from -mm tree
Date: Wed, 16 Mar 2016 12:54:44 -0700
Message-ID: <56e9ba04.2FDrEC/NXBDrFshL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38570 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598AbcCPTyp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:54:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, brouer@redhat.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: factor out slab list fixup code
has been removed from the -mm tree.  Its filename was
     mm-slab-factor-out-slab-list-fixup-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slab: factor out slab list fixup code

Slab list should be fixed up after object is detached from the slab and
this happens at two places.  They do exactly same thing.  They will be
changed in the following patch, so, to reduce code duplication, this patch
factor out them and make it common function.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff -puN mm/slab.c~mm-slab-factor-out-slab-list-fixup-code mm/slab.c
--- a/mm/slab.c~mm-slab-factor-out-slab-list-fixup-code
+++ a/mm/slab.c
@@ -2723,6 +2723,17 @@ static void *cache_free_debugcheck(struc
 #define cache_free_debugcheck(x,objp,z) (objp)
 #endif
 
+static inline void fixup_slab_list(struct kmem_cache *cachep,
+				struct kmem_cache_node *n, struct page *page)
+{
+	/* move slabp to correct slabp list: */
+	list_del(&page->lru);
+	if (page->active == cachep->num)
+		list_add(&page->lru, &n->slabs_full);
+	else
+		list_add(&page->lru, &n->slabs_partial);
+}
+
 static struct page *get_first_slab(struct kmem_cache_node *n)
 {
 	struct page *page;
@@ -2796,12 +2807,7 @@ retry:
 			ac_put_obj(cachep, ac, slab_get_obj(cachep, page));
 		}
 
-		/* move slabp to correct slabp list: */
-		list_del(&page->lru);
-		if (page->active == cachep->num)
-			list_add(&page->lru, &n->slabs_full);
-		else
-			list_add(&page->lru, &n->slabs_partial);
+		fixup_slab_list(cachep, n, page);
 	}
 
 must_grow:
@@ -3067,13 +3073,8 @@ retry:
 
 	obj = slab_get_obj(cachep, page);
 	n->free_objects--;
-	/* move slabp to correct slabp list: */
-	list_del(&page->lru);
 
-	if (page->active == cachep->num)
-		list_add(&page->lru, &n->slabs_full);
-	else
-		list_add(&page->lru, &n->slabs_partial);
+	fixup_slab_list(cachep, n, page);
 
 	spin_unlock(&n->list_lock);
 	goto done;
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

