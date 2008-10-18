From: akpm@linux-foundation.org
Subject: - mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-backout-locked_vm-adjustment-during-mmap.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:37:36 -0700
Message-ID: <200810182337.m9INbaNj032285@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33713 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751424AbYJRXhk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:37:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lee.schermerhorn@hp.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     mlock: backout locked_vm adjustment during mmap()
has been removed from the -mm tree.  Its filename was
     mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-backout-locked_vm-adjustment-during-mmap.patch

This patch was dropped because it was folded into mmap-handle-mlocked-pages-during-map-remap-unmap.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mlock: backout locked_vm adjustment during mmap()
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

Backout mmap() path locked_vm accounting adjustment from the "handle
mlocked pages during map/remap/unmap" patch.  Will resubmit as separate
patch with its own description.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |   19 ++++++-------------
 mm/mmap.c  |   19 ++++++++-----------
 2 files changed, 14 insertions(+), 24 deletions(-)

diff -puN mm/mlock.c~mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-backout-locked_vm-adjustment-during-mmap mm/mlock.c
--- a/mm/mlock.c~mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-backout-locked_vm-adjustment-during-mmap
+++ a/mm/mlock.c
@@ -246,7 +246,7 @@ int mlock_vma_pages_range(struct vm_area
 			unsigned long start, unsigned long end)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	int nr_pages = (end - start) / PAGE_SIZE;
+	int error = 0;
 	BUG_ON(!(vma->vm_flags & VM_LOCKED));
 
 	/*
@@ -259,8 +259,7 @@ int mlock_vma_pages_range(struct vm_area
 			is_vm_hugetlb_page(vma) ||
 			vma == get_gate_vma(current))) {
 		downgrade_write(&mm->mmap_sem);
-		nr_pages = __mlock_vma_pages_range(vma, start, end, 1);
-
+		error = __mlock_vma_pages_range(vma, start, end, 1);
 		up_read(&mm->mmap_sem);
 		/* vma can change or disappear */
 		down_write(&mm->mmap_sem);
@@ -268,22 +267,20 @@ int mlock_vma_pages_range(struct vm_area
 		/* non-NULL vma must contain @start, but need to check @end */
 		if (!vma ||  end > vma->vm_end)
 			return -EAGAIN;
-		return nr_pages;
+		return error;
 	}
 
 	/*
 	 * User mapped kernel pages or huge pages:
 	 * make these pages present to populate the ptes, but
-	 * fall thru' to reset VM_LOCKED--no need to unlock, and
-	 * return nr_pages so these don't get counted against task's
-	 * locked limit.  huge pages are already counted against
-	 * locked vm limit.
+	 * fall thru' to reset VM_LOCKED so we don't try to munlock
+	 * this vma during munmap()/munlock().
 	 */
 	make_pages_present(start, end);
 
 no_mlock:
 	vma->vm_flags &= ~VM_LOCKED;	/* and don't come back! */
-	return nr_pages;		/* pages NOT mlocked */
+	return error;
 }
 
 
@@ -372,10 +369,6 @@ success:
 		downgrade_write(&mm->mmap_sem);
 
 		ret = __mlock_vma_pages_range(vma, start, end, 1);
-		if (ret > 0) {
-			mm->locked_vm -= ret;
-			ret = 0;
-		}
 		/*
 		 * Need to reacquire mmap sem in write mode, as our callers
 		 * expect this.  We have no support for atomically upgrading
diff -puN mm/mmap.c~mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-backout-locked_vm-adjustment-during-mmap mm/mmap.c
--- a/mm/mmap.c~mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-backout-locked_vm-adjustment-during-mmap
+++ a/mm/mmap.c
@@ -1228,10 +1228,10 @@ out:
 		/*
 		 * makes pages present; downgrades, drops, reacquires mmap_sem
 		 */
-		int nr_pages = mlock_vma_pages_range(vma, addr, addr + len);
-		if (nr_pages < 0)
-			return nr_pages;	/* vma gone! */
-		mm->locked_vm += (len >> PAGE_SHIFT) - nr_pages;
+		int error = mlock_vma_pages_range(vma, addr, addr + len);
+		if (error < 0)
+			return error;	/* vma gone! */
+		mm->locked_vm += (len >> PAGE_SHIFT);
 	} else if ((flags & MAP_POPULATE) && !(flags & MAP_NONBLOCK))
 		make_pages_present(addr, addr + len);
 	return addr;
@@ -1706,8 +1706,7 @@ find_extend_vma(struct mm_struct *mm, un
 	if (!prev || expand_stack(prev, addr))
 		return NULL;
 	if (prev->vm_flags & VM_LOCKED) {
-		int nr_pages = mlock_vma_pages_range(prev, addr, prev->vm_end);
-		if (nr_pages < 0)
+		if (mlock_vma_pages_range(prev, addr, prev->vm_end) < 0)
 			return NULL;	/* vma gone! */
 	}
 	return prev;
@@ -1736,8 +1735,7 @@ find_extend_vma(struct mm_struct * mm, u
 	if (expand_stack(vma, addr))
 		return NULL;
 	if (vma->vm_flags & VM_LOCKED) {
-		int nr_pages = mlock_vma_pages_range(vma, addr, start);
-		if (nr_pages < 0)
+		if (mlock_vma_pages_range(vma, addr, start) < 0)
 			return NULL;	/* vma gone! */
 	}
 	return vma;
@@ -2072,9 +2070,8 @@ unsigned long do_brk(unsigned long addr,
 out:
 	mm->total_vm += len >> PAGE_SHIFT;
 	if (flags & VM_LOCKED) {
-		int nr_pages = mlock_vma_pages_range(vma, addr, addr + len);
-		if (nr_pages >= 0)
-			mm->locked_vm += (len >> PAGE_SHIFT) - nr_pages;
+		if (mlock_vma_pages_range(vma, addr, addr + len) >= 0)
+			mm->locked_vm += (len >> PAGE_SHIFT);
 	}
 	return addr;
 }
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

vmscan-use-an-indexed-array-for-lru-variables.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
pageflag-helpers-for-configed-out-flags.patch
unevictable-lru-infrastructure.patch
unevictable-infrastructure-lru-add-event-counting-with-statistics.patch
unevictable-lru-page-statistics.patch
ramfs-and-ram-disk-pages-are-unevictable.patch
shm_locked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable.patch
doc-unevictable-lru-and-mlocked-pages-documentation.patch
mlock-downgrade-mmap-sem-while-populating-mlocked-regions.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-backout-locked_vm-adjustment-during-mmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch-fix.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-fix-return-value-for-munmap-mlock-vma-race.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-update-locked_vm-on-munmap-of-mlocked-region.patch
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-mlocked-pages-add-event-counting-with-statistics.patch
swap-cull-unevictable-pages-in-fault-path.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-count-attempts-to-free-mlocked-page-2.patch
mlock-revert-mainline-handling-of-mlock-error-return.patch
mlock-make-mlock-error-return-posixly-correct.patch
mlock-make-mlock-error-return-posixly-correct-fix.patch

