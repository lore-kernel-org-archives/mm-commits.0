From: akpm@linux-foundation.org
Subject: - ntp-move-the-cmos-update-code-into-ntpc.patch removed from -mm tree
Date: Mon, 23 Jul 2007 02:34:10 -0700
Message-ID: <200707230934.l6N9YADt016361@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43369 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758519AbXGWJqh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 05:46:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, chrisw@sous-sol.org, davem@davemloft.net, johnstul@us.ibm.com, mingo@elte.hu, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     NTP: move the cmos update code into ntp.c
has been removed from the -mm tree.  Its filename was
     ntp-move-the-cmos-update-code-into-ntpc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: NTP: move the cmos update code into ntp.c
From: Thomas Gleixner <tglx@linutronix.de>

i386 and sparc64 have the identical code to update the cmos clock.  Move it
into kernel/time/ntp.c as there are other architectures coming along with the
same requirements.

[akpm@linux-foundation.org: build fixes]
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: David Miller <davem@davemloft.net>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/Kconfig          |    4 ++
 arch/i386/kernel/time.c    |   50 +----------------------------
 arch/sparc64/Kconfig       |    4 ++
 arch/sparc64/kernel/time.c |   53 +------------------------------
 include/asm-i386/timer.h   |    1 
 include/linux/time.h       |    3 +
 kernel/time/ntp.c          |   59 +++++++++++++++++++++++++++++++++--
 7 files changed, 71 insertions(+), 103 deletions(-)

diff -puN arch/i386/Kconfig~ntp-move-the-cmos-update-code-into-ntpc arch/i386/Kconfig
--- a/arch/i386/Kconfig~ntp-move-the-cmos-update-code-into-ntpc
+++ a/arch/i386/Kconfig
@@ -18,6 +18,10 @@ config GENERIC_TIME
 	bool
 	default y
 
+config GENERIC_CMOS_UPDATE
+	bool
+	default y
+
 config CLOCKSOURCE_WATCHDOG
 	bool
 	default y
diff -puN arch/i386/kernel/time.c~ntp-move-the-cmos-update-code-into-ntpc arch/i386/kernel/time.c
--- a/arch/i386/kernel/time.c~ntp-move-the-cmos-update-code-into-ntpc
+++ a/arch/i386/kernel/time.c
@@ -207,55 +207,9 @@ unsigned long read_persistent_clock(void
 	return retval;
 }
 
-static void sync_cmos_clock(unsigned long dummy);
-
-static DEFINE_TIMER(sync_cmos_timer, sync_cmos_clock, 0, 0);
-int no_sync_cmos_clock;
-
-static void sync_cmos_clock(unsigned long dummy)
-{
-	struct timeval now, next;
-	int fail = 1;
-
-	/*
-	 * If we have an externally synchronized Linux clock, then update
-	 * CMOS clock accordingly every ~11 minutes. Set_rtc_mmss() has to be
-	 * called as close as possible to 500 ms before the new second starts.
-	 * This code is run on a timer.  If the clock is set, that timer
-	 * may not expire at the correct time.  Thus, we adjust...
-	 */
-	if (!ntp_synced())
-		/*
-		 * Not synced, exit, do not restart a timer (if one is
-		 * running, let it run out).
-		 */
-		return;
-
-	do_gettimeofday(&now);
-	if (now.tv_usec >= USEC_AFTER - ((unsigned) TICK_SIZE) / 2 &&
-	    now.tv_usec <= USEC_BEFORE + ((unsigned) TICK_SIZE) / 2)
-		fail = set_rtc_mmss(now.tv_sec);
-
-	next.tv_usec = USEC_AFTER - now.tv_usec;
-	if (next.tv_usec <= 0)
-		next.tv_usec += USEC_PER_SEC;
-
-	if (!fail)
-		next.tv_sec = 659;
-	else
-		next.tv_sec = 0;
-
-	if (next.tv_usec >= USEC_PER_SEC) {
-		next.tv_sec++;
-		next.tv_usec -= USEC_PER_SEC;
-	}
-	mod_timer(&sync_cmos_timer, jiffies + timeval_to_jiffies(&next));
-}
-
-void notify_arch_cmos_timer(void)
+int update_persistent_clock(struct timespec now)
 {
-	if (!no_sync_cmos_clock)
-		mod_timer(&sync_cmos_timer, jiffies + 1);
+	return set_rtc_mmss(now.tv_sec);
 }
 
 extern void (*late_time_init)(void);
