From: akpm@osdl.org
Subject: + clocksource-add-verification-watchdog-helper.patch added to -mm tree
Date: Wed, 24 Jan 2007 22:36:13 -0800
Message-ID: <200701250636.l0P6aDIc008312@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50286 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965556AbXAYGgt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 01:36:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, johnstul@us.ibm.com, mingo@elte.hu, zippel@linux-m68k.org


The patch titled
     clocksource: Add verification (watchdog) helper
has been added to the -mm tree.  Its filename is
     clocksource-add-verification-watchdog-helper.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: clocksource: Add verification (watchdog) helper
From: Thomas Gleixner <tglx@linutronix.de>

The TSC needs to be verified against another clocksource.  Instead of using
hardwired assumptions of available hardware, provide a generic verification
mechanism.  The verification uses the best available clocksource and handles
the usability for high resolution timers / dynticks of the clocksource which
needs to be verified.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/Kconfig           |    4 +
 arch/i386/kernel/tsc.c      |   49 -------------
 include/linux/clocksource.h |   15 +++-
 kernel/time/clocksource.c   |  125 ++++++++++++++++++++++++++++++++--
 kernel/timer.c              |   46 ++++++------
 5 files changed, 161 insertions(+), 78 deletions(-)

diff -puN arch/i386/Kconfig~clocksource-add-verification-watchdog-helper arch/i386/Kconfig
--- a/arch/i386/Kconfig~clocksource-add-verification-watchdog-helper
+++ a/arch/i386/Kconfig
@@ -18,6 +18,10 @@ config GENERIC_TIME
 	bool
 	default y
 
+config CLOCKSOURCE_WATCHDOG
+	bool
+	default y
+
 config LOCKDEP_SUPPORT
 	bool
 	default y
diff -puN arch/i386/kernel/tsc.c~clocksource-add-verification-watchdog-helper arch/i386/kernel/tsc.c
--- a/arch/i386/kernel/tsc.c~clocksource-add-verification-watchdog-helper
+++ a/arch/i386/kernel/tsc.c
@@ -344,49 +344,6 @@ static struct dmi_system_id __initdata b
 	 {}
 };
 
-#define TSC_FREQ_CHECK_INTERVAL (10*MSEC_PER_SEC) /* 10sec in MS */
-static struct timer_list verify_tsc_freq_timer;
-
-/* XXX - Probably should add locking */
-static void verify_tsc_freq(unsigned long unused)
-{
-	static u64 last_tsc;
-	static unsigned long last_jiffies;
-
-	u64 now_tsc, interval_tsc;
-	unsigned long now_jiffies, interval_jiffies;
-
-
-	if (check_tsc_unstable())
-		return;
-
-	rdtscll(now_tsc);
-	now_jiffies = jiffies;
-
-	if (!last_jiffies) {
-		goto out;
-	}
-
-	interval_jiffies = now_jiffies - last_jiffies;
-	interval_tsc = now_tsc - last_tsc;
-	interval_tsc *= HZ;
-	do_div(interval_tsc, cpu_khz*1000);
-
-	if (interval_tsc < (interval_jiffies * 3 / 4)) {
-		printk("TSC appears to be running slowly. "
-			"Marking it as unstable\n");
-		mark_tsc_unstable();
-		return;
-	}
-
-out:
-	last_tsc = now_tsc;
-	last_jiffies = now_jiffies;
-	/* set us up to go off on the next interval: */
-	mod_timer(&verify_tsc_freq_timer,
-		jiffies + msecs_to_jiffies(TSC_FREQ_CHECK_INTERVAL));
-}
-
 /*
  * Make an educated guess if the TSC is trustworthy and synchronized
  * over all CPUs.
@@ -424,12 +381,6 @@ static int __init init_tsc_clocksource(v
 			clocksource_tsc.flags &= ~CLOCK_SOURCE_IS_CONTINUOUS;
 		}
 
-		init_timer(&verify_tsc_freq_timer);
-		verify_tsc_freq_timer.function = verify_tsc_freq;
-		verify_tsc_freq_timer.expires =
-			jiffies + msecs_to_jiffies(TSC_FREQ_CHECK_INTERVAL);
-		add_timer(&verify_tsc_freq_timer);
-
 		return clocksource_register(&clocksource_tsc);
 	}
 
diff -puN include/linux/clocksource.h~clocksource-add-verification-watchdog-helper include/linux/clocksource.h
--- a/include/linux/clocksource.h~clocksource-add-verification-watchdog-helper
+++ a/include/linux/clocksource.h
@@ -12,11 +12,13 @@
 #include <linux/timex.h>
 #include <linux/time.h>
 #include <linux/list.h>
+#include <linux/timer.h>
 #include <asm/div64.h>
 #include <asm/io.h>
 
 /* clocksource cycle base type */
 typedef u64 cycle_t;
