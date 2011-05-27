From: akpm@linux-foundation.org
Subject: [merged] w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support.patch removed from -mm tree
Date: Fri, 27 May 2011 12:59:21 -0700
Message-ID: <201105271957.p4RJvQa9017675@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40470 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757098Ab1E0T6a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 15:58:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cabarnes@indesign-llc.com, haojian.zhuang@gmail.com, johnpol@2ka.mipt.ru, ryan@bluewatersys.com, mm-commits@vger.kernel.org


The patch titled
     w1: add Maxim/Dallas DS2780 Stand-Alone Fuel Gauge IC support
has been removed from the -mm tree.  Its filename was
     w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: w1: add Maxim/Dallas DS2780 Stand-Alone Fuel Gauge IC support
From: Clifton Barnes <cabarnes@indesign-llc.com>

Add support for the Maxim/Dallas DS2780 Stand-Alone Fuel Gauge IC.

It was suggested to combine this functionality with the current ds2782
driver.  Unfortunately, I'm unable to commit the time to refactoring this
driver to that extent and I don't have a platform with the ds2782 part to
validate that there are no regression issues by adding this functionality.

[akpm@linux-foundation.org: use min_t()]
Signed-off-by: Clifton Barnes <cabarnes@indesign-llc.com>
Tested-by: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Ryan Mallon <ryan@bluewatersys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/Kconfig          |    7 
 drivers/power/Makefile         |    1 
 drivers/power/ds2780_battery.c |  853 +++++++++++++++++++++++++++++++
 drivers/w1/slaves/Kconfig      |   13 
 drivers/w1/slaves/Makefile     |    1 
 drivers/w1/slaves/w1_ds2780.c  |  217 +++++++
 drivers/w1/slaves/w1_ds2780.h  |  129 ++++
 drivers/w1/w1_family.h         |    1 
 8 files changed, 1222 insertions(+)

diff -puN drivers/power/Kconfig~w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support drivers/power/Kconfig
--- a/drivers/power/Kconfig~w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support
+++ a/drivers/power/Kconfig
@@ -68,6 +68,13 @@ config BATTERY_DS2760
 	help
 	  Say Y here to enable support for batteries with ds2760 chip.
 
+config BATTERY_DS2780
+	tristate "DS2780 battery driver"
+	select W1
+	select W1_SLAVE_DS2780
+	help
+	  Say Y here to enable support for batteries with ds2780 chip.
+
 config BATTERY_DS2782
 	tristate "DS2782/DS2786 standalone gas-gauge"
 	depends on I2C
diff -puN drivers/power/Makefile~w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support drivers/power/Makefile
--- a/drivers/power/Makefile~w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support
+++ a/drivers/power/Makefile
@@ -15,6 +15,7 @@ obj-$(CONFIG_WM8350_POWER)	+= wm8350_pow
 obj-$(CONFIG_TEST_POWER)	+= test_power.o
 
 obj-$(CONFIG_BATTERY_DS2760)	+= ds2760_battery.o
+obj-$(CONFIG_BATTERY_DS2780)	+= ds2780_battery.o
 obj-$(CONFIG_BATTERY_DS2782)	+= ds2782_battery.o
 obj-$(CONFIG_BATTERY_PMU)	+= pmu_battery.o
 obj-$(CONFIG_BATTERY_OLPC)	+= olpc_battery.o
