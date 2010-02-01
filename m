From: akpm@linux-foundation.org
Subject: + mm-remove-vm_lock_rmap-code.patch added to -mm tree
Date: Mon, 01 Feb 2010 12:32:44 -0800
Message-ID: <201002012032.o11KWiPs010695@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51589 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754821Ab0BAUdm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2010 15:33:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com, Lee.Schermerhorn@hp.com, aarcange@redhat.com, kosaki.motohiro@jp.fujitsu.com, lwoodman@redhat.com, npiggin@suse.de


The patch titled
     mm: remove VM_LOCK_RMAP code
has been added to the -mm tree.  Its filename is
     mm-remove-vm_lock_rmap-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -96,11 +96,7 @@ extern unsigned int kobjsize(const void 
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

mm-introduce-dump_page-and-print-symbolic-flag-names.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
mlock_vma_pages_range-never-return-negative-value.patch
mlock_vma_pages_range-only-return-success-or-failure.patch
vmscan-check-high-watermark-after-shrink-zone.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
vmscan-get_scan_ratio-cleanup.patch
mm-page_allocc-remove-duplicate-call-to-trace_mm_page_free_direct.patch
mm-page_allocc-adjust-a-call-site-to-trace_mm_page_free_direct.patch
mm-remove-function-free_hot_page.patch
mm-remove-function-free_hot_page-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix-2.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-fix.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-further-cleanups.patch
rmap-remove-obsolete-check-from-__page_check_anon_rmap.patch
rmap-move-exclusively-owned-pages-to-own-anon_vma-in-do_wp_page.patch
mm-remove-vm_lock_rmap-code.patch

