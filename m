From: akpm@linux-foundation.org
Subject: + x86-do_signal-simplify-the-ts_restore_sigmask-logic.patch added to -mm tree
Date: Wed, 13 Jul 2011 12:23:45 -0700
Message-ID: <201107131923.p6DJNjri030016@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45395 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750745Ab1GMTYX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Jul 2011 15:24:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, dhowells@redhat.com, dwmw2@infradead.org, hpa@zytor.com, matt.fleming@linux.intel.com, mingo@elte.hu, tglx@linutronix.de, viro@zeniv.linux.org.uk


The patch titled
     x86: do_signal: simplify the TS_RESTORE_SIGMASK logic
has been added to the -mm tree.  Its filename is
     x86-do_signal-simplify-the-ts_restore_sigmask-logic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: do_signal: simplify the TS_RESTORE_SIGMASK logic
From: Oleg Nesterov <oleg@redhat.com>

1. do_signal() looks at TS_RESTORE_SIGMASK and calculates the
   mask which should be stored in the signal frame, then it
   passes "oldset" to the callees, down to setup_rt_frame().

   This is ugly, setup_rt_frame() can do this itself and nobody
   else needs this sigset_t. Move this code into setup_rt_frame.

2. do_signal() also clears TS_RESTORE_SIGMASK if handle_signal()
   succeeds.

   We can move this to setup_rt_frame() as well, this avoids the
   unnecessary checks and makes the logic more clear.

3. use set_current_blocked() instead of sigprocmask(SIG_SETMASK),
   sigprocmask() should be avoided.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Matt Fleming <matt.fleming@linux.intel.com>
Cc: David Howells <dhowells@redhat.com>,
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/signal.c |   29 ++++++++++-------------------
 1 file changed, 10 insertions(+), 19 deletions(-)

diff -puN arch/x86/kernel/signal.c~x86-do_signal-simplify-the-ts_restore_sigmask-logic arch/x86/kernel/signal.c
--- a/arch/x86/kernel/signal.c~x86-do_signal-simplify-the-ts_restore_sigmask-logic
+++ a/arch/x86/kernel/signal.c
@@ -653,11 +653,15 @@ int ia32_setup_frame(int sig, struct k_s
 
 static int
 setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-	       sigset_t *set, struct pt_regs *regs)
+		struct pt_regs *regs)
 {
 	int usig = signr_convert(sig);
+	sigset_t *set = &current->blocked;
 	int ret;
 
+	if (current_thread_info()->status & TS_RESTORE_SIGMASK)
+		set = &current->saved_sigmask;
+
 	/* Set up the stack frame */
 	if (is_ia32) {
 		if (ka->sa.sa_flags & SA_SIGINFO)
@@ -672,12 +676,13 @@ setup_rt_frame(int sig, struct k_sigacti
 		return -EFAULT;
 	}
 
+	current_thread_info()->status &= ~TS_RESTORE_SIGMASK;
 	return ret;
 }
 
 static int
 handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
-	      sigset_t *oldset, struct pt_regs *regs)
+		struct pt_regs *regs)
 {
 	sigset_t blocked;
 	int ret;
@@ -712,7 +717,7 @@ handle_signal(unsigned long sig, siginfo
 	    likely(test_and_clear_thread_flag(TIF_FORCED_TF)))
 		regs->flags &= ~X86_EFLAGS_TF;
 
-	ret = setup_rt_frame(sig, ka, info, oldset, regs);
+	ret = setup_rt_frame(sig, ka, info, regs);
 
 	if (ret)
 		return ret;
@@ -767,7 +772,6 @@ static void do_signal(struct pt_regs *re
 	struct k_sigaction ka;
 	siginfo_t info;
 	int signr;
-	sigset_t *oldset;
 
 	/*
 	 * We want the common case to go fast, which is why we may in certain
@@ -779,23 +783,10 @@ static void do_signal(struct pt_regs *re
 	if (!user_mode(regs))
 		return;
 
-	if (current_thread_info()->status & TS_RESTORE_SIGMASK)
-		oldset = &current->saved_sigmask;
-	else
-		oldset = &current->blocked;
-
 	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
 	if (signr > 0) {
 		/* Whee! Actually deliver the signal.  */
-		if (handle_signal(signr, &info, &ka, oldset, regs) == 0) {
-			/*
-			 * A signal was successfully delivered; the saved
-			 * sigmask will have been stored in the signal frame,
-			 * and will be restored by sigreturn, so we can simply
-			 * clear the TS_RESTORE_SIGMASK flag.
-			 */
-			current_thread_info()->status &= ~TS_RESTORE_SIGMASK;
-		}
+		handle_signal(signr, &info, &ka, regs);
 		return;
 	}
 
@@ -823,7 +814,7 @@ static void do_signal(struct pt_regs *re
 	 */
 	if (current_thread_info()->status & TS_RESTORE_SIGMASK) {
 		current_thread_info()->status &= ~TS_RESTORE_SIGMASK;
-		sigprocmask(SIG_SETMASK, &current->saved_sigmask, NULL);
+		set_current_blocked(&current->saved_sigmask);
 	}
 }
 
_

Patches currently in -mm which might be from oleg@redhat.com are

xtensa-prevent-arbitrary-read-in-ptrace.patch
xtensa-prevent-arbitrary-read-in-ptrace-fix.patch
linux-next.patch
x86-do_signal-simplify-the-ts_restore_sigmask-logic.patch
ptrace-unify-show_regs-prototype.patch
ptrace-unify-show_regs-prototype-fix.patch
signals-convert-the-ia32_emulation-code-to-use-set_current_blocked.patch
signals-convert-the-x86_32-code-to-use-set_current_blocked.patch
signals-sys_ssetmask-sys_rt_sigsuspend-should-use-set_current_blocked.patch
coredump-use-task-comm-instead-of-unknown.patch
do_coredump-fix-the-ispipe-error-check.patch
ipc-introduce-shm_rmid_forced-sysctl.patch
ipc-introduce-shm_rmid_forced-sysctl-fix-2.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch

