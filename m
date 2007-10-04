From: akpm@linux-foundation.org
Subject: + fix-sys_remap_file_pages-bug-at-highmemc15.patch added to -mm tree
Date: Thu, 04 Oct 2007 11:46:25 -0700
Message-ID: <200710041846.l94IkPkj023667@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37731 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755347AbXJDSsR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2007 14:48:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, gurudas.pai@oracle.com, nickpiggin@yahoo.com.au


The patch titled
     fix sys_remap_file_pages BUG at highmem.c:15!
has been added to the -mm tree.  Its filename is
     fix-sys_remap_file_pages-bug-at-highmemc15.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix sys_remap_file_pages BUG at highmem.c:15!
From: Hugh Dickins <hugh@veritas.com>

Gurudas Pai reports kernel BUG at arch/i386/mm/highmem.c:15!  below
sys_remap_file_pages, while running Oracle database test on x86 in 6GB RAM:
kunmap thinks we're in_interrupt because the preempt count has wrapped.

That's because __do_fault expected to unmap page_table, but one of its two
callers do_nonlinear_fault already unmapped it: let do_linear_fault unmap
it first too, and then there's no need to pass the page_table arg down.

Why have we been so slow to notice this?  Probably through forgetting that
the mapping_cap_account_dirty test means that sys_remap_file_pages nowadays
only goes the full nonlinear vma route on a few memory-backed filesystems
like ramfs, tmpfs and hugetlbfs.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: gurudas pai <gurudas.pai@oracle.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN mm/memory.c~fix-sys_remap_file_pages-bug-at-highmemc15 mm/memory.c
--- a/mm/memory.c~fix-sys_remap_file_pages-bug-at-highmemc15
+++ a/mm/memory.c
@@ -2307,13 +2307,14 @@ oom:
  * do not need to flush old virtual caches or the TLB.
  *
  * We enter with non-exclusive mmap_sem (to exclude vma changes,
- * but allow concurrent faults), and pte mapped but not yet locked.
+ * but allow concurrent faults), and pte neither mapped nor locked.
  * We return with mmap_sem still held, but pte unmapped and unlocked.
  */
 static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
-		unsigned long address, pte_t *page_table, pmd_t *pmd,
+		unsigned long address, pmd_t *pmd,
 		pgoff_t pgoff, unsigned int flags, pte_t orig_pte)
 {
+	pte_t *page_table;
 	spinlock_t *ptl;
 	struct page *page;
 	pte_t entry;
@@ -2327,7 +2328,6 @@ static int __do_fault(struct mm_struct *
 	vmf.flags = flags;
 	vmf.page = NULL;
 
-	pte_unmap(page_table);
 	BUG_ON(vma->vm_flags & VM_PFNMAP);
 
 	if (likely(vma->vm_ops->fault)) {
@@ -2468,8 +2468,8 @@ static int do_linear_fault(struct mm_str
 			- vma->vm_start) >> PAGE_CACHE_SHIFT) + vma->vm_pgoff;
 	unsigned int flags = (write_access ? FAULT_FLAG_WRITE : 0);
 
-	return __do_fault(mm, vma, address, page_table, pmd, pgoff,
-							flags, orig_pte);
+	pte_unmap(page_table);
+	return __do_fault(mm, vma, address, pmd, pgoff, flags, orig_pte);
 }
 
 
@@ -2552,9 +2552,7 @@ static int do_nonlinear_fault(struct mm_
 	}
 
 	pgoff = pte_to_pgoff(orig_pte);
-
-	return __do_fault(mm, vma, address, page_table, pmd, pgoff,
-							flags, orig_pte);
+	return __do_fault(mm, vma, address, pmd, pgoff, flags, orig_pte);
 }
 
 /*
_

Patches currently in -mm which might be from hugh@veritas.com are

fix-sys_remap_file_pages-bug-at-highmemc15.patch
git-libata-all.patch
pa-risc-use-page-allocator-instead-of-slab-allocator.patch
mm-clarify-__add_to_swap_cache-locking.patch
mm-clarify-__add_to_swap_cache-locking-fix.patch
radix-tree-use-indirect-bit.patch
use-vm_read-write-exec-to-set-vm_page_prot.patch
mm-use-pagevec-to-rotate-reclaimable-page-fix-2.patch
mm-use-pagevec-to-rotate-reclaimable-page-fix-bug-at-include-linux-mmh220.patch
mm-use-pagevec-to-rotate-reclaimable-page-kill-redundancy-in-rotate_reclaimable_page.patch
mm-use-pagevec-to-rotate-reclaimable-page-move_tail_pages-into-lru_add_drain.patch
introduce-write_begin-write_end-aops-important-fix.patch
reiserfs-convert-to-new-aops-fix.patch
hostfs-convert-to-new-aops-fix.patch
affs-convert-to-new-aops-fix.patch
flush-cache-before-installing-new-page-at-migraton.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix-update.patch
maps-pssproportional-set-size-accounting-in-smaps.patch
mm-shmemc-make-3-functions-static.patch
lib-percpu_counter_sub.patch
mm-per-device-dirty-threshold-fix.patch
ext2-reservations.patch
fix-for-ext2-reservation.patch
ext2-balloc-use-io_error-label.patch
memory-controller-memory-accounting-v7-fix-swapoff-breakage-however.patch
exportfs-add-fid-type.patch
exportfs-add-new-methods.patch
shmem-new-export-ops.patch
exportfs-remove-old-methods.patch
exportfs-make-struct-export_operations-const.patch
exportfs-update-documentation.patch
prio_tree-debugging-patch.patch
