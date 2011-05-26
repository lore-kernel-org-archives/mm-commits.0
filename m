From: akpm@linux-foundation.org
Subject: [folded] w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support-v3.patch removed from -mm tree
Date: Thu, 26 May 2011 16:20:14 -0700
Message-ID: <201105262320.p4QNKEHI026552@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37154 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754820Ab1EZXUh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 May 2011 19:20:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cabarnes@indesign-llc.com, haojian.zhuang@gmail.com, johnpol@2ka.mipt.ru, ryan@bluewatersys.com, mm-commits@vger.kernel.org


The patch titled
     w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support-v3
has been removed from the -mm tree.  Its filename was
     w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support-v3.patch

This patch was dropped because it was folded into w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support-v3
From: Clifton Barnes <cabarnes@indesign-llc.com>

 - Formatting changes suggested from last version
 - Moved read/write functions to battery driver
 - Corrected temperature calculation
 - Changed EEPROM access to bin_attribute

Signed-off-by: Clifton Barnes <cabarnes@indesign-llc.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Ryan Mallon <ryan@bluewatersys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/ds2780_battery.c |  583 ++++++++++++++-----------------
 drivers/w1/slaves/w1_ds2780.c  |   53 --
 drivers/w1/slaves/w1_ds2780.h  |   15 
 3 files changed, 296 insertions(+), 355 deletions(-)

diff -puN drivers/power/ds2780_battery.c~w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support-v3 drivers/power/ds2780_battery.c
--- a/drivers/power/ds2780_battery.c~w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support-v3
+++ a/drivers/power/ds2780_battery.c
@@ -24,9 +24,6 @@
 #include "../w1/w1.h"
 #include "../w1/slaves/w1_ds2780.h"
 
-#define to_ds2780_device_info(x) container_of(x, struct ds2780_device_info, bat)
-#define to_power_supply(x)  (struct power_supply *) dev_get_drvdata(x)
-
 /* Current unit measurement in uA for a 1 milli-ohm sense resistor */
 #define DS2780_CURRENT_UNITS	1563
 /* Charge unit measurement in uAh for a 1 milli-ohm sense resistor */
