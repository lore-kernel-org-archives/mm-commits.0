From: akpm@linux-foundation.org
Subject: [merged] s390-use-block_sigmask.patch removed from -mm tree
Date: Mon, 27 Feb 2012 14:29:18 -0800
Message-ID: <20120227222918.747D8A02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:36984 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305Ab2B0W3V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2012 17:29:21 -0500
Received: by eaaf13 with SMTP id f13so182260eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2012 14:29:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matt.fleming@intel.com, heiko.carstens@de.ibm.com, oleg@redhat.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: S390: use block_sigmask()
has been removed from the -mm tree.  Its filename was
     s390-use-block_sigmask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Matt Fleming <matt.fleming@intel.com>
Subject: S390: use block_sigmask()

Use the new helper function introduced in commit 5e6292c0f28f ("signal:
add block_sigmask() for adding sigmask to current->blocked") which
centralises the code for updating current->blocked after successfully
delivering a signal and reduces the amount of duplicate code across
architectures.

In the past some architectures got this code wrong, so using this helper
function should stop that from happening again.

Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/compat_signal.c |    6 +-----
 arch/s390/kernel/signal.c        |    6 +-----
 2 files changed, 2 insertions(+), 10 deletions(-)

diff -puN arch/s390/kernel/compat_signal.c~s390-use-block_sigmask arch/s390/kernel/compat_signal.c
--- a/arch/s390/kernel/compat_signal.c~s390-use-block_sigmask
+++ a/arch/s390/kernel/compat_signal.c
@@ -581,7 +581,6 @@ give_sigsegv:
 int handle_signal32(unsigned long sig, struct k_sigaction *ka,
 		    siginfo_t *info, sigset_t *oldset, struct pt_regs *regs)
 {
-	sigset_t blocked;
 	int ret;
 
 	/* Set up the stack frame */
@@ -591,10 +590,7 @@ int handle_signal32(unsigned long sig, s
 		ret = setup_frame32(sig, ka, oldset, regs);
 	if (ret)
 		return ret;
-	sigorsets(&blocked, &current->blocked, &ka->sa.sa_mask);
-	if (!(ka->sa.sa_flags & SA_NODEFER))
-		sigaddset(&blocked, sig);
-	set_current_blocked(&blocked);
+	block_sigmask(ka, sig);
 	return 0;
 }
 
diff -puN arch/s390/kernel/signal.c~s390-use-block_sigmask arch/s390/kernel/signal.c
--- a/arch/s390/kernel/signal.c~s390-use-block_sigmask
+++ a/arch/s390/kernel/signal.c
@@ -385,7 +385,6 @@ static int handle_signal(unsigned long s
 			 siginfo_t *info, sigset_t *oldset,
 			 struct pt_regs *regs)
 {
-	sigset_t blocked;
 	int ret;
 
 	/* Set up the stack frame */
@@ -395,10 +394,7 @@ static int handle_signal(unsigned long s
 		ret = setup_frame(sig, ka, oldset, regs);
 	if (ret)
 		return ret;
-	sigorsets(&blocked, &current->blocked, &ka->sa.sa_mask);
-	if (!(ka->sa.sa_flags & SA_NODEFER))
-		sigaddset(&blocked, sig);
-	set_current_blocked(&blocked);
+	block_sigmask(ka, sig);
 	return 0;
 }
 
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

