From: akpm@linux-foundation.org
Subject: [folded] leds-provide-helper-to-register-leds-gpio-devices-v4.patch removed from -mm tree
Date: Tue, 24 May 2011 17:05:43 -0700
Message-ID: <201105250005.p4P05hOt024437@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59830 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932271Ab1EYAGj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 May 2011 20:06:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, fabio.estevam@freescale.com, hartleys@visionengravers.com, richard.purdie@linuxfoundation.org, rmk@arm.linux.org.uk, s.hauer@pengutronix.de, mm-commits


The patch titled
     leds-provide-helper-to-register-leds-gpio-devices-v4
has been removed from the -mm tree.  Its filename was
     leds-provide-helper-to-register-leds-gpio-devices-v4.patch

This patch was dropped because it was folded into leds-provide-helper-t=
o-register-leds-gpio-devices.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: leds-provide-helper-to-register-leds-gpio-devices-v4
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

- new commit log
- improved documentation and moved it to .c file
- used obj-$(CONFIG..) and renamed source file
- provide an example usage (in a seperate patch)

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: Fabio Estevam <fabio.estevam@freescale.com>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Richard Purdie <richard.purdie@linuxfoundation.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/Kconfig              |    4 ++
 drivers/leds/Makefile             |    2 -
 drivers/leds/led-register.c       |   33 ----------------------
 drivers/leds/leds-gpio-register.c |   42 ++++++++++++++++++++++++++++
 include/linux/leds.h              |   10 ------
 5 files changed, 46 insertions(+), 45 deletions(-)

diff -puN drivers/leds/Kconfig~leds-provide-helper-to-register-leds-gpi=
o-devices-v4 drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~leds-provide-helper-to-register-leds-gpio-de=
vices-v4
+++ a/drivers/leds/Kconfig
@@ -14,10 +14,12 @@ config LEDS_CLASS
 	  This option enables the led sysfs class in /sys/class/leds.  You'll
 	  need this to do anything useful with LEDs.  If unsure, say N.
=20
-config LEDS_REGISTER_GPIO
+config LEDS_GPIO_REGISTER
 	bool
 	help
 	  This option provides the function gpio_led_register_device.
+	  As this function is used by arch code it must not be compiled as a
+	  module.
=20
 if NEW_LEDS
=20
diff -puN drivers/leds/Makefile~leds-provide-helper-to-register-leds-gp=
io-devices-v4 drivers/leds/Makefile
--- a/drivers/leds/Makefile~leds-provide-helper-to-register-leds-gpio-d=
evices-v4
+++ a/drivers/leds/Makefile
@@ -3,7 +3,6 @@
 obj-$(CONFIG_NEW_LEDS)			+=3D led-core.o
 obj-$(CONFIG_LEDS_CLASS)		+=3D led-class.o
 obj-$(CONFIG_LEDS_TRIGGERS)		+=3D led-triggers.o
-obj-y					+=3D led-register.o
=20
 # LED Platform Drivers
 obj-$(CONFIG_LEDS_88PM860X)		+=3D leds-88pm860x.o
@@ -21,6 +20,7 @@ obj-$(CONFIG_LEDS_COBALT_QUBE)		+=3D leds-
 obj-$(CONFIG_LEDS_COBALT_RAQ)		+=3D leds-cobalt-raq.o
 obj-$(CONFIG_LEDS_SUNFIRE)		+=3D leds-sunfire.o
 obj-$(CONFIG_LEDS_PCA9532)		+=3D leds-pca9532.o
+obj-$(CONFIG_LEDS_GPIO_REGISTER)	+=3D leds-gpio-register.o
 obj-$(CONFIG_LEDS_GPIO)			+=3D leds-gpio.o
 obj-$(CONFIG_LEDS_LP3944)		+=3D leds-lp3944.o
 obj-$(CONFIG_LEDS_LP5521)		+=3D leds-lp5521.o
