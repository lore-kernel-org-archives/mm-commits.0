From: akpm@linux-foundation.org
Subject: [merged] rtc-ab8500-set-uie_unsupported-flag.patch removed from
 -mm tree
Date: Thu, 11 Dec 2014 11:07:52 -0800
Message-ID: <5489eb88.Q6vtvo+WXbq5mcTe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46034 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756919AbaLKTHx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:07:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pang.xunlei@linaro.org, a.zummo@towertech.it, arnd.bergmann@linaro.org, john.stultz@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc/ab8500: set uie_unsupported flag
has been removed from the -mm tree.  Its filename was
     rtc-ab8500-set-uie_unsupported-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xunlei Pang <pang.xunlei@linaro.org>
Subject: rtc/ab8500: set uie_unsupported flag

Currently, ab8500 doesn't set uie_unsupported of rtc_device, while it
doesn't support UIE, see ab8500_rtc_set_alarm().

Thus, when going through rtc_update_irq_enable()->rtc_timer_enqueue(),
there's a chance it has an alarm timer1 queued before which is going to
fired, so this update timer2 will be queued because it isn't the leftmost
one, which means rtc_timer_enqueue() will return 0.

This will result in two problems:
1) UIE EMUL will not be used.
2) When the alarm timer1 is fired, in rtc_timer_do_work() timer2 will
   fail to set the alarm time, so this rtc will disfunctional due to
   timer2 with the earliest expires in the timerqueue.

So, rtc drivers must set this flag if they don't support UIE.

Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ab8500.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/rtc/rtc-ab8500.c~rtc-ab8500-set-uie_unsupported-flag drivers/rtc/rtc-ab8500.c
--- a/drivers/rtc/rtc-ab8500.c~rtc-ab8500-set-uie_unsupported-flag
+++ a/drivers/rtc/rtc-ab8500.c
@@ -504,6 +504,8 @@ static int ab8500_rtc_probe(struct platf
 		return err;
 	}
 
+	rtc->uie_unsupported = 1;
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from pang.xunlei@linaro.org are

origin.patch

