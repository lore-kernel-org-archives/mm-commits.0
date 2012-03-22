From: akpm@linux-foundation.org
Subject: [merged] xtensa-no-need-to-reset-handler-if-sa_oneshot.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:17:15 -0700
Message-ID: <20120322201715.609B0A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:62591 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab2CVURQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:17:16 -0400
Received: by vbnl22 with SMTP id l22so199573vbn.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:17:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matt.fleming@intel.com, chris@zankel.net, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: xtensa: no need to reset handler if SA_ONESHOT
has been removed from the -mm tree.  Its filename was
     xtensa-no-need-to-reset-handler-if-sa_oneshot.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Matt Fleming <matt.fleming@intel.com>
Subject: xtensa: no need to reset handler if SA_ONESHOT

get_signal_to_deliver() already resets the signal handler if SA_ONESHOT is
set in ka->sa.sa_flags, there's no need to do it again in handle_signal().
 Furthermore, because we were modifying ka->sa.sa_handler (which is a copy
of sighand->action[]) instead of sighand->action[] the original code
actually had no effect on signal delivery.

Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/kernel/signal.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN arch/xtensa/kernel/signal.c~xtensa-no-need-to-reset-handler-if-sa_oneshot arch/xtensa/kernel/signal.c
--- a/arch/xtensa/kernel/signal.c~xtensa-no-need-to-reset-handler-if-sa_oneshot
+++ a/arch/xtensa/kernel/signal.c
@@ -536,9 +536,6 @@ int do_signal(struct pt_regs *regs, sigs
 		/* Set up the stack frame */
 		setup_frame(signr, &ka, &info, oldset, regs);
 
-		if (ka.sa.sa_flags & SA_ONESHOT)
-			ka.sa.sa_handler = SIG_DFL;
-
 		spin_lock_irq(&current->sighand->siglock);
 		sigorsets(&current->blocked, &current->blocked, &ka.sa.sa_mask);
 		if (!(ka.sa.sa_flags & SA_NODEFER))
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

