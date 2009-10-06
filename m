From: akpm@linux-foundation.org
Subject: + hwmon-driver-for-texas-instruments-amc6821-chip-update.patch added to -mm tree
Date: Tue, 06 Oct 2009 14:11:46 -0700
Message-ID: <200910062111.n96LBkDg021067@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44167 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933088AbZJFVNC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Oct 2009 17:13:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tomaz.mertelj@guest.arnes.si, khali@linux-fr.org


The patch titled
     hwmon-driver-for-texas-instruments-amc6821-chip-update
has been added to the -mm tree.  Its filename is
     hwmon-driver-for-texas-instruments-amc6821-chip-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hwmon-driver-for-texas-instruments-amc6821-chip-update
From: Tomaz Mertelj <tomaz.mertelj@guest.arnes.si>

I got rid of macro generated callbacks to reduce memory footprint.
simple_strtol was replaced by strict_strtol.
Fixed some errors in documentation.

Signed-off-by: Tomaz Mertelj <tomaz.mertelj@guest.arnes.si>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/hwmon/amc6821 |   12 
 drivers/hwmon/amc6821.c     |  653 ++++++++++++++++++----------------
 2 files changed, 365 insertions(+), 300 deletions(-)

diff -puN Documentation/hwmon/amc6821~hwmon-driver-for-texas-instruments-amc6821-chip-update Documentation/hwmon/amc6821
--- a/Documentation/hwmon/amc6821~hwmon-driver-for-texas-instruments-amc6821-chip-update
+++ a/Documentation/hwmon/amc6821
@@ -46,12 +46,12 @@ fan1_div		rw	Fan divisor can be either 2
 pwm1			rw	pwm1
 pwm1_enable		rw	regulator mode, 1=open loop, 2=fan controlled
 				by remote temperature, 3=fan controlled by
-				combination of on-chip temperature and
+				combination of the on-chip temperature and
 				remote-sensor temperature,
 pwm1_auto_channels_temp ro	1 if pwm_enable==2, 3 if pwm_enable==3
 pwm1_auto_point1_pwm	ro	Hardwired to 0, shared for both
 				temperature channels.
-pwm1_auto_point2_pwm	rw	This value, shared for both temperature
+pwm1_auto_point2_pwm	rw	This value is shared for both temperature
 				channels.
 pwm1_auto_point3_pwm	rw	Hardwired to 255, shared for both
 				temperature channels.
@@ -61,9 +61,9 @@ temp1_auto_point1_temp	ro	Hardwired to t
 temp1_auto_point2_temp	rw	The low-temperature limit of the proportional
 				range. Below this temperature
 				pwm1 = pwm1_auto_point2_pwm. It can go from
-				0 degree C and 124 degree C in steps of
+				0 degree C to 124 degree C in steps of
 				4 degree C. Read it out after writing to get
-				actual value.
+				the actual value.
 temp1_auto_point3_temp	rw	Above this temperature fan runs at maximum
 				speed. It can go from temp1_auto_point2_temp.
 				It can only have certain discrete values
@@ -72,13 +72,13 @@ temp1_auto_point3_temp	rw	Above this tem
 				writing to get the actual value.
 
 temp2_auto_point1_temp	rw	Must be between 0 degree C and 63 degree C and
-				it defines passive cooling temperature.
+				it defines the passive cooling temperature.
 				Below this temperature the fan stops in
 				the closed loop mode.
 temp2_auto_point2_temp	rw	The low-temperature limit of the proportional
 				range. Below this temperature
 				pwm1 = pwm1_auto_point2_pwm. It can go from
-				0 degree C and 124 degree C in steps
+				0 degree C to 124 degree C in steps
 				of 4 degree C.
 
 temp2_auto_point3_temp	rw	Above this temperature fan runs at maximum
diff -puN drivers/hwmon/amc6821.c~hwmon-driver-for-texas-instruments-amc6821-chip-update drivers/hwmon/amc6821.c
--- a/drivers/hwmon/amc6821.c~hwmon-driver-for-texas-instruments-amc6821-chip-update
+++ a/drivers/hwmon/amc6821.c
@@ -123,6 +123,31 @@ I2C_CLIENT_INSMOD_1(amc6821);
 #define AMC6821_STAT2_L_THERM 0x40
 #define AMC6821_STAT2_THERM_IN 0x80
 
