From: akpm@linux-foundation.org
Subject: + alpha-use-set_current_blocked-and-block_sigmask.patch added to -mm tree
Date: Tue, 14 Feb 2012 16:33:24 -0800
Message-ID: <20120215003325.4E938A02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:47253 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543Ab2BOAd2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Feb 2012 19:33:28 -0500
Received: by eaaf13 with SMTP id f13so15061eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 14 Feb 2012 16:33:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matt.fleming@intel.com, ink@jurassic.park.msu.ru, mattst88@gmail.com, oleg@redhat.com, rth@twiddle.net, viro@zeniv.linux.org.uk


The patch titled
     Subject: alpha: use set_current_blocked() and block_sigmask()
has been added to the -mm tree.  Its filename is
     alpha-use-set_current_blocked-and-block_sigmask.patch

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
Subject: alpha: use set_current_blocked() and block_sigmask()

As described in e6fa16ab ("signal: sigprocmask() should do
retarget_shared_pending()") the modification of current->blocked is
incorrect as we need to check for shared signals we're about to block.

Also, use the new helper function introduced in commit 5e6292c0f28f
("signal: add block_sigmask() for adding sigmask to current->blocked")
which centralises the code for updating current->blocked after
successfully delivering a signal and reduces the amount of duplicate code
across architectures.  In the past some architectures got this code wrong,
so using this helper function should stop that from happening again.

Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/signal.c |   31 ++++++++++---------------------
 1 file changed, 10 insertions(+), 21 deletions(-)

diff -puN arch/alpha/kernel/signal.c~alpha-use-set_current_blocked-and-block_sigmask arch/alpha/kernel/signal.c
--- a/arch/alpha/kernel/signal.c~alpha-use-set_current_blocked-and-block_sigmask
+++ a/arch/alpha/kernel/signal.c
@@ -120,12 +120,13 @@ SYSCALL_DEFINE5(rt_sigaction, int, sig, 
  */
 SYSCALL_DEFINE1(sigsuspend, old_sigset_t, mask)
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
@@ -238,10 +239,7 @@ do_sigreturn(struct sigcontext __user *s
 		goto give_sigsegv;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (restore_sigcontext(sc, regs, sw))
 		goto give_sigsegv;
@@ -276,10 +274,7 @@ do_rt_sigreturn(struct rt_sigframe __use
 		goto give_sigsegv;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (restore_sigcontext(&frame->uc.uc_mcontext, regs, sw))
 		goto give_sigsegv;
@@ -501,14 +496,8 @@ handle_signal(int sig, struct k_sigactio
 	else
 		ret = setup_frame(sig, ka, oldset, regs, sw);
 
-	if (ret == 0) {
-		spin_lock_irq(&current->sighand->siglock);
-		sigorsets(&current->blocked,&current->blocked,&ka->sa.sa_mask);
-		if (!(ka->sa.sa_flags & SA_NODEFER)) 
-			sigaddset(&current->blocked,sig);
-		recalc_sigpending();
-		spin_unlock_irq(&current->sighand->siglock);
-	}
+	if (ret == 0)
+		block_sigmask(ka, sig);
 
 	return ret;
 }
_
Subject: Subject: alpha: use set_current_blocked() and block_sigmask()

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

