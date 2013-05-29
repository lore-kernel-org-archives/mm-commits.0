From: akpm@linux-foundation.org
Subject: +
 drivers-rtc-rtc-cmosc-fix-accidentally-enabling-rtc-channel.patch added to
 -mm tree
Date: Wed, 29 May 2013 12:27:50 -0700
Message-ID: <51a656b6.dU0Wz/7PjIWHgxiv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49809 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965341Ab3E2T1v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 May 2013 15:27:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dbasehore@chromium.org

Subject: + drivers-rtc-rtc-cmosc-fix-accidentally-enabling-rtc-channel.patch added to -mm tree
To: dbasehore@chromium.org
From: akpm@linux-foundation.org
Date: Wed, 29 May 2013 12:27:50 -0700


The patch titled
     Subject: drivers/rtc/rtc-cmos.c: fix accidentally enabling rtc channel
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-cmosc-fix-accidentally-enabling-rtc-channel.patch

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
Subject: drivers/rtc/rtc-cmos.c: fix accidentally enabling rtc channel

During resume, we call hpet_rtc_timer_init after masking an irq bit in
hpet.  This will cause the call to hpet_disable_rtc_channel to be undone
if RTC_AIE is the only bit not masked.

Signed-off-by: Derek Basehore <dbasehore@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-cmos.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-cmos.c~rtc-cmos-fix-accidentally-enabling-rtc-channel drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-cmos-fix-accidentally-enabling-rtc-channel
+++ a/drivers/rtc/rtc-cmos.c
@@ -854,6 +854,10 @@ static int cmos_resume(struct device *de
 		}
 
 		spin_lock_irq(&rtc_lock);
+		if (device_may_wakeup(dev)) {
+			hpet_rtc_timer_init();
+		}
+
 		do {
 			CMOS_WRITE(tmp, RTC_CONTROL);
 			hpet_set_rtc_irq_bit(tmp & RTC_IRQMASK);
@@ -869,7 +873,6 @@ static int cmos_resume(struct device *de
 			rtc_update_irq(cmos->rtc, 1, mask);
 			tmp &= ~RTC_AIE;
 			hpet_mask_rtc_irq_bit(RTC_AIE);
-			hpet_rtc_timer_init();
 		} while (mask & RTC_AIE);
 		spin_unlock_irq(&rtc_lock);
 	}
_

Patches currently in -mm which might be from dbasehore@chromium.org are

drivers-rtc-rtc-cmosc-fix-accidentally-enabling-rtc-channel.patch

