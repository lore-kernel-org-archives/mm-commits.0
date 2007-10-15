From: akpm@linux-foundation.org
Subject: - x86_64-use-i386-i8253-h.patch removed from -mm tree
Date: Mon, 15 Oct 2007 02:17:59 -0700
Message-ID: <200710150917.l9F9Hx4V027340@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55857 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757163AbXJOJYN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 05:24:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, ak@suse.de, chrisw@sous-sol.org, johnstul@us.ibm.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     i386: prepare sharing the PIT code
has been removed from the -mm tree.  Its filename was
     x86_64-use-i386-i8253-h.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: prepare sharing the PIT code
From: Thomas Gleixner <tglx@linutronix.de>

PIT clock events work already and the PIT handling is the same for i386 and
x86_64.  x86_64 does not support PIT as a clock source, so disable the PIT
clocksource for x86_64.

Use the i386 i8253.h include file for x86_64 as well to share the
exports and the PIT constants.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/time.c  |    4 ----
 include/asm-x86_64/i8253.h |    8 ++------
 2 files changed, 2 insertions(+), 10 deletions(-)

diff -puN arch/x86_64/kernel/time.c~x86_64-use-i386-i8253-h arch/x86_64/kernel/time.c
--- a/arch/x86/kernel/time_64.c~x86_64-use-i386-i8253-h
+++ a/arch/x86/kernel/time_64.c
@@ -32,7 +32,6 @@
 #include <acpi/achware.h>	/* for PM timer frequency */
 #include <acpi/acpi_bus.h>
 #endif
-#include <asm/8253pit.h>
 #include <asm/i8253.h>
 #include <asm/pgtable.h>
 #include <asm/vsyscall.h>
@@ -292,9 +291,6 @@ static unsigned int __init tsc_calibrate
 	return pmc_now * tsc_khz / (tsc_now - tsc_start);
 }
 
-#define PIT_MODE 0x43
-#define PIT_CH0  0x40
-
 static void __pit_init(int val, u8 mode)
 {
 	unsigned long flags;
diff -puN include/asm-x86_64/i8253.h~x86_64-use-i386-i8253-h include/asm-x86_64/i8253.h
--- a/include/asm-x86/i8253_64.h~x86_64-use-i386-i8253-h
+++ a/include/asm-x86/i8253_64.h
@@ -1,6 +1,2 @@
-#ifndef __ASM_I8253_H__
-#define __ASM_I8253_H__
-
-extern spinlock_t i8253_lock;
-
-#endif	/* __ASM_I8253_H__ */
+#include <asm-i386/i8253.h>
+#include <asm/8253pit.h>
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
