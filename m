From: akpm@linux-foundation.org
Subject: + compal-laptop-added-jhl90-battery-hwmon-interface.patch added to -mm tree
Date: Fri, 23 Apr 2010 11:27:45 -0700
Message-ID: <201004231827.o3NIRkN4004647@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44565 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751070Ab0DWS2V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 Apr 2010 14:28:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roald.frederickx@gmail.com, mjg59@srcf.ucam.org


The patch titled
     compal-laptop: add JHL90, battery & hwmon interface
has been added to the -mm tree.  Its filename is
     compal-laptop-added-jhl90-battery-hwmon-interface.patch

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
Subject: compal-laptop: add JHL90, battery & hwmon interface
From: Roald Frederickx <roald.frederickx@gmail.com>

The driver now supports the Compal JHL90 (which I use) and it has some
added features.  The biggest novelties are a battery interface
(power_supply) and a temperature and fan control interface (hmwon).  It
also adds a power-off feature to the backlight subsystem and it exports a
few files that can enable/disable wake_on_XXX events.

Much of the original code of the old features is still there, but I've
changed some names to keep the naming more coherent with the added
functionalities.  (Sorry for the huge patch)

Some technical stuff about the new driver:

First of all, I'm not sure if the extra features also work on the other
Compal boards.  Currently they only get enabled if the DMI data indicates
you are on a JHL90 board.

Secondly, I've noticed a quirk in my fan controller.  I have to re-send
the wanted pwm-level to the controller every so often.  If I don't do
this, the fanspeed will slowly rise until after a couple of minutes it's
at full speed.  (Note that every normal userland application will probably
update the pwm-level every so often anyway, based on temperature readings,
so this might not be an issue in practice) If this turns out to be a
problem with all the controllers, maybe we should implement a kernel timer
and have the driver re-send the pwm level every XX seconds to make this
transparent to userspace?  (However, I couldn't immediately find a way to
do this cleanly.)

Additional information can be found in the source comments.

Signed-off-by: Roald Frederickx <roald.frederickx@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/compal-laptop.c |  927 ++++++++++++++++++++++---
 1 file changed, 822 insertions(+), 105 deletions(-)

diff -puN drivers/platform/x86/compal-laptop.c~compal-laptop-added-jhl90-battery-hwmon-interface drivers/platform/x86/compal-laptop.c
--- a/drivers/platform/x86/compal-laptop.c~compal-laptop-added-jhl90-battery-hwmon-interface
+++ a/drivers/platform/x86/compal-laptop.c
@@ -24,17 +24,50 @@
  */
 
 /*
- * comapl-laptop.c - Compal laptop support.
+ * compal-laptop.c - Compal laptop support.
+ *
+ * This driver exports a few files in /sys/devices/platform/compal-laptop/:
+ *   wake_up_XXX   Whether or not we listen to such wake up events (rw)
+ *
+ * In addition to these platform device attributes the driver
+ * registers itself in the Linux backlight control, power_supply, rfkill
+ * and hwmon subsystem and is available to userspace under:
+ *
+ *   /sys/class/backlight/compal-laptop/
+ *   /sys/class/power_supply/compal-laptop/
+ *   /sys/class/rfkill/rfkillX/
+ *   /sys/class/hwmon/hwmonX/
+ *
+ * Notes on the power_supply battery interface:
+ *   - the "minimum" design voltage is *the* design voltage
+ *   - the ambient temperature is the average battery temperature
+ *     and the value is an educated guess (see commented code below)
  *
- * The driver registers itself with the rfkill subsystem and
- * the Linux backlight control subsystem.
  *
  * This driver might work on other laptops produced by Compal. If you
  * want to try it you can pass force=1 as argument to the module which
  * will force it to load even when the DMI data doesn't identify the
- * laptop as FL9x.
+ * laptop as compatible.
+ *
+ * Lots of data available at:
+ * http://service1.marasst.com/Compal/JHL90_91/Service%20Manual/
+ * JHL90%20service%20manual-Final-0725.pdf
+ *
+ *
+ *
+ * Support for the Compal JHL90 added by Roald Frederickx
+ * (roald.frederickx@gmail.com):
+ * Driver got large revision. Added functionalities: backlight
+ * power, wake_on_XXX, a hwmon and power_supply interface.
+ *
+ * In case this gets merged into the kernel source: I want to dedicate this
+ * to Kasper Meerts, the awesome guy who showed me Linux and C!
  */
 
+/* NOTE: currently the wake_on_XXX, hwmon and power_supply interfaces are
+ * only enabled on a JHL90 board until it is verified that they work on the
+ * other boards too.  See the extra_features variable. */
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -43,71 +76,296 @@
 #include <linux/backlight.h>
 #include <linux/platform_device.h>
 #include <linux/rfkill.h>
+#include <linux/hwmon.h>
+#include <linux/hwmon-sysfs.h>
+#include <linux/power_supply.h>
+#include <linux/fb.h>
+
+
+/* ======= */
+/* Defines */
+/* ======= */
+#define DRIVER_NAME "compal-laptop"
+#define DRIVER_VERSION 	"0.2.7"
+
+#define BACKLIGHT_LEVEL_ADDR		0xB9
+#define BACKLIGHT_LEVEL_MAX 		7
+#define BACKLIGHT_STATE_ADDR		0x59
+#define BACKLIGHT_STATE_ON_DATA		0xE1
+#define BACKLIGHT_STATE_OFF_DATA	0xE2
+
+#define WAKE_UP_ADDR			0xA4
+#define WAKE_UP_PME			(1 << 0)
+#define WAKE_UP_MODEM			(1 << 1)
+#define WAKE_UP_LAN			(1 << 2)
+#define WAKE_UP_WLAN			(1 << 4)
+#define WAKE_UP_KEY			(1 << 6)
+#define WAKE_UP_MOUSE			(1 << 7)
+
+#define WIRELESS_ADDR			0xBB
+#define WIRELESS_WLAN			(1 << 0)
+#define WIRELESS_BT 			(1 << 1)
+#define WIRELESS_WLAN_EXISTS		(1 << 2)
+#define WIRELESS_BT_EXISTS		(1 << 3)
+#define WIRELESS_KILLSWITCH		(1 << 4)
+
+#define PWM_ADDRESS			0x46
+#define PWM_DISABLE_ADDR		0x59
+#define PWM_DISABLE_DATA		0xA5
+#define PWM_ENABLE_ADDR			0x59
+#define PWM_ENABLE_DATA			0xA8
+
+#define FAN_ADDRESS			0x46
+#define FAN_DATA			0x81
+#define FAN_FULL_ON_CMD			0x59 /* Doesn't seem to work. Just */
+#define FAN_FULL_ON_ENABLE		0x76 /* force the pwm signal to its */
+#define FAN_FULL_ON_DISABLE		0x77 /* maximum value instead */
+
+#define TEMP_CPU			0xB0
+#define TEMP_CPU_LOCAL			0xB1
+#define TEMP_CPU_DTS			0xB5
+#define TEMP_NORTHBRIDGE		0xB6
+#define TEMP_VGA			0xB4
+#define TEMP_SKIN			0xB2
+
+#define BAT_MANUFACTURER_NAME_ADDR	0x10
+#define BAT_MANUFACTURER_NAME_LEN	9
+#define BAT_MODEL_NAME_ADDR		0x19
+#define BAT_MODEL_NAME_LEN		6
+#define BAT_SERIAL_NUMBER_ADDR		0xC4
+#define BAT_SERIAL_NUMBER_LEN		5
+#define BAT_CHARGE_NOW			0xC2
+#define BAT_CHARGE_DESIGN		0xCA
+#define BAT_VOLTAGE_NOW			0xC6
+#define BAT_VOLTAGE_DESIGN		0xC8
+#define BAT_CURRENT_NOW			0xD0
+#define BAT_CURRENT_AVG			0xD2
+#define BAT_POWER			0xD4
+#define BAT_CAPACITY			0xCE
+#define BAT_TEMP			0xD6
+#define BAT_TEMP_AVG			0xD7
+#define BAT_STATUS0			0xC1
+#define BAT_STATUS1			0xF0
+#define BAT_STATUS2			0xF1
+#define BAT_STOP_CHARGE1		0xF2
+#define BAT_STOP_CHARGE2		0xF3
+
+#define BAT_S0_DISCHARGE		(1 << 0)
+#define BAT_S0_DISCHRG_CRITICAL		(1 << 2)
+#define BAT_S0_LOW			(1 << 3)
+#define BAT_S0_CHARGING			(1 << 1)
+#define BAT_S0_AC			(1 << 7)
+#define BAT_S1_EXISTS			(1 << 0)
+#define BAT_S1_FULL			(1 << 1)
+#define BAT_S1_EMPTY			(1 << 2)
+#define BAT_S1_LiION_OR_NiMH		(1 << 7)
+#define BAT_S2_LOW_LOW			(1 << 0)
+#define BAT_STOP_CHRG1_BAD_CELL		(1 << 1)
+#define BAT_STOP_CHRG1_COMM_FAIL	(1 << 2)
+#define BAT_STOP_CHRG1_OVERVOLTAGE	(1 << 6)
+#define BAT_STOP_CHRG1_OVERTEMPERATURE	(1 << 7)
+
+
+/* ======= */
+/* Structs */
+/* ======= */
+struct compal_data{
+	/* Fan control */
+	struct device *hwmon_dev;
+	int pwm_enable; /* 0:full on, 1:set by pwm1, 2:control by moterboard */
+	unsigned char curr_pwm;
+
+	/* Power supply */
+	struct power_supply psy;
+	struct power_supply_info psy_info;
+	char bat_model_name[BAT_MODEL_NAME_LEN + 1];
+	char bat_manufacturer_name[BAT_MANUFACTURER_NAME_LEN + 1];
+	char bat_serial_number[BAT_SERIAL_NUMBER_LEN + 1];
+};
 
-#define COMPAL_DRIVER_VERSION "0.2.6"
 
-#define COMPAL_LCD_LEVEL_MAX 8
+/* =============== */
+/* General globals */
+/* =============== */
+static int force;
+module_param(force, bool, 0);
+MODULE_PARM_DESC(force, "Force driver load, ignore DMI data");
 
-#define COMPAL_EC_COMMAND_WIRELESS 0xBB
-#define COMPAL_EC_COMMAND_LCD_LEVEL 0xB9
+/* Support for the wake_on_XXX, hwmon and power_supply interface. Currently
+ * only gets enabled on a JHL90 board. Might work with the others too */
+static bool extra_features;
+
+/* Nasty stuff. For some reason the fan control is very un-linear.  I've
+ * come up with these values by looping through the possible inputs and
+ * watching the output of address 0x4F (do an ec_transaction writing 0x33
+ * into 0x4F and read a few bytes from the output, like so:
+ * 	u8 writeData = 0x33;
+ * 	ec_transaction(0x4F, &writeData, 1, buffer, 32, 0);
+ * That address is labled "fan1 table information" in the service manual.
+ * It should be clear which value in 'buffer' changes). This seems to be
+ * related to fan speed. It isn't a proper 'realtime' fan speed value
+ * though, because physically stopping or speeding up the fan doesn't
+ * change it. It might be the average voltage or current of the pwm output.
+ * Nevertheless, it is more fine-grained than the actual RPM reading */
+static const unsigned char pwm_lookup_table[256] = {
+	0, 0, 0, 1, 1, 1, 2, 253, 254, 3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6, 6,
+	7, 7, 7, 8, 86, 86, 9, 9, 9, 10, 10, 10, 11, 92, 92, 12, 12, 95,
+	13, 66, 66, 14, 14, 98, 15, 15, 15, 16, 16, 67, 17, 17, 72, 18, 70,
+	75, 19, 90, 90, 73, 73, 73, 21, 21, 91, 91, 91, 96, 23, 94, 94, 94,
+	94, 94, 94, 94, 94, 94, 94, 141, 141, 238, 223, 192, 139, 139, 139,
+	139, 139, 142, 142, 142, 142, 142, 78, 78, 78, 78, 78, 76, 76, 76,
+	76, 76, 79, 79, 79, 79, 79, 79, 79, 20, 20, 20, 20, 20, 22, 22, 22,
+	22, 22, 24, 24, 24, 24, 24, 24, 219, 219, 219, 219, 219, 219, 219,
+	219, 27, 27, 188, 188, 28, 28, 28, 29, 186, 186, 186, 186, 186,
+	186, 186, 186, 186, 186, 31, 31, 31, 31, 31, 32, 32, 32, 41, 33,
+	33, 33, 33, 33, 252, 252, 34, 34, 34, 43, 35, 35, 35, 36, 36, 38,
+	206, 206, 206, 206, 206, 206, 206, 206, 206, 37, 37, 37, 46, 46,
+	47, 47, 232, 232, 232, 232, 232, 232, 232, 232, 232, 232, 48, 48,
+	48, 48, 48, 40, 40, 40, 49, 42, 42, 42, 42, 42, 42, 42, 42, 44,
+	189, 189, 189, 189, 54, 54, 45, 45, 45, 45, 45, 45, 45, 45, 251,
+	191, 199, 199, 199, 199, 199, 215, 215, 215, 215, 187, 187, 187,
+	187, 187, 193, 50
+};
 
