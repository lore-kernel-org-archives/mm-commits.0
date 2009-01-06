From: akpm@linux-foundation.org
Subject: + rcu-fix-rcutree-grace-period-latency-bug-on-small-systems.patch added to -mm tree
Date: Mon, 05 Jan 2009 16:08:49 -0800
Message-ID: <200901060008.n0608och011008@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33591 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751307AbZAFAJH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2009 19:09:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com, andi@firstfloor.org, mingo@elte.hu


The patch titled
     rcu: fix rcutree grace-period-latency bug on small systems
has been added to the -mm tree.  Its filename is
     rcu-fix-rcutree-grace-period-latency-bug-on-small-systems.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rcu: fix rcutree grace-period-latency bug on small systems
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Kudos to Andi Kleen for finding a grace-period-latency problem!  The
problem was that the special-case code for small machines never updated
the ->signaled field to indicate that grace-period initialization had
completed, which prevented force_quiescent_state() from ever expediting
grace periods.  This problem resulted in grace periods extending for more
than 20 seconds.  Not subtle.  I introduced this bug during my inspection
process when I fixed a race between grace-period initialization and
force_quiescent_state() execution.

The following patch properly updates the ->signaled field for the
"small"-system case (no more than 32 CPUs for 32-bit kernels and no more
than 64 CPUs for 64-bit kernels).

I believe that this patch should be included for 2.6.29.

Reported-by: Andi Kleen <andi@firstfloor.org>
Tested-by: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rcutree.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/rcutree.c~rcu-fix-rcutree-grace-period-latency-bug-on-small-systems kernel/rcutree.c
--- a/kernel/rcutree.c~rcu-fix-rcutree-grace-period-latency-bug-on-small-systems
+++ a/kernel/rcutree.c
@@ -572,6 +572,7 @@ rcu_start_gp(struct rcu_state *rsp, unsi
 	/* Special-case the common single-level case. */
 	if (NUM_RCU_NODES == 1) {
 		rnp->qsmask = rnp->qsmaskinit;
+		rsp->signaled = RCU_SIGNAL_INIT; /* force_quiescent_state OK. */
 		spin_unlock_irqrestore(&rnp->lock, flags);
 		return;
 	}
_

Patches currently in -mm which might be from paulmck@linux.vnet.ibm.com are

origin.patch
linux-next.patch
rcu-fix-rcutree-grace-period-latency-bug-on-small-systems.patch
kmemleak-add-the-base-support.patch
kmemleak-add-the-base-support-fix.patch

