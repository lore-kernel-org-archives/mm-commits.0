From: akpm@linux-foundation.org
Subject: + hwmon-w83627ehf-updates.patch added to -mm tree
Date: Fri, 16 Oct 2009 15:28:49 -0700
Message-ID: <200910162228.n9GMSnAR018706@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36944 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750911AbZJPW3L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Oct 2009 18:29:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daniel.blueman@gmail.com, david.c.hubbard@gmail.com, hdegoede@redhat.com, khali@linux-fr.org


The patch titled
     hwmon: w83627ehf updates
has been added to the -mm tree.  Its filename is
     hwmon-w83627ehf-updates.patch

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
Subject: hwmon: w83627ehf updates
From: Daniel J Blueman <daniel.blueman@gmail.com>

Add control of fan minimum turn-on output levels, decoupling it from the
fan turn-off output level.  Add control of rate of change of fan output
level.  These in turn allow lower turn-off rotor speed and smoother
transitions for better thermal and acoustic control authority.  Add
support for constant fan speed and proportional-response operations modes.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: David Hubbard <david.c.hubbard@gmail.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN Documentation/hwmon/w83627ehf~hwmon-w83627ehf-updates Documentation/hwmon/w83627ehf
--- a/Documentation/hwmon/w83627ehf~hwmon-w83627ehf-updates
+++ a/Documentation/hwmon/w83627ehf
@@ -81,8 +81,14 @@ pwm[1-4] - this file stores PWM duty cyc
 	   0 (stop) to 255 (full)
 
 pwm[1-4]_enable - this file controls mode of fan/temperature control:
-	* 1 Manual Mode, write to pwm file any value 0-255 (full speed)
-	* 2 Thermal Cruise
+	* 1 Manual mode, write to pwm file any value 0-255 (full speed)
+	* 2 "Thermal Cruise" mode
+	* 3 "Fan Speed Cruise" mode
+	* 4 "Smart Fan III" mode
+
+pwm[1-4]_mode - controls if output is PWM or DC level
+        * 0 DC output (0 - 12v)
+        * 1 PWM output
 
 Thermal Cruise mode
 -------------------
diff -puN drivers/hwmon/w83627ehf.c~hwmon-w83627ehf-updates drivers/hwmon/w83627ehf.c
--- a/drivers/hwmon/w83627ehf.c~hwmon-w83627ehf-updates
+++ a/drivers/hwmon/w83627ehf.c
@@ -5,6 +5,7 @@
     Copyright (C) 2006  Yuan Mu (Winbond),
                         Rudolf Marek <r.marek@assembler.cz>
                         David Hubbard <david.c.hubbard@gmail.com>
+                        Daniel J Blueman <daniel.blueman@gmail.com>
 
     Shamelessly ripped from the w83627hf driver
     Copyright (C) 2003  Mark Studebaker
@@ -177,12 +178,15 @@ static const u16 W83627EHF_REG_TEMP_CONF
 #define W83627EHF_REG_ALARM3		0x45B
 
 /* SmartFan registers */
+#define W83627EHF_REG_FAN_STEPUP_TIME 0x0f
+#define W83627EHF_REG_FAN_STEPDOWN_TIME 0x0e
+
 /* DC or PWM output fan configuration */
 static const u8 W83627EHF_REG_PWM_ENABLE[] = {
 	0x04,			/* SYS FAN0 output mode and PWM mode */
 	0x04,			/* CPU FAN0 output mode and PWM mode */
 	0x12,			/* AUX FAN mode */
-	0x62,			/* CPU fan1 mode */
+	0x62,			/* CPU FAN1 mode */
 };
 
 static const u8 W83627EHF_PWM_MODE_SHIFT[] = { 0, 1, 0, 6 };
