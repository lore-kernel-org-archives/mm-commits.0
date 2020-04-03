From: akpm@linux-foundation.org
Subject: [merged] mm-allow-vm_fault_retry-for-multiple-times.patch
 removed from -mm tree
Date: Fri, 03 Apr 2020 13:38:54 -0700
Message-ID: <20200403203854.yVes5Veau%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727829AbgDCUi4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:38:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, bgeffon@google.com, bobbypowers@gmail.com, cracauer@cons.org, david@redhat.com, dgilbert@redhat.com, dplotnikov@virtuozzo.com, gokhale2@llnl.gov, hannes@cmpxchg.org, hughd@google.com, jglisse@redhat.com, kirill@shutemov.name, mcfadden8@llnl.gov, mgorman@suse.de, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, peterx@redhat.com, rppt@linux.vnet.ibm.com, torvalds@linux-foundation.org, willy@infradead.org, xemul@openvz.org


The patch titled
     Subject: mm: allow VM_FAULT_RETRY for multiple times
has been removed from the -mm tree.  Its filename was
     mm-allow-vm_fault_retry-for-multiple-times.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm: allow VM_FAULT_RETRY for multiple times

The idea comes from a discussion between Linus and Andrea [1].

Before this patch we only allow a page fault to retry once.  We achieved
this by clearing the FAULT_FLAG_ALLOW_RETRY flag when doing
handle_mm_fault() the second time.  This was majorly used to avoid
unexpected starvation of the system by looping over forever to handle the
page fault on a single page.  However that should hardly happen, and after
all for each code path to return a VM_FAULT_RETRY we'll first wait for a
condition (during which time we should possibly yield the cpu) to happen
before VM_FAULT_RETRY is really returned.

This patch removes the restriction by keeping the FAULT_FLAG_ALLOW_RETRY
flag when we receive VM_FAULT_RETRY.  It means that the page fault handler
now can retry the page fault for multiple times if necessary without the
need to generate another page fault event.  Meanwhile we still keep the
FAULT_FLAG_TRIED flag so page fault handler can still identify whether a
page fault is the first attempt or not.

Then we'll have these combinations of fault flags (only considering
ALLOW_RETRY flag and TRIED flag):

  - ALLOW_RETRY and !TRIED:  this means the page fault allows to
                             retry, and this is the first try

  - ALLOW_RETRY and TRIED:   this means the page fault allows to
                             retry, and this is not the first try

  - !ALLOW_RETRY and !TRIED: this means the page fault does not allow
                             to retry at all

  - !ALLOW_RETRY and TRIED:  this is forbidden and should never be used

In existing code we have multiple places that has taken special care of
the first condition above by checking against (fault_flags &
FAULT_FLAG_ALLOW_RETRY).  This patch introduces a simple helper to detect
the first retry of a page fault by checking against both (fault_flags &
FAULT_FLAG_ALLOW_RETRY) and !(fault_flag & FAULT_FLAG_TRIED) because now
even the 2nd try will have the ALLOW_RETRY set, then use that helper in
all existing special paths.  One example is in __lock_page_or_retry(), now
we'll drop the mmap_sem only in the first attempt of page fault and we'll
keep it in follow up retries, so old locking behavior will be retained.

This will be a nice enhancement for current code [2] at the same time a
supporting material for the future userfaultfd-writeprotect work, since in
that work there will always be an explicit userfault writeprotect retry
for protected pages, and if that cannot resolve the page fault (e.g., when
userfaultfd-writeprotect is used in conjunction with swapped pages) then
we'll possibly need a 3rd retry of the page fault.  It might also benefit
other potential users who will have similar requirement like userfault
write-protection.

GUP code is not touched yet and will be covered in follow up patch.

Please read the thread below for more information.

[1] https://lore.kernel.org/lkml/20171102193644.GB22686@redhat.com/
[2] https://lore.kernel.org/lkml/20181230154648.GB9832@redhat.com/

