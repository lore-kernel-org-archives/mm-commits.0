From: akpm@linux-foundation.org
Subject: - holepunch-fix-mmap_sem-i_mutex-deadlock.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:37:41 -0700
Message-ID: <200703292337.l2TNbfll015134@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43288 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934401AbXC2XlB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:41:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, mszeredi@suse.cz, npiggin@suse.de, pbadari@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     holepunch: fix mmap_sem i_mutex deadlock
has been removed from the -mm tree.  Its filename was
     holepunch-fix-mmap_sem-i_mutex-deadlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: holepunch: fix mmap_sem i_mutex deadlock
From: Hugh Dickins <hugh@veritas.com>

sys_madvise has down_write of mmap_sem, then madvise_remove calls
vmtruncate_range which takes i_mutex and i_alloc_sem: no, we can easily devise
deadlocks from that ordering.

madvise_remove drop mmap_sem while calling vmtruncate_range: luckily, since
madvise_remove doesn't split or merge vmas, it's easy to handle this case with
a NULL prev, without restructuring sys_madvise.  (Though sad to retake
mmap_sem when it's unlikely to be needed, and certainly down_read is
sufficient for MADV_REMOVE, unlike the other madvices.)

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Miklos Szeredi <mszeredi@suse.cz>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff -puN mm/madvise.c~holepunch-fix-mmap_sem-i_mutex-deadlock mm/madvise.c
--- a/mm/madvise.c~holepunch-fix-mmap_sem-i_mutex-deadlock
+++ a/mm/madvise.c
@@ -159,9 +159,10 @@ static long madvise_remove(struct vm_are
 				unsigned long start, unsigned long end)
 {
 	struct address_space *mapping;
-        loff_t offset, endoff;
+	loff_t offset, endoff;
+	int error;
 
-	*prev = vma;
+	*prev = NULL;	/* tell sys_madvise we drop mmap_sem */
 
 	if (vma->vm_flags & (VM_LOCKED|VM_NONLINEAR|VM_HUGETLB))
 		return -EINVAL;
@@ -180,7 +181,12 @@ static long madvise_remove(struct vm_are
 			+ ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
 	endoff = (loff_t)(end - vma->vm_start - 1)
 			+ ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
-	return  vmtruncate_range(mapping->host, offset, endoff);
+
+	/* vmtruncate_range needs to take i_mutex and i_alloc_sem */
+	up_write(&current->mm->mmap_sem);
+	error = vmtruncate_range(mapping->host, offset, endoff);
+	down_write(&current->mm->mmap_sem);
+	return error;
 }
 
 static long
@@ -315,12 +321,15 @@ asmlinkage long sys_madvise(unsigned lon
 		if (error)
 			goto out;
 		start = tmp;
-		if (start < prev->vm_end)
+		if (prev && start < prev->vm_end)
 			start = prev->vm_end;
 		error = unmapped_error;
 		if (start >= end)
 			goto out;
-		vma = prev->vm_next;
+		if (prev)
+			vma = prev->vm_next;
+		else	/* madvise_remove dropped mmap_sem */
+			vma = find_vma(current->mm, start);
 	}
 out:
 	up_write(&current->mm->mmap_sem);
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
git-drm.patch
mm-more-rmap-checking.patch
mm-make-read_cache_page-synchronous.patch
fs-buffer-dont-pageuptodate-without-page-locked.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
i386-add-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix-2.patch
smaps-use-ptep_test_and_clear_young.patch
tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up-fix.patch
ext2-reservations.patch
ext2-balloc-use-io_error-label.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
