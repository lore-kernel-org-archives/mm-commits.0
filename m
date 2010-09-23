From: akpm@linux-foundation.org
Subject: + lis3-add-axes-module-parameter-for-custom-axis-mapping-update.patch added to -mm tree
Date: Thu, 23 Sep 2010 13:45:25 -0700
Message-ID: <201009232045.o8NKjPHF017958@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33290 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754503Ab0IWUpl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Sep 2010 16:45:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tiwai@suse.de, eric.piel@tremplin-utc.net, khali@linux-fr.org


The patch titled
     lis3-add-axes-module-parameter-for-custom-axis-mapping-update
has been added to the -mm tree.  Its filename is
     lis3-add-axes-module-parameter-for-custom-axis-mapping-update.patch

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
Subject: lis3-add-axes-module-parameter-for-custom-axis-mapping-update
From: Takashi Iwai <tiwai@suse.de>

v3->v4: use union for axis_mapping to be type-safe

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: Eric Piel <eric.piel@tremplin-utc.net>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/hp_accel.c      |   37 ++++++++++++++++----------------
 drivers/hwmon/lis3lv02d.c     |   14 ++++++------
 drivers/hwmon/lis3lv02d.h     |    9 ++++++-
 drivers/hwmon/lis3lv02d_i2c.c |   11 +++++----
 drivers/hwmon/lis3lv02d_spi.c |    3 +-
 5 files changed, 42 insertions(+), 32 deletions(-)

