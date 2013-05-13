From: akpm@linux-foundation.org
Subject: + ptrace-x86-dont-delay-disable-till-second-pass-in-ptrace_write_dr7.patch added to -mm tree
Date: Mon, 13 May 2013 16:07:02 -0700
Message-ID: <20130513230703.0727E5A4255@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:46282 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136Ab3EMXHE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 May 2013 19:07:04 -0400
Received: by mail-yh0-f73.google.com with SMTP id a41so669797yho.4
        for <mm-commits@vger.kernel.org>; Mon, 13 May 2013 16:07:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, benh@kernel.crashing.org, fweisbec@gmail.com, jan.kratochvil@redhat.com, lethal@linux-sh.org, linux@arm.linux.org.uk, mikey@neuling.org, mingo@kernel.org, paulus@samba.org, prasad@linux.vnet.ibm.com, will.deacon@arm.com


The patch titled
     Subject: ptrace/x86: dont delay "disable" till second pass in ptrace_write_dr7()
has been added to the -mm tree.  Its filename is
     ptrace-x86-dont-delay-disable-till-second-pass-in-ptrace_write_dr7.patch

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
Subject: ptrace/x86: dont delay "disable" till second pass in ptrace_write_dr7()

ptrace_write_dr7() skips ptrace_modify_breakpoint(disabled => true) unless
second_pass, this buys nothing but complicates the code and means that we
always do the main loop twice even if "disabled" was never true.

The comment says:

	Don't unregister the breakpoints right-away,
	unless all register_user_hw_breakpoint()
	requests have succeeded.

Firstly, we do not do register_user_hw_breakpoint(), it was removed by
24f1e32c ("hw-breakpoints: Rewrite the hw-breakpoints layer on top of perf
events").

We are going to restore register_user_hw_breakpoint() (see the next patch)
but this doesn't matter, after 44234adc "hw-breakpoints: Modify
breakpoints without unregistering them" perf_event_disable() can not hurt,
hw_breakpoint_del() does not free the slot.

Remove the "second_pass" check from the main loop and simplify the code. 
Since we have to check "bp != NULL" anyway, the patch also removes the
same check in ptrace_modify_breakpoint() and moves the comment into
ptrace_write_dr7().

With this patch the second pass is only needed to restore the saved
old_dr7.  This should never fail, so the patch adds WARN_ON() to catch the
potential problems as Frederic suggested.

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

 arch/x86/kernel/ptrace.c |   53 +++++++++++++------------------------
 1 file changed, 20 insertions(+), 33 deletions(-)

diff -puN arch/x86/kernel/ptrace.c~ptrace-x86-dont-delay-disable-till-second-pass-in-ptrace_write_dr7 arch/x86/kernel/ptrace.c
--- a/arch/x86/kernel/ptrace.c~ptrace-x86-dont-delay-disable-till-second-pass-in-ptrace_write_dr7
+++ a/arch/x86/kernel/ptrace.c
@@ -609,14 +609,6 @@ ptrace_modify_breakpoint(struct perf_eve
 	int gen_len, gen_type;
 	struct perf_event_attr attr;
 
-	/*
-	 * We should have at least an inactive breakpoint at this
-	 * slot. It means the user is writing dr7 without having
-	 * written the address register first
-	 */
-	if (!bp)
-		return -EINVAL;
-
 	err = arch_bp_generic_fields(len, type, &gen_len, &gen_type);
 	if (err)
 		return err;
@@ -634,52 +626,47 @@ ptrace_modify_breakpoint(struct perf_eve
  */
 static int ptrace_write_dr7(struct task_struct *tsk, unsigned long data)
 {
-	struct thread_struct *thread = &(tsk->thread);
+	struct thread_struct *thread = &tsk->thread;
 	unsigned long old_dr7;
-	int i, orig_ret = 0, rc = 0;
-	int second_pass = 0;
+	bool second_pass = false;
+	int i, rc, ret = 0;
 
 	data &= ~DR_CONTROL_RESERVED;
 	old_dr7 = ptrace_get_dr7(thread->ptrace_bps);
+
 restore:
-	/*
-	 * Loop through all the hardware breakpoints, making the
-	 * appropriate changes to each.
-	 */
+	rc = 0;
 	for (i = 0; i < HBP_NUM; i++) {
 		unsigned len, type;
 		bool disabled = !decode_dr7(data, i, &len, &type);
 		struct perf_event *bp = thread->ptrace_bps[i];
 
-		if (disabled) {
+		if (!bp) {
+			if (disabled)
+				continue;
 			/*
-			 * Don't unregister the breakpoints right-away, unless
-			 * all register_user_hw_breakpoint() requests have
-			 * succeeded. This prevents any window of opportunity
-			 * for debug register grabbing by other users.
+			 * We should have at least an inactive breakpoint at
+			 * this slot. It means the user is writing dr7 without
+			 * having written the address register first.
 			 */
-			if (!bp || !second_pass)
-				continue;
+			rc = -EINVAL;
+			break;
 		}
 
 		rc = ptrace_modify_breakpoint(bp, len, type, tsk, disabled);
 		if (rc)
 			break;
 	}
-	/*
-	 * Make a second pass to free the remaining unused breakpoints
-	 * or to restore the original breakpoints if an error occurred.
-	 */
-	if (!second_pass) {
-		second_pass = 1;
-		if (rc < 0) {
-			orig_ret = rc;
-			data = old_dr7;
-		}
+
+	/* Restore if the first pass failed, second_pass shouldn't fail. */
+	if (rc && !WARN_ON(second_pass)) {
+		ret = rc;
+		data = old_dr7;
+		second_pass = true;
 		goto restore;
 	}
 
-	return orig_ret < 0 ? orig_ret : rc;
+	return ret;
 }
 
 /*
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

