From: akpm@linux-foundation.org
Subject: + lis3lv02d-separate-the-core-from-hp-acpi-api.patch added to -mm tree
Date: Mon, 24 Nov 2008 13:22:48 -0800
Message-ID: <200811242122.mAOLMnan023176@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54365 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752918AbYKXVXD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Nov 2008 16:23:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eric.piel@tremplin-utc.net, pavel@suse.cz


The patch titled
     LIS3LV02D: separate the core from HP ACPI API
has been added to the -mm tree.  Its filename is
     lis3lv02d-separate-the-core-from-hp-acpi-api.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: LIS3LV02D: separate the core from HP ACPI API
=46rom: Eric Piel <eric.piel@tremplin-utc.net>

The sensor can be accessed via various buses.  In particular, SPI, I=C2=
=B2C
and, on HP laptops, via a specific ACPI API (the only one currently
supported).  Separate this latest platform from the core of the sensor
driver to allow support for the other bus type.  The second, and more
direct goal is actually to be able to merge this part with the
hp-disk-leds driver, which has the same ACPI PNP number.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/Makefile    |    2=20
 drivers/hwmon/hp_accel.c  |  265 ++++++++++++++++++++++++++++++++++
 drivers/hwmon/lis3lv02d.c |  273 +++---------------------------------
 drivers/hwmon/lis3lv02d.h |   35 ++++
 4 files changed, 324 insertions(+), 251 deletions(-)

diff -puN drivers/hwmon/Makefile~lis3lv02d-separate-the-core-from-hp-ac=
pi-api drivers/hwmon/Makefile
--- a/drivers/hwmon/Makefile~lis3lv02d-separate-the-core-from-hp-acpi-a=
pi
+++ a/drivers/hwmon/Makefile
@@ -49,7 +49,7 @@ obj-$(CONFIG_SENSORS_IBMAEM)	+=3D ibmaem.o
 obj-$(CONFIG_SENSORS_IBMPEX)	+=3D ibmpex.o
 obj-$(CONFIG_SENSORS_IT87)	+=3D it87.o
 obj-$(CONFIG_SENSORS_K8TEMP)	+=3D k8temp.o
-obj-$(CONFIG_SENSORS_LIS3LV02D) +=3D lis3lv02d.o
+obj-$(CONFIG_SENSORS_LIS3LV02D) +=3D lis3lv02d.o hp_accel.o
 obj-$(CONFIG_SENSORS_LM63)	+=3D lm63.o
 obj-$(CONFIG_SENSORS_LM70)	+=3D lm70.o
 obj-$(CONFIG_SENSORS_LM75)	+=3D lm75.o
