From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-cmosc-dont-disable-hpet-emulation-on-suspend.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:59:22 -0700
Message-ID: <20130430185922.8BD945A405D__12152.7727962986$1367348379$gmane$org@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:53656 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933465Ab3D3S7X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:59:23 -0400
Received: by mail-gg0-f201.google.com with SMTP id y3so87137ggc.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:59:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbasehore@chromium.org, hpa@zytor.com, maximlevitsky@gmail.com, mingo@elte.hu, rjw@sisk.pl, stable@vger.kernel.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-cmos.c: don't disable hpet emulation on suspend
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-cmosc-dont-disable-hpet-emulation-on-suspend.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Derek Basehore <dbasehore@chromium.org>
Subject: drivers/rtc/rtc-cmos.c: don't disable hpet emulation on suspend

There's a bug where rtc alarms are ignored after the rtc cmos suspends but
before the system finishes suspend.  Since hpet emulation is disabled and
it still handles the interrupts, a wake event is never registered which is
done from the rtc layer.

This patch reverts d1b2efa83fbf ("rtc: disable hpet emulation on suspend")
which disabled hpet emulation.  To fix the problem mentioned in that
commit, hpet_rtc_timer_init() is called directly on resume.

Signed-off-by: Derek Basehore <dbasehore@chromium.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-cmos.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-cmos.c~drivers-rtc-rtc-cmosc-dont-disable-hpet-emulation-on-suspend drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~drivers-rtc-rtc-cmosc-dont-disable-hpet-emulation-on-suspend
+++ a/drivers/rtc/rtc-cmos.c
@@ -804,9 +804,8 @@ static int cmos_suspend(struct device *d
 			mask = RTC_IRQMASK;
 		tmp &= ~mask;
 		CMOS_WRITE(tmp, RTC_CONTROL);
+		hpet_mask_rtc_irq_bit(mask);
 
-		/* shut down hpet emulation - we don't need it for alarm */
-		hpet_mask_rtc_irq_bit(RTC_PIE|RTC_AIE|RTC_UIE);
 		cmos_checkintr(cmos, tmp);
 	}
 	spin_unlock_irq(&rtc_lock);
@@ -870,6 +869,7 @@ static int cmos_resume(struct device *de
 			rtc_update_irq(cmos->rtc, 1, mask);
 			tmp &= ~RTC_AIE;
 			hpet_mask_rtc_irq_bit(RTC_AIE);
+			hpet_rtc_timer_init();
 		} while (mask & RTC_AIE);
 		spin_unlock_irq(&rtc_lock);
 	}
_

Patches currently in -mm which might be from dbasehore@chromium.org are

origin.patch

