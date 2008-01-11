From: akpm@linux-foundation.org
Subject: + cris-v10-correct-do_signal-to-fix-oops-and-clean-up-signal-handling-in-general.patch added to -mm tree
Date: Fri, 11 Jan 2008 15:45:19 -0800
Message-ID: <200801112345.m0BNjKE5003991@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51795 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757731AbYAKXpZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jan 2008 18:45:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.nilsson@axis.com, mikael.starvik@axis.com


The patch titled
     CRIS v10: correct do_signal to fix oops and clean up signal handling in general
has been added to the -mm tree.  Its filename is
     cris-v10-correct-do_signal-to-fix-oops-and-clean-up-signal-handling-in-general.patch

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
Subject: CRIS v10: correct do_signal to fix oops and clean up signal handling in general
From: Jesper Nilsson <jesper.nilsson@axis.com>

This fixes a kernel panic on boot due to do_signal not being compatible
with it's callers.

- do_signal now returns void, and does not have the previous signal set
  as a parameter.
- Remove sys_rt_sigsuspend, we can use the common one instead.
- Change sys_sigsuspend to be more like x86, don't call do_signal here.
- handle_signal, setup_frame and setup_rt_frame now return -EFAULT
  if we've delivered a segfault, which is used by callers to perform
  necessary cleanup.
- Break long lines, correct whitespace and formatting errors.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <mikael.starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v10/kernel/signal.c |  247 ++++++++++++---------------
 1 file changed, 110 insertions(+), 137 deletions(-)

diff -puN arch/cris/arch-v10/kernel/signal.c~cris-v10-correct-do_signal-to-fix-oops-and-clean-up-signal-handling-in-general arch/cris/arch-v10/kernel/signal.c
--- a/arch/cris/arch-v10/kernel/signal.c~cris-v10-correct-do_signal-to-fix-oops-and-clean-up-signal-handling-in-general
+++ a/arch/cris/arch-v10/kernel/signal.c
@@ -7,7 +7,7 @@
  *
  *  Ideas also taken from arch/arm.
  *
- *  Copyright (C) 2000, 2001 Axis Communications AB
+ *  Copyright (C) 2000-2007 Axis Communications AB
  *
  *  Authors:  Bjorn Wesen (bjornw@axis.com)
  *
@@ -40,84 +40,30 @@
  */
 #define RESTART_CRIS_SYS(regs) regs->r10 = regs->orig_r10; regs->irp -= 2;
 
-int do_signal(int canrestart, sigset_t *oldset, struct pt_regs *regs);
+void do_signal(int canrestart, struct pt_regs *regs);
 
 /*
- * Atomically swap in the new signal mask, and wait for a signal.  Define 
+ * Atomically swap in the new signal mask, and wait for a signal.  Define
  * dummy arguments to be able to reach the regs argument.  (Note that this
  * arrangement relies on old_sigset_t occupying one register.)
  */
-int
-sys_sigsuspend(old_sigset_t mask, long r11, long r12, long r13, long mof, 
-               long srp, struct pt_regs *regs)
+int sys_sigsuspend(old_sigset_t mask, long r11, long r12, long r13, long mof,
+	long srp, struct pt_regs *regs)
 {
-	sigset_t saveset;
-
 	mask &= _BLOCKABLE;
 	spin_lock_irq(&current->sighand->siglock);
-	saveset = current->blocked;
+	current->saved_sigmask = current->blocked;
 	siginitset(&current->blocked, mask);
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
-
-	regs->r10 = -EINTR;
-	while (1) {
-		current->state = TASK_INTERRUPTIBLE;
-		schedule();
-		if (do_signal(0, &saveset, regs))
-			/* We will get here twice: once to call the signal
-			   handler, then again to return from the
-			   sigsuspend system call.  When calling the
-			   signal handler, R10 holds the signal number as
-			   set through do_signal.  The sigsuspend call
-			   will return with the restored value set above;
-			   always -EINTR.  */
-			return regs->r10;
-	}
+	current->state = TASK_INTERRUPTIBLE;
+	schedule();
+	set_thread_flag(TIF_RESTORE_SIGMASK);
+	return -ERESTARTNOHAND;
 }
 
