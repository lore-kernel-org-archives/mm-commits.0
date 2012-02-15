From: akpm@linux-foundation.org
Subject: + h8300-use-set_current_blocked-and-block_sigmask.patch added to -mm tree
Date: Tue, 14 Feb 2012 16:33:42 -0800
Message-ID: <20120215003342.F28A5A02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:61428 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757400Ab2BOAdp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Feb 2012 19:33:45 -0500
Received: by eekb15 with SMTP id b15so18497eek.1
        for <mm-commits@vger.kernel.org>; Tue, 14 Feb 2012 16:33:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matt.fleming@intel.com, oleg@redhat.com, ysato@users.sourceforge.jp


The patch titled
     Subject: h8300: use set_current_blocked() and block_sigmask()
has been added to the -mm tree.  Its filename is
     h8300-use-set_current_blocked-and-block_sigmask.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: h8300: use set_current_blocked() and block_sigmask()

Patches currently in -mm which might be from matt.fleming@intel.com are

linux-next.patch
alpha-use-set_current_blocked-and-block_sigmask.patch
arm-use-set_current_blocked-and-block_sigmask.patch
avr32-dont-mask-signals-in-the-error-path.patch
avr32-use-set_current_blocked-in-handle_signal-sys_rt_sigreturn.patch
avr32-use-block_sigmask.patch
blackfin-use-set_current_blocked-and-block_sigmask.patch
c6x-use-set_current_blocked-and-block_sigmask.patch
cris-use-set_current_blocked-and-block_sigmask.patch
frv-use-set_current_blocked-and-block_sigmask.patch
h8300-use-set_current_blocked-and-block_sigmask.patch
hexagon-use-set_current_blocked-and-block_sigmask.patch
ia64-use-set_current_blocked-and-block_sigmask.patch
m32r-use-set_current_blocked-and-block_sigmask.patch
m68k-use-set_current_blocked-and-block_sigmask.patch
microblaze-dont-reimplement-force_sigsegv.patch
microblaze-no-need-to-reset-handler-if-sa_oneshot.patch
microblaze-fix-signal-masking.patch
microblaze-use-set_current_blocked-and-block_sigmask.patch
mips-use-set_current_blocked-and-block_sigmask.patch
mn10300-use-set_current_blocked-and-block_sigmask.patch
openrisc-dont-reimplement-force_sigsegv.patch
openrisc-no-need-to-reset-handler-if-sa_oneshot.patch
openrisc-dont-mask-signals-if-we-fail-to-setup-signal-stack.patch
openrisc-use-set_current_blocked-and-block_sigmask.patch
parisc-use-set_current_blocked-and-block_sigmask.patch
powerpc-use-set_current_blocked-and-block_sigmask.patch
use-block_sigmask.patch
score-dont-mask-signals-if-we-fail-to-setup-signal-stack.patch
score-use-set_current_blocked-and-block_sigmask.patch
sh-no-need-to-reset-handler-if-sa_oneshot.patch
sh-use-set_current_blocked-and-block_sigmask.patch
sparc-use-block_sigmask.patch
tile-use-set_current_blocked-and-block_sigmask.patch
um-dont-restore-current-blocked-on-error.patch
um-use-set_current_blocked-and-block_sigmask.patch
unicore32-use-block_sigmask.patch
xtensa-dont-reimplement-force_sigsegv.patch
xtensa-no-need-to-reset-handler-if-sa_oneshot.patch
xtensa-dont-mask-signals-if-we-fail-to-setup-signal-stack.patch
xtensa-use-set_current_blocked-and-block_sigmask.patch