diff -puN drivers/leds/led-register.c~leds-provide-helper-to-register-l=
eds-gpio-devices-v4 /dev/null
--- a/drivers/leds/led-register.c
+++ /dev/null
@@ -1,33 +0,0 @@
-/*
- * Copyright (C) 2011 Pengutronix
- * Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
- *
- * This program is free software; you can redistribute it and/or modif=
y it under
- * the terms of the GNU General Public License version 2 as published =
by the
- * Free Software Foundation.
- */
-#include <linux/err.h>
-#include <linux/platform_device.h>
-#include <linux/slab.h>
-#include <linux/leds.h>
-
-#if defined(CONFIG_LEDS_REGISTER_GPIO)
-struct platform_device *__init gpio_led_register_device(
-		int id, const struct gpio_led_platform_data *pdata)
-{
-	struct platform_device *ret;
-	struct gpio_led_platform_data _pdata =3D *pdata;
-
-	_pdata.leds =3D kmemdup(pdata->leds,
-			pdata->num_leds * sizeof(*pdata->leds), GFP_KERNEL);
-	if (!_pdata.leds)
-		return ERR_PTR(-ENOMEM);
-
-	ret =3D platform_device_register_resndata(NULL, "leds-gpio", id,
-			NULL, 0, &_pdata, sizeof(_pdata));
-	if (IS_ERR(ret))
-		kfree(_pdata.leds);
-
-	return ret;
-}
-#endif
diff -puN /dev/null drivers/leds/leds-gpio-register.c
--- /dev/null
+++ a/drivers/leds/leds-gpio-register.c
@@ -0,0 +1,42 @@
+/*
+ * Copyright (C) 2011 Pengutronix
+ * Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y it under
+ * the terms of the GNU General Public License version 2 as published =
by the
+ * Free Software Foundation.
+ */
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/leds.h>
+
+/**
+ * gpio_led_register_device - register a gpio-led device
+ * @pdata: the platform data used for the new device
+ *
+ * Makes a copy of pdata and pdata->leds and registers a new leds-gpio=
 device
+ * with the result. This allows to have pdata and pdata-leds in .init.=
rodata
+ * and so saves some bytes compared to a static struct platform_device=
 with
+ * static platform data.
+ *
+ * Returns the registered device or an error pointer.
+ */
+struct platform_device *__init gpio_led_register_device(
+		int id, const struct gpio_led_platform_data *pdata)
+{
+	struct platform_device *ret;
+	struct gpio_led_platform_data _pdata =3D *pdata;
+
+	_pdata.leds =3D kmemdup(pdata->leds,
+			pdata->num_leds * sizeof(*pdata->leds), GFP_KERNEL);
+	if (!_pdata.leds)
+		return ERR_PTR(-ENOMEM);
+
+	ret =3D platform_device_register_resndata(NULL, "leds-gpio", id,
+			NULL, 0, &_pdata, sizeof(_pdata));
+	if (IS_ERR(ret))
+		kfree(_pdata.leds);
+
+	return ret;
+}
diff -puN include/linux/leds.h~leds-provide-helper-to-register-leds-gpi=
o-devices-v4 include/linux/leds.h
--- a/include/linux/leds.h~leds-provide-helper-to-register-leds-gpio-de=
vices-v4
+++ a/include/linux/leds.h
@@ -207,16 +207,6 @@ struct gpio_led_platform_data {
 					unsigned long *delay_off);
 };
=20
-/**
- * gpio_led_register_device - register a gpio-led device
- * @pdata: the platform data used for the new device
- *
- * Use this function instead of platform_device_add()ing a static stru=
ct
- * platform_device.
- *
- * Note: as pdata and pdata->leds is copied these usually can and shou=
ld be
- * __initdata.
- */
 struct platform_device *gpio_led_register_device(
 		int id, const struct gpio_led_platform_data *pdata);
=20
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

origin.patch
leds-provide-helper-to-register-leds-gpio-devices.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
