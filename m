From: akpm@linux-foundation.org
Subject: + rtc-ab8500-dont-disable-irq-s-when-suspending.patch added to -mm tree
Date: Mon, 28 Nov 2011 15:12:47 -0800
Message-ID: <201111282312.pASNCle6023441@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:54185 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab1K1XMy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2011 18:12:54 -0500
Received: by ggnp2 with SMTP id p2so592222ggn.1
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2011 15:12:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: robert.marklund@stericsson.com, a.zummo@towertech.it, linus.walleij@linaro.org


The patch titled
     Subject: rtc/ab8500: don't disable IRQ:s when suspending
has been added to the -mm tree.  Its filename is
     rtc-ab8500-dont-disable-irq-s-when-suspending.patch

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
From: Robert Marklund <robert.marklund@stericsson.com>
Subject: rtc/ab8500: don't disable IRQ:s when suspending

We want this driver to be able to wake up the system.

Signed-off-by: Robert Marklund <robert.marklund@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ab8500.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-ab8500.c~rtc-ab8500-dont-disable-irq-s-when-suspending drivers/rtc/rtc-ab8500.c
--- a/drivers/rtc/rtc-ab8500.c~rtc-ab8500-dont-disable-irq-s-when-suspending
+++ a/drivers/rtc/rtc-ab8500.c
@@ -316,8 +316,8 @@ static int __devinit ab8500_rtc_probe(st
 		return err;
 	}
 
-	err = request_threaded_irq(irq, NULL, rtc_alarm_handler, 0,
-				   "ab8500-rtc", rtc);
+	err = request_threaded_irq(irq, NULL, rtc_alarm_handler,
+		IRQF_NO_SUSPEND, "ab8500-rtc", rtc);
 	if (err < 0) {
 		rtc_device_unregister(rtc);
 		return err;
_
Subject: Subject: rtc/ab8500: don't disable IRQ:s when suspending

Patches currently in -mm which might be from robert.marklund@stericsson.com are

rtc-ab8500-dont-disable-irq-s-when-suspending.patch

