From: akpm@linux-foundation.org
Subject: + pps-remove-unreachable-code.patch added to -mm tree
Date: Fri, 25 Feb 2011 12:47:20 -0800
Message-ID: <201102252047.p1PKlKvh028821@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43859 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932620Ab1BYUr2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Feb 2011 15:47:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lasaine@lvk.cs.msu.su, giometti@linux.it, johnstul@us.ibm.com


The patch titled
     pps: remove unreachable code
has been added to the -mm tree.  Its filename is
     pps-remove-unreachable-code.patch

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
