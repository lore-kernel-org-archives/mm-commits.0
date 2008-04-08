From: akpm@linux-foundation.org
Subject: - x86_64-ia32-ptrace-vs-enosys-sysenter-syscall.patch removed from -mm tree
Date: Tue, 08 Apr 2008 11:59:12 -0700
Message-ID: <200804081859.m38IxCqE006965@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41292 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757848AbYDHS77 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2008 14:59:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, ak@suse.de, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     ptrace vs -ENOSYS sysenter/syscall
has been removed from the -mm tree.  Its filename was
     x86_64-ia32-ptrace-vs-enosys-sysenter-syscall.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace vs -ENOSYS sysenter/syscall
From: Roland McGrath <roland@redhat.com>

The previous "x86_64 ia32 ptrace vs -ENOSYS" fix only covered the int $0x80
system call entries.  This does the same fix for the sysenter and syscall
instruction paths.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/ia32/ia32entry.S |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN arch/x86/ia32/ia32entry.S~x86_64-ia32-ptrace-vs-enosys-sysenter-syscall arch/x86/ia32/ia32entry.S
--- a/arch/x86/ia32/ia32entry.S~x86_64-ia32-ptrace-vs-enosys-sysenter-syscall
+++ a/arch/x86/ia32/ia32entry.S
@@ -162,12 +162,14 @@ sysenter_tracesys:
 	SAVE_REST
 	CLEAR_RREGS
 	movq	%r9,R9(%rsp)
-	movq	$-ENOSYS,RAX(%rsp)	/* really needed? */
+	movq	$-ENOSYS,RAX(%rsp)/* ptrace can change this for a bad syscall */
 	movq	%rsp,%rdi        /* &pt_regs -> arg1 */
 	call	syscall_trace_enter
 	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
 	RESTORE_REST
 	xchgl	%ebp,%r9d
+	cmpl	$(IA32_NR_syscalls-1),%eax
+	ja	int_ret_from_sys_call /* sysenter_tracesys has set RAX(%rsp) */
 	jmp	sysenter_do_call
 	CFI_ENDPROC
 ENDPROC(ia32_sysenter_target)
@@ -261,13 +263,15 @@ cstar_tracesys:	
 	SAVE_REST
 	CLEAR_RREGS
 	movq %r9,R9(%rsp)
-	movq $-ENOSYS,RAX(%rsp)	/* really needed? */
+	movq $-ENOSYS,RAX(%rsp)	/* ptrace can change this for a bad syscall */
 	movq %rsp,%rdi        /* &pt_regs -> arg1 */
 	call syscall_trace_enter
 	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
 	RESTORE_REST
 	xchgl %ebp,%r9d
 	movl RSP-ARGOFFSET(%rsp), %r8d
+	cmpl $(IA32_NR_syscalls-1),%eax
+	ja int_ret_from_sys_call /* cstar_tracesys has set RAX(%rsp) */
 	jmp cstar_do_call
 END(ia32_cstar_target)
 				
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
git-x86.patch
git-powerpc.patch
git-selinux.patch
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
signals-check_kill_permission-remove-tasklist_lock.patch
signals-fix-sbin-init-protection-from-unwanted-signals.patch
signals-de_thread-simplify-the-child_reaper-switching.patch
signals-allow-the-kernel-to-actually-kill-sbin-init.patch
signals-add-set_restore_sigmask.patch
signals-set_restore_sigmask-tif_sigpending.patch
signals-s390-renumber-tif_restore_sigmask.patch
signals-ia64-renumber-tif_restore_sigmask.patch
signals-use-have_set_restore_sigmask.patch
signals-x86-ts_restore_sigmask.patch
signals-powerpc-tlf_restore_sigmask.patch
ptrace-introduce-task_detached-helper.patch
reparent_thread-use-same_thread_group.patch
document-de_thread-with-exit_notify-connection.patch
ptrace-introduce-ptrace_reparented-helper.patch
ptrace-__ptrace_unlink-use-the-ptrace_reparented-helper.patch
ptrace-ptrace_attach-use-send_sig_info-instead-force_sig_specific.patch
ptrace-allow-to-ptrace-sbin-init.patch
procfs-mem-permission-cleanup.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
pids-de_thread-dont-clear-session-pgrp-pids-for-the-old-leader.patch
pids-introduce-change_pid-helper.patch
pids-sys_setpgid-use-change_pid-helper.patch
pids-__set_special_pids-use-change_pid-helper.patch
pids-sys_getsid-fix-unsafe-pid-usage-fix-possible-0-instead-of-esrch.patch
pids-sys_getpgid-fix-unsafe-pid-usage-s-tasklist-rcu.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

