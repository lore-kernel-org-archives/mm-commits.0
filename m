From: akpm@linux-foundation.org
Subject: + mips-use-set_current_blocked-and-block_sigmask.patch added to -mm tree
Date: Tue, 14 Feb 2012 16:34:00 -0800
Message-ID: <20120215003401.1948CA02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:61428 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761264Ab2BOAeD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Feb 2012 19:34:03 -0500
Received: by mail-ee0-f74.google.com with SMTP id b15so18497eek.1
        for <mm-commits@vger.kernel.org>; Tue, 14 Feb 2012 16:34:02 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matt.fleming@intel.com, ddaney@caviumnetworks.com, oleg@redhat.com, ralf@linux-mips.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: MIPS: use set_current_blocked() and block_sigmask()
has been added to the -mm tree.  Its filename is
     mips-use-set_current_blocked-and-block_sigmask.patch

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
Subject: MIPS: use set_current_blocked() and block_sigmask()

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
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Daney <ddaney@caviumnetworks.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/signal.c     |   27 +++++----------------------
 arch/mips/kernel/signal32.c   |   20 ++++----------------
 arch/mips/kernel/signal_n32.c |   10 ++--------
 3 files changed, 11 insertions(+), 46 deletions(-)

diff -puN arch/mips/kernel/signal.c~mips-use-set_current_blocked-and-block_sigmask arch/mips/kernel/signal.c
--- a/arch/mips/kernel/signal.c~mips-use-set_current_blocked-and-block_sigmask
+++ a/arch/mips/kernel/signal.c
@@ -256,11 +256,8 @@ asmlinkage int sys_sigsuspend(nabi_no_re
 		return -EFAULT;
 	sigdelsetmask(&newset, ~_BLOCKABLE);
 
-	spin_lock_irq(&current->sighand->siglock);
 	current->saved_sigmask = current->blocked;
-	current->blocked = newset;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&newset);
 
 	current->state = TASK_INTERRUPTIBLE;
 	schedule();
@@ -285,11 +282,8 @@ asmlinkage int sys_rt_sigsuspend(nabi_no
 		return -EFAULT;
 	sigdelsetmask(&newset, ~_BLOCKABLE);
 
-	spin_lock_irq(&current->sighand->siglock);
 	current->saved_sigmask = current->blocked;
-	current->blocked = newset;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&newset);
 
 	current->state = TASK_INTERRUPTIBLE;
 	schedule();
@@ -361,10 +355,7 @@ asmlinkage void sys_sigreturn(nabi_no_re
 		goto badframe;
 
 	sigdelsetmask(&blocked, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = blocked;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&blocked);
 
 	sig = restore_sigcontext(&regs, &frame->sf_sc);
 	if (sig < 0)
@@ -400,10 +391,7 @@ asmlinkage void sys_rt_sigreturn(nabi_no
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	sig = restore_sigcontext(&regs, &frame->rs_uc.uc_mcontext);
 	if (sig < 0)
@@ -579,12 +567,7 @@ static int handle_signal(unsigned long s
 	if (ret)
 		return ret;
 
-	spin_lock_irq(&current->sighand->siglock);
-	sigorsets(&current->blocked, &current->blocked, &ka->sa.sa_mask);
-	if (!(ka->sa.sa_flags & SA_NODEFER))
-		sigaddset(&current->blocked, sig);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	block_sigmask(ka, sig);
 
 	return ret;
 }
diff -puN arch/mips/kernel/signal32.c~mips-use-set_current_blocked-and-block_sigmask arch/mips/kernel/signal32.c
--- a/arch/mips/kernel/signal32.c~mips-use-set_current_blocked-and-block_sigmask
+++ a/arch/mips/kernel/signal32.c
@@ -290,11 +290,8 @@ asmlinkage int sys32_sigsuspend(nabi_no_
 		return -EFAULT;
 	sigdelsetmask(&newset, ~_BLOCKABLE);
 
-	spin_lock_irq(&current->sighand->siglock);
 	current->saved_sigmask = current->blocked;
-	current->blocked = newset;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&newset);
 
 	current->state = TASK_INTERRUPTIBLE;
 	schedule();
@@ -318,11 +315,8 @@ asmlinkage int sys32_rt_sigsuspend(nabi_
 		return -EFAULT;
 	sigdelsetmask(&newset, ~_BLOCKABLE);
 
-	spin_lock_irq(&current->sighand->siglock);
 	current->saved_sigmask = current->blocked;
-	current->blocked = newset;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&newset);
 
 	current->state = TASK_INTERRUPTIBLE;
 	schedule();
@@ -488,10 +482,7 @@ asmlinkage void sys32_sigreturn(nabi_no_
 		goto badframe;
 
 	sigdelsetmask(&blocked, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = blocked;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&blocked);
 
 	sig = restore_sigcontext32(&regs, &frame->sf_sc);
 	if (sig < 0)
@@ -529,10 +520,7 @@ asmlinkage void sys32_rt_sigreturn(nabi_
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	sig = restore_sigcontext32(&regs, &frame->rs_uc.uc_mcontext);
 	if (sig < 0)
diff -puN arch/mips/kernel/signal_n32.c~mips-use-set_current_blocked-and-block_sigmask arch/mips/kernel/signal_n32.c
--- a/arch/mips/kernel/signal_n32.c~mips-use-set_current_blocked-and-block_sigmask
+++ a/arch/mips/kernel/signal_n32.c
@@ -94,11 +94,8 @@ asmlinkage int sysn32_rt_sigsuspend(nabi
 	sigset_from_compat(&newset, &uset);
 	sigdelsetmask(&newset, ~_BLOCKABLE);
 
-	spin_lock_irq(&current->sighand->siglock);
 	current->saved_sigmask = current->blocked;
-	current->blocked = newset;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&newset);
 
 	current->state = TASK_INTERRUPTIBLE;
 	schedule();
@@ -122,10 +119,7 @@ asmlinkage void sysn32_rt_sigreturn(nabi
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	sig = restore_sigcontext(&regs, &frame->rs_uc.uc_mcontext);
 	if (sig < 0)
_
Subject: Subject: MIPS: use set_current_blocked() and block_sigmask()

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