+enum {IDX_TEMP1_INPUT = 0, IDX_TEMP1_MIN, IDX_TEMP1_MAX,
+	IDX_TEMP1_CRIT, IDX_TEMP2_INPUT, IDX_TEMP2_MIN,
+	IDX_TEMP2_MAX, IDX_TEMP2_CRIT,
+	TEMP_IDX_LEN, };
+
+static const u8 temp_reg[] = {AMC6821_REG_LTEMP_HI,
+			AMC6821_REG_LTEMP_LIMIT_MIN,
+			AMC6821_REG_LTEMP_LIMIT_MAX,
+			AMC6821_REG_LTEMP_CRIT,
+			AMC6821_REG_RTEMP_HI,
+			AMC6821_REG_RTEMP_LIMIT_MIN,
+			AMC6821_REG_RTEMP_LIMIT_MAX,
+			AMC6821_REG_RTEMP_CRIT, };
+
+enum {IDX_FAN1_INPUT = 0, IDX_FAN1_MIN, IDX_FAN1_MAX,
+	FAN1_IDX_LEN, };
+
+static const u8 fan_reg_low[] = {AMC6821_REG_TDATA_LOW,
+			AMC6821_REG_TACH_LLIMITL,
+			AMC6821_REG_TACH_HLIMITL, };
+
+
+static const u8 fan_reg_hi[] = {AMC6821_REG_TDATA_HI,
+			AMC6821_REG_TACH_LLIMITH,
+			AMC6821_REG_TACH_HLIMITH, };
 
 static int amc6821_probe(
 		struct i2c_client *client,
@@ -170,19 +195,9 @@ struct amc6821_data {
 	unsigned long last_updated; /* in jiffies */
 
 	/* register values */
-	int temp1_input;
-	int temp1_min;
-	int temp1_max;
-	int temp1_crit;
-
-	int temp2_input;
-	int temp2_min;
-	int temp2_max;
-	int temp2_crit;
-
-	u16 fan1_input;
-	u16 fan1_min;
-	u16 fan1_max;
+	int temp[TEMP_IDX_LEN];
+
+	u16 fan[FAN1_IDX_LEN];
 	u8 fan1_div;
 
 	u8 pwm1;
@@ -197,72 +212,87 @@ struct amc6821_data {
 };
 
 
-#define get_temp_para(name) \
-static ssize_t get_##name(\
-		struct device *dev,\
-		struct device_attribute *devattr,\
-		char *buf)\
-{\
-	struct amc6821_data *data = amc6821_update_device(dev);\
-	return sprintf(buf, "%d\n", data->name * 1000);\
-}
-
-get_temp_para(temp1_input);
-get_temp_para(temp1_min);
-get_temp_para(temp1_max);
-get_temp_para(temp2_input);
-get_temp_para(temp2_min);
-get_temp_para(temp2_max);
-get_temp_para(temp1_crit);
-get_temp_para(temp2_crit);
-
-#define set_temp_para(name, reg)\
-static ssize_t set_##name(\
-		struct device *dev,\
-		struct device_attribute *attr,\
-		const char *buf,\
-		size_t count)\
-{ \
-	struct i2c_client *client = to_i2c_client(dev); \
-	struct amc6821_data *data = i2c_get_clientdata(client); \
-	int val = simple_strtol(buf, NULL, 10); \
-	\
-	mutex_lock(&data->update_lock); \
-	data->name = SENSORS_LIMIT(val / 1000, -128, 127); \
-	if (i2c_smbus_write_byte_data(client, reg, data->name)) {\
-		dev_err(&client->dev, "Register write error, aborting.\n");\
-		count = -EIO;\
-	} \
-	mutex_unlock(&data->update_lock); \
-	return count; \
-}
-
-set_temp_para(temp1_min, AMC6821_REG_LTEMP_LIMIT_MIN);
-set_temp_para(temp1_max, AMC6821_REG_LTEMP_LIMIT_MAX);
-set_temp_para(temp2_min, AMC6821_REG_RTEMP_LIMIT_MIN);
-set_temp_para(temp2_max, AMC6821_REG_RTEMP_LIMIT_MAX);
-set_temp_para(temp1_crit, AMC6821_REG_LTEMP_CRIT);
-set_temp_para(temp2_crit, AMC6821_REG_RTEMP_CRIT);
-
-#define get_temp_alarm(name, reg, mask)\
-static ssize_t get_##name(\
-	struct device *dev, \
-	struct device_attribute *devattr,\
-	char *buf)\
-{\
-	struct amc6821_data *data = amc6821_update_device(dev);\
-	if (data->reg &  mask)\
-		return sprintf(buf, "1");\
-	else	\
-		return sprintf(buf, "0");\
-} \
-
-get_temp_alarm(temp1_min_alarm, stat1,	AMC6821_STAT1_LTL)
-get_temp_alarm(temp1_max_alarm, stat1, AMC6821_STAT1_LTH)
-get_temp_alarm(temp2_min_alarm, stat1, AMC6821_STAT1_RTL)
-get_temp_alarm(temp2_max_alarm, stat1, AMC6821_STAT1_RTH)
-get_temp_alarm(temp1_crit_alarm, stat2, AMC6821_STAT2_LTC)
-get_temp_alarm(temp2_crit_alarm, stat2, AMC6821_STAT2_RTC)
+static ssize_t get_temp(
+		struct device *dev,
+		struct device_attribute *devattr,
+		char *buf)
+{
+	struct amc6821_data *data = amc6821_update_device(dev);
+	int ix = to_sensor_dev_attr(devattr)->index;
+
+	return sprintf(buf, "%d\n", data->temp[ix] * 1000);
+}
+
+
+
+static ssize_t set_temp(
+		struct device *dev,
+		struct device_attribute *attr,
+		const char *buf,
+		size_t count)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct amc6821_data *data = i2c_get_clientdata(client);
+	int ix = to_sensor_dev_attr(attr)->index;
+	long val;
+
+	int ret = strict_strtol(buf, 10, &val);
+	if (ret)
+		return ret;
+	val = SENSORS_LIMIT(val / 1000, -128, 127);
+
+	mutex_lock(&data->update_lock);
+	data->temp[ix] = val;
+	if (i2c_smbus_write_byte_data(client, temp_reg[ix], data->temp[ix])) {
+		dev_err(&client->dev, "Register write error, aborting.\n");
+		count = -EIO;
+	}
+	mutex_unlock(&data->update_lock);
+	return count;
+}
+
+
+
+
+static ssize_t get_temp_alarm(
+	struct device *dev,
+	struct device_attribute *devattr,
+	char *buf)
+{
+	struct amc6821_data *data = amc6821_update_device(dev);
+	int ix = to_sensor_dev_attr(devattr)->index;
+	u8 flag;
+
+	switch (ix) {
+	case IDX_TEMP1_MIN:
+		flag = data->stat1 & AMC6821_STAT1_LTL;
+		break;
+	case IDX_TEMP1_MAX:
+		flag = data->stat1 & AMC6821_STAT1_LTH;
+		break;
+	case IDX_TEMP1_CRIT:
+		flag = data->stat2 & AMC6821_STAT2_LTC;
+		break;
+	case IDX_TEMP2_MIN:
+		flag = data->stat1 & AMC6821_STAT1_RTL;
+		break;
+	case IDX_TEMP2_MAX:
+		flag = data->stat1 & AMC6821_STAT1_RTH;
+		break;
+	case IDX_TEMP2_CRIT:
+		flag = data->stat2 & AMC6821_STAT2_RTC;
+		break;
+	default:
+		dev_dbg(dev, "Unknown attr->index (%d).\n", ix);
+		return -EINVAL;
+	}
+	if (flag)
+		return sprintf(buf, "1");
+	else
+		return sprintf(buf, "0");
+}
+
+
 
 
 static ssize_t get_temp2_fault(
@@ -294,7 +324,10 @@ static ssize_t set_pwm1(
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct amc6821_data *data = i2c_get_clientdata(client);
-	int val = simple_strtol(buf, NULL, 10);
+	long val;
+	int ret = strict_strtol(buf, 10, &val);
+	if (ret)
+		return ret;
 
 	mutex_lock(&data->update_lock);
 	data->pwm1 = SENSORS_LIMIT(val , 0, 255);
@@ -320,9 +353,12 @@ static ssize_t set_pwm1_enable(
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct amc6821_data *data = i2c_get_clientdata(client);
-	int val = simple_strtol(buf, NULL, 10);
+	long val;
+	int config = strict_strtol(buf, 10, &val);
+	if (config)
+		return config;
 
-	int config = i2c_smbus_read_byte_data(client, AMC6821_REG_CONF1);
+	config = i2c_smbus_read_byte_data(client, AMC6821_REG_CONF1);
 	if (config < 0) {
 			dev_err(&client->dev,
 			"Error reading configuration register, aborting.\n");
@@ -366,101 +402,147 @@ static ssize_t get_pwm1_auto_channels_te
 }
 
 
-#define get_auto_point(name)\
-static ssize_t get_##name(\
-		struct device *dev,\
-		struct device_attribute *devattr,\
-		char *buf)\
-{\
-	int nr = to_sensor_dev_attr(devattr)->index;\
-	struct amc6821_data *data = amc6821_update_device(dev);\
-	return sprintf(buf, "%d\n", data->name[nr] * 1000);\
+static ssize_t get_temp_auto_point_temp(
+		struct device *dev,
+		struct device_attribute *devattr,
+		char *buf)
+{
+	int ix = to_sensor_dev_attr_2(devattr)->index;
+	int nr = to_sensor_dev_attr_2(devattr)->nr;
+	struct amc6821_data *data = amc6821_update_device(dev);
+	switch (nr) {
+	case 1:
+		return sprintf(buf, "%d\n",
+			data->temp1_auto_point_temp[ix] * 1000);
+		break;
+	case 2:
+		return sprintf(buf, "%d\n",
+			data->temp2_auto_point_temp[ix] * 1000);
+		break;
+	default:
+		dev_dbg(dev, "Unknown attr->nr (%d).\n", nr);
+		return -EINVAL;
+	}
 }
 
-get_auto_point(temp1_auto_point_temp);
-get_auto_point(temp2_auto_point_temp);
 
 static ssize_t get_pwm1_auto_point_pwm(
 		struct device *dev,
 		struct device_attribute *devattr,
 		char *buf)
 {
-	int nr = to_sensor_dev_attr(devattr)->index;
+	int ix = to_sensor_dev_attr(devattr)->index;
 	struct amc6821_data *data = amc6821_update_device(dev);
-	return sprintf(buf, "%d\n", data->pwm1_auto_point_pwm[nr]);
+	return sprintf(buf, "%d\n", data->pwm1_auto_point_pwm[ix]);
 }
 
 
-#define set_temp_auto_point_temp(name, reg)\
-static ssize_t set_##name(\
-		struct device *dev,\
-		struct device_attribute *attr,\
-		const char *buf,\
-		size_t count)\
-{ \
-	struct i2c_client *client = to_i2c_client(dev); \
-	struct amc6821_data *data = amc6821_update_device(dev);\
-	int nr = to_sensor_dev_attr(attr)->index;\
-	int val = simple_strtol(buf, NULL, 10); \
-	u8 tmp;\
-	int dt;\
-	int dpwm;\
-	\
-	mutex_lock(&data->update_lock); \
-	switch (nr) {\
-	case 0:\
-		data->name[0] = SENSORS_LIMIT(val / 1000, 0,\
-				data->temp1_auto_point_temp[1]);\
-		data->name[0] = SENSORS_LIMIT(data->name[0], 0,\
-				data->temp2_auto_point_temp[1]);\
-		data->name[0] = SENSORS_LIMIT(data->name[0], 0, 63); \
-		data->valid = 0;\
-		if (i2c_smbus_write_byte_data(\
-					client,\
-					AMC6821_REG_PSV_TEMP,\
-					data->name[0])) {\
-				dev_err(&client->dev,\
-					"Register write error, aborting.\n");\
-				count = -EIO;\
-		} \
-		goto EXIT;\
-		break;\
-	case 1:\
-		data->name[1] = SENSORS_LIMIT(\
-					val / 1000,\
-					(data->name[0] & 0x7C) + 4,\
-					124);\
-		data->name[1] &= 0x7C;\
-		data->name[2] = SENSORS_LIMIT(\
-					data->name[2], data->name[1] + 1,\
-					255);\
-		break;\
-	case 2:\
-		data->name[2] = SENSORS_LIMIT(\
-					val / 1000,\
-					data->name[1]+1,\
-					255); \
-		break;\
-	} \
-	dt = data->name[2]-data->name[1];\
-	dpwm = data->pwm1_auto_point_pwm[2] - data->pwm1_auto_point_pwm[1];\
-	for (tmp = 4; tmp > 0; tmp--) {\
-		if (dt * (0x20 >> tmp) >= dpwm)\
-			break;\
-	} \
-	tmp |= (data->name[1] & 0x7C) << 1;\
-	if (i2c_smbus_write_byte_data(client, reg, tmp)) {\
-		dev_err(&client->dev, "Register write error, aborting.\n");\
-		count = -EIO;\
-	} \
-	data->valid = 0;\
-EXIT:\
-	mutex_unlock(&data->update_lock); \
-	return count; \
+static inline ssize_t set_slope_register(struct i2c_client *client,
+		u8 reg,
+		u8 dpwm,
+		u8 *ptemp)
+{
+	int dt;
+	u8 tmp;
+
+	dt = ptemp[2]-ptemp[1];
+	for (tmp = 4; tmp > 0; tmp--) {
+		if (dt * (0x20 >> tmp) >= dpwm)
+			break;
+	}
+	tmp |= (ptemp[1] & 0x7C) << 1;
+	if (i2c_smbus_write_byte_data(client,
+			reg, tmp)) {
+		dev_err(&client->dev, "Register write error, aborting.\n");
+		return -EIO;
+	}
+	return 0;
 }
 
-set_temp_auto_point_temp(temp1_auto_point_temp, AMC6821_REG_LTEMP_FAN_CTRL);
-set_temp_auto_point_temp(temp2_auto_point_temp, AMC6821_REG_RTEMP_FAN_CTRL);
+
+
+static ssize_t set_temp_auto_point_temp(
+		struct device *dev,
+		struct device_attribute *attr,
+		const char *buf,
+		size_t count)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct amc6821_data *data = amc6821_update_device(dev);
+	int ix = to_sensor_dev_attr_2(attr)->index;
+	int nr = to_sensor_dev_attr_2(attr)->nr;
+	u8 *ptemp;
+	u8 reg;
+	int dpwm;
+	long val;
+	int ret = strict_strtol(buf, 10, &val);
+	if (ret)
+		return ret;
+
+	switch (nr) {
+	case 1:
+		ptemp = data->temp1_auto_point_temp;
+		reg = AMC6821_REG_LTEMP_FAN_CTRL;
+		break;
+	case 2:
+		ptemp = data->temp2_auto_point_temp;
+		reg = AMC6821_REG_RTEMP_FAN_CTRL;
+		break;
+	default:
+		dev_dbg(dev, "Unknown attr->nr (%d).\n", nr);
+		return -EINVAL;
+	}
+
+	data->valid = 0;
+	mutex_lock(&data->update_lock);
+	switch (ix) {
+	case 0:
+		ptemp[0] = SENSORS_LIMIT(val / 1000, 0,
+				data->temp1_auto_point_temp[1]);
+		ptemp[0] = SENSORS_LIMIT(ptemp[0], 0,
+				data->temp2_auto_point_temp[1]);
+		ptemp[0] = SENSORS_LIMIT(ptemp[0], 0, 63);
+		if (i2c_smbus_write_byte_data(
+					client,
+					AMC6821_REG_PSV_TEMP,
+					ptemp[0])) {
+				dev_err(&client->dev,
+					"Register write error, aborting.\n");
+				count = -EIO;
+		}
+		goto EXIT;
+		break;
+	case 1:
+		ptemp[1] = SENSORS_LIMIT(
+					val / 1000,
+					(ptemp[0] & 0x7C) + 4,
+					124);
+		ptemp[1] &= 0x7C;
+		ptemp[2] = SENSORS_LIMIT(
+					ptemp[2], ptemp[1] + 1,
+					255);
+		break;
+	case 2:
+		ptemp[2] = SENSORS_LIMIT(
+					val / 1000,
+					ptemp[1]+1,
+					255);
+		break;
+	default:
+		dev_dbg(dev, "Unknown attr->index (%d).\n", ix);
+		count = -EINVAL;
+		goto EXIT;
+	}
+	dpwm = data->pwm1_auto_point_pwm[2] - data->pwm1_auto_point_pwm[1];
+	if (set_slope_register(client, reg, dpwm, ptemp))
+		count = -EIO;
+
+EXIT:
+	mutex_unlock(&data->update_lock);
+	return count;
+}
+
+
 
 static ssize_t set_pwm1_auto_point_pwm(
 		struct device *dev,
@@ -470,10 +552,11 @@ static ssize_t set_pwm1_auto_point_pwm(
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct amc6821_data *data = i2c_get_clientdata(client);
-	int val = simple_strtol(buf, NULL, 10);
-	u8 tmp;
-	int dt;
 	int dpwm;
+	long val;
+	int ret = strict_strtol(buf, 10, &val);
+	if (ret)
+		return ret;
 
 	mutex_lock(&data->update_lock);
 	data->pwm1_auto_point_pwm[1] = SENSORS_LIMIT(val, 0, 254);
@@ -481,52 +564,39 @@ static ssize_t set_pwm1_auto_point_pwm(
 			data->pwm1_auto_point_pwm[1])) {
 		dev_err(&client->dev, "Register write error, aborting.\n");
 		count = -EIO;
+		goto EXIT;
 	}
-
 	dpwm = data->pwm1_auto_point_pwm[2] - data->pwm1_auto_point_pwm[1];
-	dt = data->temp1_auto_point_temp[2]-data->temp1_auto_point_temp[1];
-	for (tmp = 4; tmp > 0; tmp--) {
-		if (dt * (0x20 >> tmp) >= dpwm)
-			break;
-	}
-	tmp |= (data->temp1_auto_point_temp[1] & 0x7C) << 1;
-	if (i2c_smbus_write_byte_data(client,
-			AMC6821_REG_LTEMP_FAN_CTRL, tmp)) {
-		dev_err(&client->dev, "Register write error, aborting.\n");
+	if (set_slope_register(client, AMC6821_REG_LTEMP_FAN_CTRL, dpwm,
+			data->temp1_auto_point_temp)) {
 		count = -EIO;
+		goto EXIT;
 	}
-
-	dt = data->temp2_auto_point_temp[2]-data->temp2_auto_point_temp[1];
-	for (tmp = 4; tmp > 0; tmp--) {
-		if (dt * (0x20 >> tmp) >= dpwm)
-			break;
-	}
-	tmp |= (data->temp2_auto_point_temp[1] & 0x7C) << 1;
-	if (i2c_smbus_write_byte_data(client,
-			AMC6821_REG_RTEMP_FAN_CTRL, tmp)) {
-		dev_err(&client->dev, "Register write error, aborting.\n");
+	if (set_slope_register(client, AMC6821_REG_RTEMP_FAN_CTRL, dpwm,
+			data->temp2_auto_point_temp)) {
 		count = -EIO;
+		goto EXIT;
 	}
+
+EXIT:
 	data->valid = 0;
 	mutex_unlock(&data->update_lock);
 	return count;
 }
 
-
-#define get_fan_para(name) static ssize_t get_##name(\
-		struct device *dev,\
-		struct device_attribute *devattr,\
-		char *buf)\
-{ \
-	struct amc6821_data *data = amc6821_update_device(dev); \
-	if (0 == data->name)\
-		return sprintf(buf, "0");\
-	return sprintf(buf, "%d\n", (int)(6000000 / data->name)); \
+static ssize_t get_fan(
+		struct device *dev,
+		struct device_attribute *devattr,
+		char *buf)
+{
+	struct amc6821_data *data = amc6821_update_device(dev);
+	int ix = to_sensor_dev_attr(devattr)->index;
+	if (0 == data->fan[ix])
+		return sprintf(buf, "0");
+	return sprintf(buf, "%d\n", (int)(6000000 / data->fan[ix]));
 }
 
-get_fan_para(fan1_input);
-get_fan_para(fan1_min);
-get_fan_para(fan1_max);
+
 
 static ssize_t get_fan1_fault(
 		struct device *dev,
@@ -541,34 +611,39 @@ static ssize_t get_fan1_fault(
 }
 
 
-#define set_fan_para(name, reg) \
-static ssize_t set_##name(\
-		struct device *dev,\
-		struct device_attribute *attr,\
-		const char *buf, size_t count)\
-{ \
-	struct i2c_client *client = to_i2c_client(dev); \
-	struct amc6821_data *data = i2c_get_clientdata(client); \
-	int val = simple_strtol(buf, NULL, 10); \
-	val = 1 > val ? 0xFFFF : 6000000/val; \
-\
-	mutex_lock(&data->update_lock); \
-	data->name = (u16) SENSORS_LIMIT(val, 1, 0xFFFF); \
-	if (i2c_smbus_write_byte_data(client, reg, data->name & 0xFF)) { \
-		dev_err(&client->dev, "Register write error, aborting.\n");\
-		count = -EIO;\
-	} \
-	if (i2c_smbus_write_byte_data(client, reg+1, data->name >> 8)) { \
-		dev_err(&client->dev, "Register write error, aborting.\n");\
-		count = -EIO;\
-	} \
-	mutex_unlock(&data->update_lock); \
-	return count; \
-}
 
+static ssize_t set_fan(
+		struct device *dev,
+		struct device_attribute *attr,
+		const char *buf, size_t count)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct amc6821_data *data = i2c_get_clientdata(client);
+	long val;
+	int ix = to_sensor_dev_attr(attr)->index;
+	int ret = strict_strtol(buf, 10, &val);
+	if (ret)
+		return ret;
+	val = 1 > val ? 0xFFFF : 6000000/val;
+
+	mutex_lock(&data->update_lock);
+	data->fan[ix] = (u16) SENSORS_LIMIT(val, 1, 0xFFFF);
+	if (i2c_smbus_write_byte_data(client, fan_reg_low[ix],
+			data->fan[ix] & 0xFF)) {
+		dev_err(&client->dev, "Register write error, aborting.\n");
+		count = -EIO;
+		goto EXIT;
+	}
+	if (i2c_smbus_write_byte_data(client,
+			fan_reg_hi[ix], data->fan[ix] >> 8)) {
+		dev_err(&client->dev, "Register write error, aborting.\n");
+		count = -EIO;
+	}
+EXIT:
+	mutex_unlock(&data->update_lock);
+	return count;
+}
 
-set_fan_para(fan1_min, AMC6821_REG_TACH_LLIMITL);
-set_fan_para(fan1_max, AMC6821_REG_TACH_HLIMITL);
 
 
 static ssize_t get_fan1_div(
@@ -587,9 +662,12 @@ static ssize_t set_fan1_div(
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct amc6821_data *data = i2c_get_clientdata(client);
-	int val = simple_strtol(buf, NULL, 10);
-	int config = i2c_smbus_read_byte_data(client, AMC6821_REG_CONF4);
+	long val;
+	int config = strict_strtol(buf, 10, &val);
+	if (config)
+		return config;
 
+	config = i2c_smbus_read_byte_data(client, AMC6821_REG_CONF4);
 	if (config < 0) {
 		dev_err(&client->dev,
 			"Error reading configuration register, aborting.\n");
@@ -607,53 +685,56 @@ static ssize_t set_fan1_div(
 		break;
 	default:
 		mutex_unlock(&data->update_lock);
-		return -EINVAL;
+		count = -EINVAL;
+		goto EXIT;
 	}
 	if (i2c_smbus_write_byte_data(client, AMC6821_REG_CONF4, config)) {
 		dev_err(&client->dev,
 			"Configuration register write error, aborting.\n");
 		count = -EIO;
 	}
+EXIT:
 	mutex_unlock(&data->update_lock);
 	return count;
 }
 
 
 
-static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, get_temp1_input, NULL, 0);
-static SENSOR_DEVICE_ATTR(temp1_min, S_IRUGO | S_IWUSR, get_temp1_min,
-	set_temp1_min, 0);
-static SENSOR_DEVICE_ATTR(temp1_max, S_IRUGO | S_IWUSR, get_temp1_max,
-	set_temp1_max, 0);
-static SENSOR_DEVICE_ATTR(temp1_crit, S_IRUGO | S_IWUSR, get_temp1_crit,
-	set_temp1_crit, 0);
+static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO,
+	get_temp, NULL, IDX_TEMP1_INPUT);
+static SENSOR_DEVICE_ATTR(temp1_min, S_IRUGO | S_IWUSR, get_temp,
+	set_temp, IDX_TEMP1_MIN);
+static SENSOR_DEVICE_ATTR(temp1_max, S_IRUGO | S_IWUSR, get_temp,
+	set_temp, IDX_TEMP1_MAX);
+static SENSOR_DEVICE_ATTR(temp1_crit, S_IRUGO | S_IWUSR, get_temp,
+	set_temp, IDX_TEMP1_CRIT);
 static SENSOR_DEVICE_ATTR(temp1_min_alarm, S_IRUGO,
-	get_temp1_min_alarm, NULL, 0);
+	get_temp_alarm, NULL, IDX_TEMP1_MIN);
 static SENSOR_DEVICE_ATTR(temp1_max_alarm, S_IRUGO,
-	get_temp1_max_alarm, NULL, 0);
+	get_temp_alarm, NULL, IDX_TEMP1_MAX);
 static SENSOR_DEVICE_ATTR(temp1_crit_alarm, S_IRUGO,
-	get_temp1_crit_alarm, NULL, 0);
+	get_temp_alarm, NULL, IDX_TEMP1_CRIT);
 static SENSOR_DEVICE_ATTR(temp2_input, S_IRUGO | S_IWUSR,
-	get_temp2_input, NULL, 0);
-static SENSOR_DEVICE_ATTR(temp2_min, S_IRUGO | S_IWUSR, get_temp2_min,
-	set_temp2_min, 0);
-static SENSOR_DEVICE_ATTR(temp2_max, S_IRUGO | S_IWUSR, get_temp2_max,
-	set_temp2_max, 0);
-static SENSOR_DEVICE_ATTR(temp2_crit, S_IRUGO | S_IWUSR, get_temp2_crit,
-	set_temp2_crit, 0);
+	get_temp, NULL, IDX_TEMP2_INPUT);
+static SENSOR_DEVICE_ATTR(temp2_min, S_IRUGO | S_IWUSR, get_temp,
+	set_temp, IDX_TEMP2_MIN);
+static SENSOR_DEVICE_ATTR(temp2_max, S_IRUGO | S_IWUSR, get_temp,
+	set_temp, IDX_TEMP2_MAX);
+static SENSOR_DEVICE_ATTR(temp2_crit, S_IRUGO | S_IWUSR, get_temp,
+	set_temp, IDX_TEMP2_CRIT);
 static SENSOR_DEVICE_ATTR(temp2_fault, S_IRUGO,
 	get_temp2_fault, NULL, 0);
 static SENSOR_DEVICE_ATTR(temp2_min_alarm, S_IRUGO,
-	get_temp2_min_alarm, NULL, 0);
+	get_temp_alarm, NULL, IDX_TEMP2_MIN);
 static SENSOR_DEVICE_ATTR(temp2_max_alarm, S_IRUGO,
-	get_temp2_max_alarm, NULL, 0);
+	get_temp_alarm, NULL, IDX_TEMP2_MAX);
 static SENSOR_DEVICE_ATTR(temp2_crit_alarm, S_IRUGO,
-	get_temp2_crit_alarm, NULL, 0);
-static SENSOR_DEVICE_ATTR(fan1_input, S_IRUGO, get_fan1_input, NULL, 0);
+	get_temp_alarm, NULL, IDX_TEMP2_CRIT);
+static SENSOR_DEVICE_ATTR(fan1_input, S_IRUGO, get_fan, NULL, IDX_FAN1_INPUT);
 static SENSOR_DEVICE_ATTR(fan1_min, S_IRUGO | S_IWUSR,
-	get_fan1_min, set_fan1_min, 0);
+	get_fan, set_fan, IDX_FAN1_MIN);
 static SENSOR_DEVICE_ATTR(fan1_max, S_IRUGO | S_IWUSR,
-	get_fan1_max, set_fan1_max, 0);
+	get_fan, set_fan, IDX_FAN1_MAX);
 static SENSOR_DEVICE_ATTR(fan1_fault, S_IRUGO, get_fan1_fault, NULL, 0);
 static SENSOR_DEVICE_ATTR(fan1_div, S_IRUGO | S_IWUSR,
 	get_fan1_div, set_fan1_div, 0);
