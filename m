From: akpm@linux-foundation.org
Subject: + rtc-rtc-max6902-set-driver-data-in-max6902_probe.patch added to -mm tree
Date: Tue, 11 Jan 2011 23:37:18 -0800
Message-ID: <201101120739.p0C7dkwR032638@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51808 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754313Ab1ALHkM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Jan 2011 02:40:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, a.zummo@towertech.it


The patch titled
     rtc: rtc-max6902 - set driver data in max6902_probe()
has been added to the -mm tree.  Its filename is
     rtc-rtc-max6902-set-driver-data-in-max6902_probe.patch

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
Subject: rtc: rtc-max6902 - set driver data in max6902_probe()
From: Axel Lin <axel.lin@gmail.com>

Current implementation does not set driver data in max6902_probe(), thus
calling platform_get_drvdata(spi) in max6902_remove() returns NULL.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max6902.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-max6902.c~rtc-rtc-max6902-set-driver-data-in-max6902_probe drivers/rtc/rtc-max6902.c
--- a/drivers/rtc/rtc-max6902.c~rtc-rtc-max6902-set-driver-data-in-max6902_probe
+++ a/drivers/rtc/rtc-max6902.c
@@ -139,12 +139,13 @@ static int __devinit max6902_probe(struc
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
 
+	dev_set_drvdata(&spi->dev, rtc);
 	return 0;
 }
 
 static int __devexit max6902_remove(struct spi_device *spi)
 {
-	struct rtc_device *rtc = platform_get_drvdata(spi);
+	struct rtc_device *rtc = dev_get_drvdata(&spi->dev);
 
 	rtc_device_unregister(rtc);
 	return 0;
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch
leds-leds-pca9532-cleanups.patch
drivers-video-backlight-l4f00242t03c-full-implement-fb-power-states-for-this-lcd.patch
drivers-video-backlight-l4f00242t03c-prevent-unbalanced-calls-to-regulator-enable-disable.patch
drivers-video-backlight-l4f00242t03c-fix-reset-sequence.patch
drivers-rtc-rtc-omapc-fix-a-memory-leak.patch
rtc-rtc-max6902-set-driver-data-in-max6902_probe.patch