diff -puN arch/sparc64/Kconfig~ntp-move-the-cmos-update-code-into-ntpc arch/sparc64/Kconfig
--- a/arch/sparc64/Kconfig~ntp-move-the-cmos-update-code-into-ntpc
+++ a/arch/sparc64/Kconfig
@@ -23,6 +23,10 @@ config GENERIC_TIME
 	bool
 	default y
 
+config GENERIC_CMOS_UPDATE
+	bool
+	default y
+
 config GENERIC_CLOCKEVENTS
 	bool
 	default y
diff -puN arch/sparc64/kernel/time.c~ntp-move-the-cmos-update-code-into-ntpc arch/sparc64/kernel/time.c
--- a/arch/sparc64/kernel/time.c~ntp-move-the-cmos-update-code-into-ntpc
+++ a/arch/sparc64/kernel/time.c
@@ -403,58 +403,9 @@ static struct sparc64_tick_ops hbtick_op
 
 static unsigned long timer_ticks_per_nsec_quotient __read_mostly;
 
-#define TICK_SIZE (tick_nsec / 1000)
-
-#define USEC_AFTER	500000
-#define USEC_BEFORE	500000
-
-static void sync_cmos_clock(unsigned long dummy);
-
-static DEFINE_TIMER(sync_cmos_timer, sync_cmos_clock, 0, 0);
-
-static void sync_cmos_clock(unsigned long dummy)
-{
-	struct timeval now, next;
-	int fail = 1;
-
-	/*
-	 * If we have an externally synchronized Linux clock, then update
-	 * CMOS clock accordingly every ~11 minutes. Set_rtc_mmss() has to be
-	 * called as close as possible to 500 ms before the new second starts.
-	 * This code is run on a timer.  If the clock is set, that timer
-	 * may not expire at the correct time.  Thus, we adjust...
-	 */
-	if (!ntp_synced())
-		/*
-		 * Not synced, exit, do not restart a timer (if one is
-		 * running, let it run out).
-		 */
-		return;
-
-	do_gettimeofday(&now);
-	if (now.tv_usec >= USEC_AFTER - ((unsigned) TICK_SIZE) / 2 &&
-	    now.tv_usec <= USEC_BEFORE + ((unsigned) TICK_SIZE) / 2)
-		fail = set_rtc_mmss(now.tv_sec);
-
-	next.tv_usec = USEC_AFTER - now.tv_usec;
-	if (next.tv_usec <= 0)
-		next.tv_usec += USEC_PER_SEC;
-
-	if (!fail)
-		next.tv_sec = 659;
-	else
-		next.tv_sec = 0;
-
-	if (next.tv_usec >= USEC_PER_SEC) {
-		next.tv_sec++;
-		next.tv_usec -= USEC_PER_SEC;
-	}
-	mod_timer(&sync_cmos_timer, jiffies + timeval_to_jiffies(&next));
-}
-
-void notify_arch_cmos_timer(void)
+int update_persistent_clock(struct timespec now)
 {
-	mod_timer(&sync_cmos_timer, jiffies + 1);
+	return set_rtc_mmss(now.tv_sec);
 }
 
 /* Kick start a stopped clock (procedure from the Sun NVRAM/hostid FAQ). */
