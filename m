From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-powerpc-use-general-page-fault-accounting.patch
 added to -mm tree
Date: Wed, 08 Jul 2020 17:07:10 -0700
Message-ID: <20200709000710.4pYvBK1DB%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726171AbgGIAHL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 8 Jul 2020 20:07:11 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, paulus@samba.org, peterx@redhat.com


The patch titled
     Subject: mm/powerpc: use general page fault accounting
has been added to the -mm tree.  Its filename is
     mm-powerpc-use-general-page-fault-accounting.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-powerpc-use-general-page-fault-accounting.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-powerpc-use-general-page-fault-accounting.patch

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
Subject: mm/powerpc: use general page fault accounting

Use the general page fault accounting by passing regs into
handle_mm_fault().

Link: http://lkml.kernel.org/r/20200707225021.200906-17-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/fault.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/arch/powerpc/mm/fault.c~mm-powerpc-use-general-page-fault-accounting
+++ a/arch/powerpc/mm/fault.c
@@ -607,7 +607,7 @@ good_area:
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.
 	 */
-	fault = handle_mm_fault(vma, address, flags, NULL);
+	fault = handle_mm_fault(vma, address, flags, regs);
 
 	major |= fault & VM_FAULT_MAJOR;
 
@@ -633,14 +633,9 @@ good_area:
 	/*
 	 * Major/minor page fault accounting.
 	 */
-	if (major) {
-		current->maj_flt++;
-		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1, regs, address);
+	if (major)
 		cmo_account_page_fault();
-	} else {
-		current->min_flt++;
-		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1, regs, address);
-	}
+
 	return 0;
 }
 NOKPROBE_SYMBOL(__do_page_fault);
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
