From: akpm@linux-foundation.org
Subject: + time-sh-convert-to-use-arch_getoffset-infrastructure.patch added to -mm tree
Date: Thu, 16 Apr 2009 16:04:47 -0700
Message-ID: <200904162304.n3GN4lDi009966@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38975 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754283AbZDPXHI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Apr 2009 19:07:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johnstul@us.ibm.com, lethal@linux-sh.org


The patch titled
     time: sh: convert to use arch_getoffset() infrastructure
has been added to the -mm tree.  Its filename is
     time-sh-convert-to-use-arch_getoffset-infrastructure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: time: sh: convert to use arch_getoffset() infrastructure
From: john stultz <johnstul@us.ibm.com>

Convert sh to use GENERIC_TIME via the arch_getoffset() infrastructure.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/Kconfig                    |    6 ++
 arch/sh/include/asm/timer.h        |    4 -
 arch/sh/kernel/time_32.c           |   63 ++-------------------------
 arch/sh/kernel/time_64.c           |   53 ----------------------
 arch/sh/kernel/timers/timer-cmt.c  |    2 
 arch/sh/kernel/timers/timer-mtu2.c |    2 
 6 files changed, 16 insertions(+), 114 deletions(-)

diff -puN arch/sh/Kconfig~time-sh-convert-to-use-arch_getoffset-infrastructure arch/sh/Kconfig
--- a/arch/sh/Kconfig~time-sh-convert-to-use-arch_getoffset-infrastructure
+++ a/arch/sh/Kconfig
@@ -74,7 +74,7 @@ config GENERIC_IOMAP
 	bool
 
 config GENERIC_TIME
-	def_bool n
+	def_bool y
 
 config GENERIC_CLOCKEVENTS
 	def_bool n
@@ -451,6 +451,10 @@ config SH_TMU
 	help
 	  This enables the use of the TMU as the system timer.
 
+config ARCH_USES_GETTIMEOFFSET
+	def_bool y
+	depends on !SH_TMU
+
 config SH_CMT
 	bool "CMT timer support"
 	depends on SYS_SUPPORTS_CMT && CPU_SH2
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
 extern struct sys_timer tmu_timer, cmt_timer, mtu2_timer;
 extern struct sys_timer *sys_timer;
 
-#ifndef CONFIG_GENERIC_TIME
+#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
 static inline unsigned long get_timer_offset(void)
 {
 	return sys_timer->ops->get_offset();
diff -puN arch/sh/kernel/time_32.c~time-sh-convert-to-use-arch_getoffset-infrastructure arch/sh/kernel/time_32.c
--- a/arch/sh/kernel/time_32.c~time-sh-convert-to-use-arch_getoffset-infrastructure
+++ a/arch/sh/kernel/time_32.c
@@ -44,65 +44,12 @@ static int null_rtc_set_time(const time_
 void (*rtc_sh_get_time)(struct timespec *) = null_rtc_get_time;
 int (*rtc_sh_set_time)(const time_t) = null_rtc_set_time;
 
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
@@ -200,7 +147,7 @@ struct clocksource clocksource_sh = {
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
diff -puN arch/sh/kernel/timers/timer-cmt.c~time-sh-convert-to-use-arch_getoffset-infrastructure arch/sh/kernel/timers/timer-cmt.c
--- a/arch/sh/kernel/timers/timer-cmt.c~time-sh-convert-to-use-arch_getoffset-infrastructure
+++ a/arch/sh/kernel/timers/timer-cmt.c
@@ -177,7 +177,7 @@ static struct sys_timer_ops cmt_timer_op
 	.init		= cmt_timer_init,
 	.start		= cmt_timer_start,
 	.stop		= cmt_timer_stop,
-#ifndef CONFIG_GENERIC_TIME
+#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
 	.get_offset	= cmt_timer_get_offset,
 #endif
 };
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

clocksource-pass-clocksource-to-read-callback.patch
clocksource-add-enable-and-disable-callbacks.patch
clocksource-sanity-check-sysfs-clocksource-changes.patch
time-move-calc_load-call-out-from-xtime_lock-protection.patch
time-avoid-possible-endless-loop-when-using-jiffies-clocksource-and-oneshot-mode-clockevent.patch
time-create-arch_gettimeoffset-infrastructure-for-use-in-the-generic-timekeeping-core.patch
time-sh-convert-to-use-arch_getoffset-infrastructure.patch

