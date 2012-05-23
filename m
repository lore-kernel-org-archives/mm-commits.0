From: akpm@linux-foundation.org
Subject: [merged] microblaze-use-set_current_blocked-and-block_sigmask.patch removed from -mm tree
Date: Wed, 23 May 2012 12:51:26 -0700
Message-ID: <20120523195126.64D8EA0210@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:47804 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933852Ab2EWTv2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 May 2012 15:51:28 -0400
Received: by eaao13 with SMTP id o13so443716eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 23 May 2012 12:51:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matt.fleming@intel.com, monstr@monstr.eu, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: microblaze: use set_current_blocked() and block_sigmask()
has been removed from the -mm tree.  Its filename was
     microblaze-use-set_current_blocked-and-block_sigmask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Matt Fleming <matt.fleming@intel.com>
Subject: microblaze: use set_current_blocked() and block_sigmask()

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
Acked-by: Michal Simek <monstr@monstr.eu>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/kernel/signal.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff -puN arch/microblaze/kernel/signal.c~microblaze-use-set_current_blocked-and-block_sigmask arch/microblaze/kernel/signal.c
--- a/arch/microblaze/kernel/signal.c~microblaze-use-set_current_blocked-and-block_sigmask
+++ a/arch/microblaze/kernel/signal.c
@@ -105,10 +105,7 @@ asmlinkage long sys_rt_sigreturn(struct 
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (restore_sigcontext(regs, &frame->uc.uc_mcontext, &rval))
 		goto badframe;
@@ -326,12 +323,7 @@ handle_signal(unsigned long sig, struct 
 	if (ret)
 		return ret;
 
-	spin_lock_irq(&current->sighand->siglock);
-	sigorsets(&current->blocked, &current->blocked, &ka->sa.sa_mask);
-	if (!(ka->sa.sa_flags & SA_NODEFER))
-		sigaddset(&current->blocked, sig);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	block_sigmask(ka, sig);
 
 	return 0;
 }
_

Patches currently in -mm which might be from matt.fleming@intel.com are

linux-next.patch

