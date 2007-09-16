From: akpm@linux-foundation.org
Subject: - arm-cleanup-struct-irqaction-initializers.patch removed from -mm tree
Date: Sun, 16 Sep 2007 02:26:52 -0700
Message-ID: <200709160926.l8G9Qquj009214@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43993 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752221AbXIPJjG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 05:39:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     ARM: cleanup struct irqaction initializers
has been removed from the -mm tree.  Its filename was
     arm-cleanup-struct-irqaction-initializers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ARM: cleanup struct irqaction initializers
From: Thomas Gleixner <tglx@linutronix.de>

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-clps7500/core.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletion(-)

diff -puN arch/arm/mach-clps7500/core.c~arm-cleanup-struct-irqaction-initializers arch/arm/mach-clps7500/core.c
--- a/arch/arm/mach-clps7500/core.c~arm-cleanup-struct-irqaction-initializers
+++ a/arch/arm/mach-clps7500/core.c
@@ -193,7 +193,11 @@ static struct irq_chip clps7500_no_chip 
 	.unmask	= cl7500_no_action,
 };
 
-static struct irqaction irq_isa = { no_action, 0, CPU_MASK_NONE, "isa", NULL, NULL };
+static struct irqaction irq_isa = {
+	.handler = no_action,
+	.mask = CPU_MASK_NONE,
+	.name = "isa",
+};
 
 static void __init clps7500_init_irq(void)
 {
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-acpi.patch
git-arm.patch
git-hrt.patch
git-mips.patch
sh-cleanup-struct-irqaction-initializers.patch
sh64-cleanup-struct-irqaction-initializers.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
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
v850-cleanup-struct-irqaction-initializers.patch
time-simplify-smp_call_function_single-call-sequence.patch
kernel-rtmutex-debugc-cleanups.patch
kernel-time-timekeepingc-cleanups.patch
use-num_possible_cpus-instead-of-nr_cpus-for-timer.patch
track-accurate-idle-time-with-tick_schedidle_sleeptime.patch
fix-discrepancy-between-vdso-based-gettimeofday-and-sys_gettimeofday.patch
futex_compat-simplify-pointer-magic.patch
futex_compat-update-to-match-native-version.patch
kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each.patch
whitespace-fixes-time-syscalls.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
