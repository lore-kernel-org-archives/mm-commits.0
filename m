From: akpm@linux-foundation.org
Subject: + ptrace-powerpc-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch added to -mm tree
Date: Mon, 13 May 2013 16:06:47 -0700
Message-ID: <20130513230647.F28D231C1D4@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:49034 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136Ab3EMXGt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 May 2013 19:06:49 -0400
Received: by mail-yh0-f73.google.com with SMTP id a41so669822yho.2
        for <mm-commits@vger.kernel.org>; Mon, 13 May 2013 16:06:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, benh@kernel.crashing.org, fweisbec@gmail.com, jan.kratochvil@redhat.com, lethal@linux-sh.org, linux@arm.linux.org.uk, mikey@neuling.org, mingo@kernel.org, paulus@samba.org, prasad@linux.vnet.ibm.com, will.deacon@arm.com


The patch titled
     Subject: ptrace/powerpc: revert "hw_breakpoints: Fix racy access to ptrace breakpoints"
has been added to the -mm tree.  Its filename is
     ptrace-powerpc-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: ptrace/powerpc: revert "hw_breakpoints: Fix racy access to ptrace breakpoints"

This reverts commit 07fa7a0a8a586 ("hw_breakpoints: Fix racy access to
ptrace breakpoints") and removes ptrace_get/put_breakpoints() added by
other commits.

The patch was fine but we can no longer race with SIGKILL after 9899d11f
("ptrace: ensure arch_ptrace/ptrace_request can never race with SIGKILL"),
the __TASK_TRACED tracee can't be woken up and ->ptrace_bps[] can't go
away.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Michael Neuling <mikey@neuling.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/ptrace.c |   20 --------------------
 1 file changed, 20 deletions(-)

diff -puN arch/powerpc/kernel/ptrace.c~ptrace-powerpc-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints arch/powerpc/kernel/ptrace.c
--- a/arch/powerpc/kernel/ptrace.c~ptrace-powerpc-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints
+++ a/arch/powerpc/kernel/ptrace.c
@@ -974,16 +974,12 @@ int ptrace_set_debugreg(struct task_stru
 	hw_brk.type = (data & HW_BRK_TYPE_DABR) | HW_BRK_TYPE_PRIV_ALL;
 	hw_brk.len = 8;
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
-	if (ptrace_get_breakpoints(task) < 0)
-		return -ESRCH;
-
 	bp = thread->ptrace_bps[0];
 	if ((!data) || !(hw_brk.type & HW_BRK_TYPE_RDWR)) {
 		if (bp) {
 			unregister_hw_breakpoint(bp);
 			thread->ptrace_bps[0] = NULL;
 		}
-		ptrace_put_breakpoints(task);
 		return 0;
 	}
 	if (bp) {
@@ -996,11 +992,9 @@ int ptrace_set_debugreg(struct task_stru
 
 		ret =  modify_user_hw_breakpoint(bp, &attr);
 		if (ret) {
-			ptrace_put_breakpoints(task);
 			return ret;
 		}
 		thread->ptrace_bps[0] = bp;
-		ptrace_put_breakpoints(task);
 		thread->hw_brk = hw_brk;
 		return 0;
 	}
@@ -1015,12 +1009,9 @@ int ptrace_set_debugreg(struct task_stru
 					       ptrace_triggered, NULL, task);
 	if (IS_ERR(bp)) {
 		thread->ptrace_bps[0] = NULL;
-		ptrace_put_breakpoints(task);
 		return PTR_ERR(bp);
 	}
 
-	ptrace_put_breakpoints(task);
-
 #endif /* CONFIG_HAVE_HW_BREAKPOINT */
 	task->thread.hw_brk = hw_brk;
 #else /* CONFIG_PPC_ADV_DEBUG_REGS */
@@ -1439,9 +1430,6 @@ static long ppc_set_hwdebug(struct task_
 	if (bp_info->trigger_type & PPC_BREAKPOINT_TRIGGER_WRITE)
 		brk.type |= HW_BRK_TYPE_WRITE;
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
-	if (ptrace_get_breakpoints(child) < 0)
-		return -ESRCH;
-
 	/*
 	 * Check if the request is for 'range' breakpoints. We can
 	 * support it if range < 8 bytes.
@@ -1449,12 +1437,10 @@ static long ppc_set_hwdebug(struct task_
 	if (bp_info->addr_mode == PPC_BREAKPOINT_MODE_RANGE_INCLUSIVE) {
 		len = bp_info->addr2 - bp_info->addr;
 	} else if (bp_info->addr_mode != PPC_BREAKPOINT_MODE_EXACT) {
-		ptrace_put_breakpoints(child);
 		return -EINVAL;
 	}
 	bp = thread->ptrace_bps[0];
 	if (bp) {
-		ptrace_put_breakpoints(child);
 		return -ENOSPC;
 	}
 
@@ -1468,11 +1454,9 @@ static long ppc_set_hwdebug(struct task_
 					       ptrace_triggered, NULL, child);
 	if (IS_ERR(bp)) {
 		thread->ptrace_bps[0] = NULL;
-		ptrace_put_breakpoints(child);
 		return PTR_ERR(bp);
 	}
 
-	ptrace_put_breakpoints(child);
 	return 1;
 #endif /* CONFIG_HAVE_HW_BREAKPOINT */
 
@@ -1516,16 +1500,12 @@ static long ppc_del_hwdebug(struct task_
 		return -EINVAL;
 
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
-	if (ptrace_get_breakpoints(child) < 0)
-		return -ESRCH;
-
 	bp = thread->ptrace_bps[0];
 	if (bp) {
 		unregister_hw_breakpoint(bp);
 		thread->ptrace_bps[0] = NULL;
 	} else
 		ret = -ENOENT;
-	ptrace_put_breakpoints(child);
 	return ret;
 #else /* CONFIG_HAVE_HW_BREAKPOINT */
 	if (child->thread.hw_brk.address == 0)
_

Patches currently in -mm which might be from oleg@redhat.com are

posix_cpu_timer-consolidate-expiry-time-type.patch
posix_cpu_timers-consolidate-timer-list-cleanups.patch
posix_cpu_timers-consolidate-expired-timers-check.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
posix_timers-fix-racy-timer-delta-caching-on-task-exit.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch
ptrace-x86-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch
ptrace-powerpc-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch
ptrace-arm-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch
ptrace-sh-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch
ptrace-revert-prepare-to-fix-racy-accesses-on-task-breakpoints.patch
ptrace-x86-simplify-the-disable-logic-in-ptrace_write_dr7.patch
ptrace-x86-dont-delay-disable-till-second-pass-in-ptrace_write_dr7.patch
ptrace-x86-introduce-ptrace_register_breakpoint.patch
ptrace-x86-ptrace_write_dr7-should-create-bp-if-disabled.patch
ptrace-x86-cleanup-ptrace_set_debugreg.patch
ptrace-ptrace_detach-should-do-flush_ptrace_hw_breakpointchild.patch
ptrace-x86-flush_ptrace_hw_breakpoint-shoule-clear-the-virtual-debug-registers.patch
x86-kill-tif_debug.patch