-#define KILLSWITCH_MASK 0x10
-#define WLAN_MASK	0x01
-#define BT_MASK 	0x02
 
-static struct rfkill *wifi_rfkill;
-static struct rfkill *bt_rfkill;
-static struct platform_device *compal_device;
 
-static int force;
-module_param(force, bool, 0);
-MODULE_PARM_DESC(force, "Force driver load, ignore DMI data");
 
-/* Hardware access */
+/* ========================= */
+/* Hardware access functions */
+/* ========================= */
+/* General access */
+static u8 ec_read_u8(u8 addr)
+{
+	u8 value;
+	ec_read(addr, &value);
+	return value;
+}
+
+static s8 ec_read_s8(u8 addr)
+{
+	return (s8)ec_read_u8(addr);
+}
+
+static u16 ec_read_u16(u8 addr)
+{
+	int hi, lo;
+	lo = ec_read_u8(addr);
+	hi = ec_read_u8(addr + 1);
+	return (hi << 8) + lo;
+}
+
+static s16 ec_read_s16(u8 addr)
+{
+	return (s16) ec_read_u16(addr);
+}
 
-static int set_lcd_level(int level)
+static void ec_read_sequence(u8 addr, u8 *buf, int len)
 {
-	if (level < 0 || level >= COMPAL_LCD_LEVEL_MAX)
+	int i;
+	for (i = 0; i < len; i++)
+		ec_read(addr + i, buf + i);
+}
+
+
+/* Backlight access */
+static int set_backlight_level(int level)
+{
+	if (level < 0 || level > BACKLIGHT_LEVEL_MAX)
 		return -EINVAL;
 
-	ec_write(COMPAL_EC_COMMAND_LCD_LEVEL, level);
+	ec_write(BACKLIGHT_LEVEL_ADDR, level);
 
 	return 0;
 }
 
-static int get_lcd_level(void)
+static int get_backlight_level(void)
+{
+	return (int) ec_read_u8(BACKLIGHT_LEVEL_ADDR);
+}
+
+static void set_backlight_state(bool on)
+{
+	u8 data = on ? BACKLIGHT_STATE_ON_DATA : BACKLIGHT_STATE_OFF_DATA;
+	ec_transaction(BACKLIGHT_STATE_ADDR, &data, 1, NULL, 0, 0);
+}
+
+
+/* Fan control access */
+static void pwm_enable_control(void)
+{
+	unsigned char writeData = PWM_ENABLE_DATA;
+	ec_transaction(PWM_ENABLE_ADDR, &writeData, 1, NULL, 0, 0);
+}
+
+static void pwm_disable_control(void)
+{
+	unsigned char writeData = PWM_DISABLE_DATA;
+	ec_transaction(PWM_DISABLE_ADDR, &writeData, 1, NULL, 0, 0);
+}
+
+static void set_pwm(int pwm)
 {
-	u8 result;
+	ec_transaction(PWM_ADDRESS, &pwm_lookup_table[pwm], 1, NULL, 0, 0);
+}
+
+static int get_fan_rpm(void)
+{
+	u8 value, data = FAN_DATA;
+	ec_transaction(FAN_ADDRESS, &data, 1, &value, 1, 0);
+	return 100 * (int)value;
+}
+
+
+
+
+/* =================== */
+/* Interface functions */
+/* =================== */
 
-	ec_read(COMPAL_EC_COMMAND_LCD_LEVEL, &result);
+/* Backlight interface */
+static int bl_get_brightness(struct backlight_device *b)
+{
+	return get_backlight_level();
+}
+
+static int bl_update_status(struct backlight_device *b)
+{
+	int ret = set_backlight_level(b->props.brightness);
+	if (ret)
+		return ret;
 
-	return (int) result;
+	set_backlight_state((b->props.power == FB_BLANK_UNBLANK)
+		&&    !(b->props.state & BL_CORE_SUSPENDED)
+		&&    !(b->props.state & BL_CORE_FBBLANK));
+	return 0;
 }
 
+static struct backlight_ops compalbl_ops = {
+	.get_brightness = bl_get_brightness,
+	.update_status	= bl_update_status,
+};
+
+
+/* Wireless interface */
 static int compal_rfkill_set(void *data, bool blocked)
 {
 	unsigned long radio = (unsigned long) data;
-	u8 result, value;
-
-	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
+	u8 result = ec_read_u8(WIRELESS_ADDR);
+	u8 value;
 
 	if (!blocked)
 		value = (u8) (result | radio);
 	else
 		value = (u8) (result & ~radio);
-	ec_write(COMPAL_EC_COMMAND_WIRELESS, value);
+	ec_write(WIRELESS_ADDR, value);
 
 	return 0;
 }
 
 static void compal_rfkill_poll(struct rfkill *rfkill, void *data)
 {
-	u8 result;
-	bool hw_blocked;
-
-	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
-
-	hw_blocked = !(result & KILLSWITCH_MASK);
+	u8 result = ec_read_u8(WIRELESS_ADDR);
+	bool hw_blocked = !(result & WIRELESS_KILLSWITCH);
 	rfkill_set_hw_state(rfkill, hw_blocked);
 }
 
