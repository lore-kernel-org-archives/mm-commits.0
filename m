From: akpm@linux-foundation.org
Subject: + cpuidle-remove-unused-hrtimer_peek_ahead_timers-call.patch added to -mm tree
Date: Wed, 04 Apr 2012 15:19:56 -0700
Message-ID: <20120404221956.B2F2EA042C@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:59894 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556Ab2DDWT5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Apr 2012 18:19:57 -0400
Received: by ghbz15 with SMTP id z15so101336ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 04 Apr 2012 15:19:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sergey.senozhatsky@gmail.com, arjan@infradead.org, arjan@linux.intel.com, deepthi@linux.vnet.ibm.com, g.trinabh@gmail.com, khilman@ti.com, len.brown@intel.com


The patch titled
     Subject: cpuidle: remove unused hrtimer_peek_ahead_timers() call
has been added to the -mm tree.  Its filename is
     cpuidle-remove-unused-hrtimer_peek_ahead_timers-call.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: cpuidle: remove unused hrtimer_peek_ahead_timers() call

 cpuidle: remove unused hrtimer_peek_ahead_timers() call

  commit 9a6558371bcd01c2973b7638181db4ccc34eab4f
  Author: Arjan van de Ven <arjan@linux.intel.com>
  Date:   Sun Nov 9 12:45:10 2008 -0800

     regression: disable timer peek-ahead for 2.6.28

     It's showing up as regressions; disabling it very likely just papers
     over an underlying issue, but time is running out for 2.6.28, lets get
     back to this for 2.6.29

 Many years has passed since 2008, so it seems ok to remove whole `#if 0' block.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Kevin Hilman <khilman@ti.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Trinabh Gupta <g.trinabh@gmail.com>
Cc: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpuidle/cpuidle.c |    9 ---------
 1 file changed, 9 deletions(-)

diff -puN drivers/cpuidle/cpuidle.c~cpuidle-remove-unused-hrtimer_peek_ahead_timers-call drivers/cpuidle/cpuidle.c
--- a/drivers/cpuidle/cpuidle.c~cpuidle-remove-unused-hrtimer_peek_ahead_timers-call
+++ a/drivers/cpuidle/cpuidle.c
@@ -121,15 +121,6 @@ int cpuidle_idle_call(void)
 	if (!dev || !dev->enabled)
 		return -EBUSY;
 
-#if 0
-	/* shows regressions, re-enable for 2.6.29 */
-	/*
-	 * run any timers that can be run now, at this point
-	 * before calculating the idle duration etc.
-	 */
-	hrtimer_peek_ahead_timers();
-#endif
