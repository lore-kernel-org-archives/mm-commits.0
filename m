From: akpm@linux-foundation.org
Subject: + convert-h8-300-to-generic-timekeeping.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:56:44 -0800
Message-ID: <200702272056.l1RKumXM028316@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52012 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752548AbXB0VAD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 16:00:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johnstul@us.ibm.com, ysato@users.sourceforge.jp


The patch titled
     Convert h8/300 to generic timekeeping
has been added to the -mm tree.  Its filename is
     convert-h8-300-to-generic-timekeeping.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Convert h8/300 to generic timekeeping
From: john stultz <johnstul@us.ibm.com>

Currently h8/300 does not implement sub-jiffy timekeeping, so there is no
benefit to having arch specific timekeeping code.

This patch simply removes those functions and enables the generic
timekeeping code.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/Kconfig       |    4 ++
 arch/h8300/kernel/time.c |   52 -------------------------------------
 2 files changed, 4 insertions(+), 52 deletions(-)

diff -puN arch/h8300/Kconfig~convert-h8-300-to-generic-timekeeping arch/h8300/Kconfig
--- a/arch/h8300/Kconfig~convert-h8-300-to-generic-timekeeping
+++ a/arch/h8300/Kconfig
@@ -53,6 +53,10 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
+config GENERIC_TIME
+	bool
+	default y
+
 config TIME_LOW_RES
 	bool
 	default y
diff -puN arch/h8300/kernel/time.c~convert-h8-300-to-generic-timekeeping arch/h8300/kernel/time.c
--- a/arch/h8300/kernel/time.c~convert-h8-300-to-generic-timekeeping
+++ a/arch/h8300/kernel/time.c
@@ -66,55 +66,3 @@ void time_init(void)
 
 	platform_timer_setup(timer_interrupt);
 }
-
-/*
- * This version of gettimeofday has near microsecond resolution.
- */
-void do_gettimeofday(struct timeval *tv)
-{
-	unsigned long flags;
-	unsigned long usec, sec;
-
-	read_lock_irqsave(&xtime_lock, flags);
-	usec = 0;
-	sec = xtime.tv_sec;
-	usec += (xtime.tv_nsec / 1000);
-	read_unlock_irqrestore(&xtime_lock, flags);
-
-	while (usec >= 1000000) {
-		usec -= 1000000;
-		sec++;
-	}
-
-	tv->tv_sec = sec;
-	tv->tv_usec = usec;
-}
-
-EXPORT_SYMBOL(do_gettimeofday);
-
-int do_settimeofday(struct timespec *tv)
-{
-	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
-		return -EINVAL;
-
-	write_lock_irq(&xtime_lock);
-	/* This is revolting. We need to set the xtime.tv_usec
-	 * correctly. However, the value in this location is
-	 * is value at the last tick.
-	 * Discover what correction gettimeofday
-	 * would have done, and then undo it!
-	 */
-	while (tv->tv_nsec < 0) {
-		tv->tv_nsec += NSEC_PER_SEC;
-		tv->tv_sec--;
-	}
-
-	xtime.tv_sec = tv->tv_sec;
-	xtime.tv_nsec = tv->tv_nsec;
-	ntp_clear();
-	write_sequnlock_irq(&xtime_lock);
-	clock_was_set();
-	return 0;
-}
-
-EXPORT_SYMBOL(do_settimeofday);
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

log-reason-why-tsc-was-marked-unstable.patch
clocksource-init-adjustments-fix-bug-7426.patch
convert-h8-300-to-generic-timekeeping.patch
v850-generic-timekeeping-conversion.patch
profile-likely-unlikely-macros-x86_64-fix.patch
