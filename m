From: akpm@osdl.org
Subject: - make-johns-stuff-pretend-to-compile.patch removed from -mm tree
Date: Wed, 24 Jan 2007 23:28:37 -0800
Message-ID: <200701250728.l0P7ScnA009177@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51678 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965668AbXAYH3P (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 02:29:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, johnstul@us.ibm.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     make John's stuff pretend to compile.
has been removed from the -mm tree.  Its filename was
     make-johns-stuff-pretend-to-compile.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: make John's stuff pretend to compile.
From: Thomas Gleixner <tglx@linutronix.de>

Attempt to recover from my attempt to recover John's stuff from new
gtod/dyntick implementation.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/kernel/hpet.c |    2 +-
 arch/x86_64/kernel/time.c |   16 ----------------
 arch/x86_64/kernel/tsc.c  |   36 +++++++++++++-----------------------
 x86_64/kernel/tsc_sync.c  |    0 
 4 files changed, 14 insertions(+), 40 deletions(-)

diff -puN arch/x86_64/kernel/hpet.c~make-johns-stuff-pretend-to-compile arch/x86_64/kernel/hpet.c
--- a/arch/x86_64/kernel/hpet.c~make-johns-stuff-pretend-to-compile
+++ a/arch/x86_64/kernel/hpet.c
@@ -469,7 +469,7 @@ struct clocksource clocksource_hpet = {
 	.mask		= (cycle_t)HPET_MASK,
 	.mult		= 0, /* set below */
 	.shift		= HPET_SHIFT,
-	.is_continuous	= 1,
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 	.vread		= vread_hpet,
 };
 
diff -puN arch/x86_64/kernel/tsc.c~make-johns-stuff-pretend-to-compile arch/x86_64/kernel/tsc.c
--- a/arch/x86_64/kernel/tsc.c~make-johns-stuff-pretend-to-compile
+++ a/arch/x86_64/kernel/tsc.c
@@ -46,13 +46,6 @@ static inline int check_tsc_unstable(voi
 {
 	return tsc_unstable;
 }
-
-void mark_tsc_unstable(void)
-{
-	tsc_unstable = 1;
-}
-EXPORT_SYMBOL_GPL(mark_tsc_unstable);
-
 #ifdef CONFIG_CPU_FREQ
 
 /* Frequency scaling support. Adjust the TSC based timer when the cpu frequency
@@ -187,9 +180,6 @@ __setup("notsc", notsc_setup);
 
 
 /* clock source code: */
-
-static int tsc_update_callback(void);
-
 static cycle_t read_tsc(void)
 {
 	cycle_t ret = (cycle_t)get_cycles_sync();
@@ -206,26 +196,26 @@ static struct clocksource clocksource_ts
 	.name			= "tsc",
 	.rating			= 300,
 	.read			= read_tsc,
-	.mask			= (cycle_t)-1,
+	.mask			= CLOCKSOURCE_MASK(64),
 	.mult			= 0, /* to be set */
 	.shift			= 22,
-	.update_callback	= tsc_update_callback,
-	.is_continuous		= 1,
+	.flags			= CLOCK_SOURCE_IS_CONTINUOUS |
+				  CLOCK_SOURCE_MUST_VERIFY,
 	.vread			= vread_tsc,
 };
 
-static int tsc_update_callback(void)
+void mark_tsc_unstable(void)
 {
-	int change = 0;
-
-	/* check to see if we should switch to the safe clocksource: */
-	if (clocksource_tsc.rating != 50 && check_tsc_unstable()) {
-		clocksource_tsc.rating = 50;
-		clocksource_reselect();
-		change = 1;
+	if (!tsc_unstable) {
+		tsc_unstable = 1;
+		/* Change only the rating, when not registered */
+		if (clocksource_tsc.mult)
+			clocksource_change_rating(&clocksource_tsc, 0);
+		else
+			clocksource_tsc.rating = 0;
 	}
-	return change;
 }
+EXPORT_SYMBOL_GPL(mark_tsc_unstable);
 
 static int __init init_tsc_clocksource(void)
 {
@@ -233,7 +223,7 @@ static int __init init_tsc_clocksource(v
 		clocksource_tsc.mult = clocksource_khz2mult(cpu_khz,
 							clocksource_tsc.shift);
 		if (check_tsc_unstable())
-			clocksource_tsc.rating = 50;
+			clocksource_tsc.rating = 0;
 
 		return clocksource_register(&clocksource_tsc);
 	}
diff -puN arch/x86_64/kernel/time.c~make-johns-stuff-pretend-to-compile arch/x86_64/kernel/time.c
--- a/arch/x86_64/kernel/time.c~make-johns-stuff-pretend-to-compile
+++ a/arch/x86_64/kernel/time.c
@@ -306,14 +306,6 @@ void __init pit_stop_interrupt(void)
 	__pit_init(0, 0x30); /* mode 0 */
 }
 
-static int tsc_unstable = 0;
-
-void mark_tsc_unstable(void)
-{
-	tsc_unstable = 1;
-}
-EXPORT_SYMBOL_GPL(mark_tsc_unstable);
-
 void __init stop_timer_interrupt(void)
 {
 	char *name;
@@ -441,11 +433,3 @@ static int time_init_device(void)
 }
 
 device_initcall(time_init_device);
-
-int __init notsc_setup(char *s)
-{
-	notsc = 1;
-	return 1;
-}
-
-__setup("notsc", notsc_setup);
diff -puN arch/x86_64/kernel/tsc_sync.c~make-johns-stuff-pretend-to-compile arch/x86_64/kernel/tsc_sync.c
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
make-johns-stuff-pretend-to-compile.patch
make-good_sigevent-non-static.patch
aio-completion-signal-notification.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-2.patch
scheduled-removal-of-sa_xxx-interrupt-flags.patch