@@ -669,19 +750,19 @@ static SENSOR_DEVICE_ATTR(pwm1_auto_poin
 	get_pwm1_auto_point_pwm, NULL, 2);
 static SENSOR_DEVICE_ATTR(pwm1_auto_channels_temp, S_IRUGO,
 	get_pwm1_auto_channels_temp, NULL, 0);
-static SENSOR_DEVICE_ATTR(temp1_auto_point1_temp, S_IRUGO,
-	get_temp1_auto_point_temp, NULL, 0);
-static SENSOR_DEVICE_ATTR(temp1_auto_point2_temp, S_IWUSR | S_IRUGO,
-	get_temp1_auto_point_temp, set_temp1_auto_point_temp, 1);
-static SENSOR_DEVICE_ATTR(temp1_auto_point3_temp, S_IWUSR | S_IRUGO,
-	get_temp1_auto_point_temp, set_temp1_auto_point_temp, 2);
-
-static SENSOR_DEVICE_ATTR(temp2_auto_point1_temp, S_IWUSR | S_IRUGO,
-	get_temp2_auto_point_temp, set_temp2_auto_point_temp, 0);
-static SENSOR_DEVICE_ATTR(temp2_auto_point2_temp, S_IWUSR | S_IRUGO,
-	get_temp2_auto_point_temp, set_temp2_auto_point_temp, 1);
-static SENSOR_DEVICE_ATTR(temp2_auto_point3_temp, S_IWUSR | S_IRUGO,
-	get_temp2_auto_point_temp, set_temp2_auto_point_temp, 2);
+static SENSOR_DEVICE_ATTR_2(temp1_auto_point1_temp, S_IRUGO,
+	get_temp_auto_point_temp, NULL, 1, 0);
+static SENSOR_DEVICE_ATTR_2(temp1_auto_point2_temp, S_IWUSR | S_IRUGO,
+	get_temp_auto_point_temp, set_temp_auto_point_temp, 1, 1);
+static SENSOR_DEVICE_ATTR_2(temp1_auto_point3_temp, S_IWUSR | S_IRUGO,
+	get_temp_auto_point_temp, set_temp_auto_point_temp, 1, 2);
+
+static SENSOR_DEVICE_ATTR_2(temp2_auto_point1_temp, S_IWUSR | S_IRUGO,
+	get_temp_auto_point_temp, set_temp_auto_point_temp, 2, 0);
+static SENSOR_DEVICE_ATTR_2(temp2_auto_point2_temp, S_IWUSR | S_IRUGO,
+	get_temp_auto_point_temp, set_temp_auto_point_temp, 2, 1);
+static SENSOR_DEVICE_ATTR_2(temp2_auto_point3_temp, S_IWUSR | S_IRUGO,
+	get_temp_auto_point_temp, set_temp_auto_point_temp, 2, 2);
 
 
 
