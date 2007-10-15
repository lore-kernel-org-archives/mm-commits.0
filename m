From: akpm@linux-foundation.org
Subject: - i386-hpet-sharing-optimize.patch removed from -mm tree
Date: Mon, 15 Oct 2007 02:18:33 -0700
Message-ID: <200710150918.l9F9IXA6027413@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39819 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756947AbXJOJY3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 05:24:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, ak@suse.de, chrisw@sous-sol.org, johnstul@us.ibm.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     i386/x86_64: cleanup the shared hpet code
has been removed from the -mm tree.  Its filename was
     i386-hpet-sharing-optimize.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
--- a/arch/x86/kernel/hpet_32.c~i386-hpet-sharing-optimize
+++ a/arch/x86/kernel/hpet_32.c
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
--- a/include/asm-x86/hpet_32.h~i386-hpet-sharing-optimize
+++ a/include/asm-x86/hpet_32.h
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
--- a/include/asm-x86/vsyscall.h~i386-hpet-sharing-optimize
+++ a/include/asm-x86/vsyscall.h
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
