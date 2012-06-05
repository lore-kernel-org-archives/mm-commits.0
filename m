From: akpm@linux-foundation.org
Subject: [merged] hwmon-exynos4-move-thermal-sensor-driver-to-driver-thermal-directory.patch removed from -mm tree
Date: Tue, 05 Jun 2012 12:56:21 -0700
Message-ID: <20120605195621.96066A028F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:47269 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab2FET4Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2012 15:56:24 -0400
Received: by were53 with SMTP id e53so356686wer.1
        for <mm-commits@vger.kernel.org>; Tue, 05 Jun 2012 12:56:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amit.kachhap@linaro.org, dg77.kim@samsung.com, durgadoss.r@intel.com, guenter.roeck@ericsson.com, khali@linux-fr.org, lenb@kernel.org, sw.ju@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hwmon: exynos4: move thermal sensor driver to driver/thermal directory
has been removed from the -mm tree.  Its filename was
     hwmon-exynos4-move-thermal-sensor-driver-to-driver-thermal-directory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Amit Daniel Kachhap <amit.kachhap@linaro.org>
Subject: hwmon: exynos4: move thermal sensor driver to driver/thermal directory

This movement is needed because the hwmon entries and corresponding sysfs
interface is a duplicate of utilities already provided by
driver/thermal/thermal_sys.c.  The goal is to place it in thermal folder
and add necessary functions to use the in-kernel thermal interfaces.

Signed-off-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>
Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: SangWook Ju <sw.ju@samsung.com>
Cc: Durgadoss <durgadoss.r@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/hwmon/exynos4_tmu              |   81 --
 Documentation/thermal/exynos_thermal         |   52 +
 drivers/hwmon/Kconfig                        |   10 
 drivers/hwmon/Makefile                       |    1 
 drivers/hwmon/exynos4_tmu.c                  |  514 -----------------
 drivers/thermal/Kconfig                      |    9 
 drivers/thermal/Makefile                     |    1 
 drivers/thermal/exynos_thermal.c             |  409 +++++++++++++
 include/linux/platform_data/exynos4_tmu.h    |   83 --
 include/linux/platform_data/exynos_thermal.h |   83 ++
 10 files changed, 554 insertions(+), 689 deletions(-)

diff -puN Documentation/hwmon/exynos4_tmu~hwmon-exynos4-move-thermal-sensor-driver-to-driver-thermal-directory /dev/null
--- a/Documentation/hwmon/exynos4_tmu
+++ /dev/null
@@ -1,81 +0,0 @@
-Kernel driver exynos4_tmu
-=================
-
-Supported chips:
-* ARM SAMSUNG EXYNOS4 series of SoC
-  Prefix: 'exynos4-tmu'
-  Datasheet: Not publicly available
-
-Authors: Donggeun Kim <dg77.kim@samsung.com>
-
-Description
------------
-
-This driver allows to read temperature inside SAMSUNG EXYNOS4 series of SoC.
-
-The chip only exposes the measured 8-bit temperature code value
-through a register.
-Temperature can be taken from the temperature code.
-There are three equations converting from temperature to temperature code.
-
-The three equations are:
-  1. Two point trimming
-	Tc = (T - 25) * (TI2 - TI1) / (85 - 25) + TI1
-
-  2. One point trimming
-	Tc = T + TI1 - 25
-
-  3. No trimming
-	Tc = T + 50
-
-  Tc: Temperature code, T: Temperature,
-  TI1: Trimming info for 25 degree Celsius (stored at TRIMINFO register)
-       Temperature code measured at 25 degree Celsius which is unchanged
-  TI2: Trimming info for 85 degree Celsius (stored at TRIMINFO register)
-       Temperature code measured at 85 degree Celsius which is unchanged
-
-TMU(Thermal Management Unit) in EXYNOS4 generates interrupt
-when temperature exceeds pre-defined levels.
-The maximum number of configurable threshold is four.
-The threshold levels are defined as follows:
-  Level_0: current temperature > trigger_level_0 + threshold
-  Level_1: current temperature > trigger_level_1 + threshold
-  Level_2: current temperature > trigger_level_2 + threshold
-  Level_3: current temperature > trigger_level_3 + threshold
-
-  The threshold and each trigger_level are set
-  through the corresponding registers.
-
-When an interrupt occurs, this driver notify user space of
-one of four threshold levels for the interrupt
-through kobject_uevent_env and sysfs_notify functions.
-Although an interrupt condition for level_0 can be set,
-it is not notified to user space through sysfs_notify function.
-
-Sysfs Interface
----------------
-name		name of the temperature sensor
-		RO
-
-temp1_input	temperature
-		RO
-
-temp1_max	temperature for level_1 interrupt
-		RO
-
-temp1_crit	temperature for level_2 interrupt
-		RO
-
-temp1_emergency	temperature for level_3 interrupt
-		RO
-
-temp1_max_alarm	alarm for level_1 interrupt
-		RO
-
-temp1_crit_alarm
-		alarm for level_2 interrupt
-		RO
-
-temp1_emergency_alarm
-		alarm for level_3 interrupt
-		RO
diff -puN /dev/null Documentation/thermal/exynos_thermal
--- /dev/null
+++ a/Documentation/thermal/exynos_thermal
@@ -0,0 +1,52 @@
+Kernel driver exynos4_tmu
+=================
+
+Supported chips:
+* ARM SAMSUNG EXYNOS4 series of SoC
+  Prefix: 'exynos4-tmu'
+  Datasheet: Not publicly available
+
+Authors: Donggeun Kim <dg77.kim@samsung.com>
+
+Description
+-----------
+
+This driver allows to read temperature inside SAMSUNG EXYNOS4 series of SoC.
+
+The chip only exposes the measured 8-bit temperature code value
+through a register.
+Temperature can be taken from the temperature code.
+There are three equations converting from temperature to temperature code.
+
+The three equations are:
+  1. Two point trimming
+	Tc = (T - 25) * (TI2 - TI1) / (85 - 25) + TI1
+
+  2. One point trimming
+	Tc = T + TI1 - 25
+
+  3. No trimming
+	Tc = T + 50
+
+  Tc: Temperature code, T: Temperature,
+  TI1: Trimming info for 25 degree Celsius (stored at TRIMINFO register)
+       Temperature code measured at 25 degree Celsius which is unchanged
+  TI2: Trimming info for 85 degree Celsius (stored at TRIMINFO register)
+       Temperature code measured at 85 degree Celsius which is unchanged
+
+TMU(Thermal Management Unit) in EXYNOS4 generates interrupt
+when temperature exceeds pre-defined levels.
+The maximum number of configurable threshold is four.
+The threshold levels are defined as follows:
+  Level_0: current temperature > trigger_level_0 + threshold
+  Level_1: current temperature > trigger_level_1 + threshold
+  Level_2: current temperature > trigger_level_2 + threshold
+  Level_3: current temperature > trigger_level_3 + threshold
+
+  The threshold and each trigger_level are set
+  through the corresponding registers.
+
+When an interrupt occurs, this driver notify kernel thermal framework
+with the function exynos4_report_trigger.
+Although an interrupt condition for level_0 can be set,
+it can be used to synchronize the cooling action.
diff -puN drivers/hwmon/Kconfig~hwmon-exynos4-move-thermal-sensor-driver-to-driver-thermal-directory drivers/hwmon/Kconfig
--- a/drivers/hwmon/Kconfig~hwmon-exynos4-move-thermal-sensor-driver-to-driver-thermal-directory
+++ a/drivers/hwmon/Kconfig
@@ -314,16 +314,6 @@ config SENSORS_DS1621
 	  This driver can also be built as a module.  If so, the module
 	  will be called ds1621.
 