diff -puN /dev/null drivers/hwmon/hp_accel.c
--- /dev/null
+++ a/drivers/hwmon/hp_accel.c
@@ -0,0 +1,265 @@
+/*
+ *  hp_accel.c - Interface between LIS3LV02DL driver and HP ACPI BIOS
+ *
+ *  Copyright (C) 2007-2008 Yan Burman
+ *  Copyright (C) 2008 Eric Piel
+ *  Copyright (C) 2008 Pavel Machek
+ *
+ *  This program is free software; you can redistribute it and/or modi=
fy
+ *  it under the terms of the GNU General Public License as published =
by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-13=
07  USA
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/dmi.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/input.h>
+#include <linux/kthread.h>
+#include <linux/semaphore.h>
+#include <linux/delay.h>
+#include <linux/wait.h>
+#include <linux/poll.h>
+#include <linux/freezer.h>
+#include <linux/version.h>
+#include <linux/uaccess.h>
+#include <acpi/acpi_drivers.h>
+#include <asm/atomic.h>
+#include "lis3lv02d.h"
+
+#define DRIVER_NAME     "lis3lv02d"
+#define ACPI_MDPS_CLASS "accelerometer"
+
+
+/* For automatic insertion of the module */
+static struct acpi_device_id lis3lv02d_device_ids[] =3D {
+	{"HPQ0004", 0}, /* HP Mobile Data Protection System PNP */
+	{"", 0},
+};
+MODULE_DEVICE_TABLE(acpi, lis3lv02d_device_ids);
+
+
+/**
+ * lis3lv02d_acpi_init - ACPI _INI method: initialize the device.
+ * @handle: the handle of the device
+ *
+ * Returns AE_OK on success.
+ */
+acpi_status lis3lv02d_acpi_init(acpi_handle handle)
+{
+	return acpi_evaluate_object(handle, METHOD_NAME__INI, NULL, NULL);
+}
+
+/**
+ * lis3lv02d_acpi_read - ACPI ALRD method: read a register
+ * @handle: the handle of the device
+ * @reg:    the register to read
+ * @ret:    result of the operation
+ *
+ * Returns AE_OK on success.
+ */
+acpi_status lis3lv02d_acpi_read(acpi_handle handle, int reg, u8 *ret)
+{
+	union acpi_object arg0 =3D { ACPI_TYPE_INTEGER };
+	struct acpi_object_list args =3D { 1, &arg0 };
+	unsigned long long lret;
+	acpi_status status;
+
+	arg0.integer.value =3D reg;
+
+	status =3D acpi_evaluate_integer(handle, "ALRD", &args, &lret);
+	*ret =3D lret;
+	return status;
+}
+
+/**
+ * lis3lv02d_acpi_write - ACPI ALWR method: write to a register
+ * @handle: the handle of the device
+ * @reg:    the register to write to
+ * @val:    the value to write
+ *
+ * Returns AE_OK on success.
+ */
+acpi_status lis3lv02d_acpi_write(acpi_handle handle, int reg, u8 val)
+{
+	unsigned long long ret; /* Not used when writting */
+	union acpi_object in_obj[2];
+	struct acpi_object_list args =3D { 2, in_obj };
+
+	in_obj[0].type          =3D ACPI_TYPE_INTEGER;
+	in_obj[0].integer.value =3D reg;
+	in_obj[1].type          =3D ACPI_TYPE_INTEGER;
+	in_obj[1].integer.value =3D val;
+
+	return acpi_evaluate_integer(handle, "ALWR", &args, &ret);
+}
+
+static int lis3lv02d_dmi_matched(const struct dmi_system_id *dmi)
+{
+	adev.ac =3D *((struct axis_conversion *)dmi->driver_data);
+	printk(KERN_INFO DRIVER_NAME ": hardware type %s found.\n", dmi->iden=
t);
+
+	return 1;
+}
+
+/* Represents, for each axis seen by userspace, the corresponding hw a=
xis (+1).
+ * If the value is negative, the opposite of the hw value is used. */
+static struct axis_conversion lis3lv02d_axis_normal =3D {1, 2, 3};
+static struct axis_conversion lis3lv02d_axis_y_inverted =3D {1, -2, 3}=
;
+static struct axis_conversion lis3lv02d_axis_x_inverted =3D {-1, 2, 3}=
;
+static struct axis_conversion lis3lv02d_axis_z_inverted =3D {1, 2, -3}=
;
+static struct axis_conversion lis3lv02d_axis_xy_rotated_left =3D {-2, =
1, 3};
+static struct axis_conversion lis3lv02d_axis_xy_swap_inverted =3D {-2,=
 -1, 3};
