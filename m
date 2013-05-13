From: akpm@linux-foundation.org
Subject: + ptrace-x86-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch added to -mm tree
Date: Mon, 13 May 2013 16:06:44 -0700
Message-ID: <20130513230644.F2CD75A4278@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:53819 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136Ab3EMXGq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 May 2013 19:06:46 -0400
Received: by mail-qe0-f74.google.com with SMTP id 7so50242qeb.3
        for <mm-commits@vger.kernel.org>; Mon, 13 May 2013 16:06:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, benh@kernel.crashing.org, fweisbec@gmail.com, jan.kratochvil@redhat.com, lethal@linux-sh.org, linux@arm.linux.org.uk, mikey@neuling.org, mingo@kernel.org, paulus@samba.org, prasad@linux.vnet.ibm.com, will.deacon@arm.com


The patch titled
     Subject: ptrace/x86: revert "hw_breakpoints: Fix racy access to ptrace breakpoints"
has been added to the -mm tree.  Its filename is
     ptrace-x86-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch

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
Subject: ptrace/x86: revert "hw_breakpoints: Fix racy access to ptrace breakpoints"

This reverts commit 87dc669ba257 ("hw_breakpoints: Fix racy access to
ptrace breakpoints").

The patch was fine but we can no longer race with SIGKILL after 9899d11f
("ptrace: ensure arch_ptrace/ptrace_request can never race with SIGKILL"),
the __TASK_TRACED tracee can't be woken up and ->ptrace_bps[] can't go
away.

The patch only removes ptrace_get_breakpoints/ptrace_put_breakpoints and
does a couple of "while at it" cleanups, it doesn't remove other changes
from the reverted commit.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Michael Neuling <mikey@neuling.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/ptrace.c |   28 +++++-----------------------
 1 file changed, 5 insertions(+), 23 deletions(-)

diff -puN arch/x86/kernel/ptrace.c~ptrace-x86-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints arch/x86/kernel/ptrace.c
--- a/arch/x86/kernel/ptrace.c~ptrace-x86-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints
+++ a/arch/x86/kernel/ptrace.c
@@ -641,9 +641,6 @@ static int ptrace_write_dr7(struct task_
 	unsigned len, type;
 	struct perf_event *bp;
 
-	if (ptrace_get_breakpoints(tsk) < 0)
-		return -ESRCH;
-
 	data &= ~DR_CONTROL_RESERVED;
 	old_dr7 = ptrace_get_dr7(thread->ptrace_bps);
 restore:
@@ -692,9 +689,7 @@ restore:
 		goto restore;
 	}
 
-	ptrace_put_breakpoints(tsk);
-
-	return ((orig_ret < 0) ? orig_ret : rc);
+	return orig_ret < 0 ? orig_ret : rc;
 }
 
 /*
@@ -706,18 +701,10 @@ static unsigned long ptrace_get_debugreg
 	unsigned long val = 0;
 
 	if (n < HBP_NUM) {
-		struct perf_event *bp;
-
-		if (ptrace_get_breakpoints(tsk) < 0)
-			return -ESRCH;
+		struct perf_event *bp = thread->ptrace_bps[n];
 
-		bp = thread->ptrace_bps[n];
-		if (!bp)
-			val = 0;
-		else
+		if (bp)
 			val = bp->hw.info.address;
-
-		ptrace_put_breakpoints(tsk);
 	} else if (n == 6) {
 		val = thread->debugreg6;
 	 } else if (n == 7) {
@@ -734,9 +721,6 @@ static int ptrace_set_breakpoint_addr(st
 	struct perf_event_attr attr;
 	int err = 0;
 
-	if (ptrace_get_breakpoints(tsk) < 0)
-		return -ESRCH;
-
 	if (!t->ptrace_bps[nr]) {
 		ptrace_breakpoint_init(&attr);
 		/*
@@ -762,7 +746,7 @@ static int ptrace_set_breakpoint_addr(st
 		 */
 		if (IS_ERR(bp)) {
 			err = PTR_ERR(bp);
-			goto put;
+			goto out;
 		}
 
 		t->ptrace_bps[nr] = bp;
@@ -773,9 +757,7 @@ static int ptrace_set_breakpoint_addr(st
 		attr.bp_addr = addr;
 		err = modify_user_hw_breakpoint(bp, &attr);
 	}
-
-put:
-	ptrace_put_breakpoints(tsk);
+out:
 	return err;
 }
 
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

