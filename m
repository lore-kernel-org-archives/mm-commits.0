From: akpm@linux-foundation.org
Subject: [merged] drivers-leds-leds-sunfirec-fix-sunfire_led_generic_probe-error-handling.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:55:45 -0700
Message-ID: <201107260754.p6Q7smVC003385@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60828 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753237Ab1GZHzr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:55:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     drivers/leds/leds-sunfire.c: fix sunfire_led_generic_probe() error handling
has been removed from the -mm tree.  Its filename was
     drivers-leds-leds-sunfirec-fix-sunfire_led_generic_probe-error-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/leds/leds-sunfire.c: fix sunfire_led_generic_probe() error handling
From: Axel Lin <axel.lin@gmail.com>

- return -ENOMEM if kzalloc fails, rather than the current -EINVAL

- fix a memory leak in the case of goto out_unregister_led_cdevs

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-sunfire.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN drivers/leds/leds-sunfire.c~drivers-leds-leds-sunfirec-fix-sunfire_led_generic_probe-error-handling drivers/leds/leds-sunfire.c
--- a/drivers/leds/leds-sunfire.c~drivers-leds-leds-sunfirec-fix-sunfire_led_generic_probe-error-handling
+++ a/drivers/leds/leds-sunfire.c
@@ -127,17 +127,19 @@ static int __devinit sunfire_led_generic
 					       struct led_type *types)
 {
 	struct sunfire_drvdata *p;
-	int i, err = -EINVAL;
+	int i, err;
 
 	if (pdev->num_resources != 1) {
 		printk(KERN_ERR PFX "Wrong number of resources %d, should be 1\n",
 		       pdev->num_resources);
+		err = -EINVAL;
 		goto out;
 	}
 
 	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (!p) {
 		printk(KERN_ERR PFX "Could not allocate struct sunfire_drvdata\n");
+		err = -ENOMEM;
 		goto out;
 	}
 
@@ -160,14 +162,14 @@ static int __devinit sunfire_led_generic
 
 	dev_set_drvdata(&pdev->dev, p);
 
-	err = 0;
-out:
-	return err;
+	return 0;
 
 out_unregister_led_cdevs:
 	for (i--; i >= 0; i--)
 		led_classdev_unregister(&p->leds[i].led_cdev);
-	goto out;
+	kfree(p);
+out:
+	return err;
 }
 
 static int __devexit sunfire_led_generic_remove(struct platform_device *pdev)
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch
drivers-video-backlight-aat2870_blc-fix-error-checking-for-backlight_device_register.patch
drivers-video-backlight-aat2870_blc-fix-setting-max_current.patch
drivers-video-backlight-aat2870_blc-make-it-buildable-as-a-module.patch

