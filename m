From: akpm@osdl.org
Subject: + extend-next_timer_interrupt-to-use-a-reference-jiffie.patch added to -mm tree
Date: Wed, 24 Jan 2007 22:36:23 -0800
Message-ID: <200701250636.l0P6aN1t008331@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50838 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965642AbXAYGsc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 01:48:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, bunk@stusta.de, cotte@de.ibm.com, johnstul@us.ibm.com, mingo@elte.hu, zippel@linux-m68k.org


The patch titled
     Extend next_timer_interrupt() to use a reference jiffie
has been added to the -mm tree.  Its filename is
     extend-next_timer_interrupt-to-use-a-reference-jiffie.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Extend next_timer_interrupt() to use a reference jiffie
From: Thomas Gleixner <tglx@linutronix.de>

For CONFIG_NO_HZ we need to calculate the next timer wheel event based on a
given jiffie value.  Extend the existing code to allow the extra 'now'
argument.  Provide a compability function for the existing implementations to
call the function with now == jiffies.  (This also solves the racyness of the
original code vs.  jiffies changing during the iteration.)

No functional changes to existing users of this infrastructure.

[ remove WARN_ON() that triggered on s390, by Carsten Otte <cotte@de.ibm.com> ]
[ made new helper static, Adrian Bunk <bunk@stusta.de> ]

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/timer.h |   10 ++++++++++
 kernel/hrtimer.c      |    2 +-
 kernel/timer.c        |   14 +++++++++++---
 3 files changed, 22 insertions(+), 4 deletions(-)

diff -puN include/linux/timer.h~extend-next_timer_interrupt-to-use-a-reference-jiffie include/linux/timer.h
--- a/include/linux/timer.h~extend-next_timer_interrupt-to-use-a-reference-jiffie
+++ a/include/linux/timer.h
@@ -61,7 +61,17 @@ extern int del_timer(struct timer_list *
 extern int __mod_timer(struct timer_list *timer, unsigned long expires);
 extern int mod_timer(struct timer_list *timer, unsigned long expires);
 
+/*
+ * Return when the next timer-wheel timeout occurs (in absolute jiffies),
+ * locks the timer base:
+ */
 extern unsigned long next_timer_interrupt(void);
+/*
+ * Return when the next timer-wheel timeout occurs (in absolute jiffies),
+ * locks the timer base and does the comparison against the given
+ * jiffie.
+ */
+extern unsigned long get_next_timer_interrupt(unsigned long now);
 
 /**
  * add_timer - start a timer
diff -puN kernel/hrtimer.c~extend-next_timer_interrupt-to-use-a-reference-jiffie kernel/hrtimer.c
--- a/kernel/hrtimer.c~extend-next_timer_interrupt-to-use-a-reference-jiffie
+++ a/kernel/hrtimer.c
@@ -533,7 +533,7 @@ ktime_t hrtimer_get_remaining(const stru
 }
 EXPORT_SYMBOL_GPL(hrtimer_get_remaining);
 
-#ifdef CONFIG_NO_IDLE_HZ
+#if defined(CONFIG_NO_IDLE_HZ) || defined(CONFIG_NO_HZ)
 /**
  * hrtimer_get_next_event - get the time until next expiry event
  *
diff -puN kernel/timer.c~extend-next_timer_interrupt-to-use-a-reference-jiffie kernel/timer.c
--- a/kernel/timer.c~extend-next_timer_interrupt-to-use-a-reference-jiffie
+++ a/kernel/timer.c
@@ -591,7 +591,7 @@ static inline void __run_timers(tvec_bas
 	spin_unlock_irq(&base->lock);
 }
 
-#ifdef CONFIG_NO_IDLE_HZ
+#if defined(CONFIG_NO_IDLE_HZ) || defined(CONFIG_NO_HZ)
 /*
  * Find out when the next timer event is due to happen. This
  * is used on S/390 to stop all activity when a cpus is idle.
@@ -687,10 +687,10 @@ static unsigned long cmp_next_hrtimer_ev
 /**
  * next_timer_interrupt - return the jiffy of the next pending timer
  */
-unsigned long next_timer_interrupt(void)
+unsigned long get_next_timer_interrupt(unsigned long now)
 {
 	tvec_base_t *base = __get_cpu_var(tvec_bases);
-	unsigned long expires, now = jiffies;
+	unsigned long expires;
 
 	spin_lock(&base->lock);
 	expires = __next_timer_interrupt(base);
@@ -701,6 +701,14 @@ unsigned long next_timer_interrupt(void)
 
 	return cmp_next_hrtimer_event(now, expires);
 }
+
+#ifdef CONFIG_NO_IDLE_HZ
+unsigned long next_timer_interrupt(void)
+{
+	return get_next_timer_interrupt(jiffies);
+}
+#endif
+
 #endif
 
 /******************************************************************/
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
