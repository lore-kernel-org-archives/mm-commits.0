From: akpm@linux-foundation.org
Subject: [merged] sparc-use-block_sigmask.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:17:21 -0700
Message-ID: <20120322201721.4B822A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:56681 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756174Ab2CVURX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:17:23 -0400
Received: by mail-lb0-f202.google.com with SMTP id gj3so134062lbb.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:17:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matt.fleming@intel.com, davem@davemloft.net, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sparc: use block_sigmask()
has been removed from the -mm tree.  Its filename was
     sparc-use-block_sigmask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Matt Fleming <matt.fleming@intel.com>
Subject: sparc: use block_sigmask()

Use the new helper function introduced in commit 5e6292c0f28f ("signal:
add block_sigmask() for adding sigmask to current->blocked") which
centralises the code for updating current->blocked after successfully
delivering a signal and reduces the amount of duplicate code across
architectures.  In the past some architectures got this code wrong, so
using this helper function should stop that from happening again.

Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/kernel/signal32.c  |    7 +------
 arch/sparc/kernel/signal_32.c |    7 +------
 arch/sparc/kernel/signal_64.c |    6 +-----
 3 files changed, 3 insertions(+), 17 deletions(-)

diff -puN arch/sparc/kernel/signal32.c~sparc-use-block_sigmask arch/sparc/kernel/signal32.c
--- a/arch/sparc/kernel/signal32.c~sparc-use-block_sigmask
+++ a/arch/sparc/kernel/signal32.c
@@ -776,7 +776,6 @@ static inline int handle_signal32(unsign
 				  siginfo_t *info,
 				  sigset_t *oldset, struct pt_regs *regs)
 {
-	sigset_t blocked;
 	int err;
 
 	if (ka->sa.sa_flags & SA_SIGINFO)
@@ -787,11 +786,7 @@ static inline int handle_signal32(unsign
 	if (err)
 		return err;
 
-	sigorsets(&blocked, &current->blocked, &ka->sa.sa_mask);
-	if (!(ka->sa.sa_flags & SA_NOMASK))
-		sigaddset(&blocked, signr);
-	set_current_blocked(&blocked);
-
+	block_sigmask(ka, signr);
 	tracehook_signal_handler(signr, info, ka, regs, 0);
 
 	return 0;
diff -puN arch/sparc/kernel/signal_32.c~sparc-use-block_sigmask arch/sparc/kernel/signal_32.c
--- a/arch/sparc/kernel/signal_32.c~sparc-use-block_sigmask
+++ a/arch/sparc/kernel/signal_32.c
@@ -465,7 +465,6 @@ static inline int
 handle_signal(unsigned long signr, struct k_sigaction *ka,
 	      siginfo_t *info, sigset_t *oldset, struct pt_regs *regs)
 {
-	sigset_t blocked;
 	int err;
 
 	if (ka->sa.sa_flags & SA_SIGINFO)
@@ -476,11 +475,7 @@ handle_signal(unsigned long signr, struc
 	if (err)
 		return err;
 
-	sigorsets(&blocked, &current->blocked, &ka->sa.sa_mask);
-	if (!(ka->sa.sa_flags & SA_NOMASK))
-		sigaddset(&blocked, signr);
-	set_current_blocked(&blocked);
-
+	block_sigmask(ka, signr);
 	tracehook_signal_handler(signr, info, ka, regs, 0);
 
 	return 0;
diff -puN arch/sparc/kernel/signal_64.c~sparc-use-block_sigmask arch/sparc/kernel/signal_64.c
--- a/arch/sparc/kernel/signal_64.c~sparc-use-block_sigmask
+++ a/arch/sparc/kernel/signal_64.c
@@ -479,18 +479,14 @@ static inline int handle_signal(unsigned
 				siginfo_t *info,
 				sigset_t *oldset, struct pt_regs *regs)
 {
-	sigset_t blocked;
 	int err;
 
 	err = setup_rt_frame(ka, regs, signr, oldset,
 			     (ka->sa.sa_flags & SA_SIGINFO) ? info : NULL);
 	if (err)
 		return err;
-	sigorsets(&blocked, &current->blocked, &ka->sa.sa_mask);
-	if (!(ka->sa.sa_flags & SA_NOMASK))
-		sigaddset(&blocked, signr);
-	set_current_blocked(&blocked);
 
+	block_sigmask(ka, signr);
 	tracehook_signal_handler(signr, info, ka, regs, 0);
 
 	return 0;
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

