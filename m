From: akpm@linux-foundation.org
Subject: + i386-hpet-add-x8664-hpet-bits.patch added to -mm tree
Date: Fri, 24 Aug 2007 15:04:49 -0700
Message-ID: <200708242204.l7OM4nfb016987@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46224 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759281AbXHXWGV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 18:06:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, ak@suse.de, johnstul@us.ibm.com, mingo@elte.hu


The patch titled
     i386: prepare sharing the hpet code with x86_64
has been added to the -mm tree.  Its filename is
     i386-hpet-add-x8664-hpet-bits.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: prepare sharing the hpet code with x86_64
From: Thomas Gleixner <tglx@linutronix.de>

Add the x86_64 specific bits (mapping) to share the hpet code later.

Move the reserve_platform_timer call to late init. This is necessary
for x86_64, as hpet enable() is called before memory is setup. i386
calls it in late_time_init, but it does not hurt to do it later for
both.

Pull in the x8664 hpet disable command line option as well.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/hpet.c |   59 +++++++++++++++++++++++++++++++++++++-
 1 files changed, 58 insertions(+), 1 deletion(-)

diff -puN arch/i386/kernel/hpet.c~i386-hpet-add-x8664-hpet-bits arch/i386/kernel/hpet.c
--- a/arch/i386/kernel/hpet.c~i386-hpet-add-x8664-hpet-bits
+++ a/arch/i386/kernel/hpet.c
@@ -1,5 +1,6 @@
 #include <linux/clocksource.h>
 #include <linux/clockchips.h>
+#include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/hpet.h>
 #include <linux/init.h>
@@ -7,6 +8,7 @@
 #include <linux/pm.h>
 #include <linux/delay.h>
 
+#include <asm/fixmap.h>
 #include <asm/hpet.h>
 #include <asm/i8253.h>
 #include <asm/io.h>
@@ -23,6 +25,10 @@
 unsigned long hpet_address;
 static void __iomem *hpet_virt_address;
 
+/* Temporary hack. Cleanup after x86_64 clock events conversion */
+#undef hpet_readl
+#undef hpet_writel
+
 static inline unsigned long hpet_readl(unsigned long a)
 {
 	return readl(hpet_virt_address + a);
@@ -33,6 +39,24 @@ static inline void hpet_writel(unsigned 
 	writel(d, hpet_virt_address + a);
 }
 
+#ifdef CONFIG_X86_64
+
+#include <asm/pgtable.h>
+
+static inline void hpet_set_mapping(void)
+{
+	set_fixmap_nocache(FIX_HPET_BASE, hpet_address);
+	__set_fixmap(VSYSCALL_HPET, hpet_address, PAGE_KERNEL_VSYSCALL_NOCACHE);
+	hpet_virt_address = (void __iomem *)fix_to_virt(FIX_HPET_BASE);
+}
+
+static inline void hpet_clear_mapping(void)
+{
+	hpet_virt_address = NULL;
+}
+
+#else
+
 static inline void hpet_set_mapping(void)
 {
 	hpet_virt_address = ioremap_nocache(hpet_address, HPET_MMAP_SIZE);
@@ -43,6 +67,7 @@ static inline void hpet_clear_mapping(vo
 	iounmap(hpet_virt_address);
 	hpet_virt_address = NULL;
 }
+#endif
 
 /*
  * HPET command line enable / disable
@@ -59,6 +84,13 @@ static int __init hpet_setup(char* str)
 }
 __setup("hpet=", hpet_setup);
 
+static int __init disable_hpet(char *str)
+{
+	boot_hpet_disable = 1;
+	return 1;
+}
+__setup("nohpet", disable_hpet);
+
 static inline int is_hpet_capable(void)
 {
 	return (!boot_hpet_disable && hpet_address);
@@ -225,6 +257,13 @@ static cycle_t read_hpet(void)
 	return (cycle_t)hpet_readl(HPET_COUNTER);
 }
 
+#ifdef CONFIG_X86_64
+static cycle_t __vsyscall_fn vread_hpet(void)
+{
+	return readl((const void __iomem *)fix_to_virt(VSYSCALL_HPET) + 0xf0);
+}
+#endif
+
 static struct clocksource clocksource_hpet = {
 	.name		= "hpet",
 	.rating		= 250,
@@ -233,6 +272,9 @@ static struct clocksource clocksource_hp
 	.shift		= HPET_SHIFT,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 	.resume		= hpet_start_counter,
+#ifdef CONFIG_X86_64
+	.vread		= vread_hpet,
+#endif
 };
 
 /*
@@ -331,7 +373,6 @@ int __init hpet_enable(void)
 
 	if (id & HPET_ID_LEGSUP) {
 		hpet_enable_int();
-		hpet_reserve_platform_timers(id);
 		/*
 		 * Start hpet with the boot cpu mask and make it
 		 * global after the IO_APIC has been initialized.
@@ -349,6 +390,22 @@ out_nohpet:
 	return 0;
 }
 
+/*
+ * Needs to be late, as the reserve_timer code calls kalloc !
+ *
+ * Not a problem on i386 as hpet_enable is called from late_time_init,
+ * but on x86_64 it is necessary !
+ */
+static __init int hpet_late_init(void)
+{
+	if (!is_hpet_capable())
+		return -ENODEV;
+
+	hpet_reserve_platform_timers(hpet_readl(HPET_ID));
+	return 0;
+}
+fs_initcall(hpet_late_init);
+
 #ifdef CONFIG_HPET_EMULATE_RTC
 
 /* HPET in LegacyReplacement Mode eats up RTC interrupt line. When, HPET
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
sigqueue_free-fix-the-race-with-collect_signal.patch
git-acpi.patch
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
time-simplify-smp_call_function_single-call-sequence.patch
kernel-rtmutex-debugc-cleanups.patch
kernel-time-timekeepingc-cleanups.patch
use-num_possible_cpus-instead-of-nr_cpus-for-timer.patch
kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each.patch
whitespace-fixes-time-syscalls.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