-/* Define dummy arguments to be able to reach the regs argument.  (Note that
- * this arrangement relies on size_t occupying one register.)
- */
-int
-sys_rt_sigsuspend(sigset_t *unewset, size_t sigsetsize, long r12, long r13, 
-                  long mof, long srp, struct pt_regs *regs)
-{
-	sigset_t saveset, newset;
-
-	/* XXX: Don't preclude handling different sized sigset_t's.  */
-	if (sigsetsize != sizeof(sigset_t))
-		return -EINVAL;
-
-	if (copy_from_user(&newset, unewset, sizeof(newset)))
-		return -EFAULT;
-	sigdelsetmask(&newset, ~_BLOCKABLE);
-
-	spin_lock_irq(&current->sighand->siglock);
-	saveset = current->blocked;
-	current->blocked = newset;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
-
-	regs->r10 = -EINTR;
-	while (1) {
-		current->state = TASK_INTERRUPTIBLE;
-		schedule();
-		if (do_signal(0, &saveset, regs))
-			/* We will get here twice: once to call the signal
-			   handler, then again to return from the
-			   sigsuspend system call.  When calling the
-			   signal handler, R10 holds the signal number as
-			   set through do_signal.  The sigsuspend call
-			   will return with the restored value set above;
-			   always -EINTR.  */
-			return regs->r10;
-	}
-}
-
-int 
-sys_sigaction(int sig, const struct old_sigaction __user *act,
-	      struct old_sigaction *oact)
+int sys_sigaction(int sig, const struct old_sigaction __user *act,
+	struct old_sigaction *oact)
 {
 	struct k_sigaction new_ka, old_ka;
 	int ret;
@@ -147,8 +93,7 @@ sys_sigaction(int sig, const struct old_
 	return ret;
 }
 
-int
-sys_sigaltstack(const stack_t *uss, stack_t __user *uoss)
+int sys_sigaltstack(const stack_t *uss, stack_t __user *uoss)
 {
 	return do_sigaltstack(uss, uoss, rdusp());
 }
@@ -205,7 +150,7 @@ restore_sigcontext(struct pt_regs *regs,
 
 	/* TODO: the other ports use regs->orig_XX to disable syscall checks
 	 * after this completes, but we don't use that mechanism. maybe we can
-	 * use it now ? 
+	 * use it now ?
 	 */
 
 	return err;
@@ -216,7 +161,7 @@ badframe:
 
 /* Define dummy arguments to be able to reach the regs argument.  */
 
-asmlinkage int sys_sigreturn(long r10, long r11, long r12, long r13, long mof, 
+asmlinkage int sys_sigreturn(long r10, long r11, long r12, long r13, long mof,
                              long srp, struct pt_regs *regs)
 {
 	struct sigframe __user *frame = (struct sigframe *)rdusp();
@@ -243,7 +188,7 @@ asmlinkage int sys_sigreturn(long r10, l
 	current->blocked = set;
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
-	
+
 	if (restore_sigcontext(regs, &frame->sc))
 		goto badframe;
 
@@ -254,11 +199,11 @@ asmlinkage int sys_sigreturn(long r10, l
 badframe:
 	force_sig(SIGSEGV, current);
 	return 0;
-}	
+}
 
 /* Define dummy arguments to be able to reach the regs argument.  */
 
-asmlinkage int sys_rt_sigreturn(long r10, long r11, long r12, long r13, 
+asmlinkage int sys_rt_sigreturn(long r10, long r11, long r12, long r13,
                                 long mof, long srp, struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame = (struct rt_sigframe *)rdusp();
@@ -282,7 +227,7 @@ asmlinkage int sys_rt_sigreturn(long r10
 	current->blocked = set;
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
-	
+
 	if (restore_sigcontext(regs, &frame->uc.uc_mcontext))
 		goto badframe;
 
@@ -294,14 +239,14 @@ asmlinkage int sys_rt_sigreturn(long r10
 badframe:
 	force_sig(SIGSEGV, current);
 	return 0;
-}	
+}
 
 /*
  * Set up a signal frame.
  */
 
-static int
-setup_sigcontext(struct sigcontext __user *sc, struct pt_regs *regs, unsigned long mask)
+static int setup_sigcontext(struct sigcontext __user *sc,
+	struct pt_regs *regs, unsigned long mask)
 {
 	int err = 0;
 	unsigned long usp = rdusp();
@@ -324,10 +269,11 @@ setup_sigcontext(struct sigcontext __use
 	return err;
 }
 
-/* figure out where we want to put the new signal frame - usually on the stack */
+/* Figure out where we want to put the new signal frame
+ * - usually on the stack. */
 
 static inline void __user *
-get_sigframe(struct k_sigaction *ka, struct pt_regs * regs, size_t frame_size)
+get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size)
 {
 	unsigned long sp = rdusp();
 
@@ -345,15 +291,15 @@ get_sigframe(struct k_sigaction *ka, str
 }
 
 /* grab and setup a signal frame.
- * 
+ *
  * basically we stack a lot of state info, and arrange for the
  * user-mode program to return to the kernel using either a
  * trampoline which performs the syscall sigreturn, or a provided
  * user-mode trampoline.
  */
 
-static void setup_frame(int sig, struct k_sigaction *ka,
-			sigset_t *set, struct pt_regs * regs)
+static int setup_frame(int sig, struct k_sigaction *ka,
+		       sigset_t *set, struct pt_regs *regs)
 {
 	struct sigframe __user *frame;
 	unsigned long return_ip;
@@ -401,14 +347,15 @@ static void setup_frame(int sig, struct 
 
 	wrusp((unsigned long)frame);
 
-	return;
+	return 0;
 
 give_sigsegv:
 	force_sigsegv(sig, current);
+	return -EFAULT;
 }
 
-static void setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-			   sigset_t *set, struct pt_regs * regs)
+static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
+	sigset_t *set, struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
 	unsigned long return_ip;
@@ -443,9 +390,10 @@ static void setup_rt_frame(int sig, stru
 		/* trampoline - the desired return ip is the retcode itself */
 		return_ip = (unsigned long)&frame->retcode;
 		/* This is movu.w __NR_rt_sigreturn, r9; break 13; */
-		err |= __put_user(0x9c5f,            (short __user*)(frame->retcode+0));
-		err |= __put_user(__NR_rt_sigreturn, (short __user*)(frame->retcode+2));
-		err |= __put_user(0xe93d,            (short __user*)(frame->retcode+4));
+		err |= __put_user(0x9c5f, (short __user *)(frame->retcode+0));
+		err |= __put_user(__NR_rt_sigreturn,
+			(short __user *)(frame->retcode+2));
+		err |= __put_user(0xe93d, (short __user *)(frame->retcode+4));
 	}
 
 	if (err)
@@ -455,73 +403,81 @@ static void setup_rt_frame(int sig, stru
 
 	/* Set up registers for signal handler */
 
-	regs->irp = (unsigned long) ka->sa.sa_handler;  /* what we enter NOW   */
-	regs->srp = return_ip;                          /* what we enter LATER */
-	regs->r10 = sig;                                /* first argument is signo */
-        regs->r11 = (unsigned long) &frame->info;       /* second argument is (siginfo_t *) */
-        regs->r12 = 0;                                  /* third argument is unused */
-
-	/* actually move the usp to reflect the stacked frame */
+	/* What we enter NOW   */
+	regs->irp = (unsigned long) ka->sa.sa_handler;
+	/* What we enter LATER */
+	regs->srp = return_ip;
+	/* First argument is signo */
+	regs->r10 = sig;
+	/* Second argument is (siginfo_t *) */
+	regs->r11 = (unsigned long)&frame->info;
+	/* Third argument is unused */
+	regs->r12 = 0;
 
+	/* Actually move the usp to reflect the stacked frame */
 	wrusp((unsigned long)frame);
 
-	return;
+	return 0;
 
 give_sigsegv:
 	force_sigsegv(sig, current);
+	return -EFAULT;
 }
 
 /*
  * OK, we're invoking a handler
- */	
+ */
 
-static inline void
-handle_signal(int canrestart, unsigned long sig,
-	      siginfo_t *info, struct k_sigaction *ka,
-              sigset_t *oldset, struct pt_regs * regs)
+static inline int handle_signal(int canrestart, unsigned long sig,
+	siginfo_t *info, struct k_sigaction *ka,
+	sigset_t *oldset, struct pt_regs *regs)
 {
+	int ret;
+
 	/* Are we from a system call? */
 	if (canrestart) {
 		/* If so, check system call restarting.. */
 		switch (regs->r10) {
-			case -ERESTART_RESTARTBLOCK:
-			case -ERESTARTNOHAND:
-				/* ERESTARTNOHAND means that the syscall should only be
-				   restarted if there was no handler for the signal, and since
-				   we only get here if there is a handler, we don't restart */
+		case -ERESTART_RESTARTBLOCK:
+		case -ERESTARTNOHAND:
+			/* ERESTARTNOHAND means that the syscall should
+			 * only be restarted if there was no handler for
+			 * the signal, and since we only get here if there
+			 * is a handler, we don't restart */
+			regs->r10 = -EINTR;
+			break;
+		case -ERESTARTSYS:
+			/* ERESTARTSYS means to restart the syscall if
+			 * there is no handler or the handler was
+			 * registered with SA_RESTART */
+			if (!(ka->sa.sa_flags & SA_RESTART)) {
 				regs->r10 = -EINTR;
 				break;
-
-			case -ERESTARTSYS:
-				/* ERESTARTSYS means to restart the syscall if there is no
-				   handler or the handler was registered with SA_RESTART */
-				if (!(ka->sa.sa_flags & SA_RESTART)) {
-					regs->r10 = -EINTR;
-					break;
-				}
-			/* fallthrough */
-			case -ERESTARTNOINTR:
-				/* ERESTARTNOINTR means that the syscall should be called again
-				   after the signal handler returns. */
-				RESTART_CRIS_SYS(regs);
+			}
+		/* fallthrough */
+		case -ERESTARTNOINTR:
+			/* ERESTARTNOINTR means that the syscall should
+			 * be called again after the signal handler returns. */
+			RESTART_CRIS_SYS(regs);
 		}
 	}
 
 	/* Set up the stack frame */
 	if (ka->sa.sa_flags & SA_SIGINFO)
-		setup_rt_frame(sig, ka, info, oldset, regs);
+		ret = setup_rt_frame(sig, ka, info, oldset, regs);
 	else
-		setup_frame(sig, ka, oldset, regs);
-
-	if (ka->sa.sa_flags & SA_ONESHOT)
-		ka->sa.sa_handler = SIG_DFL;
+		ret = setup_frame(sig, ka, oldset, regs);
 
-	spin_lock_irq(&current->sighand->siglock);
-	sigorsets(&current->blocked,&current->blocked,&ka->sa.sa_mask);
-	if (!(ka->sa.sa_flags & SA_NODEFER))
-		sigaddset(&current->blocked,sig);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	if (ret == 0) {
+		spin_lock_irq(&current->sighand->siglock);
+		sigorsets(&current->blocked, &current->blocked,
+			&ka->sa.sa_mask);
+		if (!(ka->sa.sa_flags & SA_NODEFER))
+			sigaddset(&current->blocked, sig);
+		recalc_sigpending();
+		spin_unlock_irq(&current->sighand->siglock);
+	}
+	return ret;
 }
 
 /*
@@ -536,11 +492,12 @@ handle_signal(int canrestart, unsigned l
  * mode below.
  */
 
-int do_signal(int canrestart, sigset_t *oldset, struct pt_regs *regs)
+void do_signal(int canrestart, struct pt_regs *regs)
 {
 	siginfo_t info;
 	int signr;
         struct k_sigaction ka;
+	sigset_t *oldset;
 
 	/*
 	 * We want the common case to go fast, which
@@ -549,16 +506,26 @@ int do_signal(int canrestart, sigset_t *
 	 * if so.
 	 */
 	if (!user_mode(regs))
-		return 1;
+		return;
 
-	if (!oldset)
+	if (test_thread_flag(TIF_RESTORE_SIGMASK))
+		oldset = &current->saved_sigmask;
+	else
 		oldset = &current->blocked;
 
 	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
 	if (signr > 0) {
 		/* Whee!  Actually deliver the signal.  */
-		handle_signal(canrestart, signr, &info, &ka, oldset, regs);
-		return 1;
+		if (handle_signal(canrestart, signr, &info, &ka,
+				oldset, regs)) {
+			/* a signal was successfully delivered; the saved
+			 * sigmask will have been stored in the signal frame,
+			 * and will be restored by sigreturn, so we can simply
+			 * clear the TIF_RESTORE_SIGMASK flag */
+			if (test_thread_flag(TIF_RESTORE_SIGMASK))
+				clear_thread_flag(TIF_RESTORE_SIGMASK);
+		}
+		return;
 	}
 
 	/* Did we come from a system call? */
@@ -569,10 +536,16 @@ int do_signal(int canrestart, sigset_t *
 		    regs->r10 == -ERESTARTNOINTR) {
 			RESTART_CRIS_SYS(regs);
 		}
-		if (regs->r10 == -ERESTART_RESTARTBLOCK){
+		if (regs->r10 == -ERESTART_RESTARTBLOCK) {
 			regs->r10 = __NR_restart_syscall;
 			regs->irp -= 2;
 		}
 	}
-	return 0;
+
+	/* if there's no signal to deliver, we just put the saved sigmask
+	 * back */
+	if (test_thread_flag(TIF_RESTORE_SIGMASK)) {
+		clear_thread_flag(TIF_RESTORE_SIGMASK);
+		sigprocmask(SIG_SETMASK, &current->saved_sigmask, NULL);
+	}
 }
_

Patches currently in -mm which might be from jesper.nilsson@axis.com are

cris-v10-correct-do_signal-to-fix-oops-and-clean-up-signal-handling-in-general.patch
cris-v10-kernel-timec-needs-to-include-linux-vmstath-to-compile.patch
cris-v10-driver-for-ds1302-needs-to-include-cris-specific-i2ch.patch
git-kbuild.patch
git-mtd.patch
cris-avoid-using-arch-links-in-kconfig.patch
arch-cris-arch-v10-vmlinuxldss-fix-boot-problem.patch
cris-remove-unused-__dummy-const_addr-and-addr-from-bitopsh.patch
cris-define-__arch_want_sys_rt_sigsuspend-in-unistdh-for-cris.patch
avoid-overflows-in-kernel-timec.patch
