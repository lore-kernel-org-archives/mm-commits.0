From: akpm@linux-foundation.org
Subject: - sh-cleanup-struct-irqaction-initializers.patch removed from -mm tree
Date: Fri, 05 Oct 2007 12:58:11 -0700
Message-ID: <200710051958.l95JwB4B022527@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60840 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763201AbXJEUB0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 16:01:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     SH: cleanup struct irqaction initializers
has been removed from the -mm tree.  Its filename was
     sh-cleanup-struct-irqaction-initializers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SH: cleanup struct irqaction initializers
From: Thomas Gleixner <tglx@linutronix.de>

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/boards/se/7343/irq.c           |    7 +++++--
 arch/sh/cchips/hd6446x/hd64461.c       |    7 ++++++-
 arch/sh/cchips/hd6446x/hd64465/setup.c |    7 ++++++-
 3 files changed, 17 insertions(+), 4 deletions(-)

diff -puN arch/sh/boards/se/7343/irq.c~sh-cleanup-struct-irqaction-initializers arch/sh/boards/se/7343/irq.c
--- a/arch/sh/boards/se/7343/irq.c~sh-cleanup-struct-irqaction-initializers
+++ a/arch/sh/boards/se/7343/irq.c
@@ -99,8 +99,11 @@ shmse_irq_demux(int irq)
  *
  * We configure IRQ5 as a cascade IRQ.
  */
-static struct irqaction irq5 = { no_action, 0, CPU_MASK_NONE, "IRQ5-cascade",
-				NULL, NULL};
+static struct irqaction irq5 = {
+	.handler = no_action,
+	.mask = CPU_MASK_NONE,
+	.name = "IRQ5-cascade",
+};
 
 static struct ipr_data se7343_irq5_ipr_map[] = {
 	{ IRQ5_IRQ, IRQ5_IPR_ADDR+2, IRQ5_IPR_POS, IRQ5_PRIORITY },
diff -puN arch/sh/cchips/hd6446x/hd64461.c~sh-cleanup-struct-irqaction-initializers arch/sh/cchips/hd6446x/hd64461.c
--- a/arch/sh/cchips/hd6446x/hd64461.c~sh-cleanup-struct-irqaction-initializers
+++ a/arch/sh/cchips/hd6446x/hd64461.c
@@ -127,7 +127,12 @@ int hd64461_irq_demux(int irq)
 	return irq;
 }
 
-static struct irqaction irq0 = { hd64461_interrupt, IRQF_DISABLED, CPU_MASK_NONE, "HD64461", NULL, NULL };
+static struct irqaction irq0 = {
+	.handler = hd64461_interrupt,
+	.flags = IRQF_DISABLED,
+	.mask = CPU_MASK_NONE,
+	.name = "HD64461",
+};
 
 int __init setup_hd64461(void)
 {
diff -puN arch/sh/cchips/hd6446x/hd64465/setup.c~sh-cleanup-struct-irqaction-initializers arch/sh/cchips/hd6446x/hd64465/setup.c
--- a/arch/sh/cchips/hd6446x/hd64465/setup.c~sh-cleanup-struct-irqaction-initializers
+++ a/arch/sh/cchips/hd6446x/hd64465/setup.c
@@ -147,7 +147,12 @@ int hd64465_irq_demux(int irq)
 	return irq;
 }
 
-static struct irqaction irq0  = { hd64465_interrupt, IRQF_DISABLED, CPU_MASK_NONE, "HD64465", NULL, NULL};
+static struct irqaction irq0  = {
+	.handler = hd64465_interrupt,
+	.flags = IRQF_DISABLED,
+	.mask = CPU_MASK_NONE,
+	.name = "HD64465",
+};
 
 
 static int __init setup_hd64465(void)
_

Patches currently in -mm which might be from tglx@linutronix.de are

clockevents-fix-bogus-next_event-reset-for-oneshot-broadcast-devices.patch
git-acpi.patch
git-arm.patch
git-mips.patch
provide-stubs-for-enable_irq_wake-and-disable_irq_wake.patch
git-sched.patch
git-sh.patch
git-sh64.patch
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
jiffies-remove-unused-macros.patch
acpi-remove-the-useless-ifdef-code.patch
i386-pit-remove-the-useless-ifdefs.patch
i386-hpet-sharing-optimize.patch
ich-force-hpet-make-generic-time-capable-of-switching-broadcast-timer.patch
ich-force-hpet-restructure-hpet-generic-clock-code.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch
ich-force-hpet-late-initialization-of-hpet-after-quirk.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
ich-force-hpet-ich5-fix-a-bug-with-suspend-resume.patch
ich-force-hpet-add-ich7_0-pciid-to-quirk-list.patch
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
fix-discrepancy-between-vdso-based-gettimeofday-and-sys_gettimeofday.patch
compile-handle_percpu_irq-even-for-uniprocessor-kernels.patch
spin_lock_unlocked-cleanups.patch
kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each.patch
whitespace-fixes-time-syscalls.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