@@ -736,7 +817,7 @@ static int amc6821_detect(
 	struct i2c_adapter *adapter = client->adapter;
 	int address = client->addr;
 
-	dev_dbg(&adapter->dev, "amc6821_detect called, kind = %d\n", kind);
+	dev_dbg(&adapter->dev, "amc6821_detect called, kind = %d.\n", kind);
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)) {
 		dev_dbg(&adapter->dev,
@@ -904,28 +985,16 @@ static struct amc6821_data *amc6821_upda
 	struct amc6821_data *data = i2c_get_clientdata(client);
 	int timeout = HZ;
 	u8 reg;
+	int i;
 
 	mutex_lock(&data->update_lock);
 
 	if (time_after(jiffies, data->last_updated + timeout) ||
 			!data->valid) {
-		data->temp1_input = i2c_smbus_read_byte_data(client,
-			AMC6821_REG_LTEMP_HI);
-		data->temp1_min = i2c_smbus_read_byte_data(client,
-			AMC6821_REG_LTEMP_LIMIT_MIN);
-		data->temp1_max = i2c_smbus_read_byte_data(client,
-			AMC6821_REG_LTEMP_LIMIT_MAX);
-		data->temp1_crit = i2c_smbus_read_byte_data(client,
-			AMC6821_REG_LTEMP_CRIT);
-
-		data->temp2_input = i2c_smbus_read_byte_data(client,
-			AMC6821_REG_RTEMP_HI);
-		data->temp2_min = i2c_smbus_read_byte_data(client,
-			AMC6821_REG_RTEMP_LIMIT_MIN);
-		data->temp2_max = i2c_smbus_read_byte_data(client,
-			AMC6821_REG_RTEMP_LIMIT_MAX);
-		data->temp2_crit = i2c_smbus_read_byte_data(client,
-			AMC6821_REG_RTEMP_CRIT);
+
+		for (i = 0; i < TEMP_IDX_LEN; i++)
+			data->temp[i] = i2c_smbus_read_byte_data(client,
+				temp_reg[i]);
 
 		data->stat1 = i2c_smbus_read_byte_data(client,
 			AMC6821_REG_STAT1);
@@ -934,18 +1003,14 @@ static struct amc6821_data *amc6821_upda
 
 		data->pwm1 = i2c_smbus_read_byte_data(client,
 			AMC6821_REG_DCY);
-		data->fan1_input = i2c_smbus_read_byte_data(client,
-			AMC6821_REG_TDATA_LOW);
-		data->fan1_input += i2c_smbus_read_byte_data(client,
-			AMC6821_REG_TDATA_HI) << 8;
-		data->fan1_min = i2c_smbus_read_byte_data(client,
-			AMC6821_REG_TACH_LLIMITL);
-		data->fan1_min += i2c_smbus_read_byte_data(client,
-			AMC6821_REG_TACH_LLIMITL+1) << 8;
-		data->fan1_max = i2c_smbus_read_byte_data(client,
-			AMC6821_REG_TACH_HLIMITL);
-		data->fan1_max += i2c_smbus_read_byte_data(client,
-			AMC6821_REG_TACH_HLIMITL+1) << 8;
+		for (i = 0; i < FAN1_IDX_LEN; i++) {
+			data->fan[i] = i2c_smbus_read_byte_data(
+					client,
+					fan_reg_low[i]);
+			data->fan[i] += i2c_smbus_read_byte_data(
+					client,
+					fan_reg_hi[i]) << 8;
+		}
 		data->fan1_div = i2c_smbus_read_byte_data(client,
 			AMC6821_REG_CONF4);
 		data->fan1_div = data->fan1_div & AMC6821_CONF4_PSPR ? 4 : 2;
_

Patches currently in -mm which might be from tomaz.mertelj@guest.arnes.si are

hwmon-driver-for-texas-instruments-amc6821-chip.patch
hwmon-driver-for-texas-instruments-amc6821-chip-update.patch

