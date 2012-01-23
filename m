From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-use-devm_-functions.patch added to -mm tree
Date: Mon, 23 Jan 2012 13:21:23 -0800
Message-ID: <20120123212124.A9FB1200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:48885 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab2AWVV0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jan 2012 16:21:26 -0500
Received: by mail-ee0-f74.google.com with SMTP id b15so141524eek.1
        for <mm-commits@vger.kernel.org>; Mon, 23 Jan 2012 13:21:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Julia.Lawall@lip6.fr, FlorianSchandinat@gmx.de, broonie@opensource.wolfsonmicro.com, dp@opensource.wolfsonmicro.com, michael.hennerich@analog.com, rpurdie@rpsys.net


The patch titled
     Subject: drivers/video/backlight: use devm_ functions
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-use-devm_-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: drivers/video/backlight: use devm_ functions

The various devm_ functions allocate memory that is released when a driver
detaches.  This patch uses these functions for data that is allocated in
the probe function of a platform device and is only freed in the remove
function.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/88pm860x_bl.c        |    8 ++------
 drivers/video/backlight/aat2870_bl.c         |    9 ++++-----
 drivers/video/backlight/cr_bllcd.c           |    3 +--
 drivers/video/backlight/da903x_bl.c          |    6 +-----
 drivers/video/backlight/max8925_bl.c         |    7 ++-----
 drivers/video/backlight/omap1_bl.c           |    9 +++------
 drivers/video/backlight/pcf50633-backlight.c |   16 +++-------------
 drivers/video/backlight/pwm_bl.c             |    7 ++-----
 8 files changed, 18 insertions(+), 47 deletions(-)

diff -puN drivers/video/backlight/88pm860x_bl.c~drivers-video-backlight-use-devm_-functions drivers/video/backlight/88pm860x_bl.c
--- a/drivers/video/backlight/88pm860x_bl.c~drivers-video-backlight-use-devm_-functions
+++ a/drivers/video/backlight/88pm860x_bl.c
@@ -187,7 +187,8 @@ static int pm860x_backlight_probe(struct
 		return -EINVAL;
 	}
 
-	data = kzalloc(sizeof(struct pm860x_backlight_data), GFP_KERNEL);
+	data = devm_kzalloc(&pdev->dev, sizeof(struct pm860x_backlight_data),
+			    GFP_KERNEL);
 	if (data == NULL)
 		return -ENOMEM;
 	strncpy(name, res->name, MFD_NAME_SIZE);
