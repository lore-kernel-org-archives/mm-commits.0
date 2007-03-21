From: akpm@linux-foundation.org
Subject: + apple-smc-driver-hardware-monitoring-and-control.patch added to -mm tree
Date: Wed, 21 Mar 2007 15:12:35 -0700
Message-ID: <200703212212.l2LMCZVh005099@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56002 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933196AbXCUWNL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Mar 2007 18:13:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nicolas@boichat.ch, benh@kernel.crashing.org, khali@linux-fr.org, paulus@samba.org


The patch titled
     Apple SMC driver (hardware monitoring and control)
has been added to the -mm tree.  Its filename is
     apple-smc-driver-hardware-monitoring-and-control.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Apple SMC driver (hardware monitoring and control)
From: Nicolas Boichat <nicolas@boichat.ch>

This driver provides support for the Apple System Management Controller, which
provides an accelerometer (Apple Sudden Motion Sensor), light sensors,
temperature sensors, keyboard backlight control and fan control. Only
Intel-based Apple's computers are supported (MacBook Pro, MacBook, MacMini).

Signed-off-by: Nicolas Boichat <nicolas@boichat.ch>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS              |    6 
 drivers/hwmon/Kconfig    |   24 
 drivers/hwmon/Makefile   |    1 
 drivers/hwmon/applesmc.c |  917 +++++++++++++++++++++++++++++++++++++
 4 files changed, 948 insertions(+)

diff -puN MAINTAINERS~apple-smc-driver-hardware-monitoring-and-control MAINTAINERS
--- a/MAINTAINERS~apple-smc-driver-hardware-monitoring-and-control
+++ a/MAINTAINERS
@@ -375,6 +375,12 @@ L:	linux-laptop@vger.kernel.org
 W:	http://www.canb.auug.org.au/~sfr/
 S:	Supported
 
+APPLE SMC DRIVER
+P:	Nicolas Boichat
+M:	nicolas@boichat.ch
+L:	mactel-linux-devel@lists.sourceforge.net
+S:	Maintained
+
 APPLETALK NETWORK LAYER
 P:	Arnaldo Carvalho de Melo
 M:	acme@conectiva.com.br
diff -puN drivers/hwmon/Kconfig~apple-smc-driver-hardware-monitoring-and-control drivers/hwmon/Kconfig
--- a/drivers/hwmon/Kconfig~apple-smc-driver-hardware-monitoring-and-control
+++ a/drivers/hwmon/Kconfig
@@ -603,6 +603,30 @@ config SENSORS_HDAPS
 	  Say Y here if you have an applicable laptop and want to experience
 	  the awesome power of hdaps.
 
+config SENSORS_APPLESMC
+	tristate "Apple SMC (Motion sensor, light sensor, keyboard backlight)"
+	depends on HWMON && INPUT && X86
+	select NEW_LEDS
+	select LEDS_CLASS
+	default n
+	help
+	  This driver provides support for the Apple System Management
+	  Controller, which provides an accelerometer (Apple Sudden Motion
+	  Sensor), light sensors, temperature sensors, keyboard backlight
+	  control and fan control.
+
+	  Only Intel-based Apple's computers are supported (MacBook Pro,
+	  MacBook, MacMini).
+
+	  Data from the different sensors, keyboard backlight control and fan
+	  control are accessible via sysfs.
+
+	  This driver also provides an absolute input class device, allowing
+	  the laptop to act as a pinball machine-esque joystick.
+
+	  Say Y here if you have an applicable laptop and want to experience
+	  the awesome power of applesmc.
+
 config HWMON_DEBUG_CHIP
 	bool "Hardware Monitoring Chip debugging messages"
 	depends on HWMON
diff -puN drivers/hwmon/Makefile~apple-smc-driver-hardware-monitoring-and-control drivers/hwmon/Makefile
--- a/drivers/hwmon/Makefile~apple-smc-driver-hardware-monitoring-and-control
+++ a/drivers/hwmon/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_SENSORS_ADM1026)	+= adm1026
 obj-$(CONFIG_SENSORS_ADM1029)	+= adm1029.o
 obj-$(CONFIG_SENSORS_ADM1031)	+= adm1031.o
 obj-$(CONFIG_SENSORS_ADM9240)	+= adm9240.o
+obj-$(CONFIG_SENSORS_APPLESMC)	+= applesmc.o
 obj-$(CONFIG_SENSORS_AMS)	+= ams/
 obj-$(CONFIG_SENSORS_ATXP1)	+= atxp1.o
 obj-$(CONFIG_SENSORS_DS1621)	+= ds1621.o
