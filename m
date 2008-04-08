From: akpm@linux-foundation.org
Subject: + signals-x86-ts_restore_sigmask.patch added to -mm tree
Date: Mon, 07 Apr 2008 17:52:49 -0700
Message-ID: <200804080052.m380qnie000868@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36138 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755364AbYDHAyv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2008 20:54:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, heiko.carstens@de.ibm.com, mingo@elte.hu, oleg@tv-sign.ru, schwidefsky@de.ibm.com, tglx@linutronix.de, tony.luck@intel.com


The patch titled
     signals: x86 TS_RESTORE_SIGMASK
has been added to the -mm tree.  Its filename is
     signals-x86-ts_restore_sigmask.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: x86 TS_RESTORE_SIGMASK
From: Roland McGrath <roland@redhat.com>

Replace TIF_RESTORE_SIGMASK with TS_RESTORE_SIGMASK and define our own
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

 arch/x86/ia32/ia32_signal.c      |    2 +-
 arch/x86/kernel/signal_32.c      |   19 ++++++++++---------
 arch/x86/kernel/signal_64.c      |   16 +++++++++-------
 include/asm-x86/thread_info_32.h |   13 +++++++++++--
 include/asm-x86/thread_info_64.h |   13 +++++++++++--
 5 files changed, 42 insertions(+), 21 deletions(-)

diff -puN arch/x86/ia32/ia32_signal.c~signals-x86-ts_restore_sigmask arch/x86/ia32/ia32_signal.c
--- a/arch/x86/ia32/ia32_signal.c~signals-x86-ts_restore_sigmask
+++ a/arch/x86/ia32/ia32_signal.c
@@ -128,7 +128,7 @@ asmlinkage long sys32_sigsuspend(int his
 
 	current->state = TASK_INTERRUPTIBLE;
 	schedule();
-	set_thread_flag(TIF_RESTORE_SIGMASK);
+	set_restore_sigmask();
 	return -ERESTARTNOHAND;
 }
 
diff -puN arch/x86/kernel/signal_32.c~signals-x86-ts_restore_sigmask arch/x86/kernel/signal_32.c
--- a/arch/x86/kernel/signal_32.c~signals-x86-ts_restore_sigmask
+++ a/arch/x86/kernel/signal_32.c
@@ -56,7 +56,7 @@ sys_sigsuspend(int history0, int history
 
 	current->state = TASK_INTERRUPTIBLE;
 	schedule();
-	set_thread_flag(TIF_RESTORE_SIGMASK);
+	set_restore_sigmask();
 	return -ERESTARTNOHAND;
 }
 
@@ -597,7 +597,7 @@ static void do_signal(struct pt_regs *re
 	if (!user_mode(regs))
 		return;
 
-	if (test_thread_flag(TIF_RESTORE_SIGMASK))
+	if (current_thread_info()->status & TS_RESTORE_SIGMASK)
 		oldset = &current->saved_sigmask;
 	else
 		oldset = &current->blocked;
@@ -614,12 +614,13 @@ static void do_signal(struct pt_regs *re
 
 		/* Whee!  Actually deliver the signal.  */
 		if (handle_signal(signr, &info, &ka, oldset, regs) == 0) {
-			/* a signal was successfully delivered; the saved
+			/*
+			 * A signal was successfully delivered; the saved
 			 * sigmask will have been stored in the signal frame,
 			 * and will be restored by sigreturn, so we can simply
-			 * clear the TIF_RESTORE_SIGMASK flag */
-			if (test_thread_flag(TIF_RESTORE_SIGMASK))
-				clear_thread_flag(TIF_RESTORE_SIGMASK);
+			 * clear the TS_RESTORE_SIGMASK flag.
+			 */
+			current_thread_info()->status &= ~TS_RESTORE_SIGMASK;
 		}
 
 		return;
@@ -647,8 +648,8 @@ static void do_signal(struct pt_regs *re
 	 * If there's no signal to deliver, we just put the saved sigmask
 	 * back.
 	 */
-	if (test_thread_flag(TIF_RESTORE_SIGMASK)) {
-		clear_thread_flag(TIF_RESTORE_SIGMASK);
+	if (current_thread_info()->status & TS_RESTORE_SIGMASK) {
+		current_thread_info()->status &= ~TS_RESTORE_SIGMASK;
 		sigprocmask(SIG_SETMASK, &current->saved_sigmask, NULL);
 	}
 }
@@ -667,7 +668,7 @@ void do_notify_resume(struct pt_regs *re
 	}
 
 	/* deal with pending signal delivery */
-	if (thread_info_flags & (_TIF_SIGPENDING | _TIF_RESTORE_SIGMASK))
+	if (thread_info_flags & _TIF_SIGPENDING)
 		do_signal(regs);
 
 	if (thread_info_flags & _TIF_HRTICK_RESCHED)
diff -puN arch/x86/kernel/signal_64.c~signals-x86-ts_restore_sigmask arch/x86/kernel/signal_64.c
--- a/arch/x86/kernel/signal_64.c~signals-x86-ts_restore_sigmask
+++ a/arch/x86/kernel/signal_64.c
@@ -433,7 +433,7 @@ static void do_signal(struct pt_regs *re
 	if (!user_mode(regs))
 		return;
 
-	if (test_thread_flag(TIF_RESTORE_SIGMASK))
+	if (current_thread_info()->status & TS_RESTORE_SIGMASK)
 		oldset = &current->saved_sigmask;
 	else
 		oldset = &current->blocked;
@@ -450,11 +450,13 @@ static void do_signal(struct pt_regs *re
 
 		/* Whee!  Actually deliver the signal.  */
 		if (handle_signal(signr, &info, &ka, oldset, regs) == 0) {
-			/* a signal was successfully delivered; the saved
+			/*
+			 * A signal was successfully delivered; the saved
 			 * sigmask will have been stored in the signal frame,
 			 * and will be restored by sigreturn, so we can simply
-			 * clear the TIF_RESTORE_SIGMASK flag */
-			clear_thread_flag(TIF_RESTORE_SIGMASK);
+			 * clear the TS_RESTORE_SIGMASK flag.
+			 */
+			current_thread_info()->status &= ~TS_RESTORE_SIGMASK;
 		}
 		return;
 	}
@@ -482,8 +484,8 @@ static void do_signal(struct pt_regs *re
 	 * If there's no signal to deliver, we just put the saved sigmask
 	 * back.
 	 */
-	if (test_thread_flag(TIF_RESTORE_SIGMASK)) {
-		clear_thread_flag(TIF_RESTORE_SIGMASK);
+	if (current_thread_info()->status & TS_RESTORE_SIGMASK) {
+		current_thread_info()->status &= ~TS_RESTORE_SIGMASK;
 		sigprocmask(SIG_SETMASK, &current->saved_sigmask, NULL);
 	}
 }
@@ -509,7 +511,7 @@ void do_notify_resume(struct pt_regs *re
 #endif /* CONFIG_X86_MCE */
 
 	/* deal with pending signal delivery */
-	if (thread_info_flags & (_TIF_SIGPENDING | _TIF_RESTORE_SIGMASK))
+	if (thread_info_flags & _TIF_SIGPENDING)
 		do_signal(regs);
 
 	if (thread_info_flags & _TIF_HRTICK_RESCHED)
diff -puN include/asm-x86/thread_info_32.h~signals-x86-ts_restore_sigmask include/asm-x86/thread_info_32.h
--- a/include/asm-x86/thread_info_32.h~signals-x86-ts_restore_sigmask
+++ a/include/asm-x86/thread_info_32.h
@@ -131,7 +131,6 @@ static inline struct thread_info *curren
 #define TIF_SYSCALL_EMU		5	/* syscall emulation active */
 #define TIF_SYSCALL_AUDIT	6	/* syscall auditing active */
 #define TIF_SECCOMP		7	/* secure computing */
-#define TIF_RESTORE_SIGMASK	8	/* restore signal mask in do_signal() */
 #define TIF_HRTICK_RESCHED	9	/* reprogram hrtick timer */
 #define TIF_MEMDIE		16
 #define TIF_DEBUG		17	/* uses debug registers */
@@ -151,7 +150,6 @@ static inline struct thread_info *curren
 #define _TIF_SYSCALL_EMU	(1<<TIF_SYSCALL_EMU)
 #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
 #define _TIF_SECCOMP		(1<<TIF_SECCOMP)
-#define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
 #define _TIF_HRTICK_RESCHED	(1<<TIF_HRTICK_RESCHED)
 #define _TIF_DEBUG		(1<<TIF_DEBUG)
 #define _TIF_IO_BITMAP		(1<<TIF_IO_BITMAP)
@@ -186,9 +184,20 @@ static inline struct thread_info *curren
  */
 #define TS_USEDFPU		0x0001	/* FPU was used by this task this quantum (SMP) */
 #define TS_POLLING		0x0002	/* True if in idle loop and not sleeping */
+#define TS_RESTORE_SIGMASK	0x0004	/* restore signal mask in do_signal() */
 
 #define tsk_is_polling(t) (task_thread_info(t)->status & TS_POLLING)
 
+#ifndef __ASSEMBLY__
+#define HAVE_SET_RESTORE_SIGMASK	1
+static inline void set_restore_sigmask(void)
+{
+	struct thread_info *ti = current_thread_info();
+	ti->status |= TS_RESTORE_SIGMASK;
+	set_bit(TIF_SIGPENDING, &ti->flags);
+}
+#endif	/* !__ASSEMBLY__ */
+
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_THREAD_INFO_H */
diff -puN include/asm-x86/thread_info_64.h~signals-x86-ts_restore_sigmask include/asm-x86/thread_info_64.h
--- a/include/asm-x86/thread_info_64.h~signals-x86-ts_restore_sigmask
+++ a/include/asm-x86/thread_info_64.h
@@ -110,7 +110,6 @@ static inline struct thread_info *stack_
 #define TIF_IRET		5	/* force IRET */
 #define TIF_SYSCALL_AUDIT	7	/* syscall auditing active */
 #define TIF_SECCOMP		8	/* secure computing */
-#define TIF_RESTORE_SIGMASK	9	/* restore signal mask in do_signal */
 #define TIF_MCE_NOTIFY		10	/* notify userspace of an MCE */
 #define TIF_HRTICK_RESCHED	11	/* reprogram hrtick timer */
 /* 16 free */
@@ -133,7 +132,6 @@ static inline struct thread_info *stack_
 #define _TIF_IRET		(1<<TIF_IRET)
 #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
 #define _TIF_SECCOMP		(1<<TIF_SECCOMP)
-#define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
 #define _TIF_MCE_NOTIFY		(1<<TIF_MCE_NOTIFY)
 #define _TIF_HRTICK_RESCHED	(1<<TIF_HRTICK_RESCHED)
 #define _TIF_IA32		(1<<TIF_IA32)
@@ -174,9 +172,20 @@ static inline struct thread_info *stack_
 #define TS_USEDFPU		0x0001	/* FPU was used by this task this quantum (SMP) */
 #define TS_COMPAT		0x0002	/* 32bit syscall active */
 #define TS_POLLING		0x0004	/* true if in idle loop and not sleeping */
+#define TS_RESTORE_SIGMASK	0x0008	/* restore signal mask in do_signal() */
 
 #define tsk_is_polling(t) (task_thread_info(t)->status & TS_POLLING)
 
+#ifndef __ASSEMBLY__
+#define HAVE_SET_RESTORE_SIGMASK	1
+static inline void set_restore_sigmask(void)
+{
+	struct thread_info *ti = current_thread_info();
+	ti->status |= TS_RESTORE_SIGMASK;
+	set_bit(TIF_SIGPENDING, &ti->flags);
+}
+#endif	/* !__ASSEMBLY__ */
+
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_THREAD_INFO_H */
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
git-x86.patch
x86-handle_vm86_trap-cleanup.patch
x86_64-ia32-ptrace-vs-enosys.patch
x86_64-ptrace-vs-enosys.patch
x86_64-ia32-ptrace-vs-enosys-sysenter-syscall.patch
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