@@ -52,160 +49,180 @@ enum current_types {
 static const char model[] = "DS2780";
 static const char manufacturer[] = "Maxim/Dallas";
 
-/* Set sense resistor value in mhos */
-static int ds2780_set_sense_register(struct ds2780_device_info *dev_info,
-	u8 conductance)
+static inline struct ds2780_device_info *to_ds2780_device_info(
+	struct power_supply *psy)
 {
-	int ret;
+	return container_of(psy, struct ds2780_device_info, bat);
+}
 
-	ret = w1_ds2780_write(dev_info->w1_dev, &conductance,
-				DS2780_RSNSP_REG, sizeof(char));
-	if (ret < 0)
-		return ret;
+static inline struct power_supply *to_power_supply(struct device *dev)
+{
+	return dev_get_drvdata(dev);
+}
 
-	ret = w1_ds2780_store_eeprom(dev_info->w1_dev, DS2780_RSNSP_REG);
-	if (ret < 0)
-		return ret;
+static inline int ds2780_read8(struct device *dev, u8 *val, int addr)
+{
+	return w1_ds2780_io(dev, val, addr, sizeof(u8), 0);
+}
+
+static int ds2780_read16(struct device *dev, s16 *val, int addr)
+{
+	int ret;
+	u8 raw[2];
 
-	ret = w1_ds2780_recall_eeprom(dev_info->w1_dev, DS2780_RSNSP_REG);
+	ret = w1_ds2780_io(dev, raw, addr, sizeof(u8) * 2, 0);
 	if (ret < 0)
 		return ret;
 
+	*val = (raw[0] << 8) | raw[1];
+
 	return 0;
 }
 
-/* Get RSGAIN value from 0 to 1.999 in steps of 0.001 */
-static int ds2780_get_rsgain_register(struct ds2780_device_info *dev_info,
-	u16 *rsgain)
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
 {
 	int ret;
-	char bytes[2];
 
-	ret = w1_ds2780_read(dev_info->w1_dev, bytes,
-				DS2780_RSGAIN_MSB_REG, sizeof(char));
+	ret = ds2780_store_eeprom(dev_info->w1_dev, reg);
 	if (ret < 0)
 		return ret;
 
-	ret = w1_ds2780_read(dev_info->w1_dev, bytes + 1,
-				DS2780_RSGAIN_LSB_REG, sizeof(char));
+	ret = ds2780_recall_eeprom(dev_info->w1_dev, reg);
 	if (ret < 0)
 		return ret;
 
-	*rsgain = (bytes[0] << 8) | bytes[1];
 	return 0;
 }
 
-/* Set RSGAIN value from 0 to 1.999 in steps of 0.001 */
-static int ds2780_set_rsgain_register(struct ds2780_device_info *dev_info,
-	u16 rsgain)
+/* Set sense resistor value in mhos */
+static int ds2780_set_sense_register(struct ds2780_device_info *dev_info,
+	u8 conductance)
 {
 	int ret;
-	char bytes[] = {rsgain >> 8, rsgain & 0xFF};
 
-	ret = w1_ds2780_write(dev_info->w1_dev, bytes,
-				DS2780_RSGAIN_MSB_REG, sizeof(char));
+	ret = ds2780_write(dev_info->w1_dev, &conductance,
+				DS2780_RSNSP_REG, sizeof(u8));
 	if (ret < 0)
 		return ret;
 
-	ret = w1_ds2780_write(dev_info->w1_dev, bytes + 1,
-				DS2780_RSGAIN_LSB_REG, sizeof(char));
-	if (ret < 0)
-		return ret;
+	return ds2780_save_eeprom(dev_info, DS2780_RSNSP_REG);
+}
 
-	ret = w1_ds2780_store_eeprom(dev_info->w1_dev, DS2780_RSGAIN_MSB_REG);
-	if (ret < 0)
-		return ret;
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
 
-	ret = w1_ds2780_recall_eeprom(dev_info->w1_dev, DS2780_RSGAIN_MSB_REG);
+	ret = ds2780_write(dev_info->w1_dev, raw,
+				DS2780_RSGAIN_MSB_REG, sizeof(u8) * 2);
 	if (ret < 0)
 		return ret;
 
-	return 0;
+	return ds2780_save_eeprom(dev_info, DS2780_RSGAIN_MSB_REG);
 }
 
 static int ds2780_get_voltage(struct ds2780_device_info *dev_info,
 	int *voltage_uV)
 {
-	char raw[2];
-	s16 voltage_raw;
 	int ret;
+	s16 voltage_raw;
 
-	/* The voltage value is located in 10 bits across the voltage MSB
-	   and LSB registers in two's compliment form
-	   Sign bit of the voltage value is in bit 7 of the voltage MSB register
-	   Bits 9 - 3 of the voltage value are in bits 6 - 0 of the
-	   voltage MSB register
-	   Bits 2 - 0 of the voltage value are in bits 7 - 5 of the
-	   voltage LSB register
-	*/
-	ret = w1_ds2780_read(dev_info->w1_dev, raw,
-				DS2780_VOLT_MSB_REG, sizeof(char));
-	if (ret < 0)
-		return ret;
-
-	ret = w1_ds2780_read(dev_info->w1_dev, raw + 1,
-				DS2780_VOLT_LSB_REG, sizeof(char));
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
 	if (ret < 0)
 		return ret;
 
-	voltage_raw = (raw[0] << 3) | (raw[1] >> 5);
-	/* DS2780 reports voltage in units of 4.88mV, but the battery class
-	 * reports in units of uV, so convert by multiplying by 4880. */
-	*voltage_uV = voltage_raw * 4880;
+	/*
+	 * DS2780 reports voltage in units of 4.88mV, but the battery class
+	 * reports in units of uV, so convert by multiplying by 4880.
+	 */
+	*voltage_uV = (voltage_raw / 32) * 4880;
 	return 0;
 }
 
 static int ds2780_get_temperature(struct ds2780_device_info *dev_info,
 	int *temperature)
 {
-	char raw[2];
-	s16 temperature_raw;
 	int ret;
+	s16 temperature_raw;
 
-	/* The temperature value is located in 10 bits across the temperature
-	   MSB and LSB registers in two's compliment form
-	   Sign bit of the temperature value is in bit 7 of the temperature
-	   MSB register
-	   Bits 9 - 3 of the temperature value are in bits 6 - 0 of the
-	   temperature MSB register
-	   Bits 2 - 0 of the temperature value are in bits 7 - 5 of the
-	   temperature LSB register
-	*/
-	ret = w1_ds2780_read(dev_info->w1_dev, raw,
-				DS2780_TEMP_MSB_REG, sizeof(char));
-	if (ret < 0)
-		return ret;
-
-	ret = w1_ds2780_read(dev_info->w1_dev, raw + 1,
-				DS2780_TEMP_LSB_REG, sizeof(char));
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
 	if (ret < 0)
 		return ret;
 
-	temperature_raw = (((signed char)raw[0] << 3)) | (raw[1] >> 5);
-	/* DS2780 reports temperature in signed units of 0.125 C, but the
-	 * battery class reports in units of 1/10 C, so we convert by
-	 * multiplying by .125 * 10 = 1.25. */
-	*temperature = temperature_raw + (temperature_raw / 4);
+	/*
+	 * Temperature is measured in units of 0.125 degrees celcius, the
+	 * power_supply class measures temperature in tenths of degrees
+	 * celsius. The temperature value is stored as a 10 bit number, plus
+	 * sign in the upper bits of a 16 bit register.
+	 */
+	*temperature = ((temperature_raw / 32) * 125) / 100;
 	return 0;
 }
 
 static int ds2780_get_current(struct ds2780_device_info *dev_info,
 	enum current_types type, int *current_uA)
 {
-	int ret;
-	char raw[2];
+	int ret, sense_res;
 	s16 current_raw;
-	int sense_res;
-	u8 sense_res_raw;
-	u8 reg_msb;
-	u8 reg_lsb;
+	u8 sense_res_raw, reg_msb;
 
 	/*
 	 * The units of measurement for current are dependent on the value of
 	 * the sense resistor.
 	 */
-	ret = w1_ds2780_read(dev_info->w1_dev, &sense_res_raw,
-				DS2780_RSNSP_REG, sizeof(u8));
+	ret = ds2780_read8(dev_info->w1_dev, &sense_res_raw, DS2780_RSNSP_REG);
 	if (ret < 0)
 		return ret;
 
@@ -215,33 +232,26 @@ static int ds2780_get_current(struct ds2
 	}
 	sense_res = 1000 / sense_res_raw;
 
-	if (type == CURRENT_NOW) {
+	if (type == CURRENT_NOW)
 		reg_msb = DS2780_CURRENT_MSB_REG;
-		reg_lsb = DS2780_CURRENT_LSB_REG;
-	} else if (type == CURRENT_AVG) {
+	else if (type == CURRENT_AVG)
 		reg_msb = DS2780_IAVG_MSB_REG;
-		reg_lsb = DS2780_IAVG_LSB_REG;
-	} else {
+	else
 		return -EINVAL;
-	}
 
-	/* The current value is located in 16 bits across the current MSB
-	   and LSB registers in two's compliment form
-	   Sign bit of the current value is in bit 7 of the current MSB register
-	   Bits 14 - 8 of the current value are in bits 6 - 0 of the current
-	   MSB register
-	   Bits 7 - 0 of the current value are in bits 7 - 0 of the current
-	   LSB register
-	*/
-	ret = w1_ds2780_read(dev_info->w1_dev, raw, reg_msb, sizeof(char));
-	if (ret < 0)
-		return ret;
-
-	ret = w1_ds2780_read(dev_info->w1_dev, raw + 1, reg_lsb, sizeof(char));
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
 	if (ret < 0)
 		return ret;
 
-	current_raw = ((signed char)raw[0] << 8) | raw[1];
 	*current_uA = current_raw * (DS2780_CURRENT_UNITS / sense_res);
 	return 0;
 }
