From: akpm@linux-foundation.org
Subject: + video-initial-support-for-adv7180.patch added to -mm tree
Date: Mon, 22 Jun 2009 21:56:02 -0700
Message-ID: <200906230456.n5N4u2gV018778@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32876 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753140AbZFWE4R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jun 2009 00:56:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard.rojfors.ext@mocean-labs.com, mchehab@infradead.org


The patch titled
     video: initial support for ADV7180
has been added to the -mm tree.  Its filename is
     video-initial-support-for-adv7180.patch

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
Subject: video: initial support for ADV7180
=46rom: Richard R=F6jfors <richard.rojfors.ext@mocean-labs.com>

This is an initial driver for Analog Devices ADV7180 Video Decoder.

So far it only supports query standard.

Signed-off-by: Richard R=F6jfors <richard.rojfors.ext@mocean-labs.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/Kconfig     |    9 +
 drivers/media/video/Makefile    |    1=20
 drivers/media/video/adv7180.c   |  221 ++++++++++++++++++++++++++++++
 include/media/v4l2-chip-ident.h |    3=20
 4 files changed, 234 insertions(+)

diff -puN drivers/media/video/Kconfig~video-initial-support-for-adv7180=
 drivers/media/video/Kconfig
--- a/drivers/media/video/Kconfig~video-initial-support-for-adv7180
+++ a/drivers/media/video/Kconfig
@@ -265,6 +265,15 @@ config VIDEO_SAA6588
=20
 comment "Video decoders"
=20
+config VIDEO_ADV7180
+	tristate "Analog Devices ADV7180 decoder"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	  Support for the Analog Devices ADV7180 video decoder.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called adv7180.
+
 config VIDEO_BT819
 	tristate "BT819A VideoStream decoder"
 	depends on VIDEO_V4L2 && I2C
diff -puN drivers/media/video/Makefile~video-initial-support-for-adv718=
0 drivers/media/video/Makefile
--- a/drivers/media/video/Makefile~video-initial-support-for-adv7180
+++ a/drivers/media/video/Makefile
@@ -45,6 +45,7 @@ obj-$(CONFIG_VIDEO_SAA7185) +=3D saa7185.o
 obj-$(CONFIG_VIDEO_SAA7191) +=3D saa7191.o
 obj-$(CONFIG_VIDEO_ADV7170) +=3D adv7170.o
 obj-$(CONFIG_VIDEO_ADV7175) +=3D adv7175.o
+obj-$(CONFIG_VIDEO_ADV7180) +=3D adv7180.o
 obj-$(CONFIG_VIDEO_ADV7343) +=3D adv7343.o
 obj-$(CONFIG_VIDEO_VPX3220) +=3D vpx3220.o
 obj-$(CONFIG_VIDEO_BT819) +=3D bt819.o
