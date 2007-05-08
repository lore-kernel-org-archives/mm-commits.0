From: akpm@linux-foundation.org
Subject: - v850-generic-timekeeping-conversion.patch removed from -mm tree
Date: Mon, 07 May 2007 17:07:48 -0700
Message-ID: <200705080007.l4807mPs009320@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39346 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967391AbXEHAIL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:08:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johnstul@us.ibm.com, uclinux-v850@lsi.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     v850: generic timekeeping conversion
has been removed from the -mm tree.  Its filename was
     v850-generic-timekeeping-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: v850: generic timekeeping conversion
From: john stultz <johnstul@us.ibm.com>

Convert an arch that does not currently implement sub-jiffy timekeeping to
use the generic timekeeping code.

v850 looks like it has some intent to implement sub-jiffy timekeeping, so
it may not yet be appropriate to try to convert, but I figured I'd get the
maintainer's input and submit the patch for comment.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Miles Bader <uclinux-v850@lsi.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/v850/Kconfig       |    4 ++
 arch/v850/kernel/time.c |   75 --------------------------------------
 2 files changed, 4 insertions(+), 75 deletions(-)

diff -puN arch/v850/Kconfig~v850-generic-timekeeping-conversion arch/v850/Kconfig
--- a/arch/v850/Kconfig~v850-generic-timekeeping-conversion
+++ a/arch/v850/Kconfig
@@ -37,6 +37,10 @@ config GENERIC_IRQ_PROBE
 	bool
 	default y
 
+config GENERIC_TIME
+	bool
+	default y
+
 config TIME_LOW_RES
 	bool
 	default y
diff -puN arch/v850/kernel/time.c~v850-generic-timekeeping-conversion arch/v850/kernel/time.c
--- a/arch/v850/kernel/time.c~v850-generic-timekeeping-conversion
+++ a/arch/v850/kernel/time.c
@@ -90,81 +90,6 @@ static irqreturn_t timer_interrupt (int 
 	return IRQ_HANDLED;
 }
 
-/*
- * This version of gettimeofday has near microsecond resolution.
- */
-void do_gettimeofday (struct timeval *tv)
-{
-#if 0 /* DAVIDM later if possible */
-	extern volatile unsigned long lost_ticks;
-	unsigned long lost;
-#endif
-	unsigned long flags;
-	unsigned long usec, sec;
-	unsigned long seq;
-
-	do {
-		seq = read_seqbegin_irqsave(&xtime_lock, flags);
-
-#if 0
-		usec = mach_gettimeoffset ? mach_gettimeoffset () : 0;
-#else
-		usec = 0;
-#endif
-#if 0 /* DAVIDM later if possible */
-		lost = lost_ticks;
-		if (lost)
-			usec += lost * (1000000/HZ);
-#endif
-		sec = xtime.tv_sec;
-		usec += xtime.tv_nsec / 1000;
-	} while (read_seqretry_irqrestore(&xtime_lock, seq, flags));
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
-	write_seqlock_irq (&xtime_lock);
-
-	/* This is revolting. We need to set the xtime.tv_nsec
-	 * correctly. However, the value in this location is
-	 * is value at the last tick.
-	 * Discover what correction gettimeofday
-	 * would have done, and then undo it!
-	 */
-#if 0
-	tv->tv_nsec -= mach_gettimeoffset() * 1000;
-#endif
-
-	while (tv->tv_nsec < 0) {
-		tv->tv_nsec += NSEC_PER_SEC;
-		tv->tv_sec--;
-	}
-
-	xtime.tv_sec = tv->tv_sec;
-	xtime.tv_nsec = tv->tv_nsec;
-
-	ntp_clear();
-
-	write_sequnlock_irq (&xtime_lock);
-	clock_was_set();
-	return 0;
-}
-
-EXPORT_SYMBOL(do_settimeofday);
-
 static int timer_dev_id;
 static struct irqaction timer_irqaction = {
 	timer_interrupt,
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