+
+#define AXIS_DMI_MATCH(_ident, _name, _axis) {		\
+	.ident =3D _ident,				\
+	.callback =3D lis3lv02d_dmi_matched,		\
+	.matches =3D {					\
+		DMI_MATCH(DMI_PRODUCT_NAME, _name)	\
+	},						\
+	.driver_data =3D &lis3lv02d_axis_##_axis		\
+}
+static struct dmi_system_id lis3lv02d_dmi_ids[] =3D {
+	/* product names are truncated to match all kinds of a same model */
+	AXIS_DMI_MATCH("NC64x0", "HP Compaq nc64", x_inverted),
+	AXIS_DMI_MATCH("NC84x0", "HP Compaq nc84", z_inverted),
+	AXIS_DMI_MATCH("NX9420", "HP Compaq nx9420", x_inverted),
+	AXIS_DMI_MATCH("NW9440", "HP Compaq nw9440", x_inverted),
+	AXIS_DMI_MATCH("NC2510", "HP Compaq 2510", y_inverted),
+	AXIS_DMI_MATCH("NC8510", "HP Compaq 8510", xy_swap_inverted),
+	AXIS_DMI_MATCH("HP2133", "HP 2133", xy_rotated_left),
+	{ NULL, }
+/* Laptop models without axis info (yet):
+ * "NC651xx" "HP Compaq 651"
+ * "NC671xx" "HP Compaq 671"
+ * "NC6910" "HP Compaq 6910"
+ * HP Compaq 8710x Notebook PC / Mobile Workstation
+ * "NC2400" "HP Compaq nc2400"
+ * "NX74x0" "HP Compaq nx74"
+ * "NX6325" "HP Compaq nx6325"
+ * "NC4400" "HP Compaq nc4400"
+ */
+};
+
+
+static int lis3lv02d_add(struct acpi_device *device)
+{
+	u8 val;
+
+	if (!device)
+		return -EINVAL;
+
+	adev.device =3D device;
+	adev.init =3D lis3lv02d_acpi_init;
+	adev.read =3D lis3lv02d_acpi_read;
+	adev.write =3D lis3lv02d_acpi_write;
+	strcpy(acpi_device_name(device), DRIVER_NAME);
+	strcpy(acpi_device_class(device), ACPI_MDPS_CLASS);
+	device->driver_data =3D &adev;
+
+	lis3lv02d_acpi_read(device->handle, WHO_AM_I, &val);
+	if ((val !=3D LIS3LV02DL_ID) && (val !=3D LIS302DL_ID)) {
+		printk(KERN_ERR DRIVER_NAME
+				": Accelerometer chip not LIS3LV02D{L,Q}\n");
+	}
+
+	/* If possible use a "standard" axes order */
+	if (dmi_check_system(lis3lv02d_dmi_ids) =3D=3D 0) {
+		printk(KERN_INFO DRIVER_NAME ": laptop model unknown, "
+				 "using default axes configuration\n");
+		adev.ac =3D lis3lv02d_axis_normal;
+	}
+
+	return lis3lv02d_init_device(&adev);
+}
+
+static int lis3lv02d_remove(struct acpi_device *device, int type)
+{
+	if (!device)
+		return -EINVAL;
+
+	lis3lv02d_joystick_disable();
+	lis3lv02d_poweroff(device->handle);
+
+	return lis3lv02d_remove_fs();
+}
+
+
+#ifdef CONFIG_PM
+static int lis3lv02d_suspend(struct acpi_device *device, pm_message_t =
state)
+{
+	/* make sure the device is off when we suspend */
+	lis3lv02d_poweroff(device->handle);
+	return 0;
+}
+
+static int lis3lv02d_resume(struct acpi_device *device)
+{
+	/* put back the device in the right state (ACPI might turn it on) */
+	mutex_lock(&adev.lock);
+	if (adev.usage > 0)
+		lis3lv02d_poweron(device->handle);
+	else
+		lis3lv02d_poweroff(device->handle);
+	mutex_unlock(&adev.lock);
+	return 0;
+}
+#else
+#define lis3lv02d_suspend NULL
+#define lis3lv02d_resume NULL
+#endif
+
+/* For the HP MDPS aka 3D Driveguard */
+static struct acpi_driver lis3lv02d_driver =3D {
+	.name  =3D DRIVER_NAME,
+	.class =3D ACPI_MDPS_CLASS,
+	.ids   =3D lis3lv02d_device_ids,
+	.ops =3D {
+		.add     =3D lis3lv02d_add,
+		.remove  =3D lis3lv02d_remove,
+		.suspend =3D lis3lv02d_suspend,
+		.resume  =3D lis3lv02d_resume,
+	}
+};
+
+static int __init lis3lv02d_init_module(void)
+{
+	int ret;
+
+	if (acpi_disabled)
+		return -ENODEV;
+
+	ret =3D acpi_bus_register_driver(&lis3lv02d_driver);
+	if (ret < 0)
+		return ret;
+
+	printk(KERN_INFO DRIVER_NAME " driver loaded.\n");
+
+	return 0;
+}
+
+static void __exit lis3lv02d_exit_module(void)
+{
+	acpi_bus_unregister_driver(&lis3lv02d_driver);
+}
+
+MODULE_DESCRIPTION("Glue between LIS3LV02Dx and HP ACPI BIOS");
+MODULE_AUTHOR("Yan Burman, Eric Piel, Pavel Machek");
+MODULE_LICENSE("GPL");
+
+module_init(lis3lv02d_init_module);
+module_exit(lis3lv02d_exit_module);
+
diff -puN drivers/hwmon/lis3lv02d.c~lis3lv02d-separate-the-core-from-hp=
-acpi-api drivers/hwmon/lis3lv02d.c
--- a/drivers/hwmon/lis3lv02d.c~lis3lv02d-separate-the-core-from-hp-acp=
i-api
+++ a/drivers/hwmon/lis3lv02d.c
@@ -3,6 +3,7 @@
  *
  *  Copyright (C) 2007-2008 Yan Burman
  *  Copyright (C) 2008 Eric Piel
