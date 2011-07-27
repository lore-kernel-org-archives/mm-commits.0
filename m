From: akpm@linux-foundation.org
Subject: [merged] rtc-limit-frequency.patch removed from -mm tree
Date: Wed, 27 Jul 2011 12:27:57 -0700
Message-ID: <201107271926.p6RJQhsT003139@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57527 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753935Ab1G0T1D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 15:27:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, greearb@candelatech.com, john.stultz@linaro.org, mingo@elte.hu, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     rtc: limit frequency
has been removed from the -mm tree.  Its filename was
     rtc-limit-frequency.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: limit frequency
From: Thomas Gleixner <tglx@linutronix.de>

Due to the hrtimer self rearming mode a user can DoS the machine simply
because it's starved by hrtimer events.

The RTC hrtimer is self rearming.  We really need to limit the frequency
to something sensible.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ben Greear <greearb@candelatech.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/interface.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/interface.c~rtc-limit-frequency drivers/rtc/interface.c
--- a/drivers/rtc/interface.c~rtc-limit-frequency
+++ a/drivers/rtc/interface.c
@@ -688,7 +688,7 @@ int rtc_irq_set_freq(struct rtc_device *
 	int err = 0;
 	unsigned long flags;
 
-	if (freq <= 0)
+	if (freq <= 0 || freq > 5000)
 		return -EINVAL;
 
 	spin_lock_irqsave(&rtc->irq_task_lock, flags);
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

