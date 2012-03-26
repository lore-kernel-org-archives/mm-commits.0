From: akpm@linux-foundation.org
Subject: [merged] backlight-add-support-for-pandora-backlight.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:29:04 -0700
Message-ID: <20120326192904.816ACA0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:63654 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111Ab2CZT3G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:29:06 -0400
Received: by mail-ee0-f74.google.com with SMTP id c41so293886eek.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:29:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: notasas@gmail.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: add support for Pandora backlight
has been removed from the -mm tree.  Its filename was
     backlight-add-support-for-pandora-backlight.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
=46rom: Grazvydas Ignotas <notasas@gmail.com>
Subject: backlight: add support for Pandora backlight

Add support for pandora (openpandora.org) backlight.

It might look like all this could be done using pwm_bl.c instead, but
there is a need of special programming sequence when turning on the LED
driver chip or else it will misbehave.  Doing this using pwm_bl.c would
require to use some register programming and pwm functions from platfor=
m
code, and ARM maintainers are allergic to driver-like code in /arch/arm
nowadays.  The PMIC PWM driver is currently missing too, so pwm_bl.c ca=
n't
be used anyway.

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/Kconfig      |    7 +
 drivers/video/backlight/Makefile     |    1=20
 drivers/video/backlight/pandora_bl.c |  171 +++++++++++++++++++++++++
 3 files changed, 179 insertions(+)

diff -puN drivers/video/backlight/Kconfig~backlight-add-support-for-pan=
dora-backlight drivers/video/backlight/Kconfig
--- a/drivers/video/backlight/Kconfig~backlight-add-support-for-pandora=
-backlight
+++ a/drivers/video/backlight/Kconfig
@@ -348,6 +348,13 @@ config BACKLIGHT_OT200
 	  To compile this driver as a module, choose M here: the module will =
be
 	  called ot200_bl.
=20
+config BACKLIGHT_PANDORA
+	tristate "Backlight driver for Pandora console"
+	depends on TWL4030_CORE
+	help
+	  If you have a Pandora console, say Y to enable the
+	  backlight driver.
+
 endif # BACKLIGHT_CLASS_DEVICE
=20
 endif # BACKLIGHT_LCD_SUPPORT
diff -puN drivers/video/backlight/Makefile~backlight-add-support-for-pa=
ndora-backlight drivers/video/backlight/Makefile
--- a/drivers/video/backlight/Makefile~backlight-add-support-for-pandor=
a-backlight
+++ a/drivers/video/backlight/Makefile
@@ -24,6 +24,7 @@ obj-$(CONFIG_BACKLIGHT_HP680)	+=3D hp680_b
 obj-$(CONFIG_BACKLIGHT_LOCOMO)	+=3D locomolcd.o
 obj-$(CONFIG_BACKLIGHT_LP855X)	+=3D lp855x_bl.o
 obj-$(CONFIG_BACKLIGHT_OMAP1)	+=3D omap1_bl.o
+obj-$(CONFIG_BACKLIGHT_PANDORA)	+=3D pandora_bl.o
 obj-$(CONFIG_BACKLIGHT_PROGEAR) +=3D progear_bl.o
 obj-$(CONFIG_BACKLIGHT_CARILLO_RANCH) +=3D cr_bllcd.o
 obj-$(CONFIG_BACKLIGHT_PWM)	+=3D pwm_bl.o
diff -puN /dev/null drivers/video/backlight/pandora_bl.c
--- /dev/null
+++ a/drivers/video/backlight/pandora_bl.c
@@ -0,0 +1,171 @@
+/*
+ * Backlight driver for Pandora handheld.
+ * Pandora uses TWL4030 PWM0 -> TPS61161 combo for control backlight.
+ * Based on pwm_bl.c
+ *
+ * Copyright 2009,2012 Gra=C5=BEvydas Ignotas <notasas@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/delay.h>
+#include <linux/fb.h>
+#include <linux/backlight.h>
+#include <linux/i2c/twl.h>
+#include <linux/err.h>
+
+#define TWL_PWM0_ON		0x00
+#define TWL_PWM0_OFF		0x01
+
+#define TWL_INTBR_GPBR1		0x0c
+#define TWL_INTBR_PMBR1		0x0d
+
+#define TWL_PMBR1_PWM0_MUXMASK	0x0c
+#define TWL_PMBR1_PWM0		0x04
+#define PWM0_CLK_ENABLE		BIT(0)
+#define PWM0_ENABLE		BIT(2)
+
+/* range accepted by hardware */
+#define MIN_VALUE 9
+#define MAX_VALUE 63
+#define MAX_USER_VALUE (MAX_VALUE - MIN_VALUE)
+
+#define PANDORABL_WAS_OFF BL_CORE_DRIVER1
+
+static int pandora_backlight_update_status(struct backlight_device *bl=
)
+{
+	int brightness =3D bl->props.brightness;
+	u8 r;
+
+	if (bl->props.power !=3D FB_BLANK_UNBLANK)
+		brightness =3D 0;
+	if (bl->props.state & BL_CORE_FBBLANK)
+		brightness =3D 0;
+	if (bl->props.state & BL_CORE_SUSPENDED)
+		brightness =3D 0;
+
+	if ((unsigned int)brightness > MAX_USER_VALUE)
+		brightness =3D MAX_USER_VALUE;
+
+	if (brightness =3D=3D 0) {
+		if (bl->props.state & PANDORABL_WAS_OFF)
+			goto done;
+
+		/* first disable PWM0 output, then clock */
+		twl_i2c_read_u8(TWL4030_MODULE_INTBR, &r, TWL_INTBR_GPBR1);
+		r &=3D ~PWM0_ENABLE;
+		twl_i2c_write_u8(TWL4030_MODULE_INTBR, r, TWL_INTBR_GPBR1);
+		r &=3D ~PWM0_CLK_ENABLE;
+		twl_i2c_write_u8(TWL4030_MODULE_INTBR, r, TWL_INTBR_GPBR1);
+
+		goto done;
+	}
+
+	if (bl->props.state & PANDORABL_WAS_OFF) {
+		/*
+		 * set PWM duty cycle to max. TPS61161 seems to use this
+		 * to calibrate it's PWM sensitivity when it starts.
+		 */
+		twl_i2c_write_u8(TWL4030_MODULE_PWM0, MAX_VALUE,
+					TWL_PWM0_OFF);
+
+		/* first enable clock, then PWM0 out */
+		twl_i2c_read_u8(TWL4030_MODULE_INTBR, &r, TWL_INTBR_GPBR1);
+		r &=3D ~PWM0_ENABLE;
+		r |=3D PWM0_CLK_ENABLE;
+		twl_i2c_write_u8(TWL4030_MODULE_INTBR, r, TWL_INTBR_GPBR1);
+		r |=3D PWM0_ENABLE;
+		twl_i2c_write_u8(TWL4030_MODULE_INTBR, r, TWL_INTBR_GPBR1);
+
+		/*
+		 * TI made it very easy to enable digital control, so easy that
+		 * it often triggers unintentionally and disabes PWM control,
+		 * so wait until 1 wire mode detection window ends.
+		 */
+		usleep_range(2000, 10000);
+	}
+
+	twl_i2c_write_u8(TWL4030_MODULE_PWM0, MIN_VALUE + brightness,
+				TWL_PWM0_OFF);
+
+done:
+	if (brightness !=3D 0)
+		bl->props.state &=3D ~PANDORABL_WAS_OFF;
+	else
+		bl->props.state |=3D PANDORABL_WAS_OFF;
+
+	return 0;
+}
+
+static int pandora_backlight_get_brightness(struct backlight_device *b=
l)
+{
+	return bl->props.brightness;
+}
+
+static const struct backlight_ops pandora_backlight_ops =3D {
+	.options	=3D BL_CORE_SUSPENDRESUME,
+	.update_status	=3D pandora_backlight_update_status,
+	.get_brightness	=3D pandora_backlight_get_brightness,
+};
+
+static int pandora_backlight_probe(struct platform_device *pdev)
+{
+	struct backlight_properties props;
+	struct backlight_device *bl;
+	u8 r;
+
+	memset(&props, 0, sizeof(props));
+	props.max_brightness =3D MAX_USER_VALUE;
+	props.type =3D BACKLIGHT_RAW;
+	bl =3D backlight_device_register(pdev->name, &pdev->dev,
+			NULL, &pandora_backlight_ops, &props);
+	if (IS_ERR(bl)) {
+		dev_err(&pdev->dev, "failed to register backlight\n");
+		return PTR_ERR(bl);
+	}
+
+	platform_set_drvdata(pdev, bl);
+
+	/* 64 cycle period, ON position 0 */
+	twl_i2c_write_u8(TWL4030_MODULE_PWM0, 0x80, TWL_PWM0_ON);
+
+	bl->props.state |=3D PANDORABL_WAS_OFF;
+	bl->props.brightness =3D MAX_USER_VALUE;
+	backlight_update_status(bl);
+
+	/* enable PWM function in pin mux */
+	twl_i2c_read_u8(TWL4030_MODULE_INTBR, &r, TWL_INTBR_PMBR1);
+	r &=3D ~TWL_PMBR1_PWM0_MUXMASK;
+	r |=3D TWL_PMBR1_PWM0;
+	twl_i2c_write_u8(TWL4030_MODULE_INTBR, r, TWL_INTBR_PMBR1);
+
+	return 0;
+}
+
+static int pandora_backlight_remove(struct platform_device *pdev)
+{
+	struct backlight_device *bl =3D platform_get_drvdata(pdev);
+	backlight_device_unregister(bl);
+	return 0;
+}
+
+static struct platform_driver pandora_backlight_driver =3D {
+	.driver		=3D {
+		.name	=3D "pandora-backlight",
+		.owner	=3D THIS_MODULE,
+	},
+	.probe		=3D pandora_backlight_probe,
+	.remove		=3D pandora_backlight_remove,
+};
+
+module_platform_driver(pandora_backlight_driver);
+
+MODULE_AUTHOR("Gra=C5=BEvydas Ignotas <notasas@gmail.com>");
+MODULE_DESCRIPTION("Pandora Backlight Driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:pandora-backlight");
_

Patches currently in -mm which might be from notasas@gmail.com are

origin.patch
linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