diff -puN /dev/null drivers/hwmon/applesmc.c
--- /dev/null
+++ a/drivers/hwmon/applesmc.c
@@ -0,0 +1,917 @@
+/*
+ * drivers/hwmon/applesmc.c - driver for Apple's SMC (accelerometer, temperature
+ * sensors, fan control, keyboard backlight control) used in Intel-based Apple
+ * computers.
+ *
+ * Copyright (C) 2007 Nicolas Boichat <nicolas@boichat.ch>
+ *
+ * Based on hdaps.c driver:
+ * Copyright (C) 2005 Robert Love <rml@novell.com>
+ * Copyright (C) 2005 Jesper Juhl <jesper.juhl@gmail.com>
+ *
+ * Fan control based on smcFanControl:
+ * Copyright (C) 2006 Hendrik Holtmann <holtmann@mac.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License v2 as published by the
+ * Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA
+ */
+
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+#include <linux/input.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/timer.h>
+#include <linux/dmi.h>
+#include <linux/mutex.h>
+#include <linux/hwmon-sysfs.h>
+#include <asm/io.h>
+#include <linux/leds.h>
+
+/* data port used by apple SMC */
+#define APPLESMC_DATA_PORT	0x300
+/* command/status port used by apple SMC */
+#define APPLESMC_CMD_PORT	0x304
+
+#define APPLESMC_NR_PORTS	5 /* 0x300-0x304 */
+
+#define APPLESMC_STATUS_MASK	0x0f
+#define APPLESMC_READ_CMD	0x10
+#define APPLESMC_WRITE_CMD	0x11
+
+#define LIGHT_SENSOR_LEFT_KEY	"ALV0" /* r-o length 6 */
+#define LIGHT_SENSOR_RIGHT_KEY	"ALV1" /* r-o length 6 */
+#define BACKLIGHT_KEY 		"LKSB" /* w-o */
+
+#define CLAMSHELL_KEY 		"MSLD" /* r-o length 1 (unused) */
+
+#define MOTION_SENSOR_X_KEY	"MO_X" /* r-o length 2 */
+#define MOTION_SENSOR_Y_KEY	"MO_Y" /* r-o length 2 */
+#define MOTION_SENSOR_Z_KEY	"MO_Z" /* r-o length 2 */
+#define MOTION_SENSOR_KEY	"MOCN" /* r/w length 2 */
+
+#define FANS_COUNT		"FNum" /* r-o length 1 */
+#define FANS_MANUAL		"FS! " /* r-w length 2 */
+#define FAN_ACTUAL_SPEED	"F0Ac" /* r-o length 2 */
+#define FAN_MIN_SPEED		"F0Mn" /* r-o length 2 */
+#define FAN_MAX_SPEED		"F0Mx" /* r-o length 2 */
+#define FAN_SAFE_SPEED		"F0Sf" /* r-o length 2 */
+#define FAN_TARGET_SPEED	"F0Tg" /* r-w length 2 */
+
+/* Temperature sensors keys. First set for Macbook(Pro), second for Macmini */
+static const char* temperature_sensors_sets[][8] = {
+	{ "TB0T", "TC0D", "TC0P", "Th0H", "Ts0P", "Th1H", "Ts1P", NULL },
+	{ "TC0D", "TC0P", NULL }
+};
+
+/* List of keys used to read/write fan speeds */
+static const char* fan_speed_keys[] = {
+	FAN_ACTUAL_SPEED,
+	FAN_MIN_SPEED,
+	FAN_MAX_SPEED,
+	FAN_SAFE_SPEED,
+	FAN_TARGET_SPEED
+};
+
+#define INIT_TIMEOUT_MSECS	5000	/* wait up to 5s for device init ... */
+#define INIT_WAIT_MSECS		50	/* ... in 50ms increments */
+
+#define APPLESMC_POLL_PERIOD	(HZ/20)	/* poll for input every 1/20s */
+#define APPLESMC_INPUT_FUZZ	4	/* input event threshold */
+#define APPLESMC_INPUT_FLAT	4
+
+#define SENSOR_X 0
+#define SENSOR_Y 1
+#define SENSOR_Z 2
+
+/* Structure to be passed to DMI_MATCH function */
+struct dmi_match_data {
+/* Indicates whether this computer has an accelerometer. */
+	int accelerometer;
+/* Indicates whether this computer has light sensors and keyboard backlight. */
+	int light;
+/* Indicates which temperature sensors set to use. */
+	int temperature_set;
+};
+
+static int debug = 0;
+static struct platform_device *pdev;
+static s16 rest_x;
+static s16 rest_y;
+static struct timer_list applesmc_timer;
+static struct input_dev *applesmc_idev;
+
+/* Indicates whether this computer has an accelerometer. */
+static unsigned int applesmc_accelerometer;
+
+/* Indicates whether this computer has light sensors and keyboard backlight. */
+static unsigned int applesmc_light;
+
+/* Indicates which temperature sensors set to use. */
+static unsigned int applesmc_temperature_set;
+
+static struct mutex applesmc_lock;
+
+/*
+ * __wait_status - Wait up to 100ms for the status port to get a certain value
+ * (masked with 0x0f), returning zero if the value is obtained.  Callers must
+ * hold applesmc_lock.
+ */
+static int __wait_status(u8 val)
+{
+	unsigned int i;
+
+	val = val & APPLESMC_STATUS_MASK;
+
+	for (i = 0; i < 10000; i++) {
+		if ((inb(APPLESMC_CMD_PORT) & APPLESMC_STATUS_MASK) == val)
+			return 0;
+		udelay(10);
+	}
+
+	printk(KERN_WARNING "applesmc: wait status failed: %x != %x\n",
+						val, inb(APPLESMC_CMD_PORT));
+
+	return -EIO;
+}
+
+/*
+ * applesmc_read_key - reads len bytes from a given key, and put them in buffer.
+ * Returns zero on success or a negative error on failure. Callers must
+ * hold applesmc_lock.
+ */
+static int applesmc_read_key(const char* key, u8* buffer, u8 len)
+{
+	int ret = -EIO;
+	int i;
+
+	outb(APPLESMC_READ_CMD, APPLESMC_CMD_PORT);
+	if (__wait_status(0x0c))
+		goto out;
+
+	for (i = 0; i < 4; i++) {
+		outb(key[i], APPLESMC_DATA_PORT);
+		if (__wait_status(0x04))
+			goto out;
+	}
+	if (debug)
+		printk(KERN_DEBUG "<%s", key);
+
+	outb(len, APPLESMC_DATA_PORT);
+	if (debug)
+		printk(KERN_DEBUG ">%x", len);
+
+	for (i = 0; i < len; i++) {
+		if (__wait_status(0x05))
+			goto out;
+		buffer[i] = inb(APPLESMC_DATA_PORT);
+		if (debug)
+			printk(KERN_DEBUG "<%x", buffer[i]);
+	}
+	if (debug)
+		printk(KERN_DEBUG "\n");
+
+	ret = 0;
+
+out:
+	return ret;
+}
+
+/*
+ * applesmc_write_key - writes len bytes from buffer to a given key.
+ * Returns zero on success or a negative error on failure. Callers must
+ * hold applesmc_lock.
+ */
+static int applesmc_write_key(const char* key, u8* buffer, u8 len)
+{
+	int ret = -EIO;
+	int i;
+
+	outb(APPLESMC_WRITE_CMD, APPLESMC_CMD_PORT);
+	if (__wait_status(0x0c))
+		goto out;
+
+	for (i = 0; i < 4; i++) {
+		outb(key[i], APPLESMC_DATA_PORT);
+		if (__wait_status(0x04))
+			goto out;
+	}
+
+	outb(len, APPLESMC_DATA_PORT);
+
+	for (i = 0; i < len; i++) {
+		if (__wait_status(0x04))
+			goto out;
+		outb(buffer[i], APPLESMC_DATA_PORT);
+	}
+
+	ret = 0;
+out:
+	return ret;
+}
+
+/*
+ * applesmc_read_motion_sensor - Read motion sensor (X, Y or Z). Callers must
+ * hold applesmc_lock.
+ */
+static int applesmc_read_motion_sensor(int index, s16* value)
+{
+	u8 buffer[2];
+	int ret;
+
+	switch (index) {
+	case SENSOR_X:
+		ret = applesmc_read_key(MOTION_SENSOR_X_KEY, buffer, 2);
+		break;
+	case SENSOR_Y:
+		ret = applesmc_read_key(MOTION_SENSOR_Y_KEY, buffer, 2);
+		break;
+	case SENSOR_Z:
+		ret = applesmc_read_key(MOTION_SENSOR_Z_KEY, buffer, 2);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	*value = ((s16)buffer[0] << 8) | buffer[1];
+
+	return ret;
+}
+
+/*
+ * applesmc_device_init - initialize the accelerometer.  Returns zero on success
+ * and negative error code on failure.  Can sleep.
+ */
+static int applesmc_device_init(void)
+{
+	int total, ret = -ENXIO;
+	u8 buffer[2];
+
+	if (!applesmc_accelerometer)
+		return 0;
+
+	mutex_lock(&applesmc_lock);
+
+	for (total = INIT_TIMEOUT_MSECS; total > 0; total -= INIT_WAIT_MSECS) {
+		if (debug)
+			printk(KERN_DEBUG "applesmc try %d\n", total);
+		if (!applesmc_read_key(MOTION_SENSOR_KEY, buffer, 2) &&
+				(buffer[0] != 0x00 || buffer[1] != 0x00)) {
+			if (total == INIT_TIMEOUT_MSECS) {
+				printk(KERN_DEBUG "applesmc: device has"
+						" already been initialized"
+						" (0x%02x, 0x%02x).\n",
+						buffer[0], buffer[1]);
+			} else {
+				printk(KERN_DEBUG "applesmc: device"
+						" successfully initialized"
+						" (0x%02x, 0x%02x).\n",
+						buffer[0], buffer[1]);
+			}
+			ret = 0;
+			goto out;
+		}
+		buffer[0] = 0xe0;
+		buffer[1] = 0x00;
+		applesmc_write_key(MOTION_SENSOR_KEY, buffer, 2);
+		msleep(INIT_WAIT_MSECS);
+	}
+
+	printk(KERN_WARNING "applesmc: failed to init the device\n");
+
+out:
+	mutex_unlock(&applesmc_lock);
+	return ret;
+}
+
+/*
+ * applesmc_get_fan_count - get the number of fans. Callers must NOT hold
+ * applesmc_lock.
+ */
+static int applesmc_get_fan_count(void)
+{
+	int ret;
+	u8 buffer[1];
+
+	mutex_lock(&applesmc_lock);
+
+	ret = applesmc_read_key(FANS_COUNT, buffer, 1);
+
+	mutex_unlock(&applesmc_lock);
+	if (ret)
+		return ret;
+	else
+		return buffer[0];
+}
+
+/* Device model stuff */
+static int applesmc_probe(struct platform_device *dev)
+{
+	int ret;
+
+	ret = applesmc_device_init();
+	if (ret)
+		return ret;
+
+	printk(KERN_INFO "applesmc: device successfully initialized.\n");
+	return 0;
+}
+
+static int applesmc_resume(struct platform_device *dev)
+{
+	return applesmc_device_init();
+}
+
+static struct platform_driver applesmc_driver = {
+	.probe = applesmc_probe,
+	.resume = applesmc_resume,
+	.driver	= {
+		.name = "applesmc",
+		.owner = THIS_MODULE,
+	},
+};
+
+/*
+ * applesmc_calibrate - Set our "resting" values.  Callers must
+ * hold applesmc_lock.
+ */
+static void applesmc_calibrate(void)
+{
+	applesmc_read_motion_sensor(SENSOR_X, &rest_x);
+	applesmc_read_motion_sensor(SENSOR_Y, &rest_y);
+}
+
+static void applesmc_mousedev_poll(unsigned long unused)
+{
+	s16 x, y;
+
+	/* Cannot sleep.  Try nonblockingly.  If we fail, try again later. */
+	if (!mutex_trylock(&applesmc_lock)) {
+		mod_timer(&applesmc_timer, jiffies + APPLESMC_POLL_PERIOD);
+		return;
+	}
+
+	if (applesmc_read_motion_sensor(SENSOR_X, &x))
+		goto out;
+	if (applesmc_read_motion_sensor(SENSOR_Y, &y))
+		goto out;
+
+	input_report_abs(applesmc_idev, ABS_X, x - rest_x);
+	input_report_abs(applesmc_idev, ABS_Y, y - rest_y);
+	input_sync(applesmc_idev);
+
+out:
+	mod_timer(&applesmc_timer, jiffies + APPLESMC_POLL_PERIOD);
+
+	mutex_unlock(&applesmc_lock);
+}
+
+/* Sysfs Files */
+
+static ssize_t applesmc_position_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	int ret;
+	s16 x, y, z;
+
+	mutex_lock(&applesmc_lock);
+
+	ret = applesmc_read_motion_sensor(SENSOR_X, &x);
+	if (ret)
+		goto out;
+	ret = applesmc_read_motion_sensor(SENSOR_Y, &y);
+	if (ret)
+		goto out;
+	ret = applesmc_read_motion_sensor(SENSOR_Z, &z);
+	if (ret)
+		goto out;
+
+out:
+	mutex_unlock(&applesmc_lock);
+	if (ret)
+		return ret;
+	else
+		return sprintf(buf, "(%d,%d,%d)\n", x, y, z);
+}
+
+static ssize_t applesmc_light_show(struct device *dev,
+				struct device_attribute *attr, char *sysfsbuf)
+{
+	int ret;
+	u8 left = 0, right = 0;
+	u8 buffer[6];
+
+	mutex_lock(&applesmc_lock);
+
+	ret = applesmc_read_key(LIGHT_SENSOR_LEFT_KEY, buffer, 6);
+	left = buffer[2];
+	if (ret)
+		goto out;
+	ret = applesmc_read_key(LIGHT_SENSOR_RIGHT_KEY, buffer, 6);
+	right = buffer[2];
+
+out:
+	mutex_unlock(&applesmc_lock);
+	if (ret)
+		return ret;
+	else
+		return sprintf(sysfsbuf, "(%d,%d)\n", left, right);
+}
+
+/* Displays degree Celsius * 100 */
+static ssize_t applesmc_show_temperature(struct device *dev,
+			struct device_attribute *devattr, char *sysfsbuf)
+{
+	int ret;
+	u8 buffer[2];
+	unsigned int temp;
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	const char* key =
+		temperature_sensors_sets[applesmc_temperature_set][attr->index];
+
+	mutex_lock(&applesmc_lock);
+
+	ret = applesmc_read_key(key, buffer, 2);
+	temp = buffer[0]*100;
+	temp += (buffer[1] >> 6) * 25;
+
+	mutex_unlock(&applesmc_lock);
+
+	if (ret)
+		return ret;
+	else
+		return sprintf(sysfsbuf, "%u\n", temp);
+}
+
+static ssize_t applesmc_show_fan_speed(struct device *dev,
+				struct device_attribute *attr, char *sysfsbuf)
+{
+	int ret;
+	unsigned int speed = 0;
+	char newkey[5];
+	u8 buffer[2];
+	struct sensor_device_attribute_2 *sensor_attr =
+						to_sensor_dev_attr_2(attr);
+
+	newkey[0] = fan_speed_keys[sensor_attr->nr][0];
+	newkey[1] = '0' + sensor_attr->index;
+	newkey[2] = fan_speed_keys[sensor_attr->nr][2];
+	newkey[3] = fan_speed_keys[sensor_attr->nr][3];
+	newkey[4] = 0;
+
+	mutex_lock(&applesmc_lock);
+
+	ret = applesmc_read_key(newkey, buffer, 2);
+	speed = ((buffer[0] << 8 | buffer[1]) >> 2);
+
+	mutex_unlock(&applesmc_lock);
+	if (ret)
+		return ret;
+	else
+		return sprintf(sysfsbuf, "%u\n", speed);
+}
+
+static ssize_t applesmc_store_fan_speed(struct device *dev,
+					struct device_attribute *attr,
+					const char *sysfsbuf, size_t count)
+{
+	int ret;
+	u32 speed;
+	char newkey[5];
+	u8 buffer[2];
+	struct sensor_device_attribute_2 *sensor_attr =
+						to_sensor_dev_attr_2(attr);
+
+	speed = simple_strtoul(sysfsbuf, NULL, 10);
+
+	if (speed > 0x4000) /* Bigger than a 14-bit value */
+		return -EINVAL;
+
+	newkey[0] = fan_speed_keys[sensor_attr->nr][0];
+	newkey[1] = '0' + sensor_attr->index;
+	newkey[2] = fan_speed_keys[sensor_attr->nr][2];
+	newkey[3] = fan_speed_keys[sensor_attr->nr][3];
+	newkey[4] = 0;
+
+	mutex_lock(&applesmc_lock);
+
+	buffer[0] = (speed >> 6) & 0xff;
+	buffer[1] = (speed << 2) & 0xff;
+	ret = applesmc_write_key(newkey, buffer, 2);
+
+	mutex_unlock(&applesmc_lock);
+	if (ret)
+		return ret;
+	else
+		return count;
+}
+
+static ssize_t applesmc_show_fan_manual(struct device *dev,
+			struct device_attribute *devattr, char *sysfsbuf)
+{
+	int ret;
+	u16 manual = 0;
+	u8 buffer[2];
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+
+	mutex_lock(&applesmc_lock);
+
+	ret = applesmc_read_key(FANS_MANUAL, buffer, 2);
+	manual = ((buffer[0] << 8 | buffer[1]) >> attr->index) & 0x01;
+
+	mutex_unlock(&applesmc_lock);
+	if (ret)
+		return ret;
+	else
+		return sprintf(sysfsbuf, "%d\n", manual);
+}
+
+static ssize_t applesmc_store_fan_manual(struct device *dev,
+					 struct device_attribute *devattr,
+					 const char *sysfsbuf, size_t count)
+{
+	int ret;
+	u8 buffer[2];
+	u32 input;
+	u16 val;
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+
+	input = simple_strtoul(sysfsbuf, NULL, 10);
+
+	mutex_lock(&applesmc_lock);
+
+	ret = applesmc_read_key(FANS_MANUAL, buffer, 2);
+	val = (buffer[0] << 8 | buffer[1]);
+	if (ret)
+		goto out;
+
+	if (input)
+		val = val | (0x01 << attr->index);
+	else
+		val = val & ~(0x01 << attr->index);
+
+	buffer[0] = (val >> 8) & 0xFF;
+	buffer[1] = val & 0xFF;
+
+	ret = applesmc_write_key(FANS_MANUAL, buffer, 2);
+
+out:
+	mutex_unlock(&applesmc_lock);
+	if (ret)
+		return ret;
+	else
+		return count;
+}
+
+static ssize_t applesmc_calibrate_show(struct device *dev,
+				struct device_attribute *attr, char *sysfsbuf)
+{
+	return sprintf(sysfsbuf, "(%d,%d)\n", rest_x, rest_y);
+}
+
+static ssize_t applesmc_calibrate_store(struct device *dev,
+	struct device_attribute *attr, const char *sysfsbuf, size_t count)
+{
+	mutex_lock(&applesmc_lock);
+	applesmc_calibrate();
+	mutex_unlock(&applesmc_lock);
+
+	return count;
+}
+
+static void applesmc_backlight_set(struct led_classdev *led_cdev,
+						enum led_brightness value)
+{
+	u8 buffer[2];
+
+	mutex_lock(&applesmc_lock);
+	buffer[0] = value;
+	buffer[1] = 0x00;
+	applesmc_write_key(BACKLIGHT_KEY, buffer, 2);
+	mutex_unlock(&applesmc_lock);
+}
+
+static struct led_classdev applesmc_backlight = {
+	.name			= "smc:kbd_backlight",
+	.default_trigger	= "nand-disk",
+	.brightness_set		= applesmc_backlight_set,
+};
+
+static DEVICE_ATTR(position, 0444, applesmc_position_show, NULL);
+static DEVICE_ATTR(calibrate, 0644,
+			applesmc_calibrate_show, applesmc_calibrate_store);
+
+static DEVICE_ATTR(light, 0444, applesmc_light_show, NULL);
+
+/*
+ * Macro defining SENSOR_DEVICE_ATTR for a fan sysfs entries.
+ *  - show actual speed
+ *  - show/store minimum speed
+ *  - show maximum speed
+ *  - show safe speed
+ *  - show/store target speed
+ *  - show/store manual mode
+ */
+#define sysfs_fan_speeds_offset(offset) \
+static SENSOR_DEVICE_ATTR_2(fan##offset##_actual_speed, S_IRUGO, \
+			applesmc_show_fan_speed, NULL, 0, offset); \
+\
+static SENSOR_DEVICE_ATTR_2(fan##offset##_minimum_speed, S_IRUGO | S_IWUSR, \
+	applesmc_show_fan_speed, applesmc_store_fan_speed, 1, offset); \
+\
+static SENSOR_DEVICE_ATTR_2(fan##offset##_maximum_speed, S_IRUGO, \
+			applesmc_show_fan_speed, NULL, 2, offset); \
+\
+static SENSOR_DEVICE_ATTR_2(fan##offset##_safe_speed, S_IRUGO, \
+			applesmc_show_fan_speed, NULL, 3, offset); \
+\
+static SENSOR_DEVICE_ATTR_2(fan##offset##_target_speed, S_IRUGO | S_IWUSR, \
+	applesmc_show_fan_speed, applesmc_store_fan_speed, 4, offset); \
+\
+static SENSOR_DEVICE_ATTR(fan##offset##_manual, S_IRUGO | S_IWUSR, \
+	applesmc_show_fan_manual, applesmc_store_fan_manual, offset); \
+\
+static struct attribute *fan##offset##_attributes[] = { \
+	&sensor_dev_attr_fan##offset##_actual_speed.dev_attr.attr, \
+	&sensor_dev_attr_fan##offset##_minimum_speed.dev_attr.attr, \
+	&sensor_dev_attr_fan##offset##_maximum_speed.dev_attr.attr, \
+	&sensor_dev_attr_fan##offset##_safe_speed.dev_attr.attr, \
+	&sensor_dev_attr_fan##offset##_target_speed.dev_attr.attr, \
+	&sensor_dev_attr_fan##offset##_manual.dev_attr.attr, \
+	NULL \
+};
+
+/*
+ * Create the needed functions for each fan using the macro defined above
+ * (2 fans are supported)
+ */
+sysfs_fan_speeds_offset(0);
+sysfs_fan_speeds_offset(1);
+
+static const struct attribute_group fan_attribute_groups[] = {
+	{ .attrs = fan0_attributes },
+	{ .attrs = fan1_attributes }
+};
+
+/*
+ * Temperature sensors sysfs entries.
+ */
+static SENSOR_DEVICE_ATTR(temperature_0, S_IRUGO,
+					applesmc_show_temperature, NULL, 0);
+static SENSOR_DEVICE_ATTR(temperature_1, S_IRUGO,
+					applesmc_show_temperature, NULL, 1);
+static SENSOR_DEVICE_ATTR(temperature_2, S_IRUGO,
+					applesmc_show_temperature, NULL, 2);
+static SENSOR_DEVICE_ATTR(temperature_3, S_IRUGO,
+					applesmc_show_temperature, NULL, 3);
+static SENSOR_DEVICE_ATTR(temperature_4, S_IRUGO,
+					applesmc_show_temperature, NULL, 4);
+static SENSOR_DEVICE_ATTR(temperature_5, S_IRUGO,
+					applesmc_show_temperature, NULL, 5);
+static SENSOR_DEVICE_ATTR(temperature_6, S_IRUGO,
+					applesmc_show_temperature, NULL, 6);
+
+static struct attribute *temperature_attributes[] = {
+	&sensor_dev_attr_temperature_0.dev_attr.attr,
+	&sensor_dev_attr_temperature_1.dev_attr.attr,
+	&sensor_dev_attr_temperature_2.dev_attr.attr,
+	&sensor_dev_attr_temperature_3.dev_attr.attr,
+	&sensor_dev_attr_temperature_4.dev_attr.attr,
+	&sensor_dev_attr_temperature_5.dev_attr.attr,
+	&sensor_dev_attr_temperature_6.dev_attr.attr,
+};
+
+/* Module stuff */
+
+/*
+ * applesmc_dmi_match - found a match.  return one, short-circuiting the hunt.
+ */
+static int applesmc_dmi_match(struct dmi_system_id *id)
+{
+	int i = 0;
+	struct dmi_match_data* dmi_data = id->driver_data;
+	printk(KERN_INFO "applesmc: %s detected:\n", id->ident);
+	applesmc_accelerometer = dmi_data->accelerometer;
+	printk(KERN_INFO "applesmc:  - Model %s accelerometer\n",
+				applesmc_accelerometer ? "with" : "without");
+	applesmc_light = dmi_data->light;
+	printk(KERN_INFO "applesmc:  - Model %s light sensors and backlight\n",
+					applesmc_light ? "with" : "without");
+
+	applesmc_temperature_set =  dmi_data->temperature_set;
+	while (temperature_sensors_sets[applesmc_temperature_set][i] != NULL)
+		i++;
+	printk(KERN_INFO "applesmc:  - Model with %d temperature sensors\n", i);
+	return 1;
+}
+
+/* Create accelerometer ressources */
+static int applesmc_create_accelerometer(void)
+{
+	int ret;
+
+	ret = sysfs_create_file(&pdev->dev.kobj, &dev_attr_position.attr);
+	if (ret)
+		goto out;
+
+	ret = sysfs_create_file(&pdev->dev.kobj, &dev_attr_calibrate.attr);
+	if (ret)
+		goto out;
+
+	applesmc_idev = input_allocate_device();
+	if (!applesmc_idev) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* initial calibrate for the input device */
+	applesmc_calibrate();
+
+	/* initialize the input class */
+	applesmc_idev->name = "applesmc";
+	applesmc_idev->cdev.dev = &pdev->dev;
+	applesmc_idev->evbit[0] = BIT(EV_ABS);
+	input_set_abs_params(applesmc_idev, ABS_X,
+			-256, 256, APPLESMC_INPUT_FUZZ, APPLESMC_INPUT_FLAT);
+	input_set_abs_params(applesmc_idev, ABS_Y,
+			-256, 256, APPLESMC_INPUT_FUZZ, APPLESMC_INPUT_FLAT);
+
+	input_register_device(applesmc_idev);
+
+	/* start up our timer for the input device */
+	init_timer(&applesmc_timer);
+	applesmc_timer.function = applesmc_mousedev_poll;
+	applesmc_timer.expires = jiffies + APPLESMC_POLL_PERIOD;
+	add_timer(&applesmc_timer);
+
+	return 0;
+
+out:
+	printk(KERN_WARNING "applesmc: driver init failed (ret=%d)!\n", ret);
+	return ret;
+}
+
+/* Release all ressources used by the accelerometer */
+static void applesmc_release_accelerometer(void)
+{
+	del_timer_sync(&applesmc_timer);
+	input_unregister_device(applesmc_idev);
+}
+
+static __initdata struct dmi_match_data applesmc_dmi_data[] = {
+/* MacBook Pro: accelerometer, backlight and temperature set 0 */
+	{ .accelerometer = 1, .light = 1, .temperature_set = 0 },
+/* MacBook: accelerometer and temperature set 0 */
+	{ .accelerometer = 1, .light = 0, .temperature_set = 0 },
+/* MacBook: temperature set 1 */
+	{ .accelerometer = 0, .light = 0, .temperature_set = 1 }
+};
+
+/* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
+ * So we need to put "Apple MacBook Pro" before "Apple MacBook". */
+static __initdata struct dmi_system_id applesmc_whitelist[] = {
+	{ applesmc_dmi_match, "Apple MacBook Pro", {
+	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
+	  DMI_MATCH(DMI_PRODUCT_NAME,"MacBookPro") },
+		(void*)&applesmc_dmi_data[0]},
+	{ applesmc_dmi_match, "Apple MacBook", {
+	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
+	  DMI_MATCH(DMI_PRODUCT_NAME,"MacBook") },
+		(void*)&applesmc_dmi_data[1]},
+	{ applesmc_dmi_match, "Apple Macmini", {
+	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
+	  DMI_MATCH(DMI_PRODUCT_NAME,"Macmini") },
+		(void*)&applesmc_dmi_data[2]},
+	{ .ident = NULL }
+};
+
+static int __init applesmc_init(void)
+{
+	int ret;
+	int count;
+	int i;
+
+	mutex_init(&applesmc_lock);
+
+	if (!dmi_check_system(applesmc_whitelist)) {
+		printk(KERN_WARNING "applesmc: supported laptop not found!\n");
+		ret = -ENODEV;
+		goto out;
+	}
+
+	if (!request_region(APPLESMC_DATA_PORT, APPLESMC_NR_PORTS,
+								"applesmc")) {
+		ret = -ENXIO;
+		goto out;
+	}
+
+	ret = platform_driver_register(&applesmc_driver);
+	if (ret)
+		goto out_region;
+
+	pdev = platform_device_register_simple("applesmc", -1, NULL, 0);
+	if (IS_ERR(pdev)) {
+		ret = PTR_ERR(pdev);
+		goto out_driver;
+	}
+
+	/* create fan files */
+	count = applesmc_get_fan_count();
+	if (count < 0) {
+		printk(KERN_ERR "applesmc: Cannot get the number of fans.\n");
+	} else {
+		printk(KERN_INFO "applesmc: %d fans found.\n", count);
+
+		switch (count) {
+		default:
+			printk(KERN_WARNING "applesmc: More than 2 fans found,"
+					" but at most 2 fans are supported"
+						" by the driver.\n");
+		case 2:
+			ret = sysfs_create_group(&pdev->dev.kobj,
+						 &fan_attribute_groups[1]);
+			if (ret)
+				goto out_device;
+		case 1:
+			ret = sysfs_create_group(&pdev->dev.kobj,
+						 &fan_attribute_groups[0]);
+			if (ret)
+				goto out_device;
+		case 0:
+			;
+		}
+	}
+
+	for (i = 0;
+	     temperature_sensors_sets[applesmc_temperature_set][i] != NULL;
+	     i++) {
+		ret = sysfs_create_file(&pdev->dev.kobj,
+						temperature_attributes[i]);
+		if (ret)
+			goto out_device;
+	}
+
+	if (applesmc_accelerometer) {
+		ret = applesmc_create_accelerometer();
+		if (ret)
+			goto out_device;
+	}
+
+	if (applesmc_light) {
+		/* Add light sensor file */
+		ret = sysfs_create_file(&pdev->dev.kobj, &dev_attr_light.attr);
+		if (ret)
+			goto out_accelerometer;
+
+		/* register as a led device */
+		ret = led_classdev_register(&pdev->dev, &applesmc_backlight);
+		if (ret < 0)
+			goto out_accelerometer;
+	}
+
+	printk(KERN_INFO "applesmc: driver successfully loaded.\n");
+	return 0;
+
+out_accelerometer:
+	if (applesmc_accelerometer)
+		applesmc_release_accelerometer();
+out_device:
+	platform_device_unregister(pdev);
+out_driver:
+	platform_driver_unregister(&applesmc_driver);
+out_region:
+	release_region(APPLESMC_DATA_PORT, APPLESMC_NR_PORTS);
+out:
+	printk(KERN_WARNING "applesmc: driver init failed (ret=%d)!\n", ret);
+	return ret;
+}
+
+static void __exit applesmc_exit(void)
+{
+	if (applesmc_light)
+		led_classdev_unregister(&applesmc_backlight);
+	if (applesmc_accelerometer)
+		applesmc_release_accelerometer();
+	platform_device_unregister(pdev);
+	platform_driver_unregister(&applesmc_driver);
+	release_region(APPLESMC_DATA_PORT, APPLESMC_NR_PORTS);
+
+	printk(KERN_INFO "applesmc: driver unloaded.\n");
+}
+
+module_init(applesmc_init);
+module_exit(applesmc_exit);
+
+MODULE_AUTHOR("Nicolas Boichat");
+MODULE_DESCRIPTION("Apple SMC");
+MODULE_LICENSE("GPL v2");
_

Patches currently in -mm which might be from nicolas@boichat.ch are

origin.patch
git-alsa.patch
apple-smc-driver-hardware-monitoring-and-control.patch
