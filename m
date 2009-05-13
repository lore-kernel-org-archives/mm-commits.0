From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-twl4030-dont-mask-alarm-interrupts-on-suspend.patch removed from -mm tree
Date: Wed, 13 May 2009 11:31:45 -0700
Message-ID: <200905131831.n4DIVjS4018508@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60514 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760539AbZEMSfo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 May 2009 14:35:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: q1.kim@samsung.com, a.zummo@towertech.it, david-b@pacbell.net, kyungmin.park@samsung.com, mm-commits@vger.kernel.org


The patch titled
     rtc: rtc-twl4030 don't mask alarm interrupts on suspend
has been removed from the -mm tree.  Its filename was
     rtc-rtc-twl4030-dont-mask-alarm-interrupts-on-suspend.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: rtc-twl4030 don't mask alarm interrupts on suspend
From: Kim Kyuwon <q1.kim@samsung.com>

This patch enables the alarm interrupt of TWL4030 RTC to wake up the
system from suspend. You can test this patch with following command.

# echo +10 > /sys/class/rtc/rtc0/wakealarm; echo mem > /sys/power/state;

Signed-off-by: Kim Kyuwon <q1.kim@samsung.com>
Acked-by: David Brownell <david-b@pacbell.net>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-twl4030.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-twl4030.c~rtc-rtc-twl4030-dont-mask-alarm-interrupts-on-suspend drivers/rtc/rtc-twl4030.c
--- a/drivers/rtc/rtc-twl4030.c~rtc-rtc-twl4030-dont-mask-alarm-interrupts-on-suspend
+++ a/drivers/rtc/rtc-twl4030.c
@@ -495,9 +495,7 @@ static int twl4030_rtc_suspend(struct pl
 {
 	irqstat = rtc_irq_bits;
 
-	/* REVISIT alarm may need to wake us from sleep */
-	mask_rtc_irq_bit(BIT_RTC_INTERRUPTS_REG_IT_TIMER_M |
-			 BIT_RTC_INTERRUPTS_REG_IT_ALARM_M);
+	mask_rtc_irq_bit(BIT_RTC_INTERRUPTS_REG_IT_TIMER_M);
 	return 0;
 }
 
_

Patches currently in -mm which might be from q1.kim@samsung.com are

origin.patch
leds-fix-led-bd2802-errors-while-resuming.patch
leds-change-the-license-information.patch
leds-add-the-sysfs-interface-into-the-leds-bd2802-driver-for-changing-wave-pattern-and-led-current.patch

