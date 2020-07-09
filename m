From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-csky-use-general-page-fault-accounting.patch added
 to -mm tree
Date: Wed, 08 Jul 2020 17:06:49 -0700
Message-ID: <20200709000649.jEBSS5Ia-%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725972AbgGIAGu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 8 Jul 2020 20:06:50 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guoren@kernel.org, mm-commits@vger.kernel.org, peterx@redhat.com


The patch titled
     Subject: mm/csky: use general page fault accounting
has been added to the -mm tree.  Its filename is
     mm-csky-use-general-page-fault-accounting.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-csky-use-general-page-fault-accounting.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-csky-use-general-page-fault-accounting.patch

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
Subject: mm/csky: use general page fault accounting

Use the general page fault accounting by passing regs into
handle_mm_fault().  It naturally solve the issue of multiple page fault
accounting when page fault retry happened.

Link: http://lkml.kernel.org/r/20200707225021.200906-7-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Acked-by: Guo Ren <guoren@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/csky/mm/fault.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

--- a/arch/csky/mm/fault.c~mm-csky-use-general-page-fault-accounting
+++ a/arch/csky/mm/fault.c
@@ -151,7 +151,7 @@ good_area:
 	 * the fault.
 	 */
 	fault = handle_mm_fault(vma, address, write ? FAULT_FLAG_WRITE : 0,
-				NULL);
+				regs);
 	if (unlikely(fault & VM_FAULT_ERROR)) {
 		if (fault & VM_FAULT_OOM)
 			goto out_of_memory;
@@ -161,16 +161,6 @@ good_area:
 			goto bad_area;
 		BUG();
 	}
-	if (fault & VM_FAULT_MAJOR) {
-		tsk->maj_flt++;
-		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1, regs,
-			      address);
-	} else {
-		tsk->min_flt++;
-		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1, regs,
-			      address);
-	}
-
 	mmap_read_unlock(mm);
 	return;
 
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
