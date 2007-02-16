From: akpm@linux-foundation.org
Subject: - hrtimers-namespace-and-enum-cleanup-vs-git-input.patch removed from -mm tree
Date: Fri, 16 Feb 2007 00:17:27 -0800
Message-ID: <200702160817.l1G8HRCB024320@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59480 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbXBPIRt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 03:17:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dtor@mail.ru, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     hrtimers: namespace and enum cleanup vs. git-input
has been removed from the -mm tree.  Its filename was
     hrtimers-namespace-and-enum-cleanup-vs-git-input.patch

This patch was dropped because it was folded into hrtimers-namespace-and-enum-cleanup.patch

------------------------------------------------------
Subject: hrtimers: namespace and enum cleanup vs. git-input
From: Andrew Morton <akpm@osdl.org>

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/input/touchscreen/ads7846.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

Index: linux-2.6.20-rc6-mm/drivers/input/touchscreen/ads7846.c
===================================================================
--- linux-2.6.20-rc6-mm.orig/drivers/input/touchscreen/ads7846.c
+++ linux-2.6.20-rc6-mm/drivers/input/touchscreen/ads7846.c
@@ -546,7 +546,7 @@ static void ads7846_rx(void *ads)
 			ts->spi->dev.bus_id, ts->tc.ignore, Rt);
 #endif
 		hrtimer_start(&ts->timer, ktime_set(0, TS_POLL_PERIOD),
-			      HRTIMER_REL);
+			      HRTIMER_MODE_REL);
 		return;
 	}
 
@@ -578,7 +578,8 @@ static void ads7846_rx(void *ads)
 #endif
 	}
 
-	hrtimer_start(&ts->timer, ktime_set(0, TS_POLL_PERIOD), HRTIMER_REL);
+	hrtimer_start(&ts->timer, ktime_set(0, TS_POLL_PERIOD),
+			HRTIMER_MODE_REL);
 }
 
 static int ads7846_debounce(void *ads, int data_idx, int *val)
@@ -667,7 +668,7 @@ static void ads7846_rx_val(void *ads)
 				status);
 }
 
-static int ads7846_timer(struct hrtimer *handle)
+static enum hrtimer_restart ads7846_timer(struct hrtimer *handle)
 {
 	struct ads7846	*ts = container_of(handle, struct ads7846, timer);
 	int		status = 0;
@@ -724,7 +725,7 @@ static irqreturn_t ads7846_irq(int irq, 
 			disable_irq(ts->spi->irq);
 			ts->pending = 1;
 			hrtimer_start(&ts->timer, ktime_set(0, TS_POLL_DELAY),
-					HRTIMER_REL);
+					HRTIMER_MODE_REL);
 		}
 	}
 	spin_unlock_irqrestore(&ts->lock, flags);
@@ -862,7 +863,7 @@ static int __devinit ads7846_probe(struc
 	ts->spi = spi;
 	ts->input = input_dev;
 
-	hrtimer_init(&ts->timer, CLOCK_MONOTONIC, HRTIMER_REL);
+	hrtimer_init(&ts->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	ts->timer.function = ads7846_timer;
 
 	spin_lock_init(&ts->lock);

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
vmi-versus-hrtimers.patch
add-a-functions-to-handle-interrupt-affinity-setting.patch
i386-use-gtod-persistent-clock-support.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-namespace-and-enum-cleanup-vs-git-input.patch
hrtimers-cleanup-locking.patch
hrtimers-add-state-tracking.patch
clockevents-i383-drivers.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
revert-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-fix.patch
reapply-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-convert-x86_64-to-use-generic_time-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
