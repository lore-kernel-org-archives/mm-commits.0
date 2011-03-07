From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-ltv350qvc-fix-a-memory-leak.patch removed from -mm tree
Date: Mon, 07 Mar 2011 13:31:11 -0800
Message-ID: <201103072131.p27LVsxA028071@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756012Ab1CGVch (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Mar 2011 16:32:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, hskinnemoen@atmel.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     drivers/video/backlight/ltv350qv.c: fix a memory leak
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-ltv350qvc-fix-a-memory-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
linux-next.patch
drivers-video-backlight-jornada720_c-make-needlessly-global-symbols-static.patch

