From: akpm@linux-foundation.org
Subject: [merged] powerpc-use-set_current_blocked-and-block_sigmask.patch removed from -mm tree
Date: Thu, 08 Mar 2012 11:17:45 -0800
Message-ID: <20120308191745.6A105A06CB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:35115 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758339Ab2CHTRr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Mar 2012 14:17:47 -0500
Received: by mail-ee0-f74.google.com with SMTP id c41so30194eek.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Mar 2012 11:17:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matt.fleming@intel.com, benh@kernel.crashing.org, oleg@redhat.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: use set_current_blocked() and block_sigmask()
has been removed from the -mm tree.  Its filename was
     powerpc-use-set_current_blocked-and-block_sigmask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Matt Fleming <matt.fleming@intel.com>
Subject: powerpc: use set_current_blocked() and block_sigmask()

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
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/signal.c    |   13 ++-----------
 arch/powerpc/kernel/signal_32.c |   11 ++++++-----
 2 files changed, 8 insertions(+), 16 deletions(-)

diff -puN arch/powerpc/kernel/signal.c~powerpc-use-set_current_blocked-and-block_sigmask arch/powerpc/kernel/signal.c
--- a/arch/powerpc/kernel/signal.c~powerpc-use-set_current_blocked-and-block_sigmask
+++ a/arch/powerpc/kernel/signal.c
@@ -57,10 +57,7 @@ void __user * get_sigframe(struct k_siga
 void restore_sigmask(sigset_t *set)
 {
 	sigdelsetmask(set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = *set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(set);
 }
 
 static void check_syscall_restart(struct pt_regs *regs, struct k_sigaction *ka,
@@ -169,13 +166,7 @@ static int do_signal(struct pt_regs *reg
 
 	regs->trap = 0;
 	if (ret) {
-		spin_lock_irq(&current->sighand->siglock);
-		sigorsets(&current->blocked, &current->blocked,
-			  &ka.sa.sa_mask);
-		if (!(ka.sa.sa_flags & SA_NODEFER))
-			sigaddset(&current->blocked, signr);
-		recalc_sigpending();
-		spin_unlock_irq(&current->sighand->siglock);
+		block_sigmask(&ka, signr);
 
 		/*
 		 * A signal was successfully delivered; the saved sigmask is in
diff -puN arch/powerpc/kernel/signal_32.c~powerpc-use-set_current_blocked-and-block_sigmask arch/powerpc/kernel/signal_32.c
--- a/arch/powerpc/kernel/signal_32.c~powerpc-use-set_current_blocked-and-block_sigmask
+++ a/arch/powerpc/kernel/signal_32.c
@@ -242,12 +242,13 @@ static inline int restore_general_regs(s
  */
 long sys_sigsuspend(old_sigset_t mask)
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

