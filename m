From: akpm@linux-foundation.org
Subject: [merged] score-use-set_current_blocked-and-block_sigmask.patch removed from -mm tree
Date: Wed, 23 May 2012 12:51:28 -0700
Message-ID: <20120523195128.6B5A8A0210@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:54639 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933873Ab2EWTv3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 May 2012 15:51:29 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so494314wgb.1
        for <mm-commits@vger.kernel.org>; Wed, 23 May 2012 12:51:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matt.fleming@intel.com, lennox.wu@gmail.com, liqin.chen@sunplusct.com, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: score: use set_current_blocked() and block_sigmask()
has been removed from the -mm tree.  Its filename was
     score-use-set_current_blocked-and-block_sigmask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Matt Fleming <matt.fleming@intel.com>
Subject: score: use set_current_blocked() and block_sigmask()

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
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/score/kernel/signal.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff -puN arch/score/kernel/signal.c~score-use-set_current_blocked-and-block_sigmask arch/score/kernel/signal.c
--- a/arch/score/kernel/signal.c~score-use-set_current_blocked-and-block_sigmask
+++ a/arch/score/kernel/signal.c
@@ -159,10 +159,7 @@ score_rt_sigreturn(struct pt_regs *regs)
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	sig = restore_sigcontext(regs, &frame->rs_uc.uc_mcontext);
 	if (sig < 0)
@@ -272,14 +269,8 @@ static int handle_signal(unsigned long s
 	 */
 	ret = setup_rt_frame(ka, regs, sig, oldset, info);
 
-	if (ret == 0) {
-		spin_lock_irq(&current->sighand->siglock);
-		sigorsets(&current->blocked, &current->blocked, &ka->sa.sa_mask);
-		if (!(ka->sa.sa_flags & SA_NODEFER))
-			sigaddset(&current->blocked, sig);
-		recalc_sigpending();
-		spin_unlock_irq(&current->sighand->siglock);
-	}
+	if (ret == 0)
+		block_sigmask(ka, sig);
 
 	return ret;
 }
_

Patches currently in -mm which might be from matt.fleming@intel.com are

linux-next.patch

