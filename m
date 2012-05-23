From: akpm@linux-foundation.org
Subject: [merged] blackfin-use-set_current_blocked-and-block_sigmask.patch removed from -mm tree
Date: Wed, 23 May 2012 12:51:32 -0700
Message-ID: <20120523195132.6B1FBA0210@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:56830 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933874Ab2EWTve (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 May 2012 15:51:34 -0400
Received: by mail-lpp01m010-f74.google.com with SMTP id r15so441065lag.1
        for <mm-commits@vger.kernel.org>; Wed, 23 May 2012 12:51:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matt.fleming@intel.com, michael.hennerich@analog.com, oleg@redhat.com, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     Subject: blackfin: use set_current_blocked() and block_sigmask()
has been removed from the -mm tree.  Its filename was
     blackfin-use-set_current_blocked-and-block_sigmask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Matt Fleming <matt.fleming@intel.com>
Subject: blackfin: use set_current_blocked() and block_sigmask()

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
Acked-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/kernel/signal.c |   17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff -puN arch/blackfin/kernel/signal.c~blackfin-use-set_current_blocked-and-block_sigmask arch/blackfin/kernel/signal.c
--- a/arch/blackfin/kernel/signal.c~blackfin-use-set_current_blocked-and-block_sigmask
+++ a/arch/blackfin/kernel/signal.c
@@ -99,10 +99,7 @@ asmlinkage int do_rt_sigreturn(unsigned 
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (rt_restore_sigcontext(regs, &frame->uc.uc_mcontext, &r0))
 		goto badframe;
@@ -266,15 +263,9 @@ handle_signal(int sig, siginfo_t *info, 
 	/* set up the stack frame */
 	ret = setup_rt_frame(sig, ka, info, oldset, regs);
 
-	if (ret == 0) {
-		spin_lock_irq(&current->sighand->siglock);
-		sigorsets(&current->blocked, &current->blocked,
-			  &ka->sa.sa_mask);
-		if (!(ka->sa.sa_flags & SA_NODEFER))
-			sigaddset(&current->blocked, sig);
-		recalc_sigpending();
-		spin_unlock_irq(&current->sighand->siglock);
-	}
+	if (ret == 0)
+		block_sigmask(ka, sig);
+
 	return ret;
 }
 
_

Patches currently in -mm which might be from matt.fleming@intel.com are

linux-next.patch

