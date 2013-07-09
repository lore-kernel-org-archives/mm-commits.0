From: akpm@linux-foundation.org
Subject: [merged]
 ptrace-x86-dont-delay-disable-till-second-pass-in-ptrace_write_dr7.patch
 removed from -mm tree
Date: Tue, 09 Jul 2013 16:21:15 -0700
Message-ID: <51dc9aeb.VwsfcI6zXlQXWXLG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39101 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab3GIXVQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:21:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, will.deacon@arm.com, prasad@linux.vnet.ibm.com, paulus@samba.org, mingo@kernel.org, mikey@neuling.org, linux@arm.linux.org.uk, lethal@linux-sh.org, jan.kratochvil@redhat.com, fweisbec@gmail.com, benh@kernel.crashing.org, oleg@redhat.com

Subject: [merged] ptrace-x86-dont-delay-disable-till-second-pass-in-ptrace_write_dr7.patch removed from -mm tree
To: oleg@redhat.com,benh@kernel.crashing.org,fweisbec@gmail.com,jan.kratochvil@redhat.com,lethal@linux-sh.org,linux@arm.linux.org.uk,mikey@neuling.org,mingo@kernel.org,paulus@samba.org,prasad@linux.vnet.ibm.com,will.deacon@arm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:21:15 -0700


The patch titled
     Subject: ptrace/x86: dont delay "disable" till second pass in ptrace_write_dr7()
has been removed from the -mm tree.  Its filename was
     ptrace-x86-dont-delay-disable-till-second-pass-in-ptrace_write_dr7.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

