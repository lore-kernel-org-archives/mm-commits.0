From: akpm@linux-foundation.org
Subject: - powerpc-user_regset-ptrace_setregs-regression-fix.patch removed from -mm tree
Date: Fri, 21 Mar 2008 13:31:44 -0700
Message-ID: <200803212031.m2LKViUB009094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38797 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757441AbYCUUc2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 16:32:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, anton@samba.org, benh@kernel.crashing.org, paulus@samba.org, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     powerpc: user_regset PTRACE_SETREGS regression fix
has been removed from the -mm tree.  Its filename was
     powerpc-user_regset-ptrace_setregs-regression-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: user_regset PTRACE_SETREGS regression fix
From: Roland McGrath <roland@redhat.com>

The PTRACE_SETREGS request was only recently added on powerpc, and gdb does
not use it.  So it slipped through without getting all the testing it should
have had.

The user_regset changes had a simple bug in storing to all of the 32-bit
general registers block on 64-bit kernels.  This bug only comes up with
PTRACE_SETREGS, not PPC_PTRACE_SETREGS.  It causes a BUG_ON to hit, so this
fix needs to go in ASAP.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Anton Blanchard <anton@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/ptrace.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN arch/powerpc/kernel/ptrace.c~powerpc-user_regset-ptrace_setregs-regression-fix arch/powerpc/kernel/ptrace.c
--- a/arch/powerpc/kernel/ptrace.c~powerpc-user_regset-ptrace_setregs-regression-fix
+++ a/arch/powerpc/kernel/ptrace.c
@@ -530,15 +530,21 @@ static int gpr32_set(struct task_struct 
 		--count;
 	}
 
-	if (kbuf)
+	if (kbuf) {
 		for (; count > 0 && pos <= PT_MAX_PUT_REG; --count)
 			regs[pos++] = *k++;
-	else
+		for (; count > 0 && pos < PT_TRAP; --count, ++pos)
+			++k;
+	} else {
 		for (; count > 0 && pos <= PT_MAX_PUT_REG; --count) {
 			if (__get_user(reg, u++))
 				return -EFAULT;
 			regs[pos++] = reg;
 		}
+		for (; count > 0 && pos < PT_TRAP; --count, ++pos)
+			if (__get_user(reg, u++))
+				return -EFAULT;
+	}
 
 	if (count > 0 && pos == PT_TRAP) {
 		if (kbuf)
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
git-x86.patch
x86-handle_vm86_trap-cleanup.patch
x86_64-ia32-ptrace-vs-enosys.patch
x86_64-ptrace-vs-enosys.patch
x86_64-ia32-ptrace-vs-enosys-sysenter-syscall.patch
powerpc-dont-use-pt_dtrace.patch
add-rusage_thread.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
signals-do_signal_stop-use-signal_group_exit.patch
signals-do_group_exit-use-signal_group_exit-more-consistently.patch
lock_task_sighand-add-rcu-lock-unlock.patch
k_getrusage-dont-take-rcu_read_lock.patch
do_task_stat-dont-take-rcu_read_lock.patch
signals-consolidate-checks-for-whether-or-not-to-ignore-a-signal.patch
signals-clean-dequeue_signal-from-excess-checks-and-assignments.patch
signals-consolidate-send_sigqueue-and-send_group_sigqueue.patch
signals-cleanup-security_task_kill-usage-implementation.patch
signals-re-assign-cld_continued-notification-from-the-sender-to-reciever.patch
kill_pid_info-dont-take-now-unneeded-tasklist_lock.patch
handle_stop_signal-unify-partial-full-stop-handling.patch
handle_stop_signal-use-the-cached-p-signal-value.patch
get_signal_to_deliver-use-the-cached-signal-sighand-values.patch
signals-send_sigqueue-dont-take-rcu-lock.patch
signals-send_sigqueue-dont-forget-about-handle_stop_signal.patch
signals-__group_complete_signal-cache-the-value-of-p-signal.patch
signals-send_group_sigqueue-dont-take-tasklist_lock.patch
signals-move-handle_stop_signal-into-send_signal.patch
signals-do_tkill-dont-use-tasklist_lock.patch
signals-do_tkill-dont-use-tasklist_lock-comment.patch
signals-send_sig_info-dont-take-tasklist_lock.patch
signals-microoptimize-the-usage-of-curr_target.patch
signals-move-the-definition-of-__group_complete_signal-up.patch
signals-change-send_signal-do_send_sigqueue-to-take-boolean-group-parameter.patch
signals-use-__group_complete_signal-for-the-specific-signals-too.patch
signals-fold-complete_signal-into-send_signal-do_send_sigqueue.patch
signals-unify-send_sigqueue-send_group_sigqueue-completely.patch
signals-join-send_sigqueue-with-send_group_sigqueue.patch
signals-handle_stop_signal-dont-worry-about-sigkill.patch
signals-cleanup-the-usage-of-print_fatal_signal.patch
signals-fold-sig_ignored-into-handle_stop_signal.patch
signals-fold-sig_ignored-into-handle_stop_signal-comment.patch
signals-document-cld_continued-notification-mechanics.patch
signals-document-cld_continued-notification-mechanics-more.patch
signals-send_signal-be-paranoid-about-signalfd_notify.patch
signals-check_kill_permission-check-session-under-tasklist_lock.patch
ptrace-introduce-task_detached-helper.patch
reparent_thread-use-same_thread_group.patch
document-de_thread-with-exit_notify-connection.patch
ptrace-introduce-ptrace_reparented-helper.patch
ptrace-__ptrace_unlink-use-the-ptrace_reparented-helper.patch
ptrace-ptrace_attach-use-send_sig_info-instead-force_sig_specific.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

