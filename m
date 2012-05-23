From: akpm@linux-foundation.org
Subject: [merged] ia64-use-set_current_blocked-and-block_sigmask.patch removed from -mm tree
Date: Wed, 23 May 2012 12:51:22 -0700
Message-ID: <20120523195122.9B7D5A0210@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:44142 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760799Ab2EWTvX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 May 2012 15:51:23 -0400
Received: by mail-qc0-f202.google.com with SMTP id p5so924325qcs.1
        for <mm-commits@vger.kernel.org>; Wed, 23 May 2012 12:51:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matt.fleming@intel.com, fenghua.yu@intel.com, oleg@redhat.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: use set_current_blocked() and block_sigmask()
has been removed from the -mm tree.  Its filename was
     ia64-use-set_current_blocked-and-block_sigmask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Matt Fleming <matt.fleming@intel.com>
Subject: ia64: use set_current_blocked() and block_sigmask()

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
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/signal.c |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff -puN arch/ia64/kernel/signal.c~ia64-use-set_current_blocked-and-block_sigmask arch/ia64/kernel/signal.c
--- a/arch/ia64/kernel/signal.c~ia64-use-set_current_blocked-and-block_sigmask
+++ a/arch/ia64/kernel/signal.c
@@ -201,13 +201,7 @@ ia64_rt_sigreturn (struct sigscratch *sc
 		goto give_sigsegv;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-
-	spin_lock_irq(&current->sighand->siglock);
-	{
-		current->blocked = set;
-		recalc_sigpending();
-	}
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (restore_sigcontext(sc, scr))
 		goto give_sigsegv;
@@ -427,12 +421,7 @@ handle_signal (unsigned long sig, struct
 	if (!setup_frame(sig, ka, info, oldset, scr))
 		return 0;
 
-	spin_lock_irq(&current->sighand->siglock);
-	sigorsets(&current->blocked, &current->blocked, &ka->sa.sa_mask);
-	if (!(ka->sa.sa_flags & SA_NODEFER))
-		sigaddset(&current->blocked, sig);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	block_sigmask(ka, sig);
 
 	/*
 	 * Let tracing know that we've done the handler setup.
_

Patches currently in -mm which might be from matt.fleming@intel.com are

linux-next.patch

