From: akpm@linux-foundation.org
Subject: + ptrace-arm-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch added to -mm tree
Date: Mon, 13 May 2013 16:06:50 -0700
Message-ID: <20130513230650.EE3C05A4211@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:40241 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136Ab3EMXGw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 May 2013 19:06:52 -0400
Received: by mail-qc0-f202.google.com with SMTP id d1so668756qcz.5
        for <mm-commits@vger.kernel.org>; Mon, 13 May 2013 16:06:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, benh@kernel.crashing.org, fweisbec@gmail.com, jan.kratochvil@redhat.com, lethal@linux-sh.org, linux@arm.linux.org.uk, mikey@neuling.org, mingo@kernel.org, paulus@samba.org, prasad@linux.vnet.ibm.com, will.deacon@arm.com


The patch titled
     Subject: ptrace/arm: revert "hw_breakpoints: Fix racy access to ptrace breakpoints"
has been added to the -mm tree.  Its filename is
     ptrace-arm-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch

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
Subject: ptrace/arm: revert "hw_breakpoints: Fix racy access to ptrace breakpoints"

This reverts commit bf0b8f4b55e ("hw_breakpoints: Fix racy access to
ptrace breakpoints").

The patch was fine but we can no longer race with SIGKILL after 9899d11f
("ptrace: ensure arch_ptrace/ptrace_request can never race with SIGKILL"),
the __TASK_TRACED tracee can't be woken up and ->ptrace_bps[] can't go
away.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Michael Neuling <mikey@neuling.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/ptrace.c |    8 --------
 1 file changed, 8 deletions(-)

diff -puN arch/arm/kernel/ptrace.c~ptrace-arm-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints arch/arm/kernel/ptrace.c
--- a/arch/arm/kernel/ptrace.c~ptrace-arm-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints
+++ a/arch/arm/kernel/ptrace.c
@@ -886,20 +886,12 @@ long arch_ptrace(struct task_struct *chi
 
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 		case PTRACE_GETHBPREGS:
-			if (ptrace_get_breakpoints(child) < 0)
-				return -ESRCH;
-
 			ret = ptrace_gethbpregs(child, addr,
 						(unsigned long __user *)data);
-			ptrace_put_breakpoints(child);
 			break;
 		case PTRACE_SETHBPREGS:
-			if (ptrace_get_breakpoints(child) < 0)
-				return -ESRCH;
-
 			ret = ptrace_sethbpregs(child, addr,
 						(unsigned long __user *)data);
-			ptrace_put_breakpoints(child);
 			break;
 #endif
 
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