diff -puN drivers/hwmon/hp_accel.c~lis3-add-axes-module-parameter-for-custom-axis-mapping-update drivers/hwmon/hp_accel.c
--- a/drivers/hwmon/hp_accel.c~lis3-add-axes-module-parameter-for-custom-axis-mapping-update
+++ a/drivers/hwmon/hp_accel.c
@@ -146,8 +146,7 @@ int lis3lv02d_acpi_write(struct lis3lv02
 
 static int lis3lv02d_dmi_matched(const struct dmi_system_id *dmi)
 {
-	memcpy(lis3_dev.axis_map, (int *)dmi->driver_data,
-	       sizeof(lis3_dev.axis_map));
+	lis3_dev.ac = *((union axis_conversion *)dmi->driver_data);
 	printk(KERN_INFO DRIVER_NAME ": hardware type %s found.\n", dmi->ident);
 
 	return 1;
@@ -155,16 +154,19 @@ static int lis3lv02d_dmi_matched(const s
 
 /* Represents, for each axis seen by userspace, the corresponding hw axis (+1).
  * If the value is negative, the opposite of the hw value is used. */
-static int lis3lv02d_axis_normal[3] = {1, 2, 3};
-static int lis3lv02d_axis_y_inverted[3] = {1, -2, 3};
-static int lis3lv02d_axis_x_inverted[3] = {-1, 2, 3};
-static int lis3lv02d_axis_z_inverted[3] = {1, 2, -3};
-static int lis3lv02d_axis_xy_swap[3] = {2, 1, 3};
-static int lis3lv02d_axis_xy_rotated_left[3] = {-2, 1, 3};
-static int lis3lv02d_axis_xy_rotated_left_usd[3] = {-2, 1, -3};
-static int lis3lv02d_axis_xy_swap_inverted[3] = {-2, -1, 3};
-static int lis3lv02d_axis_xy_rotated_right[3] = {2, -1, 3};
-static int lis3lv02d_axis_xy_swap_yz_inverted[3] = {2, -1, -3};
+#define DEFINE_CONV(name, x, y, z)			      \
+	static union axis_conversion lis3lv02d_axis_##name = \
+		{ .as_array = { x, y, z } }
+DEFINE_CONV(normal, 1, 2, 3);
+DEFINE_CONV(y_inverted, 1, -2, 3);
+DEFINE_CONV(x_inverted, -1, 2, 3);
+DEFINE_CONV(z_inverted, 1, 2, -3);
+DEFINE_CONV(xy_swap, 2, 1, 3);
+DEFINE_CONV(xy_rotated_left, -2, 1, 3);
+DEFINE_CONV(xy_rotated_left_usd, -2, 1, -3);
+DEFINE_CONV(xy_swap_inverted, -2, -1, 3);
+DEFINE_CONV(xy_rotated_right, 2, -1, 3);
+DEFINE_CONV(xy_swap_yz_inverted, 2, -1, -3);
 
 #define AXIS_DMI_MATCH(_ident, _name, _axis) {		\
 	.ident = _ident,				\
@@ -172,7 +174,7 @@ static int lis3lv02d_axis_xy_swap_yz_inv
 	.matches = {					\
 		DMI_MATCH(DMI_PRODUCT_NAME, _name)	\
 	},						\
-	.driver_data = lis3lv02d_axis_##_axis		\
+	.driver_data = &lis3lv02d_axis_##_axis		\
 }
 
 #define AXIS_DMI_MATCH2(_ident, _class1, _name1,	\
@@ -184,7 +186,7 @@ static int lis3lv02d_axis_xy_swap_yz_inv
 		DMI_MATCH(DMI_##_class1, _name1),	\
 		DMI_MATCH(DMI_##_class2, _name2),	\
 	},						\
-	.driver_data = lis3lv02d_axis_##_axis		\
+	.driver_data = &lis3lv02d_axis_##_axis		\
 }
 static struct dmi_system_id lis3lv02d_dmi_ids[] = {
 	/* product names are truncated to match all kinds of a same model */
@@ -300,14 +302,13 @@ static int lis3lv02d_add(struct acpi_dev
 	lis3lv02d_enum_resources(device);
 
 	/* If possible use a "standard" axes order */
-	if (lis3_dev.axis_map[0] && lis3_dev.axis_map[1] && lis3_dev.axis_map[2]) {
+	if (lis3_dev.ac.x && lis3_dev.ac.y && lis3_dev.ac.z) {
 		printk(KERN_INFO DRIVER_NAME ": Using custom axes %d,%d,%d\n",
-		       lis3_dev.axis_map[0], lis3_dev.axis_map[1], lis3_dev.axis_map[2]);
+		       lis3_dev.ac.x, lis3_dev.ac.y, lis3_dev.ac.z);
 	} else if (dmi_check_system(lis3lv02d_dmi_ids) == 0) {
 		printk(KERN_INFO DRIVER_NAME ": laptop model unknown, "
 				 "using default axes configuration\n");
-		memcpy(lis3_dev.axis_map, lis3lv02d_axis_normal,
-		       sizeof(lis3_dev.axis_map));
+		lis3_dev.ac = lis3lv02d_axis_normal;
 	}
 
 	/* call the core layer do its init */
diff -puN drivers/hwmon/lis3lv02d.c~lis3-add-axes-module-parameter-for-custom-axis-mapping-update drivers/hwmon/lis3lv02d.c
--- a/drivers/hwmon/lis3lv02d.c~lis3-add-axes-module-parameter-for-custom-axis-mapping-update
+++ a/drivers/hwmon/lis3lv02d.c
@@ -96,7 +96,7 @@ static struct kernel_param_ops param_ops
 	.get = param_get_int,
 };
 
-module_param_array_named(axes, lis3_dev.axis_map, axis, NULL, 0644);
+module_param_array_named(axes, lis3_dev.ac.as_array, axis, NULL, 0644);
 MODULE_PARM_DESC(axes, "Axis-mapping for x,y,z directions");
 
 static s16 lis3lv02d_read_8(struct lis3lv02d *lis3, int reg)
@@ -154,9 +154,9 @@ static void lis3lv02d_get_xyz(struct lis
 	for (i = 0; i < 3; i++)
 		position[i] = (position[i] * lis3->scale) / LIS3_ACCURACY;
 
-	*x = lis3lv02d_get_axis(lis3->axis_map[0], position);
-	*y = lis3lv02d_get_axis(lis3->axis_map[1], position);
-	*z = lis3lv02d_get_axis(lis3->axis_map[2], position);
+	*x = lis3lv02d_get_axis(lis3->ac.x, position);
+	*y = lis3lv02d_get_axis(lis3->ac.y, position);
+	*z = lis3lv02d_get_axis(lis3->ac.z, position);
 }
 
 /* conversion btw sampling rate and the register values */
@@ -503,9 +503,9 @@ int lis3lv02d_joystick_enable(void)
 	input_set_abs_params(input_dev, ABS_Y, -max_val, max_val, fuzz, flat);
 	input_set_abs_params(input_dev, ABS_Z, -max_val, max_val, fuzz, flat);
 
-	lis3_dev.mapped_btns[0] = lis3lv02d_get_axis(abs(lis3_dev.axis_map[0]), btns);
-	lis3_dev.mapped_btns[1] = lis3lv02d_get_axis(abs(lis3_dev.axis_map[1]), btns);
-	lis3_dev.mapped_btns[2] = lis3lv02d_get_axis(abs(lis3_dev.axis_map[2]), btns);
+	lis3_dev.mapped_btns[0] = lis3lv02d_get_axis(abs(lis3_dev.ac.x), btns);
+	lis3_dev.mapped_btns[1] = lis3lv02d_get_axis(abs(lis3_dev.ac.y), btns);
+	lis3_dev.mapped_btns[2] = lis3lv02d_get_axis(abs(lis3_dev.ac.z), btns);
 
 	err = input_register_polled_device(lis3_dev.idev);
 	if (err) {
diff -puN drivers/hwmon/lis3lv02d.h~lis3-add-axes-module-parameter-for-custom-axis-mapping-update drivers/hwmon/lis3lv02d.h
--- a/drivers/hwmon/lis3lv02d.h~lis3-add-axes-module-parameter-for-custom-axis-mapping-update
+++ a/drivers/hwmon/lis3lv02d.h
@@ -206,6 +206,13 @@ enum lis3lv02d_click_src_8b {
 	CLICK_IA	= 0x40,
 };
 
+union axis_conversion {
+	struct {
+		int x, y, z;
+	};
+	int as_array[3];
+};
+
 struct lis3lv02d {
 	void			*bus_priv; /* used by the bus layer only */
 	int (*init) (struct lis3lv02d *lis3);
@@ -226,7 +233,7 @@ struct lis3lv02d {
 	struct input_polled_dev	*idev;     /* input device */
 	struct platform_device	*pdev;     /* platform device */
 	atomic_t		count;     /* interrupt count after last read */
-	int			axis_map[3];  /* hw -> logical axis */
+	union axis_conversion	ac;        /* hw -> logical axis */
 	int			mapped_btns[3];
 
 	u32			irq;       /* IRQ number */
diff -puN drivers/hwmon/lis3lv02d_i2c.c~lis3-add-axes-module-parameter-for-custom-axis-mapping-update drivers/hwmon/lis3lv02d_i2c.c
--- a/drivers/hwmon/lis3lv02d_i2c.c~lis3-add-axes-module-parameter-for-custom-axis-mapping-update
+++ a/drivers/hwmon/lis3lv02d_i2c.c
@@ -61,7 +61,8 @@ static int lis3_i2c_init(struct lis3lv02
 }
 
 /* Default axis mapping but it can be overwritten by platform data */
-static int lis3lv02d_axis_map[3] = { LIS3_DEV_X, LIS3_DEV_Y, LIS3_DEV_Z };
+static union axis_conversion lis3lv02d_axis_map =
+	{ .as_array = { LIS3_DEV_X, LIS3_DEV_Y, LIS3_DEV_Z } };
 
 static int __devinit lis3lv02d_i2c_probe(struct i2c_client *client,
 					const struct i2c_device_id *id)
@@ -71,13 +72,13 @@ static int __devinit lis3lv02d_i2c_probe
 
 	if (pdata) {
 		if (pdata->axis_x)
-			lis3lv02d_axis_map[0] = pdata->axis_x;
+			lis3lv02d_axis_map.x = pdata->axis_x;
 
 		if (pdata->axis_y)
-			lis3lv02d_axis_map[1] = pdata->axis_y;
+			lis3lv02d_axis_map.y = pdata->axis_y;
 
 		if (pdata->axis_z)
-			lis3lv02d_axis_map[2] = pdata->axis_z;
+			lis3lv02d_axis_map.z = pdata->axis_z;
 
 		if (pdata->setup_resources)
 			ret = pdata->setup_resources();
@@ -92,7 +93,7 @@ static int __devinit lis3lv02d_i2c_probe
 	lis3_dev.read	  = lis3_i2c_read;
 	lis3_dev.write	  = lis3_i2c_write;
 	lis3_dev.irq	  = client->irq;
-	memcpy(&lis3_dev.axis_map, &lis3lv02d_axis_map, sizeof(lis3_dev.axis_map));
+	lis3_dev.ac	  = lis3lv02d_axis_map;
 
 	i2c_set_clientdata(client, &lis3_dev);
 	ret = lis3lv02d_init_device(&lis3_dev);
diff -puN drivers/hwmon/lis3lv02d_spi.c~lis3-add-axes-module-parameter-for-custom-axis-mapping-update drivers/hwmon/lis3lv02d_spi.c
--- a/drivers/hwmon/lis3lv02d_spi.c~lis3-add-axes-module-parameter-for-custom-axis-mapping-update
+++ a/drivers/hwmon/lis3lv02d_spi.c
@@ -54,7 +54,8 @@ static int lis3_spi_init(struct lis3lv02
 	return lis3->write(lis3, CTRL_REG1, reg);
 }
 
-static struct axis_conversion lis3lv02d_axis_normal = { 1, 2, 3 };
+static union axis_conversion lis3lv02d_axis_normal =
+	{ .as_array = { 1, 2, 3 } };
 
 static int __devinit lis302dl_spi_probe(struct spi_device *spi)
 {
_

Patches currently in -mm which might be from tiwai@suse.de are

linux-next.patch
lis3-fix-oops-with-null-platform-data.patch
lis3-add-axes-module-parameter-for-custom-axis-mapping.patch
lis3-add-axes-module-parameter-for-custom-axis-mapping-update.patch
lis3-add-support-for-new-lis3dc-hp3dc-chip.patch

