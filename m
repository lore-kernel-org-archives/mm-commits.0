From: akpm@linux-foundation.org
Subject: [merged]
 drivers-rtc-rtc-cmosc-fix-accidentally-enabling-rtc-channel.patch removed
 from -mm tree
Date: Thu, 13 Jun 2013 11:57:36 -0700
Message-ID: <51ba1620.JMLtTD9DeDaqVsAO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37050 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757091Ab3FMS5g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jun 2013 14:57:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dbasehore@chromium.org

Subject: [merged] drivers-rtc-rtc-cmosc-fix-accidentally-enabling-rtc-channel.patch removed from -mm tree
To: dbasehore@chromium.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 13 Jun 2013 11:57:36 -0700


The patch titled
     Subject: drivers/rtc/rtc-cmos.c: fix accidentally enabling rtc channel
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-cmosc-fix-accidentally-enabling-rtc-channel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Derek Basehore <dbasehore@chromium.org>
Subject: drivers/rtc/rtc-cmos.c: fix accidentally enabling rtc channel

During resume, we call hpet_rtc_timer_init after masking an irq bit in
hpet.  This will cause the call to hpet_disable_rtc_channel to be undone
if RTC_AIE is the only bit not masked.

Allowing the cmos interrupt handler to run before resuming caused some
issues where the timer for the alarm was not removed.  This would cause
other, later timers to not be cleared, so utilities such as hwclock would
time out when waiting for the update interrupt.

[akpm@linux-foundation.org: coding-style tweak]
Signed-off-by: Derek Basehore <dbasehore@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-cmos.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-cmos.c~drivers-rtc-rtc-cmosc-fix-accidentally-enabling-rtc-channel drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~drivers-rtc-rtc-cmosc-fix-accidentally-enabling-rtc-channel
+++ a/drivers/rtc/rtc-cmos.c
@@ -854,6 +854,9 @@ static int cmos_resume(struct device *de
 		}
 
 		spin_lock_irq(&rtc_lock);
+		if (device_may_wakeup(dev))
+			hpet_rtc_timer_init();
+
 		do {
 			CMOS_WRITE(tmp, RTC_CONTROL);
 			hpet_set_rtc_irq_bit(tmp & RTC_IRQMASK);
@@ -869,7 +872,6 @@ static int cmos_resume(struct device *de
 			rtc_update_irq(cmos->rtc, 1, mask);
 			tmp &= ~RTC_AIE;
 			hpet_mask_rtc_irq_bit(RTC_AIE);
-			hpet_rtc_timer_init();
 		} while (mask & RTC_AIE);
 		spin_unlock_irq(&rtc_lock);
 	}
_

Patches currently in -mm which might be from dbasehore@chromium.org are

origin.patch
drivers-rtc-rtc-cmosc-work-around-bios-clearing-rtc-control.patch

