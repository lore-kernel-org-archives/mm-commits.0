From: akpm@linux-foundation.org
Subject: [merged] backlight-ep93xx_bl-remove-incorrect-__init-annotation.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:51:15 -0700
Message-ID: <20130430185115.7703931C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:33689 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932669Ab3D3SvQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:51:16 -0400
Received: by mail-ve0-f202.google.com with SMTP id ox1so76873veb.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:51:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, rmallon@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/ep93xx_bl.c: remove incorrect __init annotation
has been removed from the -mm tree.  Its filename was
     backlight-ep93xx_bl-remove-incorrect-__init-annotation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/video/backlight/ep93xx_bl.c: remove incorrect __init annotation

When platform_driver_probe() is not used, bind/unbind via sysfs is
enabled.  Thus, __init/__exit annotations should be removed from
probe()/remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Ryan Mallon <rmallon@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ep93xx_bl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/ep93xx_bl.c~backlight-ep93xx_bl-remove-incorrect-__init-annotation drivers/video/backlight/ep93xx_bl.c
--- a/drivers/video/backlight/ep93xx_bl.c~backlight-ep93xx_bl-remove-incorrect-__init-annotation
+++ a/drivers/video/backlight/ep93xx_bl.c
@@ -60,7 +60,7 @@ static const struct backlight_ops ep93xx
 	.get_brightness	= ep93xxbl_get_brightness,
 };
 
-static int __init ep93xxbl_probe(struct platform_device *dev)
+static int ep93xxbl_probe(struct platform_device *dev)
 {
 	struct ep93xxbl *ep93xxbl;
 	struct backlight_device *bl;
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

