From: akpm@linux-foundation.org
Subject: + regulator-virtual-consumer-current-limit-support.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:38:25 -0700
Message-ID: <200807111844.m6BIi6DO030846@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36072 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754652AbYGKSoN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:44:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: philipp.zabel@gmail.com, broonie@opensource.wolfsonmicro.com, lg@opensource.wolfsonmicro.com


The patch titled
     regulator: virtual consumer current limit support
has been added to the -mm tree.  Its filename is
     regulator-virtual-consumer-current-limit-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: regulator: virtual consumer current limit support
From: Philipp Zabel <philipp.zabel@gmail.com>

This expands the virtual consumer driver to handle current limit control
via the min_microamps and max_microamps sysfs files.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
Cc: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/regulator/virtual.c |   99 ++++++++++++++++++++++++++++++++--
 1 file changed, 96 insertions(+), 3 deletions(-)

diff -puN drivers/regulator/virtual.c~regulator-virtual-consumer-current-limit-support drivers/regulator/virtual.c
--- a/drivers/regulator/virtual.c~regulator-virtual-consumer-current-limit-support
+++ a/drivers/regulator/virtual.c
@@ -22,10 +22,12 @@ struct virtual_consumer_data {
 	int enabled;
 	int min_uV;
 	int max_uV;
+	int min_uA;
+	int max_uA;
 	unsigned int mode;
 };
 
-static void update_constraints(struct virtual_consumer_data *data)
+static void update_voltage_constraints(struct virtual_consumer_data *data)
 {
 	int ret;
 
@@ -59,6 +61,41 @@ static void update_constraints(struct vi
 	}
 }
 
+static void update_current_limit_constraints(struct virtual_consumer_data
+						*data)
+{
+	int ret;
+
+	if (data->max_uA
+	    && data->min_uA <= data->max_uA) {
+		ret = regulator_set_current_limit(data->regulator,
+					data->min_uA, data->max_uA);
+		if (ret != 0) {
+			pr_err("regulator_set_current_limit() failed: %d\n",
+			       ret);
+			return;
+		}
+	}
+
+	if (data->max_uA && !data->enabled) {
+		ret = regulator_enable(data->regulator);
+		if (ret == 0)
+			data->enabled = 1;
+		else
+			printk(KERN_ERR "regulator_enable() failed: %d\n",
+				ret);
+	}
+
+	if (!(data->min_uA && data->max_uA) && data->enabled) {
+		ret = regulator_disable(data->regulator);
+		if (ret == 0)
+			data->enabled = 0;
+		else
+			printk(KERN_ERR "regulator_disable() failed: %d\n",
+				ret);
+	}
+}
+
 static ssize_t show_min_uV(struct device *dev,
 			   struct device_attribute *attr, char *buf)
 {
@@ -78,7 +115,7 @@ static ssize_t set_min_uV(struct device 
 	mutex_lock(&data->lock);
 
 	data->min_uV = val;
-	update_constraints(data);
+	update_voltage_constraints(data);
 
 	mutex_unlock(&data->lock);
 
@@ -104,7 +141,59 @@ static ssize_t set_max_uV(struct device 
 	mutex_lock(&data->lock);
 
 	data->max_uV = val;
-	update_constraints(data);
+	update_voltage_constraints(data);
+
+	mutex_unlock(&data->lock);
+
+	return count;
+}
+
+static ssize_t show_min_uA(struct device *dev,
+			   struct device_attribute *attr, char *buf)
+{
+	struct virtual_consumer_data *data = dev_get_drvdata(dev);
+	return sprintf(buf, "%d\n", data->min_uA);
+}
+
+static ssize_t set_min_uA(struct device *dev, struct device_attribute *attr,
+			  const char *buf, size_t count)
+{
+	struct virtual_consumer_data *data = dev_get_drvdata(dev);
+	long val;
+
+	if (strict_strtol(buf, 10, &val) != 0)
+		return count;
+
+	mutex_lock(&data->lock);
+
+	data->min_uA = val;
+	update_current_limit_constraints(data);
+
+	mutex_unlock(&data->lock);
+
+	return count;
+}
+
+static ssize_t show_max_uA(struct device *dev,
+			   struct device_attribute *attr, char *buf)
+{
+	struct virtual_consumer_data *data = dev_get_drvdata(dev);
+	return sprintf(buf, "%d\n", data->max_uA);
+}
+
+static ssize_t set_max_uA(struct device *dev, struct device_attribute *attr,
+			  const char *buf, size_t count)
+{
+	struct virtual_consumer_data *data = dev_get_drvdata(dev);
+	long val;
+
+	if (strict_strtol(buf, 10, &val) != 0)
+		return count;
+
+	mutex_lock(&data->lock);
+
+	data->max_uA = val;
+	update_current_limit_constraints(data);
 
 	mutex_unlock(&data->lock);
 
@@ -163,11 +252,15 @@ static ssize_t set_mode(struct device *d
 
 static DEVICE_ATTR(min_microvolts, 0666, show_min_uV, set_min_uV);
 static DEVICE_ATTR(max_microvolts, 0666, show_max_uV, set_max_uV);
+static DEVICE_ATTR(min_microamps, 0666, show_min_uA, set_min_uA);
+static DEVICE_ATTR(max_microamps, 0666, show_max_uA, set_max_uA);
 static DEVICE_ATTR(mode, 0666, show_mode, set_mode);
 
 struct device_attribute *attributes[] = {
 	&dev_attr_min_microvolts,
 	&dev_attr_max_microvolts,
+	&dev_attr_min_microamps,
+	&dev_attr_max_microamps,
 	&dev_attr_mode,
 };
 
_

Patches currently in -mm which might be from philipp.zabel@gmail.com are

origin.patch
linux-next.patch
regulator-ti-bq24022-li-ion-charger-driver.patch
regulator-ti-bq24022-li-ion-charger-driver-fix.patch
regulator-virtual-consumer-current-limit-support.patch

