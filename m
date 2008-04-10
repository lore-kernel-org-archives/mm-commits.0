From: akpm@linux-foundation.org
Subject: - signals-powerpc-tlf_restore_sigmask.patch removed from -mm tree
Date: Thu, 10 Apr 2008 00:52:14 -0600
Message-ID: <200804100652.m3A6qFJm017641@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33385 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750820AbYDJGyQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Apr 2008 02:54:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, heiko.carstens@de.ibm.com, mingo@elte.hu, oleg@tv-sign.ru, schwidefsky@de.ibm.com, tglx@linutronix.de, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     signals: powerpc TLF_RESTORE_SIGMASK
has been removed from the -mm tree.  Its filename was
     signals-powerpc-tlf_restore_sigmask.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: powerpc TLF_RESTORE_SIGMASK
From: Roland McGrath <roland@redhat.com>

Replace TIF_RESTORE_SIGMASK with TLF_RESTORE_SIGMASK and define our own
set_restore_sigmask() function.  This saves the costly SMP-safe set_bit
operation, which we do not need for the sigmask flag since TIF_SIGPENDING
always has to be set too.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/entry_32.S    |    4 ++--
 arch/powerpc/kernel/signal.c      |   12 ++++++------
 arch/powerpc/kernel/signal_32.c   |    2 +-
 include/asm-powerpc/thread_info.h |   17 +++++++++++++----
 4 files changed, 22 insertions(+), 13 deletions(-)

diff -puN arch/powerpc/kernel/entry_32.S~signals-powerpc-tlf_restore_sigmask arch/powerpc/kernel/entry_32.S
--- a/arch/powerpc/kernel/entry_32.S~signals-powerpc-tlf_restore_sigmask
+++ a/arch/powerpc/kernel/entry_32.S
@@ -661,7 +661,7 @@ user_exc_return:		/* r10 contains MSR_KE
 	/* Check current_thread_info()->flags */
 	rlwinm	r9,r1,0,0,(31-THREAD_SHIFT)
 	lwz	r9,TI_FLAGS(r9)
-	andi.	r0,r9,(_TIF_SIGPENDING|_TIF_RESTORE_SIGMASK|_TIF_NEED_RESCHED)
+	andi.	r0,r9,(_TIF_SIGPENDING|_TIF_NEED_RESCHED)
 	bne	do_work
 
 restore_user:
@@ -912,7 +912,7 @@ recheck:
 	lwz	r9,TI_FLAGS(r9)
 	andi.	r0,r9,_TIF_NEED_RESCHED
 	bne-	do_resched
-	andi.	r0,r9,_TIF_SIGPENDING|_TIF_RESTORE_SIGMASK
+	andi.	r0,r9,_TIF_SIGPENDING
 	beq	restore_user
 do_user_signal:			/* r10 contains MSR_KERNEL here */
 	ori	r10,r10,MSR_EE
diff -puN arch/powerpc/kernel/signal.c~signals-powerpc-tlf_restore_sigmask arch/powerpc/kernel/signal.c
--- a/arch/powerpc/kernel/signal.c~signals-powerpc-tlf_restore_sigmask
+++ a/arch/powerpc/kernel/signal.c
@@ -120,7 +120,7 @@ int do_signal(sigset_t *oldset, struct p
 	int ret;
 	int is32 = is_32bit_task();
 
-	if (test_thread_flag(TIF_RESTORE_SIGMASK))
+	if (current_thread_info()->local_flags & _TLF_RESTORE_SIGMASK)
 		oldset = &current->saved_sigmask;
 	else if (!oldset)
 		oldset = &current->blocked;
@@ -131,9 +131,10 @@ int do_signal(sigset_t *oldset, struct p
 	check_syscall_restart(regs, &ka, signr > 0);
 
 	if (signr <= 0) {
+		struct thread_info *ti = current_thread_info();
 		/* No signal to deliver -- put the saved sigmask back */
-		if (test_thread_flag(TIF_RESTORE_SIGMASK)) {
-			clear_thread_flag(TIF_RESTORE_SIGMASK);
+		if (ti->local_flags & _TLF_RESTORE_SIGMASK) {
+			ti->local_flags &= ~_TLF_RESTORE_SIGMASK;
 			sigprocmask(SIG_SETMASK, &current->saved_sigmask, NULL);
 		}
 		return 0;               /* no signals delivered */
@@ -169,10 +170,9 @@ int do_signal(sigset_t *oldset, struct p
 
 		/*
 		 * A signal was successfully delivered; the saved sigmask is in
-		 * its frame, and we can clear the TIF_RESTORE_SIGMASK flag.
+		 * its frame, and we can clear the TLF_RESTORE_SIGMASK flag.
 		 */
-		if (test_thread_flag(TIF_RESTORE_SIGMASK))
-			clear_thread_flag(TIF_RESTORE_SIGMASK);
+		current_thread_info()->local_flags &= ~_TLF_RESTORE_SIGMASK;
 	}
 
 	return ret;
diff -puN arch/powerpc/kernel/signal_32.c~signals-powerpc-tlf_restore_sigmask arch/powerpc/kernel/signal_32.c
--- a/arch/powerpc/kernel/signal_32.c~signals-powerpc-tlf_restore_sigmask
+++ a/arch/powerpc/kernel/signal_32.c
@@ -243,7 +243,7 @@ long sys_sigsuspend(old_sigset_t mask)
 
  	current->state = TASK_INTERRUPTIBLE;
  	schedule();
- 	set_thread_flag(TIF_RESTORE_SIGMASK);
+	set_restore_sigmask();
  	return -ERESTARTNOHAND;
 }
 
diff -puN include/asm-powerpc/thread_info.h~signals-powerpc-tlf_restore_sigmask include/asm-powerpc/thread_info.h
--- a/include/asm-powerpc/thread_info.h~signals-powerpc-tlf_restore_sigmask
+++ a/include/asm-powerpc/thread_info.h
@@ -120,7 +120,6 @@ static inline struct thread_info *curren
 #define TIF_SECCOMP		10	/* secure computing */
 #define TIF_RESTOREALL		11	/* Restore all regs (implies NOERROR) */
 #define TIF_NOERROR		12	/* Force successful syscall return */
-#define TIF_RESTORE_SIGMASK	13	/* Restore signal mask in do_signal */
 #define TIF_FREEZE		14	/* Freezing for suspend */
 #define TIF_RUNLATCH		15	/* Is the runlatch enabled? */
 #define TIF_ABI_PENDING		16	/* 32/64 bit switch needed */
@@ -138,21 +137,31 @@ static inline struct thread_info *curren
 #define _TIF_SECCOMP		(1<<TIF_SECCOMP)
 #define _TIF_RESTOREALL		(1<<TIF_RESTOREALL)
 #define _TIF_NOERROR		(1<<TIF_NOERROR)
-#define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
 #define _TIF_FREEZE		(1<<TIF_FREEZE)
 #define _TIF_RUNLATCH		(1<<TIF_RUNLATCH)
 #define _TIF_ABI_PENDING	(1<<TIF_ABI_PENDING)
 #define _TIF_SYSCALL_T_OR_A	(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP)
 
-#define _TIF_USER_WORK_MASK	( _TIF_SIGPENDING | \
-				 _TIF_NEED_RESCHED | _TIF_RESTORE_SIGMASK)
+#define _TIF_USER_WORK_MASK	(_TIF_SIGPENDING | _TIF_NEED_RESCHED)
 #define _TIF_PERSYSCALL_MASK	(_TIF_RESTOREALL|_TIF_NOERROR)
 
 /* Bits in local_flags */
 /* Don't move TLF_NAPPING without adjusting the code in entry_32.S */
 #define TLF_NAPPING		0	/* idle thread enabled NAP mode */
+#define TLF_RESTORE_SIGMASK	1	/* Restore signal mask in do_signal */
 
 #define _TLF_NAPPING		(1 << TLF_NAPPING)
+#define _TLF_RESTORE_SIGMASK	(1 << TLF_RESTORE_SIGMASK)
+
+#ifndef __ASSEMBLY__
+#define HAVE_SET_RESTORE_SIGMASK	1
+static inline void set_restore_sigmask(void)
+{
+	struct thread_info *ti = current_thread_info();
+	ti->local_flags |= TLF_RESTORE_SIGMASK;
+	set_bit(TIF_SIGPENDING, &ti->flags);
+}
+#endif	/* !__ASSEMBLY__ */
 
 #endif /* __KERNEL__ */
 
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

