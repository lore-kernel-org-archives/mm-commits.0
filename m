From: akpm@linux-foundation.org
Subject: [merged]
 mm-slab-factor-out-debugging-initialization-in-cache_init_objs.patch
 removed from -mm tree
Date: Wed, 16 Mar 2016 12:54:47 -0700
Message-ID: <56e9ba07.ADlLrIlYmm6BIB6X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38575 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595AbcCPTys (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:54:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, brouer@redhat.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: factor out debugging initialization in cache_init_objs()
has been removed from the -mm tree.  Its filename was
     mm-slab-factor-out-debugging-initialization-in-cache_init_objs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slab: factor out debugging initialization in cache_init_objs()

cache_init_objs() will be changed in following patch and current form
doesn't fit well for that change.  So, before doing it, this patch
separates debugging initialization.  This would cause two loop iteration
when debugging is enabled, but, this overhead seems too light than debug
feature itself so effect may not be visible.  This patch will greatly
simplify changes in cache_init_objs() in following patch.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff -puN mm/slab.c~mm-slab-factor-out-debugging-initialization-in-cache_init_objs mm/slab.c
--- a/mm/slab.c~mm-slab-factor-out-debugging-initialization-in-cache_init_objs
+++ a/mm/slab.c
@@ -2460,14 +2460,14 @@ static inline void set_free_obj(struct p
 	((freelist_idx_t *)(page->freelist))[idx] = val;
 }
 
-static void cache_init_objs(struct kmem_cache *cachep,
-			    struct page *page)
+static void cache_init_objs_debug(struct kmem_cache *cachep, struct page *page)
 {
+#if DEBUG
 	int i;
 
 	for (i = 0; i < cachep->num; i++) {
 		void *objp = index_to_obj(cachep, page, i);
-#if DEBUG
+
 		if (cachep->flags & SLAB_STORE_USER)
 			*dbg_userword(cachep, objp) = NULL;
 
@@ -2496,10 +2496,22 @@ static void cache_init_objs(struct kmem_
 			poison_obj(cachep, objp, POISON_FREE);
 			slab_kernel_map(cachep, objp, 0, 0);
 		}
-#else
-		if (cachep->ctor)
-			cachep->ctor(objp);
+	}
 #endif
+}
+
+static void cache_init_objs(struct kmem_cache *cachep,
+			    struct page *page)
+{
+	int i;
+
+	cache_init_objs_debug(cachep, page);
+
+	for (i = 0; i < cachep->num; i++) {
+		/* constructor could break poison info */
+		if (DEBUG == 0 && cachep->ctor)
+			cachep->ctor(index_to_obj(cachep, page, i));
+
 		set_free_obj(page, i, i);
 	}
 }
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

