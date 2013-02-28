From: akpm@linux-foundation.org
Subject: [merged] backlight-ams369fg06-make-power_on-call-optional.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:10:23 -0800
Message-ID: <20130228201023.B10635A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:65438 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381Ab3B1UKY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:10:24 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so244778yen.3
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:10:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/ams369fg06.c: make power_on() call optional
has been removed from the -mm tree.  Its filename was
     backlight-ams369fg06-make-power_on-call-optional.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/video/backlight/ams369fg06.c: make power_on() call optional

This patch makes power_on() call optional.  The voltage source can be
provided to some boards using ams369fg06 panel, thus in this case, power
on/off sequence is not necessary.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ams369fg06.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/video/backlight/ams369fg06.c~backlight-ams369fg06-make-power_on-call-optional drivers/video/backlight/ams369fg06.c
--- a/drivers/video/backlight/ams369fg06.c~backlight-ams369fg06-make-power_on-call-optional
+++ a/drivers/video/backlight/ams369fg06.c
@@ -317,10 +317,7 @@ static int ams369fg06_power_on(struct am
 	pd = lcd->lcd_pd;
 	bd = lcd->bd;
 
-	if (!pd->power_on) {
-		dev_err(lcd->dev, "power_on is NULL.\n");
-		return -EINVAL;
-	} else {
+	if (pd->power_on) {
 		pd->power_on(lcd->ld, 1);
 		msleep(pd->power_on_delay);
 	}
@@ -370,7 +367,8 @@ static int ams369fg06_power_off(struct a
 
 	msleep(pd->power_off_delay);
 
-	pd->power_on(lcd->ld, 0);
+	if (pd->power_on)
+		pd->power_on(lcd->ld, 0);
 
 	return 0;
 }
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
drivers-video-backlight-ams369fg06c-convert-ams369fg06-to-dev_pm_ops.patch
drivers-video-backlight-ams369fg06c-convert-ams369fg06-to-dev_pm_ops-fix.patch
backlight-platform_lcd-remove-unnecessary-ifdefs.patch
rtc-rtc-v3020-use-gpio_request_array.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

