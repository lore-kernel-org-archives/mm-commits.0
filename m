From: akpm@linux-foundation.org
Subject: + pps-ktimer-remove-noisy-message.patch added to -mm tree
Date: Mon, 24 Jan 2011 14:51:29 -0800
Message-ID: <201101242251.p0OMpTt3015668@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42546 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751344Ab1AXWwN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Jan 2011 17:52:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: giometti@linux.it, lasaine@lvk.cs.msu.su, mingo@elte.hu


The patch titled
     pps ktimer: remove noisy message
has been added to the -mm tree.  Its filename is
     pps-ktimer-remove-noisy-message.patch

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
Subject: pps ktimer: remove noisy message
From: Rodolfo Giometti <giometti@linux.it>

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/clients/pps-ktimer.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/pps/clients/pps-ktimer.c~pps-ktimer-remove-noisy-message drivers/pps/clients/pps-ktimer.c
--- a/drivers/pps/clients/pps-ktimer.c~pps-ktimer-remove-noisy-message
+++ a/drivers/pps/clients/pps-ktimer.c
@@ -46,8 +46,6 @@ static void pps_ktimer_event(unsigned lo
 	/* First of all we get the time stamp... */
 	pps_get_ts(&ts);
 
-	dev_info(pps->dev, "PPS event at %lu\n", jiffies);
