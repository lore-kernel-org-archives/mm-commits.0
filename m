From: akpm@linux-foundation.org
Subject: + ksm-clean-up-obsolete-references.patch added to -mm tree
Date: Tue, 08 Sep 2009 22:40:45 -0700
Message-ID: <200909090540.n895ejUs022715@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39341 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750721AbZIIFlC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2009 01:41:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh.dickins@tiscali.co.uk, aarcange@redhat.com, ieidus@redhat.com


The patch titled
     ksm: clean up obsolete references
has been added to the -mm tree.  Its filename is
     ksm-clean-up-obsolete-references.patch

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
Subject: ksm: clean up obsolete references
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

A few cleanups, given the munlock fix: the comment on ksm_test_exit() no
longer applies, and it can be made private to ksm.c; there's no more
reference to mmu_gather or tlb.h, and mmap.c doesn't need ksm.h.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Acked-by: Izik Eidus <ieidus@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ksm.h |   20 --------------------
 mm/ksm.c            |   14 +++++++++++++-
 mm/mmap.c           |    1 -
 3 files changed, 13 insertions(+), 22 deletions(-)

diff -puN include/linux/ksm.h~ksm-clean-up-obsolete-references include/linux/ksm.h
--- a/include/linux/ksm.h~ksm-clean-up-obsolete-references
+++ a/include/linux/ksm.h
@@ -12,8 +12,6 @@
 #include <linux/sched.h>
 #include <linux/vmstat.h>
 
-struct mmu_gather;
-
 #ifdef CONFIG_KSM
 int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
 		unsigned long end, int advice, unsigned long *vm_flags);
@@ -27,19 +25,6 @@ static inline int ksm_fork(struct mm_str
 	return 0;
 }
 
-/*
- * For KSM to handle OOM without deadlock when it's breaking COW in a
- * likely victim of the OOM killer, exit_mmap() has to serialize with
- * ksm_exit() after freeing mm's pages but before freeing its page tables.
- * That leaves a window in which KSM might refault pages which have just
- * been finally unmapped: guard against that with ksm_test_exit(), and
- * use it after getting mmap_sem in ksm.c, to check if mm is exiting.
- */
-static inline bool ksm_test_exit(struct mm_struct *mm)
-{
-	return atomic_read(&mm->mm_users) == 0;
-}
-
 static inline void ksm_exit(struct mm_struct *mm)
 {
 	if (test_bit(MMF_VM_MERGEABLE, &mm->flags))
@@ -79,11 +64,6 @@ static inline int ksm_fork(struct mm_str
 	return 0;
 }
 
-static inline bool ksm_test_exit(struct mm_struct *mm)
-{
-	return 0;
-}
-
 static inline void ksm_exit(struct mm_struct *mm)
 {
 }
diff -puN mm/ksm.c~ksm-clean-up-obsolete-references mm/ksm.c
--- a/mm/ksm.c~ksm-clean-up-obsolete-references
+++ a/mm/ksm.c
@@ -32,7 +32,6 @@
 #include <linux/mmu_notifier.h>
 #include <linux/ksm.h>
 
-#include <asm/tlb.h>
 #include <asm/tlbflush.h>
 
 /*
@@ -285,6 +284,19 @@ static inline int in_stable_tree(struct 
 }
 
 /*
+ * ksmd, and unmerge_and_remove_all_rmap_items(), must not touch an mm's
+ * page tables after it has passed through ksm_exit() - which, if necessary,
+ * takes mmap_sem briefly to serialize against them.  ksm_exit() does not set
+ * a special flag: they can just back out as soon as mm_users goes to zero.
+ * ksm_test_exit() is used throughout to make this test for exit: in some
+ * places for correctness, in some places just to avoid unnecessary work.
+ */
+static inline bool ksm_test_exit(struct mm_struct *mm)
+{
+	return atomic_read(&mm->mm_users) == 0;
+}
+
+/*
  * We use break_ksm to break COW on a ksm page: it's a stripped down
  *
  *	if (get_user_pages(current, mm, addr, 1, 1, 1, &page, NULL) == 1)
diff -puN mm/mmap.c~ksm-clean-up-obsolete-references mm/mmap.c
--- a/mm/mmap.c~ksm-clean-up-obsolete-references
+++ a/mm/mmap.c
@@ -27,7 +27,6 @@
 #include <linux/mount.h>
 #include <linux/mempolicy.h>
 #include <linux/rmap.h>
-#include <linux/ksm.h>
 #include <linux/mmu_notifier.h>
 #include <linux/perf_counter.h>
 
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

