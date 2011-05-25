From: akpm@linux-foundation.org
Subject: [merged] leds-provide-helper-to-register-leds-gpio-devices.patch removed from -mm tree
Date: Wed, 25 May 2011 13:32:06 -0700
Message-ID: <201105252030.p4PKUTf6014967@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756191Ab1EYUtK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:49:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, fabio.estevam@freescale.com, hartleys@visionengravers.com, richard.purdie@linuxfoundation.org, rmk@arm.linux.org.uk, s.hauer@pengutronix.de, mm-commits


The patch titled
     leds: provide helper to register "leds-gpio" devices
has been removed from the -mm tree.  Its filename was
     leds-provide-helper-to-register-leds-gpio-devices.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: leds: provide helper to register "leds-gpio" devices
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

This function makes a deep copy of the platform data to allow it to liv=
e
in init memory.  For a kernel that supports several machines and so
includes the definition for several leds-gpio devices this saves quite
some memory because all but one definition can be free'd after boot.

As the function is used by arch code it must be builtin and so cannot g=
o
into leds-gpio.c.

[akpm@linux-foundation.org: s/CONFIG_LED_REGISTER_GPIO/CONFIG_LEDS_REGI=
STER_GPIO/]
Signed-off-by: Uwe Kleine-K=F6nig  <u.kleine-koenig@pengutronix.de>
Cc: Russell King <rmk@arm.linux.org.uk>
Acked-by: Richard Purdie <richard.purdie@linuxfoundation.org>
Cc: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Tested-by: H Hartley Sweeten <hartleys@visionengravers.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/Makefile                  |    2 -
 drivers/leds/Kconfig              |    7 ++++
 drivers/leds/Makefile             |    1=20
 drivers/leds/leds-gpio-register.c |   42 ++++++++++++++++++++++++++++
 include/linux/leds.h              |    2 +
 5 files changed, 53 insertions(+), 1 deletion(-)

diff -puN drivers/Makefile~leds-provide-helper-to-register-leds-gpio-de=
vices drivers/Makefile
--- a/drivers/Makefile~leds-provide-helper-to-register-leds-gpio-device=
s
+++ a/drivers/Makefile
@@ -94,7 +94,7 @@ obj-$(CONFIG_CPU_IDLE)		+=3D cpuidle/
 obj-$(CONFIG_DMA_ENGINE)	+=3D dma/
 obj-$(CONFIG_MMC)		+=3D mmc/
 obj-$(CONFIG_MEMSTICK)		+=3D memstick/
-obj-$(CONFIG_NEW_LEDS)		+=3D leds/
+obj-y				+=3D leds/
 obj-$(CONFIG_INFINIBAND)	+=3D infiniband/
 obj-$(CONFIG_SGI_SN)		+=3D sn/
 obj-y				+=3D firmware/
diff -puN drivers/leds/Kconfig~leds-provide-helper-to-register-leds-gpi=
o-devices drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~leds-provide-helper-to-register-leds-gpio-de=
vices
+++ a/drivers/leds/Kconfig
@@ -14,6 +14,13 @@ config LEDS_CLASS
 	  This option enables the led sysfs class in /sys/class/leds.  You'll
 	  need this to do anything useful with LEDs.  If unsure, say N.
=20
+config LEDS_GPIO_REGISTER
+	bool
+	help
+	  This option provides the function gpio_led_register_device.
+	  As this function is used by arch code it must not be compiled as a
+	  module.
+
 if NEW_LEDS
=20
 comment "LED drivers"
diff -puN drivers/leds/Makefile~leds-provide-helper-to-register-leds-gp=
io-devices drivers/leds/Makefile
--- a/drivers/leds/Makefile~leds-provide-helper-to-register-leds-gpio-d=
evices
+++ a/drivers/leds/Makefile
@@ -21,6 +21,7 @@ obj-$(CONFIG_LEDS_COBALT_QUBE)		+=3D leds-
 obj-$(CONFIG_LEDS_COBALT_RAQ)		+=3D leds-cobalt-raq.o
 obj-$(CONFIG_LEDS_SUNFIRE)		+=3D leds-sunfire.o
 obj-$(CONFIG_LEDS_PCA9532)		+=3D leds-pca9532.o
+obj-$(CONFIG_LEDS_GPIO_REGISTER)	+=3D leds-gpio-register.o
 obj-$(CONFIG_LEDS_GPIO)			+=3D leds-gpio.o
 obj-$(CONFIG_LEDS_LP3944)		+=3D leds-lp3944.o
 obj-$(CONFIG_LEDS_LP5521)		+=3D leds-lp5521.o
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
o-devices include/linux/leds.h
--- a/include/linux/leds.h~leds-provide-helper-to-register-leds-gpio-de=
vices
+++ a/include/linux/leds.h
@@ -207,5 +207,7 @@ struct gpio_led_platform_data {
 					unsigned long *delay_off);
 };
=20
+struct platform_device *gpio_led_register_device(
+		int id, const struct gpio_led_platform_data *pdata);
=20
 #endif		/* __LINUX_LEDS_H_INCLUDED */
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

origin.patch
linux-next.patch
drivers-base-platformc-dont-mark-platform_device_register_resndata-as-_=
_init_or_module.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
