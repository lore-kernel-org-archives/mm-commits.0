From: akpm@linux-foundation.org
Subject: + lis3-solve-dependency-between-core-and-acpi.patch added to -mm tree
Date: Mon, 30 Mar 2009 16:26:46 -0700
Message-ID: <200903302326.n2UNQkNJ022692@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51082 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752427AbZC3X3V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 19:29:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daniel@caiaq.de, eric.piel@tremplin-utc.net, pavel@ucw.cz


The patch titled
     lis3: solve dependency between core and ACPI
has been added to the -mm tree.  Its filename is
     lis3-solve-dependency-between-core-and-acpi.patch

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
Subject: lis3: solve dependency between core and ACPI
From: Daniel Mack <daniel@caiaq.de>

This solves the dependency between lis3lv02d.[ch] and ACPI specific
methods.  It introduces a ->bus_priv pointer to the device struct which is
casted to 'struct acpi_device' in the ACIP layer.  Changed hp_accel.c
accordingly.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Acked-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Eric Piel <eric.piel@tremplin-utc.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/hp_accel.c  |   99 +++++++++++++-----------------------
 drivers/hwmon/lis3lv02d.c |   86 ++++++++++++++++++++-----------
 drivers/hwmon/lis3lv02d.h |   20 +++----
 3 files changed, 105 insertions(+), 100 deletions(-)

