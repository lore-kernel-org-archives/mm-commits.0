From: akpm@linux-foundation.org
Subject: - clockevents-allow-build-without-runtime-use.patch removed from -mm tree
Date: Mon, 15 Oct 2007 02:17:49 -0700
Message-ID: <200710150917.l9F9Hn7U027316@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51507 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759579AbXJOJS4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 05:18:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, ak@suse.de, johnstul@us.ibm.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     clockevents: Allow build w/o run-tine usage for migration purposes
has been removed from the -mm tree.  Its filename was
     clockevents-allow-build-without-runtime-use.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