@@ -249,18 +259,15 @@ static int ds2780_get_current(struct ds2
 static int ds2780_get_accumulated_current(struct ds2780_device_info *dev_info,
 	int *accumulated_current)
 {
-	char raw[2];
+	int ret, sense_res;
 	s16 current_raw;
-	int sense_res;
 	u8 sense_res_raw;
-	int ret;
 
 	/*
-	   The units of measurement for accumulated current are dependent on
-	   the value of the sense resistor.
+	 * The units of measurement for accumulated current are dependent on
+	 * the value of the sense resistor.
 	 */
-	ret = w1_ds2780_read(dev_info->w1_dev, &sense_res_raw,
-				DS2780_RSNSP_REG, sizeof(u8));
+	ret = ds2780_read8(dev_info->w1_dev, &sense_res_raw, DS2780_RSNSP_REG);
 	if (ret < 0)
 		return ret;
 
@@ -270,24 +277,18 @@ static int ds2780_get_accumulated_curren
 	}
 	sense_res = 1000 / sense_res_raw;
 
-	/* The ACR value is located in 16 bits across the ACR MSB and
-	   LSB registers
-	   Bits 15 - 8 of the ACR value are in bits 7 - 0 of the ACR
-	   MSB register
-	   Bits 7 - 0 of the ACR value are in bits 7 - 0 of the ACR
-	   LSB register
-	*/
-	ret = w1_ds2780_read(dev_info->w1_dev, raw,
-				DS2780_ACR_MSB_REG, sizeof(char));
-	if (ret < 0)
-		return ret;
-
-	ret = w1_ds2780_read(dev_info->w1_dev, raw + 1,
-				DS2780_ACR_LSB_REG, sizeof(char));
+	/*
+	 * The ACR value is located in 16 bits across the ACR MSB and
+	 * LSB registers
+	 * Bits 15 - 8 of the ACR value are in bits 7 - 0 of the ACR
+	 * MSB register
+	 * Bits 7 - 0 of the ACR value are in bits 7 - 0 of the ACR
+	 * LSB register
+	 */
+	ret = ds2780_read16(dev_info->w1_dev, &current_raw, DS2780_ACR_MSB_REG);
 	if (ret < 0)
 		return ret;
 
-	current_raw = (raw[0] << 8) | raw[1];
 	*accumulated_current = current_raw * (DS2780_CHARGE_UNITS / sense_res);
 	return 0;
 }
