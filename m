From: akpm@linux-foundation.org
Subject: [merged] mm-fs-route-madv_remove-to-falloc_fl_punch_hole.patch removed from -mm tree
Date: Thu, 31 May 2012 12:15:39 -0700
Message-ID: <20120531191539.9B074A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:42243 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932941Ab2EaTPk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:15:40 -0400
Received: by mail-qa0-f74.google.com with SMTP id g24so154247qab.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:15:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, adilger@dilger.ca, amwang@redhat.com, bpm@sgi.com, ccross@android.com, david@fromorbit.com, gregkh@linux-foundation.org, hch@infradead.org, jlbec@evilplan.org, john.stultz@linaro.org, mfasheh@suse.de, mtk.manpages@gmail.com, tytso@mit.edu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/fs: route MADV_REMOVE to FALLOC_FL_PUNCH_HOLE
has been removed from the -mm tree.  Its filename was
     mm-fs-route-madv_remove-to-falloc_fl_punch_hole.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/fs: route MADV_REMOVE to FALLOC_FL_PUNCH_HOLE

Now tmpfs supports hole-punching via fallocate(), switch madvise_remove()
to use do_fallocate() instead of vmtruncate_range(): which extends
madvise(,,MADV_REMOVE) support from tmpfs to ext4, ocfs2 and xfs.

There is one more user of vmtruncate_range() in our tree,
staging/android's ashmem_shrink(): convert it to use do_fallocate() too
(but if its unpinned areas are already unmapped - I don't know - then it
would do better to use shmem_truncate_range() directly).

Based-on-patch-by: Cong Wang <amwang@redhat.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Colin Cross <ccross@android.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linux-foundation.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger@dilger.ca>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Ben Myers <bpm@sgi.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/android/ashmem.c |    8 +++++---
 mm/madvise.c                     |   15 +++++++--------
 2 files changed, 12 insertions(+), 11 deletions(-)

diff -puN drivers/staging/android/ashmem.c~mm-fs-route-madv_remove-to-falloc_fl_punch_hole drivers/staging/android/ashmem.c
--- a/drivers/staging/android/ashmem.c~mm-fs-route-madv_remove-to-falloc_fl_punch_hole
+++ a/drivers/staging/android/ashmem.c
@@ -19,6 +19,7 @@
 #include <linux/module.h>
 #include <linux/file.h>
 #include <linux/fs.h>
+#include <linux/falloc.h>
 #include <linux/miscdevice.h>
 #include <linux/security.h>
 #include <linux/mm.h>
@@ -363,11 +364,12 @@ static int ashmem_shrink(struct shrinker
 
 	mutex_lock(&ashmem_mutex);
 	list_for_each_entry_safe(range, next, &ashmem_lru_list, lru) {
-		struct inode *inode = range->asma->file->f_dentry->d_inode;
 		loff_t start = range->pgstart * PAGE_SIZE;
-		loff_t end = (range->pgend + 1) * PAGE_SIZE - 1;
+		loff_t end = (range->pgend + 1) * PAGE_SIZE;
 
-		vmtruncate_range(inode, start, end);
+		do_fallocate(range->asma->file,
+				FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
+				start, end - start);
 		range->purged = ASHMEM_WAS_PURGED;
 		lru_del(range);
 
diff -puN mm/madvise.c~mm-fs-route-madv_remove-to-falloc_fl_punch_hole mm/madvise.c
--- a/mm/madvise.c~mm-fs-route-madv_remove-to-falloc_fl_punch_hole
+++ a/mm/madvise.c
@@ -11,8 +11,10 @@
 #include <linux/mempolicy.h>
 #include <linux/page-isolation.h>
 #include <linux/hugetlb.h>
+#include <linux/falloc.h>
 #include <linux/sched.h>
 #include <linux/ksm.h>
+#include <linux/fs.h>
 
 /*
  * Any behaviour which results in changes to the vma->vm_flags needs to
@@ -200,8 +202,7 @@ static long madvise_remove(struct vm_are
 				struct vm_area_struct **prev,
 				unsigned long start, unsigned long end)
 {
-	struct address_space *mapping;
-	loff_t offset, endoff;
+	loff_t offset;
 	int error;
 
 	*prev = NULL;	/* tell sys_madvise we drop mmap_sem */
@@ -217,16 +218,14 @@ static long madvise_remove(struct vm_are
 	if ((vma->vm_flags & (VM_SHARED|VM_WRITE)) != (VM_SHARED|VM_WRITE))
 		return -EACCES;
 
-	mapping = vma->vm_file->f_mapping;
-
 	offset = (loff_t)(start - vma->vm_start)
 			+ ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
-	endoff = (loff_t)(end - vma->vm_start - 1)
-			+ ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
 
-	/* vmtruncate_range needs to take i_mutex */
+	/* filesystem's fallocate may need to take i_mutex */
 	up_read(&current->mm->mmap_sem);
-	error = vmtruncate_range(mapping->host, offset, endoff);
+	error = do_fallocate(vma->vm_file,
+				FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
+				offset, end - start);
 	down_read(&current->mm->mmap_sem);
 	return error;
 }
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
linux-next.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
proc-clean-up-proc-pid-environ-handling.patch
proc-remove-mm_for_maps.patch
proc-use-mm_access-instead-of-ptrace_may_access.patch
proc-report-file-anon-bit-in-proc-pid-pagemap.patch
proc-use-is_err_or_null.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
prio_tree-debugging-patch.patch

