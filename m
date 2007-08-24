From: akpm@linux-foundation.org
Subject: + i386-prepare-sharing-hpet-code.patch added to -mm tree
Date: Fri, 24 Aug 2007 15:04:47 -0700
Message-ID: <200708242204.l7OM4lhw016984@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47431 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760025AbXHXWGm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 18:06:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, ak@suse.de, chrisw@sous-sol.org, johnstul@us.ibm.com, mingo@elte.hu


The patch titled
     i386: prepare sharing the hpet code with x86_64
has been added to the -mm tree.  Its filename is
     i386-prepare-sharing-hpet-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 16 insertions(+), 8 deletions(-)

diff -puN arch/i386/kernel/hpet.c~i386-prepare-sharing-hpet-code arch/i386/kernel/hpet.c
--- a/arch/i386/kernel/hpet.c~i386-prepare-sharing-hpet-code
+++ a/arch/i386/kernel/hpet.c
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
