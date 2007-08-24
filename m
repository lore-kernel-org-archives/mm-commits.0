From: akpm@linux-foundation.org
Subject: + i386-hpet-sharing-optimize.patch added to -mm tree
Date: Fri, 24 Aug 2007 15:05:33 -0700
Message-ID: <200708242205.l7OM5XVt017050@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49755 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757703AbXHXWPA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 18:15:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, ak@suse.de, chrisw@sous-sol.org, johnstul@us.ibm.com, mingo@elte.hu


The patch titled
     i386/x86_64: cleanup the shared hpet code
has been added to the -mm tree.  Its filename is
     i386-hpet-sharing-optimize.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386/x86_64: cleanup the shared hpet code
From: Thomas Gleixner <tglx@linutronix.de>

Remove hpet_readl/writel from vsyscall.h, where it does not belong anyway. 
Use the hpet code itself.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/hpet.c       |    6 +-----
 include/asm-i386/hpet.h       |    2 ++
 include/asm-x86_64/vsyscall.h |    3 ---
 3 files changed, 3 insertions(+), 8 deletions(-)

diff -puN arch/i386/kernel/hpet.c~i386-hpet-sharing-optimize arch/i386/kernel/hpet.c
--- a/arch/i386/kernel/hpet.c~i386-hpet-sharing-optimize
+++ a/arch/i386/kernel/hpet.c
@@ -25,11 +25,7 @@
 unsigned long hpet_address;
 static void __iomem *hpet_virt_address;
 
-/* Temporary hack. Cleanup after x86_64 clock events conversion */
-#undef hpet_readl
-#undef hpet_writel
-
-static inline unsigned long hpet_readl(unsigned long a)
+unsigned long hpet_readl(unsigned long a)
 {
 	return readl(hpet_virt_address + a);
 }
diff -puN include/asm-i386/hpet.h~i386-hpet-sharing-optimize include/asm-i386/hpet.h
--- a/include/asm-i386/hpet.h~i386-hpet-sharing-optimize
+++ a/include/asm-i386/hpet.h
@@ -66,6 +66,7 @@
 extern unsigned long hpet_address;
 extern int is_hpet_enabled(void);
 extern int hpet_enable(void);
+extern unsigned long hpet_readl(unsigned long a);
 
 #ifdef CONFIG_HPET_EMULATE_RTC
 
@@ -85,6 +86,7 @@ extern irqreturn_t hpet_rtc_interrupt(in
 #else
 
 static inline int hpet_enable(void) { return 0; }
+static inline unsigned long hpet_readl(unsigned long a) { return 0; }
 
 #endif /* CONFIG_HPET_TIMER */
 #endif /* _I386_HPET_H */
diff -puN include/asm-x86_64/vsyscall.h~i386-hpet-sharing-optimize include/asm-x86_64/vsyscall.h
--- a/include/asm-x86_64/vsyscall.h~i386-hpet-sharing-optimize
+++ a/include/asm-x86_64/vsyscall.h
@@ -29,9 +29,6 @@ enum vsyscall_num {
 #define VGETCPU_RDTSCP	1
 #define VGETCPU_LSL	2
 
-#define hpet_readl(a)           readl((const void __iomem *)fix_to_virt(FIX_HPET_BASE) + a)
-#define hpet_writel(d,a)        writel(d, (void __iomem *)fix_to_virt(FIX_HPET_BASE) + a)
-
 extern int __vgetcpu_mode;
 extern volatile unsigned long __jiffies;
 
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
