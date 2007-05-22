From: akpm@linux-foundation.org
Subject: + applesmc-sensors-patch-missing-from-2622-rc2.patch added to -mm tree
Date: Mon, 21 May 2007 22:57:49 -0700
Message-ID: <200705220601.l4M613Ng028503@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38357 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756017AbXEVGDv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 May 2007 02:03:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nicolas@boichat.ch, kernel@nn7.de, khali@linux-fr.org


The patch titled
     applesmc - sensors patch missing from 2.6.22-rc2
has been added to the -mm tree.  Its filename is
     applesmc-sensors-patch-missing-from-2622-rc2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 file changed, 10 insertions(+)

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

applesmc-sensors-patch-missing-from-2622-rc2.patch
