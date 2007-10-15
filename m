From: akpm@linux-foundation.org
Subject: - i386-hpet-add-x8664-hpet-bits.patch removed from -mm tree
Date: Mon, 15 Oct 2007 02:17:55 -0700
Message-ID: <200710150917.l9F9HtiP027327@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37268 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756809AbXJOJX3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 05:23:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, ak@suse.de, johnstul@us.ibm.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     i386: prepare sharing the hpet code with x86_64
has been removed from the -mm tree.  Its filename was
     i386-hpet-add-x8664-hpet-bits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 58 insertions(+), 1 deletion(-)

diff -puN arch/i386/kernel/hpet.c~i386-hpet-add-x8664-hpet-bits arch/i386/kernel/hpet.c
--- a/arch/x86/kernel/hpet_32.c~i386-hpet-add-x8664-hpet-bits
+++ a/arch/x86/kernel/hpet_32.c
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
git-acpi.patch
git-arm.patch
git-mips.patch
provide-stubs-for-enable_irq_wake-and-disable_irq_wake.patch
git-sched.patch
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
