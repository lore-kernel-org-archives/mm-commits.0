From: akpm@linux-foundation.org
Subject: - ich-force-hpet-make-generic-time-capable-of-switching-broadcast-timer.patch removed from -mm tree
Date: Thu, 19 Jul 2007 12:48:46 -0700
Message-ID: <200707191948.l6JJmlp8018929@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41661 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764006AbXGSTtn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 15:49:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: venkatesh.pallipadi@intel.com, ak@suse.de, greg@kroah.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     ICH Force HPET: make generic time capable of switching broadcast timer
has been removed from the -mm tree.  Its filename was
     ich-force-hpet-make-generic-time-capable-of-switching-broadcast-timer.patch

This patch was dropped because Changes in Andi's tree destroyed this patch series

------------------------------------------------------
Subject: ICH Force HPET: make generic time capable of switching broadcast timer
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>

Auto-detect the presence of HPET on ICH5 or newer platforms and enable HPET
for broadcast timer.  This gives a bigger upperlimit for tickless time tick
and improves the power consumption in comparison to PIT as broadcast timer.

This patch:

Change the broadcast timer, if a timer with higher rating becomes available.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/tick-broadcast.c |   13 ++++++-------
 kernel/time/tick-common.c    |    4 ++--
 2 files changed, 8 insertions(+), 9 deletions(-)

diff -puN kernel/time/tick-broadcast.c~ich-force-hpet-make-generic-time-capable-of-switching-broadcast-timer kernel/time/tick-broadcast.c
--- a/kernel/time/tick-broadcast.c~ich-force-hpet-make-generic-time-capable-of-switching-broadcast-timer
+++ a/kernel/time/tick-broadcast.c
@@ -64,8 +64,9 @@ static void tick_broadcast_start_periodi
  */
 int tick_check_broadcast_device(struct clock_event_device *dev)
 {
-	if (tick_broadcast_device.evtdev ||
-	    (dev->features & CLOCK_EVT_FEAT_C3STOP))
+	if ((tick_broadcast_device.evtdev &&
+	     tick_broadcast_device.evtdev->rating >= dev->rating) ||
+	     (dev->features & CLOCK_EVT_FEAT_C3STOP))
 		return 0;
 
 	clockevents_exchange_device(NULL, dev);
@@ -519,11 +520,9 @@ static void tick_broadcast_clear_oneshot
  */
 void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 {
-	if (bc->mode != CLOCK_EVT_MODE_ONESHOT) {
-		bc->event_handler = tick_handle_oneshot_broadcast;
-		clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
-		bc->next_event.tv64 = KTIME_MAX;
-	}
+	bc->event_handler = tick_handle_oneshot_broadcast;
+	clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
+	bc->next_event.tv64 = KTIME_MAX;
 }
 
 /*
diff -puN kernel/time/tick-common.c~ich-force-hpet-make-generic-time-capable-of-switching-broadcast-timer kernel/time/tick-common.c
--- a/kernel/time/tick-common.c~ich-force-hpet-make-generic-time-capable-of-switching-broadcast-timer
+++ a/kernel/time/tick-common.c
@@ -200,7 +200,7 @@ static int tick_check_new_device(struct 
 
 	cpu = smp_processor_id();
 	if (!cpu_isset(cpu, newdev->cpumask))
-		goto out;
+		goto out_bc;
 
 	td = &per_cpu(tick_cpu_device, cpu);
 	curdev = td->evtdev;
@@ -265,7 +265,7 @@ out_bc:
 	 */
 	if (tick_check_broadcast_device(newdev))
 		ret = NOTIFY_STOP;
-out:
+
 	spin_unlock_irqrestore(&tick_device_lock, flags);
 
 	return ret;
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

origin.patch
git-acpi.patch
cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default-fix.patch
x86_64-block-irq-balancing-for-timer.patch
ich-force-hpet-make-generic-time-capable-of-switching-broadcast-timer.patch
ich-force-hpet-restructure-hpet-generic-clock-code.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch
ich-force-hpet-late-initialization-of-hpet-after-quirk.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
ich-force-hpet-ich5-fix-a-bug-with-suspend-resume.patch
ich-force-hpet-add-ich7_0-pciid-to-quirk-list.patch
