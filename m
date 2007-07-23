From: akpm@linux-foundation.org
Subject: - clockevents-fix-device-replacement.patch removed from -mm tree
Date: Mon, 23 Jul 2007 02:34:02 -0700
Message-ID: <200707230934.l6N9Y2jh016349@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60877 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759131AbXGWJpw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 05:45:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, johnstul@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     clockevents: fix device replacement
has been removed from the -mm tree.  Its filename was
     clockevents-fix-device-replacement.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 28 insertions(+), 1 deletion(-)

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

git-acpi.patch
acpi-move-timer-broadcast-and-pmtimer-access-before-c3-arbiter-shutdown.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
acpi-remove-the-useless-ifdef-code.patch
x86_64-hpet-restore-vread.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-block-irq-balancing-for-timer.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
geode-mfgpt-clock-event-device-support.patch
whitespace-fixes-time-syscalls.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