Link: http://lkml.kernel.org/r/20200220160246.9790-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Suggested-by: Andrea Arcangeli <aarcange@redhat.com>
Tested-by: Brian Geffon <bgeffon@google.com>
Cc: Bobby Powers <bobbypowers@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Denis Plotnikov <dplotnikov@virtuozzo.com>
Cc: "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Martin Cracauer <cracauer@cons.org>
Cc: Marty McFadden <mcfadden8@llnl.gov>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Maya Gokhale <gokhale2@llnl.gov>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/mm/fault.c           |    2 -
 arch/arc/mm/fault.c             |    1 
 arch/arm/mm/fault.c             |    3 --
 arch/arm64/mm/fault.c           |    5 ----
 arch/hexagon/mm/vm_fault.c      |    1 
 arch/ia64/mm/fault.c            |    1 
 arch/m68k/mm/fault.c            |    3 --
 arch/microblaze/mm/fault.c      |    1 
 arch/mips/mm/fault.c            |    1 
 arch/nds32/mm/fault.c           |    1 
 arch/nios2/mm/fault.c           |    3 --
 arch/openrisc/mm/fault.c        |    1 
 arch/parisc/mm/fault.c          |    4 ---
 arch/powerpc/mm/fault.c         |    6 ----
 arch/riscv/mm/fault.c           |    5 ----
 arch/s390/mm/fault.c            |    5 ----
 arch/sh/mm/fault.c              |    1 
 arch/sparc/mm/fault_32.c        |    1 
 arch/sparc/mm/fault_64.c        |    1 
 arch/um/kernel/trap.c           |    1 
 arch/unicore32/mm/fault.c       |    4 ---
 arch/x86/mm/fault.c             |    2 -
 arch/xtensa/mm/fault.c          |    1 
 drivers/gpu/drm/ttm/ttm_bo_vm.c |   12 +++++++--
 include/linux/mm.h              |   37 ++++++++++++++++++++++++++++++
 mm/filemap.c                    |    2 -
 mm/internal.h                   |    6 ++--
 27 files changed, 54 insertions(+), 57 deletions(-)

--- a/arch/alpha/mm/fault.c~mm-allow-vm_fault_retry-for-multiple-times
+++ a/arch/alpha/mm/fault.c
@@ -169,7 +169,7 @@ retry:
 		else
 			current->min_flt++;
 		if (fault & VM_FAULT_RETRY) {
-			flags &= ~FAULT_FLAG_ALLOW_RETRY;
+			flags |= FAULT_FLAG_TRIED;
 
 			 /* No need to up_read(&mm->mmap_sem) as we would
 			 * have already released it in __lock_page_or_retry
--- a/arch/arc/mm/fault.c~mm-allow-vm_fault_retry-for-multiple-times
+++ a/arch/arc/mm/fault.c
@@ -145,7 +145,6 @@ retry:
 	 */
 	if (unlikely((fault & VM_FAULT_RETRY) &&
 		     (flags & FAULT_FLAG_ALLOW_RETRY))) {
-		flags &= ~FAULT_FLAG_ALLOW_RETRY;
 		flags |= FAULT_FLAG_TRIED;
 		goto retry;
 	}
--- a/arch/arm64/mm/fault.c~mm-allow-vm_fault_retry-for-multiple-times
+++ a/arch/arm64/mm/fault.c
@@ -521,12 +521,7 @@ retry:
 	}
 
 	if (fault & VM_FAULT_RETRY) {
-		/*
-		 * Clear FAULT_FLAG_ALLOW_RETRY to avoid any risk of
-		 * starvation.
-		 */
 		if (mm_flags & FAULT_FLAG_ALLOW_RETRY) {
-			mm_flags &= ~FAULT_FLAG_ALLOW_RETRY;
 			mm_flags |= FAULT_FLAG_TRIED;
 			goto retry;
 		}
--- a/arch/arm/mm/fault.c~mm-allow-vm_fault_retry-for-multiple-times
+++ a/arch/arm/mm/fault.c
@@ -319,9 +319,6 @@ retry:
 					regs, addr);
 		}
 		if (fault & VM_FAULT_RETRY) {
-			/* Clear FAULT_FLAG_ALLOW_RETRY to avoid any risk
-			* of starvation. */
-			flags &= ~FAULT_FLAG_ALLOW_RETRY;
 			flags |= FAULT_FLAG_TRIED;
 			goto retry;
 		}
