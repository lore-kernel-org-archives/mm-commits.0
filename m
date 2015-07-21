From: akpm@linux-foundation.org
Subject: +
 mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4-checkpatch-fixes.patch added to -mm tree
Date: Tue, 21 Jul 2015 13:59:51 -0700
Message-ID: <55aeb2c7.XsFjCf7QZ+EcjRGI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41034 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbbGUU7w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jul 2015 16:59:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, emunson@akamai.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4-checkpatch-fixes

WARNING: Possible unwrapped commit description (prefer a maximum 75 chars per line)
#5: 
Do extensive search for VM_LOCKED and ensure that VM_LOCKONFAULT is also handled

WARNING: line over 80 characters
#161: FILE: mm/hugetlb.c:3768:
+	unsigned long svm_flags = svma->vm_flags & ~(VM_LOCKED | VM_LOCKONFAULT);

WARNING: line over 80 characters
#173: FILE: mm/internal.h:249:
+			unsigned long start, unsigned long end, vm_flags_t to_drop);

WARNING: line over 80 characters
#223: FILE: mm/memory.c:2169:
+		if (page_copied && (vma->vm_flags & (VM_LOCKED | VM_LOCKONFAULT))) {

WARNING: line over 80 characters
#434: FILE: mm/msync.c:76:
+				(vma->vm_flags & (VM_LOCKED | VM_LOCKONFAULT))) {

WARNING: line over 80 characters
#449: FILE: mm/rmap.c:747:
+			pra->vm_flags |= (vma->vm_flags & (VM_LOCKED | VM_LOCKONFAULT));

WARNING: line over 80 characters
#461: FILE: mm/rmap.c:768:
+			pra->vm_flags |= (vma->vm_flags & (VM_LOCKED | VM_LOCKONFAULT));

total: 0 errors, 7 warnings, 371 lines checked

./patches/mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Eric B Munson <emunson@akamai.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c  |    6 ++++--
 mm/internal.h |    2 +-
 mm/memory.c   |    3 ++-
 mm/msync.c    |    2 +-
 mm/rmap.c     |    6 ++++--
 5 files changed, 12 insertions(+), 7 deletions(-)

diff -puN mm/hugetlb.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4-checkpatch-fixes mm/hugetlb.c
--- a/mm/hugetlb.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4-checkpatch-fixes
+++ a/mm/hugetlb.c
@@ -3762,10 +3762,12 @@ static unsigned long page_table_shareabl
 				svma->vm_start;
 	unsigned long sbase = saddr & PUD_MASK;
 	unsigned long s_end = sbase + PUD_SIZE;
+	unsigned long vm_flags;
+	unsigned long svm_flags;
 
 	/* Allow segments to share if only one is marked locked */
-	unsigned long vm_flags = vma->vm_flags & ~(VM_LOCKED | VM_LOCKONFAULT);
-	unsigned long svm_flags = svma->vm_flags & ~(VM_LOCKED | VM_LOCKONFAULT);
+	vm_flags = vma->vm_flags & ~(VM_LOCKED | VM_LOCKONFAULT);
+	svm_flags = svma->vm_flags & ~(VM_LOCKED | VM_LOCKONFAULT);
 
 	/*
 	 * match the virtual addresses, permission and the alignment of the
diff -puN mm/internal.h~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4-checkpatch-fixes mm/internal.h
--- a/mm/internal.h~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4-checkpatch-fixes
+++ a/mm/internal.h
@@ -246,7 +246,7 @@ void __vma_link_list(struct mm_struct *m
 extern long populate_vma_page_range(struct vm_area_struct *vma,
 		unsigned long start, unsigned long end, int *nonblocking);
 extern void munlock_vma_pages_range(struct vm_area_struct *vma,
-			unsigned long start, unsigned long end, vm_flags_t to_drop);
+		unsigned long start, unsigned long end, vm_flags_t to_drop);
 static inline void munlock_vma_pages_all(struct vm_area_struct *vma)
 {
 	munlock_vma_pages_range(vma, vma->vm_start, vma->vm_end,
diff -puN mm/memory.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4-checkpatch-fixes mm/memory.c
--- a/mm/memory.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4-checkpatch-fixes
+++ a/mm/memory.c
@@ -2166,7 +2166,8 @@ static int wp_page_copy(struct mm_struct
 		 * Don't let another task, with possibly unlocked vma,
 		 * keep the mlocked page.
 		 */
-		if (page_copied && (vma->vm_flags & (VM_LOCKED | VM_LOCKONFAULT))) {
+		if (page_copied && (vma->vm_flags &
+				    (VM_LOCKED | VM_LOCKONFAULT))) {
 			lock_page(old_page);	/* LRU manipulation */
 			munlock_vma_page(old_page);
 			unlock_page(old_page);
diff -puN mm/msync.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4-checkpatch-fixes mm/msync.c
--- a/mm/msync.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4-checkpatch-fixes
+++ a/mm/msync.c
@@ -73,7 +73,7 @@ SYSCALL_DEFINE3(msync, unsigned long, st
 		}
 		/* Here vma->vm_start <= start < vma->vm_end. */
 		if ((flags & MS_INVALIDATE) &&
-				(vma->vm_flags & (VM_LOCKED | VM_LOCKONFAULT))) {
+			    (vma->vm_flags & (VM_LOCKED | VM_LOCKONFAULT))) {
 			error = -EBUSY;
 			goto out_unlock;
 		}
diff -puN mm/rmap.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4-checkpatch-fixes mm/rmap.c
--- a/mm/rmap.c~mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4-checkpatch-fixes
+++ a/mm/rmap.c
@@ -744,7 +744,8 @@ static int page_referenced_one(struct pa
 
 		if (vma->vm_flags & (VM_LOCKED | VM_LOCKONFAULT)) {
 			spin_unlock(ptl);
-			pra->vm_flags |= (vma->vm_flags & (VM_LOCKED | VM_LOCKONFAULT));
+			pra->vm_flags |= (vma->vm_flags &
+					  (VM_LOCKED | VM_LOCKONFAULT));
 			return SWAP_FAIL; /* To break the loop */
 		}
 
@@ -765,7 +766,8 @@ static int page_referenced_one(struct pa
 
 		if (vma->vm_flags & (VM_LOCKED | VM_LOCKONFAULT)) {
 			pte_unmap_unlock(pte, ptl);
-			pra->vm_flags |= (vma->vm_flags & (VM_LOCKED | VM_LOCKONFAULT));
+			pra->vm_flags |= (vma->vm_flags &
+					  (VM_LOCKED | VM_LOCKONFAULT));
 			return SWAP_FAIL; /* To break the loop */
 		}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
kernel-kthreadc-kthread_create_on_node-clarify-documentation.patch
scripts-spellingtxt-adding-misspelled-word-for-check-fix.patch
mm.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
mm-mlock-introduce-vm_lockonfault-and-add-mlock-flags-to-enable-it-v4-checkpatch-fixes.patch
mm-mmap-add-mmap-flag-to-request-vm_lockonfault-v4-fix.patch
genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-fix.patch
genalloc-add-support-of-multiple-gen_pools-per-device-fix.patch
mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested-fix.patch
dax-revert-userfaultfd-change.patch
thp-prepare-for-dax-huge-pages-fix.patch
pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here-fix.patch
mm-show-proportional-swap-share-of-the-mapping-fix.patch
mm-improve-__gfp_noretry-comment-based-on-implementation-fix.patch
memcg-export-struct-mem_cgroup-fix.patch
memcg-export-struct-mem_cgroup-fix-2.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

