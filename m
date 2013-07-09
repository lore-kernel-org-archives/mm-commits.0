From: akpm@linux-foundation.org
Subject: [merged]
 ptrace-x86-simplify-the-disable-logic-in-ptrace_write_dr7.patch removed
 from -mm tree
Date: Tue, 09 Jul 2013 16:21:13 -0700
Message-ID: <51dc9ae9.MXdeVMj41yp9l23Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39086 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040Ab3GIXVO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:21:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, will.deacon@arm.com, prasad@linux.vnet.ibm.com, paulus@samba.org, mingo@kernel.org, mikey@neuling.org, linux@arm.linux.org.uk, lethal@linux-sh.org, jan.kratochvil@redhat.com, fweisbec@gmail.com, benh@kernel.crashing.org, oleg@redhat.com

Subject: [merged] ptrace-x86-simplify-the-disable-logic-in-ptrace_write_dr7.patch removed from -mm tree
To: oleg@redhat.com,benh@kernel.crashing.org,fweisbec@gmail.com,jan.kratochvil@redhat.com,lethal@linux-sh.org,linux@arm.linux.org.uk,mikey@neuling.org,mingo@kernel.org,paulus@samba.org,prasad@linux.vnet.ibm.com,will.deacon@arm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:21:13 -0700


The patch titled
     Subject: ptrace/x86: simplify the "disable" logic in ptrace_write_dr7()
has been removed from the -mm tree.  Its filename was
     ptrace-x86-simplify-the-disable-logic-in-ptrace_write_dr7.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

