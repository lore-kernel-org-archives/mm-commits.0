From: akpm@linux-foundation.org
Subject: + signals-convert-the-x86_32-code-to-use-set_current_blocked.patch added to -mm tree
Date: Tue, 12 Jul 2011 16:52:08 -0700
Message-ID: <201107122352.p6CNq8q8011916@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33535 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751203Ab1GLXwn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jul 2011 19:52:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, hpa@zytor.com, matt.fleming@linux.intel.com, mingo@elte.hu, tglx@linutronix.de, tj@kernel.org


The patch titled
     signals: convert the X86_32 code to use set_current_blocked()
has been added to the -mm tree.  Its filename is
     signals-convert-the-x86_32-code-to-use-set_current_blocked.patch

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
Subject: signals: convert the X86_32 code to use set_current_blocked()
From: Oleg Nesterov <oleg@redhat.com>

sys_sigsuspend() and sys_sigreturn() change ->blocked directly.  This is
not correct, see the changelog in e6fa16ab "signal: sigprocmask() should
do retarget_shared_pending()"

Change them to use set_current_blocked().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Matt Fleming <matt.fleming@linux.intel.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/signal.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff -puN arch/x86/kernel/signal.c~signals-convert-the-x86_32-code-to-use-set_current_blocked arch/x86/kernel/signal.c
--- a/arch/x86/kernel/signal.c~signals-convert-the-x86_32-code-to-use-set_current_blocked
+++ a/arch/x86/kernel/signal.c
@@ -485,17 +485,18 @@ static int __setup_rt_frame(int sig, str
 asmlinkage int
 sys_sigsuspend(int history0, int history1, old_sigset_t mask)
 {
-	mask &= _BLOCKABLE;
-	spin_lock_irq(&current->sighand->siglock);
+	sigset_t blocked;
+
 	current->saved_sigmask = current->blocked;
-	siginitset(&current->blocked, mask);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+
+	mask &= _BLOCKABLE;
+	siginitset(&blocked, mask);
+	set_current_blocked(&blocked);
 
 	current->state = TASK_INTERRUPTIBLE;
 	schedule();
-	set_restore_sigmask();
 
+	set_restore_sigmask();
 	return -ERESTARTNOHAND;
 }
 
@@ -572,10 +573,7 @@ unsigned long sys_sigreturn(struct pt_re
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (restore_sigcontext(regs, &frame->sc, &ax))
 		goto badframe;
_

Patches currently in -mm which might be from oleg@redhat.com are

xtensa-prevent-arbitrary-read-in-ptrace.patch
xtensa-prevent-arbitrary-read-in-ptrace-fix.patch
linux-next.patch
ptrace-unify-show_regs-prototype.patch
ptrace-unify-show_regs-prototype-fix.patch
signals-convert-the-ia32_emulation-code-to-use-set_current_blocked.patch
signals-convert-the-x86_32-code-to-use-set_current_blocked.patch
coredump-use-task-comm-instead-of-unknown.patch
do_coredump-fix-the-ispipe-error-check.patch
ipc-introduce-shm_rmid_forced-sysctl.patch
ipc-introduce-shm_rmid_forced-sysctl-fix-2.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch

