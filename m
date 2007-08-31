From: akpm@linux-foundation.org
Subject: + v850-cleanup-struct-irqaction-initializers.patch added to -mm tree
Date: Fri, 31 Aug 2007 11:44:53 -0700
Message-ID: <200708311844.l7VIiriI021348@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35181 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965933AbXHaSpb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 14:45:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, miles@gnu.org


The patch titled
     V850: cleanup struct irqaction initializers
has been added to the -mm tree.  Its filename is
     v850-cleanup-struct-irqaction-initializers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: V850: cleanup struct irqaction initializers
From: Thomas Gleixner <tglx@linutronix.de>

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Miles Bader <miles@gnu.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/v850/kernel/fpga85e2c.c |    5 ++++-
 arch/v850/kernel/time.c      |   11 +++++------
 2 files changed, 9 insertions(+), 7 deletions(-)

diff -puN arch/v850/kernel/fpga85e2c.c~v850-cleanup-struct-irqaction-initializers arch/v850/kernel/fpga85e2c.c
--- a/arch/v850/kernel/fpga85e2c.c~v850-cleanup-struct-irqaction-initializers
+++ a/arch/v850/kernel/fpga85e2c.c
@@ -160,5 +160,8 @@ static void make_reg_snap (int irq, void
 
 static int reg_snap_dev_id;
 static struct irqaction reg_snap_action = {
-	make_reg_snap, 0, CPU_MASK_NONE, "reg_snap", &reg_snap_dev_id, 0
+	.handler = make_reg_snap,
+	.mask = CPU_MASK_NONE,
+	.name = "reg_snap",
+	.dev_id = &reg_snap_dev_id,
 };
diff -puN arch/v850/kernel/time.c~v850-cleanup-struct-irqaction-initializers arch/v850/kernel/time.c
--- a/arch/v850/kernel/time.c~v850-cleanup-struct-irqaction-initializers
+++ a/arch/v850/kernel/time.c
@@ -92,12 +92,11 @@ static irqreturn_t timer_interrupt (int 
 
 static int timer_dev_id;
 static struct irqaction timer_irqaction = {
-	timer_interrupt,
-	IRQF_DISABLED,
-	CPU_MASK_NONE,
-	"timer",
-	&timer_dev_id,
-	NULL
+	.handler = timer_interrupt,
+	.flags = IRQF_DISABLED,
+	.mask = CPU_MASK_NONE,
+	.name = "timer",
+	.dev_id = &timer_dev_id,
 };
 
 void time_init (void)
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-acpi.patch
git-mips.patch
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
hpet-force-enable-on-vt8235-37-chipsets.patch
arm-cleanup-struct-irqaction-initializers.patch
cris-cleanup-struct-irqaction-initializers.patch
frv-cleanup-struct-irqaction-initializers.patch
i386-cleanup-struct-irqaction-initializers.patch
m32r-cleanup-struct-irqaction-initializers.patch
sh-cleanup-struct-irqaction-initializers.patch
sh64-cleanup-struct-irqaction-initializers.patch
v850-cleanup-struct-irqaction-initializers.patch
x86_64-cleanup-struct-irqaction-initializers.patch
time-simplify-smp_call_function_single-call-sequence.patch
kernel-rtmutex-debugc-cleanups.patch
kernel-time-timekeepingc-cleanups.patch
use-num_possible_cpus-instead-of-nr_cpus-for-timer.patch
track-accurate-idle-time-with-tick_schedidle_sleeptime.patch
kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each.patch
whitespace-fixes-time-syscalls.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
