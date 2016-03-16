From: akpm@linux-foundation.org
Subject: [merged] mm-slab-put-the-freelist-at-the-end-of-slab-page.patch
 removed from -mm tree
Date: Wed, 16 Mar 2016 12:54:29 -0700
Message-ID: <56e9b9f5.WoQ4j3x5bhqH9N4W%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38539 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560AbcCPTya (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:54:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, brouer@redhat.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: put the freelist at the end of slab page
has been removed from the -mm tree.  Its filename was
     mm-slab-put-the-freelist-at-the-end-of-slab-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slab: put the freelist at the end of slab page

Currently, the freelist is at the front of slab page.  This requires extra
space to meet object alignment requirement.  If we put the freelist at the
end of slab page, object could start at page boundary and will be at
correct alignment.  This is possible because freelist has no alignment
constraint itself.

This gives us two benefits.  It removes extra memory space for the
freelist alignment and remove complex calculation at cache initialization
step.  I can't think notable drawback here.

I mentioned that this would reduce extra memory space, but, this benefit
is rather theoretical because it can be applied to very few cases. 
Following is the example cache type that can get benefit from this change.

size align num before after
32 8 124 4100 4092
64 8 63 4103 4095
88 8 46 4102 4094
272 8 15 4103 4095
408 8 10 4098 4090
32 16 124 4108 4092
64 16 63 4111 4095
32 32 124 4124 4092
64 32 63 4127 4095
96 32 42 4106 4074

before means whole size for objects and aligned freelist before applying
patch and after shows the result of this patch.

Since before is more than 4096, number of object should decrease and
memory waste happens.

Anyway, this patch removes complex calculation so looks beneficial to me.

[akpm@linux-foundation.org: fix kerneldoc]
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   90 ++++++++++++----------------------------------------
 1 file changed, 22 insertions(+), 68 deletions(-)

diff -puN mm/slab.c~mm-slab-put-the-freelist-at-the-end-of-slab-page mm/slab.c
--- a/mm/slab.c~mm-slab-put-the-freelist-at-the-end-of-slab-page
+++ a/mm/slab.c
@@ -456,55 +456,12 @@ static inline struct array_cache *cpu_ca
 	return this_cpu_ptr(cachep->cpu_cache);
 }
 
-static size_t calculate_freelist_size(int nr_objs, size_t align)
-{
-	size_t freelist_size;
-
-	freelist_size = nr_objs * sizeof(freelist_idx_t);
-	if (align)
-		freelist_size = ALIGN(freelist_size, align);
-
-	return freelist_size;
-}
-
-static int calculate_nr_objs(size_t slab_size, size_t buffer_size,
-				size_t idx_size, size_t align)
-{
-	int nr_objs;
-	size_t remained_size;
-	size_t freelist_size;
-
-	/*
-	 * Ignore padding for the initial guess. The padding
-	 * is at most @align-1 bytes, and @buffer_size is at
-	 * least @align. In the worst case, this result will
-	 * be one greater than the number of objects that fit
-	 * into the memory allocation when taking the padding
-	 * into account.
-	 */
-	nr_objs = slab_size / (buffer_size + idx_size);
-
-	/*
-	 * This calculated number will be either the right
-	 * amount, or one greater than what we want.
-	 */
-	remained_size = slab_size - nr_objs * buffer_size;
-	freelist_size = calculate_freelist_size(nr_objs, align);
-	if (remained_size < freelist_size)
-		nr_objs--;
-
-	return nr_objs;
-}
-
 /*
  * Calculate the number of objects and left-over bytes for a given buffer size.
  */
 static void cache_estimate(unsigned long gfporder, size_t buffer_size,
-			   size_t align, int flags, size_t *left_over,
-			   unsigned int *num)
+		unsigned long flags, size_t *left_over, unsigned int *num)
 {
-	int nr_objs;
-	size_t mgmt_size;
 	size_t slab_size = PAGE_SIZE << gfporder;
 
 	/*
@@ -512,9 +469,12 @@ static void cache_estimate(unsigned long
 	 * on it. For the latter case, the memory allocated for a
 	 * slab is used for:
 	 *
-	 * - One freelist_idx_t for each object
-	 * - Padding to respect alignment of @align
 	 * - @buffer_size bytes for each object
+	 * - One freelist_idx_t for each object
+	 *
+	 * We don't need to consider alignment of freelist because
+	 * freelist will be at the end of slab page. The objects will be
+	 * at the correct alignment.
 	 *
 	 * If the slab management structure is off the slab, then the
 	 * alignment will already be calculated into the size. Because
@@ -522,16 +482,13 @@ static void cache_estimate(unsigned long
 	 * correct alignment when allocated.
 	 */
 	if (flags & CFLGS_OFF_SLAB) {
-		mgmt_size = 0;
-		nr_objs = slab_size / buffer_size;
-
+		*num = slab_size / buffer_size;
+		*left_over = slab_size % buffer_size;
 	} else {
-		nr_objs = calculate_nr_objs(slab_size, buffer_size,
-					sizeof(freelist_idx_t), align);
-		mgmt_size = calculate_freelist_size(nr_objs, align);
+		*num = slab_size / (buffer_size + sizeof(freelist_idx_t));
+		*left_over = slab_size %
+			(buffer_size + sizeof(freelist_idx_t));
 	}
-	*num = nr_objs;
-	*left_over = slab_size - nr_objs*buffer_size - mgmt_size;
 }
 
 #if DEBUG
