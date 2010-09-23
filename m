From: akpm@linux-foundation.org
Subject: + lis3-add-axes-module-parameter-for-custom-axis-mapping.patch added to -mm tree
Date: Thu, 23 Sep 2010 12:23:15 -0700
Message-ID: <201009231923.o8NJNFTi013974@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46854 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754939Ab0IWTXe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Sep 2010 15:23:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tiwai@suse.de, khali@linux-fr.org


The patch titled
     lis3: add axes module parameter for custom axis-mapping
has been added to the -mm tree.  Its filename is
     lis3-add-axes-module-parameter-for-custom-axis-mapping.patch

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
Subject: lis3: add axes module parameter for custom axis-mapping
From: Takashi Iwai <tiwai@suse.de>

The axis-mapping of lis3dev device on many (rather most) HP machines
doesn't follow the standard.  When each new model appears, users need to
adjust again.  Testing this requires the rebuild of kernel, thus it's not
trivial for end-users.

This patch adds a module parameter "axes" to allow a custom axis-mapping
without patching and recompiling the kernel driver.  User can pass the
parameter such as axes=3,2,1.  Also it can be changed via sysfs.

Eric Piel <eric.piel@tremplin-utc.net>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/hp_accel.c      |   35 +++++++++++++++++--------------
 drivers/hwmon/lis3lv02d.c     |   36 ++++++++++++++++++++++++++------
 drivers/hwmon/lis3lv02d.h     |    8 -------
 drivers/hwmon/lis3lv02d_i2c.c |   12 ++++------
 4 files changed, 56 insertions(+), 35 deletions(-)

diff -puN drivers/hwmon/hp_accel.c~lis3-add-axes-module-parameter-for-custom-axis-mapping drivers/hwmon/hp_accel.c
--- a/drivers/hwmon/hp_accel.c~lis3-add-axes-module-parameter-for-custom-axis-mapping
+++ a/drivers/hwmon/hp_accel.c
@@ -146,7 +146,8 @@ int lis3lv02d_acpi_write(struct lis3lv02
 
 static int lis3lv02d_dmi_matched(const struct dmi_system_id *dmi)
 {
-	lis3_dev.ac = *((struct axis_conversion *)dmi->driver_data);
+	memcpy(lis3_dev.axis_map, (int *)dmi->driver_data,
+	       sizeof(lis3_dev.axis_map));
 	printk(KERN_INFO DRIVER_NAME ": hardware type %s found.\n", dmi->ident);
 
 	return 1;
@@ -154,16 +155,16 @@ static int lis3lv02d_dmi_matched(const s
 
 /* Represents, for each axis seen by userspace, the corresponding hw axis (+1).
  * If the value is negative, the opposite of the hw value is used. */
-static struct axis_conversion lis3lv02d_axis_normal = {1, 2, 3};
-static struct axis_conversion lis3lv02d_axis_y_inverted = {1, -2, 3};
-static struct axis_conversion lis3lv02d_axis_x_inverted = {-1, 2, 3};
-static struct axis_conversion lis3lv02d_axis_z_inverted = {1, 2, -3};
-static struct axis_conversion lis3lv02d_axis_xy_swap = {2, 1, 3};
-static struct axis_conversion lis3lv02d_axis_xy_rotated_left = {-2, 1, 3};
-static struct axis_conversion lis3lv02d_axis_xy_rotated_left_usd = {-2, 1, -3};
-static struct axis_conversion lis3lv02d_axis_xy_swap_inverted = {-2, -1, 3};
-static struct axis_conversion lis3lv02d_axis_xy_rotated_right = {2, -1, 3};
-static struct axis_conversion lis3lv02d_axis_xy_swap_yz_inverted = {2, -1, -3};
+static int lis3lv02d_axis_normal[3] = {1, 2, 3};
+static int lis3lv02d_axis_y_inverted[3] = {1, -2, 3};
+static int lis3lv02d_axis_x_inverted[3] = {-1, 2, 3};
+static int lis3lv02d_axis_z_inverted[3] = {1, 2, -3};
+static int lis3lv02d_axis_xy_swap[3] = {2, 1, 3};
+static int lis3lv02d_axis_xy_rotated_left[3] = {-2, 1, 3};
+static int lis3lv02d_axis_xy_rotated_left_usd[3] = {-2, 1, -3};
+static int lis3lv02d_axis_xy_swap_inverted[3] = {-2, -1, 3};
+static int lis3lv02d_axis_xy_rotated_right[3] = {2, -1, 3};
+static int lis3lv02d_axis_xy_swap_yz_inverted[3] = {2, -1, -3};
 
 #define AXIS_DMI_MATCH(_ident, _name, _axis) {		\
 	.ident = _ident,				\
@@ -171,7 +172,7 @@ static struct axis_conversion lis3lv02d_
 	.matches = {					\
 		DMI_MATCH(DMI_PRODUCT_NAME, _name)	\
 	},						\
-	.driver_data = &lis3lv02d_axis_##_axis		\
+	.driver_data = lis3lv02d_axis_##_axis		\
 }
 
 #define AXIS_DMI_MATCH2(_ident, _class1, _name1,	\
@@ -183,7 +184,7 @@ static struct axis_conversion lis3lv02d_
 		DMI_MATCH(DMI_##_class1, _name1),	\
 		DMI_MATCH(DMI_##_class2, _name2),	\
 	},						\
-	.driver_data = &lis3lv02d_axis_##_axis		\
+	.driver_data = lis3lv02d_axis_##_axis		\
 }
 static struct dmi_system_id lis3lv02d_dmi_ids[] = {
 	/* product names are truncated to match all kinds of a same model */
@@ -299,10 +300,14 @@ static int lis3lv02d_add(struct acpi_dev
 	lis3lv02d_enum_resources(device);
 
 	/* If possible use a "standard" axes order */
-	if (dmi_check_system(lis3lv02d_dmi_ids) == 0) {
+	if (lis3_dev.axis_map[0] && lis3_dev.axis_map[1] && lis3_dev.axis_map[2]) {
+		printk(KERN_INFO DRIVER_NAME ": Using custom axes %d,%d,%d\n",
+		       lis3_dev.axis_map[0], lis3_dev.axis_map[1], lis3_dev.axis_map[2]);
+	} else if (dmi_check_system(lis3lv02d_dmi_ids) == 0) {
 		printk(KERN_INFO DRIVER_NAME ": laptop model unknown, "
 				 "using default axes configuration\n");
-		lis3_dev.ac = lis3lv02d_axis_normal;
+		memcpy(lis3_dev.axis_map, lis3lv02d_axis_normal,
+		       sizeof(lis3_dev.axis_map));
 	}
 
 	/* call the core layer do its init */
diff -puN drivers/hwmon/lis3lv02d.c~lis3-add-axes-module-parameter-for-custom-axis-mapping drivers/hwmon/lis3lv02d.c
--- a/drivers/hwmon/lis3lv02d.c~lis3-add-axes-module-parameter-for-custom-axis-mapping
+++ a/drivers/hwmon/lis3lv02d.c
@@ -75,6 +75,30 @@ struct lis3lv02d lis3_dev = {
 
 EXPORT_SYMBOL_GPL(lis3_dev);
 
+/* just like param_set_int() but does sanity-check so that it won't point
+ * over the axis array size
+ */
+static int param_set_axis(const char *val, const struct kernel_param *kp)
+{
+	int ret = param_set_int(val, kp);
+	if (!ret) {
+		int val = *(int *)kp->arg;
+		if (val < 0)
+			val = -val;
+		if (!val || val > 3)
+			return -EINVAL;
+	}
+	return ret;
+}
+
+static struct kernel_param_ops param_ops_axis = {
+	.set = param_set_axis,
+	.get = param_get_int,
+};
+
+module_param_array_named(axes, lis3_dev.axis_map, axis, NULL, 0644);
+MODULE_PARM_DESC(axes, "Axis-mapping for x,y,z directions");
+
 static s16 lis3lv02d_read_8(struct lis3lv02d *lis3, int reg)
 {
 	s8 lo;
@@ -130,9 +154,9 @@ static void lis3lv02d_get_xyz(struct lis
 	for (i = 0; i < 3; i++)
 		position[i] = (position[i] * lis3->scale) / LIS3_ACCURACY;
 
-	*x = lis3lv02d_get_axis(lis3->ac.x, position);
-	*y = lis3lv02d_get_axis(lis3->ac.y, position);
-	*z = lis3lv02d_get_axis(lis3->ac.z, position);
+	*x = lis3lv02d_get_axis(lis3->axis_map[0], position);
+	*y = lis3lv02d_get_axis(lis3->axis_map[1], position);
+	*z = lis3lv02d_get_axis(lis3->axis_map[2], position);
 }
 
 /* conversion btw sampling rate and the register values */
@@ -479,9 +503,9 @@ int lis3lv02d_joystick_enable(void)
 	input_set_abs_params(input_dev, ABS_Y, -max_val, max_val, fuzz, flat);
 	input_set_abs_params(input_dev, ABS_Z, -max_val, max_val, fuzz, flat);
 
-	lis3_dev.mapped_btns[0] = lis3lv02d_get_axis(abs(lis3_dev.ac.x), btns);
-	lis3_dev.mapped_btns[1] = lis3lv02d_get_axis(abs(lis3_dev.ac.y), btns);
-	lis3_dev.mapped_btns[2] = lis3lv02d_get_axis(abs(lis3_dev.ac.z), btns);
+	lis3_dev.mapped_btns[0] = lis3lv02d_get_axis(abs(lis3_dev.axis_map[0]), btns);
+	lis3_dev.mapped_btns[1] = lis3lv02d_get_axis(abs(lis3_dev.axis_map[1]), btns);
+	lis3_dev.mapped_btns[2] = lis3lv02d_get_axis(abs(lis3_dev.axis_map[2]), btns);
 
 	err = input_register_polled_device(lis3_dev.idev);
 	if (err) {
diff -puN drivers/hwmon/lis3lv02d.h~lis3-add-axes-module-parameter-for-custom-axis-mapping drivers/hwmon/lis3lv02d.h
--- a/drivers/hwmon/lis3lv02d.h~lis3-add-axes-module-parameter-for-custom-axis-mapping
+++ a/drivers/hwmon/lis3lv02d.h
@@ -206,12 +206,6 @@ enum lis3lv02d_click_src_8b {
 	CLICK_IA	= 0x40,
 };
 
-struct axis_conversion {
-	s8	x;
-	s8	y;
-	s8	z;
-};
-
 struct lis3lv02d {
 	void			*bus_priv; /* used by the bus layer only */
 	int (*init) (struct lis3lv02d *lis3);
@@ -232,7 +226,7 @@ struct lis3lv02d {
 	struct input_polled_dev	*idev;     /* input device */
 	struct platform_device	*pdev;     /* platform device */
 	atomic_t		count;     /* interrupt count after last read */
-	struct axis_conversion	ac;        /* hw -> logical axis */
+	int			axis_map[3];  /* hw -> logical axis */
 	int			mapped_btns[3];
 
 	u32			irq;       /* IRQ number */
diff -puN drivers/hwmon/lis3lv02d_i2c.c~lis3-add-axes-module-parameter-for-custom-axis-mapping drivers/hwmon/lis3lv02d_i2c.c
--- a/drivers/hwmon/lis3lv02d_i2c.c~lis3-add-axes-module-parameter-for-custom-axis-mapping
+++ a/drivers/hwmon/lis3lv02d_i2c.c
@@ -61,9 +61,7 @@ static int lis3_i2c_init(struct lis3lv02
 }
 
 /* Default axis mapping but it can be overwritten by platform data */
-static struct axis_conversion lis3lv02d_axis_map = { LIS3_DEV_X,
-						     LIS3_DEV_Y,
-						     LIS3_DEV_Z };
+static int lis3lv02d_axis_map[3] = { LIS3_DEV_X, LIS3_DEV_Y, LIS3_DEV_Z };
 
 static int __devinit lis3lv02d_i2c_probe(struct i2c_client *client,
 					const struct i2c_device_id *id)
@@ -73,13 +71,13 @@ static int __devinit lis3lv02d_i2c_probe
 
 	if (pdata) {
 		if (pdata->axis_x)
-			lis3lv02d_axis_map.x = pdata->axis_x;
+			lis3lv02d_axis_map[0] = pdata->axis_x;
 
 		if (pdata->axis_y)
-			lis3lv02d_axis_map.y = pdata->axis_y;
+			lis3lv02d_axis_map[1] = pdata->axis_y;
 
 		if (pdata->axis_z)
-			lis3lv02d_axis_map.z = pdata->axis_z;
+			lis3lv02d_axis_map[2] = pdata->axis_z;
 
 		if (pdata->setup_resources)
 			ret = pdata->setup_resources();
@@ -94,7 +92,7 @@ static int __devinit lis3lv02d_i2c_probe
 	lis3_dev.read	  = lis3_i2c_read;
 	lis3_dev.write	  = lis3_i2c_write;
 	lis3_dev.irq	  = client->irq;
-	lis3_dev.ac	  = lis3lv02d_axis_map;
+	memcpy(&lis3_dev.axis_map, &lis3lv02d_axis_map, sizeof(lis3_dev.axis_map));
 
 	i2c_set_clientdata(client, &lis3_dev);
 	ret = lis3lv02d_init_device(&lis3_dev);
_

Patches currently in -mm which might be from tiwai@suse.de are

linux-next.patch
lis3-add-axes-module-parameter-for-custom-axis-mapping.patch

