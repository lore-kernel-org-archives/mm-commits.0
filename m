From: akpm@linux-foundation.org
Subject: + x86-kill-tif_debug.patch added to -mm tree
Date: Mon, 13 May 2013 16:07:20 -0700
Message-ID: <20130513230720.EA0EA31C1D4@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:34542 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136Ab3EMXHW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 May 2013 19:07:22 -0400
Received: by mail-ye0-f202.google.com with SMTP id r13so668241yen.1
        for <mm-commits@vger.kernel.org>; Mon, 13 May 2013 16:07:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, benh@kernel.crashing.org, fweisbec@gmail.com, jan.kratochvil@redhat.com, lethal@linux-sh.org, linux@arm.linux.org.uk, mikey@neuling.org, mingo@kernel.org, paulus@samba.org, prasad@linux.vnet.ibm.com, will.deacon@arm.com


The patch titled
     Subject: x86: kill TIF_DEBUG
has been added to the -mm tree.  Its filename is
     x86-kill-tif_debug.patch

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
Subject: x86: kill TIF_DEBUG

Because it is not used.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Michael Neuling <mikey@neuling.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/thread_info.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN arch/x86/include/asm/thread_info.h~x86-kill-tif_debug arch/x86/include/asm/thread_info.h
--- a/arch/x86/include/asm/thread_info.h~x86-kill-tif_debug
+++ a/arch/x86/include/asm/thread_info.h
@@ -89,7 +89,6 @@ struct thread_info {
 #define TIF_FORK		18	/* ret_from_fork */
 #define TIF_NOHZ		19	/* in adaptive nohz mode */
 #define TIF_MEMDIE		20	/* is terminating due to OOM killer */
-#define TIF_DEBUG		21	/* uses debug registers */
 #define TIF_IO_BITMAP		22	/* uses I/O bitmap */
 #define TIF_FORCED_TF		24	/* true if TF in eflags artificially */
 #define TIF_BLOCKSTEP		25	/* set when we want DEBUGCTLMSR_BTF */
@@ -113,7 +112,6 @@ struct thread_info {
 #define _TIF_IA32		(1 << TIF_IA32)
 #define _TIF_FORK		(1 << TIF_FORK)
 #define _TIF_NOHZ		(1 << TIF_NOHZ)
-#define _TIF_DEBUG		(1 << TIF_DEBUG)
 #define _TIF_IO_BITMAP		(1 << TIF_IO_BITMAP)
 #define _TIF_FORCED_TF		(1 << TIF_FORCED_TF)
 #define _TIF_BLOCKSTEP		(1 << TIF_BLOCKSTEP)
@@ -154,7 +152,7 @@ struct thread_info {
 	(_TIF_IO_BITMAP|_TIF_NOTSC|_TIF_BLOCKSTEP)
 
 #define _TIF_WORK_CTXSW_PREV (_TIF_WORK_CTXSW|_TIF_USER_RETURN_NOTIFY)
-#define _TIF_WORK_CTXSW_NEXT (_TIF_WORK_CTXSW|_TIF_DEBUG)
+#define _TIF_WORK_CTXSW_NEXT (_TIF_WORK_CTXSW)
 
 #define PREEMPT_ACTIVE		0x10000000
 
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

