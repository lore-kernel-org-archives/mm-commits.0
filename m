From: akpm@linux-foundation.org
Subject: - adt7462-70-73-use-div_round_closest-for-rounded-division.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:17:14 -0800
Message-ID: <200901072217.n07MHEPJ016896@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60136 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757083AbZAGWSB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:18:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: djwong@us.ibm.com, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     adt74{62, 70, 73}: Use DIV_ROUND_CLOSEST for rounded division
has been removed from the -mm tree.  Its filename was
     adt7462-70-73-use-div_round_closest-for-rounded-division.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: adt74{62, 70, 73}: Use DIV_ROUND_CLOSEST for rounded division
From: "Darrick J. Wong" <djwong@us.ibm.com>

Modify some hwmon drivers to use DIV_ROUND_CLOSEST instead of bloating
source with (naughty) macros.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/adt7462.c |   14 ++++++--------
 drivers/hwmon/adt7470.c |    8 +++-----
 drivers/hwmon/adt7473.c |   10 ++++------
 3 files changed, 13 insertions(+), 19 deletions(-)

diff -puN drivers/hwmon/adt7462.c~adt7462-70-73-use-div_round_closest-for-rounded-division drivers/hwmon/adt7462.c
--- a/drivers/hwmon/adt7462.c~adt7462-70-73-use-div_round_closest-for-rounded-division
+++ a/drivers/hwmon/adt7462.c
@@ -204,8 +204,6 @@ I2C_CLIENT_INSMOD_1(adt7462);
 #define MASK_AND_SHIFT(value, prefix)	\
 	(((value) & prefix##_MASK) >> prefix##_SHIFT)
 
-#define ROUND_DIV(x, divisor)  (((x) + ((divisor) / 2)) / (divisor))
-
 struct adt7462_data {
 	struct device		*hwmon_dev;
 	struct attribute_group	attrs;
@@ -840,7 +838,7 @@ static ssize_t set_temp_min(struct devic
 	if (strict_strtol(buf, 10, &temp) || !temp_enabled(data, attr->index))
 		return -EINVAL;
 
-	temp = ROUND_DIV(temp, 1000) + 64;
+	temp = DIV_ROUND_CLOSEST(temp, 1000) + 64;
 	temp = SENSORS_LIMIT(temp, 0, 255);
 
 	mutex_lock(&data->lock);
@@ -878,7 +876,7 @@ static ssize_t set_temp_max(struct devic
 	if (strict_strtol(buf, 10, &temp) || !temp_enabled(data, attr->index))
 		return -EINVAL;
 
-	temp = ROUND_DIV(temp, 1000) + 64;
+	temp = DIV_ROUND_CLOSEST(temp, 1000) + 64;
 	temp = SENSORS_LIMIT(temp, 0, 255);
 
 	mutex_lock(&data->lock);
@@ -943,7 +941,7 @@ static ssize_t set_volt_max(struct devic
 		return -EINVAL;
 
 	temp *= 1000; /* convert mV to uV */
-	temp = ROUND_DIV(temp, x);
+	temp = DIV_ROUND_CLOSEST(temp, x);
 	temp = SENSORS_LIMIT(temp, 0, 255);
 
 	mutex_lock(&data->lock);
@@ -985,7 +983,7 @@ static ssize_t set_volt_min(struct devic
 		return -EINVAL;
 
 	temp *= 1000; /* convert mV to uV */
-	temp = ROUND_DIV(temp, x);
+	temp = DIV_ROUND_CLOSEST(temp, x);
 	temp = SENSORS_LIMIT(temp, 0, 255);
 
 	mutex_lock(&data->lock);
@@ -1250,7 +1248,7 @@ static ssize_t set_pwm_hyst(struct devic
 	if (strict_strtol(buf, 10, &temp))
 		return -EINVAL;
 
-	temp = ROUND_DIV(temp, 1000);
+	temp = DIV_ROUND_CLOSEST(temp, 1000);
 	temp = SENSORS_LIMIT(temp, 0, 15);
 
 	/* package things up */
@@ -1337,7 +1335,7 @@ static ssize_t set_pwm_tmin(struct devic
 	if (strict_strtol(buf, 10, &temp))
 		return -EINVAL;
 
-	temp = ROUND_DIV(temp, 1000) + 64;
+	temp = DIV_ROUND_CLOSEST(temp, 1000) + 64;
 	temp = SENSORS_LIMIT(temp, 0, 255);
 
 	mutex_lock(&data->lock);
diff -puN drivers/hwmon/adt7470.c~adt7462-70-73-use-div_round_closest-for-rounded-division drivers/hwmon/adt7470.c
--- a/drivers/hwmon/adt7470.c~adt7462-70-73-use-div_round_closest-for-rounded-division
+++ a/drivers/hwmon/adt7470.c
@@ -137,8 +137,6 @@ I2C_CLIENT_INSMOD_1(adt7470);
 #define FAN_PERIOD_INVALID	65535
 #define FAN_DATA_VALID(x)	((x) && (x) != FAN_PERIOD_INVALID)
 
-#define ROUND_DIV(x, divisor)	(((x) + ((divisor) / 2)) / (divisor))
-
 struct adt7470_data {
 	struct device		*hwmon_dev;
 	struct attribute_group	attrs;
@@ -360,7 +358,7 @@ static ssize_t set_temp_min(struct devic
 	if (strict_strtol(buf, 10, &temp))
 		return -EINVAL;
 
-	temp = ROUND_DIV(temp, 1000);
+	temp = DIV_ROUND_CLOSEST(temp, 1000);
 	temp = SENSORS_LIMIT(temp, 0, 255);
 
 	mutex_lock(&data->lock);
@@ -394,7 +392,7 @@ static ssize_t set_temp_max(struct devic
 	if (strict_strtol(buf, 10, &temp))
 		return -EINVAL;
 
-	temp = ROUND_DIV(temp, 1000);
+	temp = DIV_ROUND_CLOSEST(temp, 1000);
 	temp = SENSORS_LIMIT(temp, 0, 255);
 
 	mutex_lock(&data->lock);
@@ -671,7 +669,7 @@ static ssize_t set_pwm_tmin(struct devic
 	if (strict_strtol(buf, 10, &temp))
 		return -EINVAL;
 
-	temp = ROUND_DIV(temp, 1000);
+	temp = DIV_ROUND_CLOSEST(temp, 1000);
 	temp = SENSORS_LIMIT(temp, 0, 255);
 
 	mutex_lock(&data->lock);
diff -puN drivers/hwmon/adt7473.c~adt7462-70-73-use-div_round_closest-for-rounded-division drivers/hwmon/adt7473.c
--- a/drivers/hwmon/adt7473.c~adt7462-70-73-use-div_round_closest-for-rounded-division
+++ a/drivers/hwmon/adt7473.c
@@ -129,8 +129,6 @@ I2C_CLIENT_INSMOD_1(adt7473);
 #define FAN_PERIOD_INVALID	65535
 #define FAN_DATA_VALID(x)	((x) && (x) != FAN_PERIOD_INVALID)
 
-#define ROUND_DIV(x, divisor)	(((x) + ((divisor) / 2)) / (divisor))
-
 struct adt7473_data {
 	struct device		*hwmon_dev;
 	struct attribute_group	attrs;
@@ -459,7 +457,7 @@ static ssize_t set_temp_min(struct devic
 	if (strict_strtol(buf, 10, &temp))
 		return -EINVAL;
 
-	temp = ROUND_DIV(temp, 1000);
+	temp = DIV_ROUND_CLOSEST(temp, 1000);
 	temp = encode_temp(data->temp_twos_complement, temp);
 
 	mutex_lock(&data->lock);
@@ -495,7 +493,7 @@ static ssize_t set_temp_max(struct devic
 	if (strict_strtol(buf, 10, &temp))
 		return -EINVAL;
 
-	temp = ROUND_DIV(temp, 1000);
+	temp = DIV_ROUND_CLOSEST(temp, 1000);
 	temp = encode_temp(data->temp_twos_complement, temp);
 
 	mutex_lock(&data->lock);
@@ -720,7 +718,7 @@ static ssize_t set_temp_tmax(struct devi
 	if (strict_strtol(buf, 10, &temp))
 		return -EINVAL;
 
-	temp = ROUND_DIV(temp, 1000);
+	temp = DIV_ROUND_CLOSEST(temp, 1000);
 	temp = encode_temp(data->temp_twos_complement, temp);
 
 	mutex_lock(&data->lock);
@@ -756,7 +754,7 @@ static ssize_t set_temp_tmin(struct devi
 	if (strict_strtol(buf, 10, &temp))
 		return -EINVAL;
 
-	temp = ROUND_DIV(temp, 1000);
+	temp = DIV_ROUND_CLOSEST(temp, 1000);
 	temp = encode_temp(data->temp_twos_complement, temp);
 
 	mutex_lock(&data->lock);
_

Patches currently in -mm which might be from djwong@us.ibm.com are

origin.patch
linux-next.patch
fakephp-allocate-pci-resources-before-adding-the-device.patch

