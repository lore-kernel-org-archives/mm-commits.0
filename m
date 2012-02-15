From: akpm@linux-foundation.org
Subject: + xtensa-dont-mask-signals-if-we-fail-to-setup-signal-stack.patch added to -mm tree
Date: Tue, 14 Feb 2012 16:34:40 -0800
Message-ID: <20120215003440.ED60DA02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:60283 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757373Ab2BOAen (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Feb 2012 19:34:43 -0500
Received: by mail-lpp01m010-f74.google.com with SMTP id l5so16011lah.1
        for <mm-commits@vger.kernel.org>; Tue, 14 Feb 2012 16:34:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matt.fleming@intel.com, chris@zankel.net, oleg@redhat.com


The patch titled
     Subject: xtensa: don't mask signals if we fail to setup signal stack
has been added to the -mm tree.  Its filename is
     xtensa-dont-mask-signals-if-we-fail-to-setup-signal-stack.patch

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
Subject: Subject: xtensa: don't mask signals if we fail to setup signal stack

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

