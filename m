From: akpm@linux-foundation.org
Subject: + clocksource-spelling-error-in-watchdog-code.patch added to -mm tree
Date: Tue, 08 May 2007 12:25:13 -0700
Message-ID: <200705081925.l48JPDXS031603@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38125 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967303AbXEHTZW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 15:25:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwalker@mvista.com


The patch titled
     clocksource: spelling error in watchdog code
has been added to the -mm tree.  Its filename is
     clocksource-spelling-error-in-watchdog-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: clocksource: spelling error in watchdog code
From: Daniel Walker <dwalker@mvista.com>

There's more that need fixing, and fix my own subject spelling error too.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/clocksource.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

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
clocksource-spelling-error-in-watchdog-code.patch
slim-make-and-config-stuff.patch
profile-likely-unlikely-macros.patch