-config SENSORS_EXYNOS4_TMU
-	tristate "Temperature sensor on Samsung EXYNOS4"
-	depends on ARCH_EXYNOS4
-	help
-	  If you say yes here you get support for TMU (Thermal Management
-	  Unit) on SAMSUNG EXYNOS4 series of SoC.
-
-	  This driver can also be built as a module. If so, the module
-	  will be called exynos4-tmu.
-
 config SENSORS_I5K_AMB
 	tristate "FB-DIMM AMB temperature sensor on Intel 5000 series chipsets"
 	depends on PCI && EXPERIMENTAL
diff -puN drivers/hwmon/Makefile~hwmon-exynos4-move-thermal-sensor-driver-to-driver-thermal-directory drivers/hwmon/Makefile
--- a/drivers/hwmon/Makefile~hwmon-exynos4-move-thermal-sensor-driver-to-driver-thermal-directory
+++ a/drivers/hwmon/Makefile
@@ -48,7 +48,6 @@ obj-$(CONFIG_SENSORS_DS1621)	+= ds1621.o
 obj-$(CONFIG_SENSORS_EMC1403)	+= emc1403.o
 obj-$(CONFIG_SENSORS_EMC2103)	+= emc2103.o
 obj-$(CONFIG_SENSORS_EMC6W201)	+= emc6w201.o
-obj-$(CONFIG_SENSORS_EXYNOS4_TMU)	+= exynos4_tmu.o
 obj-$(CONFIG_SENSORS_F71805F)	+= f71805f.o
 obj-$(CONFIG_SENSORS_F71882FG)	+= f71882fg.o
 obj-$(CONFIG_SENSORS_F75375S)	+= f75375s.o
