From: akpm@linux-foundation.org
Subject: + drivers-hwmon-switch-to-using-input_dev-devparent.patch added to -mm tree
Date: Tue, 08 May 2007 20:54:42 -0700
Message-ID: <200705090354.l493sg9D013802@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43105 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753959AbXEIDyu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:54:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dtor@insightbb.com, dtor@mail.ru


The patch titled
     drivers/hwmon: switch to using input_dev->dev.parent
has been added to the -mm tree.  Its filename is
     drivers-hwmon-switch-to-using-input_dev-devparent.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/hwmon: switch to using input_dev->dev.parent
From: Dmitry Torokhov <dtor@insightbb.com>

In preparation for struct class_device -> struct device input core
conversion, switch to using input_dev->dev.parent when specifying device
position in sysfs tree.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/ams/ams-input.c |    2 +-
 drivers/hwmon/applesmc.c      |    2 +-
 drivers/hwmon/hdaps.c         |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/hwmon/ams/ams-input.c~drivers-hwmon-switch-to-using-input_dev-devparent drivers/hwmon/ams/ams-input.c
--- a/drivers/hwmon/ams/ams-input.c~drivers-hwmon-switch-to-using-input_dev-devparent
+++ a/drivers/hwmon/ams/ams-input.c
@@ -87,7 +87,7 @@ static void ams_input_enable(void)
 	ams_info.idev->id.vendor = 0;
 	ams_info.idev->open = ams_input_open;
 	ams_info.idev->close = ams_input_close;
-	ams_info.idev->cdev.dev = &ams_info.of_dev->dev;
+	ams_info.idev->dev.parent = &ams_info.of_dev->dev;
 
 	input_set_abs_params(ams_info.idev, ABS_X, -50, 50, 3, 0);
 	input_set_abs_params(ams_info.idev, ABS_Y, -50, 50, 3, 0);
diff -puN drivers/hwmon/applesmc.c~drivers-hwmon-switch-to-using-input_dev-devparent drivers/hwmon/applesmc.c
--- a/drivers/hwmon/applesmc.c~drivers-hwmon-switch-to-using-input_dev-devparent
+++ a/drivers/hwmon/applesmc.c
@@ -1100,7 +1100,7 @@ static int applesmc_create_accelerometer
 	/* initialize the input class */
 	applesmc_idev->name = "applesmc";
 	applesmc_idev->id.bustype = BUS_HOST;
-	applesmc_idev->cdev.dev = &pdev->dev;
+	applesmc_idev->dev.parent = &pdev->dev;
 	applesmc_idev->evbit[0] = BIT(EV_ABS);
 	applesmc_idev->open = applesmc_idev_open;
 	applesmc_idev->close = applesmc_idev_close;
diff -puN drivers/hwmon/hdaps.c~drivers-hwmon-switch-to-using-input_dev-devparent drivers/hwmon/hdaps.c
--- a/drivers/hwmon/hdaps.c~drivers-hwmon-switch-to-using-input_dev-devparent
+++ a/drivers/hwmon/hdaps.c
@@ -574,7 +574,7 @@ static int __init hdaps_init(void)
 
 	/* initialize the input class */
 	hdaps_idev->name = "hdaps";
-	hdaps_idev->cdev.dev = &pdev->dev;
+	hdaps_idev->dev.parent = &pdev->dev;
 	hdaps_idev->evbit[0] = BIT(EV_ABS);
 	input_set_abs_params(hdaps_idev, ABS_X,
 			-256, 256, HDAPS_INPUT_FUZZ, HDAPS_INPUT_FLAT);
_

Patches currently in -mm which might be from dtor@insightbb.com are

origin.patch
drivers-hwmon-switch-to-using-input_dev-devparent.patch
