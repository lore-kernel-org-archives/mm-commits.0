From: akpm@linux-foundation.org
Subject: + cpuidle-always-return-with-interrupts-enabled.patch added to -mm tree
Date: Tue, 06 Oct 2009 13:35:08 -0700
Message-ID: <200910062035.n96KZ8aJ010418@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38955 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757692AbZJFUgb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Oct 2009 16:36:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khilman@deeprootsystems.com, arjan@linux.intel.com, hemanthv@ti.com, len.brown@intel.com, mingo@elte.hu, rjw@sisk.pl, venkatesh.pallipadi@intel.com


The patch titled
     cpuidle: always return with interrupts enabled
has been added to the -mm tree.  Its filename is
     cpuidle-always-return-with-interrupts-enabled.patch

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
Subject: cpuidle: always return with interrupts enabled
From: Kevin Hilman <khilman@deeprootsystems.com>

In the case where cpuidle_idle_call() returns before changing state due to
a need_resched(), it was returning with IRQs disabled.

This patch ensures IRQs are (re)enabled before returning.

Reported-by: Hemanth V <hemanthv@ti.com>
Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpuidle/cpuidle.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/cpuidle/cpuidle.c~cpuidle-always-return-with-interrupts-enabled drivers/cpuidle/cpuidle.c
--- a/drivers/cpuidle/cpuidle.c~cpuidle-always-return-with-interrupts-enabled
+++ a/drivers/cpuidle/cpuidle.c
@@ -76,8 +76,11 @@ static void cpuidle_idle_call(void)
 #endif
 	/* ask the governor for the next state */
 	next_state = cpuidle_curr_governor->select(dev);
-	if (need_resched())
+	if (need_resched()) {
+		local_irq_enable();
 		return;
+	}
+
 	target_state = &dev->states[next_state];
 
 	/* enter the state and update stats */
_

Patches currently in -mm which might be from khilman@deeprootsystems.com are

cpuidle-always-return-with-interrupts-enabled.patch

