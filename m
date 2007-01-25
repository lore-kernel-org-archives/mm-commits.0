From: akpm@osdl.org
Subject: + clocksource-replace-is_continuous-by-a-flag-field.patch added to -mm tree
Date: Wed, 24 Jan 2007 22:35:59 -0800
Message-ID: <200701250635.l0P6ZxKq008289@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50241 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965553AbXAYGgd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 01:36:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, johnstul@us.ibm.com, mingo@elte.hu, zippel@linux-m68k.org


The patch titled
     clocksource: replace is_continuous by a flag field
has been added to the -mm tree.  Its filename is
     clocksource-replace-is_continuous-by-a-flag-field.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: clocksource: replace is_continuous by a flag field
From: Thomas Gleixner <tglx@linutronix.de>

Using a flag filed allows to encode more than one information into a variable.
 Preparatory patch for the generic clocksource verification.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/hpet.c          |    2 +-
 arch/i386/kernel/tsc.c           |    7 +++++--
 drivers/clocksource/acpi_pm.c    |    3 ++-
 drivers/clocksource/cyclone.c    |    2 +-
 drivers/clocksource/scx200_hrt.c |    2 +-
 include/linux/clocksource.h      |   10 ++++++++--
 kernel/time/jiffies.c            |    1 -
 kernel/timer.c                   |    2 +-
 8 files changed, 19 insertions(+), 10 deletions(-)

diff -puN arch/i386/kernel/hpet.c~clocksource-replace-is_continuous-by-a-flag-field arch/i386/kernel/hpet.c
--- a/arch/i386/kernel/hpet.c~clocksource-replace-is_continuous-by-a-flag-field
+++ a/arch/i386/kernel/hpet.c
@@ -26,7 +26,7 @@ static struct clocksource clocksource_hp
 	.mask		= HPET_MASK,
 	.mult		= 0, /* set below */
 	.shift		= HPET_SHIFT,
-	.is_continuous	= 1,
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
 static int __init init_hpet_clocksource(void)
diff -puN arch/i386/kernel/tsc.c~clocksource-replace-is_continuous-by-a-flag-field arch/i386/kernel/tsc.c
--- a/arch/i386/kernel/tsc.c~clocksource-replace-is_continuous-by-a-flag-field
+++ a/arch/i386/kernel/tsc.c
@@ -314,7 +314,8 @@ static struct clocksource clocksource_ts
 	.mult			= 0, /* to be set */
 	.shift			= 22,
 	.update_callback	= tsc_update_callback,
-	.is_continuous		= 1,
+	.flags			= CLOCK_SOURCE_IS_CONTINUOUS |
+				  CLOCK_SOURCE_MUST_VERIFY,
 };
 
 static int tsc_update_callback(void)
@@ -435,8 +436,10 @@ static int __init init_tsc_clocksource(v
 		clocksource_tsc.mult = clocksource_khz2mult(current_tsc_khz,
 							clocksource_tsc.shift);
 		/* lower the rating if we already know its unstable: */
-		if (check_tsc_unstable())
+		if (check_tsc_unstable()) {
 			clocksource_tsc.rating = 0;
+			clocksource_tsc.flags &= ~CLOCK_SOURCE_IS_CONTINUOUS;
+		}
 
 		init_timer(&verify_tsc_freq_timer);
 		verify_tsc_freq_timer.function = verify_tsc_freq;
diff -puN drivers/clocksource/acpi_pm.c~clocksource-replace-is_continuous-by-a-flag-field drivers/clocksource/acpi_pm.c
--- a/drivers/clocksource/acpi_pm.c~clocksource-replace-is_continuous-by-a-flag-field
+++ a/drivers/clocksource/acpi_pm.c
@@ -72,7 +72,8 @@ static struct clocksource clocksource_ac
 	.mask		= (cycle_t)ACPI_PM_MASK,
 	.mult		= 0, /*to be caluclated*/
 	.shift		= 22,
-	.is_continuous	= 1,
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+
 };
 
 
