From: akpm@linux-foundation.org
Subject: [merged] mm-introduce-fault_signal_pending.patch removed
 from -mm tree
Date: Fri, 03 Apr 2020 13:38:24 -0700
Message-ID: <20200403203824.wLZ-avkSB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgDCUi2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:38:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, bgeffon@google.com, bobbypowers@gmail.com, cracauer@cons.org, david@redhat.com, dgilbert@redhat.com, dplotnikov@virtuozzo.com, gokhale2@llnl.gov, hannes@cmpxchg.org, hughd@google.com, jglisse@redhat.com, kirill@shutemov.name, mcfadden8@llnl.gov, mgorman@suse.de, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, peterx@redhat.com, rppt@linux.vnet.ibm.com, torvalds@linux-foundation.org, willy@infradead.org, xemul@openvz.org


The patch titled
     Subject: mm: introduce fault_signal_pending()
has been removed from the -mm tree.  Its filename was
     mm-introduce-fault_signal_pending.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm: introduce fault_signal_pending()

For most architectures, we've got a quick path to detect fatal signal
after a handle_mm_fault().  Introduce a helper for that quick path.

It cleans the current codes a bit so we don't need to duplicate the same
check across archs.  More importantly, this will be an unified place that
we handle the signal immediately right after an interrupted page fault, so
it'll be much easier for us if we want to change the behavior of handling
signals later on for all the archs.

Note that currently only part of the archs are using this new helper,
because some archs have their own way to handle signals.  In the follow up
patches, we'll try to apply this helper to all the rest of archs.

Another note is that the "regs" parameter in the new helper is not used
yet.  It'll be used very soon.  Now we kept it in this patch only to avoid
touching all the archs again in the follow up patches.

[peterx@redhat.com: fix sparse warnings]
  Link: http://lkml.kernel.org/r/20200311145921.GD479302@xz-x1
Link: http://lkml.kernel.org/r/20200220155353.8676-4-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Tested-by: Brian Geffon <bgeffon@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Bobby Powers <bobbypowers@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Denis Plotnikov <dplotnikov@virtuozzo.com>
Cc: "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
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

 arch/alpha/mm/fault.c        |    2 +-
 arch/arm/mm/fault.c          |    2 +-
 arch/hexagon/mm/vm_fault.c   |    2 +-
 arch/ia64/mm/fault.c         |    2 +-
 arch/m68k/mm/fault.c         |    2 +-
 arch/microblaze/mm/fault.c   |    2 +-
 arch/mips/mm/fault.c         |    2 +-
 arch/nds32/mm/fault.c        |    2 +-
 arch/nios2/mm/fault.c        |    2 +-
 arch/openrisc/mm/fault.c     |    2 +-
 arch/parisc/mm/fault.c       |    2 +-
 arch/riscv/mm/fault.c        |    2 +-
 arch/s390/mm/fault.c         |    3 +--
 arch/sparc/mm/fault_32.c     |    2 +-
 arch/sparc/mm/fault_64.c     |    2 +-
 arch/unicore32/mm/fault.c    |    2 +-
 arch/xtensa/mm/fault.c       |    2 +-
 include/linux/sched/signal.h |   15 +++++++++++++++
 18 files changed, 32 insertions(+), 18 deletions(-)

--- a/arch/alpha/mm/fault.c~mm-introduce-fault_signal_pending
+++ a/arch/alpha/mm/fault.c
@@ -150,7 +150,7 @@ retry:
 	   the fault.  */
 	fault = handle_mm_fault(vma, address, flags);
 
-	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
+	if (fault_signal_pending(fault, regs))
 		return;
 
 	if (unlikely(fault & VM_FAULT_ERROR)) {
--- a/arch/arm/mm/fault.c~mm-introduce-fault_signal_pending
+++ a/arch/arm/mm/fault.c
@@ -295,7 +295,7 @@ retry:
 	 * signal first. We do not need to release the mmap_sem because
 	 * it would already be released in __lock_page_or_retry in
 	 * mm/filemap.c. */
-	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current)) {
+	if (fault_signal_pending(fault, regs)) {
 		if (!user_mode(regs))
 			goto no_context;
 		return 0;
--- a/arch/hexagon/mm/vm_fault.c~mm-introduce-fault_signal_pending
+++ a/arch/hexagon/mm/vm_fault.c
@@ -91,7 +91,7 @@ good_area:
 
 	fault = handle_mm_fault(vma, address, flags);
 
-	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
+	if (fault_signal_pending(fault, regs))
 		return;
 
 	/* The most common case -- we are done. */
--- a/arch/ia64/mm/fault.c~mm-introduce-fault_signal_pending
+++ a/arch/ia64/mm/fault.c
@@ -141,7 +141,7 @@ retry:
 	 */
 	fault = handle_mm_fault(vma, address, flags);
 
-	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
+	if (fault_signal_pending(fault, regs))
 		return;
 
 	if (unlikely(fault & VM_FAULT_ERROR)) {
--- a/arch/m68k/mm/fault.c~mm-introduce-fault_signal_pending
+++ a/arch/m68k/mm/fault.c
@@ -138,7 +138,7 @@ good_area:
 	fault = handle_mm_fault(vma, address, flags);
 	pr_debug("handle_mm_fault returns %x\n", fault);
 
-	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
+	if (fault_signal_pending(fault, regs))
 		return 0;
 
 	if (unlikely(fault & VM_FAULT_ERROR)) {
--- a/arch/microblaze/mm/fault.c~mm-introduce-fault_signal_pending
+++ a/arch/microblaze/mm/fault.c
@@ -217,7 +217,7 @@ good_area:
 	 */
 	fault = handle_mm_fault(vma, address, flags);
 
-	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
+	if (fault_signal_pending(fault, regs))
 		return;
 
 	if (unlikely(fault & VM_FAULT_ERROR)) {
--- a/arch/mips/mm/fault.c~mm-introduce-fault_signal_pending
+++ a/arch/mips/mm/fault.c
@@ -154,7 +154,7 @@ good_area:
 	 */
 	fault = handle_mm_fault(vma, address, flags);
 
-	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
+	if (fault_signal_pending(fault, regs))
 		return;
 
 	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
--- a/arch/nds32/mm/fault.c~mm-introduce-fault_signal_pending
+++ a/arch/nds32/mm/fault.c
@@ -214,7 +214,7 @@ good_area:
 	 * signal first. We do not need to release the mmap_sem because it
 	 * would already be released in __lock_page_or_retry in mm/filemap.c.
 	 */
-	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current)) {
+	if (fault_signal_pending(fault, regs)) {
 		if (!user_mode(regs))
 			goto no_context;
 		return;
--- a/arch/nios2/mm/fault.c~mm-introduce-fault_signal_pending
+++ a/arch/nios2/mm/fault.c
@@ -133,7 +133,7 @@ good_area:
 	 */
 	fault = handle_mm_fault(vma, address, flags);
 
-	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
+	if (fault_signal_pending(fault, regs))
 		return;
 
 	if (unlikely(fault & VM_FAULT_ERROR)) {
--- a/arch/openrisc/mm/fault.c~mm-introduce-fault_signal_pending
+++ a/arch/openrisc/mm/fault.c
@@ -161,7 +161,7 @@ good_area:
 
 	fault = handle_mm_fault(vma, address, flags);
 
-	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
+	if (fault_signal_pending(fault, regs))
 		return;
 
 	if (unlikely(fault & VM_FAULT_ERROR)) {
--- a/arch/parisc/mm/fault.c~mm-introduce-fault_signal_pending
+++ a/arch/parisc/mm/fault.c
@@ -304,7 +304,7 @@ good_area:
 
 	fault = handle_mm_fault(vma, address, flags);
 
-	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
+	if (fault_signal_pending(fault, regs))
 		return;
 
 	if (unlikely(fault & VM_FAULT_ERROR)) {
--- a/arch/riscv/mm/fault.c~mm-introduce-fault_signal_pending
+++ a/arch/riscv/mm/fault.c
@@ -117,7 +117,7 @@ good_area:
 	 * signal first. We do not need to release the mmap_sem because it
 	 * would already be released in __lock_page_or_retry in mm/filemap.c.
 	 */
-	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(tsk))
+	if (fault_signal_pending(fault, regs))
 		return;
 
 	if (unlikely(fault & VM_FAULT_ERROR)) {
--- a/arch/s390/mm/fault.c~mm-introduce-fault_signal_pending
+++ a/arch/s390/mm/fault.c
@@ -480,8 +480,7 @@ retry:
 	 * the fault.
 	 */
 	fault = handle_mm_fault(vma, address, flags);
-	/* No reason to continue if interrupted by SIGKILL. */
-	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current)) {
+	if (fault_signal_pending(fault, regs)) {
 		fault = VM_FAULT_SIGNAL;
 		if (flags & FAULT_FLAG_RETRY_NOWAIT)
 			goto out_up;
--- a/arch/sparc/mm/fault_32.c~mm-introduce-fault_signal_pending
+++ a/arch/sparc/mm/fault_32.c
@@ -237,7 +237,7 @@ good_area:
 	 */
 	fault = handle_mm_fault(vma, address, flags);
 
-	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
+	if (fault_signal_pending(fault, regs))
 		return;
 
 	if (unlikely(fault & VM_FAULT_ERROR)) {
--- a/arch/sparc/mm/fault_64.c~mm-introduce-fault_signal_pending
+++ a/arch/sparc/mm/fault_64.c
@@ -425,7 +425,7 @@ good_area:
 
 	fault = handle_mm_fault(vma, address, flags);
 
-	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
+	if (fault_signal_pending(fault, regs))
 		goto exit_exception;
 
 	if (unlikely(fault & VM_FAULT_ERROR)) {
--- a/arch/unicore32/mm/fault.c~mm-introduce-fault_signal_pending
+++ a/arch/unicore32/mm/fault.c
@@ -250,7 +250,7 @@ retry:
 	 * signal first. We do not need to release the mmap_sem because
 	 * it would already be released in __lock_page_or_retry in
 	 * mm/filemap.c. */
-	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
+	if (fault_signal_pending(fault, regs))
 		return 0;
 
 	if (!(fault & VM_FAULT_ERROR) && (flags & FAULT_FLAG_ALLOW_RETRY)) {
--- a/arch/xtensa/mm/fault.c~mm-introduce-fault_signal_pending
+++ a/arch/xtensa/mm/fault.c
@@ -110,7 +110,7 @@ good_area:
 	 */
 	fault = handle_mm_fault(vma, address, flags);
 
-	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
+	if (fault_signal_pending(fault, regs))
 		return;
 
 	if (unlikely(fault & VM_FAULT_ERROR)) {
--- a/include/linux/sched/signal.h~mm-introduce-fault_signal_pending
+++ a/include/linux/sched/signal.h
@@ -10,6 +10,8 @@
 #include <linux/cred.h>
 #include <linux/refcount.h>
 #include <linux/posix-timers.h>
+#include <linux/mm_types.h>
+#include <asm/ptrace.h>
 
 /*
  * Types defining task->signal and task->sighand and APIs using them:
@@ -370,6 +372,19 @@ static inline int signal_pending_state(l
 }
 
 /*
+ * This should only be used in fault handlers to decide whether we
+ * should stop the current fault routine to handle the signals
+ * instead, especially with the case where we've got interrupted with
+ * a VM_FAULT_RETRY.
+ */
+static inline bool fault_signal_pending(vm_fault_t fault_flags,
+					struct pt_regs *regs)
+{
+	return unlikely((fault_flags & VM_FAULT_RETRY) &&
+			fatal_signal_pending(current));
+}
+
+/*
  * Reevaluate whether the task has signals pending delivery.
  * Wake the task if so.
  * This is required every time the blocked sigset_t changes.
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
