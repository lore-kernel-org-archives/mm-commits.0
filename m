From: akpm@linux-foundation.org
Subject: [to-be-updated] w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support.patch removed from -mm tree
Date: Wed, 11 May 2011 12:47:34 -0700
Message-ID: <201105111947.p4BJlaxv021402@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34268 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754642Ab1EKTrt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 May 2011 15:47:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cabarnes@indesign-llc.com, haojian.zhuang@gmail.com, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     w1: add Maxim/Dallas DS2780 Stand-Alone Fuel Gauge IC support
has been removed from the -mm tree.  Its filename was
     w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: w1: add Maxim/Dallas DS2780 Stand-Alone Fuel Gauge IC support
=46rom: Clifton Barnes <cabarnes@indesign-llc.com>

Add support for the Maxim/Dallas DS2780 Stand-Alone Fuel Gauge IC.

Another patch from Haojian Zhuang for this part was recently submitted,
but I believe that this implementation is more consistent with other fu=
el
gauge drivers since it uses the power supply interface.

Signed-off-by: Clifton Barnes <cabarnes@indesign-llc.com>
Tested-by: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/Kconfig          |    7=20
 drivers/power/Makefile         |    1=20
 drivers/power/ds2780_battery.c |  797 +++++++++++++++++++++++++++++++
 drivers/w1/slaves/Kconfig      |   13=20
 drivers/w1/slaves/Makefile     |    1=20
 drivers/w1/slaves/w1_ds2780.c  |  241 +++++++++
 drivers/w1/slaves/w1_ds2780.h  |  132 +++++
 drivers/w1/w1_family.h         |    1=20
 8 files changed, 1193 insertions(+)

diff -puN drivers/power/Kconfig~w1-add-maxim-dallas-ds2780-stand-alone-=
fuel-gauge-ic-support drivers/power/Kconfig
--- a/drivers/power/Kconfig~w1-add-maxim-dallas-ds2780-stand-alone-fuel=
-gauge-ic-support
+++ a/drivers/power/Kconfig
@@ -68,6 +68,13 @@ config BATTERY_DS2760
 	help
 	  Say Y here to enable support for batteries with ds2760 chip.
=20
+config BATTERY_DS2780
+       tristate "DS2780 battery driver"
+       select W1
+       select W1_SLAVE_DS2780
+       help
+         Say Y here to enable support for batteries with ds2780 chip.
+
 config BATTERY_DS2782
 	tristate "DS2782/DS2786 standalone gas-gauge"
 	depends on I2C
diff -puN drivers/power/Makefile~w1-add-maxim-dallas-ds2780-stand-alone=
-fuel-gauge-ic-support drivers/power/Makefile
--- a/drivers/power/Makefile~w1-add-maxim-dallas-ds2780-stand-alone-fue=
l-gauge-ic-support
+++ a/drivers/power/Makefile
@@ -15,6 +15,7 @@ obj-$(CONFIG_WM8350_POWER)	+=3D wm8350_pow
 obj-$(CONFIG_TEST_POWER)	+=3D test_power.o
=20
 obj-$(CONFIG_BATTERY_DS2760)	+=3D ds2760_battery.o
+obj-$(CONFIG_BATTERY_DS2780)   +=3D ds2780_battery.o
 obj-$(CONFIG_BATTERY_DS2782)	+=3D ds2782_battery.o
 obj-$(CONFIG_BATTERY_PMU)	+=3D pmu_battery.o
 obj-$(CONFIG_BATTERY_OLPC)	+=3D olpc_battery.o
diff -puN /dev/null drivers/power/ds2780_battery.c
--- /dev/null
+++ a/drivers/power/ds2780_battery.c
@@ -0,0 +1,797 @@
+/*
+ * 1-wire client/driver for the Maxim/Dallas DS2780 Stand-Alone Fuel G=
auge IC
+ *
+ * Copyright =A9 2010 Indesign, LLC
+ *
+ * Author: Clifton Barnes <cabarnes@indesign-llc.com>
+ *
+ * Based on ds2760_battery and ds2782_battery drivers
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
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
+#define to_ds2780_device_info(x) container_of(x, struct ds2780_device_=
info, bat)
+#define to_power_supply(x)  (struct power_supply*) dev_get_drvdata(x)
+
+/* Current unit measurement in uA for a 1 milli-ohm sense resistor */
+#define DS2780_CURRENT_UNITS   1563
+/* Charge unit measurement in uAh for a 1 milli-ohm sense resistor */
+#define DS2780_CHARGE_UNITS            6250
+/* Number of bytes in user EEPROM space */
+#define DS2780_USER_EEPROM_SIZE                (DS2780_EEPROM_BLOCK0_E=
ND - DS2780_EEPROM_BLOCK0_START + 1)
+/* Number of bytes in parameter EEPROM space */
+#define DS2780_PARAM_EEPROM_SIZE       (DS2780_EEPROM_BLOCK1_END - DS2=
780_EEPROM_BLOCK1_START + 1)
+
+struct ds2780_device_info {
+       struct device *dev;
+       struct power_supply bat;
+       struct device *w1_dev;
+};
+
+enum current_types {
+       CURRENT_NOW,
+       CURRENT_AVG,
+};
+
+static const char model[] =3D "DS2780";
+static const char manufacturer[] =3D "Maxim/Dallas";
+
+/* Set sense resistor value in mhos */
+static int ds2780_set_sense_register(struct ds2780_device_info *dev_in=
fo, u8 conductance)
+{
+       int ret;
+
+       ret =3D w1_ds2780_write(dev_info->w1_dev, &conductance, DS2780_=
RSNSP_REG, sizeof(char));
+       if (ret < 0)
+               return ret;
+
+       ret =3D w1_ds2780_store_eeprom(dev_info->w1_dev, DS2780_RSNSP_R=
EG);
+       if (ret < 0)
+               return ret;
+
+       ret =3D w1_ds2780_recall_eeprom(dev_info->w1_dev, DS2780_RSNSP_=
REG);
+       if (ret < 0)
+               return ret;
+
+       return 0;
+}
+
+/* Get RSGAIN value from 0 to 1.999 in steps of 0.001 */
+static int ds2780_get_rsgain_register(struct ds2780_device_info *dev_i=
nfo, u16 *rsgain)
+{
+       int ret;
+       char bytes[2];
+
+       ret =3D w1_ds2780_read(dev_info->w1_dev, bytes, DS2780_RSGAIN_M=
SB_REG, sizeof(char));
+       if (ret < 0)
+               return ret;
+
+       ret =3D w1_ds2780_read(dev_info->w1_dev, bytes + 1, DS2780_RSGA=
IN_LSB_REG, sizeof(char));
+       if (ret < 0)
+               return ret;
+
+       *rsgain =3D (bytes[0] << 8) | bytes[1];
+       return 0;
+}
+
+/* Set RSGAIN value from 0 to 1.999 in steps of 0.001 */
+static int ds2780_set_rsgain_register(struct ds2780_device_info *dev_i=
nfo, u16 rsgain)
+{
+       int ret;
+       char bytes[] =3D {rsgain >> 8, rsgain & 0xFF};
+
+       ret =3D w1_ds2780_write(dev_info->w1_dev, bytes, DS2780_RSGAIN_=
MSB_REG, sizeof(char));
+       if (ret < 0)
+               return ret;
+
+       ret =3D w1_ds2780_write(dev_info->w1_dev, bytes + 1, DS2780_RSG=
AIN_LSB_REG, sizeof(char));
+       if (ret < 0)
+               return ret;
+
+       ret =3D w1_ds2780_store_eeprom(dev_info->w1_dev, DS2780_RSGAIN_=
MSB_REG);
+       if (ret < 0)
+               return ret;
+
+       ret =3D w1_ds2780_recall_eeprom(dev_info->w1_dev, DS2780_RSGAIN=
_MSB_REG);
+       if (ret < 0)
+               return ret;
+
+       return 0;
+}
+
+static int ds2780_get_voltage(struct ds2780_device_info *dev_info, int=
 *voltage_uV)
