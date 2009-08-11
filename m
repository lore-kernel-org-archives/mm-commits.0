From: akpm@linux-foundation.org
Subject: + video-initial-support-for-adv7180-update.patch added to -mm tree
Date: Tue, 11 Aug 2009 16:43:27 -0700
Message-ID: <200908112343.n7BNhRuA022096@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55954 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755619AbZHKXnj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Aug 2009 19:43:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard.rojfors.ext@mocean-labs.com, hverkuil@xs4all.nl, mchehab@infradead.org


The patch titled
     video-initial-support-for-adv7180-update
has been added to the -mm tree.  Its filename is
     video-initial-support-for-adv7180-update.patch

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
Subject: video-initial-support-for-adv7180-update
=46rom: Richard R=F6jfors <richard.rojfors.ext@mocean-labs.com>

Signed-off-by: Richard R=F6jfors <richard.rojfors.ext@mocean-labs.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/adv7180.c |   95 ++++++++++++--------------------
 1 file changed, 38 insertions(+), 57 deletions(-)

diff -puN drivers/media/video/adv7180.c~video-initial-support-for-adv71=
80-update drivers/media/video/adv7180.c
--- a/drivers/media/video/adv7180.c~video-initial-support-for-adv7180-u=
pdate
+++ a/drivers/media/video/adv7180.c
@@ -27,8 +27,8 @@
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
-#include <media/v4l2-i2c-drv.h>
=20
+#define DRIVER_NAME "adv7180"
=20
 #define ADV7180_INPUT_CONTROL_REG	0x00
 #define ADV7180_INPUT_CONTROL_PAL_BG_NTSC_J_SECAM	0x00
@@ -51,10 +51,6 @@
 #define ADV7180_ID_7180 0x18
=20
=20
-static unsigned short normal_i2c[] =3D { 0x42 >> 1, I2C_CLIENT_END };
-
-I2C_CLIENT_INSMOD;
-
 struct adv7180_state {
 	struct v4l2_subdev sd;
 };
@@ -98,16 +94,6 @@ static int adv7180_querystd(struct v4l2_
 	return 0;
 }
=20
-static int adv7180_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control =
*ctrl)
-{
-	return -EINVAL;
-}
-
-static int adv7180_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control =
*ctrl)
-{
-	return -EINVAL;
-}
-
 static int adv7180_g_chip_ident(struct v4l2_subdev *sd,
 	struct v4l2_dbg_chip_ident *chip)
 {
@@ -116,26 +102,12 @@ static int adv7180_g_chip_ident(struct v
 	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_ADV7180, 0=
);
 }
=20
-static int adv7180_log_status(struct v4l2_subdev *sd)
-{
-	v4l2_info(sd, "Normal operation\n");
-	return 0;
-}
-
-static irqreturn_t adv7180_irq(int irq, void *devid)
-{
-	return IRQ_NONE;
-}
-
 static const struct v4l2_subdev_video_ops adv7180_video_ops =3D {
 	.querystd =3D adv7180_querystd,
 };
=20
 static const struct v4l2_subdev_core_ops adv7180_core_ops =3D {
-	.log_status =3D adv7180_log_status,
 	.g_chip_ident =3D adv7180_g_chip_ident,
-	.g_ctrl =3D adv7180_g_ctrl,
-	.s_ctrl =3D adv7180_s_ctrl,
 };
=20
 static const struct v4l2_subdev_ops adv7180_ops =3D {
@@ -153,6 +125,7 @@ static int adv7180_probe(struct i2c_clie
 {
 	struct adv7180_state *state;
 	struct v4l2_subdev *sd;
+	int ret;
=20
 	/* Check if the adapter supports the needed features */
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DAT=
A))
@@ -161,32 +134,26 @@ static int adv7180_probe(struct i2c_clie
 	v4l_info(client, "chip found @ 0x%02x (%s)\n",
 			client->addr << 1, client->adapter->name);
=20
-	state =3D kmalloc(sizeof(struct adv7180_state), GFP_KERNEL);
+	state =3D kzalloc(sizeof(struct adv7180_state), GFP_KERNEL);
 	if (state =3D=3D NULL)
 		return -ENOMEM;
 	sd =3D &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &adv7180_ops);
=20
 	/* Initialize adv7180 */
-
-	/* register interrupt, can be used later */
-	if (client->irq > 0) {
-		/* we can use IRQ */
-		int err =3D request_irq(client->irq, adv7180_irq, IRQF_SHARED,
-			"adv7180", sd);
-		if (err) {
-			printk(KERN_ERR "adv7180: Failed to request IRQ\n");
-			v4l2_device_unregister_subdev(sd);
-			kfree(state);
-			return err;
-		}
-	}
-
 	/* enable autodetection */
-	i2c_smbus_write_byte_data(client, ADV7180_INPUT_CONTROL_REG,
+	ret =3D i2c_smbus_write_byte_data(client, ADV7180_INPUT_CONTROL_REG,
 		ADV7180_INPUT_CONTROL_PAL_BG_NTSC_J_SECAM);
-	i2c_smbus_write_byte_data(client, ADV7180_AUTODETECT_ENABLE_REG,
-		ADV7180_AUTODETECT_DEFAULT);
+	if (ret > 0)
+		ret =3D i2c_smbus_write_byte_data(client,
+			ADV7180_AUTODETECT_ENABLE_REG,
+			ADV7180_AUTODETECT_DEFAULT);
+	if (ret < 0) {
+		printk(KERN_ERR DRIVER_NAME
+			": Failed to communicate to chip: %d\n", ret);
+		return ret;
+	}
+
 	return 0;
 }
=20
@@ -194,27 +161,41 @@ static int adv7180_remove(struct i2c_cli
 {
 	struct v4l2_subdev *sd =3D i2c_get_clientdata(client);
=20
-	if (client->irq > 0)
-		free_irq(client->irq, sd);
-
 	v4l2_device_unregister_subdev(sd);
 	kfree(to_state(sd));
 	return 0;
 }
=20
 static const struct i2c_device_id adv7180_id[] =3D {
-	{ "adv7180", 0 },
-	{ }
+	{DRIVER_NAME, 0},
+	{},
 };
+
 MODULE_DEVICE_TABLE(i2c, adv7180_id);
=20
-static struct v4l2_i2c_driver_data v4l2_i2c_data =3D {
-	.name =3D "adv7180",
-	.probe =3D adv7180_probe,
-	.remove =3D adv7180_remove,
-	.id_table =3D adv7180_id,
+static struct i2c_driver adv7180_driver =3D {
+	.driver =3D {
+		.owner	=3D THIS_MODULE,
+		.name	=3D DRIVER_NAME,
+	},
+	.probe		=3D adv7180_probe,
+	.remove		=3D adv7180_remove,
+	.id_table	=3D adv7180_id,
 };
=20
+static __init int adv7180_init(void)
+{
+	return i2c_add_driver(&adv7180_driver);
+}
+
+static __exit void adv7180_exit(void)
+{
+	i2c_del_driver(&adv7180_driver);
+}
+
+module_init(adv7180_init);
+module_exit(adv7180_exit);
+
 MODULE_DESCRIPTION("Analog Devices ADV7180 video decoder driver");
 MODULE_AUTHOR("Mocean Laboratories");
 MODULE_LICENSE("GPL v2");
_

Patches currently in -mm which might be from richard.rojfors.ext@mocean=
-labs.com are

linux-next.patch
video-initial-support-for-adv7180.patch
video-initial-support-for-adv7180-update.patch
video-initial-support-for-adv7180-update-fix.patch
gpio-add-mc33880-driver.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
