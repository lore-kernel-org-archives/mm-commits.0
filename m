From: akpm@linux-foundation.org
Subject: [merged] rtc-handle-errors-correctly-in-rtc_irq_set_state.patch removed from -mm tree
Date: Wed, 27 Jul 2011 12:27:55 -0700
Message-ID: <201107271926.p6RJQfJu003136@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50167 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753438Ab1G0T1D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 15:27:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, greearb@candelatech.com, john.stultz@linaro.org, mingo@elte.hu, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     rtc: handle errors correctly in rtc_irq_set_state()
has been removed from the -mm tree.  Its filename was
     rtc-handle-errors-correctly-in-rtc_irq_set_state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: handle errors correctly in rtc_irq_set_state()
From: Thomas Gleixner <tglx@linutronix.de>

The code checks the correctness of the parameters, but unconditionally
arms/disarms the hrtimer.

The result is that a random task might arm/disarm rtc timer and surprise
the real owner by either generating events or by stopping them.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ben Greear <greearb@candelatech.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/interface.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/rtc/interface.c~rtc-handle-errors-correctly-in-rtc_irq_set_state drivers/rtc/interface.c
--- a/drivers/rtc/interface.c~rtc-handle-errors-correctly-in-rtc_irq_set_state
+++ a/drivers/rtc/interface.c
@@ -656,6 +656,8 @@ int rtc_irq_set_state(struct rtc_device 
 		err = -EBUSY;
 	if (rtc->irq_task != task)
 		err = -EACCES;
+	if (err)
+		goto out;
 
 	if (enabled) {
 		ktime_t period = ktime_set(0, NSEC_PER_SEC/rtc->irq_freq);
@@ -664,6 +666,7 @@ int rtc_irq_set_state(struct rtc_device 
 		hrtimer_cancel(&rtc->pie_timer);
 	}
 	rtc->pie_enabled = enabled;
+out:
 	spin_unlock_irqrestore(&rtc->irq_task_lock, flags);
 
 	return err;
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

