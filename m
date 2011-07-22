From: akpm@linux-foundation.org
Subject: + rtc-fix-hrtimer-deadlock.patch added to -mm tree
Date: Fri, 22 Jul 2011 15:11:46 -0700
Message-ID: <201107222211.p6MMBk5M018076@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42093 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750956Ab1GVWMC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Jul 2011 18:12:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, greearb@candelatech.com, john.stultz@linaro.org, mingo@elte.hu, stable@kernel.org


The patch titled
     rtc: fix hrtimer deadlock
has been added to the -mm tree.  Its filename is
     rtc-fix-hrtimer-deadlock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long.patch
kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long-fix.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
x86-fix-mmap-random-address-range.patch
leds-new-pcengines-alix-system-driver-enables-leds-via-gpio-interface.patch
arch-x86-kernel-e820c-eliminate-bubble-sort-from-sanitize_e820_map.patch
x86-olpc-add-missing-elements-to-device-tree.patch
x86-olpc-move-cs5536-related-constants-to-cs5535h.patch
x86-olpc-rename-olpc-xo1-to-olpc-xo1-pm.patch
x86-olpc-add-xo-1-suspend-resume-support.patch
x86-olpc-add-xo-1-sci-driver-and-power-button-control.patch
x86-olpc-ec-sci-wakeup-mask-functionality.patch
x86-olpc-xo1-sci-add-gpe-handler-and-ebook-switch-functionality.patch
x86-olpc-xo1-sci-add-lid-switch-functionality.patch
x86-olpc-xo1-sci-propagate-power-supply-battery-events.patch
x86-olpc-add-xo-1-rtc-driver.patch
x86-olpc-add-xo-15-sci-driver.patch
genirq-fix-missing-parenthesises-in-generic-chip.patch
pci-make-the-struct-pci_dev-argument-of-pci_fixup_irqs-const.patch
cross-memory-attach-v3.patch
hpet-factor-timer-allocate-from-open.patch
maintainers-update-high-resolution-timers-patterns.patch
rtc-handle-errors-correctly-in-rtc_irq_set_state.patch
rtc-limit-frequency.patch
rtc-fix-hrtimer-deadlock.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

