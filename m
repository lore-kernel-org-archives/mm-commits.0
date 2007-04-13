From: akpm@linux-foundation.org
Subject: + mm-madvise-avoid-exclusive-mmap_sem.patch added to -mm tree
Date: Fri, 13 Apr 2007 11:57:34 -0700
Message-ID: <200704131857.l3DIvYV4006942@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46267 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754137AbXDMS5w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 14:57:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, hugh@veritas.com, riel@redhat.com


The patch titled
     mm: madvise avoid exclusive mmap_sem
has been added to the -mm tree.  Its filename is
     mm-madvise-avoid-exclusive-mmap_sem.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm: madvise avoid exclusive mmap_sem
From: Nick Piggin <npiggin@suse.de>

Avoid down_write of the mmap_sem in madvise when we can help it.

Acked-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   33 +++++++++++++++++++++++++++++----
 1 files changed, 29 insertions(+), 4 deletions(-)

diff -puN mm/madvise.c~mm-madvise-avoid-exclusive-mmap_sem mm/madvise.c
--- a/mm/madvise.c~mm-madvise-avoid-exclusive-mmap_sem
+++ a/mm/madvise.c
@@ -12,6 +12,24 @@
 #include <linux/hugetlb.h>
 
 /*
+ * Any behaviour which results in changes to the vma->vm_flags needs to
+ * take mmap_sem for writing. Others, which simply traverse vmas, need
+ * to only take it for reading.
+ */
+static int madvise_need_mmap_write(int behavior)
+{
+	switch (behavior) {
+	case MADV_REMOVE:
+	case MADV_WILLNEED:
+	case MADV_DONTNEED:
+		return 0;
+	default:
+		/* be safe, default to 1. list exceptions explicitly */
+		return 1;
+	}
+}
+
+/*
  * We can potentially split a vm area into separate
  * areas, each area with its own behavior.
  */
@@ -183,9 +201,9 @@ static long madvise_remove(struct vm_are
 			+ ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
 
 	/* vmtruncate_range needs to take i_mutex and i_alloc_sem */
-	up_write(&current->mm->mmap_sem);
+	up_read(&current->mm->mmap_sem);
 	error = vmtruncate_range(mapping->host, offset, endoff);
-	down_write(&current->mm->mmap_sem);
+	down_read(&current->mm->mmap_sem);
 	return error;
 }
 
@@ -270,7 +288,10 @@ asmlinkage long sys_madvise(unsigned lon
 	int error = -EINVAL;
 	size_t len;
 
-	down_write(&current->mm->mmap_sem);
+	if (madvise_need_mmap_write(behavior))
+		down_write(&current->mm->mmap_sem);
+	else
+		down_read(&current->mm->mmap_sem);
 
 	if (start & ~PAGE_MASK)
 		goto out;
@@ -332,6 +353,10 @@ asmlinkage long sys_madvise(unsigned lon
 			vma = find_vma(current->mm, start);
 	}
 out:
-	up_write(&current->mm->mmap_sem);
+	if (madvise_need_mmap_write(behavior))
+		up_write(&current->mm->mmap_sem);
+	else
+		up_read(&current->mm->mmap_sem);
+
 	return error;
 }
_

Patches currently in -mm which might be from npiggin@suse.de are

mm-remove-gcc-workaround.patch
mm-more-rmap-checking.patch
mm-make-read_cache_page-synchronous.patch
fs-buffer-dont-pageuptodate-without-page-locked.patch
mm-simplify-filemap_nopage.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
mm-merge-nopfn-into-fault.patch
mm-remove-legacy-cruft.patch
mm-debug-check-for-the-fault-vs-invalidate-race.patch
mm-fix-clear_page_dirty_for_io-vs-fault-race.patch
mm-madvise-avoid-exclusive-mmap_sem.patch
exec-fix-remove_arg_zero.patch
exec-fix-remove_arg_zero-add-comment.patch
as-fix-antic_expire-check.patch
futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
