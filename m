From: akpm@linux-foundation.org
Subject: - mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:37:39 -0700
Message-ID: <200810182337.m9INbdh5032304@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57460 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750976AbYJRXho (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:37:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lee.schermerhorn@hp.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     mlock: resubmit locked_vm adjustment as separate patch
has been removed from the -mm tree.  Its filename was
     mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch.patch

This patch was dropped because it was folded into mmap-handle-mlocked-pages-during-map-remap-unmap.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mlock: resubmit locked_vm adjustment as separate patch
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

Adjust mm->locked_vm in the mmap(MAP_LOCKED) path to match mlock()
behavior and VM_LOCKED flag setting.

Broken out as separate patch.

During mlock*(), mlock_fixup() adjusts locked_vm as appropriate,
based on the type of vma.  For the "special" vmas--those whose
pages we don't actually mark as PageMlocked()--VM_LOCKED is not
set, so that we don't attempt to munlock the pages during munmap
or munlock, and so we don't need to duplicate the vma type filtering
there.  These vmas are not included in locked_vm by mlock_fixup().

During mmap() and vma extension, locked_vm is adjusted outside of the
mlock functions.  This patch enhances those path to match the behavior
of mlock for the special vmas.  Return number of pages NOT mlocked from
mlock_vma_pages_range() [0 or positive].  Share the return value with
possible error code [negative].  Caller adjusts locked_vm by non-negative
return value.  For "special" vmas, this will include all pages mapped
by the vma.  For "normal" [anon, file-backed] vmas, should always
return 0 adjustment.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    2 +-
 mm/mlock.c    |   42 +++++++++++++++++++++++++++++++++---------
 mm/mmap.c     |   10 +++++-----
 3 files changed, 39 insertions(+), 15 deletions(-)

diff -puN mm/internal.h~mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch mm/internal.h
--- a/mm/internal.h~mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch
+++ a/mm/internal.h
@@ -61,7 +61,7 @@ static inline unsigned long page_order(s
 	return page_private(page);
 }
 
-extern int mlock_vma_pages_range(struct vm_area_struct *vma,
+extern long mlock_vma_pages_range(struct vm_area_struct *vma,
 			unsigned long start, unsigned long end);
 extern void munlock_vma_pages_range(struct vm_area_struct *vma,
 			unsigned long start, unsigned long end);
diff -puN mm/mlock.c~mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch mm/mlock.c
--- a/mm/mlock.c~mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch
+++ a/mm/mlock.c
@@ -127,7 +127,7 @@ static void munlock_vma_page(struct page
  *
  * vma->vm_mm->mmap_sem must be held for at least read.
  */
-static int __mlock_vma_pages_range(struct vm_area_struct *vma,
+static long __mlock_vma_pages_range(struct vm_area_struct *vma,
 				   unsigned long start, unsigned long end,
 				   int mlock)
 {
@@ -229,7 +229,7 @@ static int __mlock_vma_pages_range(struc
 /*
  * Just make pages present if VM_LOCKED.  No-op if unlocking.
  */
-static int __mlock_vma_pages_range(struct vm_area_struct *vma,
+static long __mlock_vma_pages_range(struct vm_area_struct *vma,
 				   unsigned long start, unsigned long end,
 				   int mlock)
 {
@@ -240,13 +240,27 @@ static int __mlock_vma_pages_range(struc
 #endif /* CONFIG_UNEVICTABLE_LRU */
 
 /*
- * mlock all pages in this vma range.  For mmap()/mremap()/...
+/**
+ * mlock_vma_pages_range() - mlock pages in specified vma range.
+ * @vma - the vma containing the specfied address range
+ * @start - starting address in @vma to mlock
+ * @end   - end address [+1] in @vma to mlock
+ *
+ * For mmap()/mremap()/expansion of mlocked vma.
+ *
+ * return 0 on success for "normal" vmas.
+ *
+ * return number of pages [> 0] to be removed from locked_vm on success
+ * of "special" vmas.
+ *
+ * return negative error if vma spanning @start-@range disappears while
+ * mmap semaphore is dropped.  Unlikely?
  */
-int mlock_vma_pages_range(struct vm_area_struct *vma,
+long mlock_vma_pages_range(struct vm_area_struct *vma,
 			unsigned long start, unsigned long end)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	int error = 0;
+	int nr_pages = (end - start) / PAGE_SIZE;
 	BUG_ON(!(vma->vm_flags & VM_LOCKED));
 
 	/*
@@ -258,8 +272,11 @@ int mlock_vma_pages_range(struct vm_area
 	if (!((vma->vm_flags & (VM_DONTEXPAND | VM_RESERVED)) ||
 			is_vm_hugetlb_page(vma) ||
 			vma == get_gate_vma(current))) {
+		long error;
 		downgrade_write(&mm->mmap_sem);
+
 		error = __mlock_vma_pages_range(vma, start, end, 1);
+
 		up_read(&mm->mmap_sem);
 		/* vma can change or disappear */
 		down_write(&mm->mmap_sem);
@@ -267,20 +284,23 @@ int mlock_vma_pages_range(struct vm_area
 		/* non-NULL vma must contain @start, but need to check @end */
 		if (!vma ||  end > vma->vm_end)
 			return -EAGAIN;
-		return error;
+
+		return 0;	/* hide other errors from mmap(), et al */
 	}
 
 	/*
 	 * User mapped kernel pages or huge pages:
 	 * make these pages present to populate the ptes, but
-	 * fall thru' to reset VM_LOCKED so we don't try to munlock
-	 * this vma during munmap()/munlock().
+	 * fall thru' to reset VM_LOCKED--no need to unlock, and
+	 * return nr_pages so these don't get counted against task's
+	 * locked limit.  huge pages are already counted against
+	 * locked vm limit.
 	 */
 	make_pages_present(start, end);
 
 no_mlock:
 	vma->vm_flags &= ~VM_LOCKED;	/* and don't come back! */
-	return error;
+	return nr_pages;		/* error or pages NOT mlocked */
 }
 
 
@@ -369,6 +389,10 @@ success:
 		downgrade_write(&mm->mmap_sem);
 
 		ret = __mlock_vma_pages_range(vma, start, end, 1);
+		if (ret > 0) {
+			mm->locked_vm -= ret;
+			ret = 0;
+		}
 		/*
 		 * Need to reacquire mmap sem in write mode, as our callers
 		 * expect this.  We have no support for atomically upgrading
diff -puN mm/mmap.c~mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch mm/mmap.c
--- a/mm/mmap.c~mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch
+++ a/mm/mmap.c
@@ -1228,10 +1228,10 @@ out:
 		/*
 		 * makes pages present; downgrades, drops, reacquires mmap_sem
 		 */
-		int error = mlock_vma_pages_range(vma, addr, addr + len);
-		if (error < 0)
-			return error;	/* vma gone! */
-		mm->locked_vm += (len >> PAGE_SHIFT);
+		long nr_pages = mlock_vma_pages_range(vma, addr, addr + len);
+		if (nr_pages < 0)
+			return nr_pages;	/* vma gone! */
+		mm->locked_vm += (len >> PAGE_SHIFT) - nr_pages;
 	} else if ((flags & MAP_POPULATE) && !(flags & MAP_NONBLOCK))
 		make_pages_present(addr, addr + len);
 	return addr;
@@ -2070,7 +2070,7 @@ unsigned long do_brk(unsigned long addr,
 out:
 	mm->total_vm += len >> PAGE_SHIFT;
 	if (flags & VM_LOCKED) {
-		if (mlock_vma_pages_range(vma, addr, addr + len) >= 0)
+		if (!mlock_vma_pages_range(vma, addr, addr + len))
 			mm->locked_vm += (len >> PAGE_SHIFT);
 	}
 	return addr;
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