--- a/arch/hexagon/mm/vm_fault.c~mm-allow-vm_fault_retry-for-multiple-times
+++ a/arch/hexagon/mm/vm_fault.c
@@ -102,7 +102,6 @@ good_area:
 			else
 				current->min_flt++;
 			if (fault & VM_FAULT_RETRY) {
-				flags &= ~FAULT_FLAG_ALLOW_RETRY;
 				flags |= FAULT_FLAG_TRIED;
 				goto retry;
 			}
--- a/arch/ia64/mm/fault.c~mm-allow-vm_fault_retry-for-multiple-times
+++ a/arch/ia64/mm/fault.c
@@ -167,7 +167,6 @@ retry:
 		else
 			current->min_flt++;
 		if (fault & VM_FAULT_RETRY) {
-			flags &= ~FAULT_FLAG_ALLOW_RETRY;
 			flags |= FAULT_FLAG_TRIED;
 
 			 /* No need to up_read(&mm->mmap_sem) as we would
--- a/arch/m68k/mm/fault.c~mm-allow-vm_fault_retry-for-multiple-times
+++ a/arch/m68k/mm/fault.c
@@ -162,9 +162,6 @@ good_area:
 		else
 			current->min_flt++;
 		if (fault & VM_FAULT_RETRY) {
-			/* Clear FAULT_FLAG_ALLOW_RETRY to avoid any risk
-			 * of starvation. */
-			flags &= ~FAULT_FLAG_ALLOW_RETRY;
 			flags |= FAULT_FLAG_TRIED;
 
 			/*
--- a/arch/microblaze/mm/fault.c~mm-allow-vm_fault_retry-for-multiple-times
+++ a/arch/microblaze/mm/fault.c
@@ -236,7 +236,6 @@ good_area:
 		else
 			current->min_flt++;
 		if (fault & VM_FAULT_RETRY) {
-			flags &= ~FAULT_FLAG_ALLOW_RETRY;
 			flags |= FAULT_FLAG_TRIED;
 
 			/*
--- a/arch/mips/mm/fault.c~mm-allow-vm_fault_retry-for-multiple-times
+++ a/arch/mips/mm/fault.c
@@ -178,7 +178,6 @@ good_area:
 			tsk->min_flt++;
 		}
 		if (fault & VM_FAULT_RETRY) {
-			flags &= ~FAULT_FLAG_ALLOW_RETRY;
 			flags |= FAULT_FLAG_TRIED;
 
 			/*
--- a/arch/nds32/mm/fault.c~mm-allow-vm_fault_retry-for-multiple-times
+++ a/arch/nds32/mm/fault.c
@@ -246,7 +246,6 @@ good_area:
 				      1, regs, addr);
 		}
 		if (fault & VM_FAULT_RETRY) {
-			flags &= ~FAULT_FLAG_ALLOW_RETRY;
 			flags |= FAULT_FLAG_TRIED;
 
 			/* No need to up_read(&mm->mmap_sem) as we would
--- a/arch/nios2/mm/fault.c~mm-allow-vm_fault_retry-for-multiple-times
+++ a/arch/nios2/mm/fault.c
@@ -157,9 +157,6 @@ good_area:
 		else
 			current->min_flt++;
 		if (fault & VM_FAULT_RETRY) {
-			/* Clear FAULT_FLAG_ALLOW_RETRY to avoid any risk
-			 * of starvation. */
-			flags &= ~FAULT_FLAG_ALLOW_RETRY;
 			flags |= FAULT_FLAG_TRIED;
 
 			/*
--- a/arch/openrisc/mm/fault.c~mm-allow-vm_fault_retry-for-multiple-times
+++ a/arch/openrisc/mm/fault.c
@@ -181,7 +181,6 @@ good_area:
 		else
 			tsk->min_flt++;
 		if (fault & VM_FAULT_RETRY) {
-			flags &= ~FAULT_FLAG_ALLOW_RETRY;
 			flags |= FAULT_FLAG_TRIED;
 
 			 /* No need to up_read(&mm->mmap_sem) as we would
--- a/arch/parisc/mm/fault.c~mm-allow-vm_fault_retry-for-multiple-times
+++ a/arch/parisc/mm/fault.c
@@ -328,14 +328,12 @@ good_area:
 		else
 			current->min_flt++;
 		if (fault & VM_FAULT_RETRY) {
-			flags &= ~FAULT_FLAG_ALLOW_RETRY;
-
 			/*
 			 * No need to up_read(&mm->mmap_sem) as we would
 			 * have already released it in __lock_page_or_retry
 			 * in mm/filemap.c.
 			 */
-
+			flags |= FAULT_FLAG_TRIED;
 			goto retry;
 		}
 	}
