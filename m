From: akpm@linux-foundation.org
Subject: +
 mm-slab-align-cache-size-first-before-determination-of-off_slab-candidate.patch added to -mm tree
Date: Tue, 26 Jan 2016 21:30:28 -0800
Message-ID: <56a855f4.SEiy2Tr8tTTBzuOI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36841 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbcA0Faa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jan 2016 00:30:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, brouer@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: align cache size first before determination of OFF_SLAB candidate
has been added to the -mm tree.  Its filename is
     mm-slab-align-cache-size-first-before-determination-of-off_slab-candidate.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-align-cache-size-first-before-determination-of-off_slab-candidate.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-align-cache-size-first-before-determination-of-off_slab-candidate.patch

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
@@ -2126,6 +2126,17 @@ __kmem_cache_create (struct kmem_cache *
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
@@ -2136,8 +2147,8 @@ __kmem_cache_create (struct kmem_cache *
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
@@ -2149,20 +2160,13 @@ __kmem_cache_create (struct kmem_cache *
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