@@ -116,80 +374,404 @@ static const struct rfkill_ops compal_rf
 	.set_block = compal_rfkill_set,
 };
 
-static int setup_rfkill(void)
+
+/* Wake_up interface */
+#define SIMPLE_MASKED_STORE_SHOW(NAME, ADDR, MASK)			\
+static ssize_t NAME##_show(struct device *dev,				\
+	struct device_attribute *attr, char *buf) 			\
+{ 									\
+	return sprintf(buf, "%d\n", ((ec_read_u8(ADDR) & MASK) != 0));	\
+}									\
+static ssize_t NAME##_store(struct device *dev,				\
+	struct device_attribute *attr, const char *buf, size_t count)	\
+{									\
+	int state;							\
+	u8 old_val = ec_read_u8(ADDR);					\
+	if (sscanf(buf, "%d", &state) != 1 || (state < 0 || state > 1))	\
+		return -EINVAL;						\
+	ec_write(ADDR, state ? (old_val | MASK) : (old_val & ~MASK));	\
+	return count;							\
+}
+
+SIMPLE_MASKED_STORE_SHOW(wake_up_pme,	WAKE_UP_ADDR, WAKE_UP_PME)
+SIMPLE_MASKED_STORE_SHOW(wake_up_modem,	WAKE_UP_ADDR, WAKE_UP_MODEM)
+SIMPLE_MASKED_STORE_SHOW(wake_up_lan,	WAKE_UP_ADDR, WAKE_UP_LAN)
+SIMPLE_MASKED_STORE_SHOW(wake_up_wlan,	WAKE_UP_ADDR, WAKE_UP_WLAN)
+SIMPLE_MASKED_STORE_SHOW(wake_up_key,	WAKE_UP_ADDR, WAKE_UP_KEY)
+SIMPLE_MASKED_STORE_SHOW(wake_up_mouse,	WAKE_UP_ADDR, WAKE_UP_MOUSE)
+
+
+/* General hwmon interface */
+static ssize_t hwmon_name_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
 {
-	int ret;
+	return sprintf(buf, "%s\n", DRIVER_NAME);
+}
 
-	wifi_rfkill = rfkill_alloc("compal-wifi", &compal_device->dev,
-				RFKILL_TYPE_WLAN, &compal_rfkill_ops,
-				(void *) WLAN_MASK);
-	if (!wifi_rfkill)
-		return -ENOMEM;
 
-	ret = rfkill_register(wifi_rfkill);
-	if (ret)
-		goto err_wifi;
+/* Fan control interface */
+static ssize_t pwm_enable_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct compal_data *data = dev_get_drvdata(dev);
+	return sprintf(buf, "%d\n", data->pwm_enable);
+}
 
-	bt_rfkill = rfkill_alloc("compal-bluetooth", &compal_device->dev,
-				RFKILL_TYPE_BLUETOOTH, &compal_rfkill_ops,
-				(void *) BT_MASK);
-	if (!bt_rfkill) {
-		ret = -ENOMEM;
-		goto err_allocate_bt;
+static ssize_t pwm_enable_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct compal_data *data = dev_get_drvdata(dev);
+	long val;
+	int err;
+	err = strict_strtol(buf, 10, &val);
+	if (err)
+		return err;
+	if (val < 0)
+		return -EINVAL;
+
+	data->pwm_enable = val;
+
+	switch (val) {
+	case 0:  /* Full speed */
+		pwm_enable_control();
+		set_pwm(255);
+		break;
+	case 1:  /* As set by pwm1 */
+		pwm_enable_control();
+		set_pwm(data->curr_pwm);
+		break;
+	default: /* Control by motherboard */
+		pwm_disable_control();
+		break;
 	}
-	ret = rfkill_register(bt_rfkill);
-	if (ret)
-		goto err_register_bt;
 
-	return 0;
+	return count;
+}
 
-err_register_bt:
-	rfkill_destroy(bt_rfkill);
+static ssize_t pwm_show(struct device *dev, struct device_attribute *attr,
+		char *buf)
+{
+	struct compal_data *data = dev_get_drvdata(dev);
+	return sprintf(buf, "%hhu\n", data->curr_pwm);
+}
 
-err_allocate_bt:
-	rfkill_unregister(wifi_rfkill);
+static ssize_t pwm_store(struct device *dev, struct device_attribute *attr,
+		const char *buf, size_t count)
+{
+	struct compal_data *data = dev_get_drvdata(dev);
+	long val;
+	int err;
+	err = strict_strtol(buf, 10, &val);
+	if (err)
+		return err;
+	if (val < 0 || val > 255)
+		return -EINVAL;
 
-err_wifi:
-	rfkill_destroy(wifi_rfkill);
+	data->curr_pwm = val;
 
-	return ret;
+	if (data->pwm_enable != 1)
+		return count;
+	set_pwm(val);
+
+	return count;
 }
 
-/* Backlight device stuff */
+static ssize_t fan_show(struct device *dev, struct device_attribute *attr,
+		char *buf)
+{
+	return sprintf(buf, "%d\n", get_fan_rpm());
+}
 