+struct clocksource;
 
 /**
  * struct clocksource - hardware abstraction for a free running counter
@@ -62,13 +64,22 @@ struct clocksource {
 	cycle_t cycle_last, cycle_interval;
 	u64 xtime_nsec, xtime_interval;
 	s64 error;
+
+#ifdef CONFIG_CLOCKSOURCE_WATCHDOG
+	/* Watchdog related data, used by the framework */
+	struct list_head wd_list;
+	cycle_t wd_last;
+#endif
 };
 
 /*
  * Clock source flags bits::
  */
-#define CLOCK_SOURCE_IS_CONTINUOUS	0x01
-#define CLOCK_SOURCE_MUST_VERIFY	0x02
+#define CLOCK_SOURCE_IS_CONTINUOUS		0x01
+#define CLOCK_SOURCE_MUST_VERIFY		0x02
+
+#define CLOCK_SOURCE_WATCHDOG			0x10
+#define CLOCK_SOURCE_VALID_FOR_HRES		0x20
 
 /* simplify initialization of mask field */
 #define CLOCKSOURCE_MASK(bits) (cycle_t)(bits<64 ? ((1ULL<<bits)-1) : -1)
diff -puN kernel/time/clocksource.c~clocksource-add-verification-watchdog-helper kernel/time/clocksource.c
--- a/kernel/time/clocksource.c~clocksource-add-verification-watchdog-helper
+++ a/kernel/time/clocksource.c
@@ -62,9 +62,115 @@ static int __init clocksource_done_booti
 	finished_booting = 1;
 	return 0;
 }
-
 late_initcall(clocksource_done_booting);
 
