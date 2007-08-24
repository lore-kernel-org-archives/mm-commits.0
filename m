From: akpm@linux-foundation.org
Subject: + x86_64-use-i386-i8253-h.patch added to -mm tree
Date: Fri, 24 Aug 2007 15:04:53 -0700
Message-ID: <200708242204.l7OM4rqo016993@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48036 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759152AbXHXWG2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 18:06:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, ak@suse.de, chrisw@sous-sol.org, johnstul@us.ibm.com, mingo@elte.hu


The patch titled
     i386: prepare sharing the PIT code
has been added to the -mm tree.  Its filename is
     x86_64-use-i386-i8253-h.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
--- a/arch/x86_64/kernel/time.c~x86_64-use-i386-i8253-h
+++ a/arch/x86_64/kernel/time.c
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
--- a/include/asm-x86_64/i8253.h~x86_64-use-i386-i8253-h
+++ a/include/asm-x86_64/i8253.h
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
