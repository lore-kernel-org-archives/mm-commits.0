From: akpm@linux-foundation.org
Subject: + mm-vmalloc-simplify-merge_or_add_vmap_area-func.patch
 added to -mm tree
Date: Wed, 17 Jun 2020 18:58:47 -0700
Message-ID: <20200618015847.di-Mp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730570AbgFRB6s (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Jun 2020 21:58:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, urezki@gmail.com


The patch titled
     Subject: mm/vmalloc: simplify merge_or_add_vmap_area()
has been added to the -mm tree.  Its filename is
     mm-vmalloc-simplify-merge_or_add_vmap_area-func.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-simplify-merge_or_add_vmap_area-func.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-simplify-merge_or_add_vmap_area-func.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/vmalloc: simplify merge_or_add_vmap_area()

Currently when a VA is deallocated and is about to be placed back to the
tree, it can be either: merged with next/prev neighbors or inserted if not
coalesced.

On those steps the tree can be populated several times.  For example when
both neighbors are merged.  It can be avoided and simplified in fact.

Therefore do it only once when VA points to final merged area, after all
manipulations: merging/removing/inserting.

Link: http://lkml.kernel.org/r/20200527205054.1696-1-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-simplify-merge_or_add_vmap_area-func
+++ a/mm/vmalloc.c
@@ -797,9 +797,6 @@ merge_or_add_vmap_area(struct vmap_area
 		if (sibling->va_start == va->va_end) {
 			sibling->va_start = va->va_start;
 
-			/* Check and update the tree if needed. */
-			augment_tree_propagate_from(sibling);
-
 			/* Free vmap_area object. */
 			kmem_cache_free(vmap_area_cachep, va);
 
@@ -819,14 +816,18 @@ merge_or_add_vmap_area(struct vmap_area
 	if (next->prev != head) {
 		sibling = list_entry(next->prev, struct vmap_area, list);
 		if (sibling->va_end == va->va_start) {
-			sibling->va_end = va->va_end;
-
-			/* Check and update the tree if needed. */
-			augment_tree_propagate_from(sibling);
-
+			/*
+			 * If both neighbors are coalesced, it is important
+			 * to unlink the "next" node first, followed by merging
+			 * with "previous" one. Otherwise the tree might not be
+			 * fully populated if a sibling's augmented value is
+			 * "normalized" because of rotation operations.
+			 */
 			if (merged)
 				unlink_va(va, root);
 
+			sibling->va_end = va->va_end;
+
 			/* Free vmap_area object. */
 			kmem_cache_free(vmap_area_cachep, va);
 
@@ -837,11 +838,13 @@ merge_or_add_vmap_area(struct vmap_area
 	}
 
 insert:
-	if (!merged) {
+	if (!merged)
 		link_va(va, root, parent, link, head);
-		augment_tree_propagate_from(va);
-	}
 
+	/*
+	 * Last step is to check and update the tree.
+	 */
+	augment_tree_propagate_from(va);
 	return va;
 }
 
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-simplify-merge_or_add_vmap_area-func.patch
mm-vmalloc-simplify-augment_tree_propagate_check-func.patch
mm-vmalloc-switch-to-propagate-callback.patch
