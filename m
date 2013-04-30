From: akpm@linux-foundation.org
Subject: [merged] backlight-adp8870-convert-adp8870-to-dev_pm_ops.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:51:52 -0700
Message-ID: <20130430185152.6FABF5A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:39811 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932551Ab3D3Svx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:51:53 -0400
Received: by mail-qa0-f73.google.com with SMTP id p6so87711qad.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:51:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: adp8870: convert adp8870 to dev_pm_ops
has been removed from the -mm tree.  Its filename was
     backlight-adp8870-convert-adp8870-to-dev_pm_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: adp8870: convert adp8870 to dev_pm_ops

Instead of using legacy suspend/resume methods, using newer dev_pm_ops
structure allows better control over power management.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/adp8870_bl.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff -puN drivers/video/backlight/adp8870_bl.c~backlight-adp8870-convert-adp8870-to-dev_pm_ops drivers/video/backlight/adp8870_bl.c
--- a/drivers/video/backlight/adp8870_bl.c~backlight-adp8870-convert-adp8870-to-dev_pm_ops
+++ a/drivers/video/backlight/adp8870_bl.c
@@ -947,25 +947,29 @@ static int adp8870_remove(struct i2c_cli
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int adp8870_i2c_suspend(struct i2c_client *client, pm_message_t message)
+#ifdef CONFIG_PM_SLEEP
+static int adp8870_i2c_suspend(struct device *dev)
 {
+	struct i2c_client *client = to_i2c_client(dev);
+
 	adp8870_clr_bits(client, ADP8870_MDCR, NSTBY);
 
 	return 0;
 }
 
-static int adp8870_i2c_resume(struct i2c_client *client)
+static int adp8870_i2c_resume(struct device *dev)
 {
+	struct i2c_client *client = to_i2c_client(dev);
+
 	adp8870_set_bits(client, ADP8870_MDCR, NSTBY | BLEN);
 
 	return 0;
 }
-#else
-#define adp8870_i2c_suspend NULL
-#define adp8870_i2c_resume NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(adp8870_i2c_pm_ops, adp8870_i2c_suspend,
+			adp8870_i2c_resume);
+
 static const struct i2c_device_id adp8870_id[] = {
 	{ "adp8870", 0 },
 	{ }
@@ -974,12 +978,11 @@ MODULE_DEVICE_TABLE(i2c, adp8870_id);
 
 static struct i2c_driver adp8870_driver = {
 	.driver = {
-		.name = KBUILD_MODNAME,
+		.name	= KBUILD_MODNAME,
+		.pm	= &adp8870_i2c_pm_ops,
 	},
 	.probe    = adp8870_probe,
 	.remove   = adp8870_remove,
-	.suspend = adp8870_i2c_suspend,
-	.resume  = adp8870_i2c_resume,
 	.id_table = adp8870_id,
 };
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

