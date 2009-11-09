From: akpm@linux-foundation.org
Subject: [merged] radio-add-support-for-tef6862-tuner.patch removed from -mm tree
Date: Mon, 09 Nov 2009 11:55:01 -0800
Message-ID: <200911091955.nA9Jt136022870@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57211 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751326AbZKITzK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2009 14:55:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard.rojfors@mocean-labs.com, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     radio: add support for TEF6862 tuner
has been removed from the -mm tree.  Its filename was
     radio-add-support-for-tef6862-tuner.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: radio: add support for TEF6862 tuner
=46rom: Richard R=F6jfors <richard.rojfors@mocean-labs.com>

tAdd adds support for TEF6862 Car Radio Enhanced Selectivity Tuner.

It's implemented as a subdev, supporting checking signal strength and
setting and getting frequency.

Signed-off-by: Richard R=F6jfors <richard.rojfors@mocean-labs.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/radio/Kconfig     |   12 +
 drivers/media/radio/Makefile    |    1=20
 drivers/media/radio/tef6862.c   |  232 ++++++++++++++++++++++++++++++
 include/media/v4l2-chip-ident.h |    3=20
 4 files changed, 248 insertions(+)

diff -puN drivers/media/radio/Kconfig~radio-add-support-for-tef6862-tun=
er drivers/media/radio/Kconfig
--- a/drivers/media/radio/Kconfig~radio-add-support-for-tef6862-tuner
+++ a/drivers/media/radio/Kconfig
@@ -401,4 +401,16 @@ config RADIO_TEA5764_XTAL
 	  Say Y here if TEA5764 have a 32768 Hz crystal in circuit, say N
 	  here if TEA5764 reference frequency is connected in FREQIN.
=20
+config RADIO_TEF6862
+	tristate "TEF6862 Car Radio Enhanced Selectivity Tuner"
+	depends on I2C && VIDEO_V4L2
+	---help---
+	  Say Y here if you want to use the TEF6862 Car Radio Enhanced
+	  Selectivity Tuner, found for instance on the Russellville developme=
nt
+	  board. On the russellville the device is connected to internal
+	  timberdale I2C bus.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called TEF6862.
+
 endif # RADIO_ADAPTERS
diff -puN drivers/media/radio/Makefile~radio-add-support-for-tef6862-tu=
ner drivers/media/radio/Makefile
--- a/drivers/media/radio/Makefile~radio-add-support-for-tef6862-tuner
+++ a/drivers/media/radio/Makefile
@@ -22,5 +22,6 @@ obj-$(CONFIG_USB_DSBR) +=3D dsbr100.o
 obj-$(CONFIG_RADIO_SI470X) +=3D si470x/
 obj-$(CONFIG_USB_MR800) +=3D radio-mr800.o
 obj-$(CONFIG_RADIO_TEA5764) +=3D radio-tea5764.o
+obj-$(CONFIG_RADIO_TEF6862) +=3D tef6862.o
=20
 EXTRA_CFLAGS +=3D -Isound
