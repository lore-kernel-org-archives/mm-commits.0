From: akpm@linux-foundation.org
Subject: + clockevents-fix-bogus-next_event-reset-for-oneshot-broadcast-devices.patch added to -mm tree
Date: Thu, 27 Sep 2007 15:22:09 -0700
Message-ID: <200709272222.l8RMM9de030868@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39035 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756252AbXI0WWt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Sep 2007 18:22:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, ralf@linux-mips.org


The patch titled
     clockevents: fix bogus next_event reset for oneshot broadcast devices
has been added to the -mm tree.  Its filename is
     clockevents-fix-bogus-next_event-reset-for-oneshot-broadcast-devices.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: clockevents: fix bogus next_event reset for oneshot broadcast devices
From: Thomas Gleixner <tglx@linutronix.de>

In periodic broadcast mode the next_event member of the broadcast device
structure is set to KTIME_MAX in the interrupt handler. This is wrong,
as we calculate the next periodic interrupt with this variable.

Remove it.

Noticed by Ralf. MIPS is the first user of this mode, it does not affect
existing users.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-and-tested-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN kernel/time/tick-broadcast.c~clockevents-fix-bogus-next_event-reset-for-oneshot-broadcast-devices kernel/time/tick-broadcast.c
--- a/kernel/time/tick-broadcast.c~clockevents-fix-bogus-next_event-reset-for-oneshot-broadcast-devices
+++ a/kernel/time/tick-broadcast.c
@@ -177,8 +177,6 @@ static void tick_do_periodic_broadcast(v
  */
 static void tick_handle_periodic_broadcast(struct clock_event_device *dev)
 {
-	dev->next_event.tv64 = KTIME_MAX;
-
 	tick_do_periodic_broadcast();
 
 	/*
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
clockevents-fix-bogus-next_event-reset-for-oneshot-broadcast-devices.patch
git-arm.patch
git-mips.patch
provide-stubs-for-enable_irq_wake-and-disable_irq_wake.patch
sh-cleanup-struct-irqaction-initializers.patch
sh64-cleanup-struct-irqaction-initializers.patch
usb-gadget-ether-prevent-oops-caused-by-error-interrupt-race.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
x86-64-disable-local-apic-timer-use-on-amd-systems-with-c1e.patch
clockevents-remove-unused-inline-function.patch
clockevents-allow-build-without-runtime-use.patch
x86_64-consolidate-tsc-calibration.patch
i386-prepare-sharing-hpet-code.patch
i386-hpet-add-x8664-hpet-bits.patch
i386-prepare-sharing-pit-code.patch
x86_64-use-i386-i8253-h.patch
x86_64-preparatory-apic-set-lvtt.patch
x86_64-apic-remove-bogus-pit-synchronization.patch
x86_64-apic-shuffle-calibration-around.patch
x86_64-apic-calibration-remove-divisor.patch
x86_64-apic-change-setup-calling-convention.patch
x86_64-apic-remove-nested-irq-disable.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-apic-add-clockevents-functions.patch
x86_64-convert-to-clockevents.patch
x86_64-remove-unused-code.patch
x86_64-cleanup-apic-c.patch
x86_64-cleanup-apic-c-fix.patch
jiffies-remove-unused-macros.patch
acpi-remove-the-useless-ifdef-code.patch
i386-pit-remove-the-useless-ifdefs.patch
i386-hpet-sharing-optimize.patch
ich-force-hpet-make-generic-time-capable-of-switching-broadcast-timer.patch
ich-force-hpet-restructure-hpet-generic-clock-code.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable-fix.patch
ich-force-hpet-late-initialization-of-hpet-after-quirk.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable-fix.patch
ich-force-hpet-ich5-fix-a-bug-with-suspend-resume.patch
ich-force-hpet-add-ich7_0-pciid-to-quirk-list.patch
hpet-force-enable-on-ich34.patch
i386-cleanup-struct-irqaction-initializers.patch
x86_64-cleanup-struct-irqaction-initializers.patch
hpet-force-enable-on-vt8235-37-chipsets.patch
frv-cleanup-struct-irqaction-initializers.patch
m32r-cleanup-struct-irqaction-initializers.patch
cris-cleanup-struct-irqaction-initializers.patch
uml-eliminate-hz.patch
uml-fix-timer-switching.patch
uml-simplify-interval-setting.patch
uml-separate-timer-initialization.patch
uml-generic_time-support.patch
uml-generic_clockevents-support.patch
uml-clocksource-support.patch
uml-clocksource-support-fix.patch
uml-tickless-support.patch
uml-tickless-support-fix.patch
uml-eliminate-interrupts-in-the-idle-loop.patch
uml-eliminate-sigalrm.patch
uml-use-sec_per_sec-constants.patch
v850-cleanup-struct-irqaction-initializers.patch
time-simplify-smp_call_function_single-call-sequence.patch
kernel-rtmutex-debugc-cleanups.patch
kernel-time-timekeepingc-cleanups.patch
use-num_possible_cpus-instead-of-nr_cpus-for-timer.patch
track-accurate-idle-time-with-tick_schedidle_sleeptime.patch
track-accurate-idle-time-with-tick_schedidle_sleeptime-fix.patch
fix-discrepancy-between-vdso-based-gettimeofday-and-sys_gettimeofday.patch
futex_compat-simplify-pointer-magic.patch
futex_compat-update-to-match-native-version.patch
compile-handle_percpu_irq-even-for-uniprocessor-kernels.patch
kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each.patch
whitespace-fixes-time-syscalls.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
