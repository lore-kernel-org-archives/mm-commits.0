From: akpm@osdl.org
Subject: + gtod-persistent-clock-support.patch added to -mm tree
Date: Wed, 24 Jan 2007 22:35:49 -0800
Message-ID: <200701250635.l0P6Znlq008274@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50476 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965602AbXAYGjg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 01:39:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johnstul@us.ibm.com, bunk@stusta.de, mingo@elte.hu, tglx@linutronix.de, zippel@linux-m68k.org


The patch titled
     GTOD: persistent clock support
has been added to the -mm tree.  Its filename is
     gtod-persistent-clock-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: GTOD: persistent clock support
From: John Stultz <johnstul@us.ibm.com>

Persistent clock support: do proper timekeeping across suspend/resume.

[ cleanup from Adrian Bunk <bunk@stusta.de> ]

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/hrtimer.h |    3 +++
 include/linux/time.h    |    1 +
 kernel/hrtimer.c        |    8 ++++++++
 kernel/timer.c          |   37 ++++++++++++++++++++++++++++++++++++-
 4 files changed, 48 insertions(+), 1 deletion(-)

diff -puN include/linux/hrtimer.h~gtod-persistent-clock-support include/linux/hrtimer.h
--- a/include/linux/hrtimer.h~gtod-persistent-clock-support
+++ a/include/linux/hrtimer.h
@@ -146,6 +146,9 @@ extern void hrtimer_init_sleeper(struct 
 /* Soft interrupt function to run the hrtimer queues: */
 extern void hrtimer_run_queues(void);
 
+/* Resume notification */
+void hrtimer_notify_resume(void);
+
 /* Bootup initialization: */
 extern void __init hrtimers_init(void);
 
diff -puN include/linux/time.h~gtod-persistent-clock-support include/linux/time.h
--- a/include/linux/time.h~gtod-persistent-clock-support
+++ a/include/linux/time.h
@@ -92,6 +92,7 @@ extern struct timespec xtime;
 extern struct timespec wall_to_monotonic;
 extern seqlock_t xtime_lock __attribute__((weak));
 
+extern unsigned long read_persistent_clock(void);
 void timekeeping_init(void);
 
 static inline unsigned long get_seconds(void)
diff -puN kernel/hrtimer.c~gtod-persistent-clock-support kernel/hrtimer.c
--- a/kernel/hrtimer.c~gtod-persistent-clock-support
+++ a/kernel/hrtimer.c
@@ -292,6 +292,14 @@ static unsigned long ktime_divns(const k
 #endif /* BITS_PER_LONG >= 64 */
 
 /*
+ * Timekeeping resumed notification
+ */
+void hrtimer_notify_resume(void)
+{
+	clock_was_set();
+}
+
+/*
  * Counterpart to lock_timer_base above:
  */
 static inline
diff -puN kernel/timer.c~gtod-persistent-clock-support kernel/timer.c
--- a/kernel/timer.c~gtod-persistent-clock-support
+++ a/kernel/timer.c
@@ -878,12 +878,27 @@ int timekeeping_is_continuous(void)
 	return ret;
 }
 
+/**
+ * read_persistent_clock -  Return time in seconds from the persistent clock.
+ *
+ * Weak dummy function for arches that do not yet support it.
+ * Returns seconds from epoch using the battery backed persistent clock.
+ * Returns zero if unsupported.
+ *
+ *  XXX - Do be sure to remove it once all arches implement it.
+ */
+unsigned long __attribute__((weak)) read_persistent_clock(void)
+{
+	return 0;
+}
+
 /*
  * timekeeping_init - Initializes the clocksource and common timekeeping values
  */
 void __init timekeeping_init(void)
 {
 	unsigned long flags;
+	unsigned long sec = read_persistent_clock();
 
 	write_seqlock_irqsave(&xtime_lock, flags);
 
@@ -893,11 +908,20 @@ void __init timekeeping_init(void)
 	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
 	clock->cycle_last = clocksource_read(clock);
 
+	xtime.tv_sec = sec;
+	xtime.tv_nsec = 0;
+	set_normalized_timespec(&wall_to_monotonic,
+		-xtime.tv_sec, -xtime.tv_nsec);
+
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 }
 
 
+/* flag for if timekeeping is suspended */
 static int timekeeping_suspended;
+/* time in seconds when suspend began */
+static unsigned long timekeeping_suspend_time;
+
 /**
  * timekeeping_resume - Resumes the generic timekeeping subsystem.
  * @dev:	unused
@@ -909,13 +933,23 @@ static int timekeeping_suspended;
 static int timekeeping_resume(struct sys_device *dev)
 {
 	unsigned long flags;
+	unsigned long now = read_persistent_clock();
 
 	write_seqlock_irqsave(&xtime_lock, flags);
-	/* restart the last cycle value */
+
+	if (now && (now > timekeeping_suspend_time)) {
+		unsigned long sleep_length = now - timekeeping_suspend_time;
+		xtime.tv_sec += sleep_length;
+		jiffies_64 += (u64)sleep_length * HZ;
+	}
+	/* re-base the last cycle value */
 	clock->cycle_last = clocksource_read(clock);
 	clock->error = 0;
 	timekeeping_suspended = 0;
 	write_sequnlock_irqrestore(&xtime_lock, flags);
+
+	hrtimer_notify_resume();
+
 	return 0;
 }
 
@@ -925,6 +959,7 @@ static int timekeeping_suspend(struct sy
 
 	write_seqlock_irqsave(&xtime_lock, flags);
 	timekeeping_suspended = 1;
+	timekeeping_suspend_time = read_persistent_clock();
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 	return 0;
 }
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

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
i386-enable-dynticks-in-kconfig.patch
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
profile-likely-unlikely-macros-x86_64-fix.patch
