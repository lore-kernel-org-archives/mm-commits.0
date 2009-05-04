From: akpm@linux-foundation.org
Subject: [merged] time-sh-convert-to-use-arch_getoffset-infrastructure.patch removed from -mm tree
Date: Mon, 04 May 2009 13:13:50 -0700
Message-ID: <200905042013.n44KDoMH022820@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37144 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751041AbZEDUQC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2009 16:16:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johnstul@us.ibm.com, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     time: sh: convert to use arch_getoffset() infrastructure
has been removed from the -mm tree.  Its filename was
     time-sh-convert-to-use-arch_getoffset-infrastructure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: time: sh: convert to use arch_getoffset() infrastructure
From: john stultz <johnstul@us.ibm.com>

Convert sh to use GENERIC_TIME via the arch_getoffset() infrastructure.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/Kconfig                    |    2 
 arch/sh/include/asm/timer.h        |    4 -
 arch/sh/kernel/time_32.c           |   63 ++-------------------------
 arch/sh/kernel/time_64.c           |   53 ----------------------
 arch/sh/kernel/timers/timer-mtu2.c |    2 
 5 files changed, 11 insertions(+), 113 deletions(-)

diff -puN arch/sh/Kconfig~time-sh-convert-to-use-arch_getoffset-infrastructure arch/sh/Kconfig
--- a/arch/sh/Kconfig~time-sh-convert-to-use-arch_getoffset-infrastructure
+++ a/arch/sh/Kconfig
@@ -75,7 +75,7 @@ config GENERIC_IOMAP
 	bool
 
 config GENERIC_TIME
-	def_bool n
+	def_bool y
 
 config GENERIC_CLOCKEVENTS
 	def_bool n
diff -puN arch/sh/include/asm/timer.h~time-sh-convert-to-use-arch_getoffset-infrastructure arch/sh/include/asm/timer.h
--- a/arch/sh/include/asm/timer.h~time-sh-convert-to-use-arch_getoffset-infrastructure
+++ a/arch/sh/include/asm/timer.h
@@ -9,7 +9,7 @@ struct sys_timer_ops {
 	int (*init)(void);
 	int (*start)(void);
 	int (*stop)(void);
-#ifndef CONFIG_GENERIC_TIME
+#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
 	unsigned long (*get_offset)(void);
 #endif
 };