diff -puN drivers/hwmon/hp_accel.c~lis3-solve-dependency-between-core-and-acpi drivers/hwmon/hp_accel.c
--- a/drivers/hwmon/hp_accel.c~lis3-solve-dependency-between-core-and-acpi
+++ a/drivers/hwmon/hp_accel.c
@@ -85,25 +85,31 @@ MODULE_DEVICE_TABLE(acpi, lis3lv02d_devi
 
 /**
  * lis3lv02d_acpi_init - ACPI _INI method: initialize the device.
- * @handle: the handle of the device
+ * @lis3: pointer to the device struct
  *
- * Returns AE_OK on success.
+ * Returns 0 on success.
  */
-acpi_status lis3lv02d_acpi_init(acpi_handle handle)
+int lis3lv02d_acpi_init(struct lis3lv02d *lis3)
 {
-	return acpi_evaluate_object(handle, METHOD_NAME__INI, NULL, NULL);
+	struct acpi_device *dev = lis3->bus_priv;
+	if (acpi_evaluate_object(dev->handle, METHOD_NAME__INI,
+				 NULL, NULL) != AE_OK)
+		return -EINVAL;
+
+	return 0;
 }
 
 /**
  * lis3lv02d_acpi_read - ACPI ALRD method: read a register
- * @handle: the handle of the device
+ * @lis3: pointer to the device struct
  * @reg:    the register to read
  * @ret:    result of the operation
  *
- * Returns AE_OK on success.
+ * Returns 0 on success.
  */
-acpi_status lis3lv02d_acpi_read(acpi_handle handle, int reg, u8 *ret)
+int lis3lv02d_acpi_read(struct lis3lv02d *lis3, int reg, u8 *ret)
 {
+	struct acpi_device *dev = lis3->bus_priv;
 	union acpi_object arg0 = { ACPI_TYPE_INTEGER };
 	struct acpi_object_list args = { 1, &arg0 };
 	unsigned long long lret;
@@ -111,21 +117,22 @@ acpi_status lis3lv02d_acpi_read(acpi_han
 
 	arg0.integer.value = reg;
 
-	status = acpi_evaluate_integer(handle, "ALRD", &args, &lret);
+	status = acpi_evaluate_integer(dev->handle, "ALRD", &args, &lret);
 	*ret = lret;
-	return status;
+	return (status != AE_OK) ? -EINVAL : 0;
 }
 
 /**
  * lis3lv02d_acpi_write - ACPI ALWR method: write to a register
- * @handle: the handle of the device
+ * @lis3: pointer to the device struct
  * @reg:    the register to write to
  * @val:    the value to write
  *
- * Returns AE_OK on success.
+ * Returns 0 on success.
  */
-acpi_status lis3lv02d_acpi_write(acpi_handle handle, int reg, u8 val)
+int lis3lv02d_acpi_write(struct lis3lv02d *lis3, int reg, u8 val)
 {
+	struct acpi_device *dev = lis3->bus_priv;
 	unsigned long long ret; /* Not used when writting */
 	union acpi_object in_obj[2];
 	struct acpi_object_list args = { 2, in_obj };
@@ -135,7 +142,10 @@ acpi_status lis3lv02d_acpi_write(acpi_ha
 	in_obj[1].type          = ACPI_TYPE_INTEGER;
 	in_obj[1].integer.value = val;
 
-	return acpi_evaluate_integer(handle, "ALWR", &args, &ret);
+	if (acpi_evaluate_integer(dev->handle, "ALWR", &args, &ret) != AE_OK)
+		return -EINVAL;
+
+	return 0;
 }
 
 static int lis3lv02d_dmi_matched(const struct dmi_system_id *dmi)
@@ -217,7 +227,7 @@ static struct dmi_system_id lis3lv02d_dm
 
 static void hpled_set(struct delayed_led_classdev *led_cdev, enum led_brightness value)
 {
-	acpi_handle handle = lis3_dev.device->handle;
+	struct acpi_device *dev = lis3_dev.bus_priv;
 	unsigned long long ret; /* Not used when writing */
 	union acpi_object in_obj[1];
 	struct acpi_object_list args = { 1, in_obj };
@@ -225,7 +235,7 @@ static void hpled_set(struct delayed_led
 	in_obj[0].type          = ACPI_TYPE_INTEGER;
 	in_obj[0].integer.value = !!value;
 
-	acpi_evaluate_integer(handle, "ALED", &args, &ret);
+	acpi_evaluate_integer(dev->handle, "ALED", &args, &ret);
 }
 
 static struct delayed_led_classdev hpled_led = {
@@ -262,23 +272,6 @@ static void lis3lv02d_enum_resources(str
 		printk(KERN_DEBUG DRIVER_NAME ": Error getting resources\n");
 }
 
-static s16 lis3lv02d_read_16(acpi_handle handle, int reg)
-{
-	u8 lo, hi;
-
-	lis3_dev.read(handle, reg - 1, &lo);
-	lis3_dev.read(handle, reg, &hi);
-	/* In "12 bit right justified" mode, bit 6, bit 7, bit 8 = bit 5 */
-	return (s16)((hi << 8) | lo);
-}
-
-static s16 lis3lv02d_read_8(acpi_handle handle, int reg)
-{
-	s8 lo;
-	lis3_dev.read(handle, reg, &lo);
-	return lo;
-}
-
 static int lis3lv02d_add(struct acpi_device *device)
 {
 	int ret;
@@ -286,7 +279,7 @@ static int lis3lv02d_add(struct acpi_dev
 	if (!device)
 		return -EINVAL;
 
-	lis3_dev.device = device;
+	lis3_dev.bus_priv = device;
 	lis3_dev.init = lis3lv02d_acpi_init;
 	lis3_dev.read = lis3lv02d_acpi_read;
 	lis3_dev.write = lis3lv02d_acpi_write;
@@ -294,23 +287,8 @@ static int lis3lv02d_add(struct acpi_dev
 	strcpy(acpi_device_class(device), ACPI_MDPS_CLASS);
 	device->driver_data = &lis3_dev;
 
-	lis3lv02d_acpi_read(device->handle, WHO_AM_I, &lis3_dev.whoami);
-	switch (lis3_dev.whoami) {
-	case LIS_DOUBLE_ID:
-		printk(KERN_INFO DRIVER_NAME ": 2-byte sensor found\n");
-		lis3_dev.read_data = lis3lv02d_read_16;
-		lis3_dev.mdps_max_val = 2048;
-		break;
-	case LIS_SINGLE_ID:
-		printk(KERN_INFO DRIVER_NAME ": 1-byte sensor found\n");
-		lis3_dev.read_data = lis3lv02d_read_8;
-		lis3_dev.mdps_max_val = 128;
-		break;
-	default:
-		printk(KERN_ERR DRIVER_NAME
-			": unknown sensor type 0x%X\n", lis3_dev.whoami);
-		return -EINVAL;
-	}
+	/* obtain IRQ number of our device from ACPI */
+	lis3lv02d_enum_resources(device);
 
 	/* If possible use a "standard" axes order */
 	if (dmi_check_system(lis3lv02d_dmi_ids) == 0) {
@@ -319,18 +297,17 @@ static int lis3lv02d_add(struct acpi_dev
 		lis3_dev.ac = lis3lv02d_axis_normal;
 	}
 
-	INIT_WORK(&hpled_led.work, delayed_set_status_worker);
-	ret = led_classdev_register(NULL, &hpled_led.led_classdev);
+	/* call the core layer do its init */
+	ret = lis3lv02d_init_device(&lis3_dev);
 	if (ret)
 		return ret;
 
-	/* obtain IRQ number of our device from ACPI */
-	lis3lv02d_enum_resources(lis3_dev.device);
-
-	ret = lis3lv02d_init_device(&lis3_dev);
+	INIT_WORK(&hpled_led.work, delayed_set_status_worker);
+	ret = led_classdev_register(NULL, &hpled_led.led_classdev);
 	if (ret) {
+		lis3lv02d_joystick_disable();
+		lis3lv02d_poweroff(&lis3_dev);
 		flush_work(&hpled_led.work);
-		led_classdev_unregister(&hpled_led.led_classdev);
 		return ret;
 	}
 
@@ -343,7 +320,7 @@ static int lis3lv02d_remove(struct acpi_
 		return -EINVAL;
 
 	lis3lv02d_joystick_disable();
-	lis3lv02d_poweroff(device->handle);
+	lis3lv02d_poweroff(&lis3_dev);
 
 	flush_work(&hpled_led.work);
 	led_classdev_unregister(&hpled_led.led_classdev);
@@ -356,7 +333,7 @@ static int lis3lv02d_remove(struct acpi_
 static int lis3lv02d_suspend(struct acpi_device *device, pm_message_t state)
 {
 	/* make sure the device is off when we suspend */
-	lis3lv02d_poweroff(device->handle);
+	lis3lv02d_poweroff(&lis3_dev);
 	return 0;
 }
 
@@ -365,9 +342,9 @@ static int lis3lv02d_resume(struct acpi_
 	/* put back the device in the right state (ACPI might turn it on) */
 	mutex_lock(&lis3_dev.lock);
 	if (lis3_dev.usage > 0)
-		lis3lv02d_poweron(device->handle);
+		lis3lv02d_poweron(&lis3_dev);
 	else
-		lis3lv02d_poweroff(device->handle);
+		lis3lv02d_poweroff(&lis3_dev);
 	mutex_unlock(&lis3_dev.lock);
 	return 0;
 }
diff -puN drivers/hwmon/lis3lv02d.c~lis3-solve-dependency-between-core-and-acpi drivers/hwmon/lis3lv02d.c
--- a/drivers/hwmon/lis3lv02d.c~lis3-solve-dependency-between-core-and-acpi
+++ a/drivers/hwmon/lis3lv02d.c
@@ -36,7 +36,6 @@
 #include <linux/freezer.h>
 #include <linux/uaccess.h>
 #include <linux/miscdevice.h>
-#include <acpi/acpi_drivers.h>
 #include <asm/atomic.h>
 #include "lis3lv02d.h"
 
@@ -53,18 +52,27 @@
  * joystick.
  */
 
-struct acpi_lis3lv02d lis3_dev = {
+struct lis3lv02d lis3_dev = {
 	.misc_wait   = __WAIT_QUEUE_HEAD_INITIALIZER(lis3_dev.misc_wait),
 };
 
 EXPORT_SYMBOL_GPL(lis3_dev);
 
-static s16 lis3lv02d_read_16(acpi_handle handle, int reg)
+static s16 lis3lv02d_read_8(struct lis3lv02d *lis3, int reg)
+{
+	s8 lo;
+	if (lis3->read(lis3, reg, &lo) < 0)
+		return 0;
+
+	return lo;
+}
+
+static s16 lis3lv02d_read_16(struct lis3lv02d *lis3, int reg)
 {
 	u8 lo, hi;
 
-	lis3_dev.read(handle, reg, &lo);
-	lis3_dev.read(handle, reg + 1, &hi);
+	lis3->read(lis3, reg - 1, &lo);
+	lis3->read(lis3, reg, &hi);
 	/* In "12 bit right justified" mode, bit 6, bit 7, bit 8 = bit 5 */
 	return (s16)((hi << 8) | lo);
 }
@@ -86,36 +94,36 @@ static inline int lis3lv02d_get_axis(s8 
 
 /**
  * lis3lv02d_get_xyz - Get X, Y and Z axis values from the accelerometer
- * @handle: the handle to the device
- * @x:      where to store the X axis value
- * @y:      where to store the Y axis value
- * @z:      where to store the Z axis value
+ * @lis3: pointer to the device struct
+ * @x:    where to store the X axis value
+ * @y:    where to store the Y axis value
+ * @z:    where to store the Z axis value
  *
  * Note that 40Hz input device can eat up about 10% CPU at 800MHZ
  */
-static void lis3lv02d_get_xyz(acpi_handle handle, int *x, int *y, int *z)
+static void lis3lv02d_get_xyz(struct lis3lv02d *lis3, int *x, int *y, int *z)
 {
 	int position[3];
 
-	position[0] = lis3_dev.read_data(handle, OUTX);
-	position[1] = lis3_dev.read_data(handle, OUTY);
-	position[2] = lis3_dev.read_data(handle, OUTZ);
+	position[0] = lis3_dev.read_data(lis3, OUTX);
+	position[1] = lis3_dev.read_data(lis3, OUTY);
+	position[2] = lis3_dev.read_data(lis3, OUTZ);
 
 	*x = lis3lv02d_get_axis(lis3_dev.ac.x, position);
 	*y = lis3lv02d_get_axis(lis3_dev.ac.y, position);
 	*z = lis3lv02d_get_axis(lis3_dev.ac.z, position);
 }
 
-void lis3lv02d_poweroff(acpi_handle handle)
+void lis3lv02d_poweroff(struct lis3lv02d *lis3)
 {
 	lis3_dev.is_on = 0;
 }
 EXPORT_SYMBOL_GPL(lis3lv02d_poweroff);
 
-void lis3lv02d_poweron(acpi_handle handle)
+void lis3lv02d_poweron(struct lis3lv02d *lis3)
 {
 	lis3_dev.is_on = 1;
-	lis3_dev.init(handle);
+	lis3_dev.init(lis3);
 }
 EXPORT_SYMBOL_GPL(lis3lv02d_poweron);
 
@@ -124,13 +132,13 @@ EXPORT_SYMBOL_GPL(lis3lv02d_poweron);
  * device will always be on until a call to lis3lv02d_decrease_use(). Not to be
  * used from interrupt context.
  */
-static void lis3lv02d_increase_use(struct acpi_lis3lv02d *dev)
+static void lis3lv02d_increase_use(struct lis3lv02d *dev)
 {
 	mutex_lock(&dev->lock);
 	dev->usage++;
 	if (dev->usage == 1) {
 		if (!dev->is_on)
-			lis3lv02d_poweron(dev->device->handle);
+			lis3lv02d_poweron(dev);
 	}
 	mutex_unlock(&dev->lock);
 }
@@ -139,12 +147,12 @@ static void lis3lv02d_increase_use(struc
  * To be called whenever a usage of the device is stopped.
  * It will make sure to turn off the device when there is not usage.
  */
-static void lis3lv02d_decrease_use(struct acpi_lis3lv02d *dev)
+static void lis3lv02d_decrease_use(struct lis3lv02d *dev)
 {
 	mutex_lock(&dev->lock);
 	dev->usage--;
 	if (dev->usage == 0)
-		lis3lv02d_poweroff(dev->device->handle);
+		lis3lv02d_poweroff(dev);
 	mutex_unlock(&dev->lock);
 }
 
@@ -291,7 +299,7 @@ static int lis3lv02d_joystick_kthread(vo
 	int x, y, z;
 
 	while (!kthread_should_stop()) {
-		lis3lv02d_get_xyz(lis3_dev.device->handle, &x, &y, &z);
+		lis3lv02d_get_xyz(&lis3_dev, &x, &y, &z);
 		input_report_abs(lis3_dev.idev, ABS_X, x - lis3_dev.xcalib);
 		input_report_abs(lis3_dev.idev, ABS_Y, y - lis3_dev.ycalib);
 		input_report_abs(lis3_dev.idev, ABS_Z, z - lis3_dev.zcalib);
@@ -325,7 +333,8 @@ static void lis3lv02d_joystick_close(str
 
 static inline void lis3lv02d_calibrate_joystick(void)
 {
-	lis3lv02d_get_xyz(lis3_dev.device->handle, &lis3_dev.xcalib, &lis3_dev.ycalib, &lis3_dev.zcalib);
+	lis3lv02d_get_xyz(&lis3_dev,
+		&lis3_dev.xcalib, &lis3_dev.ycalib, &lis3_dev.zcalib);
 }
 
 int lis3lv02d_joystick_enable(void)
@@ -382,7 +391,7 @@ static ssize_t lis3lv02d_position_show(s
 	int x, y, z;
 
 	lis3lv02d_increase_use(&lis3_dev);
-	lis3lv02d_get_xyz(lis3_dev.device->handle, &x, &y, &z);
+	lis3lv02d_get_xyz(&lis3_dev, &x, &y, &z);
 	lis3lv02d_decrease_use(&lis3_dev);
 	return sprintf(buf, "(%d,%d,%d)\n", x, y, z);
 }
@@ -412,7 +421,7 @@ static ssize_t lis3lv02d_rate_show(struc
 	int val;
 
 	lis3lv02d_increase_use(&lis3_dev);
-	lis3_dev.read(lis3_dev.device->handle, CTRL_REG1, &ctrl);
+	lis3_dev.read(&lis3_dev, CTRL_REG1, &ctrl);
 	lis3lv02d_decrease_use(&lis3_dev);
 	val = (ctrl & (CTRL1_DF0 | CTRL1_DF1)) >> 4;
 	return sprintf(buf, "%d\n", lis3lv02dl_df_val[val]);
@@ -435,7 +444,7 @@ static struct attribute_group lis3lv02d_
 };
 
 
-static int lis3lv02d_add_fs(struct acpi_device *device)
+static int lis3lv02d_add_fs(struct lis3lv02d *lis3)
 {
 	lis3_dev.pdev = platform_device_register_simple(DRIVER_NAME, -1, NULL, 0);
 	if (IS_ERR(lis3_dev.pdev))
@@ -456,10 +465,29 @@ EXPORT_SYMBOL_GPL(lis3lv02d_remove_fs);
  * Initialise the accelerometer and the various subsystems.
  * Should be rather independant of the bus system.
  */
-int lis3lv02d_init_device(struct acpi_lis3lv02d *dev)
+int lis3lv02d_init_device(struct lis3lv02d *dev)
 {
+	dev->whoami = lis3lv02d_read_8(dev, WHO_AM_I);
+
+	switch (dev->whoami) {
+	case LIS_DOUBLE_ID:
+		printk(KERN_INFO DRIVER_NAME ": 2-byte sensor found\n");
+		dev->read_data = lis3lv02d_read_16;
+		dev->mdps_max_val = 2048;
+		break;
+	case LIS_SINGLE_ID:
+		printk(KERN_INFO DRIVER_NAME ": 1-byte sensor found\n");
+		dev->read_data = lis3lv02d_read_8;
+		dev->mdps_max_val = 128;
+		break;
+	default:
+		printk(KERN_ERR DRIVER_NAME
+			": unknown sensor type 0x%X\n", lis3_dev.whoami);
+		return -EINVAL;
+	}
+
 	mutex_init(&dev->lock);
-	lis3lv02d_add_fs(dev->device);
+	lis3lv02d_add_fs(dev);
 	lis3lv02d_increase_use(dev);
 
 	if (lis3lv02d_joystick_enable())
@@ -467,10 +495,10 @@ int lis3lv02d_init_device(struct acpi_li
 
 	printk("lis3_init_device: irq %d\n", dev->irq);
 
-	/* if we did not get an IRQ from ACPI - we have nothing more to do */
+	/* bail if we did not get an IRQ from the bus layer */
 	if (!dev->irq) {
 		printk(KERN_ERR DRIVER_NAME
-			": No IRQ in ACPI. Disabling /dev/freefall\n");
+			": No IRQ. Disabling /dev/freefall\n");
 		goto out;
 	}
 
diff -puN drivers/hwmon/lis3lv02d.h~lis3-solve-dependency-between-core-and-acpi drivers/hwmon/lis3lv02d.h
--- a/drivers/hwmon/lis3lv02d.h~lis3-solve-dependency-between-core-and-acpi
+++ a/drivers/hwmon/lis3lv02d.h
@@ -159,14 +159,14 @@ struct axis_conversion {
 	s8	z;
 };
 
-struct acpi_lis3lv02d {
-	struct acpi_device	*device;   /* The ACPI device */
-	acpi_status (*init) (acpi_handle handle);
-	acpi_status (*write) (acpi_handle handle, int reg, u8 val);
-	acpi_status (*read) (acpi_handle handle, int reg, u8 *ret);
+struct lis3lv02d {
+	void			*bus_priv; /* used by the bus layer only */
+	int (*init) (struct lis3lv02d *lis3);
+	int (*write) (struct lis3lv02d *lis3, int reg, u8 val);
+	int (*read) (struct lis3lv02d *lis3, int reg, u8 *ret);
 
 	u8			whoami;    /* 3Ah: 2-byte registries, 3Bh: 1-byte registries */
-	s16 (*read_data) (acpi_handle handle, int reg);
+	s16 (*read_data) (struct lis3lv02d *lis3, int reg);
 	int			mdps_max_val;
 
 	struct input_dev	*idev;     /* input device */
@@ -187,11 +187,11 @@ struct acpi_lis3lv02d {
 	unsigned long		misc_opened; /* bit0: whether the device is open */
 };
 
-int lis3lv02d_init_device(struct acpi_lis3lv02d *dev);
+int lis3lv02d_init_device(struct lis3lv02d *lis3);
 int lis3lv02d_joystick_enable(void);
 void lis3lv02d_joystick_disable(void);
-void lis3lv02d_poweroff(acpi_handle handle);
-void lis3lv02d_poweron(acpi_handle handle);
+void lis3lv02d_poweroff(struct lis3lv02d *lis3);
+void lis3lv02d_poweron(struct lis3lv02d *lis3);
 int lis3lv02d_remove_fs(void);
 
-extern struct acpi_lis3lv02d lis3_dev;
+extern struct lis3lv02d lis3_dev;
_

Patches currently in -mm which might be from daniel@caiaq.de are

origin.patch
linux-next.patch
drivers-misc-isl29003c-driver-for-the-isl29003-ambient-light-sensor.patch
drivers-misc-isl29003c-driver-for-the-isl29003-ambient-light-sensor-fix.patch
hp_accel-add-two-more-axis-information.patch
lis3-reorder-functions-to-make-forward-decl-obsolete.patch
lis3-solve-dependency-between-core-and-acpi.patch
lis3-spi-transport-layer.patch
w1-coding-style-cleanups-in-w1_ioc.patch

