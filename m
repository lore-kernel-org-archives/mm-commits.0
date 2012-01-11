From: akpm@linux-foundation.org
Subject: [merged] leds-convert-wm8350-driver-to-devm_kzalloc.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:30:47 -0800
Message-ID: <20120111213047.EE7185C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:59532 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933921Ab2AKVat (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:30:49 -0500
Received: by mail-ee0-f74.google.com with SMTP id d41so44333eek.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:30:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: broonie@opensource.wolfsonmicro.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: leds: convert wm8350 driver to devm_kzalloc()
has been removed from the -mm tree.  Its filename was
     leds-convert-wm8350-driver-to-devm_kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: leds: convert wm8350 driver to devm_kzalloc()

Saves a small amount of code and systematically eliminates leaks.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-wm8350.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/leds/leds-wm8350.c~leds-convert-wm8350-driver-to-devm_kzalloc drivers/leds/leds-wm8350.c
--- a/drivers/leds/leds-wm8350.c~leds-convert-wm8350-driver-to-devm_kzalloc
+++ a/drivers/leds/leds-wm8350.c
@@ -227,7 +227,7 @@ static int wm8350_led_probe(struct platf
 		goto err_isink;
 	}
 
-	led = kzalloc(sizeof(*led), GFP_KERNEL);
+	led = devm_kzalloc(&pdev->dev, sizeof(*led), GFP_KERNEL);
 	if (led == NULL) {
 		ret = -ENOMEM;
 		goto err_dcdc;
@@ -259,12 +259,10 @@ static int wm8350_led_probe(struct platf
 
 	ret = led_classdev_register(&pdev->dev, &led->cdev);
 	if (ret < 0)
-		goto err_led;
+		goto err_dcdc;
 
 	return 0;
 
- err_led:
-	kfree(led);
  err_dcdc:
 	regulator_put(dcdc);
  err_isink:
@@ -281,7 +279,6 @@ static int wm8350_led_remove(struct plat
 	wm8350_led_disable(led);
 	regulator_put(led->dcdc);
 	regulator_put(led->isink);
-	kfree(led);
 	return 0;
 }
 
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

origin.patch
linux-next.patch

