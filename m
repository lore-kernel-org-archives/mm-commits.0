From: akpm@linux-foundation.org
Subject: [merged] rtc-fix-hrtimer-deadlock.patch removed from -mm tree
Date: Wed, 27 Jul 2011 12:27:59 -0700
Message-ID: <201107271926.p6RJQjjO003142@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46844 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754217Ab1G0T1E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 15:27:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, greearb@candelatech.com, john.stultz@linaro.org, mingo@elte.hu, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     rtc: fix hrtimer deadlock
has been removed from the -mm tree.  Its filename was
     rtc-fix-hrtimer-deadlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: fix hrtimer deadlock
From: Thomas Gleixner <tglx@linutronix.de>

Ben reported a lockup related to rtc. The lockup happens due to:

CPU0                                        CPU1

rtc_irq_set_state()			    __run_hrtimer()
  spin_lock_irqsave(&rtc->irq_task_lock)    rtc_handle_legacy_irq();
					      spin_lock(&rtc->irq_task_lock);
  hrtimer_cancel()
    while (callback_running);

So the running callback never finishes as it's blocked on
rtc->irq_task_lock.

Use hrtimer_try_to_cancel() instead and drop rtc->irq_task_lock while
waiting for the callback.  Fix this for both rtc_irq_set_state() and
rtc_irq_set_freq().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reported-by: Ben Greear <greearb@candelatech.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/interface.c |   56 +++++++++++++++++++++++++-------------
 1 file changed, 37 insertions(+), 19 deletions(-)

diff -puN drivers/rtc/interface.c~rtc-fix-hrtimer-deadlock drivers/rtc/interface.c
--- a/drivers/rtc/interface.c~rtc-fix-hrtimer-deadlock
+++ a/drivers/rtc/interface.c
@@ -636,6 +636,29 @@ void rtc_irq_unregister(struct rtc_devic
 }
 EXPORT_SYMBOL_GPL(rtc_irq_unregister);
 
+static int rtc_update_hrtimer(struct rtc_device *rtc, int enabled)
+{
+	/*
+	 * We unconditionally cancel the timer here, because otherwise
+	 * we could run into BUG_ON(timer->state != HRTIMER_STATE_CALLBACK);
+	 * when we manage to start the timer before the callback
+	 * returns HRTIMER_RESTART.
+	 *
+	 * We cannot use hrtimer_cancel() here as a running callback
+	 * could be blocked on rtc->irq_task_lock and hrtimer_cancel()
+	 * would spin forever.
+	 */
+	if (hrtimer_try_to_cancel(&rtc->pie_timer) < 0)
+		return -1;
+
+	if (enabled) {
+		ktime_t period = ktime_set(0, NSEC_PER_SEC / rtc->irq_freq);
+
+		hrtimer_start(&rtc->pie_timer, period, HRTIMER_MODE_REL);
+	}
+	return 0;
+}
+
 /**
  * rtc_irq_set_state - enable/disable 2^N Hz periodic IRQs
  * @rtc: the rtc device
@@ -651,24 +674,21 @@ int rtc_irq_set_state(struct rtc_device 
 	int err = 0;
 	unsigned long flags;
 
+retry:
 	spin_lock_irqsave(&rtc->irq_task_lock, flags);
 	if (rtc->irq_task != NULL && task == NULL)
 		err = -EBUSY;
 	if (rtc->irq_task != task)
 		err = -EACCES;
-	if (err)
-		goto out;
-
-	if (enabled) {
-		ktime_t period = ktime_set(0, NSEC_PER_SEC/rtc->irq_freq);
-		hrtimer_start(&rtc->pie_timer, period, HRTIMER_MODE_REL);
-	} else {
-		hrtimer_cancel(&rtc->pie_timer);
+	if (!err) {
+		if (rtc_update_hrtimer(rtc, enabled) < 0) {
+			spin_unlock_irqrestore(&rtc->irq_task_lock, flags);
+			cpu_relax();
+			goto retry;
+		}
+		rtc->pie_enabled = enabled;
 	}
-	rtc->pie_enabled = enabled;
-out:
 	spin_unlock_irqrestore(&rtc->irq_task_lock, flags);
-
 	return err;
 }
 EXPORT_SYMBOL_GPL(rtc_irq_set_state);
@@ -690,20 +710,18 @@ int rtc_irq_set_freq(struct rtc_device *
 
 	if (freq <= 0 || freq > 5000)
 		return -EINVAL;
-
+retry:
 	spin_lock_irqsave(&rtc->irq_task_lock, flags);
 	if (rtc->irq_task != NULL && task == NULL)
 		err = -EBUSY;
 	if (rtc->irq_task != task)
 		err = -EACCES;
-	if (err == 0) {
+	if (!err) {
 		rtc->irq_freq = freq;
-		if (rtc->pie_enabled) {
-			ktime_t period;
-			hrtimer_cancel(&rtc->pie_timer);
-			period = ktime_set(0, NSEC_PER_SEC/rtc->irq_freq);
-			hrtimer_start(&rtc->pie_timer, period,
-					HRTIMER_MODE_REL);
+		if (rtc->pie_enabled && rtc_update_hrtimer(rtc, 1) < 0) {
+			spin_unlock_irqrestore(&rtc->irq_task_lock, flags);
+			cpu_relax();
+			goto retry;
 		}
 	}
 	spin_unlock_irqrestore(&rtc->irq_task_lock, flags);
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
linux-next.patch
kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long.patch
kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long-fix.patch
x86-fix-mmap-random-address-range.patch
leds-new-pcengines-alix-system-driver-enables-leds-via-gpio-interface.patch
arch-x86-kernel-e820c-eliminate-bubble-sort-from-sanitize_e820_map.patch
genirq-fix-missing-parenthesises-in-generic-chip.patch
cross-memory-attach-v3.patch
hpet-factor-timer-allocate-from-open.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

