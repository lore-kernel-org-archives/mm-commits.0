From: akpm@linux-foundation.org
Subject: + clockevents-allow-build-without-runtime-use.patch added to -mm tree
Date: Fri, 24 Aug 2007 15:04:43 -0700
Message-ID: <200708242204.l7OM4icA016978@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50912 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757035AbXHXWGM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 18:06:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, ak@suse.de, johnstul@us.ibm.com, mingo@elte.hu


The patch titled
     clockevents: Allow build w/o run-tine usage for migration purposes
has been added to the -mm tree.  Its filename is
     clockevents-allow-build-without-runtime-use.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: clockevents: Allow build w/o run-tine usage for migration purposes
From: Thomas Gleixner <tglx@linutronix.de>

Migration aid to allow preparatory patches which introduce not yet used parts
of clock events code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/clockchips.h |    8 ++++++--
 kernel/time/Kconfig        |    5 +++++
 kernel/time/Makefile       |    2 +-
 kernel/time/clockevents.c  |    3 ++-
 4 files changed, 14 insertions(+), 4 deletions(-)

diff -puN include/linux/clockchips.h~clockevents-allow-build-without-runtime-use include/linux/clockchips.h
--- a/include/linux/clockchips.h~clockevents-allow-build-without-runtime-use
+++ a/include/linux/clockchips.h
@@ -8,7 +8,7 @@
 #ifndef _LINUX_CLOCKCHIPS_H
 #define _LINUX_CLOCKCHIPS_H
 
-#ifdef CONFIG_GENERIC_CLOCKEVENTS
+#ifdef CONFIG_GENERIC_CLOCKEVENTS_BUILD
 
 #include <linux/clocksource.h>
 #include <linux/cpumask.h>
@@ -126,9 +126,13 @@ extern int clockevents_register_notifier
 extern int clockevents_program_event(struct clock_event_device *dev,
 				     ktime_t expires, ktime_t now);
 
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
 extern void clockevents_notify(unsigned long reason, void *arg);
-
 #else
+# define clockevents_notify(reason, arg) do { } while (0)
+#endif
+
+#else /* CONFIG_GENERIC_CLOCKEVENTS_BUILD */
 
 #define clockevents_notify(reason, arg) do { } while (0)
 
diff -puN kernel/time/Kconfig~clockevents-allow-build-without-runtime-use kernel/time/Kconfig
--- a/kernel/time/Kconfig~clockevents-allow-build-without-runtime-use
+++ a/kernel/time/Kconfig
@@ -23,3 +23,8 @@ config HIGH_RES_TIMERS
 	  hardware is not capable then this option only increases
 	  the size of the kernel image.
 
+config GENERIC_CLOCKEVENTS_BUILD
+	bool
+	default y
+	depends on GENERIC_CLOCKEVENTS || GENERIC_CLOCKEVENTS_MIGR
+
diff -puN kernel/time/Makefile~clockevents-allow-build-without-runtime-use kernel/time/Makefile
--- a/kernel/time/Makefile~clockevents-allow-build-without-runtime-use
+++ a/kernel/time/Makefile
@@ -1,6 +1,6 @@
 obj-y += timekeeping.o ntp.o clocksource.o jiffies.o timer_list.o
 
-obj-$(CONFIG_GENERIC_CLOCKEVENTS)		+= clockevents.o
+obj-$(CONFIG_GENERIC_CLOCKEVENTS_BUILD)		+= clockevents.o
 obj-$(CONFIG_GENERIC_CLOCKEVENTS)		+= tick-common.o
 obj-$(CONFIG_GENERIC_CLOCKEVENTS_BROADCAST)	+= tick-broadcast.o
 obj-$(CONFIG_TICK_ONESHOT)			+= tick-oneshot.o
diff -puN kernel/time/clockevents.c~clockevents-allow-build-without-runtime-use kernel/time/clockevents.c
--- a/kernel/time/clockevents.c~clockevents-allow-build-without-runtime-use
+++ a/kernel/time/clockevents.c
@@ -194,6 +194,7 @@ void clockevents_exchange_device(struct 
 	local_irq_restore(flags);
 }
 
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
 /**
  * clockevents_notify - notification about relevant events
  */
@@ -222,4 +223,4 @@ void clockevents_notify(unsigned long re
 	spin_unlock(&clockevents_lock);
 }
 EXPORT_SYMBOL_GPL(clockevents_notify);
-
+#endif
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
