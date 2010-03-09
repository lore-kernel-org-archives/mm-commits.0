From: akpm@linux-foundation.org
Subject: [merged] mm-remove-vm_lock_rmap-code.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:04:16 -0800
Message-ID: <201003091904.o29J4GFK031032@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33440 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755643Ab0CITEx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:04:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, Lee.Schermerhorn@hp.com, aarcange@redhat.com, kosaki.motohiro@jp.fujitsu.com, lwoodman@redhat.com, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm: remove VM_LOCK_RMAP code
has been removed from the -mm tree.  Its filename was
     mm-remove-vm_lock_rmap-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: remove VM_LOCK_RMAP code
From: Rik van Riel <riel@redhat.com>

When a VMA is in an inconsistent state during setup or teardown, the worst
that can happen is that the rmap code will not be able to find the page.

The mapping is in the process of being torn down (PTEs just got
invalidated by munmap), or set up (no PTEs have been instantiated yet).

It is also impossible for the rmap code to follow a pointer to an already
freed VMA, because the rmap code holds the anon_vma->lock, which the VMA
teardown code needs to take before the VMA is removed from the anon_vma
chain.

Hence, we should not need the VM_LOCK_RMAP locking at all.

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    4 ----
 mm/mmap.c          |   15 ---------------
 mm/rmap.c          |   12 ------------
 3 files changed, 31 deletions(-)

diff -puN include/linux/mm.h~mm-remove-vm_lock_rmap-code include/linux/mm.h
--- a/include/linux/mm.h~mm-remove-vm_lock_rmap-code
+++ a/include/linux/mm.h
@@ -97,11 +97,7 @@ extern unsigned int kobjsize(const void 
 #define VM_NORESERVE	0x00200000	/* should the VM suppress accounting */
 #define VM_HUGETLB	0x00400000	/* Huge TLB Page VM */
 #define VM_NONLINEAR	0x00800000	/* Is non-linear (remap_file_pages) */
-#ifdef CONFIG_MMU
-#define VM_LOCK_RMAP	0x01000000	/* Do not follow this rmap (mmu mmap) */
-#else
 #define VM_MAPPED_COPY	0x01000000	/* T if mapped copy of data (nommu mmap) */
-#endif
 #define VM_INSERTPAGE	0x02000000	/* The vma has had "vm_insert_page()" done on it */
 #define VM_ALWAYSDUMP	0x04000000	/* Always include in core dumps */
 
diff -puN mm/mmap.c~mm-remove-vm_lock_rmap-code mm/mmap.c
--- a/mm/mmap.c~mm-remove-vm_lock_rmap-code
+++ a/mm/mmap.c
@@ -554,9 +554,7 @@ again:			remove_next = 1 + (end > next->
 		 */
 		if (importer && !importer->anon_vma) {
 			/* Block reverse map lookups until things are set up. */
-			importer->vm_flags |= VM_LOCK_RMAP;
 			if (anon_vma_clone(importer, vma)) {
-				importer->vm_flags &= ~VM_LOCK_RMAP;
 				return -ENOMEM;
 			}
 			importer->anon_vma = anon_vma;
@@ -618,11 +616,6 @@ again:			remove_next = 1 + (end > next->
 		__vma_unlink(mm, next, vma);
 		if (file)
 			__remove_shared_vm_struct(next, file, mapping);
-		/*
-		 * This VMA is now dead, no need for rmap to follow it.
-		 * Call anon_vma_merge below, outside of i_mmap_lock.
-		 */
-		next->vm_flags |= VM_LOCK_RMAP;
 	} else if (insert) {
 		/*
 		 * split_vma has split insert from vma, and needs
@@ -635,20 +628,12 @@ again:			remove_next = 1 + (end > next->
 	if (mapping)
 		spin_unlock(&mapping->i_mmap_lock);
 
-	/*
-	 * The current VMA has been set up. It is now safe for the
-	 * rmap code to get from the pages to the ptes.
-	 */
-	if (anon_vma && importer)
-		importer->vm_flags &= ~VM_LOCK_RMAP;
-
 	if (remove_next) {
 		if (file) {
 			fput(file);
 			if (next->vm_flags & VM_EXECUTABLE)
 				removed_exe_file_vma(mm);
 		}
-		/* Protected by mmap_sem and VM_LOCK_RMAP. */
 		if (next->anon_vma)
 			anon_vma_merge(vma, next);
 		mm->map_count--;
diff -puN mm/rmap.c~mm-remove-vm_lock_rmap-code mm/rmap.c
--- a/mm/rmap.c~mm-remove-vm_lock_rmap-code
+++ a/mm/rmap.c
@@ -329,18 +329,6 @@ vma_address(struct page *page, struct vm
 		/* page should be within @vma mapping range */
 		return -EFAULT;
 	}
-	if (unlikely(vma->vm_flags & VM_LOCK_RMAP)) {
-		/*
-		 * This VMA is being unlinked or is not yet linked into the
-		 * VMA tree.  Do not try to follow this rmap.  This race
-		 * condition can result in page_referenced() ignoring a
-		 * reference or in try_to_unmap() failing to unmap a page.
-		 * The VMA cannot be freed under us because we hold the
-		 * anon_vma->lock, which the munmap code takes while
-		 * unlinking the anon_vmas from the VMA.
-		 */
-		return -EFAULT;
-	}
 	return address;
 }
 
_

Patches currently in -mm which might be from riel@redhat.com are

fs-buffer_head-remove-kmem_cache-constructor-to-reduce-memory-usage-under-slub.patch
mm-introduce-dump_page-and-print-symbolic-flag-names.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch

