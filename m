From: akpm@linux-foundation.org
Subject: [merged] backlight-tosa-use-devm_backlight_device_register.patch
 removed from -mm tree
Date: Fri, 24 Jan 2014 11:01:17 -0800
Message-ID: <52e2b87d.u7H5YRkqFqfcVYk3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43581 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaAXTBR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:01:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tomi.valkeinen@ti.com, jg1.han@samsung.com

Subject: [merged] backlight-tosa-use-devm_backlight_device_register.patch removed from -mm tree
To: jg1.han@samsung.com,tomi.valkeinen@ti.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:01:17 -0800


The patch titled
     Subject: backlight: tosa: use devm_backlight_device_register()
has been removed from the -mm tree.  Its filename was
     backlight-tosa-use-devm_backlight_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: tosa: use devm_backlight_device_register()

Use devm_backlight_device_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/tosa_bl.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/video/backlight/tosa_bl.c~backlight-tosa-use-devm_backlight_device_register drivers/video/backlight/tosa_bl.c
--- a/drivers/video/backlight/tosa_bl.c~backlight-tosa-use-devm_backlight_device_register
+++ a/drivers/video/backlight/tosa_bl.c
@@ -105,8 +105,9 @@ static int tosa_bl_probe(struct i2c_clie
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = 512 - 1;
-	data->bl = backlight_device_register("tosa-bl", &client->dev, data,
-					     &bl_ops, &props);
+	data->bl = devm_backlight_device_register(&client->dev, "tosa-bl",
+						&client->dev, data, &bl_ops,
+						&props);
 	if (IS_ERR(data->bl)) {
 		ret = PTR_ERR(data->bl);
 		goto err_reg;
@@ -128,9 +129,7 @@ static int tosa_bl_remove(struct i2c_cli
 {
 	struct tosa_bl_data *data = i2c_get_clientdata(client);
 
-	backlight_device_unregister(data->bl);
 	data->bl = NULL;
