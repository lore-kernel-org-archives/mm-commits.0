From: akpm@linux-foundation.org
Subject: + ksm-remove-vm_mergeable_flags.patch added to -mm tree
Date: Tue, 04 Aug 2009 15:01:25 -0700
Message-ID: <200908042201.n74M1QE1014044@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39181 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933196AbZHDWCc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Aug 2009 18:02:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh.dickins@tiscali.co.uk, aarcange@redhat.com, ieidus@redhat.com


The patch titled
     ksm: remove VM_MERGEABLE_FLAGS
has been added to the -mm tree.  Its filename is
     ksm-remove-vm_mergeable_flags.patch

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
@@ -660,9 +660,6 @@ again:			remove_next = 1 + (end > next->
 	validate_mm(mm);
 }
 
-/* Flags that can be inherited from an existing mapping when merging */
-#define VM_MERGEABLE_FLAGS (VM_CAN_NONLINEAR)
-
 /*
  * If the vma has a ->close operation then the driver probably needs to release
  * per-vma resources, so we don't attempt to merge those.
@@ -670,7 +667,8 @@ again:			remove_next = 1 + (end > next->
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

acpi-fix-null-bug-for-hid-uid-string.patch
mm-oom-analysis-add-shmem-vmstat.patch
ksm-add-mmu_notifier-set_pte_at_notify.patch
ksm-first-tidy-up-madvise_vma.patch
ksm-define-madv_mergeable-and-madv_unmergeable.patch
ksm-the-mm-interface-to-ksm.patch
ksm-no-debug-in-page_dup_rmap.patch
ksm-identify-pageksm-pages.patch
ksm-kernel-samepage-merging.patch
ksm-prevent-mremap-move-poisoning.patch
ksm-change-copyright-message.patch
ksm-change-ksm-nice-level-to-be-5.patch
ksm-rename-kernel_pages_allocated.patch
ksm-move-pages_sharing-updates.patch
ksm-pages_unshared-and-pages_volatile.patch
ksm-break-cow-once-unshared.patch
ksm-keep-quiet-while-list-empty.patch
ksm-five-little-cleanups.patch
ksm-fix-endless-loop-on-oom.patch
ksm-distribute-remove_mm_from_lists.patch
ksm-fix-oom-deadlock.patch
ksm-sysfs-and-defaults.patch
ksm-add-some-documentation.patch
ksm-remove-vm_mergeable_flags.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
ramfs-move-ramfs_magic-to-include-linux-magich.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
prio_tree-debugging-patch.patch

