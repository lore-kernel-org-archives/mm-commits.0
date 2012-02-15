From: akpm@linux-foundation.org
Subject: + microblaze-fix-signal-masking.patch added to -mm tree
Date: Tue, 14 Feb 2012 16:33:56 -0800
Message-ID: <20120215003356.A8CC6A02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:40430 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757444Ab2BOAd5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Feb 2012 19:33:57 -0500
Received: by mail-yx0-f202.google.com with SMTP id m1so81317yen.1
        for <mm-commits@vger.kernel.org>; Tue, 14 Feb 2012 16:33:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matt.fleming@intel.com, monstr@monstr.eu, oleg@redhat.com


The patch titled
     Subject: microblaze: fix signal masking
has been added to the -mm tree.  Its filename is
     microblaze-fix-signal-masking.patch

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
Subject: microblaze: fix signal masking

There are a couple of problems with the current signal code,

1. If we failed to setup the signal stack frame then we should not be
   masking any signals.

2. ka->sa.sa_mask is only added to the current blocked signals list if
   SA_NODEFER is set in ka->sa.sa_flags.  If we successfully setup the
   signal frame and are going to run the handler then we must honour
   sa_mask.

Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Michal Simek <monstr@monstr.eu>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/kernel/signal.c |   31 +++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff -puN arch/microblaze/kernel/signal.c~microblaze-fix-signal-masking arch/microblaze/kernel/signal.c
--- a/arch/microblaze/kernel/signal.c~microblaze-fix-signal-masking
+++ a/arch/microblaze/kernel/signal.c
@@ -169,7 +169,7 @@ get_sigframe(struct k_sigaction *ka, str
 	return (void __user *)((sp - frame_size) & -8UL);
 }
 
-static void setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
+static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 			sigset_t *set, struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
@@ -267,10 +267,11 @@ static void setup_rt_frame(int sig, stru
 		current->comm, current->pid, frame, regs->pc);
 #endif
 
-	return;
+	return 0;
 
 give_sigsegv:
 	force_sigsegv(sig, current);
+	return -EFAULT;
 }
 
 /* Handle restarting system calls */
@@ -314,21 +315,25 @@ static int
 handle_signal(unsigned long sig, struct k_sigaction *ka,
 		siginfo_t *info, sigset_t *oldset, struct pt_regs *regs)
 {
+	int ret;
+
 	/* Set up the stack frame */
 	if (ka->sa.sa_flags & SA_SIGINFO)
-		setup_rt_frame(sig, ka, info, oldset, regs);
+		ret = setup_rt_frame(sig, ka, info, oldset, regs);
 	else
-		setup_rt_frame(sig, ka, NULL, oldset, regs);
+		ret = setup_rt_frame(sig, ka, NULL, oldset, regs);
+
+	if (ret)
+		return ret;
 
-	if (!(ka->sa.sa_flags & SA_NODEFER)) {
-		spin_lock_irq(&current->sighand->siglock);
-		sigorsets(&current->blocked,
-				&current->blocked, &ka->sa.sa_mask);
+	spin_lock_irq(&current->sighand->siglock);
+	sigorsets(&current->blocked, &current->blocked, &ka->sa.sa_mask);
+	if (!(ka->sa.sa_flags & SA_NODEFER))
 		sigaddset(&current->blocked, sig);
-		recalc_sigpending();
-		spin_unlock_irq(&current->sighand->siglock);
-	}
-	return 1;
+	recalc_sigpending();
+	spin_unlock_irq(&current->sighand->siglock);
+
+	return 0;
 }
 
 /*
@@ -369,7 +374,7 @@ int do_signal(struct pt_regs *regs, sigs
 		/* Whee! Actually deliver the signal. */
 		if (in_syscall)
 			handle_restart(regs, &ka, 1);
-		if (handle_signal(signr, &ka, &info, oldset, regs)) {
+		if (!handle_signal(signr, &ka, &info, oldset, regs)) {
 			/*
 			 * A signal was successfully delivered; the saved
 			 * sigmask will have been stored in the signal frame,
_
Subject: Subject: microblaze: fix signal masking

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

