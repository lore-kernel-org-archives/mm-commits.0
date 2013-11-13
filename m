From: akpm@linux-foundation.org
Subject: [merged]
 mm-kmemleak-avoid-false-negatives-on-vmalloced-objects.patch removed from
 -mm tree
Date: Wed, 13 Nov 2013 12:38:38 -0800
Message-ID: <5283e34e.xE356C1xLjAIHQYB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42630 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab3KMUij (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:38:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, catalin.marinas@arm.com

Subject: [merged] mm-kmemleak-avoid-false-negatives-on-vmalloced-objects.patch removed from -mm tree
To: catalin.marinas@arm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:38:38 -0800


The patch titled
     Subject: mm: kmemleak: avoid false negatives on vmalloc'ed objects
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-avoid-false-negatives-on-vmalloced-objects.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: mm: kmemleak: avoid false negatives on vmalloc'ed objects

Commit 248ac0e1 ("mm/vmalloc: remove guard page from between vmap blocks")
had the side effect of making vmap_area.va_end member point to the next
vmap_area.va_start.  This was creating an artificial reference to
vmalloc'ed objects and kmemleak was rarely reporting vmalloc() leaks.

This patch marks the vmap_area containing pointers explicitly and reduces
the min ref_count to 2 as vm_struct still contains a reference to the
vmalloc'ed object.  The kmemleak add_scan_area() function has been
improved to allow a SIZE_MAX argument covering the rest of the object (for
simpler calling sites).

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    4 +++-
 mm/vmalloc.c  |   14 ++++++++++----
 2 files changed, 13 insertions(+), 5 deletions(-)

diff -puN mm/kmemleak.c~mm-kmemleak-avoid-false-negatives-on-vmalloced-objects mm/kmemleak.c
--- a/mm/kmemleak.c~mm-kmemleak-avoid-false-negatives-on-vmalloced-objects
+++ a/mm/kmemleak.c
@@ -753,7 +753,9 @@ static void add_scan_area(unsigned long
 	}
 
 	spin_lock_irqsave(&object->lock, flags);
-	if (ptr + size > object->pointer + object->size) {
+	if (size == SIZE_MAX) {
+		size = object->pointer + object->size - ptr;
+	} else if (ptr + size > object->pointer + object->size) {
 		kmemleak_warn("Scan area larger than object 0x%08lx\n", ptr);
 		dump_object_info(object);
 		kmem_cache_free(scan_area_cache, area);
diff -puN mm/vmalloc.c~mm-kmemleak-avoid-false-negatives-on-vmalloced-objects mm/vmalloc.c
--- a/mm/vmalloc.c~mm-kmemleak-avoid-false-negatives-on-vmalloced-objects
+++ a/mm/vmalloc.c
@@ -359,6 +359,12 @@ static struct vmap_area *alloc_vmap_area
 	if (unlikely(!va))
 		return ERR_PTR(-ENOMEM);
 
+	/*
+	 * Only scan the relevant parts containing pointers to other objects
+	 * to avoid false negatives.
+	 */
+	kmemleak_scan_area(&va->rb_node, SIZE_MAX, gfp_mask & GFP_RECLAIM_MASK);
+
 retry:
 	spin_lock(&vmap_area_lock);
 	/*
@@ -1645,11 +1651,11 @@ void *__vmalloc_node_range(unsigned long
 	clear_vm_uninitialized_flag(area);
 
 	/*
-	 * A ref_count = 3 is needed because the vm_struct and vmap_area
-	 * structures allocated in the __get_vm_area_node() function contain
-	 * references to the virtual address of the vmalloc'ed block.
+	 * A ref_count = 2 is needed because vm_struct allocated in
+	 * __get_vm_area_node() contains a reference to the virtual address of
+	 * the vmalloc'ed block.
 	 */
-	kmemleak_alloc(addr, real_size, 3, gfp_mask);
+	kmemleak_alloc(addr, real_size, 2, gfp_mask);
 
 	return addr;
 
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

origin.patch
linux-next.patch
x86-add-missed-pgtable_pmd_page_ctor-dtor-calls-for-preallocated-pmds.patch
arm64-handle-pgtable_page_ctor-fail.patch

