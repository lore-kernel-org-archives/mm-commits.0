From: akpm@linux-foundation.org
Subject: - applesmc-sensors-patch-missing-from-2622-rc2.patch removed from -mm tree
Date: Tue, 29 May 2007 11:56:40 -0700
Message-ID: <200705291856.l4TIudjB008660@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38907 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765332AbXE2S51 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:57:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicolas@boichat.ch, kernel@nn7.de, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     applesmc - sensors patch missing from 2.6.22-rc2
has been removed from the -mm tree.  Its filename was
     applesmc-sensors-patch-missing-from-2622-rc2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: applesmc - sensors patch missing from 2.6.22-rc2
From: Nicolas Boichat <nicolas@boichat.ch>

Add name file needed by lm_sensors user-space applications in applesmc
sysfs tree.

Cc: Soeren Sonnenburg <kernel@nn7.de>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/applesmc.c |   10 ++++++++++
 1 files changed, 10 insertions(+)

diff -puN drivers/hwmon/applesmc.c~applesmc-sensors-patch-missing-from-2622-rc2 drivers/hwmon/applesmc.c
--- a/drivers/hwmon/applesmc.c~applesmc-sensors-patch-missing-from-2622-rc2
+++ a/drivers/hwmon/applesmc.c
@@ -491,6 +491,12 @@ out:
 
 /* Sysfs Files */
 
+static ssize_t applesmc_name_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "applesmc\n");
+}
+
 static ssize_t applesmc_position_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
@@ -913,6 +919,8 @@ static struct led_classdev applesmc_back
 	.brightness_set		= applesmc_brightness_set,
 };
 
+static DEVICE_ATTR(name, 0444, applesmc_name_show, NULL);
+
 static DEVICE_ATTR(position, 0444, applesmc_position_show, NULL);
 static DEVICE_ATTR(calibrate, 0644,
 			applesmc_calibrate_show, applesmc_calibrate_store);
@@ -1197,6 +1205,8 @@ static int __init applesmc_init(void)
 		goto out_driver;
 	}
 
+	ret = sysfs_create_file(&pdev->dev.kobj, &dev_attr_name.attr);
+
 	/* Create key enumeration sysfs files */
 	ret = sysfs_create_group(&pdev->dev.kobj, &key_enumeration_group);
 	if (ret)
_

Patches currently in -mm which might be from nicolas@boichat.ch are
