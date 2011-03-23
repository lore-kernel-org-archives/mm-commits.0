From: akpm@linux-foundation.org
Subject: [merged] pps-remove-unreachable-code.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:41:10 -0700
Message-ID: <201103232044.p2NKikqm029125@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47501 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933430Ab1CWUpl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:45:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lasaine@lvk.cs.msu.su, giometti@linux.it, johnstul@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     pps: remove unreachable code
has been removed from the -mm tree.  Its filename was
     pps-remove-unreachable-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pps: remove unreachable code
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>

Remove code enabled only when CONFIG_PREEMPT_RT is turned on because it is
not used in the vanilla kernel.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Rodolfo Giometti <giometti@linux.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/generators/pps_gen_parport.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN drivers/pps/generators/pps_gen_parport.c~pps-remove-unreachable-code drivers/pps/generators/pps_gen_parport.c
--- a/drivers/pps/generators/pps_gen_parport.c~pps-remove-unreachable-code
+++ a/drivers/pps/generators/pps_gen_parport.c
@@ -216,11 +216,6 @@ static void parport_attach(struct parpor
 
 	hrtimer_init(&device.timer, CLOCK_REALTIME, HRTIMER_MODE_ABS);
 	device.timer.function = hrtimer_event;
-#ifdef CONFIG_PREEMPT_RT
-	/* hrtimer interrupt will run in the interrupt context with this */
-	device.timer.irqsafe = 1;
-#endif