+#ifdef CONFIG_CLOCKSOURCE_WATCHDOG
+static LIST_HEAD(watchdog_list);
+static struct clocksource *watchdog;
+static struct timer_list watchdog_timer;
+static DEFINE_SPINLOCK(watchdog_lock);
+static cycle_t watchdog_last;
+/*
+ * Interval: 0.5sec Treshold: 0.0625s
+ */
+#define WATCHDOG_INTERVAL (HZ >> 1)
+#define WATCHDOG_TRESHOLD (NSEC_PER_SEC >> 4)
+
+static void clocksource_ratewd(struct clocksource *cs, int64_t delta)
+{
+	if (delta > -WATCHDOG_TRESHOLD && delta < WATCHDOG_TRESHOLD)
+		return;
+
+	printk(KERN_WARNING "Clocksource %s unstable (delta = %Ld ns)\n",
+	       cs->name, delta);
+	cs->flags &= ~(CLOCK_SOURCE_VALID_FOR_HRES | CLOCK_SOURCE_WATCHDOG);
+	clocksource_change_rating(cs, 0);
+	cs->flags &= ~CLOCK_SOURCE_WATCHDOG;
+	list_del(&cs->wd_list);
+}
+
+static void clocksource_watchdog(unsigned long data)
+{
+	struct clocksource *cs, *tmp;
+	cycle_t csnow, wdnow;
+	int64_t wd_nsec, cs_nsec;
+
+	spin_lock(&watchdog_lock);
+
+	wdnow = watchdog->read();
+	wd_nsec = cyc2ns(watchdog, (wdnow - watchdog_last) & watchdog->mask);
+	watchdog_last = wdnow;
+
+	list_for_each_entry_safe(cs, tmp, &watchdog_list, wd_list) {
+		csnow = cs->read();
+		/* Initialized ? */
+		if (!(cs->flags & CLOCK_SOURCE_WATCHDOG)) {
+			if ((cs->flags & CLOCK_SOURCE_IS_CONTINUOUS) &&
+			    (watchdog->flags & CLOCK_SOURCE_IS_CONTINUOUS))
+				cs->flags |= CLOCK_SOURCE_VALID_FOR_HRES;
+			cs->flags |= CLOCK_SOURCE_WATCHDOG;
+			cs->wd_last = csnow;
+		} else {
+			cs_nsec = cyc2ns(cs, (csnow - cs->wd_last) & cs->mask);
+			cs->wd_last = csnow;
+			/* Check the delta. Might remove from the list ! */
+			clocksource_ratewd(cs, cs_nsec - wd_nsec);
+		}
+	}
+
+	if (!list_empty(&watchdog_list)) {
+		__mod_timer(&watchdog_timer,
+			    watchdog_timer.expires + WATCHDOG_INTERVAL);
+	}
+	spin_unlock(&watchdog_lock);
+}
+static void clocksource_check_watchdog(struct clocksource *cs)
+{
+	struct clocksource *cse;
+	unsigned long flags;
+
+	spin_lock_irqsave(&watchdog_lock, flags);
+	if (cs->flags & CLOCK_SOURCE_MUST_VERIFY) {
+		int started = !list_empty(&watchdog_list);
+
+		list_add(&cs->wd_list, &watchdog_list);
+		if (!started && watchdog) {
+			watchdog_last = watchdog->read();
+			watchdog_timer.expires = jiffies + WATCHDOG_INTERVAL;
+			add_timer(&watchdog_timer);
+		}
+	} else if (cs->flags & CLOCK_SOURCE_IS_CONTINUOUS) {
+			cs->flags |= CLOCK_SOURCE_VALID_FOR_HRES;
+
+		if (!watchdog || cs->rating > watchdog->rating) {
+			if (watchdog)
+				del_timer(&watchdog_timer);
+			watchdog = cs;
+			init_timer(&watchdog_timer);
+			watchdog_timer.function = clocksource_watchdog;
+
+			/* Reset watchdog cycles */
+			list_for_each_entry(cse, &watchdog_list, wd_list)
+				cse->flags &= ~CLOCK_SOURCE_WATCHDOG;
+			/* Start if list is not empty */
+			if (!list_empty(&watchdog_list)) {
+				watchdog_last = watchdog->read();
+				watchdog_timer.expires =
+					jiffies + WATCHDOG_INTERVAL;
+				add_timer(&watchdog_timer);
+			}
+		}
+	}
+	spin_unlock_irqrestore(&watchdog_lock, flags);
+}
+#else
+static void clocksource_check_watchdog(struct clocksource *cs)
+{
+	if (cs->flags & CLOCK_SOURCE_IS_CONTINUOUS)
+		cs->flags |= CLOCK_SOURCE_VALID_FOR_HRES;
+}
+#endif
+
 /**
  * clocksource_get_next - Returns the selected clocksource
  *
@@ -93,13 +199,21 @@ struct clocksource *clocksource_get_next
  */
 static struct clocksource *select_clocksource(void)
 {
+	struct clocksource *next;
+
 	if (list_empty(&clocksource_list))
 		return NULL;
 
 	if (clocksource_override)
-		return clocksource_override;
+		next = clocksource_override;
+	else
+		next = list_entry(clocksource_list.next, struct clocksource,
+				  list);
 
-	return list_entry(clocksource_list.next, struct clocksource, list);
+	if (next == curr_clocksource)
+		return NULL;
+
+	return next;
 }
 
 /*
@@ -137,13 +251,15 @@ static int clocksource_enqueue(struct cl
 int clocksource_register(struct clocksource *c)
 {
 	unsigned long flags;
-	int ret = 0;
+	int ret;
 
 	spin_lock_irqsave(&clocksource_lock, flags);
 	ret = clocksource_enqueue(c);
 	if (!ret)
 		next_clocksource = select_clocksource();
 	spin_unlock_irqrestore(&clocksource_lock, flags);
+	if (!ret)
+		clocksource_check_watchdog(c);
 	return ret;
 }
 EXPORT_SYMBOL(clocksource_register);
@@ -158,6 +274,7 @@ void clocksource_change_rating(struct cl
 
 	spin_lock_irqsave(&clocksource_lock, flags);
 	list_del(&cs->list);
+	cs->rating = rating;
 	clocksource_enqueue(cs);
 	next_clocksource = select_clocksource();
 	spin_unlock_irqrestore(&clocksource_lock, flags);
diff -puN kernel/timer.c~clocksource-add-verification-watchdog-helper kernel/timer.c
--- a/kernel/timer.c~clocksource-add-verification-watchdog-helper
+++ a/kernel/timer.c
@@ -832,30 +832,34 @@ EXPORT_SYMBOL(do_settimeofday);
  *
  * Accumulates current time interval and initializes new clocksource
  */
