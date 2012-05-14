From: akpm@linux-foundation.org
Subject: + mm-fs-route-madv_remove-to-falloc_fl_punch_hole.patch added to -mm tree
Date: Mon, 14 May 2012 16:13:57 -0700
Message-ID: <20120514231357.72724A00AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:57447 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757353Ab2ENXN6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 May 2012 19:13:58 -0400
Received: by qabg24 with SMTP id g24so583170qab.1
        for <mm-commits@vger.kernel.org>; Mon, 14 May 2012 16:13:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, adilger@dilger.ca, amwang@redhat.com, bpm@sgi.com, ccross@android.com, david@fromorbit.com, gregkh@linux-foundation.org, hch@infradead.org, jlbec@evilplan.org, john.stultz@linaro.org, mfasheh@suse.de, mtk.manpages@gmail.com, tytso@mit.edu, viro@zeniv.linux.org.uk


The patch titled
     Subject: mm/fs: route MADV_REMOVE to FALLOC_FL_PUNCH_HOLE
has been added to the -mm tree.  Its filename is
     mm-fs-route-madv_remove-to-falloc_fl_punch_hole.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: mm/fs: route MADV_REMOVE to FALLOC_FL_PUNCH_HOLE

Patches currently in -mm which might be from hughd@google.com are

linux-next.patch
mm-remove-swap-token-code.patch
mm-vmscan-remove-lumpy-reclaim.patch
mm-vmscan-do-not-stall-on-writeback-during-memory-compaction.patch
mm-vmscan-remove-reclaim_mode_t.patch
mm-mmapc-find_vma-remove-unnecessary-ifmm-check.patch
mm-mmapc-find_vma-remove-unnecessary-ifmm-check-fix.patch
mm-fork-fix-overflow-in-vma-length-when-copying-mmap-on-clone.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
bug-introduce-build_bug_on_invalid-macro.patch
bug-completely-remove-code-generated-by-disabled-vm_bug_on.patch
shmem-replace-page-if-mapping-excludes-its-zone.patch
tmpfs-enable-nosec-optimization.patch
tmpfs-optimize-clearing-when-writing.patch
tmpfs-support-fallocate-falloc_fl_punch_hole.patch
mm-fs-route-madv_remove-to-falloc_fl_punch_hole.patch
mm-fs-remove-truncate_range.patch
tmpfs-support-fallocate-preallocation.patch
tmpfs-undo-fallocation-on-failure.patch
tmpfs-quit-when-fallocate-fills-memory.patch
tmpfs-support-seek_data-and-seek_hole.patch
memcg-fix-change-behavior-of-shared-anon-at-moving-task.patch
memcg-swap-mem_cgroup_move_swap_account-never-needs-fixup.patch
memcg-swap-use-mem_cgroup_uncharge_swap.patch
mm-memcg-scanning_global_lru-means-mem_cgroup_disabled.patch
mm-memcg-move-reclaim_stat-into-lruvec.patch
mm-push-lru-index-into-shrink_active_list.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
mm-mark-mm-inline-functions-as-__always_inline.patch
mm-remove-lru-type-checks-from-__isolate_lru_page.patch
mm-memcg-kill-mem_cgroup_lru_del.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup.patch
memcg-add-mlock-statistic-in-memorystat.patch
memcg-add-mlock-statistic-in-memorystat-fix.patch
mm-vmscan-store-priority-in-struct-scan_control.patch
mm-add-link-from-struct-lruvec-to-struct-zone.patch
mm-vmscan-push-lruvec-pointer-into-isolate_lru_pages.patch
mm-vmscan-push-zone-pointer-into-shrink_page_list.patch
mm-vmscan-remove-update_isolated_counts.patch
mm-vmscan-push-lruvec-pointer-into-putback_inactive_pages.patch
mm-vmscan-replace-zone_nr_lru_pages-with-get_lruvec_size.patch
mm-vmscan-push-lruvec-pointer-into-inactive_list_is_low.patch
mm-vmscan-push-lruvec-pointer-into-shrink_list.patch
mm-vmscan-push-lruvec-pointer-into-get_scan_count.patch
mm-vmscan-push-lruvec-pointer-into-should_continue_reclaim.patch
mm-vmscan-kill-struct-mem_cgroup_zone.patch
mm-huge_memoryc-use-lockdep_assert_held.patch
proc-clean-up-proc-pid-environ-handling.patch
proc-remove-mm_for_maps.patch
proc-use-mm_access-instead-of-ptrace_may_access.patch
proc-report-file-anon-bit-in-proc-pid-pagemap.patch
proc-use-is_err_or_null.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
prio_tree-debugging-patch.patch

