From: akpm@linux-foundation.org
Subject: + ksm-mremap-use-err-from-ksm_madvise.patch added to -mm tree
Date: Tue, 08 Sep 2009 22:40:50 -0700
Message-ID: <200909090540.n895eoBE022908@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33331 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750815AbZIIFlE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2009 01:41:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh.dickins@tiscali.co.uk, aarcange@redhat.com, ieidus@redhat.com


The patch titled
     ksm: mremap use err from ksm_madvise
has been added to the -mm tree.  Its filename is
     ksm-mremap-use-err-from-ksm_madvise.patch

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
Subject: ksm: mremap use err from ksm_madvise
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

mremap move's use of ksm_madvise() was assuming -ENOMEM on failure,
because ksm_madvise used to say -EAGAIN for that; but ksm_madvise now says
-ENOMEM (letting madvise convert that to -EAGAIN), and can also say
-ERESTARTSYS when signalled: so pass the error from ksm_madvise.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Acked-by: Izik Eidus <ieidus@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN mm/mremap.c~ksm-mremap-use-err-from-ksm_madvise mm/mremap.c
--- a/mm/mremap.c~ksm-mremap-use-err-from-ksm_madvise
+++ a/mm/mremap.c
@@ -175,6 +175,7 @@ static unsigned long move_vma(struct vm_
 	unsigned long excess = 0;
 	unsigned long hiwater_vm;
 	int split = 0;
+	int err;
 
 	/*
 	 * We'd prefer to avoid failure later on in do_munmap:
@@ -190,9 +191,10 @@ static unsigned long move_vma(struct vm_
 	 * pages recently unmapped.  But leave vma->vm_flags as it was,
 	 * so KSM can come around to merge on vma and new_vma afterwards.
 	 */
-	if (ksm_madvise(vma, old_addr, old_addr + old_len,
-						MADV_UNMERGEABLE, &vm_flags))
-		return -ENOMEM;
+	err = ksm_madvise(vma, old_addr, old_addr + old_len,
+						MADV_UNMERGEABLE, &vm_flags);
+	if (err)
+		return err;
 
 	new_pgoff = vma->vm_pgoff + ((old_addr - vma->vm_start) >> PAGE_SHIFT);
 	new_vma = copy_vma(&vma, new_addr, new_len, new_pgoff);
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

linux-next.patch
acpi-fix-null-bug-for-hid-uid-string-2.patch
vfs-optimize-touch_time-too-fix.patch
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
ksm-fix-deadlock-with-munlock-in-exit_mmap.patch
ksm-sysfs-and-defaults.patch
ksm-add-some-documentation.patch
ksm-remove-vm_mergeable_flags.patch
ksm-clean-up-obsolete-references.patch
ksm-unmerge-is-an-origin-of-ooms.patch
ksm-mremap-use-err-from-ksm_madvise.patch
mm-add_to_swap_cache-must-not-sleep.patch
mm-add_to_swap_cache-does-not-return-eexist.patch
mm-includecheck-fix-for-mm-shmemc.patch
mm-introduce-page_lru_base_type-fix.patch
mm-replace-various-uses-of-num_physpages-by-totalram_pages.patch
hugetlbfs-allow-the-creation-of-files-suitable-for-map_private-on-the-vfs-internal-mount.patch
hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions.patch
hugetlb-add-map_hugetlb-example.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
ramfs-move-ramfs_magic-to-include-linux-magich.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
prio_tree-debugging-patch.patch