@@ -298,8 +299,7 @@ static int ds2780_get_capacity(struct ds
 	int ret;
 	u8 raw;
 
-	ret = w1_ds2780_read(dev_info->w1_dev, &raw,
-				DS2780_RARC_REG, sizeof(u8));
+	ret = ds2780_read8(dev_info->w1_dev, &raw, DS2780_RARC_REG);
 	if (ret < 0)
 		return ret;
 
@@ -309,9 +309,7 @@ static int ds2780_get_capacity(struct ds
 
 static int ds2780_get_status(struct ds2780_device_info *dev_info, int *status)
 {
-	int ret;
-	int current_uA;
-	int capacity;
+	int ret, current_uA, capacity;
 
 	ret = ds2780_get_current(dev_info, CURRENT_NOW, &current_uA);
 	if (ret < 0)
@@ -336,47 +334,29 @@ static int ds2780_get_status(struct ds27
 static int ds2780_get_charge_now(struct ds2780_device_info *dev_info,
 	int *charge_now)
 {
-	char raw[2];
-	u16 charge_raw;
 	int ret;
+	u16 charge_raw;
 
-	/* The RAAC value is located in 16 bits across the RAAC MSB and
-	   LSB registers
-	   Bits 15 - 8 of the RAAC value are in bits 7 - 0 of the RAAC
-	   MSB register
-	   Bits 7 - 0 of the RAAC value are in bits 7 - 0 of the RAAC
-	   LSB register
-	*/
-	ret = w1_ds2780_read(dev_info->w1_dev, raw,
-				DS2780_RAAC_MSB_REG, sizeof(char));
-	if (ret < 0)
-		return ret;
-
-	ret = w1_ds2780_read(dev_info->w1_dev, raw + 1,
-				DS2780_RAAC_LSB_REG, sizeof(char));
+	/*
+	 * The RAAC value is located in 16 bits across the RAAC MSB and
+	 * LSB registers
+	 * Bits 15 - 8 of the RAAC value are in bits 7 - 0 of the RAAC
+	 * MSB register
+	 * Bits 7 - 0 of the RAAC value are in bits 7 - 0 of the RAAC
+	 * LSB register
+	 */
+	ret = ds2780_read16(dev_info->w1_dev, &charge_raw, DS2780_RAAC_MSB_REG);
 	if (ret < 0)
 		return ret;
 
-	charge_raw = (raw[0] << 8) | raw[1];
 	*charge_now = charge_raw * 1600;
-
 	return 0;
-
 }
 
 static int ds2780_get_control_register(struct ds2780_device_info *dev_info,
 	u8 *control_reg)
 {
-	u8 reg;
-	int ret;
-
-	ret = w1_ds2780_read(dev_info->w1_dev, &reg,
-				DS2780_CONTROL_REG, sizeof(u8));
-	if (ret < 0)
-		return ret;
-
-	*control_reg = reg;
-	return 0;
+	return ds2780_read8(dev_info->w1_dev, control_reg, DS2780_CONTROL_REG);
 }
 
 static int ds2780_set_control_register(struct ds2780_device_info *dev_info,
@@ -384,20 +364,12 @@ static int ds2780_set_control_register(s
 {
 	int ret;
 
-	ret = w1_ds2780_write(dev_info->w1_dev, &control_reg,
+	ret = ds2780_write(dev_info->w1_dev, &control_reg,
 				DS2780_CONTROL_REG, sizeof(u8));
 	if (ret < 0)
 		return ret;
 
-	ret = w1_ds2780_store_eeprom(dev_info->w1_dev, DS2780_CONTROL_REG);
-	if (ret < 0)
-		return ret;
-
-	ret = w1_ds2780_recall_eeprom(dev_info->w1_dev, DS2780_CONTROL_REG);
-	if (ret < 0)
-		return ret;
-
-	return 0;
+	return ds2780_save_eeprom(dev_info, DS2780_CONTROL_REG);
 }
 
 static int ds2780_battery_get_property(struct power_supply *psy,
@@ -482,12 +454,8 @@ static ssize_t ds2780_get_pmod_enabled(s
 	if (ret < 0)
 		return ret;
 
-	if (control_reg & DS2780_CONTROL_REG_PMOD)
-		ret = sprintf(buf, "1\n");
-	else
-		ret = sprintf(buf, "0\n");
-
-	return ret;
+	return sprintf(buf, "%d\n",
+		 !!(control_reg & DS2780_CONTROL_REG_PMOD));
 }
 
 static ssize_t ds2780_set_pmod_enabled(struct device *dev,
@@ -496,8 +464,7 @@ static ssize_t ds2780_set_pmod_enabled(s
 	size_t count)
 {
 	int ret;
-	u8 control_reg;
-	u8 new_setting;
+	u8 control_reg, new_setting;
 	struct power_supply *psy = to_power_supply(dev);
 	struct ds2780_device_info *dev_info = to_ds2780_device_info(psy);
 
@@ -506,7 +473,7 @@ static ssize_t ds2780_set_pmod_enabled(s
 	if (ret < 0)
 		return ret;
 
-	ret = kstrtou8(buf, 10, &new_setting);
+	ret = kstrtou8(buf, 0, &new_setting);
 	if (ret < 0)
 		return ret;
 
@@ -525,7 +492,6 @@ static ssize_t ds2780_set_pmod_enabled(s
 		return ret;
 
 	return count;
-
 }
 
 static ssize_t ds2780_get_sense_resistor_value(struct device *dev,
@@ -537,12 +503,11 @@ static ssize_t ds2780_get_sense_resistor
 	struct power_supply *psy = to_power_supply(dev);
 	struct ds2780_device_info *dev_info = to_ds2780_device_info(psy);
 
-	ret = w1_ds2780_read(dev_info->w1_dev, &sense_resistor,
-				DS2780_RSNSP_REG, sizeof(u8));
+	ret = ds2780_read8(dev_info->w1_dev, &sense_resistor, DS2780_RSNSP_REG);
 	if (ret < 0)
 		return ret;
 
-	ret = sprintf(buf, "%i\n", sense_resistor);
+	ret = sprintf(buf, "%d\n", sense_resistor);
 	return ret;
 }
 
@@ -556,7 +521,7 @@ static ssize_t ds2780_set_sense_resistor
 	struct power_supply *psy = to_power_supply(dev);
 	struct ds2780_device_info *dev_info = to_ds2780_device_info(psy);
 
-	ret = kstrtou8(buf, 10, &new_setting);
+	ret = kstrtou8(buf, 0, &new_setting);
 	if (ret < 0)
 		return ret;
 
@@ -580,8 +545,7 @@ static ssize_t ds2780_get_rsgain_setting
 	if (ret < 0)
 		return ret;
 
-	ret = sprintf(buf, "%d\n", rsgain);
-	return ret;
+	return sprintf(buf, "%d\n", rsgain);
 }
 
 static ssize_t ds2780_set_rsgain_setting(struct device *dev,
@@ -594,7 +558,7 @@ static ssize_t ds2780_set_rsgain_setting
 	struct power_supply *psy = to_power_supply(dev);
 	struct ds2780_device_info *dev_info = to_ds2780_device_info(psy);
 
-	ret = kstrtou16(buf, 10, &new_setting);
+	ret = kstrtou16(buf, 0, &new_setting);
 	if (ret < 0)
 		return ret;
 
@@ -611,167 +575,171 @@ static ssize_t ds2780_set_rsgain_setting
 	return count;
 }
 
-static ssize_t ds2780_get_user_eeprom(struct device *dev,
+static ssize_t ds2780_get_pio_pin(struct device *dev,
 	struct device_attribute *attr,
 	char *buf)
 {
 	int ret;
+	u8 sfr;
 	struct power_supply *psy = to_power_supply(dev);
 	struct ds2780_device_info *dev_info = to_ds2780_device_info(psy);
 
-	ret = w1_ds2780_read(dev_info->w1_dev, buf, DS2780_EEPROM_BLOCK0_START,
-				DS2780_USER_EEPROM_SIZE);
+	ret = ds2780_read8(dev_info->w1_dev, &sfr, DS2780_SFR_REG);
 	if (ret < 0)
 		return ret;
 
-	return DS2780_USER_EEPROM_SIZE;
+	ret = sprintf(buf, "%d\n", sfr & DS2780_SFR_REG_PIOSC);
+	return ret;
 }
 
-static ssize_t ds2780_set_user_eeprom(struct device *dev,
+static ssize_t ds2780_set_pio_pin(struct device *dev,
 	struct device_attribute *attr,
 	const char *buf,
 	size_t count)
 {
 	int ret;
+	u8 new_setting;
 	struct power_supply *psy = to_power_supply(dev);
 	struct ds2780_device_info *dev_info = to_ds2780_device_info(psy);
 
-	/* Only write as much as there is user EEPROM to not overwrite
-	   parameter EEPROM
-	*/
-	if (count > DS2780_USER_EEPROM_SIZE)
-		count = DS2780_USER_EEPROM_SIZE;
-
-	ret = w1_ds2780_write(dev_info->w1_dev, (char *)buf,
-				DS2780_EEPROM_BLOCK0_START, count);
+	ret = kstrtou8(buf, 0, &new_setting);
 	if (ret < 0)
 		return ret;
 
-	ret = w1_ds2780_store_eeprom(dev_info->w1_dev,
-					DS2780_EEPROM_BLOCK0_START);
-	if (ret < 0)
-		return ret;
+	if ((new_setting != 0) && (new_setting != 1)) {
+		dev_err(dev_info->dev, "Invalid pio_pin setting (0 or 1)\n");
+		return -EINVAL;
+	}
 
-	ret = w1_ds2780_recall_eeprom(dev_info->w1_dev,
-					DS2780_EEPROM_BLOCK0_START);
+	ret = ds2780_write(dev_info->w1_dev, &new_setting,
+				DS2780_SFR_REG, sizeof(u8));
 	if (ret < 0)
 		return ret;
 
 	return count;
 }
 
-static ssize_t ds2780_get_param_eeprom(struct device *dev,
-	struct device_attribute *attr,
-	char *buf)
+static ssize_t ds2780_read_param_eeprom_bin(struct file *filp,
+				struct kobject *kobj,
+				struct bin_attribute *bin_attr,
+				char *buf, loff_t off, size_t count)
 {
-	int ret;
+	struct device *dev = container_of(kobj, struct device, kobj);
 	struct power_supply *psy = to_power_supply(dev);
 	struct ds2780_device_info *dev_info = to_ds2780_device_info(psy);
 
-	ret = w1_ds2780_read(dev_info->w1_dev, buf, DS2780_EEPROM_BLOCK1_START,
-				DS2780_PARAM_EEPROM_SIZE);
-	if (ret < 0)
-		return ret;
+	count = min((loff_t)count,
+		DS2780_EEPROM_BLOCK1_END -
+		DS2780_EEPROM_BLOCK1_START + 1 - off);
 
-	return DS2780_PARAM_EEPROM_SIZE;
+	return ds2780_read_block(dev_info->w1_dev, buf,
+				DS2780_EEPROM_BLOCK1_START + off, count);
 }
 
-static ssize_t ds2780_set_param_eeprom(struct device *dev,
-	struct device_attribute *attr,
-	const char *buf,
-	size_t count)
+static ssize_t ds2780_write_param_eeprom_bin(struct file *filp,
+				struct kobject *kobj,
+				struct bin_attribute *bin_attr,
+				char *buf, loff_t off, size_t count)
 {
-	int ret;
+	struct device *dev = container_of(kobj, struct device, kobj);
 	struct power_supply *psy = to_power_supply(dev);
 	struct ds2780_device_info *dev_info = to_ds2780_device_info(psy);
+	int ret;
 
-	/* Only write as much as there is parameter EEPROM */
-	if (count > DS2780_PARAM_EEPROM_SIZE)
-		count = DS2780_PARAM_EEPROM_SIZE;
+	count = min((loff_t)count,
+		DS2780_EEPROM_BLOCK1_END -
+		DS2780_EEPROM_BLOCK1_START + 1 - off);
 
-	ret = w1_ds2780_write(dev_info->w1_dev, (char *)buf,
-				DS2780_EEPROM_BLOCK1_START, count);
+	ret = ds2780_write(dev_info->w1_dev, buf,
+				DS2780_EEPROM_BLOCK1_START + off, count);
 	if (ret < 0)
 		return ret;
 
-	ret = w1_ds2780_store_eeprom(dev_info->w1_dev,
-					DS2780_EEPROM_BLOCK1_START);
-	if (ret < 0)
-		return ret;
-
-	ret = w1_ds2780_recall_eeprom(dev_info->w1_dev,
-					DS2780_EEPROM_BLOCK1_START);
+	ret = ds2780_save_eeprom(dev_info, DS2780_EEPROM_BLOCK1_START);
 	if (ret < 0)
 		return ret;
 
 	return count;
 }
 
-static ssize_t ds2780_get_pio_pin(struct device *dev,
-	struct device_attribute *attr,
-	char *buf)
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
 {
-	int ret;
-	u8 sfr;
+	struct device *dev = container_of(kobj, struct device, kobj);
 	struct power_supply *psy = to_power_supply(dev);
 	struct ds2780_device_info *dev_info = to_ds2780_device_info(psy);
 
-	ret = w1_ds2780_read(dev_info->w1_dev, &sfr,
-				DS2780_SFR_REG, sizeof(u8));
-	if (ret < 0)
-		return ret;
+	count = min((loff_t)count,
+		DS2780_EEPROM_BLOCK0_END -
+		DS2780_EEPROM_BLOCK0_START + 1 - off);
+
+	return ds2780_read_block(dev_info->w1_dev, buf,
+				DS2780_EEPROM_BLOCK0_START + off, count);
 
-	ret = sprintf(buf, "%d\n", sfr & DS2780_SFR_REG_PIOSC);
-	return ret;
 }
 
-static ssize_t ds2780_set_pio_pin(struct device *dev,
-	struct device_attribute *attr,
-	const char *buf,
-	size_t count)
+static ssize_t ds2780_write_user_eeprom_bin(struct file *filp,
+				struct kobject *kobj,
+				struct bin_attribute *bin_attr,
+				char *buf, loff_t off, size_t count)
 {
-	int ret;
-	u8 new_setting;
+	struct device *dev = container_of(kobj, struct device, kobj);
 	struct power_supply *psy = to_power_supply(dev);
 	struct ds2780_device_info *dev_info = to_ds2780_device_info(psy);
+	int ret;
 
-	ret = kstrtou8(buf, 10, &new_setting);
+	count = min((loff_t)count,
+		DS2780_EEPROM_BLOCK0_END -
+		DS2780_EEPROM_BLOCK0_START + 1 - off);
+
+	ret = ds2780_write(dev_info->w1_dev, buf,
+				DS2780_EEPROM_BLOCK0_START + off, count);
 	if (ret < 0)
 		return ret;
 
-	if ((new_setting != 0) && (new_setting != 1)) {
-		dev_err(dev_info->dev, "Invalid pio_pin setting (0 or 1)\n");
-		return -EINVAL;
-	}
-
-	ret = w1_ds2780_write(dev_info->w1_dev, &new_setting,
-				DS2780_SFR_REG, sizeof(u8));
+	ret = ds2780_save_eeprom(dev_info, DS2780_EEPROM_BLOCK0_START);
 	if (ret < 0)
 		return ret;
 
 	return count;
 }
 
+static struct bin_attribute ds2780_user_eeprom_bin_attr = {
+	.attr = {
+		.name = "user_eeprom",
+		.mode = S_IRUGO | S_IWUSR,
+	},
+	.size = DS2780_EEPROM_BLOCK0_END - DS2780_EEPROM_BLOCK0_START + 1,
+	.read = ds2780_read_user_eeprom_bin,
+	.write = ds2780_write_user_eeprom_bin,
+};
 
-static DEVICE_ATTR(pmod_enabled, 0644, ds2780_get_pmod_enabled,
-					ds2780_set_pmod_enabled);
-static DEVICE_ATTR(sense_resistor_value, 0644, ds2780_get_sense_resistor_value,
-					ds2780_set_sense_resistor_value);
-static DEVICE_ATTR(rsgain_setting, 0644, ds2780_get_rsgain_setting,
-					ds2780_set_rsgain_setting);
-static DEVICE_ATTR(user_eeprom, 0644, ds2780_get_user_eeprom,
-					ds2780_set_user_eeprom);
-static DEVICE_ATTR(param_eeprom, 0644, ds2780_get_param_eeprom,
-					ds2780_set_param_eeprom);
-static DEVICE_ATTR(pio_pin, 0644, ds2780_get_pio_pin, ds2780_set_pio_pin);
+static DEVICE_ATTR(pmod_enabled, S_IRUGO | S_IWUSR, ds2780_get_pmod_enabled,
+	ds2780_set_pmod_enabled);
+static DEVICE_ATTR(sense_resistor_value, S_IRUGO | S_IWUSR,
+	ds2780_get_sense_resistor_value, ds2780_set_sense_resistor_value);
+static DEVICE_ATTR(rsgain_setting, S_IRUGO | S_IWUSR, ds2780_get_rsgain_setting,
+	ds2780_set_rsgain_setting);
+static DEVICE_ATTR(pio_pin, S_IRUGO | S_IWUSR, ds2780_get_pio_pin,
+	ds2780_set_pio_pin);
 
 
 static struct attribute *ds2780_attributes[] = {
 	&dev_attr_pmod_enabled.attr,
 	&dev_attr_sense_resistor_value.attr,
 	&dev_attr_rsgain_setting.attr,
-	&dev_attr_user_eeprom.attr,
-	&dev_attr_param_eeprom.attr,
 	&dev_attr_pio_pin.attr,
 	NULL
 };
@@ -780,7 +748,7 @@ static const struct attribute_group ds27
 	.attrs = ds2780_attributes,
 };
 
-static int ds2780_battery_probe(struct platform_device *pdev)
+static int __devinit ds2780_battery_probe(struct platform_device *pdev)
 {
 	int ret = 0;
 	struct ds2780_device_info *dev_info;
@@ -788,7 +756,7 @@ static int ds2780_battery_probe(struct p
 	dev_info = kzalloc(sizeof(*dev_info), GFP_KERNEL);
 	if (!dev_info) {
 		ret = -ENOMEM;
-		goto dev_info_alloc_failed;
+		goto fail;
 	}
 
 	platform_set_drvdata(pdev, dev_info);
@@ -804,26 +772,47 @@ static int ds2780_battery_probe(struct p
 	ret = power_supply_register(&pdev->dev, &dev_info->bat);
 	if (ret) {
 		dev_err(dev_info->dev, "failed to register battery\n");
-		goto batt_failed;
+		goto fail_free_info;
 	}
 
 	ret = sysfs_create_group(&dev_info->bat.dev->kobj, &ds2780_attr_group);
 	if (ret) {
-		printk(KERN_INFO "ds2780: failed to create sysfs group\n");
-		goto fail_sysfs;
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
 	}
 
 	return 0;
 
-fail_sysfs:
+fail_remove_bin_file:
+	sysfs_remove_bin_file(&dev_info->bat.dev->kobj,
+				&ds2780_param_eeprom_bin_attr);
+fail_remove_group:
+	sysfs_remove_group(&dev_info->bat.dev->kobj, &ds2780_attr_group);
+fail_unregister:
 	power_supply_unregister(&dev_info->bat);
-batt_failed:
+fail_free_info:
 	kfree(dev_info);
-dev_info_alloc_failed:
+fail:
 	return ret;
 }
 
-static int ds2780_battery_remove(struct platform_device *pdev)
+static int __devexit ds2780_battery_remove(struct platform_device *pdev)
 {
 	struct ds2780_device_info *dev_info = platform_get_drvdata(pdev);
 
@@ -836,26 +825,6 @@ static int ds2780_battery_remove(struct 
 	return 0;
 }
 
-#ifdef CONFIG_PM
-
-static int ds2780_battery_suspend(struct platform_device *pdev,
-				  pm_message_t state)
-{
-	return 0;
-}
-
-static int ds2780_battery_resume(struct platform_device *pdev)
-{
-	return 0;
-}
-
-#else
-
-#define ds2780_battery_suspend NULL
-#define ds2780_battery_resume NULL
-
-#endif /* CONFIG_PM */
-
 MODULE_ALIAS("platform:ds2780-battery");
 
 static struct platform_driver ds2780_battery_driver = {
@@ -864,8 +833,6 @@ static struct platform_driver ds2780_bat
 	},
 	.probe	  = ds2780_battery_probe,
 	.remove   = ds2780_battery_remove,
-	.suspend  = ds2780_battery_suspend,
-	.resume	  = ds2780_battery_resume,
 };
 
 static int __init ds2780_battery_init(void)
diff -puN drivers/w1/slaves/w1_ds2780.c~w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support-v3 drivers/w1/slaves/w1_ds2780.c
--- a/drivers/w1/slaves/w1_ds2780.c~w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support-v3
+++ a/drivers/w1/slaves/w1_ds2780.c
@@ -26,7 +26,7 @@
 #include "../w1_family.h"
 #include "w1_ds2780.h"
 
-static int w1_ds2780_io(struct device *dev, char *buf, int addr, size_t count,
+int w1_ds2780_io(struct device *dev, char *buf, int addr, size_t count,
 			int io)
 {
 	struct w1_slave *sl = container_of(dev, struct w1_slave, dev);
@@ -40,19 +40,18 @@ static int w1_ds2780_io(struct device *d
 		count = 0;
 		goto out;
 	}
-	if (addr + count > DS2780_DATA_SIZE)
-		count = DS2780_DATA_SIZE - addr;
+	count = min((int)count, DS2780_DATA_SIZE - addr);
 
-	if (!w1_reset_select_slave(sl)) {
-		if (!io) {
-			w1_write_8(sl->master, W1_DS2780_READ_DATA);
-			w1_write_8(sl->master, addr);
-			count = w1_read_block(sl->master, buf, count);
-		} else {
+	if (w1_reset_select_slave(sl) == 0) {
+		if (io) {
 			w1_write_8(sl->master, W1_DS2780_WRITE_DATA);
 			w1_write_8(sl->master, addr);
 			w1_write_block(sl->master, buf, count);
 			/* XXX w1_write_block returns void, not n_written */
+		} else {
+			w1_write_8(sl->master, W1_DS2780_READ_DATA);
+			w1_write_8(sl->master, addr);
+			count = w1_read_block(sl->master, buf, count);
 		}
 	}
 
@@ -61,20 +60,9 @@ out:
 
 	return count;
 }
+EXPORT_SYMBOL(w1_ds2780_io);
 
-int w1_ds2780_read(struct device *dev, char *buf, int addr, size_t count)
-{
-	return w1_ds2780_io(dev, buf, addr, count, 0);
-}
-EXPORT_SYMBOL(w1_ds2780_read);
-
-int w1_ds2780_write(struct device *dev, char *buf, int addr, size_t count)
-{
-	return w1_ds2780_io(dev, buf, addr, count, 1);
-}
-EXPORT_SYMBOL(w1_ds2780_write);
-
-static int w1_ds2780_eeprom_cmd(struct device *dev, int addr, int cmd)
+int w1_ds2780_eeprom_cmd(struct device *dev, int addr, int cmd)
 {
 	struct w1_slave *sl = container_of(dev, struct w1_slave, dev);
 
@@ -91,25 +79,15 @@ static int w1_ds2780_eeprom_cmd(struct d
 	mutex_unlock(&sl->master->mutex);
 	return 0;
 }
+EXPORT_SYMBOL(w1_ds2780_eeprom_cmd);
 
-int w1_ds2780_store_eeprom(struct device *dev, int addr)
-{
-	return w1_ds2780_eeprom_cmd(dev, addr, W1_DS2780_COPY_DATA);
-}
-EXPORT_SYMBOL(w1_ds2780_store_eeprom);
-
-int w1_ds2780_recall_eeprom(struct device *dev, int addr)
-{
-	return w1_ds2780_eeprom_cmd(dev, addr, W1_DS2780_RECALL_DATA);
-}
-EXPORT_SYMBOL(w1_ds2780_recall_eeprom);
-
-static ssize_t w1_ds2780_read_bin(struct file *filp, struct kobject *kobj,
+static ssize_t w1_ds2780_read_bin(struct file *filp,
+				  struct kobject *kobj,
 				  struct bin_attribute *bin_attr,
 				  char *buf, loff_t off, size_t count)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
-	return w1_ds2780_read(dev, buf, off, count);
+	return w1_ds2780_io(dev, buf, off, count, 0);
 }
 
 static struct bin_attribute w1_ds2780_bin_attr = {
@@ -188,7 +166,7 @@ static int w1_ds2780_add_slave(struct w1
 
 	dev_set_drvdata(&sl->dev, pdev);
 
-	goto success;
+	return 0;
 
 bin_attr_failed:
 pdev_add_failed:
@@ -196,7 +174,6 @@ pdev_add_failed:
 pdev_alloc_failed:
 	release_bat_id(id);
 noid:
-success:
 	return ret;
 }
 
diff -puN drivers/w1/slaves/w1_ds2780.h~w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support-v3 drivers/w1/slaves/w1_ds2780.h
--- a/drivers/w1/slaves/w1_ds2780.h~w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support-v3
+++ a/drivers/w1/slaves/w1_ds2780.h
@@ -13,8 +13,8 @@
  *
  */
 
-#ifndef __w1_ds2780_h__
-#define __w1_ds2780_h__
+#ifndef _W1_DS2780_H
+#define _W1_DS2780_H
 
 /* Function commands */
 #define W1_DS2780_READ_DATA		0x69
@@ -122,11 +122,8 @@
 #define DS2780_EEPROM_REG_BL1		(1 << 1)
 #define DS2780_EEPROM_REG_BL0		(1 << 0)
 
-extern int w1_ds2780_read(struct device *dev, char *buf, int addr,
-			size_t count);
-extern int w1_ds2780_write(struct device *dev, char *buf, int addr,
-			size_t count);
-extern int w1_ds2780_store_eeprom(struct device *dev, int addr);
-extern int w1_ds2780_recall_eeprom(struct device *dev, int addr);
+extern int w1_ds2780_io(struct device *dev, char *buf, int addr, size_t count,
+			int io);
+extern int w1_ds2780_eeprom_cmd(struct device *dev, int addr, int cmd);
 
-#endif /* !__w1_ds2780_h__ */
+#endif /* !_W1_DS2780_H */
_

Patches currently in -mm which might be from cabarnes@indesign-llc.com are

w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support.patch
w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support-v3-fix.patch

