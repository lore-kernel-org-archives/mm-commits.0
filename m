From: akpm@linux-foundation.org
Subject: [merged] ptrace-x86-introduce-ptrace_register_breakpoint.patch
 removed from -mm tree
Date: Tue, 09 Jul 2013 16:21:17 -0700
Message-ID: <51dc9aed.r5U0MXAIaG8/bkny%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39107 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab3GIXVS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:21:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, will.deacon@arm.com, prasad@linux.vnet.ibm.com, paulus@samba.org, mingo@kernel.org, mikey@neuling.org, linux@arm.linux.org.uk, lethal@linux-sh.org, jan.kratochvil@redhat.com, fweisbec@gmail.com, benh@kernel.crashing.org, oleg@redhat.com

Subject: [merged] ptrace-x86-introduce-ptrace_register_breakpoint.patch removed from -mm tree
To: oleg@redhat.com,benh@kernel.crashing.org,fweisbec@gmail.com,jan.kratochvil@redhat.com,lethal@linux-sh.org,linux@arm.linux.org.uk,mikey@neuling.org,mingo@kernel.org,paulus@samba.org,prasad@linux.vnet.ibm.com,will.deacon@arm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:21:17 -0700


The patch titled
     Subject: ptrace/x86: introduce ptrace_register_breakpoint()
has been removed from the -mm tree.  Its filename was
     ptrace-x86-introduce-ptrace_register_breakpoint.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
mm-mempolicy-fix-mbind_range-vma_adjust-interaction.patch
include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch
fput-task_work_add-can-fail-if-the-caller-has-passed-exit_task_work-fix.patch
fput-turn-list_head-delayed_fput_list-into-llist_head.patch
llist-fix-simplify-llist_add-and-llist_add_batch.patch
llist-llist_add-can-use-llist_add_batch.patch
kernel-wide-fix-missing-validations-on-__get-__put-__copy_to-__copy_from_user.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch
signals-eventpoll-set-saved_sigmask-at-the-start.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch

