From: akpm@linux-foundation.org
Subject: [alternative-merged] h8300-use-set_current_blocked-and-block_sigmask.patch removed from -mm tree
Date: Wed, 23 May 2012 12:49:19 -0700
Message-ID: <20120523194919.8A4A8A0210@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:48230 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760680Ab2EWTtW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 May 2012 15:49:22 -0400
Received: by faaa25 with SMTP id a25so444758faa.1
        for <mm-commits@vger.kernel.org>; Wed, 23 May 2012 12:49:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matt.fleming@intel.com, oleg@redhat.com, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: h8300: use set_current_blocked() and block_sigmask()
has been removed from the -mm tree.  Its filename was
     h8300-use-set_current_blocked-and-block_sigmask.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Matt Fleming <matt.fleming@intel.com>
Subject: h8300: use set_current_blocked() and block_sigmask()

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
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/kernel/signal.c |   33 +++++++++------------------------
 1 file changed, 9 insertions(+), 24 deletions(-)

diff -puN arch/h8300/kernel/signal.c~h8300-use-set_current_blocked-and-block_sigmask arch/h8300/kernel/signal.c
--- a/arch/h8300/kernel/signal.c~h8300-use-set_current_blocked-and-block_sigmask
+++ a/arch/h8300/kernel/signal.c
@@ -57,14 +57,13 @@ asmlinkage int do_signal(struct pt_regs 
 asmlinkage int do_sigsuspend(struct pt_regs *regs)
 {
 	old_sigset_t mask = regs->er3;
-	sigset_t saveset;
+	sigset_t saveset, blocked;
 
-	mask &= _BLOCKABLE;
-	spin_lock_irq(&current->sighand->siglock);
 	saveset = current->blocked;
-	siginitset(&current->blocked, mask);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+
+	mask &= _BLOCKABLE;
+	siginitset(&blocked, mask);
+	set_current_blocked(&blocked);
 
 	regs->er0 = -EINTR;
 	while (1) {
@@ -90,11 +89,8 @@ do_rt_sigsuspend(struct pt_regs *regs)
 		return -EFAULT;
 	sigdelsetmask(&newset, ~_BLOCKABLE);
 
-	spin_lock_irq(&current->sighand->siglock);
 	saveset = current->blocked;
-	current->blocked = newset;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&newset);
 
 	regs->er0 = -EINTR;
 	while (1) {
@@ -232,10 +228,7 @@ asmlinkage int do_sigreturn(unsigned lon
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 	
 	if (restore_sigcontext(regs, &frame->sc, &er0))
 		goto badframe;
@@ -260,10 +253,7 @@ asmlinkage int do_rt_sigreturn(unsigned 
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_unlock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_lock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 	
 	if (restore_sigcontext(regs, &frame->uc.uc_mcontext, &er0))
 		goto badframe;
@@ -489,12 +479,7 @@ handle_signal(unsigned long sig, siginfo
 	else
 		setup_frame(sig, ka, oldset, regs);
 
-	spin_lock_irq(&current->sighand->siglock);
-	sigorsets(&current->blocked,&current->blocked,&ka->sa.sa_mask);
-	if (!(ka->sa.sa_flags & SA_NODEFER))
-		sigaddset(&current->blocked,sig);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	block_sigmask(ka, sig);
 }
 
 /*
_

Patches currently in -mm which might be from matt.fleming@intel.com are

linux-next.patch
unicore32-use-block_sigmask.patch
blackfin-use-set_current_blocked-and-block_sigmask.patch
frv-use-set_current_blocked-and-block_sigmask.patch
parisc-use-set_current_blocked-and-block_sigmask.patch

