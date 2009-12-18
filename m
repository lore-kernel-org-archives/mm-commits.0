From: akpm@linux-foundation.org
Subject: [merged] hwmon-i2c-bus-support-for-lis3lv02d-and-variant-accelerometer-chips.patch removed from -mm tree
Date: Fri, 18 Dec 2009 12:26:13 -0800
Message-ID: <200912182026.nBIKQDnR016448@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48407 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932800AbZLRU0i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Dec 2009 15:26:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: samu.p.onkalo@nokia.com, eric.piel@tremplin-utc.net, kalhan.trisal@intel.com, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     hwmon: I2C bus support for lis3lv02d and variant accelerometer chi=
ps
has been removed from the -mm tree.  Its filename was
     hwmon-i2c-bus-support-for-lis3lv02d-and-variant-accelerometer-chip=
s.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: hwmon: I2C bus support for lis3lv02d and variant accelerometer=
 chips
=46rom: Samu Onkalo <samu.p.onkalo@nokia.com>

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: =C9ric Piel <eric.piel@tremplin-utc.net>
Cc: Kalhan Trisal <kalhan.trisal@intel.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/Kconfig         |   17 ++
 drivers/hwmon/Makefile        |    1=20
 drivers/hwmon/lis3lv02d_i2c.c |  183 ++++++++++++++++++++++++++++++++
 3 files changed, 201 insertions(+)

diff -puN drivers/hwmon/Kconfig~hwmon-i2c-bus-support-for-lis3lv02d-and=
-variant-accelerometer-chips drivers/hwmon/Kconfig
--- a/drivers/hwmon/Kconfig~hwmon-i2c-bus-support-for-lis3lv02d-and-var=
iant-accelerometer-chips
+++ a/drivers/hwmon/Kconfig
@@ -983,6 +983,23 @@ config SENSORS_LIS3_SPI
 	  will be called lis3lv02d and a specific module for the SPI transpor=
t
 	  is called lis3lv02d_spi.
=20
+config SENSORS_LIS3_I2C
+	tristate "STMicroeletronics LIS3LV02Dx three-axis digital acceleromet=
er (I2C)"
+	depends on I2C && INPUT
+	select INPUT_POLLDEV
+	default n
+	help
+	  This driver provides support for the LIS3LV02Dx accelerometer conne=
cted
+	  via I2C. The accelerometer data is readable via
+	  /sys/devices/platform/lis3lv02d.
+
+	  This driver also provides an absolute input class device, allowing
+	  the device to act as a pinball machine-esque joystick.
+
+	  This driver can also be built as modules.  If so, the core module
+	  will be called lis3lv02d and a specific module for the I2C transpor=
t
+	  is called lis3lv02d_i2c.
+
 config SENSORS_APPLESMC
 	tristate "Apple SMC (Motion sensor, light sensor, keyboard backlight)=
"
 	depends on INPUT && X86
diff -puN drivers/hwmon/Makefile~hwmon-i2c-bus-support-for-lis3lv02d-an=
d-variant-accelerometer-chips drivers/hwmon/Makefile
--- a/drivers/hwmon/Makefile~hwmon-i2c-bus-support-for-lis3lv02d-and-va=
riant-accelerometer-chips
+++ a/drivers/hwmon/Makefile
@@ -55,6 +55,7 @@ obj-$(CONFIG_SENSORS_IT87)	+=3D it87.o
 obj-$(CONFIG_SENSORS_K8TEMP)	+=3D k8temp.o
 obj-$(CONFIG_SENSORS_LIS3LV02D) +=3D lis3lv02d.o hp_accel.o
 obj-$(CONFIG_SENSORS_LIS3_SPI)	+=3D lis3lv02d.o lis3lv02d_spi.o
+obj-$(CONFIG_SENSORS_LIS3_I2C)	+=3D lis3lv02d.o lis3lv02d_i2c.o
 obj-$(CONFIG_SENSORS_LM63)	+=3D lm63.o
 obj-$(CONFIG_SENSORS_LM70)	+=3D lm70.o
 obj-$(CONFIG_SENSORS_LM75)	+=3D lm75.o
