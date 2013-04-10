From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-cmosc-dont-disable-hpet-emulation-on-suspend.patch added to -mm tree
Date: Wed, 10 Apr 2013 16:58:23 -0700
Message-ID: <20130410235823.976C731C1FE__36149.171277839$1365638310$gmane$org@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:48691 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937220Ab3DJX6Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Apr 2013 19:58:25 -0400
Received: by mail-ob0-f202.google.com with SMTP id va7so256561obc.5
        for <mm-commits@vger.kernel.org>; Wed, 10 Apr 2013 16:58:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbasehore@chromium.org, hpa@zytor.com, maximlevitsky@gmail.com, mingo@elte.hu, rjw@sisk.pl, stable@vger.kernel.org, tglx@linutronix.de


The patch titled
     Subject: drivers/rtc/rtc-cmos.c: don't disable hpet emulation on suspend
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-cmosc-dont-disable-hpet-emulation-on-suspend.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

drivers-rtc-rtc-cmosc-dont-disable-hpet-emulation-on-suspend.patch

