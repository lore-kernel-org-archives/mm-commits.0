From: akpm@linux-foundation.org
Subject: [merged] cpuidle-remove-unused-hrtimer_peek_ahead_timers-call.patch removed from -mm tree
Date: Tue, 05 Jun 2012 12:56:10 -0700
Message-ID: <20120605195610.8E11BA028F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:59523 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab2FET4M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2012 15:56:12 -0400
Received: by wgbdt11 with SMTP id dt11so356202wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 05 Jun 2012 12:56:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, arjan@infradead.org, arjan@linux.intel.com, deepthi@linux.vnet.ibm.com, g.trinabh@gmail.com, khilman@ti.com, len.brown@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cpuidle: remove unused hrtimer_peek_ahead_timers() call
has been removed from the -mm tree.  Its filename was
     cpuidle-remove-unused-hrtimer_peek_ahead_timers-call.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -141,15 +141,6 @@ int cpuidle_idle_call(void)
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
