From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-lm3630_blc-remove-ret-=-eio-of-lm3630_backlight_register.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:42:18 -0800
Message-ID: <20130222204218.AF7FC31C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:45203 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829Ab3BVUmT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:42:19 -0500
Received: by mail-qa0-f74.google.com with SMTP id o13so119067qaj.1
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:42:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, daniel.jeong@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/lm3630_bl.c: remove ret = -EIO of lm3630_backlight_register()
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-lm3630_blc-remove-ret-=-eio-of-lm3630_backlight_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/video/backlight/lm3630_bl.c: remove ret = -EIO of lm3630_backlight_register()

There is no need to return -EIO, because backlight_device_register()
already returns correct error values.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Daniel Jeong <daniel.jeong@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lm3630_bl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/backlight/lm3630_bl.c~drivers-video-backlight-lm3630_blc-remove-ret-=-eio-of-lm3630_backlight_register drivers/video/backlight/lm3630_bl.c
--- a/drivers/video/backlight/lm3630_bl.c~drivers-video-backlight-lm3630_blc-remove-ret-=-eio-of-lm3630_backlight_register
+++ a/drivers/video/backlight/lm3630_bl.c
@@ -320,7 +320,7 @@ static int lm3630_backlight_register(str
 		    backlight_device_register(name, pchip->dev, pchip,
 					      &lm3630_bank_a_ops, &props);
 		if (IS_ERR(pchip->bled1))
-			return -EIO;
+			return PTR_ERR(pchip->bled1);
 		break;
 	case BLED_2:
 		props.brightness = pdata->init_brt_led2;
@@ -329,7 +329,7 @@ static int lm3630_backlight_register(str
 		    backlight_device_register(name, pchip->dev, pchip,
 					      &lm3630_bank_b_ops, &props);
 		if (IS_ERR(pchip->bled2))
-			return -EIO;
+			return PTR_ERR(pchip->bled2);
 		break;
 	}
 	return 0;
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

