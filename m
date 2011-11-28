From: akpm@linux-foundation.org
Subject: + rtc-ab8500-set-can_wake-flag.patch added to -mm tree
Date: Mon, 28 Nov 2011 15:12:56 -0800
Message-ID: <201111282312.pASNCvJ1005392@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:59595 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab1K1XNA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2011 18:13:00 -0500
Received: by eeuu44 with SMTP id u44so49890eeu.1
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2011 15:12:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andrew.lynn@stericsson.com, a.zummo@towertech.it, jonas.aberg@stericsson.com, linus.walleij@linaro.org


The patch titled
     Subject: rtc/ab8500: set can_wake flag
has been added to the -mm tree.  Its filename is
     rtc-ab8500-set-can_wake-flag.patch

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
From: Andrew Lynn <andrew.lynn@stericsson.com>
Subject: rtc/ab8500: set can_wake flag

Set can_wake flag so wakealarm property is visible in sysfs.

Signed-off-by: Andrew Lynn <andrew.lynn@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ab8500.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/rtc/rtc-ab8500.c~rtc-ab8500-set-can_wake-flag drivers/rtc/rtc-ab8500.c
--- a/drivers/rtc/rtc-ab8500.c~rtc-ab8500-set-can_wake-flag
+++ a/drivers/rtc/rtc-ab8500.c
@@ -308,6 +308,8 @@ static int __devinit ab8500_rtc_probe(st
 		return -ENODEV;
 	}
 
+	device_init_wakeup(&pdev->dev, true);
+
 	rtc = rtc_device_register("ab8500-rtc", &pdev->dev, &ab8500_rtc_ops,
 			THIS_MODULE);
 	if (IS_ERR(rtc)) {
_
Subject: Subject: rtc/ab8500: set can_wake flag

Patches currently in -mm which might be from andrew.lynn@stericsson.com are

rtc-ab8500-set-can_wake-flag.patch

