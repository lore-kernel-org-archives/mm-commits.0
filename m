From: akpm@linux-foundation.org
Subject: [merged] ksm-remove-vm_mergeable_flags.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:40:19 -0700
Message-ID: <200909222040.n8MKeJil005305@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46106 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752744AbZIVUmR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:42:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, aarcange@redhat.com, ieidus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ksm: remove VM_MERGEABLE_FLAGS
has been removed from the -mm tree.  Its filename was
     ksm-remove-vm_mergeable_flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ksm: remove VM_MERGEABLE_FLAGS
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

KSM originally stood for Kernel Shared Memory: but the kernel has long
supported shared memory, and VM_SHARED and VM_MAYSHARE vmas, and KSM is
something else.  So we switched to saying "merge" instead of "share".

But Chris Wright points out that this is confusing where mmap.c merges
adjacent vmas: most especially in the name VM_MERGEABLE_FLAGS, used by
is_mergeable_vma() to let vmas be merged despite flags being different.

Call it VMA_MERGE_DESPITE_FLAGS?  Perhaps, but at present it consists
only of VM_CAN_NONLINEAR: so for now it's clearer on all sides to use
that directly, with a comment on it in is_mergeable_vma().

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Acked-by: Izik Eidus <ieidus@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN mm/mmap.c~ksm-remove-vm_mergeable_flags mm/mmap.c
--- a/mm/mmap.c~ksm-remove-vm_mergeable_flags
+++ a/mm/mmap.c
@@ -657,9 +657,6 @@ again:			remove_next = 1 + (end > next->
 	validate_mm(mm);
 }
 
-/* Flags that can be inherited from an existing mapping when merging */
-#define VM_MERGEABLE_FLAGS (VM_CAN_NONLINEAR)
-
 /*
  * If the vma has a ->close operation then the driver probably needs to release
  * per-vma resources, so we don't attempt to merge those.
@@ -667,7 +664,8 @@ again:			remove_next = 1 + (end > next->
 static inline int is_mergeable_vma(struct vm_area_struct *vma,
 			struct file *file, unsigned long vm_flags)
 {
-	if ((vma->vm_flags ^ vm_flags) & ~VM_MERGEABLE_FLAGS)
+	/* VM_CAN_NONLINEAR may get set later by f_op->mmap() */
+	if ((vma->vm_flags ^ vm_flags) & ~VM_CAN_NONLINEAR)
 		return 0;
 	if (vma->vm_file != file)
 		return 0;
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

origin.patch
linux-next.patch
vfs-optimize-touch_time-too.patch
vfs-seq_file-add-helpers-for-data-filling.patch
fs-new-truncate-helpers.patch
fs-use-new-truncate-helpers.patch
fs-introduce-new-truncate-sequence.patch
fs-convert-simple-fs-to-new-truncate.patch
tmpfs-convert-to-use-the-new-truncate-convention.patch
ext2-convert-to-use-the-new-truncate-convention.patch
fat-convert-to-use-the-new-truncate-convention.patch
btrfs-convert-to-use-the-new-truncate-convention.patch
jfs-convert-to-use-the-new-truncate-convention.patch
udf-convert-to-use-the-new-truncate-convention.patch
minix-convert-to-use-the-new-truncate-convention.patch
getrusage-fill-ru_maxrss-value.patch
walk-system-ram-range-fix.patch
ramfs-move-ramfs_magic-to-include-linux-magich.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
prio_tree-debugging-patch.patch

