From: akpm@linux-foundation.org
Subject: [merged] signals-convert-the-x86_32-code-to-use-set_current_blocked.patch removed from -mm tree
Date: Thu, 21 Jul 2011 12:12:38 -0700
Message-ID: <201107211912.p6LJCVlr032261@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52799 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753189Ab1GUTNL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Jul 2011 15:13:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, hpa@zytor.com, matt.fleming@linux.intel.com, mingo@elte.hu, tglx@linutronix.de, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     signals: convert the X86_32 code to use set_current_blocked()
has been removed from the -mm tree.  Its filename was
     signals-convert-the-x86_32-code-to-use-set_current_blocked.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
signals-sys_ssetmask-sys_rt_sigsuspend-should-use-set_current_blocked.patch
coredump-use-task-comm-instead-of-unknown.patch
do_coredump-fix-the-ispipe-error-check.patch
fs-execc-acct_arg_size-ptl-is-no-longer-needed-for-add_mm_counter.patch
ipc-introduce-shm_rmid_forced-sysctl.patch
ipc-introduce-shm_rmid_forced-sysctl-fix-2.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch

