From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mips-use-general-page-fault-accounting.patch added
 to -mm tree
Date: Wed, 08 Jul 2020 17:06:59 -0700
Message-ID: <20200709000659.O70Uu76gh%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725972AbgGIAHA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 8 Jul 2020 20:07:00 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, peterx@redhat.com, tsbogend@alpha.franken.de


The patch titled
     Subject: mm/mips: use general page fault accounting
has been added to the -mm tree.  Its filename is
     mm-mips-use-general-page-fault-accounting.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mips-use-general-page-fault-accounting.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mips-use-general-page-fault-accounting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/mips: use general page fault accounting

Use the general page fault accounting by passing regs into
handle_mm_fault().  It naturally solve the issue of multiple page fault
accounting when page fault retry happened.

Fix PERF_COUNT_SW_PAGE_FAULTS perf event manually for page fault retries,
by moving it before taking mmap_sem.

Link: http://lkml.kernel.org/r/20200707225021.200906-12-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Acked-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/mm/fault.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

--- a/arch/mips/mm/fault.c~mm-mips-use-general-page-fault-accounting
+++ a/arch/mips/mm/fault.c
@@ -96,6 +96,8 @@ static void __kprobes __do_page_fault(st
 
 	if (user_mode(regs))
 		flags |= FAULT_FLAG_USER;
+
+	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
 retry:
 	mmap_read_lock(mm);
 	vma = find_vma(mm, address);
@@ -152,12 +154,11 @@ good_area:
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.
 	 */
-	fault = handle_mm_fault(vma, address, flags, NULL);
+	fault = handle_mm_fault(vma, address, flags, regs);
 
 	if (fault_signal_pending(fault, regs))
 		return;
 
-	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
 	if (unlikely(fault & VM_FAULT_ERROR)) {
 		if (fault & VM_FAULT_OOM)
 			goto out_of_memory;
@@ -168,15 +169,6 @@ good_area:
 		BUG();
 	}
 	if (flags & FAULT_FLAG_ALLOW_RETRY) {
-		if (fault & VM_FAULT_MAJOR) {
-			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1,
-						  regs, address);
-			tsk->maj_flt++;
-		} else {
-			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1,
-						  regs, address);
-			tsk->min_flt++;
-		}
 		if (fault & VM_FAULT_RETRY) {
 			flags |= FAULT_FLAG_TRIED;
 
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-do-page-fault-accounting-in-handle_mm_fault.patch
mm-alpha-use-general-page-fault-accounting.patch
mm-arc-use-general-page-fault-accounting.patch
mm-arm-use-general-page-fault-accounting.patch
mm-arm64-use-general-page-fault-accounting.patch
mm-csky-use-general-page-fault-accounting.patch
mm-hexagon-use-general-page-fault-accounting.patch
mm-ia64-use-general-page-fault-accounting.patch
mm-m68k-use-general-page-fault-accounting.patch
mm-microblaze-use-general-page-fault-accounting.patch
mm-mips-use-general-page-fault-accounting.patch
mm-nds32-use-general-page-fault-accounting.patch
mm-nios2-use-general-page-fault-accounting.patch
mm-openrisc-use-general-page-fault-accounting.patch
mm-parisc-use-general-page-fault-accounting.patch
mm-powerpc-use-general-page-fault-accounting.patch
mm-riscv-use-general-page-fault-accounting.patch
mm-s390-use-general-page-fault-accounting.patch
mm-sh-use-general-page-fault-accounting.patch
mm-sparc32-use-general-page-fault-accounting.patch
mm-sparc64-use-general-page-fault-accounting.patch
mm-x86-use-general-page-fault-accounting.patch
mm-xtensa-use-general-page-fault-accounting.patch
mm-clean-up-the-last-pieces-of-page-fault-accountings.patch
mm-gup-remove-task_struct-pointer-for-all-gup-code.patch
