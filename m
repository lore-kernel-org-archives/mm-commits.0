From: akpm@linux-foundation.org
Subject: + mm-rmap-remove-vma_address-check-for-address-inside-vma.patch added to -mm tree
Date: Fri, 07 Sep 2012 15:16:26 -0700
Message-ID: <20120907221627.554C410008F@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:63570 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab2IGWQ2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Sep 2012 18:16:28 -0400
Received: by yenq6 with SMTP id q6so12232yen.1
        for <mm-commits@vger.kernel.org>; Fri, 07 Sep 2012 15:16:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, a.p.zijlstra@chello.nl, aarcange@redhat.com, daniel.santos@pobox.com, hughd@google.com, riel@redhat.com


The patch titled
     Subject: mm rmap: remove vma_address check for address inside vma
has been added to the -mm tree.  Its filename is
     mm-rmap-remove-vma_address-check-for-address-inside-vma.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mm rmap: remove vma_address check for address inside vma

In file and anon rmap, we use interval trees to find potentially relevant
vmas and then call vma_address() to find the virtual address the given
page might be found at in these vmas.  vma_address() used to include a
check that the returned address falls within the limits of the vma, but
this check isn't necessary now that we always use interval trees in rmap:
the interval tree just doesn't return any vmas which this check would find
to be irrelevant.  As a result, we can replace the use of -EFAULT error
code (which then needed to be checked in every call site) with a
VM_BUG_ON().

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Daniel Santos <daniel.santos@pobox.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ---
 mm/rmap.c        |   48 +++++++++++++++++++--------------------------
 2 files changed, 21 insertions(+), 31 deletions(-)

diff -puN mm/huge_memory.c~mm-rmap-remove-vma_address-check-for-address-inside-vma mm/huge_memory.c
--- a/mm/huge_memory.c~mm-rmap-remove-vma_address-check-for-address-inside-vma
+++ a/mm/huge_memory.c
@@ -1386,8 +1386,6 @@ static void __split_huge_page(struct pag
 		struct vm_area_struct *vma = avc->vma;
 		unsigned long addr = vma_address(page, vma);
 		BUG_ON(is_vma_temporary_stack(vma));
-		if (addr == -EFAULT)
-			continue;
 		mapcount += __split_huge_page_splitting(page, vma, addr);
 	}
 	/*
@@ -1412,8 +1410,6 @@ static void __split_huge_page(struct pag
 		struct vm_area_struct *vma = avc->vma;
 		unsigned long addr = vma_address(page, vma);
 		BUG_ON(is_vma_temporary_stack(vma));
-		if (addr == -EFAULT)
-			continue;
 		mapcount2 += __split_huge_page_map(page, vma, addr);
 	}
 	if (mapcount != mapcount2)
diff -puN mm/rmap.c~mm-rmap-remove-vma_address-check-for-address-inside-vma mm/rmap.c
--- a/mm/rmap.c~mm-rmap-remove-vma_address-check-for-address-inside-vma
+++ a/mm/rmap.c
@@ -510,22 +510,26 @@ void page_unlock_anon_vma(struct anon_vm
 
 /*
  * At what user virtual address is page expected in @vma?
- * Returns virtual address or -EFAULT if page's index/offset is not
- * within the range mapped the @vma.
  */
