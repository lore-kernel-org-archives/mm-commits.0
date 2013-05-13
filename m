From: akpm@linux-foundation.org
Subject: + ptrace-x86-cleanup-ptrace_set_debugreg.patch added to -mm tree
Date: Mon, 13 May 2013 16:07:11 -0700
Message-ID: <20130513230711.EC1815A423C@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:54848 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136Ab3EMXHN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 May 2013 19:07:13 -0400
Received: by mail-qc0-f202.google.com with SMTP id d1so668782qcz.5
        for <mm-commits@vger.kernel.org>; Mon, 13 May 2013 16:07:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, benh@kernel.crashing.org, fweisbec@gmail.com, jan.kratochvil@redhat.com, lethal@linux-sh.org, linux@arm.linux.org.uk, mikey@neuling.org, mingo@kernel.org, paulus@samba.org, prasad@linux.vnet.ibm.com, will.deacon@arm.com


The patch titled
     Subject: ptrace/x86: cleanup ptrace_set_debugreg()
has been added to the -mm tree.  Its filename is
     ptrace-x86-cleanup-ptrace_set_debugreg.patch

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
Subject: ptrace/x86: cleanup ptrace_set_debugreg()

ptrace_set_debugreg() is trivial but looks horrible.  Kill the unnecessary
goto's and return's to cleanup the code.

This matches ptrace_get_debugreg() which also needs the trivial whitespace
cleanups.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
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

 arch/x86/kernel/ptrace.c |   26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

diff -puN arch/x86/kernel/ptrace.c~ptrace-x86-cleanup-ptrace_set_debugreg arch/x86/kernel/ptrace.c
--- a/arch/x86/kernel/ptrace.c~ptrace-x86-cleanup-ptrace_set_debugreg
+++ a/arch/x86/kernel/ptrace.c
@@ -703,7 +703,7 @@ restore:
  */
 static unsigned long ptrace_get_debugreg(struct task_struct *tsk, int n)
 {
-	struct thread_struct *thread = &(tsk->thread);
+	struct thread_struct *thread = &tsk->thread;
 	unsigned long val = 0;
 
 	if (n < HBP_NUM) {
@@ -713,7 +713,7 @@ static unsigned long ptrace_get_debugreg
 			val = bp->hw.info.address;
 	} else if (n == 6) {
 		val = thread->debugreg6;
-	 } else if (n == 7) {
+	} else if (n == 7) {
 		val = thread->ptrace_dr7;
 	}
 	return val;
@@ -761,30 +761,20 @@ static int ptrace_set_breakpoint_addr(st
 static int ptrace_set_debugreg(struct task_struct *tsk, int n,
 			       unsigned long val)
 {
-	struct thread_struct *thread = &(tsk->thread);
-	int rc = 0;
-
+	struct thread_struct *thread = &tsk->thread;
 	/* There are no DR4 or DR5 registers */
-	if (n == 4 || n == 5)
-		return -EIO;
+	int rc = -EIO;
 
-	if (n == 6) {
-		thread->debugreg6 = val;
-		goto ret_path;
-	}
 	if (n < HBP_NUM) {
 		rc = ptrace_set_breakpoint_addr(tsk, n, val);
-		if (rc)
-			return rc;
-	}
-	/* All that's left is DR7 */
-	if (n == 7) {
+	} else if (n == 6) {
+		thread->debugreg6 = val;
+		rc = 0;
+	} else if (n == 7) {
 		rc = ptrace_write_dr7(tsk, val);
 		if (!rc)
 			thread->ptrace_dr7 = val;
 	}
-
-ret_path:
 	return rc;
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

