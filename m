From: akpm@linux-foundation.org
Subject: + ptrace-x86-introduce-ptrace_register_breakpoint.patch added to -mm tree
Date: Mon, 13 May 2013 16:07:05 -0700
Message-ID: <20130513230705.EBB0E31C1D4@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:55860 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136Ab3EMXHH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 May 2013 19:07:07 -0400
Received: by mail-gh0-f201.google.com with SMTP id r14so212068ghr.0
        for <mm-commits@vger.kernel.org>; Mon, 13 May 2013 16:07:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, benh@kernel.crashing.org, fweisbec@gmail.com, jan.kratochvil@redhat.com, lethal@linux-sh.org, linux@arm.linux.org.uk, mikey@neuling.org, mingo@kernel.org, paulus@samba.org, prasad@linux.vnet.ibm.com, will.deacon@arm.com


The patch titled
     Subject: ptrace/x86: introduce ptrace_register_breakpoint()
has been added to the -mm tree.  Its filename is
     ptrace-x86-introduce-ptrace_register_breakpoint.patch

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
Subject: ptrace/x86: introduce ptrace_register_breakpoint()

No functional changes, preparation.

Extract the "register breakpoint" code from ptrace_get_debugreg() into the
new/generic helper, ptrace_register_breakpoint().  It will have more
users.

The patch also adds another simple helper, ptrace_fill_bp_fields(), to
factor out the arch_bp_generic_fields() logic in register/modify.

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

 arch/x86/kernel/ptrace.c |   86 +++++++++++++++++++++----------------
 1 file changed, 50 insertions(+), 36 deletions(-)

diff -puN arch/x86/kernel/ptrace.c~ptrace-x86-introduce-ptrace_register_breakpoint arch/x86/kernel/ptrace.c
--- a/arch/x86/kernel/ptrace.c~ptrace-x86-introduce-ptrace_register_breakpoint
+++ a/arch/x86/kernel/ptrace.c
@@ -601,22 +601,48 @@ static unsigned long ptrace_get_dr7(stru
 	return dr7;
 }
 
-static int
-ptrace_modify_breakpoint(struct perf_event *bp, int len, int type,
-			 struct task_struct *tsk, int disabled)
+static int ptrace_fill_bp_fields(struct perf_event_attr *attr,
+					int len, int type, bool disabled)
+{
+	int err, bp_len, bp_type;
+
+	err = arch_bp_generic_fields(len, type, &bp_len, &bp_type);
+	if (!err) {
+		attr->bp_len = bp_len;
+		attr->bp_type = bp_type;
+		attr->disabled = disabled;
+	}
+
+	return err;
+}
+
+static struct perf_event *
+ptrace_register_breakpoint(struct task_struct *tsk, int len, int type,
+				unsigned long addr, bool disabled)
 {
-	int err;
-	int gen_len, gen_type;
 	struct perf_event_attr attr;
+	int err;
+
+	ptrace_breakpoint_init(&attr);
+	attr.bp_addr = addr;
 
-	err = arch_bp_generic_fields(len, type, &gen_len, &gen_type);
+	err = ptrace_fill_bp_fields(&attr, len, type, disabled);
 	if (err)
-		return err;
+		return ERR_PTR(err);
 
-	attr = bp->attr;
-	attr.bp_len = gen_len;
-	attr.bp_type = gen_type;
-	attr.disabled = disabled;
+	return register_user_hw_breakpoint(&attr, ptrace_triggered,
+						 NULL, tsk);
+}
+
+static int ptrace_modify_breakpoint(struct perf_event *bp, int len, int type,
+					int disabled)
+{
+	struct perf_event_attr attr = bp->attr;
+	int err;
+
+	err = ptrace_fill_bp_fields(&attr, len, type, disabled);
+	if (err)
+		return err;
 
 	return modify_user_hw_breakpoint(bp, &attr);
 }
@@ -653,7 +679,7 @@ restore:
 			break;
 		}
 
-		rc = ptrace_modify_breakpoint(bp, len, type, tsk, disabled);
+		rc = ptrace_modify_breakpoint(bp, len, type, disabled);
 		if (rc)
 			break;
 	}
@@ -693,26 +719,14 @@ static unsigned long ptrace_get_debugreg
 static int ptrace_set_breakpoint_addr(struct task_struct *tsk, int nr,
 				      unsigned long addr)
 {
-	struct perf_event *bp;
 	struct thread_struct *t = &tsk->thread;
-	struct perf_event_attr attr;
+	struct perf_event *bp = t->ptrace_bps[nr];
 	int err = 0;
 
-	if (!t->ptrace_bps[nr]) {
-		ptrace_breakpoint_init(&attr);
-		/*
-		 * Put stub len and type to register (reserve) an inactive but
-		 * correct bp
-		 */
-		attr.bp_addr = addr;
-		attr.bp_len = HW_BREAKPOINT_LEN_1;
-		attr.bp_type = HW_BREAKPOINT_W;
-		attr.disabled = 1;
-
-		bp = register_user_hw_breakpoint(&attr, ptrace_triggered,
-						 NULL, tsk);
-
+	if (!bp) {
 		/*
+		 * Put stub len and type to create an inactive but correct bp.
+		 *
 		 * CHECKME: the previous code returned -EIO if the addr wasn't
 		 * a valid task virtual addr. The new one will return -EINVAL in
 		 *  this case.
@@ -721,20 +735,20 @@ static int ptrace_set_breakpoint_addr(st
 		 * writing for the user. And anyway this is the previous
 		 * behaviour.
 		 */
-		if (IS_ERR(bp)) {
+		bp = ptrace_register_breakpoint(tsk,
+				X86_BREAKPOINT_LEN_1, X86_BREAKPOINT_WRITE,
+				addr, true);
+		if (IS_ERR(bp))
 			err = PTR_ERR(bp);
-			goto out;
-		}
-
-		t->ptrace_bps[nr] = bp;
+		else
+			t->ptrace_bps[nr] = bp;
 	} else {
-		bp = t->ptrace_bps[nr];
+		struct perf_event_attr attr = bp->attr;
 
-		attr = bp->attr;
 		attr.bp_addr = addr;
 		err = modify_user_hw_breakpoint(bp, &attr);
 	}
-out:
+
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

