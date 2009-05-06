From: akpm@linux-foundation.org
Subject: [merged] time-avoid-possible-endless-loop-when-using-jiffies-clocksource-and-oneshot-mode-clockevent.patch removed from -mm tree
Date: Wed, 06 May 2009 13:47:33 -0700
Message-ID: <200905062047.n46KlXVQ011108@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54571 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759499AbZEFUv6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 May 2009 16:51:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johnstul@us.ibm.com, elendil@planet.nl, schwidefsky@de.ibm.com, tglx@linutronix.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     time: avoid possible endless loop when using jiffies clocksource and ONESHOT mode clockevent
has been removed from the -mm tree.  Its filename was
     time-avoid-possible-endless-loop-when-using-jiffies-clocksource-and-oneshot-mode-clockevent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: time: avoid possible endless loop when using jiffies clocksource and ONESHOT mode clockevent
From: john stultz <johnstul@us.ibm.com>

Avoid an endless loop issue by requiring that a highres valid clocksource
be installed before we call tick_periodic() in a loop when using ONESHOT
mode.  The result is we will only increment jiffies once per interrupt
until a continuous hardware clocksource is available.

Without this, we can run into a endless loop, where each cycle through the
loop, jiffies is updated which increments time by tick_period or more (due
to clock steering), which can cause the event programming to think the
next event was before the newly incremented time and fail causing
tick_periodic() to be called again and the whole process loops forever.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Frans Pop <elendil@planet.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/tick-common.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN kernel/time/tick-common.c~time-avoid-possible-endless-loop-when-using-jiffies-clocksource-and-oneshot-mode-clockevent kernel/time/tick-common.c
--- a/kernel/time/tick-common.c~time-avoid-possible-endless-loop-when-using-jiffies-clocksource-and-oneshot-mode-clockevent
+++ a/kernel/time/tick-common.c
@@ -94,7 +94,17 @@ void tick_handle_periodic(struct clock_e
 	for (;;) {
 		if (!clockevents_program_event(dev, next, ktime_get()))
 			return;
-		tick_periodic(cpu);
+		/*
+		 * Have to be careful here. If we're in oneshot mode,
+		 * before we call tick_periodic() in a loop, we need
+		 * to be sure we're using a real hardware clocksource.
+		 * Otherwise we could get trapped in an infinite
+		 * loop, as the tick_periodic() increments jiffies,
+		 * when then will increment time, posibly causing
+		 * the loop to trigger again and again.
+		 */
+		if (timekeeping_valid_for_hres())
+			tick_periodic(cpu);
 		next = ktime_add(next, tick_period);
 	}
 }
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

origin.patch
linux-next.patch
time-move-calc_load-call-out-from-xtime_lock-protection.patch
clockevent-export-register_device-and-delta2ns.patch
ntp-adjust-shift_pll-to-improve-ntp-convergence.patch
clocksource-sanity-check-sysfs-clocksource-changes.patch