-static int change_clocksource(void)
+static void change_clocksource(void)
 {
 	struct clocksource *new;
 	cycle_t now;
 	u64 nsec;
+
 	new = clocksource_get_next();
-	if (clock != new) {
-		now = clocksource_read(new);
-		nsec =  __get_nsec_offset();
-		timespec_add_ns(&xtime, nsec);
-
-		clock = new;
-		clock->cycle_last = now;
-		printk(KERN_INFO "Time: %s clocksource has been installed.\n",
-		       clock->name);
-		return 1;
-	}
-	return 0;
+
+	if (clock == new)
+		return;
+
+	now = clocksource_read(new);
+	nsec =  __get_nsec_offset();
+	timespec_add_ns(&xtime, nsec);
+
+	clock = new;
+	clock->cycle_last = now;
+
+	clock->error = 0;
+	clock->xtime_nsec = 0;
+	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
+
+	hrtimer_clock_notify();
+	printk(KERN_INFO "Time: %s clocksource has been installed.\n",
+	       clock->name);
 }
 #else
-static inline int change_clocksource(void)
-{
-	return 0;
-}
+static inline void change_clocksource(void) { }
 #endif
 
 /**
@@ -869,7 +873,7 @@ int timekeeping_is_continuous(void)
 	do {
 		seq = read_seqbegin(&xtime_lock);
 
-		ret = clock->flags & CLOCK_SOURCE_IS_CONTINUOUS;
+		ret = clock->flags & CLOCK_SOURCE_VALID_FOR_HRES;
 
 	} while (read_seqretry(&xtime_lock, seq));
 
@@ -1122,11 +1126,7 @@ static void update_wall_time(void)
 	clock->xtime_nsec -= (s64)xtime.tv_nsec << clock->shift;
 
 	/* check to see if there is a new clocksource to use */
-	if (change_clocksource()) {
-		clock->error = 0;
-		clock->xtime_nsec = 0;
-		clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
-	}
+	change_clocksource();
 }
 
 /*
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-block.patch
use-cycle_t-instead-of-u64-in-struct-time_interpolator.patch
proc-remove-useless-and-buggy-nlink-settings.patch
add-irq-flag-to-disable-balancing-for-an-interrupt.patch
add-a-functions-to-handle-interrupt-affinity-setting.patch
hz-free-ntp.patch
uninline-jiffiesh-functions.patch
fix-multiple-conversion-bugs-in-msecs_to_jiffies.patch
fix-timeout-overflow-with-jiffies.patch
gtod-persistent-clock-support.patch
i386-use-gtod-persistent-clock-support.patch
i386-remove-useless-code-in-tscc.patch
simplify-the-registration-of-clocksources.patch
x86-rewrite-smp-tsc-sync-code.patch
clocksource-replace-is_continuous-by-a-flag-field.patch
clocksource-replace-is_continuous-by-a-flag-field-fix.patch
clocksource-fixup-is_continous-changes-on-arm.patch
clocksource-fixup-is_continous-changes-on-avr32.patch
clocksource-fixup-is_continous-changes-on-s390.patch
clocksource-fixup-is_continous-changes-on-mips.patch
clocksource-remove-the-update-callback.patch
clocksource-add-verification-watchdog-helper.patch
clocksource-add-verification-watchdog-helper-fix.patch
mark-tsc-on-geodelx-reliable.patch
uninline-irq_enter.patch
fix-cascade-lookup-of-next_timer_interrupt.patch
extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-namespace-and-enum-cleanup-vs-git-input.patch
hrtimers-cleanup-locking.patch
hrtimers-add-state-tracking.patch
hrtimers-clean-up-callback-tracking.patch
hrtimers-move-and-add-documentation.patch
acpi-fix-missing-include-for-up.patch
acpi-keep-track-of-timer-broadcasting.patch
allow-early-access-to-the-power-management-timer.patch
i386-apic-clean-up-the-apic-code.patch
clockevents-add-core-functionality.patch
tick-management-core-functionality.patch
tick-management-broadcast-functionality.patch
tick-management-dyntick--highres-functionality.patch
clockevents-i383-drivers.patch
i386-rework-local-apic-timer-calibration.patch
i386-prepare-for-dyntick.patch
i386-prepare-nmi-watchdog-for-dynticks.patch
hrtimers-add-high-resolution-timer-support.patch
hrtimers-prevent-possible-itimer-dos.patch
add-debugging-feature-proc-timer_stat.patch
add-debugging-feature-proc-timer_list.patch
add-sysrq-q-to-print-timer_list-debug-info.patch
generic-vsyscall-gtod-support-for-generic_time.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
time-x86_64-hpet_address-cleanup.patch
revert-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-split-x86_64-kernel-timec-up.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-fix.patch
reapply-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-convert-x86_64-to-use-generic_time.patch
time-x86_64-convert-x86_64-to-use-generic_time-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
make-good_sigevent-non-static.patch
aio-completion-signal-notification.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-2.patch
scheduled-removal-of-sa_xxx-interrupt-flags.patch
