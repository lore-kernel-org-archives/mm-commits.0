From: akpm@linux-foundation.org
Subject: + rtc-disable-hpet-emulation-on-suspend.patch added to -mm tree
Date: Tue, 13 Oct 2009 15:08:03 -0700
Message-ID: <200910132208.n9DM83xa031357@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40933 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760915AbZJMWJY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Oct 2009 18:09:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maximlevitsky@gmail.com, david-b@pacbell.net, hpa@zytor.com, mingo@elte.hu, rjw@sisk.pl, tglx@linutronix.de


The patch titled
     rtc: disable hpet emulation on suspend
has been added to the -mm tree.  Its filename is
     rtc-disable-hpet-emulation-on-suspend.patch

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
Subject: rtc: disable hpet emulation on suspend
From: Maxim Levitsky <maximlevitsky@gmail.com>

I noticed that rtc wont generate interrupts after a resume from disk.
Here hpet rtc emulation is used.

Problem is that rtc hpet comparator, isn't reinitialized after resume.
Easiest way to solve this, is always mask all hpet interrupts on suspend
This is triggered, when suspending with alarm set.


Otherwise, hpet driver will think it doesn't need to reinitialize
the rtc comparator, thus rtc interrupts won't work.

This emulation isn't need for wakealarm.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/rtc/rtc-cmos.c~rtc-disable-hpet-emulation-on-suspend drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-disable-hpet-emulation-on-suspend
+++ a/drivers/rtc/rtc-cmos.c
@@ -871,8 +871,9 @@ static int cmos_suspend(struct device *d
 			mask = RTC_IRQMASK;
 		tmp &= ~mask;
 		CMOS_WRITE(tmp, RTC_CONTROL);
-		hpet_mask_rtc_irq_bit(mask);
 
+		/* shut down hpet emulation - we don't need it for alarm */
+		hpet_mask_rtc_irq_bit(RTC_PIE|RTC_AIE|RTC_UIE);
 		cmos_checkintr(cmos, tmp);
 	}
 	spin_unlock_irq(&rtc_lock);
_

Patches currently in -mm which might be from maximlevitsky@gmail.com are

rtc-disable-hpet-emulation-on-suspend.patch

