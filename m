From: akpm@linux-foundation.org
Subject: - applesmc-use-standard-sysfs-names-for-labels.patch removed from -mm tree
Date: Wed, 09 May 2007 01:42:49 -0700
Message-ID: <200705090842.l498gnDa018233@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54098 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754344AbXEIInG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 04:43:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, nicolas@boichat.ch, mm-commits@vger.kernel.org


The patch titled
     applesmc: Use standard sysfs names for labels
has been removed from the -mm tree.  Its filename was
     applesmc-use-standard-sysfs-names-for-labels.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: applesmc: Use standard sysfs names for labels
From: Jean Delvare <khali@linux-fr.org>

We have a standard suffix to associate a designation string to a sensor:
_label.  Use it instead of _position so that libsensors will catch it. 
(This isn't implemented yet, but should be soon.)

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Nicolas Boichat <nicolas@boichat.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/applesmc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/hwmon/applesmc.c~applesmc-use-standard-sysfs-names-for-labels drivers/hwmon/applesmc.c
--- a/drivers/hwmon/applesmc.c~applesmc-use-standard-sysfs-names-for-labels
+++ a/drivers/hwmon/applesmc.c
@@ -981,7 +981,7 @@ static SENSOR_DEVICE_ATTR_2(fan##offset#
 static SENSOR_DEVICE_ATTR(fan##offset##_manual, S_IRUGO | S_IWUSR, \
 	applesmc_show_fan_manual, applesmc_store_fan_manual, offset-1); \
 \
-static SENSOR_DEVICE_ATTR(fan##offset##_position, S_IRUGO, \
+static SENSOR_DEVICE_ATTR(fan##offset##_label, S_IRUGO, \
 	applesmc_show_fan_position, NULL, offset-1); \
 \
 static struct attribute *fan##offset##_attributes[] = { \
@@ -991,7 +991,7 @@ static struct attribute *fan##offset##_a
 	&sensor_dev_attr_fan##offset##_safe.dev_attr.attr, \
 	&sensor_dev_attr_fan##offset##_output.dev_attr.attr, \
 	&sensor_dev_attr_fan##offset##_manual.dev_attr.attr, \
-	&sensor_dev_attr_fan##offset##_position.dev_attr.attr, \
+	&sensor_dev_attr_fan##offset##_label.dev_attr.attr, \
 	NULL \
 };
 
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
git-alsa.patch
git-dvb.patch
scx200-use-mutex-instead-of-semaphore.patch