+ *  Copyright (C) 2008 Pavel Machek
  *
  *  This program is free software; you can redistribute it and/or modi=
fy
  *  it under the terms of the GNU General Public License as published =
by
@@ -39,7 +40,6 @@
 #include "lis3lv02d.h"
=20
 #define DRIVER_NAME     "lis3lv02d"
-#define ACPI_MDPS_CLASS "accelerometer"
=20
 /* joystick device poll interval in milliseconds */
 #define MDPS_POLL_INTERVAL 50
@@ -55,100 +55,17 @@
 /* Maximum value our axis may get for the input device (signed 12 bits=
) */
 #define MDPS_MAX_VAL 2048
=20
-struct axis_conversion {
-	s8	x;
-	s8	y;
-	s8	z;
-};
-
-struct acpi_lis3lv02d {
-	struct acpi_device	*device;   /* The ACPI device */
-	struct input_dev	*idev;     /* input device */
-	struct task_struct	*kthread;  /* kthread for input */
-	struct mutex            lock;
-	struct platform_device	*pdev;     /* platform device */
-	atomic_t		count;     /* interrupt count after last read */
-	int			xcalib;    /* calibrated null value for x */
-	int			ycalib;    /* calibrated null value for y */
-	int			zcalib;    /* calibrated null value for z */
-	unsigned char		is_on;     /* whether the device is on or off */
-	unsigned char		usage;     /* usage counter */
-	struct axis_conversion	ac;        /* hw -> logical axis */
-};
+struct acpi_lis3lv02d adev;
+EXPORT_SYMBOL_GPL(adev);
=20
-static struct acpi_lis3lv02d adev;
-
-static int lis3lv02d_remove_fs(void);
 static int lis3lv02d_add_fs(struct acpi_device *device);
=20
-/* For automatic insertion of the module */
-static struct acpi_device_id lis3lv02d_device_ids[] =3D {
-	{"HPQ0004", 0}, /* HP Mobile Data Protection System PNP */
-	{"", 0},
-};
-MODULE_DEVICE_TABLE(acpi, lis3lv02d_device_ids);
-
-/**
- * lis3lv02d_acpi_init - ACPI _INI method: initialize the device.
- * @handle: the handle of the device
- *
- * Returns AE_OK on success.
- */
-static inline acpi_status lis3lv02d_acpi_init(acpi_handle handle)
-{
-	return acpi_evaluate_object(handle, METHOD_NAME__INI, NULL, NULL);
-}
-
-/**
- * lis3lv02d_acpi_read - ACPI ALRD method: read a register
- * @handle: the handle of the device
- * @reg:    the register to read
- * @ret:    result of the operation
- *
- * Returns AE_OK on success.
- */
-static acpi_status lis3lv02d_acpi_read(acpi_handle handle, int reg, u8=
 *ret)
