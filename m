From: akpm@linux-foundation.org
Subject: + ptrace-x86-ptrace_write_dr7-should-create-bp-if-disabled.patch added to -mm tree
Date: Mon, 13 May 2013 16:07:08 -0700
Message-ID: <20130513230708.F1E145A4255@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:62791 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136Ab3EMXHK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 May 2013 19:07:10 -0400
Received: by mail-qa0-f73.google.com with SMTP id bs12so333798qab.4
        for <mm-commits@vger.kernel.org>; Mon, 13 May 2013 16:07:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, benh@kernel.crashing.org, fweisbec@gmail.com, jan.kratochvil@redhat.com, lethal@linux-sh.org, linux@arm.linux.org.uk, mikey@neuling.org, mingo@kernel.org, paulus@samba.org, prasad@linux.vnet.ibm.com, will.deacon@arm.com


The patch titled
     Subject: ptrace/x86: ptrace_write_dr7() should create bp if !disabled
has been added to the -mm tree.  Its filename is
     ptrace-x86-ptrace_write_dr7-should-create-bp-if-disabled.patch

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
Subject: ptrace/x86: ptrace_write_dr7() should create bp if !disabled

24f1e32c ("hw-breakpoints: Rewrite the hw-breakpoints layer on top of perf
events") introduced the minor regression.  Before this commit

	PTRACE_POKEUSER DR7, enableDR0
	PTRACE_POKEUSER DR0, address

was perfectly valid, now PTRACE_POKEUSER(DR7) fails if DR0 was not
previously initialized by PTRACE_POKEUSER(DR0).

Change ptrace_write_dr7() to do ptrace_register_breakpoint(addr => 0) if
!bp && !disabled.  This fixes watchpoint-zeroaddr from ptrace-tests, see
https://bugzilla.redhat.com/show_bug.cgi?id=660204.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Jan Kratochvil <jan.kratochvil@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Michael Neuling <mikey@neuling.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/ptrace.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff -puN arch/x86/kernel/ptrace.c~ptrace-x86-ptrace_write_dr7-should-create-bp-if-disabled arch/x86/kernel/ptrace.c
--- a/arch/x86/kernel/ptrace.c~ptrace-x86-ptrace_write_dr7-should-create-bp-if-disabled
+++ a/arch/x86/kernel/ptrace.c
@@ -670,13 +670,16 @@ restore:
 		if (!bp) {
 			if (disabled)
 				continue;
-			/*
-			 * We should have at least an inactive breakpoint at
-			 * this slot. It means the user is writing dr7 without
-			 * having written the address register first.
-			 */
-			rc = -EINVAL;
-			break;
+
+			bp = ptrace_register_breakpoint(tsk,
+					len, type, 0, disabled);
+			if (IS_ERR(bp)) {
+				rc = PTR_ERR(bp);
+				break;
+			}
+
+			thread->ptrace_bps[i] = bp;
+			continue;
 		}
 
 		rc = ptrace_modify_breakpoint(bp, len, type, disabled);
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

