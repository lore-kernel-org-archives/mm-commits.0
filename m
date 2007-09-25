From: akpm@linux-foundation.org
Subject: + x86-64-disable-local-apic-timer-use-on-amd-systems-with-c1e.patch added to -mm tree
Date: Tue, 25 Sep 2007 13:01:46 -0700
Message-ID: <200709252001.l8PK1k2v002065@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33247 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751923AbXIYUDF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Sep 2007 16:03:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, ak@suse.de, mingo@elte.hu, rjw@sisk.pl


The patch titled
     x86-64: Disable local APIC timer use on AMD systems with C1E
has been added to the -mm tree.  Its filename is
     x86-64-disable-local-apic-timer-use-on-amd-systems-with-c1e.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86-64: Disable local APIC timer use on AMD systems with C1E
From: Thomas Gleixner <tglx@linutronix.de>

commit 3556ddfa9284a86a59a9b78fe5894430f6ab4eef titled

 [PATCH] x86-64: Disable local APIC timer use on AMD systems with C1E

solves a problem with AMD dual core laptops e.g. HP nx6325 (Turion 64
X2) with C1E enabled:

When both cores go into idle at the same time, then the system switches
into C1E state, which is basically the same as C3. This stops the local
apic timer.

This was debugged right after the dyntick merge on i386 and despite the
patch title it fixes only the 32 bit path.

x86_64 is still missing this fix. It seems that mainline is not really
affected by this issue, as the PIT is running and keeps jiffies
incrementing, but that's just waiting for trouble.

-mm suffers from this problem due to the x86_64 high resolution timer
patches.

This is a quick and dirty port of the i386 code to x86_64.

I spent quite a time with Rafael to debug the -mm / hrt wreckage until
someone pointed us to this. I really had forgotten that we debugged this
half a year ago already.

Sigh, is it just me or is there something yelling arch/x86 into my ear?

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/setup.c |   34 ++++++++++++++++++++++++++++++++++
 include/asm-x86_64/apic.h  |    1 +
 2 files changed, 35 insertions(+)

diff -puN arch/x86_64/kernel/setup.c~x86-64-disable-local-apic-timer-use-on-amd-systems-with-c1e arch/x86_64/kernel/setup.c
--- a/arch/x86_64/kernel/setup.c~x86-64-disable-local-apic-timer-use-on-amd-systems-with-c1e
+++ a/arch/x86_64/kernel/setup.c
@@ -561,6 +561,37 @@ static void __cpuinit early_init_amd(str
 #endif
 }
 
+#define ENABLE_C1E_MASK		0x18000000
+#define CPUID_PROCESSOR_SIGNATURE	1
+#define CPUID_XFAM		0x0ff00000
+#define CPUID_XFAM_K8		0x00000000
+#define CPUID_XFAM_10H		0x00100000
+#define CPUID_XFAM_11H		0x00200000
+#define CPUID_XMOD		0x000f0000
+#define CPUID_XMOD_REV_F	0x00040000
+
+/* AMD systems with C1E don't have a working lAPIC timer. Check for that. */
+static __cpuinit int amd_apic_timer_broken(void)
+{
+	u32 lo, hi;
+	u32 eax = cpuid_eax(CPUID_PROCESSOR_SIGNATURE);
+	switch (eax & CPUID_XFAM) {
+	case CPUID_XFAM_K8:
+		if ((eax & CPUID_XMOD) < CPUID_XMOD_REV_F)
+			break;
+	case CPUID_XFAM_10H:
+	case CPUID_XFAM_11H:
+		rdmsr(MSR_K8_ENABLE_C1E, lo, hi);
+		if (lo & ENABLE_C1E_MASK)
+			return 1;
+		break;
+	default:
+		/* err on the side of caution */
+		return 1;
+	}
+	return 0;
+}
+
 static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 {
 	unsigned level, flags, dummy;
@@ -633,6 +664,9 @@ static void __cpuinit init_amd(struct cp
 	if (c->x86 == 0x10 && !force_mwait)
 		clear_bit(X86_FEATURE_MWAIT, &c->x86_capability);
 
+	if (amd_apic_timer_broken())
+		disable_apic_timer = 1;
+
 	if (c->x86 >= 0xf && c->x86 <= 0x11 &&
 	    !rdmsr_safe(MSR_VM_CR, &flags, &dummy) &&
 	    (flags & 0x18))
diff -puN include/asm-x86_64/apic.h~x86-64-disable-local-apic-timer-use-on-amd-systems-with-c1e include/asm-x86_64/apic.h
--- a/include/asm-x86_64/apic.h~x86-64-disable-local-apic-timer-use-on-amd-systems-with-c1e
+++ a/include/asm-x86_64/apic.h
@@ -19,6 +19,7 @@
 extern int apic_verbosity;
 extern int apic_runs_main_timer;
 extern int ioapic_force;
+extern int disable_apic_timer;
 
 /*
  * Define the default level of output to be very little
_

Patches currently in -mm which might be from tglx@linutronix.de are

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
kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each.patch
whitespace-fixes-time-syscalls.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