-{
-	union acpi_object arg0 =3D { ACPI_TYPE_INTEGER };
-	struct acpi_object_list args =3D { 1, &arg0 };
-	unsigned long long lret;
-	acpi_status status;
-
-	arg0.integer.value =3D reg;
-
-	status =3D acpi_evaluate_integer(handle, "ALRD", &args, &lret);
-	*ret =3D lret;
-	return status;
-}
-
-/**
- * lis3lv02d_acpi_write - ACPI ALWR method: write to a register
- * @handle: the handle of the device
- * @reg:    the register to write to
- * @val:    the value to write
- *
- * Returns AE_OK on success.
- */
-static acpi_status lis3lv02d_acpi_write(acpi_handle handle, int reg, u=
8 val)
-{
-	unsigned long long ret; /* Not used when writting */
-	union acpi_object in_obj[2];
-	struct acpi_object_list args =3D { 2, in_obj };
-
-	in_obj[0].type          =3D ACPI_TYPE_INTEGER;
-	in_obj[0].integer.value =3D reg;
-	in_obj[1].type          =3D ACPI_TYPE_INTEGER;
-	in_obj[1].integer.value =3D val;
-
-	return acpi_evaluate_integer(handle, "ALWR", &args, &ret);
-}
-
 static s16 lis3lv02d_read_16(acpi_handle handle, int reg)
 {
 	u8 lo, hi;
=20
-	lis3lv02d_acpi_read(handle, reg, &lo);
-	lis3lv02d_acpi_read(handle, reg + 1, &hi);
+	adev.read(handle, reg, &lo);
+	adev.read(handle, reg + 1, &hi);
 	/* In "12 bit right justified" mode, bit 6, bit 7, bit 8 =3D bit 5 */
 	return (s16)((hi << 8) | lo);
 }
@@ -190,54 +107,31 @@ static void lis3lv02d_get_xyz(acpi_handl
 	*z =3D lis3lv02d_get_axis(adev.ac.z, position);
 }
=20
-static inline void lis3lv02d_poweroff(acpi_handle handle)
+void lis3lv02d_poweroff(acpi_handle handle)
 {
 	adev.is_on =3D 0;
 	/* disable X,Y,Z axis and power down */
-	lis3lv02d_acpi_write(handle, CTRL_REG1, 0x00);
+	adev.write(handle, CTRL_REG1, 0x00);
 }
+EXPORT_SYMBOL_GPL(lis3lv02d_poweroff);
=20
-static void lis3lv02d_poweron(acpi_handle handle)
+void lis3lv02d_poweron(acpi_handle handle)
 {
 	u8 val;
=20
 	adev.is_on =3D 1;
-	lis3lv02d_acpi_init(handle);
-	lis3lv02d_acpi_write(handle, FF_WU_CFG, 0);
+	adev.init(handle);
+	adev.write(handle, FF_WU_CFG, 0);
 	/*
 	 * BDU: LSB and MSB values are not updated until both have been read.
 	 *      So the value read will always be correct.
 	 * IEN: Interrupt for free-fall and DD, not for data-ready.
 	 */
-	lis3lv02d_acpi_read(handle, CTRL_REG2, &val);
+	adev.read(handle, CTRL_REG2, &val);
 	val |=3D CTRL2_BDU | CTRL2_IEN;
-	lis3lv02d_acpi_write(handle, CTRL_REG2, val);
-}
-
-#ifdef CONFIG_PM
-static int lis3lv02d_suspend(struct acpi_device *device, pm_message_t =
state)
-{
-	/* make sure the device is off when we suspend */
-	lis3lv02d_poweroff(device->handle);
-	return 0;
+	adev.write(handle, CTRL_REG2, val);
 }