-inline unsigned long
-vma_address(struct page *page, struct vm_area_struct *vma)
+static inline unsigned long
+__vma_address(struct page *page, struct vm_area_struct *vma)
 {
 	pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
-	unsigned long address;
 
 	if (unlikely(is_vm_hugetlb_page(vma)))
 		pgoff = page->index << huge_page_order(page_hstate(page));
-	address = vma->vm_start + ((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
-	if (unlikely(address < vma->vm_start || address >= vma->vm_end)) {
-		/* page should be within @vma mapping range */
-		return -EFAULT;
-	}
+
+	return vma->vm_start + ((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
+}
+
+inline unsigned long
+vma_address(struct page *page, struct vm_area_struct *vma)
+{
+	unsigned long address = __vma_address(page, vma);
+
+	/* page should be within @vma mapping range */
+	VM_BUG_ON(address < vma->vm_start || address >= vma->vm_end);
+
 	return address;
 }
 
@@ -535,6 +539,7 @@ vma_address(struct page *page, struct vm
  */
 unsigned long page_address_in_vma(struct page *page, struct vm_area_struct *vma)
 {
+	unsigned long address;
 	if (PageAnon(page)) {
 		struct anon_vma *page__anon_vma = page_anon_vma(page);
 		/*
@@ -550,7 +555,10 @@ unsigned long page_address_in_vma(struct
 			return -EFAULT;
 	} else
 		return -EFAULT;
-	return vma_address(page, vma);
+	address = __vma_address(page, vma);
+	if (unlikely(address < vma->vm_start || address >= vma->vm_end))
+		return -EFAULT;
+	return address;
 }
 
 /*
@@ -624,8 +632,8 @@ int page_mapped_in_vma(struct page *page
 	pte_t *pte;
 	spinlock_t *ptl;
 
-	address = vma_address(page, vma);
-	if (address == -EFAULT)		/* out of vma range */
+	address = __vma_address(page, vma);
+	if (unlikely(address < vma->vm_start || address >= vma->vm_end))
 		return 0;
 	pte = page_check_address(page, vma->vm_mm, address, &ptl, 1);
 	if (!pte)			/* the page is not in this mm */
@@ -732,8 +740,6 @@ static int page_referenced_anon(struct p
 	anon_vma_interval_tree_foreach(avc, &anon_vma->rb_root, pgoff, pgoff) {
 		struct vm_area_struct *vma = avc->vma;
 		unsigned long address = vma_address(page, vma);
-		if (address == -EFAULT)
-			continue;
 		/*
 		 * If we are reclaiming on behalf of a cgroup, skip
 		 * counting on behalf of references from different
@@ -799,8 +805,6 @@ static int page_referenced_file(struct p
 
 	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
 		unsigned long address = vma_address(page, vma);
-		if (address == -EFAULT)
-			continue;
 		/*
 		 * If we are reclaiming on behalf of a cgroup, skip
 		 * counting on behalf of references from different
@@ -904,8 +908,6 @@ static int page_mkclean_file(struct addr
 	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
 		if (vma->vm_flags & VM_SHARED) {
 			unsigned long address = vma_address(page, vma);
-			if (address == -EFAULT)
-				continue;
 			ret += page_mkclean_one(page, vma, address);
 		}
 	}
@@ -1468,8 +1470,6 @@ static int try_to_unmap_anon(struct page
 			continue;
 
 		address = vma_address(page, vma);
-		if (address == -EFAULT)
-			continue;
 		ret = try_to_unmap_one(page, vma, address, flags);
 		if (ret != SWAP_AGAIN || !page_mapped(page))
 			break;
@@ -1508,8 +1508,6 @@ static int try_to_unmap_file(struct page
 	mutex_lock(&mapping->i_mmap_mutex);
 	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
 		unsigned long address = vma_address(page, vma);
-		if (address == -EFAULT)
-			continue;
 		ret = try_to_unmap_one(page, vma, address, flags);
 		if (ret != SWAP_AGAIN || !page_mapped(page))
 			goto out;
@@ -1684,8 +1682,6 @@ static int rmap_walk_anon(struct page *p
 	anon_vma_interval_tree_foreach(avc, &anon_vma->rb_root, pgoff, pgoff) {
 		struct vm_area_struct *vma = avc->vma;
 		unsigned long address = vma_address(page, vma);
-		if (address == -EFAULT)
-			continue;
 		ret = rmap_one(page, vma, address, arg);
 		if (ret != SWAP_AGAIN)
 			break;
@@ -1707,8 +1703,6 @@ static int rmap_walk_file(struct page *p
 	mutex_lock(&mapping->i_mmap_mutex);
 	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
 		unsigned long address = vma_address(page, vma);
-		if (address == -EFAULT)
-			continue;
 		ret = rmap_one(page, vma, address, arg);
 		if (ret != SWAP_AGAIN)
 			break;
_

Patches currently in -mm which might be from walken@google.com are

linux-next.patch
mm-adjust-final-endif-position-in-mm-internalh.patch
mm-fix-potential-anon_vma-locking-issue-in-mprotect.patch
ipc-mqueue-remove-unnecessary-rb_init_node-calls.patch
rbtree-reference-documentation-rbtreetxt-for-usage-instructions.patch
rbtree-empty-nodes-have-no-color.patch
rbtree-empty-nodes-have-no-color-fix.patch
rbtree-fix-incorrect-rbtree-node-insertion-in-fs-proc-proc_sysctlc.patch
rbtree-move-some-implementation-details-from-rbtreeh-to-rbtreec.patch
rbtree-move-some-implementation-details-from-rbtreeh-to-rbtreec-fix.patch
rbtree-performance-and-correctness-test.patch
rbtree-performance-and-correctness-test-fix.patch
rbtree-break-out-of-rb_insert_color-loop-after-tree-rotation.patch
rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary.patch
rbtree-low-level-optimizations-in-rb_insert_color.patch
rbtree-adjust-node-color-in-__rb_erase_color-only-when-necessary.patch
rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary-fix.patch
rbtree-optimize-case-selection-logic-in-__rb_erase_color.patch
rbtree-low-level-optimizations-in-__rb_erase_color.patch
rbtree-coding-style-adjustments.patch
rbtree-optimize-fetching-of-sibling-node.patch
rbtree-test-fix-sparse-warning-about-64-bit-constant.patch
rbtree-add-__rb_change_child-helper-function.patch
rbtree-place-easiest-case-first-in-rb_erase.patch
rbtree-handle-1-child-recoloring-in-rb_erase-instead-of-rb_erase_color.patch
rbtree-low-level-optimizations-in-rb_erase.patch
rbtree-augmented-rbtree-test.patch
rbtree-faster-augmented-rbtree-manipulation.patch
rbtree-remove-prior-augmented-rbtree-implementation.patch
rbtree-add-rb_declare_callbacks-macro.patch
rbtree-add-prio-tree-and-interval-tree-tests.patch
mm-replace-vma-prio_tree-with-an-interval-tree.patch
kmemleak-use-rbtree-instead-of-prio-tree.patch
prio_tree-remove.patch
rbtree-move-augmented-rbtree-functionality-to-rbtree_augmentedh.patch
mm-interval-tree-updates.patch
mm-anon-rmap-remove-anon_vma_moveto_tail.patch
mm-anon-rmap-replace-same_anon_vma-linked-list-with-an-interval-tree.patch
mm-rmap-remove-vma_address-check-for-address-inside-vma.patch
mm-add-config_debug_vm_rb-build-option.patch
mm-avoid-taking-rmap-locks-in-move_ptes.patch

