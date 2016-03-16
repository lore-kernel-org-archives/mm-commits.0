From: akpm@linux-foundation.org
Subject: [merged] mm-slab-clean-up-cache-type-determination.patch removed
 from -mm tree
Date: Wed, 16 Mar 2016 12:54:35 -0700
Message-ID: <56e9b9fb.XnwcI60DSvee5Cxx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38553 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933996AbcCPTyg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:54:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, brouer@redhat.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: clean up cache type determination
has been removed from the -mm tree.  Its filename was
     mm-slab-clean-up-cache-type-determination.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slab: clean up cache type determination

Current cache type determination code is open-code and looks not
understandable.  Following patch will introduce one more cache type and it
would make code more complex.  So, before it happens, this patch abstracts
these codes.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |  105 +++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 71 insertions(+), 34 deletions(-)

diff -puN mm/slab.c~mm-slab-clean-up-cache-type-determination mm/slab.c
--- a/mm/slab.c~mm-slab-clean-up-cache-type-determination
+++ a/mm/slab.c
@@ -2023,6 +2023,64 @@ __kmem_cache_alias(const char *name, siz
 	return cachep;
 }
 
+static bool set_off_slab_cache(struct kmem_cache *cachep,
+			size_t size, unsigned long flags)
+{
+	size_t left;
+
+	cachep->num = 0;
+
+	/*
+	 * Determine if the slab management is 'on' or 'off' slab.
+	 * (bootstrapping cannot cope with offslab caches so don't do
+	 * it too early on. Always use on-slab management when
+	 * SLAB_NOLEAKTRACE to avoid recursive calls into kmemleak)
+	 */
+	if (size < OFF_SLAB_MIN_SIZE)
+		return false;
+
+	if (slab_early_init)
+		return false;
+
+	if (flags & SLAB_NOLEAKTRACE)
+		return false;
+
+	/*
+	 * Size is large, assume best to place the slab management obj
+	 * off-slab (should allow better packing of objs).
+	 */
+	left = calculate_slab_order(cachep, size, flags | CFLGS_OFF_SLAB);
+	if (!cachep->num)
+		return false;
+
+	/*
+	 * If the slab has been placed off-slab, and we have enough space then
+	 * move it on-slab. This is at the expense of any extra colouring.
+	 */
+	if (left >= cachep->num * sizeof(freelist_idx_t))
+		return false;
+
+	cachep->colour = left / cachep->colour_off;
+
+	return true;
+}
+
+static bool set_on_slab_cache(struct kmem_cache *cachep,
+			size_t size, unsigned long flags)
+{
+	size_t left;
+
+	cachep->num = 0;
+
+	left = calculate_slab_order(cachep, size, flags);
+	if (!cachep->num)
+		return false;
+
+	cachep->colour = left / cachep->colour_off;
+
+	return true;
+}
+
 /**
  * __kmem_cache_create - Create a cache.
  * @cachep: cache management descriptor
@@ -2047,7 +2105,6 @@ __kmem_cache_alias(const char *name, siz
 int
 __kmem_cache_create (struct kmem_cache *cachep, unsigned long flags)
 {
-	size_t left_over, freelist_size;
 	size_t ralign = BYTES_PER_WORD;
 	gfp_t gfp;
 	int err;
@@ -2098,6 +2155,10 @@ __kmem_cache_create (struct kmem_cache *
 	 * 4) Store it.
 	 */
 	cachep->align = ralign;
+	cachep->colour_off = cache_line_size();
+	/* Offset must be a multiple of the alignment. */
+	if (cachep->colour_off < cachep->align)
+		cachep->colour_off = cachep->align;
 
 	if (slab_is_available())
 		gfp = GFP_KERNEL;
@@ -2152,43 +2213,18 @@ __kmem_cache_create (struct kmem_cache *
 	}
 #endif
 
-	/*
-	 * Determine if the slab management is 'on' or 'off' slab.
-	 * (bootstrapping cannot cope with offslab caches so don't do
-	 * it too early on. Always use on-slab management when
-	 * SLAB_NOLEAKTRACE to avoid recursive calls into kmemleak)
-	 */
-	if (size >= OFF_SLAB_MIN_SIZE && !slab_early_init &&
-	    !(flags & SLAB_NOLEAKTRACE)) {
-		/*
-		 * Size is large, assume best to place the slab management obj
-		 * off-slab (should allow better packing of objs).
-		 */
+	if (set_off_slab_cache(cachep, size, flags)) {
 		flags |= CFLGS_OFF_SLAB;
+		goto done;
 	}
 
-	left_over = calculate_slab_order(cachep, size, flags);
-
-	if (!cachep->num)
-		return -E2BIG;
+	if (set_on_slab_cache(cachep, size, flags))
+		goto done;
 
-	freelist_size = cachep->num * sizeof(freelist_idx_t);
-
-	/*
-	 * If the slab has been placed off-slab, and we have enough space then
-	 * move it on-slab. This is at the expense of any extra colouring.
-	 */
-	if (flags & CFLGS_OFF_SLAB && left_over >= freelist_size) {
-		flags &= ~CFLGS_OFF_SLAB;
-		left_over -= freelist_size;
-	}
+	return -E2BIG;
 
-	cachep->colour_off = cache_line_size();
-	/* Offset must be a multiple of the alignment. */
-	if (cachep->colour_off < cachep->align)
-		cachep->colour_off = cachep->align;
-	cachep->colour = left_over / cachep->colour_off;
-	cachep->freelist_size = freelist_size;
+done:
+	cachep->freelist_size = cachep->num * sizeof(freelist_idx_t);
 	cachep->flags = flags;
 	cachep->allocflags = __GFP_COMP;
 	if (CONFIG_ZONE_DMA_FLAG && (flags & SLAB_CACHE_DMA))
@@ -2209,7 +2245,8 @@ __kmem_cache_create (struct kmem_cache *
 #endif
 
 	if (OFF_SLAB(cachep)) {
-		cachep->freelist_cache = kmalloc_slab(freelist_size, 0u);
+		cachep->freelist_cache =
+			kmalloc_slab(cachep->freelist_size, 0u);
 		/*
 		 * This is a possibility for one of the kmalloc_{dma,}_caches.
 		 * But since we go off slab only for object size greater than
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