-static int bl_get_brightness(struct backlight_device *b)
+
+/* Temperature interface */
+#define TEMPERATURE_SHOW_TEMP_AND_LABEL(POSTFIX, ADDRESS, LABEL) 	\
+static ssize_t temp_##POSTFIX(struct device *dev, 			\
+		struct device_attribute *attr, char *buf) 		\
+{									\
+	return sprintf(buf, "%d\n", 1000 * (int)ec_read_s8(ADDRESS));	\
+}									\
+static ssize_t label_##POSTFIX(struct device *dev, 			\
+		struct device_attribute *attr, char *buf) 		\
+{									\
+	return sprintf(buf, "%s\n", LABEL); 				\
+}
+
+/* Labels as in service guide */
+TEMPERATURE_SHOW_TEMP_AND_LABEL(cpu,        TEMP_CPU,        "CPU_TEMP");
+TEMPERATURE_SHOW_TEMP_AND_LABEL(cpu_local,  TEMP_CPU_LOCAL,  "CPU_TEMP_LOCAL");
+TEMPERATURE_SHOW_TEMP_AND_LABEL(cpu_DTS,    TEMP_CPU_DTS,    "CPU_DTS");
+TEMPERATURE_SHOW_TEMP_AND_LABEL(northbridge,TEMP_NORTHBRIDGE,"NorthBridge");
+TEMPERATURE_SHOW_TEMP_AND_LABEL(vga,        TEMP_VGA,        "VGA_TEMP");
+TEMPERATURE_SHOW_TEMP_AND_LABEL(SKIN,       TEMP_SKIN,       "SKIN_TEMP90");
+
+
+/* Power supply interface */
+static int bat_status(void)
 {
-	return get_lcd_level();
+	u8 status0 = ec_read_u8(BAT_STATUS0);
+	u8 status1 = ec_read_u8(BAT_STATUS1);
+
+	if (status0 & BAT_S0_CHARGING)
+		return POWER_SUPPLY_STATUS_CHARGING;
+	if (status0 & BAT_S0_DISCHARGE)
+		return POWER_SUPPLY_STATUS_DISCHARGING;
+	if (status1 & BAT_S1_FULL)
+		return POWER_SUPPLY_STATUS_FULL;
+	return POWER_SUPPLY_STATUS_NOT_CHARGING;
 }
 
+static int bat_health(void)
+{
+	u8 status = ec_read_u8(BAT_STOP_CHARGE1);
 
-static int bl_update_status(struct backlight_device *b)
+	if (status & BAT_STOP_CHRG1_OVERTEMPERATURE)
+		return POWER_SUPPLY_HEALTH_OVERHEAT;
+	if (status & BAT_STOP_CHRG1_OVERVOLTAGE)
+		return POWER_SUPPLY_HEALTH_OVERVOLTAGE;
+	if (status & BAT_STOP_CHRG1_BAD_CELL)
+		return POWER_SUPPLY_HEALTH_DEAD;
+	if (status & BAT_STOP_CHRG1_COMM_FAIL)
+		return POWER_SUPPLY_HEALTH_UNKNOWN;
+	return POWER_SUPPLY_HEALTH_GOOD;
+}
+
+static int bat_is_present(void)
 {
-	return set_lcd_level(b->props.brightness);
+	u8 status = ec_read_u8(BAT_STATUS2);
+	return ((status & BAT_S1_EXISTS) != 0);
 }
 
-static struct backlight_ops compalbl_ops = {
-	.get_brightness = bl_get_brightness,
-	.update_status	= bl_update_status,
-};
+static int bat_technology(void)
+{
+	u8 status = ec_read_u8(BAT_STATUS1);
+
+	if (status & BAT_S1_LiION_OR_NiMH)
+		return POWER_SUPPLY_TECHNOLOGY_LION;
+	return POWER_SUPPLY_TECHNOLOGY_NiMH;
+}
+
+static int bat_capacity_level(void)
+{
+	u8 status0 = ec_read_u8(BAT_STATUS0);
+	u8 status1 = ec_read_u8(BAT_STATUS1);
+	u8 status2 = ec_read_u8(BAT_STATUS2);
+
+	if (status0 & BAT_S0_DISCHRG_CRITICAL
+			|| status1 & BAT_S1_EMPTY
+			|| status2 & BAT_S2_LOW_LOW)
+		return POWER_SUPPLY_CAPACITY_LEVEL_CRITICAL;
+	if (status0 & BAT_S0_LOW)
+		return POWER_SUPPLY_CAPACITY_LEVEL_LOW;
+	if (status1 & BAT_S1_FULL)
+		return POWER_SUPPLY_CAPACITY_LEVEL_FULL;
+	return POWER_SUPPLY_CAPACITY_LEVEL_NORMAL;
+}
+
+static int bat_get_property(struct power_supply *psy,
+				enum power_supply_property psp,
+				union power_supply_propval *val)
+{
+	struct compal_data *data;
+	data = container_of(psy, struct compal_data, psy);
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_STATUS:
+		val->intval = bat_status();
+		break;
+	case POWER_SUPPLY_PROP_HEALTH:
+		val->intval = bat_health();
+		break;
+	case POWER_SUPPLY_PROP_PRESENT:
+		val->intval = bat_is_present();
+		break;
+	case POWER_SUPPLY_PROP_TECHNOLOGY:
+		val->intval = bat_technology();
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN: /* THE design voltage... */
+		val->intval = ec_read_u16(BAT_VOLTAGE_DESIGN) * 1000;
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+		val->intval = ec_read_u16(BAT_VOLTAGE_NOW) * 1000;
+		break;
+	case POWER_SUPPLY_PROP_CURRENT_NOW:
+		val->intval = ec_read_s16(BAT_CURRENT_NOW) * 1000;
+		break;
+	case POWER_SUPPLY_PROP_CURRENT_AVG:
+		val->intval = ec_read_s16(BAT_CURRENT_AVG) * 1000;
+		break;
+	case POWER_SUPPLY_PROP_POWER_NOW:
+		val->intval = ec_read_u8(BAT_POWER) * 1000000;
+		break;
+	case POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN:
+		val->intval = ec_read_u16(BAT_CHARGE_DESIGN) * 1000;
+		break;
+	case POWER_SUPPLY_PROP_CHARGE_NOW:
+		val->intval = ec_read_u16(BAT_CHARGE_NOW) * 1000;
+		break;
+	case POWER_SUPPLY_PROP_CAPACITY:
+		val->intval = ec_read_u8(BAT_CAPACITY);
+		break;
+	case POWER_SUPPLY_PROP_CAPACITY_LEVEL:
+		val->intval = bat_capacity_level();
+		break;
+	/* It smees that BAT_TEMP_AVG is a (2's complement?) value showing
+	 * the number of degrees, whereas BAT_TEMP is somewhat more
+	 * complicated. It looks like this is a negative nember with a
+	 * 100/256 divider and an offset of 222. Both were determined
+	 * experimentally by comparing BAT_TEMP and BAT_TEMP_AVG. */
+	case POWER_SUPPLY_PROP_TEMP:
+		val->intval = ((222 - (int)ec_read_u8(BAT_TEMP)) * 1000) >> 8;
+		break;
+	case POWER_SUPPLY_PROP_TEMP_AMBIENT: /* Ambient, Avg, ... same thing */
+		val->intval = ec_read_s8(BAT_TEMP_AVG) * 10;
+		break;
+	/* Neither the model name nor manufacturer name work for me. */
+	case POWER_SUPPLY_PROP_MODEL_NAME:
+		val->strval = data->bat_model_name;
+		break;
+	case POWER_SUPPLY_PROP_MANUFACTURER:
+		val->strval = data->bat_manufacturer_name;
+		break;
+	case POWER_SUPPLY_PROP_SERIAL_NUMBER:
+		val->strval = data->bat_serial_number;
+		break;
+	default:
+		break;
+	}
+	return 0;
+}
+
+
 
