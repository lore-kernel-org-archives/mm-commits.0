From: akpm@linux-foundation.org
Subject: + rtc-rtc-88pm80x-remove-unnecessary-platform_set_drvdata.patch added to -mm tree
Date: Tue, 07 May 2013 15:22:23 -0700
Message-ID: <20130507222223.C52FB5A4016@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:46229 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab3EGWWY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 18:22:24 -0400
Received: by mail-vb0-f74.google.com with SMTP id q16so119789vbe.1
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 15:22:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com


The patch titled
     Subject: rtc: rtc-88pm80x: remove unnecessary platform_set_drvdata()
has been added to the -mm tree.  Its filename is
     rtc-rtc-88pm80x-remove-unnecessary-platform_set_drvdata.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-88pm80x: remove unnecessary platform_set_drvdata()

The driver core clears the driver data to NULL after device_release or on
probe failure, since commit 0998d063100 ("device-core: Ensure drvdata =
NULL when no driver is bound").  Thus, it is not needed to manually clear
the device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-88pm80x.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/rtc/rtc-88pm80x.c~rtc-rtc-88pm80x-remove-unnecessary-platform_set_drvdata drivers/rtc/rtc-88pm80x.c
--- a/drivers/rtc/rtc-88pm80x.c~rtc-rtc-88pm80x-remove-unnecessary-platform_set_drvdata
+++ a/drivers/rtc/rtc-88pm80x.c
@@ -345,7 +345,6 @@ out:
 static int pm80x_rtc_remove(struct platform_device *pdev)
 {
 	struct pm80x_rtc_info *info = platform_get_drvdata(pdev);
-	platform_set_drvdata(pdev, NULL);
 	pm80x_free_irq(info->chip, info->irq, info);
 	return 0;
 }
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
backlight-atmel-pwm-bl-remove-unnecessary-platform_set_drvdata.patch
backlight-ep93xx-remove-unnecessary-platform_set_drvdata.patch
backlight-lp8788-remove-unnecessary-platform_set_drvdata.patch
backlight-pcf50633-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-88pm80x-remove-unnecessary-platform_set_drvdata.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch

