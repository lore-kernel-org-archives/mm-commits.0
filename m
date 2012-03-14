From: akpm@linux-foundation.org
Subject: [merged] tile-use-set_current_blocked-and-block_sigmask.patch removed from -mm tree
Date: Wed, 14 Mar 2012 14:24:48 -0700
Message-ID: <20120314212448.71A3FA076E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:65523 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030915Ab2CNVYu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Mar 2012 17:24:50 -0400
Received: by mail-fa0-f74.google.com with SMTP id a19so98071faa.1
        for <mm-commits@vger.kernel.org>; Wed, 14 Mar 2012 14:24:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matt.fleming@intel.com, arnd@arndb.de, cmetcalf@tilera.com, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tile: use set_current_blocked() and block_sigmask()
has been removed from the -mm tree.  Its filename was
     tile-use-set_current_blocked-and-block_sigmask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Matt Fleming <matt.fleming@intel.com>
Subject: tile: use set_current_blocked() and block_sigmask()

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
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/kernel/compat_signal.c |    5 +----
 arch/tile/kernel/signal.c        |   13 ++-----------
 2 files changed, 3 insertions(+), 15 deletions(-)

diff -puN arch/tile/kernel/compat_signal.c~tile-use-set_current_blocked-and-block_sigmask arch/tile/kernel/compat_signal.c
--- a/arch/tile/kernel/compat_signal.c~tile-use-set_current_blocked-and-block_sigmask
+++ a/arch/tile/kernel/compat_signal.c
@@ -303,10 +303,7 @@ long compat_sys_rt_sigreturn(struct pt_r
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (restore_sigcontext(regs, &frame->uc.uc_mcontext))
 		goto badframe;
diff -puN arch/tile/kernel/signal.c~tile-use-set_current_blocked-and-block_sigmask arch/tile/kernel/signal.c
--- a/arch/tile/kernel/signal.c~tile-use-set_current_blocked-and-block_sigmask
+++ a/arch/tile/kernel/signal.c
@@ -97,10 +97,7 @@ SYSCALL_DEFINE1(rt_sigreturn, struct pt_
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (restore_sigcontext(regs, &frame->uc.uc_mcontext))
 		goto badframe;
@@ -286,13 +283,7 @@ static int handle_signal(unsigned long s
 		 * the work_pending path in the return-to-user code, and
 		 * either way we can re-enable interrupts unconditionally.
 		 */
-		spin_lock_irq(&current->sighand->siglock);
-		sigorsets(&current->blocked,
-			  &current->blocked, &ka->sa.sa_mask);
-		if (!(ka->sa.sa_flags & SA_NODEFER))
-			sigaddset(&current->blocked, sig);
-		recalc_sigpending();
-		spin_unlock_irq(&current->sighand->siglock);
+		block_sigmask(ka, sig);
 	}
 
 	return ret;
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
hexagon-use-set_current_blocked-and-block_sigmask.patch