-
-static int lis3lv02d_resume(struct acpi_device *device)
-{
-	/* put back the device in the right state (ACPI might turn it on) */
-	mutex_lock(&adev.lock);
-	if (adev.usage > 0)
-		lis3lv02d_poweron(device->handle);
-	else
-		lis3lv02d_poweroff(device->handle);
-	mutex_unlock(&adev.lock);
-	return 0;
-}
-#else
-#define lis3lv02d_suspend NULL
-#define lis3lv02d_resume NULL
-#endif
-
+EXPORT_SYMBOL_GPL(lis3lv02d_poweron);
=20
 /*
  * To be called before starting to use the device. It makes sure that =
the
@@ -315,7 +209,7 @@ static inline void lis3lv02d_calibrate_j
 	lis3lv02d_get_xyz(adev.device->handle, &adev.xcalib, &adev.ycalib, &a=
dev.zcalib);
 }
=20
-static int lis3lv02d_joystick_enable(void)
+int lis3lv02d_joystick_enable(void)
 {
 	int err;
=20
@@ -349,8 +243,9 @@ static int lis3lv02d_joystick_enable(voi
=20
 	return err;
 }
+EXPORT_SYMBOL_GPL(lis3lv02d_joystick_enable);
=20
-static void lis3lv02d_joystick_disable(void)
+void lis3lv02d_joystick_disable(void)
 {
 	if (!adev.idev)
 		return;
@@ -358,13 +253,13 @@ static void lis3lv02d_joystick_disable(v
 	input_unregister_device(adev.idev);
 	adev.idev =3D NULL;
 }
-
+EXPORT_SYMBOL_GPL(lis3lv02d_joystick_disable);
=20
 /*
  * Initialise the accelerometer and the various subsystems.
  * Should be rather independant of the bus system.
  */