-static struct backlight_device *compalbl_device;
 
 
+/* ============== */
+/* Driver Globals */
+/* ============== */
+static DEVICE_ATTR(wake_up_pme,
+		0644, wake_up_pme_show,		wake_up_pme_store);
+static DEVICE_ATTR(wake_up_modem,
+		0644, wake_up_modem_show,	wake_up_modem_store);
+static DEVICE_ATTR(wake_up_lan,
+		0644, wake_up_lan_show,	wake_up_lan_store);
+static DEVICE_ATTR(wake_up_wlan,
+		0644, wake_up_wlan_show,	wake_up_wlan_store);
+static DEVICE_ATTR(wake_up_key,
+		0644, wake_up_key_show,	wake_up_key_store);
+static DEVICE_ATTR(wake_up_mouse,
+		0644, wake_up_mouse_show,	wake_up_mouse_store);
+
+static SENSOR_DEVICE_ATTR(name,        S_IRUGO, hwmon_name_show,   NULL, 1);
+static SENSOR_DEVICE_ATTR(fan1_input,  S_IRUGO, fan_show,          NULL, 1);
+static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, temp_cpu,          NULL, 1);
+static SENSOR_DEVICE_ATTR(temp2_input, S_IRUGO, temp_cpu_local,    NULL, 1);
+static SENSOR_DEVICE_ATTR(temp3_input, S_IRUGO, temp_cpu_DTS,      NULL, 1);
+static SENSOR_DEVICE_ATTR(temp4_input, S_IRUGO, temp_northbridge,  NULL, 1);
+static SENSOR_DEVICE_ATTR(temp5_input, S_IRUGO, temp_vga,          NULL, 1);
+static SENSOR_DEVICE_ATTR(temp6_input, S_IRUGO, temp_SKIN,         NULL, 1);
+static SENSOR_DEVICE_ATTR(temp1_label, S_IRUGO, label_cpu,         NULL, 1);
+static SENSOR_DEVICE_ATTR(temp2_label, S_IRUGO, label_cpu_local,   NULL, 1);
+static SENSOR_DEVICE_ATTR(temp3_label, S_IRUGO, label_cpu_DTS,     NULL, 1);
+static SENSOR_DEVICE_ATTR(temp4_label, S_IRUGO, label_northbridge, NULL, 1);
+static SENSOR_DEVICE_ATTR(temp5_label, S_IRUGO, label_vga,         NULL, 1);
+static SENSOR_DEVICE_ATTR(temp6_label, S_IRUGO, label_SKIN,        NULL, 1);
+static SENSOR_DEVICE_ATTR(pwm1, S_IRUGO | S_IWUSR, pwm_show, pwm_store, 1);
+static SENSOR_DEVICE_ATTR(pwm1_enable,
+		S_IRUGO | S_IWUSR, pwm_enable_show, pwm_enable_store, 0);
+
+static struct attribute *compal_attributes[] = {
+	&dev_attr_wake_up_pme.attr,
+	&dev_attr_wake_up_modem.attr,
+	&dev_attr_wake_up_lan.attr,
+	&dev_attr_wake_up_wlan.attr,
+	&dev_attr_wake_up_key.attr,
+	&dev_attr_wake_up_mouse.attr,
+	/* Maybe put the sensor-stuff in a separate hwmon-driver? That way,
+	 * the hwmon sysfs won't be cluttered with the above files. */
+	&sensor_dev_attr_name.dev_attr.attr,
+	&sensor_dev_attr_pwm1_enable.dev_attr.attr,
+	&sensor_dev_attr_pwm1.dev_attr.attr,
+	&sensor_dev_attr_fan1_input.dev_attr.attr,
+	&sensor_dev_attr_temp1_input.dev_attr.attr,
+	&sensor_dev_attr_temp2_input.dev_attr.attr,
+	&sensor_dev_attr_temp3_input.dev_attr.attr,
+	&sensor_dev_attr_temp4_input.dev_attr.attr,
+	&sensor_dev_attr_temp5_input.dev_attr.attr,
+	&sensor_dev_attr_temp6_input.dev_attr.attr,
+	&sensor_dev_attr_temp1_label.dev_attr.attr,
+	&sensor_dev_attr_temp2_label.dev_attr.attr,
+	&sensor_dev_attr_temp3_label.dev_attr.attr,
+	&sensor_dev_attr_temp4_label.dev_attr.attr,
+	&sensor_dev_attr_temp5_label.dev_attr.attr,
+	&sensor_dev_attr_temp6_label.dev_attr.attr,
+	NULL
+};
+
+static struct attribute_group compal_attribute_group = {
+	.attrs = compal_attributes
+};
+
+static int __devinit compal_probe(struct platform_device *);
+static int __devexit compal_remove(struct platform_device *);
 static struct platform_driver compal_driver = {
 	.driver = {
-		.name = "compal-laptop",
+		.name = DRIVER_NAME,
 		.owner = THIS_MODULE,
-	}
+	},
+	.probe	= compal_probe,
+	.remove	= __devexit_p(compal_remove)
+};
+
+static enum power_supply_property compal_bat_properties[] = {
+	POWER_SUPPLY_PROP_STATUS,
+	POWER_SUPPLY_PROP_HEALTH,
+	POWER_SUPPLY_PROP_PRESENT,
+	POWER_SUPPLY_PROP_TECHNOLOGY,
+	POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN,
+	POWER_SUPPLY_PROP_VOLTAGE_NOW,
+	POWER_SUPPLY_PROP_CURRENT_NOW,
+	POWER_SUPPLY_PROP_CURRENT_AVG,
+	POWER_SUPPLY_PROP_POWER_NOW,
+	POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN,
+	POWER_SUPPLY_PROP_CHARGE_NOW,
+	POWER_SUPPLY_PROP_CAPACITY,
+	POWER_SUPPLY_PROP_CAPACITY_LEVEL,
+	POWER_SUPPLY_PROP_TEMP,
+	POWER_SUPPLY_PROP_TEMP_AMBIENT,
+	POWER_SUPPLY_PROP_MODEL_NAME,
+	POWER_SUPPLY_PROP_MANUFACTURER,
+	POWER_SUPPLY_PROP_SERIAL_NUMBER,
 };
 
