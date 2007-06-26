From: akpm@linux-foundation.org
Subject: + ntp-move-the-cmos-update-code-into-ntpc.patch added to -mm tree
Date: Mon, 25 Jun 2007 17:07:44 -0700
Message-ID: <200706260007.l5Q07iUk014433@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39907 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752962AbXFZAIh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 20:08:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, chrisw@sous-sol.org, davem@davemloft.net, johnstul@us.ibm.com, mingo@elte.hu, zippel@linux-m68k.org


The patch titled
     NTP: move the cmos update code into ntp.c
has been added to the -mm tree.  Its filename is
     ntp-move-the-cmos-update-code-into-ntpc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: NTP: move the cmos update code into ntp.c
From: Thomas Gleixner <tglx@linutronix.de>

i386 and sparc64 have the identical code to update the cmos clock.  Move it
into kernel/time/ntp.c as there are other architectures coming along with the
same requirements.

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
 include/linux/time.h       |    2 +
 kernel/time/ntp.c          |   59 +++++++++++++++++++++++++++++++++--
 7 files changed, 70 insertions(+), 103 deletions(-)

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
@@ -12,7 +12,6 @@ unsigned long native_calculate_cpu_khz(v
 
 extern int timer_ack;
 extern int no_timer_check;
-extern int no_sync_cmos_clock;
 extern int recalibrate_cpu_khz(void);
 
 #ifndef CONFIG_PARAVIRT
diff -puN include/linux/time.h~ntp-move-the-cmos-update-code-into-ntpc include/linux/time.h
--- a/include/linux/time.h~ntp-move-the-cmos-update-code-into-ntpc
+++ a/include/linux/time.h
@@ -93,6 +93,8 @@ extern struct timespec wall_to_monotonic
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
@@ -187,12 +188,64 @@ u64 current_tick_length(void)
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
@@ -357,6 +410,6 @@ leave:	if ((time_status & (STA_UNSYNC|ST
 	txc->stbcnt	   = 0;
 	write_sequnlock_irq(&xtime_lock);
 	do_gettimeofday(&txc->time);
-	notify_arch_cmos_timer();
+	notify_cmos_timer();
 	return(result);
 }
_

Patches currently in -mm which might be from tglx@linutronix.de are

git-acpi-add-exports.patch
git-arm.patch
i386-hpet-check-if-the-counter-works.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
acpi-move-timer-broadcast-and-pmtimer-access-before-c3-arbiter-shutdown.patch
timekeeping-fixup-shadow-variable-argument.patch
timerc-cleanup-recently-introduced-whitespace-damage.patch
clockevents-remove-prototypes-of-removed-functions.patch
clockevents-fix-resume-logic.patch
clockevents-fix-device-replacement.patch
tick-management-spread-timer-interrupt.patch
highres-improve-debug-output.patch
hrtimer-speedup-hrtimer_enqueue.patch
pcspkr-use-the-global-pit-lock.patch
ntp-move-the-cmos-update-code-into-ntpc.patch
i386-pit-stop-only-when-in-periodic-or-oneshot-mode.patch
i386-remove-volatile-in-apicc.patch
i386-hpet-assumes-boot-cpu-is-0.patch
i386-move-pit-function-declarations-and-constants-to-correct-header-file.patch
x86_64-untangle-asm-hpeth-from-asm-timexh.patch
x86_64-use-generic-cmos-update.patch
x86_64-remove-dead-code-and-other-janitor-work-in-tscc.patch
x86_64-fix-apic-typo.patch
x86_64-convert-to-cleckevents.patch
acpi-remove-the-useless-ifdef-code.patch
x86_64-hpet-restore-vread.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-block-irq-balancing-for-timer.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
remove-clockevents_releaserequest_device.patch
add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats.patch
improve-behaviour-of-spurious-irq-detect.patch
improve-behaviour-of-spurious-irq-detect-fix.patch
sys_time-speedup.patch
lguest-the-host-code.patch
