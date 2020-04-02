From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-introduce-fault_signal_pending-fix.patch removed from -mm tree
Date: Wed, 01 Apr 2020 20:29:46 -0700
Message-ID: <20200402032946.wGDLMovCR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733251AbgDBD3s (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 1 Apr 2020 23:29:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lkp@intel.com, mm-commits@vger.kernel.org, peterx@redhat.com


The patch titled
     Subject: mm-introduce-fault_signal_pending-fix
has been removed from the -mm tree.  Its filename was
     mm-introduce-fault_signal_pending-fix.patch

This patch was dropped because it was folded into mm-introduce-fault_signal_pending.patch

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