diff -puN /dev/null drivers/power/ds2780_battery.c
--- /dev/null
+++ a/drivers/power/ds2780_battery.c
@@ -0,0 +1,853 @@
+/*
+ * 1-wire client/driver for the Maxim/Dallas DS2780 Stand-Alone Fuel Gauge IC
+ *
+ * Copyright (C) 2010 Indesign, LLC
+ *
+ * Author: Clifton Barnes <cabarnes@indesign-llc.com>
+ *
+ * Based on ds2760_battery and ds2782_battery drivers
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/param.h>
+#include <linux/pm.h>
+#include <linux/platform_device.h>
+#include <linux/power_supply.h>
+#include <linux/idr.h>
+
+#include "../w1/w1.h"
+#include "../w1/slaves/w1_ds2780.h"
+
+/* Current unit measurement in uA for a 1 milli-ohm sense resistor */
+#define DS2780_CURRENT_UNITS	1563
+/* Charge unit measurement in uAh for a 1 milli-ohm sense resistor */
+#define DS2780_CHARGE_UNITS		6250
+/* Number of bytes in user EEPROM space */
+#define DS2780_USER_EEPROM_SIZE		(DS2780_EEPROM_BLOCK0_END - \
+					DS2780_EEPROM_BLOCK0_START + 1)
+/* Number of bytes in parameter EEPROM space */
+#define DS2780_PARAM_EEPROM_SIZE	(DS2780_EEPROM_BLOCK1_END - \
+					DS2780_EEPROM_BLOCK1_START + 1)
+
+struct ds2780_device_info {
+	struct device *dev;
+	struct power_supply bat;
+	struct device *w1_dev;
+};
+
+enum current_types {
+	CURRENT_NOW,
+	CURRENT_AVG,
+};
+
+static const char model[] = "DS2780";
+static const char manufacturer[] = "Maxim/Dallas";
+
+static inline struct ds2780_device_info *to_ds2780_device_info(
+	struct power_supply *psy)
+{
+	return container_of(psy, struct ds2780_device_info, bat);
+}
+
+static inline struct power_supply *to_power_supply(struct device *dev)
+{
+	return dev_get_drvdata(dev);
+}
+
+static inline int ds2780_read8(struct device *dev, u8 *val, int addr)
+{
+	return w1_ds2780_io(dev, val, addr, sizeof(u8), 0);
+}
+
+static int ds2780_read16(struct device *dev, s16 *val, int addr)
+{
+	int ret;
+	u8 raw[2];
+
+	ret = w1_ds2780_io(dev, raw, addr, sizeof(u8) * 2, 0);
+	if (ret < 0)
+		return ret;
+
+	*val = (raw[0] << 8) | raw[1];
+
+	return 0;
+}
+
+static inline int ds2780_read_block(struct device *dev, u8 *val, int addr,
+	size_t count)
+{
+	return w1_ds2780_io(dev, val, addr, count, 0);
+}
+
+static inline int ds2780_write(struct device *dev, u8 *val, int addr,
+	size_t count)
+{
+	return w1_ds2780_io(dev, val, addr, count, 1);
+}
+
+static inline int ds2780_store_eeprom(struct device *dev, int addr)
+{
+	return w1_ds2780_eeprom_cmd(dev, addr, W1_DS2780_COPY_DATA);
+}
+
+static inline int ds2780_recall_eeprom(struct device *dev, int addr)
+{
+	return w1_ds2780_eeprom_cmd(dev, addr, W1_DS2780_RECALL_DATA);
+}
+
+static int ds2780_save_eeprom(struct ds2780_device_info *dev_info, int reg)
+{
+	int ret;
+
+	ret = ds2780_store_eeprom(dev_info->w1_dev, reg);
+	if (ret < 0)
+		return ret;
+
+	ret = ds2780_recall_eeprom(dev_info->w1_dev, reg);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+/* Set sense resistor value in mhos */
+static int ds2780_set_sense_register(struct ds2780_device_info *dev_info,
+	u8 conductance)
+{
+	int ret;
+
+	ret = ds2780_write(dev_info->w1_dev, &conductance,
+				DS2780_RSNSP_REG, sizeof(u8));
+	if (ret < 0)
+		return ret;
+
+	return ds2780_save_eeprom(dev_info, DS2780_RSNSP_REG);
+}
+
+/* Get RSGAIN value from 0 to 1.999 in steps of 0.001 */
+static int ds2780_get_rsgain_register(struct ds2780_device_info *dev_info,
+	u16 *rsgain)
+{
+	return ds2780_read16(dev_info->w1_dev, rsgain, DS2780_RSGAIN_MSB_REG);
+}
+
+/* Set RSGAIN value from 0 to 1.999 in steps of 0.001 */
+static int ds2780_set_rsgain_register(struct ds2780_device_info *dev_info,
+	u16 rsgain)
+{
+	int ret;
+	u8 raw[] = {rsgain >> 8, rsgain & 0xFF};
+
+	ret = ds2780_write(dev_info->w1_dev, raw,
+				DS2780_RSGAIN_MSB_REG, sizeof(u8) * 2);
+	if (ret < 0)
+		return ret;
+
+	return ds2780_save_eeprom(dev_info, DS2780_RSGAIN_MSB_REG);
+}
+
+static int ds2780_get_voltage(struct ds2780_device_info *dev_info,
+	int *voltage_uV)
+{
+	int ret;
+	s16 voltage_raw;
+
+	/*
+	 * The voltage value is located in 10 bits across the voltage MSB
+	 * and LSB registers in two's compliment form
+	 * Sign bit of the voltage value is in bit 7 of the voltage MSB register
+	 * Bits 9 - 3 of the voltage value are in bits 6 - 0 of the
+	 * voltage MSB register
+	 * Bits 2 - 0 of the voltage value are in bits 7 - 5 of the
+	 * voltage LSB register
+	 */
+	ret = ds2780_read16(dev_info->w1_dev, &voltage_raw,
+				DS2780_VOLT_MSB_REG);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * DS2780 reports voltage in units of 4.88mV, but the battery class
+	 * reports in units of uV, so convert by multiplying by 4880.
+	 */
+	*voltage_uV = (voltage_raw / 32) * 4880;
+	return 0;
+}
+
+static int ds2780_get_temperature(struct ds2780_device_info *dev_info,
+	int *temperature)
+{
+	int ret;
+	s16 temperature_raw;
+
+	/*
+	 * The temperature value is located in 10 bits across the temperature
+	 * MSB and LSB registers in two's compliment form
+	 * Sign bit of the temperature value is in bit 7 of the temperature
+	 * MSB register
+	 * Bits 9 - 3 of the temperature value are in bits 6 - 0 of the
+	 * temperature MSB register
+	 * Bits 2 - 0 of the temperature value are in bits 7 - 5 of the
+	 * temperature LSB register
+	 */
+	ret = ds2780_read16(dev_info->w1_dev, &temperature_raw,
+				DS2780_TEMP_MSB_REG);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * Temperature is measured in units of 0.125 degrees celcius, the
+	 * power_supply class measures temperature in tenths of degrees
+	 * celsius. The temperature value is stored as a 10 bit number, plus
+	 * sign in the upper bits of a 16 bit register.
+	 */
+	*temperature = ((temperature_raw / 32) * 125) / 100;
+	return 0;
+}
+
+static int ds2780_get_current(struct ds2780_device_info *dev_info,
+	enum current_types type, int *current_uA)
+{
+	int ret, sense_res;
+	s16 current_raw;
+	u8 sense_res_raw, reg_msb;
+
+	/*
+	 * The units of measurement for current are dependent on the value of
+	 * the sense resistor.
+	 */
+	ret = ds2780_read8(dev_info->w1_dev, &sense_res_raw, DS2780_RSNSP_REG);
+	if (ret < 0)
+		return ret;
+
+	if (sense_res_raw == 0) {
+		dev_err(dev_info->dev, "sense resistor value is 0\n");
+		return -ENXIO;
+	}
+	sense_res = 1000 / sense_res_raw;
+
+	if (type == CURRENT_NOW)
+		reg_msb = DS2780_CURRENT_MSB_REG;
+	else if (type == CURRENT_AVG)
+		reg_msb = DS2780_IAVG_MSB_REG;
+	else
+		return -EINVAL;
+
+	/*
+	 * The current value is located in 16 bits across the current MSB
+	 * and LSB registers in two's compliment form
+	 * Sign bit of the current value is in bit 7 of the current MSB register
+	 * Bits 14 - 8 of the current value are in bits 6 - 0 of the current
+	 * MSB register
+	 * Bits 7 - 0 of the current value are in bits 7 - 0 of the current
+	 * LSB register
+	 */
+	ret = ds2780_read16(dev_info->w1_dev, &current_raw, reg_msb);
+	if (ret < 0)
+		return ret;
+
+	*current_uA = current_raw * (DS2780_CURRENT_UNITS / sense_res);
+	return 0;
+}
+
+static int ds2780_get_accumulated_current(struct ds2780_device_info *dev_info,
+	int *accumulated_current)
+{
+	int ret, sense_res;
+	s16 current_raw;
+	u8 sense_res_raw;
+
+	/*
+	 * The units of measurement for accumulated current are dependent on
+	 * the value of the sense resistor.
+	 */
+	ret = ds2780_read8(dev_info->w1_dev, &sense_res_raw, DS2780_RSNSP_REG);
+	if (ret < 0)
+		return ret;
+
+	if (sense_res_raw == 0) {
+		dev_err(dev_info->dev, "sense resistor value is 0\n");
+		return -ENXIO;
+	}
+	sense_res = 1000 / sense_res_raw;
+
+	/*
+	 * The ACR value is located in 16 bits across the ACR MSB and
+	 * LSB registers
+	 * Bits 15 - 8 of the ACR value are in bits 7 - 0 of the ACR
+	 * MSB register
+	 * Bits 7 - 0 of the ACR value are in bits 7 - 0 of the ACR
+	 * LSB register
+	 */
+	ret = ds2780_read16(dev_info->w1_dev, &current_raw, DS2780_ACR_MSB_REG);
+	if (ret < 0)
+		return ret;
+
+	*accumulated_current = current_raw * (DS2780_CHARGE_UNITS / sense_res);
+	return 0;
+}
+
+static int ds2780_get_capacity(struct ds2780_device_info *dev_info,
+	int *capacity)
+{
+	int ret;
+	u8 raw;
+
+	ret = ds2780_read8(dev_info->w1_dev, &raw, DS2780_RARC_REG);
+	if (ret < 0)
+		return ret;
+
+	*capacity = raw;
+	return raw;
+}
+
+static int ds2780_get_status(struct ds2780_device_info *dev_info, int *status)
+{
+	int ret, current_uA, capacity;
+
+	ret = ds2780_get_current(dev_info, CURRENT_NOW, &current_uA);
+	if (ret < 0)
+		return ret;
+
+	ret = ds2780_get_capacity(dev_info, &capacity);
+	if (ret < 0)
+		return ret;
+
+	if (capacity == 100)
+		*status = POWER_SUPPLY_STATUS_FULL;
+	else if (current_uA == 0)
+		*status = POWER_SUPPLY_STATUS_NOT_CHARGING;
+	else if (current_uA < 0)
+		*status = POWER_SUPPLY_STATUS_DISCHARGING;
+	else
+		*status = POWER_SUPPLY_STATUS_CHARGING;
+
+	return 0;
+}
+
+static int ds2780_get_charge_now(struct ds2780_device_info *dev_info,
+	int *charge_now)
+{
+	int ret;
+	u16 charge_raw;
+
+	/*
+	 * The RAAC value is located in 16 bits across the RAAC MSB and
+	 * LSB registers
+	 * Bits 15 - 8 of the RAAC value are in bits 7 - 0 of the RAAC
+	 * MSB register
+	 * Bits 7 - 0 of the RAAC value are in bits 7 - 0 of the RAAC
+	 * LSB register
+	 */
+	ret = ds2780_read16(dev_info->w1_dev, &charge_raw, DS2780_RAAC_MSB_REG);
+	if (ret < 0)
+		return ret;
+
+	*charge_now = charge_raw * 1600;
+	return 0;
+}
+
+static int ds2780_get_control_register(struct ds2780_device_info *dev_info,
+	u8 *control_reg)
+{
+	return ds2780_read8(dev_info->w1_dev, control_reg, DS2780_CONTROL_REG);
+}
+
+static int ds2780_set_control_register(struct ds2780_device_info *dev_info,
+	u8 control_reg)
+{
+	int ret;
+
+	ret = ds2780_write(dev_info->w1_dev, &control_reg,
+				DS2780_CONTROL_REG, sizeof(u8));
+	if (ret < 0)
+		return ret;
+
+	return ds2780_save_eeprom(dev_info, DS2780_CONTROL_REG);
+}
+
+static int ds2780_battery_get_property(struct power_supply *psy,
+	enum power_supply_property psp,
+	union power_supply_propval *val)
+{
+	int ret = 0;
+	struct ds2780_device_info *dev_info = to_ds2780_device_info(psy);
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+		ret = ds2780_get_voltage(dev_info, &val->intval);
+		break;
+
+	case POWER_SUPPLY_PROP_TEMP:
+		ret = ds2780_get_temperature(dev_info, &val->intval);
+		break;
+
+	case POWER_SUPPLY_PROP_MODEL_NAME:
+		val->strval = model;
+		break;
+
+	case POWER_SUPPLY_PROP_MANUFACTURER:
+		val->strval = manufacturer;
+		break;
+
+	case POWER_SUPPLY_PROP_CURRENT_NOW:
+		ret = ds2780_get_current(dev_info, CURRENT_NOW, &val->intval);
+		break;
+
+	case POWER_SUPPLY_PROP_CURRENT_AVG:
+		ret = ds2780_get_current(dev_info, CURRENT_AVG, &val->intval);
+		break;
+
+	case POWER_SUPPLY_PROP_STATUS:
+		ret = ds2780_get_status(dev_info, &val->intval);
+		break;
+
+	case POWER_SUPPLY_PROP_CAPACITY:
+		ret = ds2780_get_capacity(dev_info, &val->intval);
+		break;
+
+	case POWER_SUPPLY_PROP_CHARGE_COUNTER:
+		ret = ds2780_get_accumulated_current(dev_info, &val->intval);
+		break;
+
+	case POWER_SUPPLY_PROP_CHARGE_NOW:
+		ret = ds2780_get_charge_now(dev_info, &val->intval);
+		break;
+
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static enum power_supply_property ds2780_battery_props[] = {
+	POWER_SUPPLY_PROP_STATUS,
+	POWER_SUPPLY_PROP_VOLTAGE_NOW,
+	POWER_SUPPLY_PROP_TEMP,
+	POWER_SUPPLY_PROP_MODEL_NAME,
+	POWER_SUPPLY_PROP_MANUFACTURER,
+	POWER_SUPPLY_PROP_CURRENT_NOW,
+	POWER_SUPPLY_PROP_CURRENT_AVG,
+	POWER_SUPPLY_PROP_CAPACITY,
+	POWER_SUPPLY_PROP_CHARGE_COUNTER,
+	POWER_SUPPLY_PROP_CHARGE_NOW,
+};
+
+static ssize_t ds2780_get_pmod_enabled(struct device *dev,
+	struct device_attribute *attr,
+	char *buf)
+{
+	int ret;
+	u8 control_reg;
+	struct power_supply *psy = to_power_supply(dev);
+	struct ds2780_device_info *dev_info = to_ds2780_device_info(psy);
+
+	/* Get power mode */
+	ret = ds2780_get_control_register(dev_info, &control_reg);
+	if (ret < 0)
+		return ret;
+
+	return sprintf(buf, "%d\n",
+		 !!(control_reg & DS2780_CONTROL_REG_PMOD));
+}
+
+static ssize_t ds2780_set_pmod_enabled(struct device *dev,
+	struct device_attribute *attr,
+	const char *buf,
+	size_t count)
+{
+	int ret;
+	u8 control_reg, new_setting;
+	struct power_supply *psy = to_power_supply(dev);
+	struct ds2780_device_info *dev_info = to_ds2780_device_info(psy);
+
+	/* Set power mode */
+	ret = ds2780_get_control_register(dev_info, &control_reg);
+	if (ret < 0)
+		return ret;
+
+	ret = kstrtou8(buf, 0, &new_setting);
+	if (ret < 0)
+		return ret;
+
+	if ((new_setting != 0) && (new_setting != 1)) {
+		dev_err(dev_info->dev, "Invalid pmod setting (0 or 1)\n");
+		return -EINVAL;
+	}
+
+	if (new_setting)
+		control_reg |= DS2780_CONTROL_REG_PMOD;
+	else
+		control_reg &= ~DS2780_CONTROL_REG_PMOD;
+
+	ret = ds2780_set_control_register(dev_info, control_reg);
+	if (ret < 0)
+		return ret;
+
+	return count;
+}
+
+static ssize_t ds2780_get_sense_resistor_value(struct device *dev,
+	struct device_attribute *attr,
+	char *buf)
+{
+	int ret;
+	u8 sense_resistor;
+	struct power_supply *psy = to_power_supply(dev);
+	struct ds2780_device_info *dev_info = to_ds2780_device_info(psy);
+
+	ret = ds2780_read8(dev_info->w1_dev, &sense_resistor, DS2780_RSNSP_REG);
+	if (ret < 0)
+		return ret;
+
+	ret = sprintf(buf, "%d\n", sense_resistor);
+	return ret;
+}
+
+static ssize_t ds2780_set_sense_resistor_value(struct device *dev,
+	struct device_attribute *attr,
+	const char *buf,
+	size_t count)
+{
+	int ret;
+	u8 new_setting;
+	struct power_supply *psy = to_power_supply(dev);
+	struct ds2780_device_info *dev_info = to_ds2780_device_info(psy);
+
+	ret = kstrtou8(buf, 0, &new_setting);
+	if (ret < 0)
+		return ret;
+
+	ret = ds2780_set_sense_register(dev_info, new_setting);
+	if (ret < 0)
+		return ret;
+
+	return count;
+}
+
+static ssize_t ds2780_get_rsgain_setting(struct device *dev,
+	struct device_attribute *attr,
+	char *buf)
+{
+	int ret;
+	u16 rsgain;
+	struct power_supply *psy = to_power_supply(dev);
+	struct ds2780_device_info *dev_info = to_ds2780_device_info(psy);
+
+	ret = ds2780_get_rsgain_register(dev_info, &rsgain);
+	if (ret < 0)
+		return ret;
+
+	return sprintf(buf, "%d\n", rsgain);
+}
+
+static ssize_t ds2780_set_rsgain_setting(struct device *dev,
+	struct device_attribute *attr,
+	const char *buf,
+	size_t count)
+{
+	int ret;
+	u16 new_setting;
+	struct power_supply *psy = to_power_supply(dev);
+	struct ds2780_device_info *dev_info = to_ds2780_device_info(psy);
+
+	ret = kstrtou16(buf, 0, &new_setting);
+	if (ret < 0)
+		return ret;
+
+	/* Gain can only be from 0 to 1.999 in steps of .001 */
+	if (new_setting > 1999) {
+		dev_err(dev_info->dev, "Invalid rsgain setting (0 - 1999)\n");
+		return -EINVAL;
+	}
+
+	ret = ds2780_set_rsgain_register(dev_info, new_setting);
+	if (ret < 0)
+		return ret;
+
+	return count;
+}
+
+static ssize_t ds2780_get_pio_pin(struct device *dev,
+	struct device_attribute *attr,
+	char *buf)
+{
+	int ret;
+	u8 sfr;
+	struct power_supply *psy = to_power_supply(dev);
+	struct ds2780_device_info *dev_info = to_ds2780_device_info(psy);
+
+	ret = ds2780_read8(dev_info->w1_dev, &sfr, DS2780_SFR_REG);
+	if (ret < 0)
+		return ret;
+
+	ret = sprintf(buf, "%d\n", sfr & DS2780_SFR_REG_PIOSC);
+	return ret;
+}
+
+static ssize_t ds2780_set_pio_pin(struct device *dev,
+	struct device_attribute *attr,
+	const char *buf,
+	size_t count)
+{
+	int ret;
+	u8 new_setting;
+	struct power_supply *psy = to_power_supply(dev);
+	struct ds2780_device_info *dev_info = to_ds2780_device_info(psy);
+
+	ret = kstrtou8(buf, 0, &new_setting);
+	if (ret < 0)
+		return ret;
+
+	if ((new_setting != 0) && (new_setting != 1)) {
+		dev_err(dev_info->dev, "Invalid pio_pin setting (0 or 1)\n");
+		return -EINVAL;
+	}
+
+	ret = ds2780_write(dev_info->w1_dev, &new_setting,
+				DS2780_SFR_REG, sizeof(u8));
+	if (ret < 0)
+		return ret;
+
+	return count;
+}
+
+static ssize_t ds2780_read_param_eeprom_bin(struct file *filp,
+				struct kobject *kobj,
+				struct bin_attribute *bin_attr,
+				char *buf, loff_t off, size_t count)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct power_supply *psy = to_power_supply(dev);
+	struct ds2780_device_info *dev_info = to_ds2780_device_info(psy);
+
+	count = min_t(loff_t, count,
+		DS2780_EEPROM_BLOCK1_END -
+		DS2780_EEPROM_BLOCK1_START + 1 - off);
+
+	return ds2780_read_block(dev_info->w1_dev, buf,
+				DS2780_EEPROM_BLOCK1_START + off, count);
+}
+
+static ssize_t ds2780_write_param_eeprom_bin(struct file *filp,
+				struct kobject *kobj,
+				struct bin_attribute *bin_attr,
+				char *buf, loff_t off, size_t count)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct power_supply *psy = to_power_supply(dev);
+	struct ds2780_device_info *dev_info = to_ds2780_device_info(psy);
+	int ret;
+
+	count = min_t(loff_t, count,
+		DS2780_EEPROM_BLOCK1_END -
+		DS2780_EEPROM_BLOCK1_START + 1 - off);
+
+	ret = ds2780_write(dev_info->w1_dev, buf,
+				DS2780_EEPROM_BLOCK1_START + off, count);
+	if (ret < 0)
+		return ret;
+
+	ret = ds2780_save_eeprom(dev_info, DS2780_EEPROM_BLOCK1_START);
+	if (ret < 0)
+		return ret;
+
+	return count;
+}
+
+static struct bin_attribute ds2780_param_eeprom_bin_attr = {
+	.attr = {
+		.name = "param_eeprom",
+		.mode = S_IRUGO | S_IWUSR,
+	},
+	.size = DS2780_EEPROM_BLOCK1_END - DS2780_EEPROM_BLOCK1_START + 1,
+	.read = ds2780_read_param_eeprom_bin,
+	.write = ds2780_write_param_eeprom_bin,
+};
+
+static ssize_t ds2780_read_user_eeprom_bin(struct file *filp,
+				struct kobject *kobj,
+				struct bin_attribute *bin_attr,
+				char *buf, loff_t off, size_t count)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct power_supply *psy = to_power_supply(dev);
+	struct ds2780_device_info *dev_info = to_ds2780_device_info(psy);
+
+	count = min_t(loff_t, count,
+		DS2780_EEPROM_BLOCK0_END -
+		DS2780_EEPROM_BLOCK0_START + 1 - off);
+
+	return ds2780_read_block(dev_info->w1_dev, buf,
+				DS2780_EEPROM_BLOCK0_START + off, count);
+
+}
+
+static ssize_t ds2780_write_user_eeprom_bin(struct file *filp,
+				struct kobject *kobj,
+				struct bin_attribute *bin_attr,
+				char *buf, loff_t off, size_t count)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct power_supply *psy = to_power_supply(dev);
+	struct ds2780_device_info *dev_info = to_ds2780_device_info(psy);
+	int ret;
+
+	count = min_t(loff_t, count,
+		DS2780_EEPROM_BLOCK0_END -
+		DS2780_EEPROM_BLOCK0_START + 1 - off);
+
+	ret = ds2780_write(dev_info->w1_dev, buf,
+				DS2780_EEPROM_BLOCK0_START + off, count);
+	if (ret < 0)
+		return ret;
+
+	ret = ds2780_save_eeprom(dev_info, DS2780_EEPROM_BLOCK0_START);
+	if (ret < 0)
+		return ret;
+
+	return count;
+}
+
+static struct bin_attribute ds2780_user_eeprom_bin_attr = {
+	.attr = {
+		.name = "user_eeprom",
+		.mode = S_IRUGO | S_IWUSR,
+	},
+	.size = DS2780_EEPROM_BLOCK0_END - DS2780_EEPROM_BLOCK0_START + 1,
+	.read = ds2780_read_user_eeprom_bin,
+	.write = ds2780_write_user_eeprom_bin,
+};
+
+static DEVICE_ATTR(pmod_enabled, S_IRUGO | S_IWUSR, ds2780_get_pmod_enabled,
+	ds2780_set_pmod_enabled);
+static DEVICE_ATTR(sense_resistor_value, S_IRUGO | S_IWUSR,
+	ds2780_get_sense_resistor_value, ds2780_set_sense_resistor_value);
+static DEVICE_ATTR(rsgain_setting, S_IRUGO | S_IWUSR, ds2780_get_rsgain_setting,
+	ds2780_set_rsgain_setting);
+static DEVICE_ATTR(pio_pin, S_IRUGO | S_IWUSR, ds2780_get_pio_pin,
+	ds2780_set_pio_pin);
+
+
+static struct attribute *ds2780_attributes[] = {
+	&dev_attr_pmod_enabled.attr,
+	&dev_attr_sense_resistor_value.attr,
+	&dev_attr_rsgain_setting.attr,
+	&dev_attr_pio_pin.attr,
+	NULL
+};
+
+static const struct attribute_group ds2780_attr_group = {
+	.attrs = ds2780_attributes,
+};
+
+static int __devinit ds2780_battery_probe(struct platform_device *pdev)
+{
+	int ret = 0;
+	struct ds2780_device_info *dev_info;
+
+	dev_info = kzalloc(sizeof(*dev_info), GFP_KERNEL);
+	if (!dev_info) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	platform_set_drvdata(pdev, dev_info);
+
+	dev_info->dev			= &pdev->dev;
+	dev_info->w1_dev		= pdev->dev.parent;
+	dev_info->bat.name		= dev_name(&pdev->dev);
+	dev_info->bat.type		= POWER_SUPPLY_TYPE_BATTERY;
+	dev_info->bat.properties	= ds2780_battery_props;
+	dev_info->bat.num_properties	= ARRAY_SIZE(ds2780_battery_props);
+	dev_info->bat.get_property	= ds2780_battery_get_property;
+
+	ret = power_supply_register(&pdev->dev, &dev_info->bat);
+	if (ret) {
+		dev_err(dev_info->dev, "failed to register battery\n");
+		goto fail_free_info;
+	}
+
+	ret = sysfs_create_group(&dev_info->bat.dev->kobj, &ds2780_attr_group);
+	if (ret) {
+		dev_err(dev_info->dev, "failed to create sysfs group\n");
+		goto fail_unregister;
+	}
+
+	ret = sysfs_create_bin_file(&dev_info->bat.dev->kobj,
+					&ds2780_param_eeprom_bin_attr);
+	if (ret) {
+		dev_err(dev_info->dev,
+				"failed to create param eeprom bin file");
+		goto fail_remove_group;
+	}
+
+	ret = sysfs_create_bin_file(&dev_info->bat.dev->kobj,
+					&ds2780_user_eeprom_bin_attr);
+	if (ret) {
+		dev_err(dev_info->dev,
+				"failed to create user eeprom bin file");
+		goto fail_remove_bin_file;
+	}
+
+	return 0;
+
+fail_remove_bin_file:
+	sysfs_remove_bin_file(&dev_info->bat.dev->kobj,
+				&ds2780_param_eeprom_bin_attr);
+fail_remove_group:
+	sysfs_remove_group(&dev_info->bat.dev->kobj, &ds2780_attr_group);
+fail_unregister:
+	power_supply_unregister(&dev_info->bat);
+fail_free_info:
+	kfree(dev_info);
+fail:
+	return ret;
+}
+
+static int __devexit ds2780_battery_remove(struct platform_device *pdev)
+{
+	struct ds2780_device_info *dev_info = platform_get_drvdata(pdev);
+
+	/* remove attributes */
+	sysfs_remove_group(&dev_info->bat.dev->kobj, &ds2780_attr_group);
+
+	power_supply_unregister(&dev_info->bat);
+
+	kfree(dev_info);
+	return 0;
+}
+
+MODULE_ALIAS("platform:ds2780-battery");
+
+static struct platform_driver ds2780_battery_driver = {
+	.driver = {
+		.name = "ds2780-battery",
+	},
+	.probe	  = ds2780_battery_probe,
+	.remove   = ds2780_battery_remove,
+};
+
+static int __init ds2780_battery_init(void)
+{
+	return platform_driver_register(&ds2780_battery_driver);
+}
+
+static void __exit ds2780_battery_exit(void)
+{
+	platform_driver_unregister(&ds2780_battery_driver);
+}
+
+module_init(ds2780_battery_init);
+module_exit(ds2780_battery_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Clifton Barnes <cabarnes@indesign-llc.com>");
+MODULE_DESCRIPTION("Maxim/Dallas DS2780 Stand-Alone Fuel Gauage IC driver");
diff -puN drivers/w1/slaves/Kconfig~w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support drivers/w1/slaves/Kconfig
--- a/drivers/w1/slaves/Kconfig~w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support
+++ a/drivers/w1/slaves/Kconfig
@@ -68,6 +68,19 @@ config W1_SLAVE_DS2760
 
 	  If you are unsure, say N.
 
+config W1_SLAVE_DS2780
+	tristate "Dallas 2780 battery monitor chip"
+	depends on W1
+	help
+	  If you enable this you will have the DS2780 battery monitor
+	  chip support.
+
+	  The battery monitor chip is used in many batteries/devices
+	  as the one who is responsible for charging/discharging/monitoring
+	  Li+ batteries.
+
+	  If you are unsure, say N.
+
 config W1_SLAVE_BQ27000
 	tristate "BQ27000 slave support"
 	depends on W1
diff -puN drivers/w1/slaves/Makefile~w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support drivers/w1/slaves/Makefile
--- a/drivers/w1/slaves/Makefile~w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support
+++ a/drivers/w1/slaves/Makefile
@@ -9,4 +9,5 @@ obj-$(CONFIG_W1_SLAVE_DS2423)	+= w1_ds24
 obj-$(CONFIG_W1_SLAVE_DS2431)	+= w1_ds2431.o
 obj-$(CONFIG_W1_SLAVE_DS2433)	+= w1_ds2433.o
 obj-$(CONFIG_W1_SLAVE_DS2760)	+= w1_ds2760.o
+obj-$(CONFIG_W1_SLAVE_DS2780)	+= w1_ds2780.o
 obj-$(CONFIG_W1_SLAVE_BQ27000)	+= w1_bq27000.o
diff -puN /dev/null drivers/w1/slaves/w1_ds2780.c
--- /dev/null
+++ a/drivers/w1/slaves/w1_ds2780.c
@@ -0,0 +1,217 @@
+/*
+ * 1-Wire implementation for the ds2780 chip
+ *
+ * Copyright (C) 2010 Indesign, LLC
+ *
+ * Author: Clifton Barnes <cabarnes@indesign-llc.com>
+ *
+ * Based on w1-ds2760 driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/types.h>
+#include <linux/platform_device.h>
+#include <linux/mutex.h>
+#include <linux/idr.h>
+
+#include "../w1.h"
+#include "../w1_int.h"
+#include "../w1_family.h"
+#include "w1_ds2780.h"
+
+int w1_ds2780_io(struct device *dev, char *buf, int addr, size_t count,
+			int io)
+{
+	struct w1_slave *sl = container_of(dev, struct w1_slave, dev);
+
+	if (!dev)
+		return -ENODEV;
+
+	mutex_lock(&sl->master->mutex);
+
+	if (addr > DS2780_DATA_SIZE || addr < 0) {
+		count = 0;
+		goto out;
+	}
+	count = min_t(int, count, DS2780_DATA_SIZE - addr);
+
+	if (w1_reset_select_slave(sl) == 0) {
+		if (io) {
+			w1_write_8(sl->master, W1_DS2780_WRITE_DATA);
+			w1_write_8(sl->master, addr);
+			w1_write_block(sl->master, buf, count);
+			/* XXX w1_write_block returns void, not n_written */
+		} else {
+			w1_write_8(sl->master, W1_DS2780_READ_DATA);
+			w1_write_8(sl->master, addr);
+			count = w1_read_block(sl->master, buf, count);
+		}
+	}
+
+out:
+	mutex_unlock(&sl->master->mutex);
+
+	return count;
+}
+EXPORT_SYMBOL(w1_ds2780_io);
+
+int w1_ds2780_eeprom_cmd(struct device *dev, int addr, int cmd)
+{
+	struct w1_slave *sl = container_of(dev, struct w1_slave, dev);
+
+	if (!dev)
+		return -EINVAL;
+
+	mutex_lock(&sl->master->mutex);
+
+	if (w1_reset_select_slave(sl) == 0) {
+		w1_write_8(sl->master, cmd);
+		w1_write_8(sl->master, addr);
+	}
+
+	mutex_unlock(&sl->master->mutex);
+	return 0;
+}
+EXPORT_SYMBOL(w1_ds2780_eeprom_cmd);
+
+static ssize_t w1_ds2780_read_bin(struct file *filp,
+				  struct kobject *kobj,
+				  struct bin_attribute *bin_attr,
+				  char *buf, loff_t off, size_t count)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	return w1_ds2780_io(dev, buf, off, count, 0);
+}
+
+static struct bin_attribute w1_ds2780_bin_attr = {
+	.attr = {
+		.name = "w1_slave",
+		.mode = S_IRUGO,
+	},
+	.size = DS2780_DATA_SIZE,
+	.read = w1_ds2780_read_bin,
+};
+
+static DEFINE_IDR(bat_idr);
+static DEFINE_MUTEX(bat_idr_lock);
+
+static int new_bat_id(void)
+{
+	int ret;
+
+	while (1) {
+		int id;
+
+		ret = idr_pre_get(&bat_idr, GFP_KERNEL);
+		if (ret == 0)
+			return -ENOMEM;
+
+		mutex_lock(&bat_idr_lock);
+		ret = idr_get_new(&bat_idr, NULL, &id);
+		mutex_unlock(&bat_idr_lock);
+
+		if (ret == 0) {
+			ret = id & MAX_ID_MASK;
+			break;
+		} else if (ret == -EAGAIN) {
+			continue;
+		} else {
+			break;
+		}
+	}
+
+	return ret;
+}
+
+static void release_bat_id(int id)
+{
+	mutex_lock(&bat_idr_lock);
+	idr_remove(&bat_idr, id);
+	mutex_unlock(&bat_idr_lock);
+}
+
+static int w1_ds2780_add_slave(struct w1_slave *sl)
+{
+	int ret;
+	int id;
+	struct platform_device *pdev;
+
+	id = new_bat_id();
+	if (id < 0) {
+		ret = id;
+		goto noid;
+	}
+
+	pdev = platform_device_alloc("ds2780-battery", id);
+	if (!pdev) {
+		ret = -ENOMEM;
+		goto pdev_alloc_failed;
+	}
+	pdev->dev.parent = &sl->dev;
+
+	ret = platform_device_add(pdev);
+	if (ret)
+		goto pdev_add_failed;
+
+	ret = sysfs_create_bin_file(&sl->dev.kobj, &w1_ds2780_bin_attr);
+	if (ret)
+		goto bin_attr_failed;
+
+	dev_set_drvdata(&sl->dev, pdev);
+
+	return 0;
+
+bin_attr_failed:
+pdev_add_failed:
+	platform_device_unregister(pdev);
+pdev_alloc_failed:
+	release_bat_id(id);
+noid:
+	return ret;
+}
+
+static void w1_ds2780_remove_slave(struct w1_slave *sl)
+{
+	struct platform_device *pdev = dev_get_drvdata(&sl->dev);
+	int id = pdev->id;
+
+	platform_device_unregister(pdev);
+	release_bat_id(id);
+	sysfs_remove_bin_file(&sl->dev.kobj, &w1_ds2780_bin_attr);
+}
+
+static struct w1_family_ops w1_ds2780_fops = {
+	.add_slave    = w1_ds2780_add_slave,
+	.remove_slave = w1_ds2780_remove_slave,
+};
+
+static struct w1_family w1_ds2780_family = {
+	.fid = W1_FAMILY_DS2780,
+	.fops = &w1_ds2780_fops,
+};
+
+static int __init w1_ds2780_init(void)
+{
+	idr_init(&bat_idr);
+	return w1_register_family(&w1_ds2780_family);
+}
+
+static void __exit w1_ds2780_exit(void)
+{
+	w1_unregister_family(&w1_ds2780_family);
+	idr_destroy(&bat_idr);
+}
+
+module_init(w1_ds2780_init);
+module_exit(w1_ds2780_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Clifton Barnes <cabarnes@indesign-llc.com>");
+MODULE_DESCRIPTION("1-wire Driver for Maxim/Dallas DS2780 Stand-Alone Fuel Gauge IC");
diff -puN /dev/null drivers/w1/slaves/w1_ds2780.h
--- /dev/null
+++ a/drivers/w1/slaves/w1_ds2780.h
@@ -0,0 +1,129 @@
+/*
+ * 1-Wire implementation for the ds2780 chip
+ *
+ * Copyright (C) 2010 Indesign, LLC
+ *
+ * Author: Clifton Barnes <cabarnes@indesign-llc.com>
+ *
+ * Based on w1-ds2760 driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef _W1_DS2780_H
+#define _W1_DS2780_H
+
+/* Function commands */
+#define W1_DS2780_READ_DATA		0x69
+#define W1_DS2780_WRITE_DATA		0x6C
+#define W1_DS2780_COPY_DATA		0x48
+#define W1_DS2780_RECALL_DATA		0xB8
+#define W1_DS2780_LOCK			0x6A
+
+/* Register map */
+/* Register 0x00 Reserved */
+#define DS2780_STATUS_REG		0x01
+#define DS2780_RAAC_MSB_REG		0x02
+#define DS2780_RAAC_LSB_REG		0x03
+#define DS2780_RSAC_MSB_REG		0x04
+#define DS2780_RSAC_LSB_REG		0x05
+#define DS2780_RARC_REG			0x06
+#define DS2780_RSRC_REG			0x07
+#define DS2780_IAVG_MSB_REG		0x08
+#define DS2780_IAVG_LSB_REG		0x09
+#define DS2780_TEMP_MSB_REG		0x0A
+#define DS2780_TEMP_LSB_REG		0x0B
+#define DS2780_VOLT_MSB_REG		0x0C
+#define DS2780_VOLT_LSB_REG		0x0D
+#define DS2780_CURRENT_MSB_REG		0x0E
+#define DS2780_CURRENT_LSB_REG		0x0F
+#define DS2780_ACR_MSB_REG		0x10
+#define DS2780_ACR_LSB_REG		0x11
+#define DS2780_ACRL_MSB_REG		0x12
+#define DS2780_ACRL_LSB_REG		0x13
+#define DS2780_AS_REG			0x14
+#define DS2780_SFR_REG			0x15
+#define DS2780_FULL_MSB_REG		0x16
+#define DS2780_FULL_LSB_REG		0x17
+#define DS2780_AE_MSB_REG		0x18
+#define DS2780_AE_LSB_REG		0x19
+#define DS2780_SE_MSB_REG		0x1A
+#define DS2780_SE_LSB_REG		0x1B
+/* Register 0x1C - 0x1E Reserved */
+#define DS2780_EEPROM_REG		0x1F
+#define DS2780_EEPROM_BLOCK0_START	0x20
+/* Register 0x20 - 0x2F User EEPROM */
+#define DS2780_EEPROM_BLOCK0_END	0x2F
+/* Register 0x30 - 0x5F Reserved */
+#define DS2780_EEPROM_BLOCK1_START	0x60
+#define DS2780_CONTROL_REG		0x60
+#define DS2780_AB_REG			0x61
+#define DS2780_AC_MSB_REG		0x62
+#define DS2780_AC_LSB_REG		0x63
+#define DS2780_VCHG_REG			0x64
+#define DS2780_IMIN_REG			0x65
+#define DS2780_VAE_REG			0x66
+#define DS2780_IAE_REG			0x67
+#define DS2780_AE_40_REG		0x68
+#define DS2780_RSNSP_REG		0x69
+#define DS2780_FULL_40_MSB_REG		0x6A
+#define DS2780_FULL_40_LSB_REG		0x6B
+#define DS2780_FULL_3040_SLOPE_REG	0x6C
+#define DS2780_FULL_2030_SLOPE_REG	0x6D
+#define DS2780_FULL_1020_SLOPE_REG	0x6E
+#define DS2780_FULL_0010_SLOPE_REG	0x6F
+#define DS2780_AE_3040_SLOPE_REG	0x70
+#define DS2780_AE_2030_SLOPE_REG	0x71
+#define DS2780_AE_1020_SLOPE_REG	0x72
+#define DS2780_AE_0010_SLOPE_REG	0x73
+#define DS2780_SE_3040_SLOPE_REG	0x74
+#define DS2780_SE_2030_SLOPE_REG	0x75
+#define DS2780_SE_1020_SLOPE_REG	0x76
+#define DS2780_SE_0010_SLOPE_REG	0x77
+#define DS2780_RSGAIN_MSB_REG		0x78
+#define DS2780_RSGAIN_LSB_REG		0x79
+#define DS2780_RSTC_REG			0x7A
+#define DS2780_FRSGAIN_MSB_REG		0x7B
+#define DS2780_FRSGAIN_LSB_REG		0x7C
+#define DS2780_EEPROM_BLOCK1_END	0x7C
+/* Register 0x7D - 0xFF Reserved */
+
+/* Number of valid register addresses */
+#define DS2780_DATA_SIZE		0x80
+
+/* Status register bits */
+#define DS2780_STATUS_REG_CHGTF		(1 << 7)
+#define DS2780_STATUS_REG_AEF		(1 << 6)
+#define DS2780_STATUS_REG_SEF		(1 << 5)
+#define DS2780_STATUS_REG_LEARNF	(1 << 4)
+/* Bit 3 Reserved */
+#define DS2780_STATUS_REG_UVF		(1 << 2)
+#define DS2780_STATUS_REG_PORF		(1 << 1)
+/* Bit 0 Reserved */
+
+/* Control register bits */
+/* Bit 7 Reserved */
+#define DS2780_CONTROL_REG_UVEN		(1 << 6)
+#define DS2780_CONTROL_REG_PMOD		(1 << 5)
+#define DS2780_CONTROL_REG_RNAOP	(1 << 4)
+/* Bit 0 - 3 Reserved */
+
+/* Special feature register bits */
+/* Bit 1 - 7 Reserved */
+#define DS2780_SFR_REG_PIOSC		(1 << 0)
+
+/* EEPROM register bits */
+#define DS2780_EEPROM_REG_EEC		(1 << 7)
+#define DS2780_EEPROM_REG_LOCK		(1 << 6)
+/* Bit 2 - 6 Reserved */
+#define DS2780_EEPROM_REG_BL1		(1 << 1)
+#define DS2780_EEPROM_REG_BL0		(1 << 0)
+
+extern int w1_ds2780_io(struct device *dev, char *buf, int addr, size_t count,
+			int io);
+extern int w1_ds2780_eeprom_cmd(struct device *dev, int addr, int cmd);
+
+#endif /* !_W1_DS2780_H */
diff -puN drivers/w1/w1_family.h~w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support drivers/w1/w1_family.h
--- a/drivers/w1/w1_family.h~w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support
+++ a/drivers/w1/w1_family.h
@@ -37,6 +37,7 @@
 #define W1_FAMILY_DS2408	0x29
 #define W1_EEPROM_DS2431	0x2D
 #define W1_FAMILY_DS2760	0x30
+#define W1_FAMILY_DS2780	0x32
 
 #define MAXNAMELEN		32
 
_

Patches currently in -mm which might be from cabarnes@indesign-llc.com are

origin.patch

