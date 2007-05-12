From: akpm@linux-foundation.org
Subject: - drivers-hwmon-switch-to-using-input_dev-devparent.patch removed from -mm tree
Date: Fri, 11 May 2007 22:15:34 -0700
Message-ID: <200705120515.l4C5FYfv001761@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49314 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756383AbXELFPx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:15:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dtor@insightbb.com, dtor@mail.ru, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     drivers/hwmon: switch to using input_dev->dev.parent
has been removed from the -mm tree.  Its filename was
     drivers-hwmon-switch-to-using-input_dev-devparent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/hwmon: switch to using input_dev->dev.parent
From: Dmitry Torokhov <dtor@insightbb.com>

In preparation for struct class_device -> struct device input core
conversion, switch to using input_dev->dev.parent when specifying device
position in sysfs tree.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Acked-by: Jean Delvare <khali@linux-fr.org>
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
git-input.patch
ucb1x00-do-not-access-input_dev-private-directly.patch
