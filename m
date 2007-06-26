From: akpm@linux-foundation.org
Subject: + clockevents-fix-device-replacement.patch added to -mm tree
Date: Mon, 25 Jun 2007 17:07:34 -0700
Message-ID: <200706260007.l5Q07YCZ014418@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40768 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755380AbXFZAIX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 20:08:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, johnstul@us.ibm.com


The patch titled
     clockevents: fix device replacement
has been added to the -mm tree.  Its filename is
     clockevents-fix-device-replacement.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: clockevents: fix device replacement
From: Thomas Gleixner <tglx@linutronix.de>

When a device is replaced by a better rated device, then the broadcast
mode needs to be evaluated again. When the new device has no requirement
for broadcasting, then the broadcast bits for the CPU must be cleared.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/tick-broadcast.c |   29 ++++++++++++++++++++++++++++-
 1 files changed, 28 insertions(+), 1 deletion(-)

diff -puN kernel/time/tick-broadcast.c~clockevents-fix-device-replacement kernel/time/tick-broadcast.c
--- a/kernel/time/tick-broadcast.c~clockevents-fix-device-replacement
+++ a/kernel/time/tick-broadcast.c
@@ -31,6 +31,12 @@ struct tick_device tick_broadcast_device
 static cpumask_t tick_broadcast_mask;
 static DEFINE_SPINLOCK(tick_broadcast_lock);
 
+#ifdef CONFIG_TICK_ONESHOT
+static void tick_broadcast_clear_oneshot(int cpu);
+#else
+static inline void tick_broadcast_clear_oneshot(int cpu) { }
+#endif
+
 /*
  * Debugging: see timer_list.c
  */
@@ -99,8 +105,19 @@ int tick_device_uses_broadcast(struct cl
 		cpu_set(cpu, tick_broadcast_mask);
 		tick_broadcast_start_periodic(tick_broadcast_device.evtdev);
 		ret = 1;
-	}
+	} else {
+		/*
+		 * When the new device is not affected by the stop
+		 * feature and the cpu is marked in the broadcast mask
+		 * then clear the broadcast bit.
+		 */
+		if (!(dev->features & CLOCK_EVT_FEAT_C3STOP)) {
+			int cpu = smp_processor_id();
 
+			cpu_clear(cpu, tick_broadcast_mask);
+			tick_broadcast_clear_oneshot(cpu);
+		}
+	}
 	spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 	return ret;
 }
@@ -487,6 +504,16 @@ out:
 	spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 }
 
+/*
+ * Reset the one shot broadcast for a cpu
+ *
+ * Called with tick_broadcast_lock held
+ */
+static void tick_broadcast_clear_oneshot(int cpu)
+{
+	cpu_clear(cpu, tick_broadcast_oneshot_mask);
+}
+
 /**
  * tick_broadcast_setup_highres - setup the broadcast device for highres
  */
_

Patches currently in -mm which might be from tglx@linutronix.de are

git-acpi-add-exports.patch
git-arm.patch
i386-hpet-check-if-the-counter-works.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
acpi-move-timer-broadcast-and-pmtimer-access-before-c3-arbiter-shutdown.patch
timekeeping-fixup-shadow-variable-argument.patch
timerc-cleanup-recently-introduced-whitespace-damage.patch
clockevents-remove-prototypes-of-removed-functions.patch
clockevents-fix-resume-logic.patch
clockevents-fix-device-replacement.patch
tick-management-spread-timer-interrupt.patch
highres-improve-debug-output.patch
hrtimer-speedup-hrtimer_enqueue.patch
pcspkr-use-the-global-pit-lock.patch
ntp-move-the-cmos-update-code-into-ntpc.patch
i386-pit-stop-only-when-in-periodic-or-oneshot-mode.patch
i386-remove-volatile-in-apicc.patch
i386-hpet-assumes-boot-cpu-is-0.patch
i386-move-pit-function-declarations-and-constants-to-correct-header-file.patch
x86_64-untangle-asm-hpeth-from-asm-timexh.patch
x86_64-use-generic-cmos-update.patch
x86_64-remove-dead-code-and-other-janitor-work-in-tscc.patch
x86_64-fix-apic-typo.patch
x86_64-convert-to-cleckevents.patch
acpi-remove-the-useless-ifdef-code.patch
x86_64-hpet-restore-vread.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-block-irq-balancing-for-timer.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
remove-clockevents_releaserequest_device.patch
add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats.patch
improve-behaviour-of-spurious-irq-detect.patch
improve-behaviour-of-spurious-irq-detect-fix.patch
sys_time-speedup.patch
lguest-the-host-code.patch
