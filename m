From: akpm@linux-foundation.org
Subject: [merged] openrisc-dont-mask-signals-if-we-fail-to-setup-signal-stack.patch removed from -mm tree
Date: Thu, 16 Feb 2012 11:47:11 -0800
Message-ID: <20120216194711.68194A0128@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:39313 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab2BPTrM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Feb 2012 14:47:12 -0500
Received: by yhgm50 with SMTP id m50so337866yhg.1
        for <mm-commits@vger.kernel.org>; Thu, 16 Feb 2012 11:47:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matt.fleming@intel.com, arnd@arndb.de, jonas@southpole.se, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: OpenRISC: don't mask signals if we fail to setup signal stack
has been removed from the -mm tree.  Its filename was
     openrisc-dont-mask-signals-if-we-fail-to-setup-signal-stack.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Matt Fleming <matt.fleming@intel.com>
Subject: OpenRISC: don't mask signals if we fail to setup signal stack

setup_rt_frame() needs to return an indication of whether it succeeded or
failed in setting up the signal stack frame.  If setup_rt_frame() fails
then we must not modify current->blocked.

Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/openrisc/kernel/signal.c |   29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff -puN arch/openrisc/kernel/signal.c~openrisc-dont-mask-signals-if-we-fail-to-setup-signal-stack arch/openrisc/kernel/signal.c
--- a/arch/openrisc/kernel/signal.c~openrisc-dont-mask-signals-if-we-fail-to-setup-signal-stack
+++ a/arch/openrisc/kernel/signal.c
@@ -189,8 +189,8 @@ static inline void __user *get_sigframe(
  * trampoline which performs the syscall sigreturn, or a provided
  * user-mode trampoline.
  */
-static void setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-			   sigset_t *set, struct pt_regs *regs)
+static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
+			  sigset_t *set, struct pt_regs *regs)
 {
 	struct rt_sigframe *frame;
 	unsigned long return_ip;
@@ -247,18 +247,23 @@ static void setup_rt_frame(int sig, stru
 	/* actually move the usp to reflect the stacked frame */
 	regs->sp = (unsigned long)frame;
 
-	return;
+	return 0;
 
 give_sigsegv:
 	force_sigsegv(sig, current);
+	return -EFAULT;
 }
 
-static inline void
+static inline int
 handle_signal(unsigned long sig,
 	      siginfo_t *info, struct k_sigaction *ka,
 	      sigset_t *oldset, struct pt_regs *regs)
 {
-	setup_rt_frame(sig, ka, info, oldset, regs);
+	int ret;
+
+	ret = setup_rt_frame(sig, ka, info, oldset, regs);
+	if (ret)
+		return ret;
 
 	spin_lock_irq(&current->sighand->siglock);
 	sigorsets(&current->blocked, &current->blocked, &ka->sa.sa_mask);
@@ -267,6 +272,8 @@ handle_signal(unsigned long sig,
 	recalc_sigpending();
 
 	spin_unlock_irq(&current->sighand->siglock);
+
+	return 0;
 }
 
 /*
@@ -355,13 +362,13 @@ void do_signal(struct pt_regs *regs)
 			oldset = &current->blocked;
 
 		/* Whee!  Actually deliver the signal.  */
-		handle_signal(signr, &info, &ka, oldset, regs);
-		/* a signal was successfully delivered; the saved
-		 * sigmask will have been stored in the signal frame,
-		 * and will be restored by sigreturn, so we can simply
-		 * clear the TIF_RESTORE_SIGMASK flag */
-		if (test_thread_flag(TIF_RESTORE_SIGMASK))
+		if (!handle_signal(signr, &info, &ka, oldset, regs)) {
+			/* a signal was successfully delivered; the saved
+			 * sigmask will have been stored in the signal frame,
+			 * and will be restored by sigreturn, so we can simply
+			 * clear the TIF_RESTORE_SIGMASK flag */
 			clear_thread_flag(TIF_RESTORE_SIGMASK);
+		}
 
 		tracehook_signal_handler(signr, &info, &ka, regs,
 					 test_thread_flag(TIF_SINGLESTEP));
_

Patches currently in -mm which might be from matt.fleming@intel.com are

linux-next.patch
arm-use-set_current_blocked-and-block_sigmask.patch
avr32-dont-mask-signals-in-the-error-path.patch
avr32-use-set_current_blocked-in-handle_signal-sys_rt_sigreturn.patch
avr32-use-block_sigmask.patch
powerpc-use-set_current_blocked-and-block_sigmask.patch
hexagon-use-set_current_blocked-and-block_sigmask.patch
tile-use-set_current_blocked-and-block_sigmask.patch
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
s390-use-block_sigmask.patch
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

