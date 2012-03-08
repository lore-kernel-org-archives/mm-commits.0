From: akpm@linux-foundation.org
Subject: [merged] arm-use-set_current_blocked-and-block_sigmask.patch removed from -mm tree
Date: Thu, 08 Mar 2012 11:17:43 -0800
Message-ID: <20120308191743.81DD1A06CB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:57627 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758367Ab2CHTRq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Mar 2012 14:17:46 -0500
Received: by wejx9 with SMTP id x9so31726wej.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Mar 2012 11:17:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matt.fleming@intel.com, arnd.bergmann@linaro.org, dave.martin@linaro.org, linux@arm.linux.org.uk, nicolas.pitre@linaro.org, oleg@redhat.com, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arm: use set_current_blocked() and block_sigmask()
has been removed from the -mm tree.  Its filename was
     arm-use-set_current_blocked-and-block_sigmask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Matt Fleming <matt.fleming@intel.com>
Subject: arm: use set_current_blocked() and block_sigmask()

As described in e6fa16ab ("signal: sigprocmask() should do
retarget_shared_pending()") the modification of current->blocked is
incorrect as we need to check for shared signals we're about to block.

Also, use the new helper function introduced in commit 5e6292c0f28f
("signal: add block_sigmask() for adding sigmask to current->blocked")
which centralises the code for updating current->blocked after
successfully delivering a signal and reduces the amount of duplicate code
across architectures.  In the past some architectures got this code wrong,
so using this helper function should stop that from happening again.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: Dave Martin <dave.martin@linaro.org>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/signal.c |   24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff -puN arch/arm/kernel/signal.c~arm-use-set_current_blocked-and-block_sigmask arch/arm/kernel/signal.c
--- a/arch/arm/kernel/signal.c~arm-use-set_current_blocked-and-block_sigmask
+++ a/arch/arm/kernel/signal.c
@@ -66,12 +66,13 @@ const unsigned long syscall_restart_code
  */
 asmlinkage int sys_sigsuspend(int restart, unsigned long oldmask, old_sigset_t mask)
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
@@ -280,10 +281,7 @@ static int restore_sigframe(struct pt_re
 	err = __copy_from_user(&set, &sf->uc.uc_sigmask, sizeof(set));
 	if (err == 0) {
 		sigdelsetmask(&set, ~_BLOCKABLE);
-		spin_lock_irq(&current->sighand->siglock);
-		current->blocked = set;
-		recalc_sigpending();
-		spin_unlock_irq(&current->sighand->siglock);
+		set_current_blocked(&set);
 	}
 
 	__get_user_error(regs->ARM_r0, &sf->uc.uc_mcontext.arm_r0, err);
@@ -636,13 +634,7 @@ handle_signal(unsigned long sig, struct 
 	/*
 	 * Block the signal if we were successful.
 	 */
-	spin_lock_irq(&tsk->sighand->siglock);
-	sigorsets(&tsk->blocked, &tsk->blocked,
-		  &ka->sa.sa_mask);
-	if (!(ka->sa.sa_flags & SA_NODEFER))
-		sigaddset(&tsk->blocked, sig);
-	recalc_sigpending();
-	spin_unlock_irq(&tsk->sighand->siglock);
+	block_sigmask(ka, sig);
 
 	return 0;
 }
_

Patches currently in -mm which might be from matt.fleming@intel.com are

linux-next.patch
avr32-dont-mask-signals-in-the-error-path.patch
avr32-use-set_current_blocked-in-handle_signal-sys_rt_sigreturn.patch
avr32-use-block_sigmask.patch
ia64-use-set_current_blocked-and-block_sigmask.patch
microblaze-dont-reimplement-force_sigsegv.patch
microblaze-no-need-to-reset-handler-if-sa_oneshot.patch
microblaze-fix-signal-masking.patch
microblaze-use-set_current_blocked-and-block_sigmask.patch
mips-use-set_current_blocked-and-block_sigmask.patch
score-dont-mask-signals-if-we-fail-to-setup-signal-stack.patch
score-use-set_current_blocked-and-block_sigmask.patch
unicore32-use-block_sigmask.patch
blackfin-use-set_current_blocked-and-block_sigmask.patch
parisc-use-set_current_blocked-and-block_sigmask.patch
xtensa-dont-reimplement-force_sigsegv.patch
xtensa-no-need-to-reset-handler-if-sa_oneshot.patch
xtensa-dont-mask-signals-if-we-fail-to-setup-signal-stack.patch
xtensa-use-set_current_blocked-and-block_sigmask.patch
sparc-use-block_sigmask.patch
frv-use-set_current_blocked-and-block_sigmask.patch
sh-no-need-to-reset-handler-if-sa_oneshot.patch
sh-use-set_current_blocked-and-block_sigmask.patch
h8300-use-set_current_blocked-and-block_sigmask.patch
alpha-use-set_current_blocked-and-block_sigmask.patch
m32r-use-set_current_blocked-and-block_sigmask.patch
m68k-use-set_current_blocked-and-block_sigmask.patch
mn10300-use-set_current_blocked-and-block_sigmask.patch
c6x-use-set_current_blocked-and-block_sigmask.patch
cris-use-set_current_blocked-and-block_sigmask.patch
um-dont-restore-current-blocked-on-error.patch
um-use-set_current_blocked-and-block_sigmask.patch
powerpc-eeh-remove-eeh_event_handler-daemonize.patch
tile-use-set_current_blocked-and-block_sigmask.patch
hexagon-use-set_current_blocked-and-block_sigmask.patch

