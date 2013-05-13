From: akpm@linux-foundation.org
Subject: + ptrace-x86-simplify-the-disable-logic-in-ptrace_write_dr7.patch added to -mm tree
Date: Mon, 13 May 2013 16:06:59 -0700
Message-ID: <20130513230659.EA2BF5A423C@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:56759 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136Ab3EMXHC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 May 2013 19:07:02 -0400
Received: by mail-ye0-f201.google.com with SMTP id m14so668181yen.2
        for <mm-commits@vger.kernel.org>; Mon, 13 May 2013 16:07:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, benh@kernel.crashing.org, fweisbec@gmail.com, jan.kratochvil@redhat.com, lethal@linux-sh.org, linux@arm.linux.org.uk, mikey@neuling.org, mingo@kernel.org, paulus@samba.org, prasad@linux.vnet.ibm.com, will.deacon@arm.com


The patch titled
     Subject: ptrace/x86: simplify the "disable" logic in ptrace_write_dr7()
has been added to the -mm tree.  Its filename is
     ptrace-x86-simplify-the-disable-logic-in-ptrace_write_dr7.patch

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
Subject: ptrace/x86: simplify the "disable" logic in ptrace_write_dr7()

ptrace_write_dr7() looks unnecessarily overcomplicated.  We can factor out
ptrace_modify_breakpoint() and do not do "continue" twice, just we need to
pass the proper "disabled" argument to ptrace_modify_breakpoint().

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

 arch/x86/kernel/ptrace.c |   38 +++++++++++++------------------------
 1 file changed, 14 insertions(+), 24 deletions(-)

diff -puN arch/x86/kernel/ptrace.c~ptrace-x86-simplify-the-disable-logic-in-ptrace_write_dr7 arch/x86/kernel/ptrace.c
--- a/arch/x86/kernel/ptrace.c~ptrace-x86-simplify-the-disable-logic-in-ptrace_write_dr7
+++ a/arch/x86/kernel/ptrace.c
@@ -637,9 +637,7 @@ static int ptrace_write_dr7(struct task_
 	struct thread_struct *thread = &(tsk->thread);
 	unsigned long old_dr7;
 	int i, orig_ret = 0, rc = 0;
-	int enabled, second_pass = 0;
-	unsigned len, type;
-	struct perf_event *bp;
+	int second_pass = 0;
 
 	data &= ~DR_CONTROL_RESERVED;
 	old_dr7 = ptrace_get_dr7(thread->ptrace_bps);
@@ -649,30 +647,22 @@ restore:
 	 * appropriate changes to each.
 	 */
 	for (i = 0; i < HBP_NUM; i++) {
-		enabled = decode_dr7(data, i, &len, &type);
-		bp = thread->ptrace_bps[i];
+		unsigned len, type;
+		bool disabled = !decode_dr7(data, i, &len, &type);
+		struct perf_event *bp = thread->ptrace_bps[i];
 
-		if (!enabled) {
-			if (bp) {
-				/*
-				 * Don't unregister the breakpoints right-away,
-				 * unless all register_user_hw_breakpoint()
-				 * requests have succeeded. This prevents
-				 * any window of opportunity for debug
-				 * register grabbing by other users.
-				 */
-				if (!second_pass)
-					continue;
-
-				rc = ptrace_modify_breakpoint(bp, len, type,
-							      tsk, 1);
-				if (rc)
-					break;
-			}
-			continue;
+		if (disabled) {
+			/*
+			 * Don't unregister the breakpoints right-away, unless
+			 * all register_user_hw_breakpoint() requests have
+			 * succeeded. This prevents any window of opportunity
+			 * for debug register grabbing by other users.
+			 */
+			if (!bp || !second_pass)
+				continue;
 		}
 
-		rc = ptrace_modify_breakpoint(bp, len, type, tsk, 0);
+		rc = ptrace_modify_breakpoint(bp, len, type, tsk, disabled);
 		if (rc)
 			break;
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

