From: akpm@linux-foundation.org
Subject: [alternative-merged] score-dont-mask-signals-if-we-fail-to-setup-signal-stack.patch removed from -mm tree
Date: Wed, 23 May 2012 12:49:09 -0700
Message-ID: <20120523194909.5E7DAA0210@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:54357 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760680Ab2EWTtL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 May 2012 15:49:11 -0400
Received: by eeit10 with SMTP id t10so448221eei.1
        for <mm-commits@vger.kernel.org>; Wed, 23 May 2012 12:49:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matt.fleming@intel.com, lennox.wu@gmail.com, liqin.chen@sunplusct.com, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: score: don't mask signals if we fail to setup signal stack
has been removed from the -mm tree.  Its filename was
     score-dont-mask-signals-if-we-fail-to-setup-signal-stack.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Matt Fleming <matt.fleming@intel.com>
Subject: score: don't mask signals if we fail to setup signal stack

If setup_rt_frame() returns -EFAULT then we must not block any signals
in the current process.

Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/score/kernel/signal.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN arch/score/kernel/signal.c~score-dont-mask-signals-if-we-fail-to-setup-signal-stack arch/score/kernel/signal.c
--- a/arch/score/kernel/signal.c~score-dont-mask-signals-if-we-fail-to-setup-signal-stack
+++ a/arch/score/kernel/signal.c
@@ -272,12 +272,14 @@ static int handle_signal(unsigned long s
 	 */
 	ret = setup_rt_frame(ka, regs, sig, oldset, info);
 
-	spin_lock_irq(&current->sighand->siglock);
-	sigorsets(&current->blocked, &current->blocked, &ka->sa.sa_mask);
-	if (!(ka->sa.sa_flags & SA_NODEFER))
-		sigaddset(&current->blocked, sig);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	if (ret == 0) {
+		spin_lock_irq(&current->sighand->siglock);
+		sigorsets(&current->blocked, &current->blocked, &ka->sa.sa_mask);
+		if (!(ka->sa.sa_flags & SA_NODEFER))
+			sigaddset(&current->blocked, sig);
+		recalc_sigpending();
+		spin_unlock_irq(&current->sighand->siglock);
+	}
 
 	return ret;
 }
_

Patches currently in -mm which might be from matt.fleming@intel.com are

linux-next.patch
score-use-set_current_blocked-and-block_sigmask.patch
h8300-use-set_current_blocked-and-block_sigmask.patch
unicore32-use-block_sigmask.patch
blackfin-use-set_current_blocked-and-block_sigmask.patch
frv-use-set_current_blocked-and-block_sigmask.patch
parisc-use-set_current_blocked-and-block_sigmask.patch

