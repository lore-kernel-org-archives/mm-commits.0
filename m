From: akpm@linux-foundation.org
Subject: + applesmc-use-standard-sysfs-names-for-labels.patch added to -mm tree
Date: Tue, 08 May 2007 14:31:24 -0700
Message-ID: <200705082131.l48LVOKp002277@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52101 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968104AbXEHVbs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 17:31:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, nicolas@boichat.ch


The patch titled
     applesmc: Use standard sysfs names for labels
has been added to the -mm tree.  Its filename is
     applesmc-use-standard-sysfs-names-for-labels.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 2 insertions(+), 2 deletions(-)

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
apple-smc-driver-hardware-monitoring-and-control.patch
oss-strlcpy-is-smart-enough.patch
rtc-add-rtc-class-driver-for-the-maxim-max6900.patch
legacy-pc-parports-support-parport-dev.patch
layered-parport-code-uses-parport-dev.patch
clean-up-mutex_trylock-noise.patch
fbdev-dont-show-logo-if-driver-or-fbcon-are-modular.patch
rivafb-handle-i2c-bus-creation-failure.patch
rivafb-nvidiafb-various-cleanups.patch
rivafb-fixed-reversed-ddc-ports.patch
applesmc-use-the-address-as-platform-device-id.patch
applesmc-use-standard-sysfs-names-for-labels.patch
git-alsa.patch
scx200-use-mutex-instead-of-semaphore.patch
x86-msr-add-support-for-safe-variants.patch
