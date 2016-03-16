From: akpm@linux-foundation.org
Subject: [merged]
 mm-slab-align-cache-size-first-before-determination-of-off_slab-candidate.patch removed from -mm tree
Date: Wed, 16 Mar 2016 12:54:32 -0700
Message-ID: <56e9b9f8.XgeUC/pEqXg6O8CO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38545 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560AbcCPTyd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:54:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, brouer@redhat.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: align cache size first before determination of OFF_SLAB candidate
has been removed from the -mm tree.  Its filename was
     mm-slab-align-cache-size-first-before-determination-of-off_slab-candidate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slab: align cache size first before determination of OFF_SLAB candidate

Finding suitable OFF_SLAB candidate is more related to aligned cache size
rather than original size.  Same reasoning can be applied to the debug
pagealloc candidate.  So, this patch moves up alignment fixup to proper
position.  From that point, size is aligned so we can remove some
alignment fixups.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff -puN mm/slab.c~mm-slab-align-cache-size-first-before-determination-of-off_slab-candidate mm/slab.c
--- a/mm/slab.c~mm-slab-align-cache-size-first-before-determination-of-off_slab-candidate
+++ a/mm/slab.c
@@ -2125,6 +2125,17 @@ __kmem_cache_create (struct kmem_cache *
 		else
 			size += BYTES_PER_WORD;
 	}
+#endif
+
+	size = ALIGN(size, cachep->align);
+	/*
+	 * We should restrict the number of objects in a slab to implement
+	 * byte sized index. Refer comment on SLAB_OBJ_MIN_SIZE definition.
+	 */
+	if (FREELIST_BYTE_INDEX && size < SLAB_OBJ_MIN_SIZE)
+		size = ALIGN(SLAB_OBJ_MIN_SIZE, cachep->align);
+
+#if DEBUG
 	/*
 	 * To activate debug pagealloc, off-slab management is necessary
 	 * requirement. In early phase of initialization, small sized slab
@@ -2135,8 +2146,8 @@ __kmem_cache_create (struct kmem_cache *
 	if (debug_pagealloc_enabled() && (flags & SLAB_POISON) &&
 		!slab_early_init && size >= kmalloc_size(INDEX_NODE) &&
 		size >= 256 && cachep->object_size > cache_line_size() &&
-		ALIGN(size, cachep->align) < PAGE_SIZE) {
-		cachep->obj_offset += PAGE_SIZE - ALIGN(size, cachep->align);
+		size < PAGE_SIZE) {
+		cachep->obj_offset += PAGE_SIZE - size;
 		size = PAGE_SIZE;
 	}
 #endif
@@ -2148,20 +2159,13 @@ __kmem_cache_create (struct kmem_cache *
 	 * SLAB_NOLEAKTRACE to avoid recursive calls into kmemleak)
 	 */
 	if (size >= OFF_SLAB_MIN_SIZE && !slab_early_init &&
-	    !(flags & SLAB_NOLEAKTRACE))
+	    !(flags & SLAB_NOLEAKTRACE)) {
 		/*
 		 * Size is large, assume best to place the slab management obj
 		 * off-slab (should allow better packing of objs).
 		 */
 		flags |= CFLGS_OFF_SLAB;
-
-	size = ALIGN(size, cachep->align);
-	/*
-	 * We should restrict the number of objects in a slab to implement
-	 * byte sized index. Refer comment on SLAB_OBJ_MIN_SIZE definition.
-	 */
-	if (FREELIST_BYTE_INDEX && size < SLAB_OBJ_MIN_SIZE)
-		size = ALIGN(SLAB_OBJ_MIN_SIZE, cachep->align);
+	}
 
 	left_over = calculate_slab_order(cachep, size, flags);
 
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

