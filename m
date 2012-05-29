From: akpm@linux-foundation.org
Subject: [folded] leds-add-lm3533-led-driver-fix.patch removed from -mm tree
Date: Tue, 29 May 2012 14:55:03 -0700
Message-ID: <20120529215503.EF0BCA0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:41160 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab2E2VzF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 May 2012 17:55:05 -0400
Received: by ghbz15 with SMTP id z15so339605ghb.1
        for <mm-commits@vger.kernel.org>; Tue, 29 May 2012 14:55:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jhovold@gmail.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: leds: lm3533: use devres to manage driver data
has been removed from the -mm tree.  Its filename was
     leds-add-lm3533-led-driver-fix.patch

This patch was dropped because it was folded into leds-add-lm3533-led-driver.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johan Hovold <jhovold@gmail.com>
Subject: leds: lm3533: use devres to manage driver data

Use devres to manage driver data.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lm3533.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/leds/leds-lm3533.c~leds-add-lm3533-led-driver-fix drivers/leds/leds-lm3533.c
--- a/drivers/leds/leds-lm3533.c~leds-add-lm3533-led-driver-fix
+++ a/drivers/leds/leds-lm3533.c
@@ -632,7 +632,7 @@ static int __devinit lm3533_led_probe(st
 		return -EINVAL;
 	}
 
-	led = kzalloc(sizeof(*led), GFP_KERNEL);
+	led = devm_kzalloc(&pdev->dev, sizeof(*led), GFP_KERNEL);
 	if (!led)
 		return -ENOMEM;
 
@@ -661,7 +661,7 @@ static int __devinit lm3533_led_probe(st
 	ret = led_classdev_register(pdev->dev.parent, &led->cdev);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register LED %d\n", pdev->id);
-		goto err_free;
+		return ret;
 	}
 
 	led->cb.dev = led->cdev.dev;
@@ -688,8 +688,6 @@ err_sysfs_remove:
 err_unregister:
 	led_classdev_unregister(&led->cdev);
 	flush_work_sync(&led->work);
-err_free:
-	kfree(led);
 
 	return ret;
 }
@@ -704,7 +702,6 @@ static int __devexit lm3533_led_remove(s
 	sysfs_remove_group(&led->cdev.dev->kobj, &lm3533_led_attribute_group);
 	led_classdev_unregister(&led->cdev);
 	flush_work_sync(&led->work);
-	kfree(led);
 
 	return 0;
 }
_

Patches currently in -mm which might be from jhovold@gmail.com are

origin.patch
backlight-add-lm3533-backlight-driver.patch
leds-add-lm3533-led-driver.patch
leds-add-lm3533-led-driver-replace-als-attribute-with-als_channel-and-als_en.patch

