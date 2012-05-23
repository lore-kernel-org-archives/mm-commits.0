From: akpm@linux-foundation.org
Subject: [alternative-merged] cris-use-set_current_blocked-and-block_sigmask.patch removed from -mm tree
Date: Wed, 23 May 2012 12:47:46 -0700
Message-ID: <20120523194746.6596BA0210@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:51013 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760680Ab2EWTrr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 May 2012 15:47:47 -0400
Received: by mail-qc0-f202.google.com with SMTP id p5so922486qcs.1
        for <mm-commits@vger.kernel.org>; Wed, 23 May 2012 12:47:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matt.fleming@intel.com, jesper.nilsson@axis.com, oleg@redhat.com, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cris: use set_current_blocked() and block_sigmask()
has been removed from the -mm tree.  Its filename was
     cris-use-set_current_blocked-and-block_sigmask.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Matt Fleming <matt.fleming@intel.com>
Subject: cris: use set_current_blocked() and block_sigmask()

As described in e6fa16ab ("signal: sigprocmask() should do
retarget_shared_pending()") the modification of current->blocked is
incorrect as we need to check whether the signal we're about to block is
pending in the shared queue.

Also, use the new helper function introduced in commit 5e6292c0f28f
("signal: add block_sigmask() for adding sigmask to current->blocked")
which centralises the code for updating current->blocked after
successfully delivering a signal and reduces the amount of duplicate code
across architectures.  In the past some architectures got this code wrong,
so using this helper function should stop that from happening again.

Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Mikael Starvik <starvik@axis.com>
Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v10/kernel/signal.c |   34 ++++++++----------------
 arch/cris/arch-v32/kernel/signal.c |   37 ++++++++-------------------
 2 files changed, 23 insertions(+), 48 deletions(-)

diff -puN arch/cris/arch-v10/kernel/signal.c~cris-use-set_current_blocked-and-block_sigmask arch/cris/arch-v10/kernel/signal.c
--- a/arch/cris/arch-v10/kernel/signal.c~cris-use-set_current_blocked-and-block_sigmask
+++ a/arch/cris/arch-v10/kernel/signal.c
@@ -51,12 +51,14 @@ void do_signal(int canrestart, struct pt
 int sys_sigsuspend(old_sigset_t mask, long r11, long r12, long r13, long mof,
 	long srp, struct pt_regs *regs)
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
+
 	current->state = TASK_INTERRUPTIBLE;
 	schedule();
 	set_thread_flag(TIF_RESTORE_SIGMASK);
@@ -185,10 +187,7 @@ asmlinkage int sys_sigreturn(long r10, l
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (restore_sigcontext(regs, &frame->sc))
 		goto badframe;
@@ -224,10 +223,7 @@ asmlinkage int sys_rt_sigreturn(long r10
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (restore_sigcontext(regs, &frame->uc.uc_mcontext))
 		goto badframe;
@@ -469,15 +465,9 @@ static inline int handle_signal(int canr
 	else
 		ret = setup_frame(sig, ka, oldset, regs);
 
-	if (ret == 0) {
-		spin_lock_irq(&current->sighand->siglock);
-		sigorsets(&current->blocked, &current->blocked,
-			&ka->sa.sa_mask);
-		if (!(ka->sa.sa_flags & SA_NODEFER))
-			sigaddset(&current->blocked, sig);
-		recalc_sigpending();
-		spin_unlock_irq(&current->sighand->siglock);
-	}
+	if (ret == 0)
+		block_sigmask(ka, sig);
+
 	return ret;
 }
 
diff -puN arch/cris/arch-v32/kernel/signal.c~cris-use-set_current_blocked-and-block_sigmask arch/cris/arch-v32/kernel/signal.c
--- a/arch/cris/arch-v32/kernel/signal.c~cris-use-set_current_blocked-and-block_sigmask
+++ a/arch/cris/arch-v32/kernel/signal.c
@@ -62,12 +62,14 @@ int
 sys_sigsuspend(old_sigset_t mask, long r11, long r12, long r13, long mof,
 	       long srp, struct pt_regs *regs)
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
+
 	current->state = TASK_INTERRUPTIBLE;
 	schedule();
 	set_thread_flag(TIF_RESTORE_SIGMASK);
@@ -176,12 +178,7 @@ sys_sigreturn(long r10, long r11, long r
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-
-	current->blocked = set;
-
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (restore_sigcontext(regs, &frame->sc))
 		goto badframe;
@@ -222,12 +219,7 @@ sys_rt_sigreturn(long r10, long r11, lon
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-
-	current->blocked = set;
-
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (restore_sigcontext(regs, &frame->uc.uc_mcontext))
 		goto badframe;
@@ -515,15 +507,8 @@ handle_signal(int canrestart, unsigned l
 	if (ka->sa.sa_flags & SA_ONESHOT)
 		ka->sa.sa_handler = SIG_DFL;
 
-	if (ret == 0) {
-		spin_lock_irq(&current->sighand->siglock);
-		sigorsets(&current->blocked, &current->blocked,
-			&ka->sa.sa_mask);
-		if (!(ka->sa.sa_flags & SA_NODEFER))
-			sigaddset(&current->blocked, sig);
-		recalc_sigpending();
-		spin_unlock_irq(&current->sighand->siglock);
-	}
+	if (ret == 0)
+		block_sigmask(ka, sig);
 
 	return ret;
 }
_

Patches currently in -mm which might be from matt.fleming@intel.com are

linux-next.patch
ia64-use-set_current_blocked-and-block_sigmask.patch
microblaze-dont-reimplement-force_sigsegv.patch
microblaze-no-need-to-reset-handler-if-sa_oneshot.patch
microblaze-fix-signal-masking.patch
microblaze-use-set_current_blocked-and-block_sigmask.patch
score-dont-mask-signals-if-we-fail-to-setup-signal-stack.patch
score-use-set_current_blocked-and-block_sigmask.patch
h8300-use-set_current_blocked-and-block_sigmask.patch
unicore32-use-block_sigmask.patch
blackfin-use-set_current_blocked-and-block_sigmask.patch
frv-use-set_current_blocked-and-block_sigmask.patch
parisc-use-set_current_blocked-and-block_sigmask.patch

