From: akpm@linux-foundation.org
Subject: - signals-x86-ts_restore_sigmask.patch removed from -mm tree
Date: Thu, 01 May 2008 02:27:26 -0700
Message-ID: <200805010927.m419RQvc030417@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52651 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758620AbYEAJrI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:47:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, heiko.carstens@de.ibm.com, mingo@elte.hu, oleg@tv-sign.ru, schwidefsky@de.ibm.com, tglx@linutronix.de, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     signals: x86 TS_RESTORE_SIGMASK
has been removed from the -mm tree.  Its filename was
     signals-x86-ts_restore_sigmask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 arch/x86/kernel/signal_32.c      |   17 ++++++++---------
 arch/x86/kernel/signal_64.c      |   16 +++++++++-------
 include/asm-x86/thread_info_32.h |   13 +++++++++++--
 include/asm-x86/thread_info_64.h |   13 +++++++++++--
 5 files changed, 40 insertions(+), 21 deletions(-)

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
@@ -57,7 +57,7 @@ sys_sigsuspend(int history0, int history
 
 	current->state = TASK_INTERRUPTIBLE;
 	schedule();
-	set_thread_flag(TIF_RESTORE_SIGMASK);
+	set_restore_sigmask();
 
 	return -ERESTARTNOHAND;
 }
@@ -593,7 +593,7 @@ static void do_signal(struct pt_regs *re
 	if (!user_mode(regs))
 		return;
 
-	if (test_thread_flag(TIF_RESTORE_SIGMASK))
+	if (current_thread_info()->status & TS_RESTORE_SIGMASK)
 		oldset = &current->saved_sigmask;
 	else
 		oldset = &current->blocked;
@@ -612,13 +612,12 @@ static void do_signal(struct pt_regs *re
 		/* Whee! Actually deliver the signal.  */
 		if (handle_signal(signr, &info, &ka, oldset, regs) == 0) {
 			/*
-			 * a signal was successfully delivered; the saved
+			 * A signal was successfully delivered; the saved
 			 * sigmask will have been stored in the signal frame,
 			 * and will be restored by sigreturn, so we can simply
-			 * clear the TIF_RESTORE_SIGMASK flag
+			 * clear the TS_RESTORE_SIGMASK flag.
 			 */
-			if (test_thread_flag(TIF_RESTORE_SIGMASK))
-				clear_thread_flag(TIF_RESTORE_SIGMASK);
+			current_thread_info()->status &= ~TS_RESTORE_SIGMASK;
 		}
 		return;
 	}
@@ -645,8 +644,8 @@ static void do_signal(struct pt_regs *re
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
@@ -665,7 +664,7 @@ do_notify_resume(struct pt_regs *regs, v
 	}
 
 	/* deal with pending signal delivery */
-	if (thread_info_flags & (_TIF_SIGPENDING | _TIF_RESTORE_SIGMASK))
+	if (thread_info_flags & _TIF_SIGPENDING)
 		do_signal(regs);
 
 	if (thread_info_flags & _TIF_HRTICK_RESCHED)
diff -puN arch/x86/kernel/signal_64.c~signals-x86-ts_restore_sigmask arch/x86/kernel/signal_64.c
--- a/arch/x86/kernel/signal_64.c~signals-x86-ts_restore_sigmask
+++ a/arch/x86/kernel/signal_64.c
@@ -427,7 +427,7 @@ static void do_signal(struct pt_regs *re
 	if (!user_mode(regs))
 		return;
 
-	if (test_thread_flag(TIF_RESTORE_SIGMASK))
+	if (current_thread_info()->status & TS_RESTORE_SIGMASK)
 		oldset = &current->saved_sigmask;
 	else
 		oldset = &current->blocked;
@@ -444,11 +444,13 @@ static void do_signal(struct pt_regs *re
 
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
@@ -476,8 +478,8 @@ static void do_signal(struct pt_regs *re
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
@@ -498,7 +500,7 @@ void do_notify_resume(struct pt_regs *re
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
 #define _TIF_SYSCALL_EMU	(1 << TIF_SYSCALL_EMU)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
-#define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
 #define _TIF_HRTICK_RESCHED	(1 << TIF_HRTICK_RESCHED)
 #define _TIF_DEBUG		(1 << TIF_DEBUG)
 #define _TIF_IO_BITMAP		(1 << TIF_IO_BITMAP)
@@ -188,9 +186,20 @@ static inline struct thread_info *curren
 					   this quantum (SMP) */
 #define TS_POLLING		0x0002	/* True if in idle loop
 					   and not sleeping */
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
@@ -109,7 +109,6 @@ static inline struct thread_info *stack_
 #define TIF_IRET		5	/* force IRET */
 #define TIF_SYSCALL_AUDIT	7	/* syscall auditing active */
 #define TIF_SECCOMP		8	/* secure computing */
-#define TIF_RESTORE_SIGMASK	9	/* restore signal mask in do_signal */
 #define TIF_MCE_NOTIFY		10	/* notify userspace of an MCE */
 #define TIF_HRTICK_RESCHED	11	/* reprogram hrtick timer */
 /* 16 free */
@@ -133,7 +132,6 @@ static inline struct thread_info *stack_
 #define _TIF_IRET		(1 << TIF_IRET)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
-#define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
 #define _TIF_MCE_NOTIFY		(1 << TIF_MCE_NOTIFY)
 #define _TIF_HRTICK_RESCHED	(1 << TIF_HRTICK_RESCHED)
 #define _TIF_IA32		(1 << TIF_IA32)
@@ -178,9 +176,20 @@ static inline struct thread_info *stack_
 #define TS_COMPAT		0x0002	/* 32bit syscall active */
 #define TS_POLLING		0x0004	/* true if in idle loop
 					   and not sleeping */
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
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