-static int lis3lv02d_init_device(struct acpi_lis3lv02d *dev)
+int lis3lv02d_init_device(struct acpi_lis3lv02d *dev)
 {
 	mutex_init(&dev->lock);
 	lis3lv02d_add_fs(dev->device);
@@ -376,93 +271,7 @@ static int lis3lv02d_init_device(struct=20
 	lis3lv02d_decrease_use(dev);
 	return 0;
 }
-
-static int lis3lv02d_dmi_matched(const struct dmi_system_id *dmi)
-{
-	adev.ac =3D *((struct axis_conversion *)dmi->driver_data);
-	printk(KERN_INFO DRIVER_NAME ": hardware type %s found.\n", dmi->iden=
t);
-
-	return 1;
-}
-
-/* Represents, for each axis seen by userspace, the corresponding hw a=
xis (+1).
- * If the value is negative, the opposite of the hw value is used. */
-static struct axis_conversion lis3lv02d_axis_normal =3D {1, 2, 3};
-static struct axis_conversion lis3lv02d_axis_y_inverted =3D {1, -2, 3}=
;
-static struct axis_conversion lis3lv02d_axis_x_inverted =3D {-1, 2, 3}=
;
-static struct axis_conversion lis3lv02d_axis_z_inverted =3D {1, 2, -3}=
;
-static struct axis_conversion lis3lv02d_axis_xy_rotated_left =3D {-2, =
1, 3};
-static struct axis_conversion lis3lv02d_axis_xy_swap_inverted =3D {-2,=
 -1, 3};
-
-#define AXIS_DMI_MATCH(_ident, _name, _axis) {		\
-	.ident =3D _ident,				\
-	.callback =3D lis3lv02d_dmi_matched,		\
-	.matches =3D {					\
-		DMI_MATCH(DMI_PRODUCT_NAME, _name)	\
-	},						\
-	.driver_data =3D &lis3lv02d_axis_##_axis		\
-}
-static struct dmi_system_id lis3lv02d_dmi_ids[] =3D {
-	/* product names are truncated to match all kinds of a same model */
-	AXIS_DMI_MATCH("NC64x0", "HP Compaq nc64", x_inverted),
-	AXIS_DMI_MATCH("NC84x0", "HP Compaq nc84", z_inverted),
-	AXIS_DMI_MATCH("NX9420", "HP Compaq nx9420", x_inverted),
-	AXIS_DMI_MATCH("NW9440", "HP Compaq nw9440", x_inverted),
-	AXIS_DMI_MATCH("NC2510", "HP Compaq 2510", y_inverted),
-	AXIS_DMI_MATCH("NC8510", "HP Compaq 8510", xy_swap_inverted),
-	AXIS_DMI_MATCH("HP2133", "HP 2133", xy_rotated_left),
-	{ NULL, }
-/* Laptop models without axis info (yet):
- * "NC651xx" "HP Compaq 651"
- * "NC671xx" "HP Compaq 671"
- * "NC6910" "HP Compaq 6910"
- * HP Compaq 8710x Notebook PC / Mobile Workstation
- * "NC2400" "HP Compaq nc2400"
- * "NX74x0" "HP Compaq nx74"
- * "NX6325" "HP Compaq nx6325"
- * "NC4400" "HP Compaq nc4400"
- */
-};
-
-static int lis3lv02d_add(struct acpi_device *device)
-{
-	u8 val;
-
-	if (!device)
-		return -EINVAL;
-
-	adev.device =3D device;
-	strcpy(acpi_device_name(device), DRIVER_NAME);
-	strcpy(acpi_device_class(device), ACPI_MDPS_CLASS);
-	device->driver_data =3D &adev;
-
-	lis3lv02d_acpi_read(device->handle, WHO_AM_I, &val);
-	if ((val !=3D LIS3LV02DL_ID) && (val !=3D LIS302DL_ID)) {
-		printk(KERN_ERR DRIVER_NAME
-				": Accelerometer chip not LIS3LV02D{L,Q}\n");
-	}
-
-	/* If possible use a "standard" axes order */
-	if (dmi_check_system(lis3lv02d_dmi_ids) =3D=3D 0) {
-		printk(KERN_INFO DRIVER_NAME ": laptop model unknown, "
-				 "using default axes configuration\n");
-		adev.ac =3D lis3lv02d_axis_normal;
-	}
-
-	return lis3lv02d_init_device(&adev);
-}
-
-static int lis3lv02d_remove(struct acpi_device *device, int type)
-{
-	if (!device)
-		return -EINVAL;
-
-	lis3lv02d_joystick_disable();
-	lis3lv02d_poweroff(device->handle);
-
-	return lis3lv02d_remove_fs();
-}
-
+EXPORT_SYMBOL_GPL(lis3lv02d_init_device);
=20
 /* Sysfs stuff */
 static ssize_t lis3lv02d_position_show(struct device *dev,
@@ -501,7 +310,7 @@ static ssize_t lis3lv02d_rate_show(struc
 	int val;
=20
 	lis3lv02d_increase_use(&adev);
-	lis3lv02d_acpi_read(adev.device->handle, CTRL_REG1, &ctrl);
+	adev.read(adev.device->handle, CTRL_REG1, &ctrl);
 	lis3lv02d_decrease_use(&adev);
 	val =3D (ctrl & (CTRL1_DF0 | CTRL1_DF1)) >> 4;
 	return sprintf(buf, "%d\n", lis3lv02dl_df_val[val]);
@@ -523,6 +332,7 @@ static struct attribute_group lis3lv02d_
 	.attrs =3D lis3lv02d_attributes
 };
=20
+
 static int lis3lv02d_add_fs(struct acpi_device *device)
 {
 	adev.pdev =3D platform_device_register_simple(DRIVER_NAME, -1, NULL, =
0);
@@ -532,50 +342,15 @@ static int lis3lv02d_add_fs(struct acpi_
 	return sysfs_create_group(&adev.pdev->dev.kobj, &lis3lv02d_attribute_=
group);
 }
=20
-static int lis3lv02d_remove_fs(void)
+int lis3lv02d_remove_fs(void)
 {
 	sysfs_remove_group(&adev.pdev->dev.kobj, &lis3lv02d_attribute_group);
 	platform_device_unregister(adev.pdev);
 	return 0;
 }
-
-/* For the HP MDPS aka 3D Driveguard */
-static struct acpi_driver lis3lv02d_driver =3D {
-	.name  =3D DRIVER_NAME,
-	.class =3D ACPI_MDPS_CLASS,
-	.ids   =3D lis3lv02d_device_ids,
-	.ops =3D {
-		.add     =3D lis3lv02d_add,
-		.remove  =3D lis3lv02d_remove,
-		.suspend =3D lis3lv02d_suspend,
-		.resume  =3D lis3lv02d_resume,
-	}
-};
-
-static int __init lis3lv02d_init_module(void)
-{
-	int ret;
-
-	if (acpi_disabled)
-		return -ENODEV;
-
-	ret =3D acpi_bus_register_driver(&lis3lv02d_driver);
-	if (ret < 0)
-		return ret;
-
-	printk(KERN_INFO DRIVER_NAME " driver loaded.\n");
-
-	return 0;
-}
-
-static void __exit lis3lv02d_exit_module(void)
-{
-	acpi_bus_unregister_driver(&lis3lv02d_driver);
-}
+EXPORT_SYMBOL_GPL(lis3lv02d_remove_fs);
=20
 MODULE_DESCRIPTION("ST LIS3LV02Dx three-axis digital accelerometer dri=
ver");
 MODULE_AUTHOR("Yan Burman and Eric Piel");
 MODULE_LICENSE("GPL");
=20
-module_init(lis3lv02d_init_module);
-module_exit(lis3lv02d_exit_module);
diff -puN drivers/hwmon/lis3lv02d.h~lis3lv02d-separate-the-core-from-hp=
-acpi-api drivers/hwmon/lis3lv02d.h
--- a/drivers/hwmon/lis3lv02d.h~lis3lv02d-separate-the-core-from-hp-acp=
i-api
+++ a/drivers/hwmon/lis3lv02d.h
@@ -23,7 +23,7 @@
  * The actual chip is STMicroelectronics LIS3LV02DL or LIS3LV02DQ that=
 seems to
  * be connected via SPI. There exists also several similar chips (such=
 as LIS302DL or
  * LIS3L02DQ) but not in the HP laptops and they have slightly differe=
nt registers.
- * They can also be connected via I=C3=82=CB=9BC.
+ * They can also be connected via I=C2=B2C.
  */
=20
 #define LIS3LV02DL_ID	0x3A /* Also the LIS3LV02DQ */
@@ -147,3 +147,36 @@ enum lis3lv02d_dd_src {
 	DD_SRC_IA	=3D 0x40,
 };
=20
+struct axis_conversion {
+	s8	x;
+	s8	y;
+	s8	z;
+};
+
+struct acpi_lis3lv02d {
+	struct acpi_device	*device;   /* The ACPI device */
+	acpi_status (*init) (acpi_handle handle);
+	acpi_status (*write) (acpi_handle handle, int reg, u8 val);
+	acpi_status (*read) (acpi_handle handle, int reg, u8 *ret);
+
+	struct input_dev	*idev;     /* input device */
+	struct task_struct	*kthread;  /* kthread for input */
+	struct mutex            lock;
+	struct platform_device	*pdev;     /* platform device */
+	atomic_t		count;     /* interrupt count after last read */
+	int			xcalib;    /* calibrated null value for x */
+	int			ycalib;    /* calibrated null value for y */
+	int			zcalib;    /* calibrated null value for z */
+	unsigned char		is_on;     /* whether the device is on or off */
+	unsigned char		usage;     /* usage counter */
+	struct axis_conversion	ac;        /* hw -> logical axis */
+};
+
+int lis3lv02d_init_device(struct acpi_lis3lv02d *dev);
+int lis3lv02d_joystick_enable(void);
+void lis3lv02d_joystick_disable(void);
+void lis3lv02d_poweroff(acpi_handle handle);
+void lis3lv02d_poweron(acpi_handle handle);
+int lis3lv02d_remove_fs(void);
+
+extern struct acpi_lis3lv02d adev;
_

Patches currently in -mm which might be from eric.piel@tremplin-utc.net=
 are

lis3lv02d-separate-the-core-from-hp-acpi-api.patch
lis3lv02d-merge-with-leds-hp-disk.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