@@ -1911,7 +1868,6 @@ static void slabs_destroy(struct kmem_ca
  * calculate_slab_order - calculate size (page order) of slabs
  * @cachep: pointer to the cache that is being created
  * @size: size of objects to be created in this cache.
- * @align: required alignment for the objects.
  * @flags: slab allocation flags
  *
  * Also calculates the number of objects per slab.
@@ -1921,7 +1877,7 @@ static void slabs_destroy(struct kmem_ca
  * towards high-order requests, this should be changed.
  */
 static size_t calculate_slab_order(struct kmem_cache *cachep,
-			size_t size, size_t align, unsigned long flags)
+				size_t size, unsigned long flags)
 {
 	unsigned long offslab_limit;
 	size_t left_over = 0;
@@ -1931,7 +1887,7 @@ static size_t calculate_slab_order(struc
 		unsigned int num;
 		size_t remainder;
 
-		cache_estimate(gfporder, size, align, flags, &remainder, &num);
+		cache_estimate(gfporder, size, flags, &remainder, &num);
 		if (!num)
 			continue;
 
@@ -2207,12 +2163,12 @@ __kmem_cache_create (struct kmem_cache *
 	if (FREELIST_BYTE_INDEX && size < SLAB_OBJ_MIN_SIZE)
 		size = ALIGN(SLAB_OBJ_MIN_SIZE, cachep->align);
 
-	left_over = calculate_slab_order(cachep, size, cachep->align, flags);
+	left_over = calculate_slab_order(cachep, size, flags);
 
 	if (!cachep->num)
 		return -E2BIG;
 
-	freelist_size = calculate_freelist_size(cachep->num, cachep->align);
+	freelist_size = cachep->num * sizeof(freelist_idx_t);
 
 	/*
 	 * If the slab has been placed off-slab, and we have enough space then
@@ -2223,11 +2179,6 @@ __kmem_cache_create (struct kmem_cache *
 		left_over -= freelist_size;
 	}
 
-	if (flags & CFLGS_OFF_SLAB) {
-		/* really off slab. No need for manual alignment */
-		freelist_size = calculate_freelist_size(cachep->num, 0);
-	}
-
 	cachep->colour_off = cache_line_size();
 	/* Offset must be a multiple of the alignment. */
 	if (cachep->colour_off < cachep->align)
@@ -2443,6 +2394,9 @@ static void *alloc_slabmgmt(struct kmem_
 	void *freelist;
 	void *addr = page_address(page);
 
+	page->s_mem = addr + colour_off;
+	page->active = 0;
+
 	if (OFF_SLAB(cachep)) {
 		/* Slab management obj is off-slab. */
 		freelist = kmem_cache_alloc_node(cachep->freelist_cache,
@@ -2450,11 +2404,11 @@ static void *alloc_slabmgmt(struct kmem_
 		if (!freelist)
 			return NULL;
 	} else {
-		freelist = addr + colour_off;
-		colour_off += cachep->freelist_size;
+		/* We will use last bytes at the slab for freelist */
+		freelist = addr + (PAGE_SIZE << cachep->gfporder) -
+				cachep->freelist_size;
 	}
-	page->active = 0;
-	page->s_mem = addr + colour_off;
+
 	return freelist;
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

