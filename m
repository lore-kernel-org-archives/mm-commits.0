From: akpm@linux-foundation.org
Subject: - i386-prepare-sharing-pit-code.patch removed from -mm tree
Date: Mon, 15 Oct 2007 02:17:57 -0700
Message-ID: <200710150917.l9F9Hvnc027331@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60407 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755711AbXJOJXM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 05:23:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, ak@suse.de, chrisw@sous-sol.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     i386: prepare sharing the PIT code
has been removed from the -mm tree.  Its filename was
     i386-prepare-sharing-pit-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: prepare sharing the PIT code
From: Thomas Gleixner <tglx@linutronix.de>

PIT clock events work already and the PIT handling is the same for i386 and
x86_64.  x86_64 does not support PIT as a clock source, so disable the PIT
clocksource for x86_64.

Prepare i8253.h to be shared with x8664

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/i8253.c |    4 +++-
 include/asm-i386/i8253.h |    6 ++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff -puN arch/i386/kernel/i8253.c~i386-prepare-sharing-pit-code arch/i386/kernel/i8253.c
--- a/arch/x86/kernel/i8253_32.c~i386-prepare-sharing-pit-code
+++ a/arch/x86/kernel/i8253_32.c
@@ -13,7 +13,6 @@
 #include <asm/delay.h>
 #include <asm/i8253.h>
 #include <asm/io.h>
-#include <asm/timer.h>
 
 DEFINE_SPINLOCK(i8253_lock);
 EXPORT_SYMBOL(i8253_lock);
@@ -120,6 +119,7 @@ void __init setup_pit_timer(void)
 	global_clock_event = &pit_clockevent;
 }
 
+#ifndef CONFIG_X86_64
 /*
  * Since the PIT overflows every tick, its not very useful
  * to just read by itself. So use jiffies to emulate a free
@@ -204,3 +204,5 @@ static int __init init_pit_clocksource(v
 	return clocksource_register(&clocksource_pit);
 }
 arch_initcall(init_pit_clocksource);
+
+#endif
diff -puN include/asm-i386/i8253.h~i386-prepare-sharing-pit-code include/asm-i386/i8253.h
--- a/include/asm-x86/i8253_32.h~i386-prepare-sharing-pit-code
+++ a/include/asm-x86/i8253_32.h
@@ -1,8 +1,6 @@
 #ifndef __ASM_I8253_H__
 #define __ASM_I8253_H__
 
-#include <linux/clockchips.h>
-
 /* i8253A PIT registers */
 #define PIT_MODE		0x43
 #define PIT_CH0			0x40
@@ -10,8 +8,12 @@
 
 extern spinlock_t i8253_lock;
 
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
+
 extern struct clock_event_device *global_clock_event;
 
 extern void setup_pit_timer(void);
 
+#endif
+
 #endif	/* __ASM_I8253_H__ */
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