--- a/arch/powerpc/mm/fault.c~mm-allow-vm_fault_retry-for-multiple-times
+++ a/arch/powerpc/mm/fault.c
@@ -590,13 +590,7 @@ good_area:
 	 * case.
 	 */
 	if (unlikely(fault & VM_FAULT_RETRY)) {
-		/* We retry only once */
 		if (flags & FAULT_FLAG_ALLOW_RETRY) {
-			/*
-			 * Clear FAULT_FLAG_ALLOW_RETRY to avoid any risk
-			 * of starvation.
-			 */
-			flags &= ~FAULT_FLAG_ALLOW_RETRY;
 			flags |= FAULT_FLAG_TRIED;
 			goto retry;
 		}
--- a/arch/riscv/mm/fault.c~mm-allow-vm_fault_retry-for-multiple-times
+++ a/arch/riscv/mm/fault.c
@@ -144,11 +144,6 @@ good_area:
 				      1, regs, addr);
 		}
 		if (fault & VM_FAULT_RETRY) {
-			/*
-			 * Clear FAULT_FLAG_ALLOW_RETRY to avoid any risk
-			 * of starvation.
-			 */
-			flags &= ~(FAULT_FLAG_ALLOW_RETRY);
 			flags |= FAULT_FLAG_TRIED;
 
 			/*
--- a/arch/s390/mm/fault.c~mm-allow-vm_fault_retry-for-multiple-times
+++ a/arch/s390/mm/fault.c
@@ -513,10 +513,7 @@ retry:
 				fault = VM_FAULT_PFAULT;
 				goto out_up;
 			}
-			/* Clear FAULT_FLAG_ALLOW_RETRY to avoid any risk
-			 * of starvation. */
-			flags &= ~(FAULT_FLAG_ALLOW_RETRY |
-				   FAULT_FLAG_RETRY_NOWAIT);
+			flags &= ~FAULT_FLAG_RETRY_NOWAIT;
 			flags |= FAULT_FLAG_TRIED;
 			down_read(&mm->mmap_sem);
 			goto retry;
--- a/arch/sh/mm/fault.c~mm-allow-vm_fault_retry-for-multiple-times
+++ a/arch/sh/mm/fault.c
@@ -481,7 +481,6 @@ good_area:
 				      regs, address);
 		}
 		if (fault & VM_FAULT_RETRY) {
-			flags &= ~FAULT_FLAG_ALLOW_RETRY;
 			flags |= FAULT_FLAG_TRIED;
 
 			/*
--- a/arch/sparc/mm/fault_32.c~mm-allow-vm_fault_retry-for-multiple-times
+++ a/arch/sparc/mm/fault_32.c
@@ -261,7 +261,6 @@ good_area:
 				      1, regs, address);
 		}
 		if (fault & VM_FAULT_RETRY) {
-			flags &= ~FAULT_FLAG_ALLOW_RETRY;
 			flags |= FAULT_FLAG_TRIED;
 
 			/* No need to up_read(&mm->mmap_sem) as we would
--- a/arch/sparc/mm/fault_64.c~mm-allow-vm_fault_retry-for-multiple-times
+++ a/arch/sparc/mm/fault_64.c
@@ -449,7 +449,6 @@ good_area:
 				      1, regs, address);
 		}
 		if (fault & VM_FAULT_RETRY) {
-			flags &= ~FAULT_FLAG_ALLOW_RETRY;
 			flags |= FAULT_FLAG_TRIED;
 
 			/* No need to up_read(&mm->mmap_sem) as we would
--- a/arch/um/kernel/trap.c~mm-allow-vm_fault_retry-for-multiple-times
+++ a/arch/um/kernel/trap.c
@@ -97,7 +97,6 @@ good_area:
 			else
 				current->min_flt++;
 			if (fault & VM_FAULT_RETRY) {
-				flags &= ~FAULT_FLAG_ALLOW_RETRY;
 				flags |= FAULT_FLAG_TRIED;
 
 				goto retry;
--- a/arch/unicore32/mm/fault.c~mm-allow-vm_fault_retry-for-multiple-times
+++ a/arch/unicore32/mm/fault.c
@@ -259,9 +259,7 @@ retry:
 		else
 			tsk->min_flt++;
 		if (fault & VM_FAULT_RETRY) {
-			/* Clear FAULT_FLAG_ALLOW_RETRY to avoid any risk
-			* of starvation. */
-			flags &= ~FAULT_FLAG_ALLOW_RETRY;
+			flags |= FAULT_FLAG_TRIED;
 			goto retry;
 		}
 	}