+{
+       char raw[2];
+       s16 voltage_raw;
+       int ret;
+
+       /* The voltage value is located in 10 bits across the voltage M=
SB and LSB registers in two's compliment form
+          Sign bit of the voltage value is in bit 7 of the voltage MSB=
 register
+          Bits 9 - 3 of the voltage value are in bits 6 - 0 of the vol=
tage MSB register
+          Bits 2 - 0 of the voltage value are in bits 7 - 5 of the vol=
tage LSB register
+       */
+       ret =3D w1_ds2780_read(dev_info->w1_dev, raw, DS2780_VOLT_MSB_R=
EG, sizeof(char));
+       if (ret < 0)
+               return ret;
+
+       ret =3D w1_ds2780_read(dev_info->w1_dev, raw + 1, DS2780_VOLT_L=
SB_REG, sizeof(char));
+       if (ret < 0)
+               return ret;
+
+       voltage_raw =3D (raw[0] << 3) | (raw[1] >> 5);
+       /* DS2780 reports voltage in units of 4.88mV, but the battery c=
lass
+        * reports in units of uV, so convert by multiplying by 4880. *=
/
+       *voltage_uV =3D voltage_raw * 4880;
+       return 0;
+}
+
+static int ds2780_get_temperature(struct ds2780_device_info *dev_info,=
 int *temperature)
+{
+       char raw[2];
+       s16 temperature_raw;
+       int ret;
+
+       /* The temperature value is located in 10 bits across the tempe=
rature MSB and LSB registers in two's compliment form
+          Sign bit of the temperature value is in bit 7 of the tempera=
ture MSB register
+          Bits 9 - 3 of the temperature value are in bits 6 - 0 of the=
 temperature MSB register
+          Bits 2 - 0 of the temperature value are in bits 7 - 5 of the=
 temperature LSB register
+       */
+       ret =3D w1_ds2780_read(dev_info->w1_dev, raw, DS2780_TEMP_MSB_R=
EG, sizeof(char));
+       if (ret < 0)
+               return ret;
+
+       ret =3D w1_ds2780_read(dev_info->w1_dev, raw + 1, DS2780_TEMP_L=
SB_REG, sizeof(char));
+       if (ret < 0)
+               return ret;
+
+       temperature_raw =3D (((signed char)raw[0] << 3)) | (raw[1] >> 5=
);
+       /* DS2780 reports temperature in signed units of 0.125 =B0C, bu=
t the
+        * battery class reports in units of 1/10 =B0C, so we convert b=
y
+        * multiplying by .125 * 10 =3D 1.25. */
+       *temperature =3D temperature_raw + (temperature_raw / 4);
+       return 0;
+}
+
+static int ds2780_get_current(struct ds2780_device_info *dev_info, enu=
m current_types type, int *current_uA)
+{
+       int ret;
+       char raw[2];
+       s16 current_raw;
+       int sense_res;
+       u8 sense_res_raw;
+       u8 reg_msb;
+       u8 reg_lsb;
+
+       /*
+        * The units of measurement for current are dependent on the va=
lue of
+        * the sense resistor.
+        */
+       ret =3D w1_ds2780_read(dev_info->w1_dev, &sense_res_raw, DS2780=
_RSNSP_REG, sizeof(u8));
+       if (ret < 0)
+               return ret;
+
+       if (sense_res_raw =3D=3D 0) {
+               dev_err(dev_info->dev, "sense resistor value is 0\n");
+               return -ENXIO;
+       }
+       sense_res =3D 1000 / sense_res_raw;
+
+       if (type =3D=3D CURRENT_NOW) {
+               reg_msb =3D DS2780_CURRENT_MSB_REG;
+               reg_lsb =3D DS2780_CURRENT_LSB_REG;
+       }
+       else if (type =3D=3D CURRENT_AVG) {
+               reg_msb =3D DS2780_IAVG_MSB_REG;
+               reg_lsb =3D DS2780_IAVG_LSB_REG;
+       }
+       else {
+               return -EINVAL;
+       }
+
+       /* The current value is located in 16 bits across the current M=
SB and LSB registers in two's compliment form
+          Sign bit of the current value is in bit 7 of the current MSB=
 register
+          Bits 14 - 8 of the current value are in bits 6 - 0 of the cu=
rrent MSB register
+          Bits 7 - 0 of the current value are in bits 7 - 0 of the cur=
rent LSB register
+       */
+       ret =3D w1_ds2780_read(dev_info->w1_dev, raw, reg_msb, sizeof(c=
har));
+       if (ret < 0)
+               return ret;
+
+       ret =3D w1_ds2780_read(dev_info->w1_dev, raw + 1, reg_lsb, size=
of(char));
+       if (ret < 0)
+               return ret;
+
+       current_raw =3D ((signed char)raw[0] << 8) | raw[1];
+       *current_uA =3D current_raw * (DS2780_CURRENT_UNITS / sense_res=
);
+       return 0;
+}
+
+static int ds2780_get_accumulated_current(struct ds2780_device_info *d=
ev_info, int *accumulated_current)
+{
+       char raw[2];
+       s16 current_raw;
+       int sense_res;
+       u8 sense_res_raw;
+       int ret;
+
+       /*
+        * The units of measurement for accumulated current are depende=
nt on the value of
+        * the sense resistor.
+        */
+       ret =3D w1_ds2780_read(dev_info->w1_dev, &sense_res_raw, DS2780=
_RSNSP_REG, sizeof(u8));
+       if (ret < 0)
+               return ret;
+
+       if (sense_res_raw =3D=3D 0) {
+               dev_err(dev_info->dev, "sense resistor value is 0\n");
+               return -ENXIO;
+       }
+       sense_res =3D 1000 / sense_res_raw;
+
+       /* The ACR value is located in 16 bits across the ACR MSB and L=
SB registers
+          Bits 15 - 8 of the ACR value are in bits 7 - 0 of the ACR MS=
B register
+          Bits 7 - 0 of the ACR value are in bits 7 - 0 of the ACR LSB=
 register
+       */
+       ret =3D w1_ds2780_read(dev_info->w1_dev, raw, DS2780_ACR_MSB_RE=
G, sizeof(char));
+       if (ret < 0)
+               return ret;
+
+       ret =3D w1_ds2780_read(dev_info->w1_dev, raw + 1, DS2780_ACR_LS=
B_REG, sizeof(char));
+       if (ret < 0)
+               return ret;
+
+       current_raw =3D (raw[0] << 8) | raw[1];
+       *accumulated_current =3D current_raw * (DS2780_CHARGE_UNITS / s=
ense_res);
+       return 0;
+}
+
+static int ds2780_get_capacity(struct ds2780_device_info *dev_info, in=
t *capacity)
+{
+       int ret;
+       u8 raw;
+
+       ret =3D w1_ds2780_read(dev_info->w1_dev, &raw, DS2780_RARC_REG,=
 sizeof(u8));
+       if (ret < 0)
+               return ret;
+
+       *capacity =3D raw;
+       return raw;
+}
+
+static int ds2780_get_status(struct ds2780_device_info *dev_info, int =
*status)
+{
+       int ret;
+       int current_uA;
+       int capacity;
+
+       ret =3D ds2780_get_current(dev_info, CURRENT_NOW, &current_uA);
+       if (ret < 0)
+               return ret;
+
+       ret =3D ds2780_get_capacity(dev_info, &capacity);
+       if (ret < 0)
+               return ret;
+
+       if (capacity =3D=3D 100)
+               *status =3D POWER_SUPPLY_STATUS_FULL;
+       else if (current_uA =3D=3D 0)
+               *status =3D POWER_SUPPLY_STATUS_NOT_CHARGING;
+       else if (current_uA < 0)
+               *status =3D POWER_SUPPLY_STATUS_DISCHARGING;
+       else
+               *status =3D POWER_SUPPLY_STATUS_CHARGING;
+
+       return 0;
+}
+
+static int ds2780_get_charge_now(struct ds2780_device_info *dev_info, =
int *charge_now)
+{
+       char raw[2];
+       u16 charge_raw;
+       int ret;
+
+       /* The RAAC value is located in 16 bits across the RAAC MSB and=
 LSB registers
+          Bits 15 - 8 of the RAAC value are in bits 7 - 0 of the RAAC =
MSB register
+          Bits 7 - 0 of the RAAC value are in bits 7 - 0 of the RAAC L=
SB register
+       */
+       ret =3D w1_ds2780_read(dev_info->w1_dev, raw, DS2780_RAAC_MSB_R=
EG, sizeof(char));
+       if (ret < 0)
+               return ret;
+
+       ret =3D w1_ds2780_read(dev_info->w1_dev, raw + 1, DS2780_RAAC_L=
SB_REG, sizeof(char));
+       if (ret < 0)
+               return ret;
+
+       charge_raw =3D (raw[0] << 8) | raw[1];
+       *charge_now =3D charge_raw * 1600;
+
+       return 0;
+
+}
+
+static int ds2780_get_control_register(struct ds2780_device_info *dev_=
info, u8 *control_reg)
+{
+       u8 reg;
+       int ret;
+
+       ret =3D w1_ds2780_read(dev_info->w1_dev, &reg, DS2780_CONTROL_R=
EG, sizeof(u8));
+       if (ret < 0)
+               return ret;
+
+       *control_reg =3D reg;
+       return 0;
+}
+
+static int ds2780_set_control_register(struct ds2780_device_info *dev_=
info, u8 control_reg)
+{
+       int ret;
+
+       ret =3D w1_ds2780_write(dev_info->w1_dev, &control_reg, DS2780_=
CONTROL_REG, sizeof(u8));
+       if (ret < 0)
+               return ret;
+
+       ret =3D w1_ds2780_store_eeprom(dev_info->w1_dev, DS2780_CONTROL=
_REG);
+       if (ret < 0)
+               return ret;
+
+       ret =3D w1_ds2780_recall_eeprom(dev_info->w1_dev, DS2780_CONTRO=
L_REG);
+       if (ret < 0)
+               return ret;
+
+       return 0;
+}
+
+static int ds2780_battery_get_property(struct power_supply *psy,
+                                          enum power_supply_property p=
sp,
+                                          union power_supply_propval *=
val)
+{
+       int ret =3D 0;
+       struct ds2780_device_info *dev_info =3D to_ds2780_device_info(p=
sy);
+
+       switch (psp) {
+       case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+               ret =3D ds2780_get_voltage(dev_info, &val->intval);
+               break;
+
+       case POWER_SUPPLY_PROP_TEMP:
+               ret =3D ds2780_get_temperature(dev_info, &val->intval);
+               break;
+
+       case POWER_SUPPLY_PROP_MODEL_NAME:
+               val->strval =3D model;
+               break;
+
+       case POWER_SUPPLY_PROP_MANUFACTURER:
+               val->strval =3D manufacturer;
+               break;
+
+       case POWER_SUPPLY_PROP_CURRENT_NOW:
+               ret =3D ds2780_get_current(dev_info, CURRENT_NOW, &val-=
>intval);
+               break;
+
+       case POWER_SUPPLY_PROP_CURRENT_AVG:
+               ret =3D ds2780_get_current(dev_info, CURRENT_AVG, &val-=
>intval);
+               break;
+
+       case POWER_SUPPLY_PROP_STATUS:
+               ret =3D ds2780_get_status(dev_info, &val->intval);
+               break;
+
+       case POWER_SUPPLY_PROP_CAPACITY:
+               ret =3D ds2780_get_capacity(dev_info, &val->intval);
+               break;
+
+       case POWER_SUPPLY_PROP_CHARGE_COUNTER:
+               ret =3D ds2780_get_accumulated_current(dev_info, &val->=
intval);
+               break;
+
+       case POWER_SUPPLY_PROP_CHARGE_NOW:
+               ret =3D ds2780_get_charge_now(dev_info, &val->intval);
+               break;
+
+       default:
+               ret =3D -EINVAL;
+       }
+
+       return ret;
+}
+
+static enum power_supply_property ds2780_battery_props[] =3D {
+       POWER_SUPPLY_PROP_STATUS,
+       POWER_SUPPLY_PROP_VOLTAGE_NOW,
+       POWER_SUPPLY_PROP_TEMP,
+       POWER_SUPPLY_PROP_MODEL_NAME,
+       POWER_SUPPLY_PROP_MANUFACTURER,
+       POWER_SUPPLY_PROP_CURRENT_NOW,
+       POWER_SUPPLY_PROP_CURRENT_AVG,
+       POWER_SUPPLY_PROP_CAPACITY,
+       POWER_SUPPLY_PROP_CHARGE_COUNTER,
+       POWER_SUPPLY_PROP_CHARGE_NOW,
+};
+
+static ssize_t ds2780_get_pmod_enabled(struct device *dev,
+                                        struct device_attribute *attr,=
 char *buf)
