From: akpm@linux-foundation.org
Subject: + clocksource-fix-lock-order-in-the-resume-path.patch added to -mm tree
Date: Mon, 14 May 2007 15:02:11 -0700
Message-ID: <200705142202.l4EM2B7f027283@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:32868 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755244AbXENWCT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 May 2007 18:02:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, johnstul@us.ibm.com


The patch titled
     clocksource: fix lock order in the resume path
has been added to the -mm tree.  Its filename is
     clocksource-fix-lock-order-in-the-resume-path.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 3 insertions(+), 7 deletions(-)

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

timekeeping-fix-mismerge.patch
clocksource-fix-lock-order-in-the-resume-path.patch
git-avr32.patch
drm-spinlock-initializer-cleanup.patch
git-dvb.patch
s390-spinlock-initializer-cleanup.patch
i386-hpet-check-if-the-counter-works.patch
clockevents-fix-resume-logic-updated-version.patch