--- a/arch/x86/mm/fault.c~mm-allow-vm_fault_retry-for-multiple-times
+++ a/arch/x86/mm/fault.c
@@ -1479,8 +1479,6 @@ good_area:
 	 */
 	if (unlikely((fault & VM_FAULT_RETRY) &&
 		     (flags & FAULT_FLAG_ALLOW_RETRY))) {
-		/* Retry at most once */
-		flags &= ~FAULT_FLAG_ALLOW_RETRY;
 		flags |= FAULT_FLAG_TRIED;
 		goto retry;
 	}
--- a/arch/xtensa/mm/fault.c~mm-allow-vm_fault_retry-for-multiple-times
+++ a/arch/xtensa/mm/fault.c
@@ -128,7 +128,6 @@ good_area:
 		else
 			current->min_flt++;
 		if (fault & VM_FAULT_RETRY) {
-			flags &= ~FAULT_FLAG_ALLOW_RETRY;
 			flags |= FAULT_FLAG_TRIED;
 
 			 /* No need to up_read(&mm->mmap_sem) as we would
--- a/drivers/gpu/drm/ttm/ttm_bo_vm.c~mm-allow-vm_fault_retry-for-multiple-times
+++ a/drivers/gpu/drm/ttm/ttm_bo_vm.c
@@ -59,9 +59,10 @@ static vm_fault_t ttm_bo_vm_fault_idle(s
 
 	/*
 	 * If possible, avoid waiting for GPU with mmap_sem
-	 * held.
+	 * held.  We only do this if the fault allows retry and this
+	 * is the first attempt.
 	 */
-	if (vmf->flags & FAULT_FLAG_ALLOW_RETRY) {
+	if (fault_flag_allow_retry_first(vmf->flags)) {
 		ret = VM_FAULT_RETRY;
 		if (vmf->flags & FAULT_FLAG_RETRY_NOWAIT)
 			goto out_unlock;
@@ -135,7 +136,12 @@ vm_fault_t ttm_bo_vm_reserve(struct ttm_
 	 * for the buffer to become unreserved.
 	 */
 	if (unlikely(!dma_resv_trylock(bo->base.resv))) {
-		if (vmf->flags & FAULT_FLAG_ALLOW_RETRY) {
+		/*
+		 * If the fault allows retry and this is the first
+		 * fault attempt, we try to release the mmap_sem
+		 * before waiting
+		 */
+		if (fault_flag_allow_retry_first(vmf->flags)) {
 			if (!(vmf->flags & FAULT_FLAG_RETRY_NOWAIT)) {
 				ttm_bo_get(bo);
 				up_read(&vmf->vma->vm_mm->mmap_sem);
--- a/include/linux/mm.h~mm-allow-vm_fault_retry-for-multiple-times
+++ a/include/linux/mm.h
@@ -394,6 +394,25 @@ extern pgprot_t protection_map[16];
  * @FAULT_FLAG_REMOTE: The fault is not for current task/mm.
  * @FAULT_FLAG_INSTRUCTION: The fault was during an instruction fetch.
  * @FAULT_FLAG_INTERRUPTIBLE: The fault can be interrupted by non-fatal signals.
+ *
+ * About @FAULT_FLAG_ALLOW_RETRY and @FAULT_FLAG_TRIED: we can specify
+ * whether we would allow page faults to retry by specifying these two
+ * fault flags correctly.  Currently there can be three legal combinations:
+ *
+ * (a) ALLOW_RETRY and !TRIED:  this means the page fault allows retry, and
+ *                              this is the first try
+ *
+ * (b) ALLOW_RETRY and TRIED:   this means the page fault allows retry, and
+ *                              we've already tried at least once
+ *
+ * (c) !ALLOW_RETRY and !TRIED: this means the page fault does not allow retry
+ *
+ * The unlisted combination (!ALLOW_RETRY && TRIED) is illegal and should never
+ * be used.  Note that page faults can be allowed to retry for multiple times,
+ * in which case we'll have an initial fault with flags (a) then later on
+ * continuous faults with flags (b).  We should always try to detect pending
+ * signals before a retry to make sure the continuous page faults can still be
+ * interrupted if necessary.
  */
 #define FAULT_FLAG_WRITE			0x01
 #define FAULT_FLAG_MKWRITE			0x02
@@ -414,6 +433,24 @@ extern pgprot_t protection_map[16];
 			     FAULT_FLAG_KILLABLE | \
 			     FAULT_FLAG_INTERRUPTIBLE)
 
+/**
+ * fault_flag_allow_retry_first - check ALLOW_RETRY the first time
+ *
+ * This is mostly used for places where we want to try to avoid taking
+ * the mmap_sem for too long a time when waiting for another condition
+ * to change, in which case we can try to be polite to release the
+ * mmap_sem in the first round to avoid potential starvation of other
+ * processes that would also want the mmap_sem.
+ *
+ * Return: true if the page fault allows retry and this is the first
+ * attempt of the fault handling; false otherwise.
+ */
+static inline bool fault_flag_allow_retry_first(unsigned int flags)
+{
+	return (flags & FAULT_FLAG_ALLOW_RETRY) &&
+	    (!(flags & FAULT_FLAG_TRIED));
+}
+
 #define FAULT_FLAG_TRACE \
 	{ FAULT_FLAG_WRITE,		"WRITE" }, \
 	{ FAULT_FLAG_MKWRITE,		"MKWRITE" }, \
--- a/mm/filemap.c~mm-allow-vm_fault_retry-for-multiple-times
+++ a/mm/filemap.c
@@ -1386,7 +1386,7 @@ EXPORT_SYMBOL_GPL(__lock_page_killable);
 int __lock_page_or_retry(struct page *page, struct mm_struct *mm,
 			 unsigned int flags)
 {
-	if (flags & FAULT_FLAG_ALLOW_RETRY) {
+	if (fault_flag_allow_retry_first(flags)) {
 		/*
 		 * CAUTION! In this case, mmap_sem is not released
 		 * even though return 0.
--- a/mm/internal.h~mm-allow-vm_fault_retry-for-multiple-times
+++ a/mm/internal.h
@@ -400,10 +400,10 @@ static inline struct file *maybe_unlock_
 	/*
 	 * FAULT_FLAG_RETRY_NOWAIT means we don't want to wait on page locks or
 	 * anything, so we only pin the file and drop the mmap_sem if only
-	 * FAULT_FLAG_ALLOW_RETRY is set.
+	 * FAULT_FLAG_ALLOW_RETRY is set, while this is the first attempt.
 	 */
-	if ((flags & (FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_RETRY_NOWAIT)) ==
-	    FAULT_FLAG_ALLOW_RETRY) {
+	if (fault_flag_allow_retry_first(flags) &&
+	    !(flags & FAULT_FLAG_RETRY_NOWAIT)) {
 		fpin = get_file(vmf->vma->vm_file);
 		up_read(&vmf->vma->vm_mm->mmap_sem);
 	}
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-merge-parameters-for-change_protection.patch
userfaultfd-wp-apply-_page_uffd_wp-bit.patch
userfaultfd-wp-drop-_page_uffd_wp-properly-when-fork.patch
userfaultfd-wp-add-pmd_swp_uffd_wp-helpers.patch
userfaultfd-wp-support-swap-and-page-migration.patch
khugepaged-skip-collapse-if-uffd-wp-detected.patch
userfaultfd-wp-dont-wake-up-when-doing-write-protect.patch
userfaultfd-wp-declare-_uffdio_writeprotect-conditionally.patch
userfaultfd-selftests-refactor-statistics.patch
userfaultfd-selftests-add-write-protect-test.patch
