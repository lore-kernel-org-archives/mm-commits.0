From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-atmel-pwm-blc-add-__init-annotation.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:51:21 -0700
Message-ID: <20130430185121.6CAC05A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:53654 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932669Ab3D3SvW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:51:22 -0400
Received: by mail-gg0-f201.google.com with SMTP id y3so86321ggc.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:51:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/atmel-pwm-bl.c: add __init annotation
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-atmel-pwm-blc-add-__init-annotation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/video/backlight/atmel-pwm-bl.c: add __init annotation

When platform_driver_probe() is used, bind/unbind via sysfs is disabled. 
Thus, __init/__exit annotations can be added to probe()/remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/atmel-pwm-bl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/atmel-pwm-bl.c~drivers-video-backlight-atmel-pwm-blc-add-__init-annotation drivers/video/backlight/atmel-pwm-bl.c
--- a/drivers/video/backlight/atmel-pwm-bl.c~drivers-video-backlight-atmel-pwm-blc-add-__init-annotation
+++ a/drivers/video/backlight/atmel-pwm-bl.c
@@ -118,7 +118,7 @@ static const struct backlight_ops atmel_
 	.update_status  = atmel_pwm_bl_set_intensity,
 };
 
-static int atmel_pwm_bl_probe(struct platform_device *pdev)
+static int __init atmel_pwm_bl_probe(struct platform_device *pdev)
 {
 	struct backlight_properties props;
 	const struct atmel_pwm_bl_platform_data *pdata;
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

