From: akpm@linux-foundation.org
Subject: - scheduled-removal-of-sa_xxx-interrupt-flags.patch removed from -mm tree
Date: Thu, 08 Feb 2007 15:54:17 -0800
Message-ID: <200702082354.l18NsHRY031259@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46026 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965730AbXBHXy1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Feb 2007 18:54:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Scheduled removal of SA_xxx interrupt flags
has been removed from the -mm tree.  Its filename was
     scheduled-removal-of-sa_xxx-interrupt-flags.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: Scheduled removal of SA_xxx interrupt flags
From: Thomas Gleixner <tglx@linutronix.de>

The name space cleanup of the interrupt request flags (SA_xxx -> IRQF_xxx)
left a 6 month grace period for the old deprecated flags.  Remove them.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/feature-removal-schedule.txt |    9 ---------
 include/linux/interrupt.h                  |   16 ----------------
 2 files changed, 25 deletions(-)

diff -puN Documentation/feature-removal-schedule.txt~scheduled-removal-of-sa_xxx-interrupt-flags Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~scheduled-removal-of-sa_xxx-interrupt-flags
+++ a/Documentation/feature-removal-schedule.txt
@@ -183,15 +183,6 @@ Who:	Nick Piggin <npiggin@suse.de>
 
 ---------------------------
 
-What:	Interrupt only SA_* flags
-When:	Januar 2007
-Why:	The interrupt related SA_* flags are replaced by IRQF_* to move them
-	out of the signal namespace.
-
-Who:	Thomas Gleixner <tglx@linutronix.de>
-
----------------------------
-
 What:	PHYSDEVPATH, PHYSDEVBUS, PHYSDEVDRIVER in the uevent environment
 When:	October 2008
 Why:	The stacking of class devices makes these values misleading and
diff -puN include/linux/interrupt.h~scheduled-removal-of-sa_xxx-interrupt-flags include/linux/interrupt.h
--- a/include/linux/interrupt.h~scheduled-removal-of-sa_xxx-interrupt-flags
+++ a/include/linux/interrupt.h
@@ -52,22 +52,6 @@
 #define IRQF_PERCPU		0x00000400
 #define IRQF_NOBALANCING	0x00000800
 
-/*
- * Migration helpers. Scheduled for removal in 1/2007
- * Do not use for new code !
- */
-#define SA_INTERRUPT		IRQF_DISABLED
-#define SA_SAMPLE_RANDOM	IRQF_SAMPLE_RANDOM
-#define SA_SHIRQ		IRQF_SHARED
-#define SA_PROBEIRQ		IRQF_PROBE_SHARED
-#define SA_PERCPU		IRQF_PERCPU
-
-#define SA_TRIGGER_LOW		IRQF_TRIGGER_LOW
-#define SA_TRIGGER_HIGH		IRQF_TRIGGER_HIGH
-#define SA_TRIGGER_FALLING	IRQF_TRIGGER_FALLING
-#define SA_TRIGGER_RISING	IRQF_TRIGGER_RISING
-#define SA_TRIGGER_MASK		IRQF_TRIGGER_MASK
-
 typedef irqreturn_t (*irq_handler_t)(int, void *);
 
 struct irqaction {
_

Patches currently in -mm which might be from tglx@linutronix.de are

bugfixes-pci-devices-get-assigned-redundant-irqs.patch
git-block.patch
kernel-time-clocksourcec-needs-struct-task_struct-on-m68k.patch
use-cycle_t-instead-of-u64-in-struct-time_interpolator.patch
proc-remove-useless-and-buggy-nlink-settings.patch
add-irq-flag-to-disable-balancing-for-an-interrupt.patch
add-a-functions-to-handle-interrupt-affinity-setting.patch
add-a-functions-to-handle-interrupt-affinity-setting-alpha-fix.patch
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
time-x86_64-hpet-fixup-clocksource-changes.patch
time-x86_64-tsc-fixup-clocksource-changes.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
posix-timers-rcu-optimization-for-clock_gettime.patch
posix-timers-rcu-optimization-for-clock_gettime-fix.patch
genirq-do-not-mask-interrupts-by-default.patch
genirq-remove-irq_disabled.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-2.patch
deprecate-sa_interrupt-and-friends.patch
scheduled-removal-of-sa_xxx-interrupt-flags.patch