@@ -193,10 +197,12 @@ static const u8 W83627EHF_REG_PWM[] = { 
 static const u8 W83627EHF_REG_TARGET[] = { 0x05, 0x06, 0x13, 0x63 };
 static const u8 W83627EHF_REG_TOLERANCE[] = { 0x07, 0x07, 0x14, 0x62 };
 
-
 /* Advanced Fan control, some values are common for all fans */
-static const u8 W83627EHF_REG_FAN_MIN_OUTPUT[] = { 0x08, 0x09, 0x15, 0x64 };
-static const u8 W83627EHF_REG_FAN_STOP_TIME[] = { 0x0C, 0x0D, 0x17, 0x66 };
+static const u8 W83627EHF_REG_FAN_START_OUTPUT[] = { 0x0a, 0x0b, 0x16, 0x65 };
+static const u8 W83627EHF_REG_FAN_STOP_OUTPUT[] = { 0x08, 0x09, 0x15, 0x64 };
+static const u8 W83627EHF_REG_FAN_STOP_TIME[] = { 0x0c, 0x0d, 0x17, 0x66 };
+static const u8 W83627EHF_REG_FAN_MAX_OUTPUT[] = { 0xff, 0x67, 0xff, 0x69 };
+static const u8 W83627EHF_REG_FAN_STEP_OUTPUT[] = { 0xff, 0x68, 0xff, 0x6a };
 
 /*
  * Conversions
@@ -295,14 +301,19 @@ struct w83627ehf_data {
 
 	u8 pwm_mode[4]; /* 0->DC variable voltage, 1->PWM variable duty cycle */
 	u8 pwm_enable[4]; /* 1->manual
-			     2->thermal cruise (also called SmartFan I) */
+			     2->thermal cruise mode (also called SmartFan I)
+			     3->fan speed cruise mode
+			     4->variable thermal cruise (also called SmartFan III) */
 	u8 pwm_num;		/* number of pwm */
 	u8 pwm[4];
 	u8 target_temp[4];
 	u8 tolerance[4];
 
-	u8 fan_min_output[4]; /* minimum fan speed */
-	u8 fan_stop_time[4];
+	u8 fan_start_output[4]; /* minimum fan speed when spinning up */
+	u8 fan_stop_output[4]; /* minimum fan speed when spinning down */
+	u8 fan_stop_time[4]; /* time at minimum before disabling fan */
+	u8 fan_max_output[4]; /* maximum fan speed */
+	u8 fan_step_output[4]; /* rate of change output value */
 
 	u8 vid;
 	u8 vrm;
@@ -529,8 +540,10 @@ static struct w83627ehf_data *w83627ehf_
 						& 3) + 1;
 			data->pwm[i] = w83627ehf_read_value(data,
 						W83627EHF_REG_PWM[i]);
-			data->fan_min_output[i] = w83627ehf_read_value(data,
-						W83627EHF_REG_FAN_MIN_OUTPUT[i]);
+			data->fan_start_output[i] = w83627ehf_read_value(data,
+						W83627EHF_REG_FAN_START_OUTPUT[i]);
+			data->fan_stop_output[i] = w83627ehf_read_value(data,
+						W83627EHF_REG_FAN_STOP_OUTPUT[i]);
 			data->fan_stop_time[i] = w83627ehf_read_value(data,
 						W83627EHF_REG_FAN_STOP_TIME[i]);
 			data->target_temp[i] =
@@ -976,7 +989,7 @@ store_pwm_enable(struct device *dev, str
 	u32 val = simple_strtoul(buf, NULL, 10);
 	u16 reg;
 
-	if (!val || (val > 2))	/* only modes 1 and 2 are supported */
+	if (!val || (val > 4))
 		return -EINVAL;
 	mutex_lock(&data->update_lock);
 	reg = w83627ehf_read_value(data, W83627EHF_REG_PWM_ENABLE[nr]);
@@ -1118,7 +1131,10 @@ store_##reg(struct device *dev, struct d
 	return count; \
 }
 
