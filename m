From: akpm@linux-foundation.org
Subject: + i386-prepare-sharing-pit-code.patch added to -mm tree
Date: Fri, 24 Aug 2007 15:04:51 -0700
Message-ID: <200708242204.l7OM4p8f016990@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56633 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759125AbXHXWGS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 18:06:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, ak@suse.de, chrisw@sous-sol.org, mingo@elte.hu


The patch titled
     i386: prepare sharing the PIT code
has been added to the -mm tree.  Its filename is
     i386-prepare-sharing-pit-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
--- a/arch/i386/kernel/i8253.c~i386-prepare-sharing-pit-code
+++ a/arch/i386/kernel/i8253.c
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
--- a/include/asm-i386/i8253.h~i386-prepare-sharing-pit-code
+++ a/include/asm-i386/i8253.h
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
