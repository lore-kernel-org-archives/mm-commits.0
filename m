From: akpm@linux-foundation.org
Subject: - clocksource-fix-lock-order-in-the-resume-path.patch removed from -mm tree
Date: Tue, 15 May 2007 11:07:16 -0700
Message-ID: <200705151807.l4FI7FEa014153@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57691 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755696AbXEOSIL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 14:08:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, johnstul@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     clocksource: fix lock order in the resume path
has been removed from the -mm tree.  Its filename was
     clocksource-fix-lock-order-in-the-resume-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: clocksource: fix lock order in the resume path
From: Thomas Gleixner <tglx@linutronix.de>

lockdep complains about the lock nesting of clocksource and watchdog lock
in the resume path.

Change the resume marker to a bit operation and remove the lock from this
path.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/clocksource.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN kernel/time/clocksource.c~clocksource-fix-lock-order-in-the-resume-path kernel/time/clocksource.c
--- a/kernel/time/clocksource.c~clocksource-fix-lock-order-in-the-resume-path
+++ a/kernel/time/clocksource.c
@@ -74,7 +74,7 @@ static struct clocksource *watchdog;
 static struct timer_list watchdog_timer;
 static DEFINE_SPINLOCK(watchdog_lock);
 static cycle_t watchdog_last;
-static int watchdog_resumed;
+static unsigned long watchdog_resumed;
 
 /*
  * Interval: 0.5sec Threshold: 0.0625s
@@ -104,9 +104,7 @@ static void clocksource_watchdog(unsigne
 
 	spin_lock(&watchdog_lock);
 
-	resumed = watchdog_resumed;
-	if (unlikely(resumed))
-		watchdog_resumed = 0;
+	resumed = test_and_clear_bit(0, &watchdog_resumed);
 
 	wdnow = watchdog->read();
 	wd_nsec = cyc2ns(watchdog, (wdnow - watchdog_last) & watchdog->mask);
@@ -151,9 +149,7 @@ static void clocksource_watchdog(unsigne
 }
 static void clocksource_resume_watchdog(void)
 {
-	spin_lock(&watchdog_lock);
-	watchdog_resumed = 1;
-	spin_unlock(&watchdog_lock);
+	set_bit(0, &watchdog_resumed);
 }
 
 static void clocksource_check_watchdog(struct clocksource *cs)
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
drm-spinlock-initializer-cleanup.patch
s390-spinlock-initializer-cleanup.patch
i386-hpet-check-if-the-counter-works.patch
clockevents-fix-resume-logic-updated-version.patch