-fan_functions(fan_min_output, FAN_MIN_OUTPUT)
+fan_functions(fan_start_output, FAN_START_OUTPUT)
+fan_functions(fan_stop_output, FAN_STOP_OUTPUT)
+fan_functions(fan_max_output, FAN_MAX_OUTPUT)
+fan_functions(fan_step_output, FAN_STEP_OUTPUT)
 
 #define fan_time_functions(reg, REG) \
 static ssize_t show_##reg(struct device *dev, struct device_attribute *attr, \
@@ -1161,8 +1177,14 @@ static DEVICE_ATTR(name, S_IRUGO, show_n
 static struct sensor_device_attribute sda_sf3_arrays_fan4[] = {
 	SENSOR_ATTR(pwm4_stop_time, S_IWUSR | S_IRUGO, show_fan_stop_time,
 		    store_fan_stop_time, 3),
-	SENSOR_ATTR(pwm4_min_output, S_IWUSR | S_IRUGO, show_fan_min_output,
-		    store_fan_min_output, 3),
+	SENSOR_ATTR(pwm4_start_output, S_IWUSR | S_IRUGO, show_fan_start_output,
+		    store_fan_start_output, 3),
+	SENSOR_ATTR(pwm4_stop_output, S_IWUSR | S_IRUGO, show_fan_stop_output,
+		    store_fan_stop_output, 3),
+	SENSOR_ATTR(pwm4_max_output, S_IWUSR | S_IRUGO, show_fan_max_output,
+		    store_fan_max_output, 3),
+	SENSOR_ATTR(pwm4_step_output, S_IWUSR | S_IRUGO, show_fan_step_output,
+		    store_fan_step_output, 3),
 };
 
 static struct sensor_device_attribute sda_sf3_arrays[] = {
@@ -1172,12 +1194,24 @@ static struct sensor_device_attribute sd
 		    store_fan_stop_time, 1),
 	SENSOR_ATTR(pwm3_stop_time, S_IWUSR | S_IRUGO, show_fan_stop_time,
 		    store_fan_stop_time, 2),
-	SENSOR_ATTR(pwm1_min_output, S_IWUSR | S_IRUGO, show_fan_min_output,
-		    store_fan_min_output, 0),
-	SENSOR_ATTR(pwm2_min_output, S_IWUSR | S_IRUGO, show_fan_min_output,
-		    store_fan_min_output, 1),
-	SENSOR_ATTR(pwm3_min_output, S_IWUSR | S_IRUGO, show_fan_min_output,
-		    store_fan_min_output, 2),
+	SENSOR_ATTR(pwm1_start_output, S_IWUSR | S_IRUGO, show_fan_start_output,
+		    store_fan_start_output, 0),
+	SENSOR_ATTR(pwm2_start_output, S_IWUSR | S_IRUGO, show_fan_start_output,
+		    store_fan_start_output, 1),
+	SENSOR_ATTR(pwm3_start_output, S_IWUSR | S_IRUGO, show_fan_start_output,
+		    store_fan_start_output, 2),
+	SENSOR_ATTR(pwm1_stop_output, S_IWUSR | S_IRUGO, show_fan_stop_output,
+		    store_fan_stop_output, 0),
+	SENSOR_ATTR(pwm2_stop_output, S_IWUSR | S_IRUGO, show_fan_stop_output,
+		    store_fan_stop_output, 1),
+	SENSOR_ATTR(pwm3_stop_output, S_IWUSR | S_IRUGO, show_fan_stop_output,
+		    store_fan_stop_output, 2),
+
+	/* pwm1 and pwm3 don't support max and step settings */
+	SENSOR_ATTR(pwm2_max_output, S_IWUSR | S_IRUGO, show_fan_max_output,
+		    store_fan_max_output, 1),
+	SENSOR_ATTR(pwm2_step_output, S_IWUSR | S_IRUGO, show_fan_step_output,
+		    store_fan_step_output, 1),
 };
 
 static ssize_t
_

Patches currently in -mm which might be from daniel.blueman@gmail.com are

hwmon-w83627ehf-updates.patch

