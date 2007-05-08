From: akpm@linux-foundation.org
Subject: - convert-h8-300-to-generic-timekeeping.patch removed from -mm tree
Date: Mon, 07 May 2007 17:04:56 -0700
Message-ID: <200705080004.l4804uO6009051@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41423 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967364AbXEHAFU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:05:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johnstul@us.ibm.com, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Convert h8/300 to generic timekeeping
has been removed from the -mm tree.  Its filename was
     convert-h8-300-to-generic-timekeeping.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Convert h8/300 to generic timekeeping
From: john stultz <johnstul@us.ibm.com>

Currently h8/300 does not implement sub-jiffy timekeeping, so there is no
benefit to having arch specific timekeeping code.

This patch simply removes those functions and enables the generic
timekeeping code.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Acked-by: Yoshinori Sato <ysato@users.sourceforge.jp>
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

origin.patch
optimize-timespec_trunc.patch
time-smp-friendly-alignment-of-struct-clocksource.patch
move-timekeeping-code-to-timekeepingc.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
introduce-a-handy-list_first_entry-macro-v2.patch
blacklist-dell-optiplex-320-from-using-the-hpet.patch
blacklist-dell-optiplex-320-from-using-the-hpet-fix.patch
declare-struct-ktime.patch
clocksource-fix-resume-logic.patch
clockevents-fix-resume-logic-updated-version.patch
