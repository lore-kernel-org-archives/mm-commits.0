From: akpm@linux-foundation.org
Subject: + leds-add-lm3533-led-driver-fix.patch added to -mm tree
Date: Tue, 22 May 2012 13:40:16 -0700
Message-ID: <20120522204016.D7F57A044C@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:44482 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933293Ab2EVUkS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 May 2012 16:40:18 -0400
Received: by qcsp5 with SMTP id p5so791125qcs.1
        for <mm-commits@vger.kernel.org>; Tue, 22 May 2012 13:40:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jhovold@gmail.com, rpurdie@rpsys.net


The patch titled
     Subject: leds: lm3533: use devres to manage driver data
has been added to the -mm tree.  Its filename is
     leds-add-lm3533-led-driver-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: leds: lm3533: use devres to manage driver data

Patches currently in -mm which might be from jhovold@gmail.com are

linux-next.patch
backlight-add-lm3533-backlight-driver.patch
backlight-add-lm3533-backlight-driver-fix.patch
backlight-add-lm3533-backlight-driver-fix-fix.patch
backlight-add-lm3533-backlight-driver-v4.patch
leds-add-lm3533-led-driver.patch
leds-add-lm3533-led-driver-fix.patch