-/* Initialization */
+static struct backlight_device *compalbl_device;
+
+static struct platform_device *compal_device;
+
+static struct rfkill *wifi_rfkill;
+static struct rfkill *bt_rfkill;
+
+
+
+
+
+/* =================================== */
+/* Initialization & clean-up functions */
+/* =================================== */
 
 static int dmi_check_cb(const struct dmi_system_id *id)
 {
-	printk(KERN_INFO "compal-laptop: Identified laptop model '%s'.\n",
+	printk(KERN_INFO DRIVER_NAME": Identified laptop model '%s'\n",
 		id->ident);
+	extra_features = false;
+	return 0;
+}
 
+static int dmi_check_cb_extra(const struct dmi_system_id *id)
+{
+	printk(KERN_INFO DRIVER_NAME": Identified laptop model '%s', "
+		"enabling extra features\n",
+		id->ident);
+	extra_features = true;
 	return 0;
 }
 
@@ -274,27 +856,106 @@ static struct dmi_system_id __initdata c
 		},
 		.callback = dmi_check_cb
 	},
-
+	{
+		.ident = "JHL90",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "JHL90"),
+			DMI_MATCH(DMI_BOARD_VERSION, "REFERENCE"),
+		},
+		.callback = dmi_check_cb_extra
+	},
 	{ }
 };
 