diff -puN include/asm-i386/timer.h~ntp-move-the-cmos-update-code-into-ntpc include/asm-i386/timer.h
--- a/include/asm-i386/timer.h~ntp-move-the-cmos-update-code-into-ntpc
+++ a/include/asm-i386/timer.h
@@ -11,7 +11,6 @@ unsigned long native_calculate_cpu_khz(v
 
 extern int timer_ack;
 extern int no_timer_check;
-extern int no_sync_cmos_clock;
 extern int recalibrate_cpu_khz(void);
 
 #ifndef CONFIG_PARAVIRT
diff -puN include/linux/time.h~ntp-move-the-cmos-update-code-into-ntpc include/linux/time.h
--- a/include/linux/time.h~ntp-move-the-cmos-update-code-into-ntpc
+++ a/include/linux/time.h
@@ -4,6 +4,7 @@
 #include <linux/types.h>
 
 #ifdef __KERNEL__
+# include <linux/cache.h>
 # include <linux/seqlock.h>
 #endif
 
@@ -94,6 +95,8 @@ extern struct timespec wall_to_monotonic
 extern seqlock_t xtime_lock __attribute__((weak));
 
 extern unsigned long read_persistent_clock(void);
+extern int update_persistent_clock(struct timespec now);
+extern int no_sync_cmos_clock __read_mostly;
 void timekeeping_init(void);
 
 static inline unsigned long get_seconds(void)
diff -puN kernel/time/ntp.c~ntp-move-the-cmos-update-code-into-ntpc kernel/time/ntp.c
--- a/kernel/time/ntp.c~ntp-move-the-cmos-update-code-into-ntpc
+++ a/kernel/time/ntp.c
@@ -10,6 +10,7 @@
 
 #include <linux/mm.h>
 #include <linux/time.h>
+#include <linux/timer.h>
 #include <linux/timex.h>
 #include <linux/jiffies.h>
 #include <linux/hrtimer.h>
@@ -175,12 +176,64 @@ u64 current_tick_length(void)
 	return tick_length;
 }
 
+#ifdef CONFIG_GENERIC_CMOS_UPDATE
 
-void __attribute__ ((weak)) notify_arch_cmos_timer(void)
+/* Disable the cmos update - used by virtualization and embedded */
+int no_sync_cmos_clock  __read_mostly;
+
+static void sync_cmos_clock(unsigned long dummy);
+
+static DEFINE_TIMER(sync_cmos_timer, sync_cmos_clock, 0, 0);
+
+static void sync_cmos_clock(unsigned long dummy)
 {
-	return;
+	struct timespec now, next;
+	int fail = 1;
+
+	/*
+	 * If we have an externally synchronized Linux clock, then update
+	 * CMOS clock accordingly every ~11 minutes. Set_rtc_mmss() has to be
+	 * called as close as possible to 500 ms before the new second starts.
+	 * This code is run on a timer.  If the clock is set, that timer
+	 * may not expire at the correct time.  Thus, we adjust...
+	 */
+	if (!ntp_synced())
+		/*
+		 * Not synced, exit, do not restart a timer (if one is
+		 * running, let it run out).
+		 */
+		return;
+
+	getnstimeofday(&now);
+	if (abs(xtime.tv_nsec - (NSEC_PER_SEC / 2)) <= tick_nsec / 2)
+		fail = update_persistent_clock(now);
+
+	next.tv_nsec = (NSEC_PER_SEC / 2) - now.tv_nsec;
+	if (next.tv_nsec <= 0)
+		next.tv_nsec += NSEC_PER_SEC;
+
+	if (!fail)
+		next.tv_sec = 659;
+	else
+		next.tv_sec = 0;
+
+	if (next.tv_nsec >= NSEC_PER_SEC) {
+		next.tv_sec++;
+		next.tv_nsec -= NSEC_PER_SEC;
+	}
+	mod_timer(&sync_cmos_timer, jiffies + timespec_to_jiffies(&next));
 }
 
+static void notify_cmos_timer(void)
+{
+	if (no_sync_cmos_clock)
+		mod_timer(&sync_cmos_timer, jiffies + 1);
+}
+
+#else
+static inline void notify_cmos_timer(void) { }
+#endif
+
 /* adjtimex mainly allows reading (and writing, if superuser) of
  * kernel time-keeping variables. used by xntpd.
  */
@@ -345,6 +398,6 @@ leave:	if ((time_status & (STA_UNSYNC|ST
 	txc->stbcnt	   = 0;
 	write_sequnlock_irq(&xtime_lock);
 	do_gettimeofday(&txc->time);
-	notify_arch_cmos_timer();
+	notify_cmos_timer();
 	return(result);
 }
_

Patches currently in -mm which might be from tglx@linutronix.de are

git-acpi.patch
acpi-move-timer-broadcast-and-pmtimer-access-before-c3-arbiter-shutdown.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
acpi-remove-the-useless-ifdef-code.patch
x86_64-hpet-restore-vread.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-block-irq-balancing-for-timer.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
geode-mfgpt-clock-event-device-support.patch
whitespace-fixes-time-syscalls.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
