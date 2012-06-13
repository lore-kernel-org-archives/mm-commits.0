From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-ab8500c-use-irqf_oneshot-when-requesting-a-threaded-irq.patch added to -mm tree
Date: Wed, 13 Jun 2012 15:26:27 -0700
Message-ID: <20120613222627.DB8A6A0137@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:54339 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836Ab2FMW0a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jun 2012 18:26:30 -0400
Received: by wgbdt11 with SMTP id dt11so62876wgb.1
        for <mm-commits@vger.kernel.org>; Wed, 13 Jun 2012 15:26:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lee.jones@linaro.org, a.zummo@towertech.it, stable@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-ab8500.c: use IRQF_ONESHOT when requesting a threaded IRQ
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-ab8500c-use-irqf_oneshot-when-requesting-a-threaded-irq.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lee Jones <lee.jones@linaro.org>
Subject: drivers/rtc/rtc-ab8500.c: use IRQF_ONESHOT when requesting a threaded IRQ

The kernel now forces IRQs to be ONESHOT if no IRQ handler is passed.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ab8500.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-ab8500.c~drivers-rtc-rtc-ab8500c-use-irqf_oneshot-when-requesting-a-threaded-irq drivers/rtc/rtc-ab8500.c
--- a/drivers/rtc/rtc-ab8500.c~drivers-rtc-rtc-ab8500c-use-irqf_oneshot-when-requesting-a-threaded-irq
+++ a/drivers/rtc/rtc-ab8500.c
@@ -422,7 +422,7 @@ static int __devinit ab8500_rtc_probe(st
 	}
 
 	err = request_threaded_irq(irq, NULL, rtc_alarm_handler,
-		IRQF_NO_SUSPEND, "ab8500-rtc", rtc);
+		IRQF_NO_SUSPEND | IRQF_ONESHOT, "ab8500-rtc", rtc);
 	if (err < 0) {
 		rtc_device_unregister(rtc);
 		return err;
_
Subject: Subject: drivers/rtc/rtc-ab8500.c: use IRQF_ONESHOT when requesting a threaded IRQ

Patches currently in -mm which might be from lee.jones@linaro.org are

linux-next.patch
drivers-rtc-rtc-ab8500c-use-irqf_oneshot-when-requesting-a-threaded-irq.patch

