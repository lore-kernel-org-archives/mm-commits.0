From: akpm@linux-foundation.org
Subject: [merged] leds-convert-wm831x-status-driver-to-devm_kzalloc.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:30:43 -0800
Message-ID: <20120111213044.13A205C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:59532 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933921Ab2AKVap (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:30:45 -0500
Received: by eekd41 with SMTP id d41so44333eek.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:30:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: broonie@opensource.wolfsonmicro.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: leds: convert wm831x status driver to devm_kzalloc()
has been removed from the -mm tree.  Its filename was
     leds-convert-wm831x-status-driver-to-devm_kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: leds: convert wm831x status driver to devm_kzalloc()

Saves a small amount of code and systematically eliminates leaks.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-wm831x-status.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/leds/leds-wm831x-status.c~leds-convert-wm831x-status-driver-to-devm_kzalloc drivers/leds/leds-wm831x-status.c
--- a/drivers/leds/leds-wm831x-status.c~leds-convert-wm831x-status-driver-to-devm_kzalloc
+++ a/drivers/leds/leds-wm831x-status.c
@@ -237,7 +237,8 @@ static int wm831x_status_probe(struct pl
 		goto err;
 	}
 
-	drvdata = kzalloc(sizeof(struct wm831x_status), GFP_KERNEL);
+	drvdata = devm_kzalloc(&pdev->dev, sizeof(struct wm831x_status),
+			       GFP_KERNEL);
 	if (!drvdata)
 		return -ENOMEM;
 	dev_set_drvdata(&pdev->dev, drvdata);
@@ -300,7 +301,6 @@ static int wm831x_status_probe(struct pl
 
 err_led:
 	led_classdev_unregister(&drvdata->cdev);
-	kfree(drvdata);
 err:
 	return ret;
 }
@@ -311,7 +311,6 @@ static int wm831x_status_remove(struct p
 
 	device_remove_file(drvdata->cdev.dev, &dev_attr_src);
 	led_classdev_unregister(&drvdata->cdev);
-	kfree(drvdata);
 
 	return 0;
 }
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

origin.patch
linux-next.patch