diff -puN /dev/null drivers/media/radio/tef6862.c
--- /dev/null
+++ a/drivers/media/radio/tef6862.c
@@ -0,0 +1,232 @@
+/*
+ * tef6862.c Philips TEF6862 Car Radio Enhanced Selectivity Tuner
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
+#include <media/v4l2-device.h>
+#include <media/v4l2-chip-ident.h>
+
+#define DRIVER_NAME "tef6862"
+
+#define FREQ_MUL 16000
+
+#define TEF6862_LO_FREQ (875 * FREQ_MUL / 10)
+#define TEF6862_HI_FREQ (108 * FREQ_MUL)
+
+/* Write mode sub addresses */
+#define WM_SUB_BANDWIDTH	0x0
+#define WM_SUB_PLLM		0x1
+#define WM_SUB_PLLL		0x2
+#define WM_SUB_DAA		0x3
+#define WM_SUB_AGC		0x4
+#define WM_SUB_BAND		0x5
+#define WM_SUB_CONTROL		0x6
+#define WM_SUB_LEVEL		0x7
+#define WM_SUB_IFCF		0x8
+#define WM_SUB_IFCAP		0x9
+#define WM_SUB_ACD		0xA
+#define WM_SUB_TEST		0xF
+
+/* Different modes of the MSA register */
+#define MODE_BUFFER		0x0
+#define MODE_PRESET		0x1
+#define MODE_SEARCH		0x2
+#define MODE_AF_UPDATE		0x3
+#define MODE_JUMP		0x4
+#define MODE_CHECK		0x5
+#define MODE_LOAD		0x6
+#define MODE_END		0x7
+#define MODE_SHIFT		5
+
+struct tef6862_state {
+	struct v4l2_subdev sd;
+	unsigned long freq;
+};
+
+static inline struct tef6862_state *to_state(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct tef6862_state, sd);
+}
+
+static u16 tef6862_sigstr(struct i2c_client *client)
+{
+	u8 buf[4];
+	int err =3D i2c_master_recv(client, buf, sizeof(buf));
+	if (err =3D=3D sizeof(buf))
+		return buf[3] << 8;
+	return 0;
+}
+
+static int tef6862_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *=
v)
+{
+	if (v->index > 0)
+		return -EINVAL;
+
+	/* only support FM for now */
+	strlcpy(v->name, "FM", sizeof(v->name));
+	v->type =3D V4L2_TUNER_RADIO;
+	v->rangelow =3D TEF6862_LO_FREQ;
+	v->rangehigh =3D TEF6862_HI_FREQ;
+	v->rxsubchans =3D V4L2_TUNER_SUB_MONO;
+	v->capability =3D V4L2_TUNER_CAP_LOW;
+	v->audmode =3D V4L2_TUNER_MODE_STEREO;
+	v->signal =3D tef6862_sigstr(v4l2_get_subdevdata(sd));
+
+	return 0;
+}
+
+static int tef6862_s_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *=
v)
+{
+	return v->index ? -EINVAL : 0;
+}
+
+static int tef6862_s_frequency(struct v4l2_subdev *sd, struct v4l2_fre=
quency *f)
+{
+	struct tef6862_state *state =3D to_state(sd);
+	struct i2c_client *client =3D v4l2_get_subdevdata(sd);
+	u16 pll;
+	u8 i2cmsg[3];
+	int err;
+
+	if (f->tuner !=3D 0)
+		return -EINVAL;
+
+	pll =3D 1964 + ((f->frequency - TEF6862_LO_FREQ) * 20) / FREQ_MUL;
+	i2cmsg[0] =3D (MODE_PRESET << MODE_SHIFT) | WM_SUB_PLLM;
+	i2cmsg[1] =3D (pll >> 8) & 0xff;
+	i2cmsg[2] =3D pll & 0xff;
+
+	err =3D i2c_master_send(client, i2cmsg, sizeof(i2cmsg));
+	if (!err)
+		state->freq =3D f->frequency;
+	return err;
+}
+
+static int tef6862_g_frequency(struct v4l2_subdev *sd, struct v4l2_fre=
quency *f)
+{
+	struct tef6862_state *state =3D to_state(sd);
+
+	if (f->tuner !=3D 0)
+		return -EINVAL;
+	f->type =3D V4L2_TUNER_RADIO;
+	f->frequency =3D state->freq;
+	return 0;
+}
+
+static int tef6862_g_chip_ident(struct v4l2_subdev *sd,
+	struct v4l2_dbg_chip_ident *chip)
+{
+	struct i2c_client *client =3D v4l2_get_subdevdata(sd);
+
+	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_TEF6862, 0=
);
+}
+
+static const struct v4l2_subdev_tuner_ops tef6862_tuner_ops =3D {
+	.g_tuner =3D tef6862_g_tuner,
+	.s_tuner =3D tef6862_s_tuner,
+	.s_frequency =3D tef6862_s_frequency,
+	.g_frequency =3D tef6862_g_frequency,
+};
+
+static const struct v4l2_subdev_core_ops tef6862_core_ops =3D {
+	.g_chip_ident =3D tef6862_g_chip_ident,
+};
+
+static const struct v4l2_subdev_ops tef6862_ops =3D {
+	.core =3D &tef6862_core_ops,
+	.tuner =3D &tef6862_tuner_ops,
+};
+
+/*
+ * Generic i2c probe
+ * concerning the addresses: i2c wants 7 bit (without the r/w bit), so=
 '>>1'
+ */
+
+static int __devinit tef6862_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
+{
+	struct tef6862_state *state;
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
+	state =3D kmalloc(sizeof(struct tef6862_state), GFP_KERNEL);
+	if (state =3D=3D NULL)
+		return -ENOMEM;
+	state->freq =3D TEF6862_LO_FREQ;
+
+	sd =3D &state->sd;
+	v4l2_i2c_subdev_init(sd, client, &tef6862_ops);
+
+	return 0;
+}
+
+static int __devexit tef6862_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *sd =3D i2c_get_clientdata(client);
+
+	v4l2_device_unregister_subdev(sd);
+	kfree(to_state(sd));
+	return 0;
+}
+
+static const struct i2c_device_id tef6862_id[] =3D {
+	{DRIVER_NAME, 0},
+	{},
+};
+
+MODULE_DEVICE_TABLE(i2c, tef6862_id);
+
+static struct i2c_driver tef6862_driver =3D {
+	.driver =3D {
+		.owner	=3D THIS_MODULE,
+		.name	=3D DRIVER_NAME,
+	},
+	.probe		=3D tef6862_probe,
+	.remove		=3D tef6862_remove,
+	.id_table	=3D tef6862_id,
+};
+
+static __init int tef6862_init(void)
+{
+	return i2c_add_driver(&tef6862_driver);
+}
+
+static __exit void tef6862_exit(void)
+{
+	i2c_del_driver(&tef6862_driver);
+}
+
+module_init(tef6862_init);
+module_exit(tef6862_exit);
+
+MODULE_DESCRIPTION("TEF6862 Car Radio Enhanced Selectivity Tuner");
+MODULE_AUTHOR("Mocean Laboratories");
+MODULE_LICENSE("GPL v2");
+
diff -puN include/media/v4l2-chip-ident.h~radio-add-support-for-tef6862=
-tuner include/media/v4l2-chip-ident.h
--- a/include/media/v4l2-chip-ident.h~radio-add-support-for-tef6862-tun=
er
+++ a/include/media/v4l2-chip-ident.h
@@ -129,6 +129,9 @@ enum {
 	V4L2_IDENT_SAA6752HS =3D 6752,
 	V4L2_IDENT_SAA6752HS_AC3 =3D 6753,
=20
+	/* modules tef6862: just ident 6862 */
+	V4L2_IDENT_TEF6862 =3D 6862,
+
 	/* module adv7170: just ident 7170 */
 	V4L2_IDENT_ADV7170 =3D 7170,
=20
_

Patches currently in -mm which might be from richard.rojfors@mocean-lab=
s.com are

linux-next.patch
xilinx_spi-split-into-generic-of-and-platform-driver-add-support-for-ds=
570.patch
gpio-add-gpio-driver-for-the-timberdale-fpga.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