diff -puN drivers/hwmon/exynos4_tmu.c~hwmon-exynos4-move-thermal-sensor-driver-to-driver-thermal-directory /dev/null
--- a/drivers/hwmon/exynos4_tmu.c
+++ /dev/null
@@ -1,514 +0,0 @@
-/*
- * exynos4_tmu.c - Samsung EXYNOS4 TMU (Thermal Management Unit)
- *
- *  Copyright (C) 2011 Samsung Electronics
- *  Donggeun Kim <dg77.kim@samsung.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- *
- */
-
-#include <linux/module.h>
-#include <linux/err.h>
-#include <linux/kernel.h>
-#include <linux/slab.h>
-#include <linux/platform_device.h>
-#include <linux/interrupt.h>
-#include <linux/clk.h>
-#include <linux/workqueue.h>
-#include <linux/sysfs.h>
-#include <linux/kobject.h>
-#include <linux/io.h>
-#include <linux/mutex.h>
-
-#include <linux/hwmon.h>
-#include <linux/hwmon-sysfs.h>
-
-#include <linux/platform_data/exynos4_tmu.h>
-
-#define EXYNOS4_TMU_REG_TRIMINFO	0x0
-#define EXYNOS4_TMU_REG_CONTROL		0x20
-#define EXYNOS4_TMU_REG_STATUS		0x28
-#define EXYNOS4_TMU_REG_CURRENT_TEMP	0x40
-#define EXYNOS4_TMU_REG_THRESHOLD_TEMP	0x44
-#define EXYNOS4_TMU_REG_TRIG_LEVEL0	0x50
-#define EXYNOS4_TMU_REG_TRIG_LEVEL1	0x54
-#define EXYNOS4_TMU_REG_TRIG_LEVEL2	0x58
-#define EXYNOS4_TMU_REG_TRIG_LEVEL3	0x5C
-#define EXYNOS4_TMU_REG_PAST_TEMP0	0x60
-#define EXYNOS4_TMU_REG_PAST_TEMP1	0x64
-#define EXYNOS4_TMU_REG_PAST_TEMP2	0x68
-#define EXYNOS4_TMU_REG_PAST_TEMP3	0x6C
-#define EXYNOS4_TMU_REG_INTEN		0x70
-#define EXYNOS4_TMU_REG_INTSTAT		0x74
-#define EXYNOS4_TMU_REG_INTCLEAR	0x78
-
-#define EXYNOS4_TMU_GAIN_SHIFT		8
-#define EXYNOS4_TMU_REF_VOLTAGE_SHIFT	24
-
-#define EXYNOS4_TMU_TRIM_TEMP_MASK	0xff
-#define EXYNOS4_TMU_CORE_ON	3
-#define EXYNOS4_TMU_CORE_OFF	2
-#define EXYNOS4_TMU_DEF_CODE_TO_TEMP_OFFSET	50
-#define EXYNOS4_TMU_TRIG_LEVEL0_MASK	0x1
-#define EXYNOS4_TMU_TRIG_LEVEL1_MASK	0x10
-#define EXYNOS4_TMU_TRIG_LEVEL2_MASK	0x100
-#define EXYNOS4_TMU_TRIG_LEVEL3_MASK	0x1000
-#define EXYNOS4_TMU_INTCLEAR_VAL	0x1111
-
-struct exynos4_tmu_data {
-	struct exynos4_tmu_platform_data *pdata;
-	struct device *hwmon_dev;
-	struct resource *mem;
-	void __iomem *base;
-	int irq;
-	struct work_struct irq_work;
-	struct mutex lock;
-	struct clk *clk;
-	u8 temp_error1, temp_error2;
-};
-
-/*
- * TMU treats temperature as a mapped temperature code.
- * The temperature is converted differently depending on the calibration type.
- */
-static int temp_to_code(struct exynos4_tmu_data *data, u8 temp)
-{
-	struct exynos4_tmu_platform_data *pdata = data->pdata;
-	int temp_code;
-
-	/* temp should range between 25 and 125 */
-	if (temp < 25 || temp > 125) {
-		temp_code = -EINVAL;
-		goto out;
-	}
-
-	switch (pdata->cal_type) {
-	case TYPE_TWO_POINT_TRIMMING:
-		temp_code = (temp - 25) *
-		    (data->temp_error2 - data->temp_error1) /
-		    (85 - 25) + data->temp_error1;
-		break;
-	case TYPE_ONE_POINT_TRIMMING:
-		temp_code = temp + data->temp_error1 - 25;
-		break;
-	default:
-		temp_code = temp + EXYNOS4_TMU_DEF_CODE_TO_TEMP_OFFSET;
-		break;
-	}
-out:
-	return temp_code;
-}
-
-/*
- * Calculate a temperature value from a temperature code.
- * The unit of the temperature is degree Celsius.
- */
-static int code_to_temp(struct exynos4_tmu_data *data, u8 temp_code)
-{
-	struct exynos4_tmu_platform_data *pdata = data->pdata;
-	int temp;
-
-	/* temp_code should range between 75 and 175 */
-	if (temp_code < 75 || temp_code > 175) {
-		temp = -ENODATA;
-		goto out;
-	}
-
-	switch (pdata->cal_type) {
-	case TYPE_TWO_POINT_TRIMMING:
-		temp = (temp_code - data->temp_error1) * (85 - 25) /
-		    (data->temp_error2 - data->temp_error1) + 25;
-		break;
-	case TYPE_ONE_POINT_TRIMMING:
-		temp = temp_code - data->temp_error1 + 25;
-		break;
-	default:
-		temp = temp_code - EXYNOS4_TMU_DEF_CODE_TO_TEMP_OFFSET;
-		break;
-	}
-out:
-	return temp;
-}
-
-static int exynos4_tmu_initialize(struct platform_device *pdev)
-{
-	struct exynos4_tmu_data *data = platform_get_drvdata(pdev);
-	struct exynos4_tmu_platform_data *pdata = data->pdata;
-	unsigned int status, trim_info;
-	int ret = 0, threshold_code;
-
-	mutex_lock(&data->lock);
-	clk_enable(data->clk);
-
-	status = readb(data->base + EXYNOS4_TMU_REG_STATUS);
-	if (!status) {
-		ret = -EBUSY;
-		goto out;
-	}
-
-	/* Save trimming info in order to perform calibration */
-	trim_info = readl(data->base + EXYNOS4_TMU_REG_TRIMINFO);
-	data->temp_error1 = trim_info & EXYNOS4_TMU_TRIM_TEMP_MASK;
-	data->temp_error2 = ((trim_info >> 8) & EXYNOS4_TMU_TRIM_TEMP_MASK);
-
-	/* Write temperature code for threshold */
-	threshold_code = temp_to_code(data, pdata->threshold);
-	if (threshold_code < 0) {
-		ret = threshold_code;
-		goto out;
-	}
-	writeb(threshold_code,
-		data->base + EXYNOS4_TMU_REG_THRESHOLD_TEMP);
-
-	writeb(pdata->trigger_levels[0],
-		data->base + EXYNOS4_TMU_REG_TRIG_LEVEL0);
-	writeb(pdata->trigger_levels[1],
-		data->base + EXYNOS4_TMU_REG_TRIG_LEVEL1);
-	writeb(pdata->trigger_levels[2],
-		data->base + EXYNOS4_TMU_REG_TRIG_LEVEL2);
-	writeb(pdata->trigger_levels[3],
-		data->base + EXYNOS4_TMU_REG_TRIG_LEVEL3);
-
-	writel(EXYNOS4_TMU_INTCLEAR_VAL,
-		data->base + EXYNOS4_TMU_REG_INTCLEAR);
-out:
-	clk_disable(data->clk);
-	mutex_unlock(&data->lock);
-
-	return ret;
-}
-
-static void exynos4_tmu_control(struct platform_device *pdev, bool on)
-{
-	struct exynos4_tmu_data *data = platform_get_drvdata(pdev);
-	struct exynos4_tmu_platform_data *pdata = data->pdata;
-	unsigned int con, interrupt_en;
-
-	mutex_lock(&data->lock);
-	clk_enable(data->clk);
-
-	con = pdata->reference_voltage << EXYNOS4_TMU_REF_VOLTAGE_SHIFT |
-		pdata->gain << EXYNOS4_TMU_GAIN_SHIFT;
-	if (on) {
-		con |= EXYNOS4_TMU_CORE_ON;
-		interrupt_en = pdata->trigger_level3_en << 12 |
-			pdata->trigger_level2_en << 8 |
-			pdata->trigger_level1_en << 4 |
-			pdata->trigger_level0_en;
-	} else {
-		con |= EXYNOS4_TMU_CORE_OFF;
-		interrupt_en = 0; /* Disable all interrupts */
-	}
-	writel(interrupt_en, data->base + EXYNOS4_TMU_REG_INTEN);
-	writel(con, data->base + EXYNOS4_TMU_REG_CONTROL);
-
-	clk_disable(data->clk);
-	mutex_unlock(&data->lock);
-}
-
-static int exynos4_tmu_read(struct exynos4_tmu_data *data)
-{
-	u8 temp_code;
-	int temp;
-
-	mutex_lock(&data->lock);
-	clk_enable(data->clk);
-
-	temp_code = readb(data->base + EXYNOS4_TMU_REG_CURRENT_TEMP);
-	temp = code_to_temp(data, temp_code);
-
-	clk_disable(data->clk);
-	mutex_unlock(&data->lock);
-
-	return temp;
-}
-
-static void exynos4_tmu_work(struct work_struct *work)
-{
-	struct exynos4_tmu_data *data = container_of(work,
-			struct exynos4_tmu_data, irq_work);
-
-	mutex_lock(&data->lock);
-	clk_enable(data->clk);
-
-	writel(EXYNOS4_TMU_INTCLEAR_VAL, data->base + EXYNOS4_TMU_REG_INTCLEAR);
-
-	kobject_uevent(&data->hwmon_dev->kobj, KOBJ_CHANGE);
-
-	enable_irq(data->irq);
-
-	clk_disable(data->clk);
-	mutex_unlock(&data->lock);
-}
-
-static irqreturn_t exynos4_tmu_irq(int irq, void *id)
-{
-	struct exynos4_tmu_data *data = id;
-
-	disable_irq_nosync(irq);
-	schedule_work(&data->irq_work);
-
-	return IRQ_HANDLED;
-}
-
-static ssize_t exynos4_tmu_show_name(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	return sprintf(buf, "exynos4-tmu\n");
-}
-
-static ssize_t exynos4_tmu_show_temp(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct exynos4_tmu_data *data = dev_get_drvdata(dev);
-	int ret;
-
-	ret = exynos4_tmu_read(data);
-	if (ret < 0)
-		return ret;
-
-	/* convert from degree Celsius to millidegree Celsius */
-	return sprintf(buf, "%d\n", ret * 1000);
-}
-
-static ssize_t exynos4_tmu_show_alarm(struct device *dev,
-		struct device_attribute *devattr, char *buf)
-{
-	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
-	struct exynos4_tmu_data *data = dev_get_drvdata(dev);
-	struct exynos4_tmu_platform_data *pdata = data->pdata;
-	int temp;
-	unsigned int trigger_level;
-
-	temp = exynos4_tmu_read(data);
-	if (temp < 0)
-		return temp;
-
-	trigger_level = pdata->threshold + pdata->trigger_levels[attr->index];
-
-	return sprintf(buf, "%d\n", !!(temp > trigger_level));
-}
-
-static ssize_t exynos4_tmu_show_level(struct device *dev,
-		struct device_attribute *devattr, char *buf)
-{
-	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
-	struct exynos4_tmu_data *data = dev_get_drvdata(dev);
-	struct exynos4_tmu_platform_data *pdata = data->pdata;
-	unsigned int temp = pdata->threshold +
-			pdata->trigger_levels[attr->index];
-
-	return sprintf(buf, "%u\n", temp * 1000);
-}
-
-static DEVICE_ATTR(name, S_IRUGO, exynos4_tmu_show_name, NULL);
-static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, exynos4_tmu_show_temp, NULL, 0);
-
-static SENSOR_DEVICE_ATTR(temp1_max_alarm, S_IRUGO,
-		exynos4_tmu_show_alarm, NULL, 1);
-static SENSOR_DEVICE_ATTR(temp1_crit_alarm, S_IRUGO,
-		exynos4_tmu_show_alarm, NULL, 2);
-static SENSOR_DEVICE_ATTR(temp1_emergency_alarm, S_IRUGO,
-		exynos4_tmu_show_alarm, NULL, 3);
-
-static SENSOR_DEVICE_ATTR(temp1_max, S_IRUGO, exynos4_tmu_show_level, NULL, 1);
-static SENSOR_DEVICE_ATTR(temp1_crit, S_IRUGO, exynos4_tmu_show_level, NULL, 2);
-static SENSOR_DEVICE_ATTR(temp1_emergency, S_IRUGO,
-		exynos4_tmu_show_level, NULL, 3);
-
-static struct attribute *exynos4_tmu_attributes[] = {
-	&dev_attr_name.attr,
-	&sensor_dev_attr_temp1_input.dev_attr.attr,
-	&sensor_dev_attr_temp1_max_alarm.dev_attr.attr,
-	&sensor_dev_attr_temp1_crit_alarm.dev_attr.attr,
-	&sensor_dev_attr_temp1_emergency_alarm.dev_attr.attr,
-	&sensor_dev_attr_temp1_max.dev_attr.attr,
-	&sensor_dev_attr_temp1_crit.dev_attr.attr,
-	&sensor_dev_attr_temp1_emergency.dev_attr.attr,
-	NULL,
-};
-
-static const struct attribute_group exynos4_tmu_attr_group = {
-	.attrs = exynos4_tmu_attributes,
-};
-
-static int __devinit exynos4_tmu_probe(struct platform_device *pdev)
-{
-	struct exynos4_tmu_data *data;
-	struct exynos4_tmu_platform_data *pdata = pdev->dev.platform_data;
-	int ret;
-
-	if (!pdata) {
-		dev_err(&pdev->dev, "No platform init data supplied.\n");
-		return -ENODEV;
-	}
-
-	data = kzalloc(sizeof(struct exynos4_tmu_data), GFP_KERNEL);
-	if (!data) {
-		dev_err(&pdev->dev, "Failed to allocate driver structure\n");
-		return -ENOMEM;
-	}
-
-	data->irq = platform_get_irq(pdev, 0);
-	if (data->irq < 0) {
-		ret = data->irq;
-		dev_err(&pdev->dev, "Failed to get platform irq\n");
-		goto err_free;
-	}
-
-	INIT_WORK(&data->irq_work, exynos4_tmu_work);
-
-	data->mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!data->mem) {
-		ret = -ENOENT;
-		dev_err(&pdev->dev, "Failed to get platform resource\n");
-		goto err_free;
-	}
-
-	data->mem = request_mem_region(data->mem->start,
-			resource_size(data->mem), pdev->name);
-	if (!data->mem) {
-		ret = -ENODEV;
-		dev_err(&pdev->dev, "Failed to request memory region\n");
-		goto err_free;
-	}
-
-	data->base = ioremap(data->mem->start, resource_size(data->mem));
-	if (!data->base) {
-		ret = -ENODEV;
-		dev_err(&pdev->dev, "Failed to ioremap memory\n");
-		goto err_mem_region;
-	}
-
-	ret = request_irq(data->irq, exynos4_tmu_irq,
-		IRQF_TRIGGER_RISING,
-		"exynos4-tmu", data);
-	if (ret) {
-		dev_err(&pdev->dev, "Failed to request irq: %d\n", data->irq);
-		goto err_io_remap;
-	}
-
-	data->clk = clk_get(NULL, "tmu_apbif");
-	if (IS_ERR(data->clk)) {
-		ret = PTR_ERR(data->clk);
-		dev_err(&pdev->dev, "Failed to get clock\n");
-		goto err_irq;
-	}
-
-	data->pdata = pdata;
-	platform_set_drvdata(pdev, data);
-	mutex_init(&data->lock);
-
-	ret = exynos4_tmu_initialize(pdev);
-	if (ret) {
-		dev_err(&pdev->dev, "Failed to initialize TMU\n");
-		goto err_clk;
-	}
-
-	ret = sysfs_create_group(&pdev->dev.kobj, &exynos4_tmu_attr_group);
-	if (ret) {
-		dev_err(&pdev->dev, "Failed to create sysfs group\n");
-		goto err_clk;
-	}
-
-	data->hwmon_dev = hwmon_device_register(&pdev->dev);
-	if (IS_ERR(data->hwmon_dev)) {
-		ret = PTR_ERR(data->hwmon_dev);
-		dev_err(&pdev->dev, "Failed to register hwmon device\n");
-		goto err_create_group;
-	}
-
-	exynos4_tmu_control(pdev, true);
-
-	return 0;
-
-err_create_group:
-	sysfs_remove_group(&pdev->dev.kobj, &exynos4_tmu_attr_group);
-err_clk:
-	platform_set_drvdata(pdev, NULL);
-	clk_put(data->clk);
-err_irq:
-	free_irq(data->irq, data);
-err_io_remap:
-	iounmap(data->base);
-err_mem_region:
-	release_mem_region(data->mem->start, resource_size(data->mem));
-err_free:
-	kfree(data);
-
-	return ret;
-}
-
-static int __devexit exynos4_tmu_remove(struct platform_device *pdev)
-{
-	struct exynos4_tmu_data *data = platform_get_drvdata(pdev);
-
-	exynos4_tmu_control(pdev, false);
-
-	hwmon_device_unregister(data->hwmon_dev);
-	sysfs_remove_group(&pdev->dev.kobj, &exynos4_tmu_attr_group);
-
-	clk_put(data->clk);
-
-	free_irq(data->irq, data);
-
-	iounmap(data->base);
-	release_mem_region(data->mem->start, resource_size(data->mem));
-
-	platform_set_drvdata(pdev, NULL);
-
-	kfree(data);
-
-	return 0;
-}
-
-#ifdef CONFIG_PM
-static int exynos4_tmu_suspend(struct platform_device *pdev, pm_message_t state)
-{
-	exynos4_tmu_control(pdev, false);
-
-	return 0;
-}
-
-static int exynos4_tmu_resume(struct platform_device *pdev)
-{
-	exynos4_tmu_initialize(pdev);
-	exynos4_tmu_control(pdev, true);
-
-	return 0;
-}
-#else
-#define exynos4_tmu_suspend NULL
-#define exynos4_tmu_resume NULL
-#endif
-
-static struct platform_driver exynos4_tmu_driver = {
-	.driver = {
-		.name   = "exynos4-tmu",
-		.owner  = THIS_MODULE,
-	},
-	.probe = exynos4_tmu_probe,
-	.remove	= __devexit_p(exynos4_tmu_remove),
-	.suspend = exynos4_tmu_suspend,
-	.resume = exynos4_tmu_resume,
-};
-
-module_platform_driver(exynos4_tmu_driver);
-
-MODULE_DESCRIPTION("EXYNOS4 TMU Driver");
-MODULE_AUTHOR("Donggeun Kim <dg77.kim@samsung.com>");
-MODULE_LICENSE("GPL");
-MODULE_ALIAS("platform:exynos4-tmu");
diff -puN drivers/thermal/Kconfig~hwmon-exynos4-move-thermal-sensor-driver-to-driver-thermal-directory drivers/thermal/Kconfig
--- a/drivers/thermal/Kconfig~hwmon-exynos4-move-thermal-sensor-driver-to-driver-thermal-directory
+++ a/drivers/thermal/Kconfig
@@ -38,3 +38,12 @@ config SPEAR_THERMAL
 	help
 	  Enable this to plug the SPEAr thermal sensor driver into the Linux
 	  thermal framework