@@ -200,7 +201,6 @@ static int pm860x_backlight_probe(struct
 	data->port = pdata->flags;
 	if (data->port < 0) {
 		dev_err(&pdev->dev, "wrong platform data is assigned");
-		kfree(data);
 		return -EINVAL;
 	}
 
@@ -211,7 +211,6 @@ static int pm860x_backlight_probe(struct
 					&pm860x_backlight_ops, &props);
 	if (IS_ERR(bl)) {
 		dev_err(&pdev->dev, "failed to register backlight\n");
-		kfree(data);
 		return PTR_ERR(bl);
 	}
 	bl->props.brightness = MAX_BRIGHTNESS;
@@ -247,17 +246,14 @@ static int pm860x_backlight_probe(struct
 	return 0;
 out:
 	backlight_device_unregister(bl);
-	kfree(data);
 	return ret;
 }
 
 static int pm860x_backlight_remove(struct platform_device *pdev)
 {
 	struct backlight_device *bl = platform_get_drvdata(pdev);
-	struct pm860x_backlight_data *data = bl_get_data(bl);
 
 	backlight_device_unregister(bl);
-	kfree(data);
 	return 0;
 }
 
diff -puN drivers/video/backlight/aat2870_bl.c~drivers-video-backlight-use-devm_-functions drivers/video/backlight/aat2870_bl.c
--- a/drivers/video/backlight/aat2870_bl.c~drivers-video-backlight-use-devm_-functions
+++ a/drivers/video/backlight/aat2870_bl.c
@@ -145,7 +145,9 @@ static int aat2870_bl_probe(struct platf
 		goto out;
 	}
 
-	aat2870_bl = kzalloc(sizeof(struct aat2870_bl_driver_data), GFP_KERNEL);
+	aat2870_bl = devm_kzalloc(&pdev->dev,
+				  sizeof(struct aat2870_bl_driver_data),
+				  GFP_KERNEL);
 	if (!aat2870_bl) {
 		dev_err(&pdev->dev,
 			"Failed to allocate memory for aat2870 backlight\n");
@@ -162,7 +164,7 @@ static int aat2870_bl_probe(struct platf
 		dev_err(&pdev->dev,
 			"Failed allocate memory for backlight device\n");
 		ret = PTR_ERR(bd);
-		goto out_kfree;
+		goto out;
 	}
 
 	aat2870_bl->pdev = pdev;
@@ -199,8 +201,6 @@ static int aat2870_bl_probe(struct platf
 
 out_bl_dev_unregister:
 	backlight_device_unregister(bd);
-out_kfree:
-	kfree(aat2870_bl);
 out:
 	return ret;
 }
@@ -215,7 +215,6 @@ static int aat2870_bl_remove(struct plat
 	backlight_update_status(bd);
 
 	backlight_device_unregister(bd);
-	kfree(aat2870_bl);
 
 	return 0;
 }
diff -puN drivers/video/backlight/cr_bllcd.c~drivers-video-backlight-use-devm_-functions drivers/video/backlight/cr_bllcd.c
--- a/drivers/video/backlight/cr_bllcd.c~drivers-video-backlight-use-devm_-functions
+++ a/drivers/video/backlight/cr_bllcd.c
@@ -212,7 +212,7 @@ static int cr_backlight_probe(struct pla
 			      &gpio_bar);
 	gpio_bar &= ~0x3F;
 
-	crp = kzalloc(sizeof(*crp), GFP_KERNEL);
+	crp = devm_kzalloc(&pdev->dev, sizeof(*crp), GFP_KERNEL);
 	if (!crp) {
 		lcd_device_unregister(ldp);
 		backlight_device_unregister(bdp);
@@ -243,7 +243,6 @@ static int cr_backlight_remove(struct pl
 	backlight_device_unregister(crp->cr_backlight_device);
 	lcd_device_unregister(crp->cr_lcd_device);
 	pci_dev_put(lpc_dev);
-	kfree(crp);
 
 	return 0;
 }
diff -puN drivers/video/backlight/da903x_bl.c~drivers-video-backlight-use-devm_-functions drivers/video/backlight/da903x_bl.c
--- a/drivers/video/backlight/da903x_bl.c~drivers-video-backlight-use-devm_-functions
+++ a/drivers/video/backlight/da903x_bl.c
@@ -110,7 +110,7 @@ static int da903x_backlight_probe(struct
 	struct backlight_properties props;
 	int max_brightness;
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
 	if (data == NULL)
 		return -ENOMEM;
 
@@ -124,7 +124,6 @@ static int da903x_backlight_probe(struct
 	default:
 		dev_err(&pdev->dev, "invalid backlight device ID(%d)\n",
 				pdev->id);
-		kfree(data);
 		return -EINVAL;
 	}
 
@@ -143,7 +142,6 @@ static int da903x_backlight_probe(struct
 				       &da903x_backlight_ops, &props);
 	if (IS_ERR(bl)) {
 		dev_err(&pdev->dev, "failed to register backlight\n");
-		kfree(data);
 		return PTR_ERR(bl);
 	}
 
@@ -157,10 +155,8 @@ static int da903x_backlight_probe(struct
 static int da903x_backlight_remove(struct platform_device *pdev)
 {
 	struct backlight_device *bl = platform_get_drvdata(pdev);
-	struct da903x_backlight_data *data = bl_get_data(bl);
 
 	backlight_device_unregister(bl);
-	kfree(data);
 	return 0;
 }
 
diff -puN drivers/video/backlight/max8925_bl.c~drivers-video-backlight-use-devm_-functions drivers/video/backlight/max8925_bl.c
--- a/drivers/video/backlight/max8925_bl.c~drivers-video-backlight-use-devm_-functions
+++ a/drivers/video/backlight/max8925_bl.c
@@ -129,7 +129,8 @@ static int __devinit max8925_backlight_p
 		return -EINVAL;
 	}
 
-	data = kzalloc(sizeof(struct max8925_backlight_data), GFP_KERNEL);
+	data = devm_kzalloc(&pdev->dev, sizeof(struct max8925_backlight_data),
+			    GFP_KERNEL);
 	if (data == NULL)
 		return -ENOMEM;
 	strncpy(name, res->name, MAX8925_NAME_SIZE);
@@ -143,7 +144,6 @@ static int __devinit max8925_backlight_p
 					&max8925_backlight_ops, &props);
 	if (IS_ERR(bl)) {
 		dev_err(&pdev->dev, "failed to register backlight\n");
-		kfree(data);
 		return PTR_ERR(bl);
 	}
 	bl->props.brightness = MAX_BRIGHTNESS;
@@ -165,17 +165,14 @@ static int __devinit max8925_backlight_p
 	return 0;
 out:
 	backlight_device_unregister(bl);
-	kfree(data);
 	return ret;
 }
 
 static int __devexit max8925_backlight_remove(struct platform_device *pdev)
 {
 	struct backlight_device *bl = platform_get_drvdata(pdev);
-	struct max8925_backlight_data *data = bl_get_data(bl);
 
 	backlight_device_unregister(bl);
-	kfree(data);
 	return 0;
 }
 
diff -puN drivers/video/backlight/omap1_bl.c~drivers-video-backlight-use-devm_-functions drivers/video/backlight/omap1_bl.c
--- a/drivers/video/backlight/omap1_bl.c~drivers-video-backlight-use-devm_-functions
+++ a/drivers/video/backlight/omap1_bl.c
@@ -141,7 +141,8 @@ static int omapbl_probe(struct platform_
 	if (!pdata)
 		return -ENXIO;
 
-	bl = kzalloc(sizeof(struct omap_backlight), GFP_KERNEL);
+	bl = devm_kzalloc(&pdev->dev, sizeof(struct omap_backlight),
+			  GFP_KERNEL);
 	if (unlikely(!bl))
 		return -ENOMEM;
 
@@ -150,10 +151,8 @@ static int omapbl_probe(struct platform_
 	props.max_brightness = OMAPBL_MAX_INTENSITY;
 	dev = backlight_device_register("omap-bl", &pdev->dev, bl, &omapbl_ops,
 					&props);
-	if (IS_ERR(dev)) {
-		kfree(bl);
+	if (IS_ERR(dev))
 		return PTR_ERR(dev);
-	}
 
 	bl->powermode = FB_BLANK_POWERDOWN;
 	bl->current_intensity = 0;
@@ -177,10 +176,8 @@ static int omapbl_probe(struct platform_
 static int omapbl_remove(struct platform_device *pdev)
 {
 	struct backlight_device *dev = platform_get_drvdata(pdev);
-	struct omap_backlight *bl = dev_get_drvdata(&dev->dev);
 
 	backlight_device_unregister(dev);
-	kfree(bl);
 
 	return 0;
 }
diff -puN drivers/video/backlight/pcf50633-backlight.c~drivers-video-backlight-use-devm_-functions drivers/video/backlight/pcf50633-backlight.c
--- a/drivers/video/backlight/pcf50633-backlight.c~drivers-video-backlight-use-devm_-functions
+++ a/drivers/video/backlight/pcf50633-backlight.c
@@ -101,14 +101,13 @@ static const struct backlight_ops pcf506
 
 static int __devinit pcf50633_bl_probe(struct platform_device *pdev)
 {
-	int ret;
 	struct pcf50633_bl *pcf_bl;
 	struct device *parent = pdev->dev.parent;
 	struct pcf50633_platform_data *pcf50633_data = parent->platform_data;
 	struct pcf50633_bl_platform_data *pdata = pcf50633_data->backlight_data;
 	struct backlight_properties bl_props;
 
-	pcf_bl = kzalloc(sizeof(*pcf_bl), GFP_KERNEL);
+	pcf_bl = devm_kzalloc(&pdev->dev, sizeof(*pcf_bl), GFP_KERNEL);
 	if (!pcf_bl)
 		return -ENOMEM;
 
@@ -129,10 +128,8 @@ static int __devinit pcf50633_bl_probe(s
 	pcf_bl->bl = backlight_device_register(pdev->name, &pdev->dev, pcf_bl,
 						&pcf50633_bl_ops, &bl_props);
 
-	if (IS_ERR(pcf_bl->bl)) {
-		ret = PTR_ERR(pcf_bl->bl);
-		goto err_free;
-	}
+	if (IS_ERR(pcf_bl->bl))
+		return PTR_ERR(pcf_bl->bl);
 
 	platform_set_drvdata(pdev, pcf_bl);
 
@@ -145,11 +142,6 @@ static int __devinit pcf50633_bl_probe(s
 	backlight_update_status(pcf_bl->bl);
 
 	return 0;
-
-err_free:
-	kfree(pcf_bl);
-
-	return ret;
 }
 
 static int __devexit pcf50633_bl_remove(struct platform_device *pdev)
@@ -160,8 +152,6 @@ static int __devexit pcf50633_bl_remove(
 
 	platform_set_drvdata(pdev, NULL);
 
-	kfree(pcf_bl);
-
 	return 0;
 }
 
diff -puN drivers/video/backlight/pwm_bl.c~drivers-video-backlight-use-devm_-functions drivers/video/backlight/pwm_bl.c
--- a/drivers/video/backlight/pwm_bl.c~drivers-video-backlight-use-devm_-functions
+++ a/drivers/video/backlight/pwm_bl.c
@@ -102,7 +102,7 @@ static int pwm_backlight_probe(struct pl
 			return ret;
 	}
 
-	pb = kzalloc(sizeof(*pb), GFP_KERNEL);
+	pb = devm_kzalloc(&pdev->dev, sizeof(*pb), GFP_KERNEL);
 	if (!pb) {
 		dev_err(&pdev->dev, "no memory for state\n");
 		ret = -ENOMEM;
@@ -121,7 +121,7 @@ static int pwm_backlight_probe(struct pl
 	if (IS_ERR(pb->pwm)) {
 		dev_err(&pdev->dev, "unable to request PWM for backlight\n");
 		ret = PTR_ERR(pb->pwm);
-		goto err_pwm;
+		goto err_alloc;
 	} else
 		dev_dbg(&pdev->dev, "got pwm for backlight\n");
 
@@ -144,8 +144,6 @@ static int pwm_backlight_probe(struct pl
 
 err_bl:
 	pwm_free(pb->pwm);
-err_pwm:
-	kfree(pb);
 err_alloc:
 	if (data->exit)
 		data->exit(&pdev->dev);
@@ -162,7 +160,6 @@ static int pwm_backlight_remove(struct p
 	pwm_config(pb->pwm, 0, pb->period);
 	pwm_disable(pb->pwm);
 	pwm_free(pb->pwm);
-	kfree(pb);
 	if (data->exit)
 		data->exit(&pdev->dev);
 	return 0;
_
Subject: Subject: drivers/video/backlight: use devm_ functions

Patches currently in -mm which might be from Julia.Lawall@lip6.fr are

linux-next.patch
drivers-video-backlight-wm831x_blc-use-devm_-functions.patch
drivers-video-backlight-use-devm_-functions.patch
drivers-video-backlight-adp5520_blc-use-devm_-functions.patch