diff -puN /dev/null drivers/hwmon/lis3lv02d_i2c.c
--- /dev/null
+++ a/drivers/hwmon/lis3lv02d_i2c.c
@@ -0,0 +1,183 @@
+/*
+ * drivers/hwmon/lis3lv02d_i2c.c
+ *
+ * Implements I2C interface for lis3lv02d (STMicroelectronics) acceler=
ometer.
+ * Driver is based on corresponding SPI driver written by Daniel Mack
+ * (lis3lv02d_spi.c (C) 2009 Daniel Mack <daniel@caiaq.de> ).
+ *
+ * Copyright (C) 2009 Nokia Corporation and/or its subsidiary(-ies).
+ *
+ * Contact: Samu Onkalo <samu.p.onkalo@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include "lis3lv02d.h"
+
+#define DRV_NAME 	"lis3lv02d_i2c"
+
+static inline s32 lis3_i2c_write(struct lis3lv02d *lis3, int reg, u8 v=
alue)
+{
+	struct i2c_client *c =3D lis3->bus_priv;
+	return i2c_smbus_write_byte_data(c, reg, value);
+}
+
+static inline s32 lis3_i2c_read(struct lis3lv02d *lis3, int reg, u8 *v=
)
+{
+	struct i2c_client *c =3D lis3->bus_priv;
+	*v =3D i2c_smbus_read_byte_data(c, reg);
+	return 0;
+}
+
+static int lis3_i2c_init(struct lis3lv02d *lis3)
+{
+	u8 reg;
+	int ret;
+
+	/* power up the device */
+	ret =3D lis3->read(lis3, CTRL_REG1, &reg);
+	if (ret < 0)
+		return ret;
+
+	reg |=3D CTRL1_PD0;
+	return lis3->write(lis3, CTRL_REG1, reg);
+}
+
+/* Default axis mapping but it can be overwritten by platform data */
+static struct axis_conversion lis3lv02d_axis_map =3D { LIS3_DEV_X,
+						     LIS3_DEV_Y,
+						     LIS3_DEV_Z };
+
+static int __devinit lis3lv02d_i2c_probe(struct i2c_client *client,
+					const struct i2c_device_id *id)
+{
+	int ret =3D 0;
+	struct lis3lv02d_platform_data *pdata =3D client->dev.platform_data;
+
+	if (pdata) {
+		if (pdata->axis_x)
+			lis3lv02d_axis_map.x =3D pdata->axis_x;
+
+		if (pdata->axis_y)
+			lis3lv02d_axis_map.y =3D pdata->axis_y;
+
+		if (pdata->axis_z)
+			lis3lv02d_axis_map.z =3D pdata->axis_z;
+
+		if (pdata->setup_resources)
+			ret =3D pdata->setup_resources();
+
+		if (ret)
+			goto fail;
+	}
+
+	lis3_dev.pdata	  =3D pdata;
+	lis3_dev.bus_priv =3D client;
+	lis3_dev.init	  =3D lis3_i2c_init;
+	lis3_dev.read	  =3D lis3_i2c_read;
+	lis3_dev.write	  =3D lis3_i2c_write;
+	lis3_dev.irq	  =3D client->irq;
+	lis3_dev.ac	  =3D lis3lv02d_axis_map;
+
+	i2c_set_clientdata(client, &lis3_dev);
+	ret =3D lis3lv02d_init_device(&lis3_dev);
+fail:
+	return ret;
+}
+
+static int __devexit lis3lv02d_i2c_remove(struct i2c_client *client)
+{
+	struct lis3lv02d *lis3 =3D i2c_get_clientdata(client);
+	struct lis3lv02d_platform_data *pdata =3D client->dev.platform_data;
+
+	if (pdata && pdata->release_resources)
+		pdata->release_resources();
+
+	lis3lv02d_joystick_disable();
+	lis3lv02d_poweroff(lis3);
+
+	return lis3lv02d_remove_fs(&lis3_dev);
+}
+
+#ifdef CONFIG_PM
+static int lis3lv02d_i2c_suspend(struct i2c_client *client, pm_message=
_t mesg)
+{
+	struct lis3lv02d *lis3 =3D i2c_get_clientdata(client);
+
+	if (!lis3->pdata->wakeup_flags)
+		lis3lv02d_poweroff(lis3);
+	return 0;
+}
+
+static int lis3lv02d_i2c_resume(struct i2c_client *client)
+{
+	struct lis3lv02d *lis3 =3D i2c_get_clientdata(client);
+
+	if (!lis3->pdata->wakeup_flags)
+		lis3lv02d_poweron(lis3);
+	return 0;
+}
+
+static void lis3lv02d_i2c_shutdown(struct i2c_client *client)
+{
+	lis3lv02d_i2c_suspend(client, PMSG_SUSPEND);
+}
+#else
+#define lis3lv02d_i2c_suspend	NULL
+#define lis3lv02d_i2c_resume	NULL
+#define lis3lv02d_i2c_shutdown	NULL
+#endif
+
+static const struct i2c_device_id lis3lv02d_id[] =3D {
+	{"lis3lv02d", 0 },
+	{}
+};
+
+MODULE_DEVICE_TABLE(i2c, lis3lv02d_id);
+
+static struct i2c_driver lis3lv02d_i2c_driver =3D {
+	.driver	 =3D {
+		.name   =3D DRV_NAME,
+		.owner  =3D THIS_MODULE,
+	},
+	.suspend =3D lis3lv02d_i2c_suspend,
+	.shutdown =3D lis3lv02d_i2c_shutdown,
+	.resume =3D lis3lv02d_i2c_resume,
+	.probe	=3D lis3lv02d_i2c_probe,
+	.remove	=3D __devexit_p(lis3lv02d_i2c_remove),
+	.id_table =3D lis3lv02d_id,
+};
+
+static int __init lis3lv02d_init(void)
+{
+	return i2c_add_driver(&lis3lv02d_i2c_driver);
+}
+
+static void __exit lis3lv02d_exit(void)
+{
+	i2c_del_driver(&lis3lv02d_i2c_driver);
+}
+
+MODULE_AUTHOR("Nokia Corporation");
+MODULE_DESCRIPTION("lis3lv02d I2C interface");
+MODULE_LICENSE("GPL");
+
+module_init(lis3lv02d_init);
+module_exit(lis3lv02d_exit);
_

Patches currently in -mm which might be from samu.p.onkalo@nokia.com ar=
e


--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
