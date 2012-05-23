From: akpm@linux-foundation.org
Subject: [merged] parisc-use-set_current_blocked-and-block_sigmask.patch removed from -mm tree
Date: Wed, 23 May 2012 12:51:34 -0700
Message-ID: <20120523195134.6DD4AA0210@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:45244 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933873Ab2EWTvg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 May 2012 15:51:36 -0400
Received: by mail-lb0-f202.google.com with SMTP id gp10so440935lbb.1
        for <mm-commits@vger.kernel.org>; Wed, 23 May 2012 12:51:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matt.fleming@intel.com, deller@gmx.de, jejb@parisc-linux.org, kyle@mcmartin.ca, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: parisc: use set_current_blocked() and block_sigmask()
has been removed from the -mm tree.  Its filename was
     parisc-use-set_current_blocked-and-block_sigmask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Matt Fleming <matt.fleming@intel.com>
Subject: parisc: use set_current_blocked() and block_sigmask()

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
Acked-by: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/kernel/signal.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff -puN arch/parisc/kernel/signal.c~parisc-use-set_current_blocked-and-block_sigmask arch/parisc/kernel/signal.c
--- a/arch/parisc/kernel/signal.c~parisc-use-set_current_blocked-and-block_sigmask
+++ a/arch/parisc/kernel/signal.c
@@ -131,10 +131,7 @@ sys_rt_sigreturn(struct pt_regs *regs, i
 	}
 		
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	/* Good thing we saved the old gr[30], eh? */
 #ifdef CONFIG_64BIT
@@ -454,12 +451,7 @@ handle_signal(unsigned long sig, siginfo
 	if (!setup_rt_frame(sig, ka, info, oldset, regs, in_syscall))
 		return 0;
 
-	spin_lock_irq(&current->sighand->siglock);
-	sigorsets(&current->blocked,&current->blocked,&ka->sa.sa_mask);
-	if (!(ka->sa.sa_flags & SA_NODEFER))
-		sigaddset(&current->blocked,sig);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	block_sigmask(ka, sig);
 
 	tracehook_signal_handler(sig, info, ka, regs, 
 		test_thread_flag(TIF_SINGLESTEP) ||
_

Patches currently in -mm which might be from matt.fleming@intel.com are

linux-next.patch

