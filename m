From: akpm@linux-foundation.org
Subject: [merged] xtensa-dont-mask-signals-if-we-fail-to-setup-signal-stack.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:17:17 -0700
Message-ID: <20120322201717.68AC1A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:56681 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab2CVURU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:17:20 -0400
Received: by lbbgj3 with SMTP id gj3so134062lbb.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:17:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matt.fleming@intel.com, chris@zankel.net, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: xtensa: don't mask signals if we fail to setup signal stack
has been removed from the -mm tree.  Its filename was
     xtensa-dont-mask-signals-if-we-fail-to-setup-signal-stack.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Matt Fleming <matt.fleming@intel.com>
Subject: xtensa: don't mask signals if we fail to setup signal stack

setup_frame() needs to return an indication of whether it succeeded or
failed in setting up the signal stack frame.  If setup_frame() fails then
we must not modify current->blocked.

Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/kernel/signal.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN arch/xtensa/kernel/signal.c~xtensa-dont-mask-signals-if-we-fail-to-setup-signal-stack arch/xtensa/kernel/signal.c
--- a/arch/xtensa/kernel/signal.c~xtensa-dont-mask-signals-if-we-fail-to-setup-signal-stack
+++ a/arch/xtensa/kernel/signal.c
@@ -336,8 +336,8 @@ gen_return_code(unsigned char *codemem)
 }
 
 
-static void setup_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-			sigset_t *set, struct pt_regs *regs)
+static int setup_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
+		       sigset_t *set, struct pt_regs *regs)
 {
 	struct rt_sigframe *frame;
 	int err = 0;
@@ -422,10 +422,11 @@ static void setup_frame(int sig, struct 
 		current->comm, current->pid, signal, frame, regs->pc);
 #endif
 
-	return;
+	return 0;
 
 give_sigsegv:
 	force_sigsegv(sig, current);
+	return -EFAULT;
 }
 
 /*
@@ -534,7 +535,9 @@ int do_signal(struct pt_regs *regs, sigs
 
 		/* Whee!  Actually deliver the signal.  */
 		/* Set up the stack frame */
-		setup_frame(signr, &ka, &info, oldset, regs);
+		ret = setup_frame(signr, &ka, &info, oldset, regs);
+		if (ret)
+			return ret;
 
 		spin_lock_irq(&current->sighand->siglock);
 		sigorsets(&current->blocked, &current->blocked, &ka.sa.sa_mask);
_

Patches currently in -mm which might be from matt.fleming@intel.com are

origin.patch
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
hexagon-use-set_current_blocked-and-block_sigmask.patch

