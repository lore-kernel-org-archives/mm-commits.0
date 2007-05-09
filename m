From: akpm@linux-foundation.org
Subject: - clocksource-spelling-error-in-watchdog-code.patch removed from -mm tree
Date: Wed, 09 May 2007 14:50:20 -0700
Message-ID: <200705092150.l49LoKlo002796@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42238 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758210AbXEIVu1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:50:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, mm-commits@vger.kernel.org


The patch titled
     clocksource: spelling error in watchdog code
has been removed from the -mm tree.  Its filename was
     clocksource-spelling-error-in-watchdog-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: clocksource: spelling error in watchdog code
From: Daniel Walker <dwalker@mvista.com>

There's more that need fixing, and fix my own subject spelling error too.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/clocksource.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/time/clocksource.c~clocksource-spelling-error-in-watchdog-code kernel/time/clocksource.c
--- a/kernel/time/clocksource.c~clocksource-spelling-error-in-watchdog-code
+++ a/kernel/time/clocksource.c
@@ -75,14 +75,14 @@ static struct timer_list watchdog_timer;
 static DEFINE_SPINLOCK(watchdog_lock);
 static cycle_t watchdog_last;
 /*
- * Interval: 0.5sec Treshold: 0.0625s
+ * Interval: 0.5sec Threshold: 0.0625s
  */
 #define WATCHDOG_INTERVAL (HZ >> 1)
-#define WATCHDOG_TRESHOLD (NSEC_PER_SEC >> 4)
+#define WATCHDOG_THRESHOLD (NSEC_PER_SEC >> 4)
 
 static void clocksource_ratewd(struct clocksource *cs, int64_t delta)
 {
-	if (delta > -WATCHDOG_TRESHOLD && delta < WATCHDOG_TRESHOLD)
+	if (delta > -WATCHDOG_THRESHOLD && delta < WATCHDOG_THRESHOLD)
 		return;
 
 	printk(KERN_WARNING "Clocksource %s unstable (delta = %Ld ns)\n",
_

Patches currently in -mm which might be from dwalker@mvista.com are

origin.patch
slim-make-and-config-stuff.patch
profile-likely-unlikely-macros.patch