@@ -26,7 +26,7 @@ struct sys_timer {
 extern struct sys_timer tmu_timer, mtu2_timer;
 extern struct sys_timer *sys_timer;
 
-#ifndef CONFIG_GENERIC_TIME
+#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
 static inline unsigned long get_timer_offset(void)
 {
 	return sys_timer->ops->get_offset();
diff -puN arch/sh/kernel/time_32.c~time-sh-convert-to-use-arch_getoffset-infrastructure arch/sh/kernel/time_32.c
--- a/arch/sh/kernel/time_32.c~time-sh-convert-to-use-arch_getoffset-infrastructure
+++ a/arch/sh/kernel/time_32.c
@@ -83,65 +83,12 @@ static int __init rtc_generic_init(void)
 }
 module_init(rtc_generic_init);
 
-#ifndef CONFIG_GENERIC_TIME
-void do_gettimeofday(struct timeval *tv)
+#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
+u32 arch_gettimeoffset(void)
 {
-	unsigned long flags;
-	unsigned long seq;
-	unsigned long usec, sec;
-
-	do {
-		/*
-		 * Turn off IRQs when grabbing xtime_lock, so that
-		 * the sys_timer get_offset code doesn't have to handle it.
-		 */
-		seq = read_seqbegin_irqsave(&xtime_lock, flags);
-		usec = get_timer_offset();
-		sec = xtime.tv_sec;
-		usec += xtime.tv_nsec / NSEC_PER_USEC;
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
-EXPORT_SYMBOL(do_gettimeofday);
-
-int do_settimeofday(struct timespec *tv)
-{
-	time_t wtm_sec, sec = tv->tv_sec;
-	long wtm_nsec, nsec = tv->tv_nsec;
-
-	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
-		return -EINVAL;
-
-	write_seqlock_irq(&xtime_lock);
-	/*
-	 * This is revolting. We need to set "xtime" correctly. However, the
-	 * value in this location is the value at the most recent update of
-	 * wall time.  Discover what correction gettimeofday() would have
-	 * made, and then undo it!
-	 */
-	nsec -= get_timer_offset() * NSEC_PER_USEC;
-
-	wtm_sec  = wall_to_monotonic.tv_sec + (xtime.tv_sec - sec);
-	wtm_nsec = wall_to_monotonic.tv_nsec + (xtime.tv_nsec - nsec);
-
-	set_normalized_timespec(&xtime, sec, nsec);
-	set_normalized_timespec(&wall_to_monotonic, wtm_sec, wtm_nsec);
-
-	ntp_clear();
-	write_sequnlock_irq(&xtime_lock);
-	clock_was_set();
-
-	return 0;
+	return get_timer_offset() * 1000;
 }
-EXPORT_SYMBOL(do_settimeofday);
-#endif /* !CONFIG_GENERIC_TIME */
+#endif /* CONFIG_ARCH_USES_GETTIMEOFFSET */
 
 /* last time the RTC clock got updated */
 static long last_rtc_update;
@@ -239,7 +186,7 @@ struct clocksource clocksource_sh = {
 	.name		= "SuperH",
 };
 
-#ifdef CONFIG_GENERIC_TIME
+#ifndef CONFIG_ARCH_USES_GETTIMEOFFSET
 unsigned long long sched_clock(void)
 {
 	unsigned long long cycles;
diff -puN arch/sh/kernel/time_64.c~time-sh-convert-to-use-arch_getoffset-infrastructure arch/sh/kernel/time_64.c
--- a/arch/sh/kernel/time_64.c~time-sh-convert-to-use-arch_getoffset-infrastructure
+++ a/arch/sh/kernel/time_64.c
@@ -144,59 +144,10 @@ static unsigned long usecs_since_tick(vo
 	return result;
 }
 
-void do_gettimeofday(struct timeval *tv)
+u32 arch_gettimeoffset(void)
 {
-	unsigned long flags;
-	unsigned long seq;
-	unsigned long usec, sec;
-
-	do {
-		seq = read_seqbegin_irqsave(&xtime_lock, flags);
-		usec = usecs_since_tick();
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
-EXPORT_SYMBOL(do_gettimeofday);
-
-int do_settimeofday(struct timespec *tv)
-{
-	time_t wtm_sec, sec = tv->tv_sec;
-	long wtm_nsec, nsec = tv->tv_nsec;
-
-	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
-		return -EINVAL;
-
-	write_seqlock_irq(&xtime_lock);
-	/*
-	 * This is revolting. We need to set "xtime" correctly. However, the
-	 * value in this location is the value at the most recent update of
-	 * wall time.  Discover what correction gettimeofday() would have
-	 * made, and then undo it!
-	 */
-	nsec -= 1000 * usecs_since_tick();
-
-	wtm_sec  = wall_to_monotonic.tv_sec + (xtime.tv_sec - sec);
-	wtm_nsec = wall_to_monotonic.tv_nsec + (xtime.tv_nsec - nsec);
-
-	set_normalized_timespec(&xtime, sec, nsec);
-	set_normalized_timespec(&wall_to_monotonic, wtm_sec, wtm_nsec);
-
-	ntp_clear();
-	write_sequnlock_irq(&xtime_lock);
-	clock_was_set();
-
-	return 0;
+	return usecs_since_tick() * 1000;
 }
-EXPORT_SYMBOL(do_settimeofday);
 
 /* Dummy RTC ops */
 static void null_rtc_get_time(struct timespec *tv)
diff -puN arch/sh/kernel/timers/timer-mtu2.c~time-sh-convert-to-use-arch_getoffset-infrastructure arch/sh/kernel/timers/timer-mtu2.c
--- a/arch/sh/kernel/timers/timer-mtu2.c~time-sh-convert-to-use-arch_getoffset-infrastructure
+++ a/arch/sh/kernel/timers/timer-mtu2.c
@@ -191,7 +191,7 @@ struct sys_timer_ops mtu2_timer_ops = {
 	.init		= mtu2_timer_init,
 	.start		= mtu2_timer_start,
 	.stop		= mtu2_timer_stop,
-#ifndef CONFIG_GENERIC_TIME
+#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
 	.get_offset	= mtu2_timer_get_offset,
 #endif
 };
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

linux-next.patch
time-move-calc_load-call-out-from-xtime_lock-protection.patch
time-avoid-possible-endless-loop-when-using-jiffies-clocksource-and-oneshot-mode-clockevent.patch
clocksource-sanity-check-sysfs-clocksource-changes.patch