diff -puN /dev/null drivers/media/video/adv7180.c
--- /dev/null
+++ a/drivers/media/video/adv7180.c
@@ -0,0 +1,221 @@
+/*
+ * adv7180.c Analog Devices ADV7180 video decoder driver
+ * Copyright (c) 2009 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/i2c.h>
+#include <linux/i2c-id.h>
+#include <media/v4l2-ioctl.h>
+#include <linux/videodev2.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-chip-ident.h>
+#include <media/v4l2-i2c-drv.h>
+
+
+#define ADV7180_INPUT_CONTROL_REG	0x00
+#define ADV7180_INPUT_CONTROL_PAL_BG_NTSC_J_SECAM	0x00
+#define ADV7180_AUTODETECT_ENABLE_REG	0x07
+#define ADV7180_AUTODETECT_DEFAULT	0x7f
+
+
+#define ADV7180_STATUS1_REG 0x10
+#define ADV7180_STATUS1_AUTOD_MASK 0x70
+#define ADV7180_STATUS1_AUTOD_NTSM_M_J	0x00
+#define ADV7180_STATUS1_AUTOD_NTSC_4_43 0x10
+#define ADV7180_STATUS1_AUTOD_PAL_M	0x20
+#define ADV7180_STATUS1_AUTOD_PAL_60	0x30
+#define ADV7180_STATUS1_AUTOD_PAL_B_G	0x40
+#define ADV7180_STATUS1_AUTOD_SECAM	0x50
+#define ADV7180_STATUS1_AUTOD_PAL_COMB	0x60
+#define ADV7180_STATUS1_AUTOD_SECAM_525	0x70
+
+#define ADV7180_IDENT_REG 0x11
+#define ADV7180_ID_7180 0x18
+
+
+static unsigned short normal_i2c[] =3D { 0x42 >> 1, I2C_CLIENT_END };
+
+I2C_CLIENT_INSMOD;
+
+struct adv7180_state {
+	struct v4l2_subdev sd;
+};
+
+static v4l2_std_id determine_norm(struct i2c_client *client)
+{
+	u8 status1 =3D i2c_smbus_read_byte_data(client, ADV7180_STATUS1_REG);
+
+	switch (status1 & ADV7180_STATUS1_AUTOD_MASK) {
+	case ADV7180_STATUS1_AUTOD_NTSM_M_J:
+		return V4L2_STD_NTSC_M_JP;
+	case ADV7180_STATUS1_AUTOD_NTSC_4_43:
+		return V4L2_STD_NTSC_443;
+	case ADV7180_STATUS1_AUTOD_PAL_M:
+		return V4L2_STD_PAL_M;
+	case ADV7180_STATUS1_AUTOD_PAL_60:
+		return V4L2_STD_PAL_60;
+	case ADV7180_STATUS1_AUTOD_PAL_B_G:
+		return V4L2_STD_PAL;
+	case ADV7180_STATUS1_AUTOD_SECAM:
+		return V4L2_STD_SECAM;
+	case ADV7180_STATUS1_AUTOD_PAL_COMB:
+		return V4L2_STD_PAL_Nc | V4L2_STD_PAL_N;
+	case ADV7180_STATUS1_AUTOD_SECAM_525:
+		return V4L2_STD_SECAM;
+	default:
+		return V4L2_STD_UNKNOWN;
+	}
+}
+
+static inline struct adv7180_state *to_state(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct adv7180_state, sd);
+}
+
+static int adv7180_querystd(struct v4l2_subdev *sd, v4l2_std_id *std)
+{
+	struct i2c_client *client =3D v4l2_get_subdevdata(sd);
+
+	*(v4l2_std_id *)std =3D determine_norm(client);
+	return 0;
+}
+
+static int adv7180_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control =
*ctrl)
+{
+	return -EINVAL;
+}
+
+static int adv7180_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control =
*ctrl)
+{
+	return -EINVAL;
+}
+
+static int adv7180_g_chip_ident(struct v4l2_subdev *sd,
+	struct v4l2_dbg_chip_ident *chip)
+{
+	struct i2c_client *client =3D v4l2_get_subdevdata(sd);
+
+	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_ADV7180, 0=
);
+}
+
+static int adv7180_log_status(struct v4l2_subdev *sd)
+{
+	v4l2_info(sd, "Normal operation\n");
+	return 0;
+}
+
+static irqreturn_t adv7180_irq(int irq, void *devid)
+{
+	return IRQ_NONE;
+}
+
+static const struct v4l2_subdev_video_ops adv7180_video_ops =3D {
+	.querystd =3D adv7180_querystd,
+};
+
+static const struct v4l2_subdev_core_ops adv7180_core_ops =3D {
+	.log_status =3D adv7180_log_status,
+	.g_chip_ident =3D adv7180_g_chip_ident,
+	.g_ctrl =3D adv7180_g_ctrl,
+	.s_ctrl =3D adv7180_s_ctrl,
+};
+
+static const struct v4l2_subdev_ops adv7180_ops =3D {
+	.core =3D &adv7180_core_ops,
+	.video =3D &adv7180_video_ops,
+};
+
+/*
+ * Generic i2c probe
+ * concerning the addresses: i2c wants 7 bit (without the r/w bit), so=
 '>>1'
+ */
+
+static int adv7180_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
+{
+	struct adv7180_state *state;
+	struct v4l2_subdev *sd;
+
+	/* Check if the adapter supports the needed features */
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DAT=
A))
+		return -EIO;
+
+	v4l_info(client, "chip found @ 0x%02x (%s)\n",
+			client->addr << 1, client->adapter->name);
+
+	state =3D kmalloc(sizeof(struct adv7180_state), GFP_KERNEL);
+	if (state =3D=3D NULL)
+		return -ENOMEM;
+	sd =3D &state->sd;
+	v4l2_i2c_subdev_init(sd, client, &adv7180_ops);
+
+	/* Initialize adv7180 */
+
+	/* register interrupt, can be used later */
+	if (client->irq > 0) {
+		/* we can use IRQ */
+		int err =3D request_irq(client->irq, adv7180_irq, IRQF_SHARED,
+			"adv7180", sd);
+		if (err) {
+			printk(KERN_ERR "adv7180: Failed to request IRQ\n");
+			v4l2_device_unregister_subdev(sd);
+			kfree(state);
+			return err;
+		}
+	}
+
+	/* enable autodetection */
+	i2c_smbus_write_byte_data(client, ADV7180_INPUT_CONTROL_REG,
+		ADV7180_INPUT_CONTROL_PAL_BG_NTSC_J_SECAM);
+	i2c_smbus_write_byte_data(client, ADV7180_AUTODETECT_ENABLE_REG,
+		ADV7180_AUTODETECT_DEFAULT);
+	return 0;
+}
+
+static int adv7180_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *sd =3D i2c_get_clientdata(client);
+
+	if (client->irq > 0)
+		free_irq(client->irq, sd);
+
+	v4l2_device_unregister_subdev(sd);
+	kfree(to_state(sd));
+	return 0;
+}
+
+static const struct i2c_device_id adv7180_id[] =3D {
+	{ "adv7180", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, adv7180_id);
+
+static struct v4l2_i2c_driver_data v4l2_i2c_data =3D {
+	.name =3D "adv7180",
+	.probe =3D adv7180_probe,
+	.remove =3D adv7180_remove,
+	.id_table =3D adv7180_id,
+};
+
+MODULE_DESCRIPTION("Analog Devices ADV7180 video decoder driver");
+MODULE_AUTHOR("Mocean Laboratories");
+MODULE_LICENSE("GPL v2");
+
diff -puN include/media/v4l2-chip-ident.h~video-initial-support-for-adv=
7180 include/media/v4l2-chip-ident.h
--- a/include/media/v4l2-chip-ident.h~video-initial-support-for-adv7180
+++ a/include/media/v4l2-chip-ident.h
@@ -131,6 +131,9 @@ enum {
 	/* module adv7175: just ident 7175 */
 	V4L2_IDENT_ADV7175 =3D 7175,
=20
+	/* module adv7180: just ident 7180 */
+	V4L2_IDENT_ADV7180 =3D 7180,
+
 	/* module saa7185: just ident 7185 */
 	V4L2_IDENT_SAA7185 =3D 7185,
=20
_

Patches currently in -mm which might be from richard.rojfors.ext@mocean=
-labs.com are

origin.patch
video-initial-support-for-adv7180.patch
gpio-add-mc33880-driver.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
