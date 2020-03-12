From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-fault_signal_pending-fix.patch added to
 -mm tree
Date: Wed, 11 Mar 2020 17:33:08 -0700
Message-ID: <20200312003308.m9p_ivQ-S%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731423AbgCLAdJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 11 Mar 2020 20:33:09 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lkp@intel.com, mm-commits@vger.kernel.org, peterx@redhat.com


The patch titled
     Subject: mm-introduce-fault_signal_pending-fix
has been added to the -mm tree.  Its filename is
     mm-introduce-fault_signal_pending-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-introduce-fault_signal_pending-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-introduce-fault_signal_pending-fix.patch

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
Subject: mm-introduce-fault_signal_pending-fix

fix sparse warnings

Link: http://lkml.kernel.org/r/20200311145921.GD479302@xz-x1
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/mm/fault.c         |    2 +-
 include/linux/sched/signal.h |    4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/arch/mips/mm/fault.c~mm-introduce-fault_signal_pending-fix
+++ a/arch/mips/mm/fault.c
@@ -154,7 +154,7 @@ good_area:
 	 */
 	fault = handle_mm_fault(vma, address, flags);
 
-	if (fault_signal_pending(regs))
+	if (fault_signal_pending(fault, regs))
 		return;
 
 	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
--- a/include/linux/sched/signal.h~mm-introduce-fault_signal_pending-fix
+++ a/include/linux/sched/signal.h
@@ -10,6 +10,8 @@
 #include <linux/cred.h>
 #include <linux/refcount.h>
 #include <linux/posix-timers.h>
+#include <linux/mm_types.h>
+#include <asm/ptrace.h>
 
 /*
  * Types defining task->signal and task->sighand and APIs using them:
@@ -375,7 +377,7 @@ static inline int signal_pending_state(l
  * instead, especially with the case where we've got interrupted with
  * a VM_FAULT_RETRY.
  */
-static inline bool fault_signal_pending(unsigned int fault_flags,
+static inline bool fault_signal_pending(vm_fault_t fault_flags,
 					struct pt_regs *regs)
 {
 	return unlikely((fault_flags & VM_FAULT_RETRY) &&
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-gup-rename-nonblocking-to-locked-where-proper.patch
mm-gup-fix-__get_user_pages-on-fault-retry-of-hugetlb.patch
mm-introduce-fault_signal_pending.patch
mm-introduce-fault_signal_pending-fix.patch
x86-mm-use-helper-fault_signal_pending.patch
arc-mm-use-helper-fault_signal_pending.patch
arm64-mm-use-helper-fault_signal_pending.patch
powerpc-mm-use-helper-fault_signal_pending.patch
sh-mm-use-helper-fault_signal_pending.patch
mm-return-faster-for-non-fatal-signals-in-user-mode-faults.patch
userfaultfd-dont-retake-mmap_sem-to-emulate-nopage.patch
mm-introduce-fault_flag_default.patch
mm-introduce-fault_flag_interruptible.patch
mm-allow-vm_fault_retry-for-multiple-times.patch
mm-gup-allow-vm_fault_retry-for-multiple-times.patch
mm-gup-allow-to-react-to-fatal-signals.patch
mm-userfaultfd-honor-fault_flag_killable-in-fault-path.patch
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