+
+config EXYNOS_THERMAL
+	tristate "Temperature sensor on Samsung EXYNOS4"
+	depends on ARCH_EXYNOS4 && THERMAL
+	help
+	  If you say yes here you get support for TMU (Thermal Managment
+	  Unit) on SAMSUNG EXYNOS4 series of SoC.
+	  This driver can also be built as a module. If so, the module
+	  will be called exynos4-tmu
diff -puN drivers/thermal/Makefile~hwmon-exynos4-move-thermal-sensor-driver-to-driver-thermal-directory drivers/thermal/Makefile
--- a/drivers/thermal/Makefile~hwmon-exynos4-move-thermal-sensor-driver-to-driver-thermal-directory
+++ a/drivers/thermal/Makefile
@@ -5,3 +5,4 @@
 obj-$(CONFIG_THERMAL)		+= thermal_sys.o
 obj-$(CONFIG_CPU_THERMAL)       += cpu_cooling.o
 obj-$(CONFIG_SPEAR_THERMAL)		+= spear_thermal.o
+obj-$(CONFIG_EXYNOS_THERMAL)		+= exynos_thermal.o
diff -puN /dev/null drivers/thermal/exynos_thermal.c
--- /dev/null
+++ a/drivers/thermal/exynos_thermal.c
@@ -0,0 +1,409 @@
+/*
+ * exynos_thermal.c - Samsung EXYNOS TMU (Thermal Management Unit)
+ *
+ *  Copyright (C) 2011 Samsung Electronics
+ *  Donggeun Kim <dg77.kim@samsung.com>
+ *  Amit Daniel Kachhap <amit.kachhap@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/clk.h>
+#include <linux/workqueue.h>
+#include <linux/sysfs.h>
+#include <linux/kobject.h>
+#include <linux/io.h>
+#include <linux/mutex.h>
+
+#include <linux/platform_data/exynos_thermal.h>
+
+#define EXYNOS4_TMU_REG_TRIMINFO	0x0
+#define EXYNOS4_TMU_REG_CONTROL		0x20
+#define EXYNOS4_TMU_REG_STATUS		0x28
+#define EXYNOS4_TMU_REG_CURRENT_TEMP	0x40
+#define EXYNOS4_TMU_REG_THRESHOLD_TEMP	0x44
+#define EXYNOS4_TMU_REG_TRIG_LEVEL0	0x50
+#define EXYNOS4_TMU_REG_TRIG_LEVEL1	0x54
+#define EXYNOS4_TMU_REG_TRIG_LEVEL2	0x58
+#define EXYNOS4_TMU_REG_TRIG_LEVEL3	0x5C
+#define EXYNOS4_TMU_REG_PAST_TEMP0	0x60
+#define EXYNOS4_TMU_REG_PAST_TEMP1	0x64
+#define EXYNOS4_TMU_REG_PAST_TEMP2	0x68
+#define EXYNOS4_TMU_REG_PAST_TEMP3	0x6C
+#define EXYNOS4_TMU_REG_INTEN		0x70
+#define EXYNOS4_TMU_REG_INTSTAT		0x74
+#define EXYNOS4_TMU_REG_INTCLEAR	0x78
+
+#define EXYNOS4_TMU_GAIN_SHIFT		8
+#define EXYNOS4_TMU_REF_VOLTAGE_SHIFT	24
+
+#define EXYNOS4_TMU_TRIM_TEMP_MASK	0xff
+#define EXYNOS4_TMU_CORE_ON	3
+#define EXYNOS4_TMU_CORE_OFF	2
+#define EXYNOS4_TMU_DEF_CODE_TO_TEMP_OFFSET	50
+#define EXYNOS4_TMU_TRIG_LEVEL0_MASK	0x1
+#define EXYNOS4_TMU_TRIG_LEVEL1_MASK	0x10
+#define EXYNOS4_TMU_TRIG_LEVEL2_MASK	0x100
+#define EXYNOS4_TMU_TRIG_LEVEL3_MASK	0x1000
+#define EXYNOS4_TMU_INTCLEAR_VAL	0x1111
+
+struct exynos4_tmu_data {
+	struct exynos4_tmu_platform_data *pdata;
+	struct resource *mem;
+	void __iomem *base;
+	int irq;
+	struct work_struct irq_work;
+	struct mutex lock;
+	struct clk *clk;
+	u8 temp_error1, temp_error2;
+};
+
+/*
+ * TMU treats temperature as a mapped temperature code.
+ * The temperature is converted differently depending on the calibration type.
+ */
+static int temp_to_code(struct exynos4_tmu_data *data, u8 temp)
+{
+	struct exynos4_tmu_platform_data *pdata = data->pdata;
+	int temp_code;
+
+	/* temp should range between 25 and 125 */
+	if (temp < 25 || temp > 125) {
+		temp_code = -EINVAL;
+		goto out;
+	}
+
+	switch (pdata->cal_type) {
+	case TYPE_TWO_POINT_TRIMMING:
+		temp_code = (temp - 25) *
+		    (data->temp_error2 - data->temp_error1) /
+		    (85 - 25) + data->temp_error1;
+		break;
+	case TYPE_ONE_POINT_TRIMMING:
+		temp_code = temp + data->temp_error1 - 25;
+		break;
+	default:
+		temp_code = temp + EXYNOS4_TMU_DEF_CODE_TO_TEMP_OFFSET;
+		break;
+	}
+out:
+	return temp_code;
+}
+
+/*
+ * Calculate a temperature value from a temperature code.
+ * The unit of the temperature is degree Celsius.
+ */
+static int code_to_temp(struct exynos4_tmu_data *data, u8 temp_code)
+{
+	struct exynos4_tmu_platform_data *pdata = data->pdata;
+	int temp;
+
+	/* temp_code should range between 75 and 175 */
+	if (temp_code < 75 || temp_code > 175) {
+		temp = -ENODATA;
+		goto out;
+	}
+
+	switch (pdata->cal_type) {
+	case TYPE_TWO_POINT_TRIMMING:
+		temp = (temp_code - data->temp_error1) * (85 - 25) /
+		    (data->temp_error2 - data->temp_error1) + 25;
+		break;
+	case TYPE_ONE_POINT_TRIMMING:
+		temp = temp_code - data->temp_error1 + 25;
+		break;
+	default:
+		temp = temp_code - EXYNOS4_TMU_DEF_CODE_TO_TEMP_OFFSET;
+		break;
+	}
+out:
+	return temp;
+}
+
+static int exynos4_tmu_initialize(struct platform_device *pdev)
+{
+	struct exynos4_tmu_data *data = platform_get_drvdata(pdev);
+	struct exynos4_tmu_platform_data *pdata = data->pdata;
+	unsigned int status, trim_info;
+	int ret = 0, threshold_code;
+
+	mutex_lock(&data->lock);
+	clk_enable(data->clk);
+
+	status = readb(data->base + EXYNOS4_TMU_REG_STATUS);
+	if (!status) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	/* Save trimming info in order to perform calibration */
+	trim_info = readl(data->base + EXYNOS4_TMU_REG_TRIMINFO);
+	data->temp_error1 = trim_info & EXYNOS4_TMU_TRIM_TEMP_MASK;
+	data->temp_error2 = ((trim_info >> 8) & EXYNOS4_TMU_TRIM_TEMP_MASK);
+
+	/* Write temperature code for threshold */
+	threshold_code = temp_to_code(data, pdata->threshold);
+	if (threshold_code < 0) {
+		ret = threshold_code;
+		goto out;
+	}
+	writeb(threshold_code,
+		data->base + EXYNOS4_TMU_REG_THRESHOLD_TEMP);
+
+	writeb(pdata->trigger_levels[0],
+		data->base + EXYNOS4_TMU_REG_TRIG_LEVEL0);
+	writeb(pdata->trigger_levels[1],
+		data->base + EXYNOS4_TMU_REG_TRIG_LEVEL1);
+	writeb(pdata->trigger_levels[2],
+		data->base + EXYNOS4_TMU_REG_TRIG_LEVEL2);
+	writeb(pdata->trigger_levels[3],
+		data->base + EXYNOS4_TMU_REG_TRIG_LEVEL3);
+
+	writel(EXYNOS4_TMU_INTCLEAR_VAL,
+		data->base + EXYNOS4_TMU_REG_INTCLEAR);
+out:
+	clk_disable(data->clk);
+	mutex_unlock(&data->lock);
+
+	return ret;
+}
+
+static void exynos4_tmu_control(struct platform_device *pdev, bool on)
+{
+	struct exynos4_tmu_data *data = platform_get_drvdata(pdev);
+	struct exynos4_tmu_platform_data *pdata = data->pdata;
+	unsigned int con, interrupt_en;
+
+	mutex_lock(&data->lock);
+	clk_enable(data->clk);
+
+	con = pdata->reference_voltage << EXYNOS4_TMU_REF_VOLTAGE_SHIFT |
+		pdata->gain << EXYNOS4_TMU_GAIN_SHIFT;
+	if (on) {
+		con |= EXYNOS4_TMU_CORE_ON;
+		interrupt_en = pdata->trigger_level3_en << 12 |
+			pdata->trigger_level2_en << 8 |
+			pdata->trigger_level1_en << 4 |
+			pdata->trigger_level0_en;
+	} else {
+		con |= EXYNOS4_TMU_CORE_OFF;
+		interrupt_en = 0; /* Disable all interrupts */
+	}
+	writel(interrupt_en, data->base + EXYNOS4_TMU_REG_INTEN);
+	writel(con, data->base + EXYNOS4_TMU_REG_CONTROL);
+
+	clk_disable(data->clk);
+	mutex_unlock(&data->lock);
+}
+
+static int exynos4_tmu_read(struct exynos4_tmu_data *data)
+{
+	u8 temp_code;
+	int temp;
+
+	mutex_lock(&data->lock);
+	clk_enable(data->clk);
+
+	temp_code = readb(data->base + EXYNOS4_TMU_REG_CURRENT_TEMP);
+	temp = code_to_temp(data, temp_code);
+
+	clk_disable(data->clk);
+	mutex_unlock(&data->lock);
+
+	return temp;
+}
+
+static void exynos4_tmu_work(struct work_struct *work)
+{
+	struct exynos4_tmu_data *data = container_of(work,
+			struct exynos4_tmu_data, irq_work);
+
+	mutex_lock(&data->lock);
+	clk_enable(data->clk);
+
+	writel(EXYNOS4_TMU_INTCLEAR_VAL, data->base + EXYNOS4_TMU_REG_INTCLEAR);
+
+	enable_irq(data->irq);
+
+	clk_disable(data->clk);
+	mutex_unlock(&data->lock);
+}
+
+static irqreturn_t exynos4_tmu_irq(int irq, void *id)
+{
+	struct exynos4_tmu_data *data = id;
+
+	disable_irq_nosync(irq);
+	schedule_work(&data->irq_work);
+
+	return IRQ_HANDLED;
+}
+
+static int __devinit exynos4_tmu_probe(struct platform_device *pdev)
+{
+	struct exynos4_tmu_data *data;
+	struct exynos4_tmu_platform_data *pdata = pdev->dev.platform_data;
+	int ret;
+
+	if (!pdata) {
+		dev_err(&pdev->dev, "No platform init data supplied.\n");
+		return -ENODEV;
+	}
+
+	data = kzalloc(sizeof(struct exynos4_tmu_data), GFP_KERNEL);
+	if (!data) {
+		dev_err(&pdev->dev, "Failed to allocate driver structure\n");
+		return -ENOMEM;
+	}
+
+	data->irq = platform_get_irq(pdev, 0);
+	if (data->irq < 0) {
+		ret = data->irq;
+		dev_err(&pdev->dev, "Failed to get platform irq\n");
+		goto err_free;
+	}
+
+	INIT_WORK(&data->irq_work, exynos4_tmu_work);
+
+	data->mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!data->mem) {
+		ret = -ENOENT;
+		dev_err(&pdev->dev, "Failed to get platform resource\n");
+		goto err_free;
+	}
+
+	data->mem = request_mem_region(data->mem->start,
+			resource_size(data->mem), pdev->name);
+	if (!data->mem) {
+		ret = -ENODEV;
+		dev_err(&pdev->dev, "Failed to request memory region\n");
+		goto err_free;
+	}
+
+	data->base = ioremap(data->mem->start, resource_size(data->mem));
+	if (!data->base) {
+		ret = -ENODEV;
+		dev_err(&pdev->dev, "Failed to ioremap memory\n");
+		goto err_mem_region;
+	}
+
+	ret = request_irq(data->irq, exynos4_tmu_irq,
+		IRQF_TRIGGER_RISING,
+		"exynos4-tmu", data);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to request irq: %d\n", data->irq);
+		goto err_io_remap;
+	}
+
+	data->clk = clk_get(NULL, "tmu_apbif");
+	if (IS_ERR(data->clk)) {
+		ret = PTR_ERR(data->clk);
+		dev_err(&pdev->dev, "Failed to get clock\n");
+		goto err_irq;
+	}
+
+	data->pdata = pdata;
+	platform_set_drvdata(pdev, data);
+	mutex_init(&data->lock);
+
+	ret = exynos4_tmu_initialize(pdev);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to initialize TMU\n");
+		goto err_clk;
+	}
+
+	exynos4_tmu_control(pdev, true);
+
+	return 0;
+err_clk:
+	platform_set_drvdata(pdev, NULL);
+	clk_put(data->clk);
+err_irq:
+	free_irq(data->irq, data);
+err_io_remap:
+	iounmap(data->base);
+err_mem_region:
+	release_mem_region(data->mem->start, resource_size(data->mem));
+err_free:
+	kfree(data);
+
+	return ret;
+}
+
+static int __devexit exynos4_tmu_remove(struct platform_device *pdev)
+{
+	struct exynos4_tmu_data *data = platform_get_drvdata(pdev);
+
+	exynos4_tmu_control(pdev, false);
+
+	clk_put(data->clk);
+
+	free_irq(data->irq, data);
+
+	iounmap(data->base);
+	release_mem_region(data->mem->start, resource_size(data->mem));
+
+	platform_set_drvdata(pdev, NULL);
+
+	kfree(data);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int exynos4_tmu_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	exynos4_tmu_control(pdev, false);
+
+	return 0;
+}
+
+static int exynos4_tmu_resume(struct platform_device *pdev)
+{
+	exynos4_tmu_initialize(pdev);
+	exynos4_tmu_control(pdev, true);
+
+	return 0;
+}
+#else
+#define exynos4_tmu_suspend NULL
+#define exynos4_tmu_resume NULL
+#endif
+
+static struct platform_driver exynos4_tmu_driver = {
+	.driver = {
+		.name   = "exynos4-tmu",
+		.owner  = THIS_MODULE,
+	},
+	.probe = exynos4_tmu_probe,
+	.remove	= __devexit_p(exynos4_tmu_remove),
+	.suspend = exynos4_tmu_suspend,
+	.resume = exynos4_tmu_resume,
+};
+
+module_platform_driver(exynos4_tmu_driver);
+
+MODULE_DESCRIPTION("EXYNOS4 TMU Driver");
+MODULE_AUTHOR("Donggeun Kim <dg77.kim@samsung.com>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:exynos4-tmu");
diff -puN include/linux/platform_data/exynos4_tmu.h~hwmon-exynos4-move-thermal-sensor-driver-to-driver-thermal-directory /dev/null
--- a/include/linux/platform_data/exynos4_tmu.h
+++ /dev/null
@@ -1,83 +0,0 @@
-/*
- * exynos4_tmu.h - Samsung EXYNOS4 TMU (Thermal Management Unit)
- *
- *  Copyright (C) 2011 Samsung Electronics
- *  Donggeun Kim <dg77.kim@samsung.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- */
-
-#ifndef _LINUX_EXYNOS4_TMU_H
-#define _LINUX_EXYNOS4_TMU_H
-
-enum calibration_type {
-	TYPE_ONE_POINT_TRIMMING,
-	TYPE_TWO_POINT_TRIMMING,
-	TYPE_NONE,
-};
-
-/**
- * struct exynos4_tmu_platform_data
- * @threshold: basic temperature for generating interrupt
- *	       25 <= threshold <= 125 [unit: degree Celsius]
- * @trigger_levels: array for each interrupt levels
- *	[unit: degree Celsius]
- *	0: temperature for trigger_level0 interrupt
- *	   condition for trigger_level0 interrupt:
- *		current temperature > threshold + trigger_levels[0]
- *	1: temperature for trigger_level1 interrupt
- *	   condition for trigger_level1 interrupt:
- *		current temperature > threshold + trigger_levels[1]
- *	2: temperature for trigger_level2 interrupt
- *	   condition for trigger_level2 interrupt:
- *		current temperature > threshold + trigger_levels[2]
- *	3: temperature for trigger_level3 interrupt
- *	   condition for trigger_level3 interrupt:
- *		current temperature > threshold + trigger_levels[3]
- * @trigger_level0_en:
- *	1 = enable trigger_level0 interrupt,
- *	0 = disable trigger_level0 interrupt
- * @trigger_level1_en:
- *	1 = enable trigger_level1 interrupt,
- *	0 = disable trigger_level1 interrupt
- * @trigger_level2_en:
- *	1 = enable trigger_level2 interrupt,
- *	0 = disable trigger_level2 interrupt
- * @trigger_level3_en:
- *	1 = enable trigger_level3 interrupt,
- *	0 = disable trigger_level3 interrupt
- * @gain: gain of amplifier in the positive-TC generator block
- *	0 <= gain <= 15
- * @reference_voltage: reference voltage of amplifier
- *	in the positive-TC generator block
- *	0 <= reference_voltage <= 31
- * @cal_type: calibration type for temperature
- *
- * This structure is required for configuration of exynos4_tmu driver.
- */
-struct exynos4_tmu_platform_data {
-	u8 threshold;
-	u8 trigger_levels[4];
-	bool trigger_level0_en;
-	bool trigger_level1_en;
-	bool trigger_level2_en;
-	bool trigger_level3_en;
-
-	u8 gain;
-	u8 reference_voltage;
-
-	enum calibration_type cal_type;
-};
-#endif /* _LINUX_EXYNOS4_TMU_H */
diff -puN /dev/null include/linux/platform_data/exynos_thermal.h
--- /dev/null
+++ a/include/linux/platform_data/exynos_thermal.h
@@ -0,0 +1,83 @@
+/*
+ * exynos_thermal.h - Samsung EXYNOS4 TMU (Thermal Management Unit)
+ *
+ *  Copyright (C) 2011 Samsung Electronics
+ *  Donggeun Kim <dg77.kim@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#ifndef _LINUX_EXYNOS_THERMAL_H
+#define _LINUX_EXYNOS_THERMAL_H
+
+enum calibration_type {
+	TYPE_ONE_POINT_TRIMMING,
+	TYPE_TWO_POINT_TRIMMING,
+	TYPE_NONE,
+};
+
+/**
+ * struct exynos4_tmu_platform_data
+ * @threshold: basic temperature for generating interrupt
+ *	       25 <= threshold <= 125 [unit: degree Celsius]
+ * @trigger_levels: array for each interrupt levels
+ *	[unit: degree Celsius]
+ *	0: temperature for trigger_level0 interrupt
+ *	   condition for trigger_level0 interrupt:
+ *		current temperature > threshold + trigger_levels[0]
+ *	1: temperature for trigger_level1 interrupt
+ *	   condition for trigger_level1 interrupt:
+ *		current temperature > threshold + trigger_levels[1]
+ *	2: temperature for trigger_level2 interrupt
+ *	   condition for trigger_level2 interrupt:
+ *		current temperature > threshold + trigger_levels[2]
+ *	3: temperature for trigger_level3 interrupt
+ *	   condition for trigger_level3 interrupt:
+ *		current temperature > threshold + trigger_levels[3]
+ * @trigger_level0_en:
+ *	1 = enable trigger_level0 interrupt,
+ *	0 = disable trigger_level0 interrupt
+ * @trigger_level1_en:
+ *	1 = enable trigger_level1 interrupt,
+ *	0 = disable trigger_level1 interrupt
+ * @trigger_level2_en:
+ *	1 = enable trigger_level2 interrupt,
+ *	0 = disable trigger_level2 interrupt
+ * @trigger_level3_en:
+ *	1 = enable trigger_level3 interrupt,
+ *	0 = disable trigger_level3 interrupt
+ * @gain: gain of amplifier in the positive-TC generator block
+ *	0 <= gain <= 15
+ * @reference_voltage: reference voltage of amplifier
+ *	in the positive-TC generator block
+ *	0 <= reference_voltage <= 31
+ * @cal_type: calibration type for temperature
+ *
+ * This structure is required for configuration of exynos4_tmu driver.
+ */
+struct exynos4_tmu_platform_data {
+	u8 threshold;
+	u8 trigger_levels[4];
+	bool trigger_level0_en;
+	bool trigger_level1_en;
+	bool trigger_level2_en;
+	bool trigger_level3_en;
+
+	u8 gain;
+	u8 reference_voltage;
+
+	enum calibration_type cal_type;
+};
+#endif /* _LINUX_EXYNOS_THERMAL_H */
_

Patches currently in -mm which might be from amit.kachhap@linaro.org are

linux-next.patch