+static void initialize_power_supply_data(struct compal_data *data)
+{
+	data->psy.name = DRIVER_NAME;
+	data->psy.type = POWER_SUPPLY_TYPE_BATTERY;
+	data->psy.properties = compal_bat_properties;
+	data->psy.num_properties = ARRAY_SIZE(compal_bat_properties);
+	data->psy.get_property = bat_get_property;
+
+	ec_read_sequence(BAT_MANUFACTURER_NAME_ADDR,
+					data->bat_manufacturer_name,
+					BAT_MANUFACTURER_NAME_LEN);
+	data->bat_manufacturer_name[BAT_MANUFACTURER_NAME_LEN] = 0;
+
+	ec_read_sequence(BAT_MODEL_NAME_ADDR,
+					data->bat_model_name,
+					BAT_MODEL_NAME_LEN);
+	data->bat_model_name[BAT_MODEL_NAME_LEN] = 0;
+
+	scnprintf(data->bat_serial_number, BAT_SERIAL_NUMBER_LEN + 1, "%d",
+				ec_read_u16(BAT_SERIAL_NUMBER_ADDR));
+}
+
+static void initialize_fan_control_data(struct compal_data *data)
+{
+	data->pwm_enable = 2; /* Keep motherboard in control for now */
+	data->curr_pwm = 255; /* Try not to cause a CPU_on_fire exception
+				 if we take over... */
+}
+
+static int setup_rfkill(void)
+{
+	int ret;
+
+	wifi_rfkill = rfkill_alloc("compal-wifi", &compal_device->dev,
+				RFKILL_TYPE_WLAN, &compal_rfkill_ops,
+				(void *) WIRELESS_WLAN);
+	if (!wifi_rfkill)
+		return -ENOMEM;
+
+	ret = rfkill_register(wifi_rfkill);
+	if (ret)
+		goto err_wifi;
+
+	bt_rfkill = rfkill_alloc("compal-bluetooth", &compal_device->dev,
+				RFKILL_TYPE_BLUETOOTH, &compal_rfkill_ops,
+				(void *) WIRELESS_BT);
+	if (!bt_rfkill) {
+		ret = -ENOMEM;
+		goto err_allocate_bt;
+	}
+	ret = rfkill_register(bt_rfkill);
+	if (ret)
+		goto err_register_bt;
+
+	return 0;
+
+err_register_bt:
+	rfkill_destroy(bt_rfkill);
+
+err_allocate_bt:
+	rfkill_unregister(wifi_rfkill);
+
+err_wifi:
+	rfkill_destroy(wifi_rfkill);
+
+	return ret;
+}
+
 static int __init compal_init(void)
 {
 	int ret;
 
-	if (acpi_disabled)
+	if (acpi_disabled) {
+		printk(KERN_ERR DRIVER_NAME": ACPI needs to be enabled for "
+						"this driver to work!\n");
 		return -ENODEV;
+	}
 
-	if (!force && !dmi_check_system(compal_dmi_table))
+	if (!force && !dmi_check_system(compal_dmi_table)) {
+		printk(KERN_ERR DRIVER_NAME": Motherboard not recognized (You "
+				"could try the module's force-parameter)");
 		return -ENODEV;
-
-	/* Register backlight stuff */
+	}
 
 	if (!acpi_video_backlight_support()) {
 		struct backlight_properties props;
 		memset(&props, 0, sizeof(struct backlight_properties));
-		props.max_brightness = COMPAL_LCD_LEVEL_MAX - 1;
-		compalbl_device = backlight_device_register("compal-laptop",
+		props.max_brightness = BACKLIGHT_LEVEL_MAX;
+		compalbl_device = backlight_device_register(DRIVER_NAME,
 							    NULL, NULL,
 							    &compalbl_ops,
 							    &props);
@@ -304,67 +965,122 @@ static int __init compal_init(void)
 
 	ret = platform_driver_register(&compal_driver);
 	if (ret)
-		goto fail_backlight;
+		goto err_backlight;
 
-	/* Register platform stuff */
-
-	compal_device = platform_device_alloc("compal-laptop", -1);
+	compal_device = platform_device_alloc(DRIVER_NAME, -1);
 	if (!compal_device) {
 		ret = -ENOMEM;
-		goto fail_platform_driver;
+		goto err_platform_driver;
 	}
 
-	ret = platform_device_add(compal_device);
+	ret = platform_device_add(compal_device); /* This calls compal_probe */
 	if (ret)
-		goto fail_platform_device;
+		goto err_platform_device;
 
 	ret = setup_rfkill();
 	if (ret)
-		goto fail_rfkill;
-
-	printk(KERN_INFO "compal-laptop: driver "COMPAL_DRIVER_VERSION
-		" successfully loaded.\n");
+		goto err_rfkill;
 
+	printk(KERN_INFO DRIVER_NAME": Driver "DRIVER_VERSION
+						" successfully loaded\n");
 	return 0;
 
-fail_rfkill:
+err_rfkill:
 	platform_device_del(compal_device);
 
-fail_platform_device:
-
+err_platform_device:
 	platform_device_put(compal_device);
 
-fail_platform_driver:
-
+err_platform_driver:
 	platform_driver_unregister(&compal_driver);
 
-fail_backlight:
-
+err_backlight:
 	backlight_device_unregister(compalbl_device);
 
 	return ret;
 }
 
-static void __exit compal_cleanup(void)
+static int __devinit compal_probe(struct platform_device *pdev)
 {
+	int err;
+	struct compal_data *data;
+
+	if (!extra_features)
+		return 0;
+
+	/* Fan control */
+	data = kzalloc(sizeof(struct compal_data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	initialize_fan_control_data(data);
+
+	err = sysfs_create_group(&pdev->dev.kobj, &compal_attribute_group)
+	if (err)
+		return err;
+
+	data->hwmon_dev = hwmon_device_register(&pdev->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
+		sysfs_remove_group(&pdev->dev.kobj,
+				&compal_attribute_group);
+		kfree(data);
+		return err;
+	}
+
+	/* Power supply */
+	initialize_power_supply_data(data);
+	power_supply_register(&compal_device->dev, &data->psy);
+
+	platform_set_drvdata(pdev, data);
+
+	return 0;
+}
 
+static void __exit compal_cleanup(void)
+{
 	platform_device_unregister(compal_device);
 	platform_driver_unregister(&compal_driver);
 	backlight_device_unregister(compalbl_device);
 	rfkill_unregister(wifi_rfkill);
-	rfkill_destroy(wifi_rfkill);
 	rfkill_unregister(bt_rfkill);
+	rfkill_destroy(wifi_rfkill);
 	rfkill_destroy(bt_rfkill);
 
-	printk(KERN_INFO "compal-laptop: driver unloaded.\n");
+	printk(KERN_INFO DRIVER_NAME": Driver unloaded\n");
+}
+
+static int __devexit compal_remove(struct platform_device *pdev)
+{
+	struct compal_data *data;
+
+	if (!extra_features)
+		return 0;
+
+	printk(KERN_INFO DRIVER_NAME": Unloading: resetting fan control "
+							"to motherboard\n");
+	pwm_disable_control();
+
+	data = platform_get_drvdata(pdev);
+	hwmon_device_unregister(data->hwmon_dev);
+	power_supply_unregister(&data->psy);
+
+	platform_set_drvdata(pdev, NULL);
+	kfree(data);
+
+	sysfs_remove_group(&pdev->dev.kobj, &compal_attribute_group);
+
+	return 0;
 }
 
+
 module_init(compal_init);
 module_exit(compal_cleanup);
 
 MODULE_AUTHOR("Cezary Jackiewicz");
+MODULE_AUTHOR("Roald Frederickx (roald.frederickx@gmail.com)");
 MODULE_DESCRIPTION("Compal Laptop Support");
-MODULE_VERSION(COMPAL_DRIVER_VERSION);
+MODULE_VERSION(DRIVER_VERSION);
 MODULE_LICENSE("GPL");
 
 MODULE_ALIAS("dmi:*:rnIFL90:rvrIFT00:*");
@@ -372,6 +1088,7 @@ MODULE_ALIAS("dmi:*:rnIFL90:rvrREFERENCE
 MODULE_ALIAS("dmi:*:rnIFL91:rvrIFT00:*");
 MODULE_ALIAS("dmi:*:rnJFL92:rvrIFT00:*");
 MODULE_ALIAS("dmi:*:rnIFT00:rvrIFT00:*");
+MODULE_ALIAS("dmi:*:rnJHL90:rvrREFERENCE:*");
 MODULE_ALIAS("dmi:*:svnDellInc.:pnInspiron910:*");
 MODULE_ALIAS("dmi:*:svnDellInc.:pnInspiron1010:*");
 MODULE_ALIAS("dmi:*:svnDellInc.:pnInspiron1011:*");
_

Patches currently in -mm which might be from roald.frederickx@gmail.com are

compal-laptop-added-jhl90-battery-hwmon-interface.patch

