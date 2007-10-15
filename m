From: akpm@linux-foundation.org
Subject: - i386-prepare-sharing-hpet-code.patch removed from -mm tree
Date: Mon, 15 Oct 2007 02:17:53 -0700
Message-ID: <200710150917.l9F9Hrmn027323@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58461 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757341AbXJOJYd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 05:24:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, ak@suse.de, chrisw@sous-sol.org, johnstul@us.ibm.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     i386: prepare sharing the hpet code with x86_64
has been removed from the -mm tree.  Its filename was
     i386-prepare-sharing-hpet-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: prepare sharing the hpet code with x86_64
From: Thomas Gleixner <tglx@linutronix.de>

The hpet implementations of i386 and x8664 has been mostly the same before the
clock events conversion of i386.  The clock events conversion of i386 hpet is
already done.  So it makes sense to share the code for the x86_64 clock events
conversion.

Abstract out the mapping functions.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/hpet.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff -puN arch/i386/kernel/hpet.c~i386-prepare-sharing-hpet-code arch/i386/kernel/hpet.c
--- a/arch/x86/kernel/hpet_32.c~i386-prepare-sharing-hpet-code
+++ a/arch/x86/kernel/hpet_32.c
@@ -8,10 +8,9 @@
 #include <linux/delay.h>
 
 #include <asm/hpet.h>
+#include <asm/i8253.h>
 #include <asm/io.h>
 
-extern struct clock_event_device *global_clock_event;
-
 #define HPET_MASK	CLOCKSOURCE_MASK(32)
 #define HPET_SHIFT	22
 
@@ -22,7 +21,7 @@ extern struct clock_event_device *global
  * HPET address is set in acpi/boot.c, when an ACPI entry exists
  */
 unsigned long hpet_address;
-static void __iomem * hpet_virt_address;
+static void __iomem *hpet_virt_address;
 
 static inline unsigned long hpet_readl(unsigned long a)
 {
@@ -34,6 +33,17 @@ static inline void hpet_writel(unsigned 
 	writel(d, hpet_virt_address + a);
 }
 
+static inline void hpet_set_mapping(void)
+{
+	hpet_virt_address = ioremap_nocache(hpet_address, HPET_MMAP_SIZE);
+}
+
+static inline void hpet_clear_mapping(void)
+{
+	iounmap(hpet_virt_address);
+	hpet_virt_address = NULL;
+}
+
 /*
  * HPET command line enable / disable
  */
@@ -83,7 +93,7 @@ static void hpet_reserve_platform_timers
 
 	memset(&hd, 0, sizeof (hd));
 	hd.hd_phys_address = hpet_address;
-	hd.hd_address = hpet_virt_address;
+	hd.hd_address = hpet;
 	hd.hd_nirqs = nrtimers;
 	hd.hd_flags = HPET_DATA_PLATFORM;
 	hpet_reserve_timer(&hd, 0);
@@ -238,7 +248,7 @@ int __init hpet_enable(void)
 	if (!is_hpet_capable())
 		return 0;
 
-	hpet_virt_address = ioremap_nocache(hpet_address, HPET_MMAP_SIZE);
+	hpet_set_mapping();
 
 	/*
 	 * Read the period and check for a sane value:
@@ -334,13 +344,11 @@ int __init hpet_enable(void)
 	return 0;
 
 out_nohpet:
-	iounmap(hpet_virt_address);
-	hpet_virt_address = NULL;
+	hpet_clear_mapping();
 	boot_hpet_disable = 1;
 	return 0;
 }
 
-
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