diff -puN drivers/clocksource/cyclone.c~clocksource-replace-is_continuous-by-a-flag-field drivers/clocksource/cyclone.c
--- a/drivers/clocksource/cyclone.c~clocksource-replace-is_continuous-by-a-flag-field
+++ a/drivers/clocksource/cyclone.c
@@ -31,7 +31,7 @@ static struct clocksource clocksource_cy
 	.mask		= CYCLONE_TIMER_MASK,
 	.mult		= 10,
 	.shift		= 0,
-	.is_continuous	= 1,
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
 static int __init init_cyclone_clocksource(void)
diff -puN drivers/clocksource/scx200_hrt.c~clocksource-replace-is_continuous-by-a-flag-field drivers/clocksource/scx200_hrt.c
--- a/drivers/clocksource/scx200_hrt.c~clocksource-replace-is_continuous-by-a-flag-field
+++ a/drivers/clocksource/scx200_hrt.c
@@ -57,7 +57,7 @@ static struct clocksource cs_hrt = {
 	.rating		= 250,
 	.read		= read_hrt,
 	.mask		= CLOCKSOURCE_MASK(32),
-	.is_continuous	= 1,
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 	/* mult, shift are set based on mhz27 flag */
 };
 
diff -puN include/linux/clocksource.h~clocksource-replace-is_continuous-by-a-flag-field include/linux/clocksource.h
--- a/include/linux/clocksource.h~clocksource-replace-is_continuous-by-a-flag-field
+++ a/include/linux/clocksource.h
@@ -45,7 +45,7 @@ typedef u64 cycle_t;
  * @mult:		cycle to nanosecond multiplier
  * @shift:		cycle to nanosecond divisor (power of two)
  * @update_callback:	called when safe to alter clocksource values
- * @is_continuous:	defines if clocksource is free-running.
+ * @flags:		flags describing special properties
  * @cycle_interval:	Used internally by timekeeping core, please ignore.
  * @xtime_interval:	Used internally by timekeeping core, please ignore.
  */
@@ -58,7 +58,7 @@ struct clocksource {
 	u32 mult;
 	u32 shift;
 	int (*update_callback)(void);
-	int is_continuous;
+	unsigned long flags;
 
 	/* timekeeping specific data, ignore */
 	cycle_t cycle_last, cycle_interval;
@@ -66,6 +66,12 @@ struct clocksource {
 	s64 error;
 };
 
+/*
+ * Clock source flags bits::
+ */
+#define CLOCK_SOURCE_IS_CONTINUOUS	0x01
+#define CLOCK_SOURCE_MUST_VERIFY	0x02
+
 /* simplify initialization of mask field */
 #define CLOCKSOURCE_MASK(bits) (cycle_t)(bits<64 ? ((1ULL<<bits)-1) : -1)
 
diff -puN kernel/time/jiffies.c~clocksource-replace-is_continuous-by-a-flag-field kernel/time/jiffies.c
--- a/kernel/time/jiffies.c~clocksource-replace-is_continuous-by-a-flag-field
+++ a/kernel/time/jiffies.c
@@ -62,7 +62,6 @@ struct clocksource clocksource_jiffies =
 	.mask		= 0xffffffff, /*32bits*/
 	.mult		= NSEC_PER_JIFFY << JIFFIES_SHIFT, /* details above */
 	.shift		= JIFFIES_SHIFT,
-	.is_continuous	= 0, /* tick based, not free running */
 };
 
 static int __init init_jiffies_clocksource(void)
diff -puN kernel/timer.c~clocksource-replace-is_continuous-by-a-flag-field kernel/timer.c
--- a/kernel/timer.c~clocksource-replace-is_continuous-by-a-flag-field
+++ a/kernel/timer.c
@@ -871,7 +871,7 @@ int timekeeping_is_continuous(void)
 	do {
 		seq = read_seqbegin(&xtime_lock);
 
-		ret = clock->is_continuous;
+		ret = clock->flags & CLOCK_SOURCE_IS_CONTINUOUS;
 
 	} while (read_seqretry(&xtime_lock, seq));
 
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