+{
+       int ret;
+       u8 control_reg;
+       struct power_supply *psy =3D to_power_supply(dev);
+       struct ds2780_device_info *dev_info =3D to_ds2780_device_info(p=
sy);
+
+       /* Get power mode */
+       ret =3D ds2780_get_control_register(dev_info, &control_reg);
+       if (ret < 0)
+               return ret;
+
+       if (control_reg & DS2780_CONTROL_REG_PMOD)
+               ret =3D sprintf(buf, "1\n");
+       else
+               ret =3D sprintf(buf, "0\n");
+
+       return ret;
+}
+
+static ssize_t ds2780_set_pmod_enabled(struct device *dev,
+                                        struct device_attribute *attr,=
 const char *buf, size_t count)
+{
+       int ret;
+       u8 control_reg;
+       char *endp;
+       u8 new_setting;
+       struct power_supply *psy =3D to_power_supply(dev);
+       struct ds2780_device_info *dev_info =3D to_ds2780_device_info(p=
sy);
+
+       /* Set power mode */
+       ret =3D ds2780_get_control_register(dev_info, &control_reg);
+       if (ret < 0)
+               return ret;
+
+       new_setting =3D (u8)simple_strtoul(buf, &endp, 10);
+       if ((new_setting !=3D 0) && (new_setting !=3D 1)) {
+               dev_err(dev_info->dev, "Invalid pmod setting (0 or 1)\n=
");
+               return -EINVAL;
+       }
+
+       if (new_setting)
+               control_reg |=3D DS2780_CONTROL_REG_PMOD;
+       else
+               control_reg &=3D ~DS2780_CONTROL_REG_PMOD;
+
+       ret =3D ds2780_set_control_register(dev_info, control_reg);
+       if (ret < 0)
+               return ret;
+
+       return count;
+
+}
+
+static ssize_t ds2780_get_sense_resistor_value(struct device *dev,
+                                        struct device_attribute *attr,=
 char *buf)
+{
+       int ret;
+       u8 sense_resistor;
+       struct power_supply *psy =3D to_power_supply(dev);
+       struct ds2780_device_info *dev_info =3D to_ds2780_device_info(p=
sy);
+
+       ret =3D w1_ds2780_read(dev_info->w1_dev, &sense_resistor, DS278=
0_RSNSP_REG, sizeof(u8));
+       if (ret < 0)
+               return ret;
+
+       ret =3D sprintf(buf, "%i\n", sense_resistor);
+       return ret;
+}
+
+static ssize_t ds2780_set_sense_resistor_value(struct device *dev,
+                                        struct device_attribute *attr,=
 const char *buf, size_t count)
+{
+       int ret;
+       char *endp;
+       u8 new_setting;
+       struct power_supply *psy =3D to_power_supply(dev);
+       struct ds2780_device_info *dev_info =3D to_ds2780_device_info(p=
sy);
+
+       new_setting =3D (u8)simple_strtoul(buf, &endp, 10);
+       ret =3D ds2780_set_sense_register(dev_info, new_setting);
+       if (ret < 0)
+               return ret;
+
+       return count;
+}
+
+static ssize_t ds2780_get_rsgain_setting(struct device *dev,
+                                        struct device_attribute *attr,=
 char *buf)
+{
+       int ret;
+       u16 rsgain;
+       struct power_supply *psy =3D to_power_supply(dev);
+       struct ds2780_device_info *dev_info =3D to_ds2780_device_info(p=
sy);
+
+       ret =3D ds2780_get_rsgain_register(dev_info, &rsgain);
+       if (ret < 0)
+               return ret;
+
+       ret =3D sprintf(buf, "%d\n", rsgain);
+       return ret;
+}
+
+static ssize_t ds2780_set_rsgain_setting(struct device *dev,
+                                        struct device_attribute *attr,=
 const char *buf, size_t count)
+{
+       int ret;
+       char *endp;
+       u16 new_setting;
+       struct power_supply *psy =3D to_power_supply(dev);
+       struct ds2780_device_info *dev_info =3D to_ds2780_device_info(p=
sy);
+
+       new_setting =3D (u16)simple_strtoul(buf, &endp, 10);
+       /* Gain can only be from 0 to 1.999 in steps of .001 */
+       if (new_setting > 1999) {
+               dev_err(dev_info->dev, "Invalid rsgain setting (0 - 199=
9)\n");
+               return -EINVAL;
+       }
+
+       ret =3D ds2780_set_rsgain_register(dev_info, new_setting);
+       if (ret < 0)
+               return ret;
+
+       return count;
+}
+
+static ssize_t ds2780_get_user_eeprom(struct device *dev,
+                                        struct device_attribute *attr,=
 char *buf)
+{
+       int ret;
+       struct power_supply *psy =3D to_power_supply(dev);
+       struct ds2780_device_info *dev_info =3D to_ds2780_device_info(p=
sy);
+
+       ret =3D w1_ds2780_read(dev_info->w1_dev, buf, DS2780_EEPROM_BLO=
CK0_START, DS2780_USER_EEPROM_SIZE);
+       if (ret < 0)
+               return ret;
+
+       return DS2780_USER_EEPROM_SIZE;
+}
+
+static ssize_t ds2780_set_user_eeprom(struct device *dev,
+                                        struct device_attribute *attr,=
 const char *buf, size_t count)
+{
+       int ret;
+       struct power_supply *psy =3D to_power_supply(dev);
+       struct ds2780_device_info *dev_info =3D to_ds2780_device_info(p=
sy);
+
+       /* Only write as much as there is user EEPROM to not overwrite =
parameter EEPROM */
+       if (count > DS2780_USER_EEPROM_SIZE)
+               count =3D DS2780_USER_EEPROM_SIZE;
+
+       ret =3D w1_ds2780_write(dev_info->w1_dev, (char*)buf, DS2780_EE=
PROM_BLOCK0_START, count);
+       if (ret < 0)
+               return ret;
+
+       ret =3D w1_ds2780_store_eeprom(dev_info->w1_dev, DS2780_EEPROM_=
BLOCK0_START);
+       if (ret < 0)
+               return ret;
+
+       ret =3D w1_ds2780_recall_eeprom(dev_info->w1_dev, DS2780_EEPROM=
_BLOCK0_START);
+       if (ret < 0)
+               return ret;
+
+       return count;
+}
+
+static ssize_t ds2780_get_param_eeprom(struct device *dev,
+                                        struct device_attribute *attr,=
 char *buf)
+{
+       int ret;
+       struct power_supply *psy =3D to_power_supply(dev);
+       struct ds2780_device_info *dev_info =3D to_ds2780_device_info(p=
sy);
+
+       ret =3D w1_ds2780_read(dev_info->w1_dev, buf, DS2780_EEPROM_BLO=
CK1_START, DS2780_PARAM_EEPROM_SIZE);
+       if (ret < 0)
+               return ret;
+
+       return DS2780_PARAM_EEPROM_SIZE;
+}
+
+static ssize_t ds2780_set_param_eeprom(struct device *dev,
+                                        struct device_attribute *attr,=
 const char *buf, size_t count)
+{
+       int ret;
+       struct power_supply *psy =3D to_power_supply(dev);
+       struct ds2780_device_info *dev_info =3D to_ds2780_device_info(p=
sy);
+
+       /* Only write as much as there is parameter EEPROM */
+       if (count > DS2780_PARAM_EEPROM_SIZE)
+               count =3D DS2780_PARAM_EEPROM_SIZE;
+
+       ret =3D w1_ds2780_write(dev_info->w1_dev, (char*)buf, DS2780_EE=
PROM_BLOCK1_START, count);
+       if (ret < 0)
+               return ret;
+
+       ret =3D w1_ds2780_store_eeprom(dev_info->w1_dev, DS2780_EEPROM_=
BLOCK1_START);
+       if (ret < 0)
+               return ret;
+
+       ret =3D w1_ds2780_recall_eeprom(dev_info->w1_dev, DS2780_EEPROM=
_BLOCK1_START);
+       if (ret < 0)
+               return ret;
+
+       return count;
+}
+
+static ssize_t ds2780_get_pio_pin(struct device *dev,
+                                        struct device_attribute *attr,=
 char *buf)
+{
+       int ret;
+       u8 sfr;
+       struct power_supply *psy =3D to_power_supply(dev);
+       struct ds2780_device_info *dev_info =3D to_ds2780_device_info(p=
sy);
+
+       ret =3D w1_ds2780_read(dev_info->w1_dev, &sfr, DS2780_SFR_REG, =
sizeof(u8));
+       if (ret < 0)
+               return ret;
+
+       ret =3D sprintf(buf, "%d\n", sfr & DS2780_SFR_REG_PIOSC);
+       return ret;
+}
+
+static ssize_t ds2780_set_pio_pin(struct device *dev,
+                                        struct device_attribute *attr,=
 const char *buf, size_t count)
+{
+       int ret;
+       u8 new_setting;
+       char *endp;
+       struct power_supply *psy =3D to_power_supply(dev);
+       struct ds2780_device_info *dev_info =3D to_ds2780_device_info(p=
sy);
+
+       new_setting =3D (u8)simple_strtoul(buf, &endp, 10);
+       if ((new_setting !=3D 0) && (new_setting !=3D 1)) {
+               dev_err(dev_info->dev, "Invalid pio_pin setting (0 or 1=
)\n");
+               return -EINVAL;
+       }
+
+       ret =3D w1_ds2780_write(dev_info->w1_dev, &new_setting, DS2780_=
SFR_REG, sizeof(u8));
+       if (ret < 0)
+               return ret;
+
+       return count;
+}
+
+
+static DEVICE_ATTR(pmod_enabled, 0644, ds2780_get_pmod_enabled, ds2780=
_set_pmod_enabled);
+static DEVICE_ATTR(sense_resistor_value, 0644, ds2780_get_sense_resist=
or_value, ds2780_set_sense_resistor_value);
+static DEVICE_ATTR(rsgain_setting, 0644, ds2780_get_rsgain_setting, ds=
2780_set_rsgain_setting);
+static DEVICE_ATTR(user_eeprom, 0644, ds2780_get_user_eeprom, ds2780_s=
et_user_eeprom);
+static DEVICE_ATTR(param_eeprom, 0644, ds2780_get_param_eeprom, ds2780=
_set_param_eeprom);
+static DEVICE_ATTR(pio_pin, 0644, ds2780_get_pio_pin, ds2780_set_pio_p=
in);
+
+
+static struct attribute *ds2780_attributes[] =3D {
+       &dev_attr_pmod_enabled.attr,
+       &dev_attr_sense_resistor_value.attr,
+       &dev_attr_rsgain_setting.attr,
+       &dev_attr_user_eeprom.attr,
+       &dev_attr_param_eeprom.attr,
+       &dev_attr_pio_pin.attr,
+       NULL
+};
+
+static const struct attribute_group ds2780_attr_group =3D {
+       .attrs =3D ds2780_attributes,
+};
+
+static int ds2780_battery_probe(struct platform_device *pdev)
+{
+       int ret =3D 0;
+       struct ds2780_device_info *dev_info;
+
+       dev_info =3D kzalloc(sizeof(*dev_info), GFP_KERNEL);
+       if (!dev_info) {
+               ret =3D -ENOMEM;
+               goto dev_info_alloc_failed;
+       }
+
+       platform_set_drvdata(pdev, dev_info);
+
+       dev_info->dev                   =3D &pdev->dev;
+       dev_info->w1_dev                =3D pdev->dev.parent;
+       dev_info->bat.name              =3D dev_name(&pdev->dev);
+       dev_info->bat.type              =3D POWER_SUPPLY_TYPE_BATTERY;
+       dev_info->bat.properties        =3D ds2780_battery_props;
+       dev_info->bat.num_properties    =3D ARRAY_SIZE(ds2780_battery_p=
rops);
+       dev_info->bat.get_property      =3D ds2780_battery_get_property=
;
+
+       ret =3D power_supply_register(&pdev->dev, &dev_info->bat);
+       if (ret) {
+               dev_err(dev_info->dev, "failed to register battery\n");
+               goto batt_failed;
+       }
+
+       ret =3D sysfs_create_group(&dev_info->bat.dev->kobj, &ds2780_at=
tr_group);
+       if (ret) {
+               printk(KERN_INFO "ds2780: failed to create sysfs group\=
n");
+               goto fail_sysfs;
+       }
+
+       return 0;
+
+fail_sysfs:
+       power_supply_unregister(&dev_info->bat);
+batt_failed:
+       kfree(dev_info);
+dev_info_alloc_failed:
+       return ret;
+}
+
+static int ds2780_battery_remove(struct platform_device *pdev)
+{
+       struct ds2780_device_info *dev_info =3D platform_get_drvdata(pd=
ev);
+
+       /* remove attributes */
+       sysfs_remove_group(&dev_info->bat.dev->kobj, &ds2780_attr_group=
);
+
+       power_supply_unregister(&dev_info->bat);
+
+       kfree(dev_info);
+       return 0;
+}
+
+#ifdef CONFIG_PM
+
+static int ds2780_battery_suspend(struct platform_device *pdev,
+                                 pm_message_t state)
+{
+       return 0;
+}
+
+static int ds2780_battery_resume(struct platform_device *pdev)
+{
+       return 0;
+}
+
+#else
+
+#define ds2780_battery_suspend NULL
+#define ds2780_battery_resume NULL
+
+#endif /* CONFIG_PM */
+
+MODULE_ALIAS("platform:ds2780-battery");
+
+static struct platform_driver ds2780_battery_driver =3D {
+       .driver =3D {
+               .name =3D "ds2780-battery",
+       },
+       .probe    =3D ds2780_battery_probe,
+       .remove   =3D ds2780_battery_remove,
+       .suspend  =3D ds2780_battery_suspend,
+       .resume   =3D ds2780_battery_resume,
+};
+
+static int __init ds2780_battery_init(void)
+{
+       return platform_driver_register(&ds2780_battery_driver);
+}
+
+static void __exit ds2780_battery_exit(void)
+{
+       platform_driver_unregister(&ds2780_battery_driver);
+}
+
+module_init(ds2780_battery_init);
+module_exit(ds2780_battery_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Clifton Barnes <cabarnes@indesign-llc.com>");
+MODULE_DESCRIPTION("Maxim/Dallas DS2780 Stand-Alone Fuel Gauage IC dri=
ver");
diff -puN drivers/w1/slaves/Kconfig~w1-add-maxim-dallas-ds2780-stand-al=
one-fuel-gauge-ic-support drivers/w1/slaves/Kconfig
--- a/drivers/w1/slaves/Kconfig~w1-add-maxim-dallas-ds2780-stand-alone-=
fuel-gauge-ic-support
+++ a/drivers/w1/slaves/Kconfig
@@ -68,6 +68,19 @@ config W1_SLAVE_DS2760
=20
 	  If you are unsure, say N.
=20
+config W1_SLAVE_DS2780
+       tristate "Dallas 2780 battery monitor chip"
+       depends on W1
+       help
+         If you enable this you will have the DS2780 battery monitor
+         chip support.
+
+         The battery monitor chip is used in many batteries/devices
+         as the one who is responsible for charging/discharging/monito=
ring
+         Li+ batteries.
+
+         If you are unsure, say N.
+
 config W1_SLAVE_BQ27000
 	tristate "BQ27000 slave support"
 	depends on W1
diff -puN drivers/w1/slaves/Makefile~w1-add-maxim-dallas-ds2780-stand-a=
lone-fuel-gauge-ic-support drivers/w1/slaves/Makefile
--- a/drivers/w1/slaves/Makefile~w1-add-maxim-dallas-ds2780-stand-alone=
-fuel-gauge-ic-support
+++ a/drivers/w1/slaves/Makefile
@@ -9,4 +9,5 @@ obj-$(CONFIG_W1_SLAVE_DS2423)	+=3D w1_ds24
 obj-$(CONFIG_W1_SLAVE_DS2431)	+=3D w1_ds2431.o
 obj-$(CONFIG_W1_SLAVE_DS2433)	+=3D w1_ds2433.o
 obj-$(CONFIG_W1_SLAVE_DS2760)	+=3D w1_ds2760.o
+obj-$(CONFIG_W1_SLAVE_DS2780)  +=3D w1_ds2780.o
 obj-$(CONFIG_W1_SLAVE_BQ27000)	+=3D w1_bq27000.o
diff -puN /dev/null drivers/w1/slaves/w1_ds2780.c
--- /dev/null
+++ a/drivers/w1/slaves/w1_ds2780.c
@@ -0,0 +1,241 @@
+/*
+ * 1-Wire implementation for the ds2780 chip
+ *
+ * Copyright =A9 2010 Indesign, LLC
+ *
+ * Author: Clifton Barnes <cabarnes@indesign-llc.com>
+ *
+ * Based on w1-ds2760 driver
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
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
+static int w1_ds2780_io(struct device *dev, char *buf, int addr, size_=
t count,
+                       int io)
+{
+       struct w1_slave *sl =3D container_of(dev, struct w1_slave, dev)=
;
+
+       if (!dev)
+               return -ENODEV;
+
+       mutex_lock(&sl->master->mutex);
+
+       if (addr > DS2780_DATA_SIZE || addr < 0) {
+               count =3D 0;
+               goto out;
+       }
+       if (addr + count > DS2780_DATA_SIZE)
+               count =3D DS2780_DATA_SIZE - addr;
+
+       if (!w1_reset_select_slave(sl)) {
+               if (!io) {
+                       w1_write_8(sl->master, W1_DS2780_READ_DATA);
+                       w1_write_8(sl->master, addr);
+                       count =3D w1_read_block(sl->master, buf, count)=
;
+               } else {
+                       w1_write_8(sl->master, W1_DS2780_WRITE_DATA);
+                       w1_write_8(sl->master, addr);
+                       w1_write_block(sl->master, buf, count);
+                       /* XXX w1_write_block returns void, not n_writt=
en */
+               }
+       }
+
+out:
+       mutex_unlock(&sl->master->mutex);
+
+       return count;
+}
+
+int w1_ds2780_read(struct device *dev, char *buf, int addr, size_t cou=
nt)
+{
+       return w1_ds2780_io(dev, buf, addr, count, 0);
+}
+
+int w1_ds2780_write(struct device *dev, char *buf, int addr, size_t co=
unt)
+{
+       return w1_ds2780_io(dev, buf, addr, count, 1);
+}
+
+static int w1_ds2780_eeprom_cmd(struct device *dev, int addr, int cmd)
+{
+       struct w1_slave *sl =3D container_of(dev, struct w1_slave, dev)=
;
+
+       if (!dev)
+               return -EINVAL;
+
+       mutex_lock(&sl->master->mutex);
+
+       if (w1_reset_select_slave(sl) =3D=3D 0) {
+               w1_write_8(sl->master, cmd);
+               w1_write_8(sl->master, addr);
+       }
+
+       mutex_unlock(&sl->master->mutex);
+       return 0;
+}
+
+int w1_ds2780_store_eeprom(struct device *dev, int addr)
+{
+       return w1_ds2780_eeprom_cmd(dev, addr, W1_DS2780_COPY_DATA);
+}
+
+int w1_ds2780_recall_eeprom(struct device *dev, int addr)
+{
+       return w1_ds2780_eeprom_cmd(dev, addr, W1_DS2780_RECALL_DATA);
+}
+
+static ssize_t w1_ds2780_read_bin(struct kobject *kobj,
+                                 struct bin_attribute *bin_attr,
+                                 char *buf, loff_t off, size_t count)
+{
+       struct device *dev =3D container_of(kobj, struct device, kobj);
+       return w1_ds2780_read(dev, buf, off, count);
+}
+
+static struct bin_attribute w1_ds2780_bin_attr =3D {
+       .attr =3D {
+               .name =3D "w1_slave",
+               .mode =3D S_IRUGO,
+       },
+       .size =3D DS2780_DATA_SIZE,
+       .read =3D w1_ds2780_read_bin,
+};
+
+static DEFINE_IDR(bat_idr);
+static DEFINE_MUTEX(bat_idr_lock);
+
+static int new_bat_id(void)
+{
+       int ret;
+
+       while (1) {
+               int id;
+
+               ret =3D idr_pre_get(&bat_idr, GFP_KERNEL);
+               if (ret =3D=3D 0)
+                       return -ENOMEM;
+
+               mutex_lock(&bat_idr_lock);
+               ret =3D idr_get_new(&bat_idr, NULL, &id);
+               mutex_unlock(&bat_idr_lock);
+
+               if (ret =3D=3D 0) {
+                       ret =3D id & MAX_ID_MASK;
+                       break;
+               } else if (ret =3D=3D -EAGAIN) {
+                       continue;
+               } else {
+                       break;
+               }
+       }
+
+       return ret;
+}
+
+static void release_bat_id(int id)
+{
+       mutex_lock(&bat_idr_lock);
+       idr_remove(&bat_idr, id);
+       mutex_unlock(&bat_idr_lock);
+}
+
+static int w1_ds2780_add_slave(struct w1_slave *sl)
+{
+       int ret;
+       int id;
+       struct platform_device *pdev;
+
+       id =3D new_bat_id();
+       if (id < 0) {
+               ret =3D id;
+               goto noid;
+       }
+
+       pdev =3D platform_device_alloc("ds2780-battery", id);
+       if (!pdev) {
+               ret =3D -ENOMEM;
+               goto pdev_alloc_failed;
+       }
+       pdev->dev.parent =3D &sl->dev;
+
+       ret =3D platform_device_add(pdev);
+       if (ret)
+               goto pdev_add_failed;
+
+       ret =3D sysfs_create_bin_file(&sl->dev.kobj, &w1_ds2780_bin_att=
r);
+       if (ret)
+               goto bin_attr_failed;
+
+       dev_set_drvdata(&sl->dev, pdev);
+
+       goto success;
+
+bin_attr_failed:
+pdev_add_failed:
+       platform_device_unregister(pdev);
+pdev_alloc_failed:
+       release_bat_id(id);
+noid:
+success:
+       return ret;
+}
+
+static void w1_ds2780_remove_slave(struct w1_slave *sl)
+{
+       struct platform_device *pdev =3D dev_get_drvdata(&sl->dev);
+       int id =3D pdev->id;
+
+       platform_device_unregister(pdev);
+       release_bat_id(id);
+       sysfs_remove_bin_file(&sl->dev.kobj, &w1_ds2780_bin_attr);
+}
+
+static struct w1_family_ops w1_ds2780_fops =3D {
+       .add_slave    =3D w1_ds2780_add_slave,
+       .remove_slave =3D w1_ds2780_remove_slave,
+};
+
+static struct w1_family w1_ds2780_family =3D {
+       .fid =3D W1_FAMILY_DS2780,
+       .fops =3D &w1_ds2780_fops,
+};
+
+static int __init w1_ds2780_init(void)
+{
+       idr_init(&bat_idr);
+       return w1_register_family(&w1_ds2780_family);
+}
+
+static void __exit w1_ds2780_exit(void)
+{
+       w1_unregister_family(&w1_ds2780_family);
+       idr_destroy(&bat_idr);
+}
+
+EXPORT_SYMBOL(w1_ds2780_read);
+EXPORT_SYMBOL(w1_ds2780_write);
+EXPORT_SYMBOL(w1_ds2780_store_eeprom);
+EXPORT_SYMBOL(w1_ds2780_recall_eeprom);
+
+module_init(w1_ds2780_init);
+module_exit(w1_ds2780_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Clifton Barnes <cabarnes@indesign-llc.com>");
+MODULE_DESCRIPTION("1-wire Driver for Maxim/Dallas DS2780 Stand-Alone =
=46uel Gauage IC");
diff -puN /dev/null drivers/w1/slaves/w1_ds2780.h
--- /dev/null
+++ a/drivers/w1/slaves/w1_ds2780.h
@@ -0,0 +1,132 @@
+/*
+ * 1-Wire implementation for the ds2780 chip
+ *
+ * Copyright =A9 2010 Indesign, LLC
+ *
+ * Author: Clifton Barnes <cabarnes@indesign-llc.com>
+ *
+ * Based on w1-ds2760 driver
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef __w1_ds2780_h__
+#define __w1_ds2780_h__
+
+/* Function commands */
+#define W1_DS2780_READ_DATA            0x69
+#define W1_DS2780_WRITE_DATA           0x6C
+#define W1_DS2780_COPY_DATA            0x48
+#define W1_DS2780_RECALL_DATA          0xB8
+#define W1_DS2780_LOCK                 0x6A
+
+/* Register map */
+/* Register 0x00 Reserved */
+#define DS2780_STATUS_REG              0x01
+#define DS2780_RAAC_MSB_REG            0x02
+#define DS2780_RAAC_LSB_REG            0x03
+#define DS2780_RSAC_MSB_REG            0x04
+#define DS2780_RSAC_LSB_REG            0x05
+#define DS2780_RARC_REG                0x06
+#define DS2780_RSRC_REG                0x07
+#define DS2780_IAVG_MSB_REG            0x08
+#define DS2780_IAVG_LSB_REG            0x09
+#define DS2780_TEMP_MSB_REG            0x0A
+#define DS2780_TEMP_LSB_REG            0x0B
+#define DS2780_VOLT_MSB_REG            0x0C
+#define DS2780_VOLT_LSB_REG            0x0D
+#define DS2780_CURRENT_MSB_REG         0x0E
+#define DS2780_CURRENT_LSB_REG         0x0F
+#define DS2780_ACR_MSB_REG             0x10
+#define DS2780_ACR_LSB_REG             0x11
+#define DS2780_ACRL_MSB_REG            0x12
+#define DS2780_ACRL_LSB_REG            0x13
+#define DS2780_AS_REG                  0x14
+#define DS2780_SFR_REG                 0x15
+#define DS2780_FULL_MSB_REG            0x16
+#define DS2780_FULL_LSB_REG            0x17
+#define DS2780_AE_MSB_REG              0x18
+#define DS2780_AE_LSB_REG              0x19
+#define DS2780_SE_MSB_REG              0x1A
+#define DS2780_SE_LSB_REG              0x1B
+/* Register 0x1C - 0x1E Reserved */
+#define DS2780_EEPROM_REG              0x1F
+#define DS2780_EEPROM_BLOCK0_START     0x20
+/* Register 0x20 - 0x2F User EEPROM */
+#define DS2780_EEPROM_BLOCK0_END       0x2F
+/* Register 0x30 - 0x5F Reserved */
+#define DS2780_EEPROM_BLOCK1_START     0x60
+#define DS2780_CONTROL_REG             0x60
+#define DS2780_AB_REG                  0x61
+#define DS2780_AC_MSB_REG              0x62
+#define DS2780_AC_LSB_REG              0x63
+#define DS2780_VCHG_REG                0x64
+#define DS2780_IMIN_REG                0x65
+#define DS2780_VAE_REG                 0x66
+#define DS2780_IAE_REG                 0x67
+#define DS2780_AE_40_REG               0x68
+#define DS2780_RSNSP_REG               0x69
+#define DS2780_FULL_40_MSB_REG         0x6A
+#define DS2780_FULL_40_LSB_REG         0x6B
+#define DS2780_FULL_3040_SLOPE_REG     0x6C
+#define DS2780_FULL_2030_SLOPE_REG     0x6D
+#define DS2780_FULL_1020_SLOPE_REG     0x6E
+#define DS2780_FULL_0010_SLOPE_REG     0x6F
+#define DS2780_AE_3040_SLOPE_REG       0x70
+#define DS2780_AE_2030_SLOPE_REG       0x71
+#define DS2780_AE_1020_SLOPE_REG       0x72
+#define DS2780_AE_0010_SLOPE_REG       0x73
+#define DS2780_SE_3040_SLOPE_REG       0x74
+#define DS2780_SE_2030_SLOPE_REG       0x75
+#define DS2780_SE_1020_SLOPE_REG       0x76
+#define DS2780_SE_0010_SLOPE_REG       0x77
+#define DS2780_RSGAIN_MSB_REG          0x78
+#define DS2780_RSGAIN_LSB_REG          0x79
+#define DS2780_RSTC_REG                0x7A
+#define DS2780_FRSGAIN_MSB_REG         0x7B
+#define DS2780_FRSGAIN_LSB_REG         0x7C
+#define DS2780_EEPROM_BLOCK1_END       0x7C
+/* Register 0x7D - 0xFF Reserved */
+
+/* Number of valid register addresses */
+#define DS2780_DATA_SIZE               0x80
+
+/* Status register bits */
+#define DS2780_STATUS_REG_CHGTF        (1 << 7)
+#define DS2780_STATUS_REG_AEF          (1 << 6)
+#define DS2780_STATUS_REG_SEF          (1 << 5)
+#define DS2780_STATUS_REG_LEARNF       (1 << 4)
+/* Bit 3 Reserved */
+#define DS2780_STATUS_REG_UVF          (1 << 2)
+#define DS2780_STATUS_REG_PORF         (1 << 1)
+/* Bit 0 Reserved */
+
+/* Control register bits */
+/* Bit 7 Reserved */
+#define DS2780_CONTROL_REG_UVEN        (1 << 6)
+#define DS2780_CONTROL_REG_PMOD        (1 << 5)
+#define DS2780_CONTROL_REG_RNAOP       (1 << 4)
+/* Bit 0 - 3 Reserved */
+
+/* Special feature register bits */
+/* Bit 1 - 7 Reserved */
+#define DS2780_SFR_REG_PIOSC           (1 << 0)
+
+/* EEPROM register bits */
+#define DS2780_EEPROM_REG_EEC          (1 << 7)
+#define DS2780_EEPROM_REG_LOCK         (1 << 6)
+/* Bit 2 - 6 Reserved */
+#define DS2780_EEPROM_REG_BL1          (1 << 1)
+#define DS2780_EEPROM_REG_BL0          (1 << 0)
+
+extern int w1_ds2780_read(struct device *dev, char *buf, int addr,
+                       size_t count);
+extern int w1_ds2780_write(struct device *dev, char *buf, int addr,
+                       size_t count);
+extern int w1_ds2780_store_eeprom(struct device *dev, int addr);
+extern int w1_ds2780_recall_eeprom(struct device *dev, int addr);
+
+#endif /* !__w1_ds2780_h__ */
diff -puN drivers/w1/w1_family.h~w1-add-maxim-dallas-ds2780-stand-alone=
-fuel-gauge-ic-support drivers/w1/w1_family.h
--- a/drivers/w1/w1_family.h~w1-add-maxim-dallas-ds2780-stand-alone-fue=
l-gauge-ic-support
+++ a/drivers/w1/w1_family.h
@@ -37,6 +37,7 @@
 #define W1_FAMILY_DS2408	0x29
 #define W1_EEPROM_DS2431	0x2D
 #define W1_FAMILY_DS2760	0x30
+#define W1_FAMILY_DS2780       0x32
=20
 #define MAXNAMELEN		32
=20
_

Patches currently in -mm which might be from cabarnes@indesign-llc.com =
are


--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
