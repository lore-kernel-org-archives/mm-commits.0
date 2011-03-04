From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-ltv350qvc-fix-a-memory-leak.patch added to -mm tree
Date: Fri, 04 Mar 2011 15:55:09 -0800
Message-ID: <201103042355.p24Nt9qa011326@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60287 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760072Ab1CDXzu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Mar 2011 18:55:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, hskinnemoen@atmel.com, rpurdie@rpsys.net


The patch titled
     drivers/video/backlight/ltv350qv.c: fix a memory leak
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-ltv350qvc-fix-a-memory-leak.patch

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
Subject: drivers/video/backlight/ltv350qv.c: fix a memory leak
From: Axel Lin <axel.lin@gmail.com>

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ltv350qv.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN drivers/video/backlight/ltv350qv.c~drivers-video-backlight-ltv350qvc-fix-a-memory-leak drivers/video/backlight/ltv350qv.c
--- a/drivers/video/backlight/ltv350qv.c~drivers-video-backlight-ltv350qvc-fix-a-memory-leak
+++ a/drivers/video/backlight/ltv350qv.c
@@ -239,11 +239,15 @@ static int __devinit ltv350qv_probe(stru
 	lcd->spi = spi;
 	lcd->power = FB_BLANK_POWERDOWN;
 	lcd->buffer = kzalloc(8, GFP_KERNEL);
+	if (!lcd->buffer) {
+		ret = -ENOMEM;
+		goto out_free_lcd;
+	}
 
 	ld = lcd_device_register("ltv350qv", &spi->dev, lcd, &ltv_ops);
 	if (IS_ERR(ld)) {
 		ret = PTR_ERR(ld);
-		goto out_free_lcd;
+		goto out_free_buffer;
 	}
 	lcd->ld = ld;
 
@@ -257,6 +261,8 @@ static int __devinit ltv350qv_probe(stru
 
 out_unregister:
 	lcd_device_unregister(ld);
+out_free_buffer:
+	kfree(lcd->buffer);
 out_free_lcd:
 	kfree(lcd);
 	return ret;
@@ -268,6 +274,7 @@ static int __devexit ltv350qv_remove(str
 
 	ltv350qv_power(lcd, FB_BLANK_POWERDOWN);
 	lcd_device_unregister(lcd->ld);
+	kfree(lcd->buffer);
 	kfree(lcd);
 
 	return 0;
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
drivers-rtc-rtc-s3cc-fix-prototype-for-s3c_rtc_setaie.patch
misc-bmp085-add-module_device_table.patch
drivers-video-backlight-ltv350qvc-fix-a-memory-leak.patch
linux-next.patch
drivers-video-backlight-jornada720_c-make-needlessly-global-symbols-static.patch

