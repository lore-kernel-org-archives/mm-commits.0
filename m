From: akpm@linux-foundation.org
Subject: + leds-provide-helper-to-register-leds-gpio-devices.patch added to -mm tree
Date: Mon, 09 May 2011 15:05:41 -0700
Message-ID: <201105092205.p49M5fXE021255@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39440 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932208Ab1EIWG3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2011 18:06:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: u.kleine-koenig@pengutronix.de, fabio.estevam@freescale.com, hartleys@visionengravers.com, richard.purdie@linuxfoundation.org, rmk@arm.linux.org.uk, s.hauer@pengutronix.de


The patch titled
     leds: provide helper to register "leds-gpio" devices
has been added to the -mm tree.  Its filename is
     leds-provide-helper-to-register-leds-gpio-devices.patch

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
Subject: leds: provide helper to register "leds-gpio" devices
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

This function makes a deep copy of the platform data to allow it to liv=
e
in init memory.  The definition cannot go into leds-gpio.c because it
needs to be builtin to be usable by platforms.

Signed-off-by: Uwe Kleine-K=F6nig  <u.kleine-koenig@pengutronix.de>
Cc: Russell King <rmk@arm.linux.org.uk>
Acked-by: Richard Purdie <richard.purdie@linuxfoundation.org>
Cc: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/Makefile            |    2 +-
 drivers/leds/Kconfig        |    5 +++++
 drivers/leds/Makefile       |    1 +
 drivers/leds/led-register.c |   33 +++++++++++++++++++++++++++++++++
 include/linux/leds.h        |   12 ++++++++++++
 5 files changed, 52 insertions(+), 1 deletion(-)

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
@@ -14,6 +14,11 @@ config LEDS_CLASS
 	  This option enables the led sysfs class in /sys/class/leds.  You'll
 	  need this to do anything useful with LEDs.  If unsure, say N.
=20
+config LED_REGISTER_GPIO
+	bool
+	help
+	  This option provides the function gpio_led_register_device.
+
 if NEW_LEDS
=20
 comment "LED drivers"
diff -puN drivers/leds/Makefile~leds-provide-helper-to-register-leds-gp=
io-devices drivers/leds/Makefile
--- a/drivers/leds/Makefile~leds-provide-helper-to-register-leds-gpio-d=
evices
+++ a/drivers/leds/Makefile
@@ -3,6 +3,7 @@
 obj-$(CONFIG_NEW_LEDS)			+=3D led-core.o
 obj-$(CONFIG_LEDS_CLASS)		+=3D led-class.o
 obj-$(CONFIG_LEDS_TRIGGERS)		+=3D led-triggers.o
+obj-y					+=3D led-register.o
=20
 # LED Platform Drivers
 obj-$(CONFIG_LEDS_88PM860X)		+=3D leds-88pm860x.o
diff -puN /dev/null drivers/leds/led-register.c
--- /dev/null
+++ a/drivers/leds/led-register.c
@@ -0,0 +1,33 @@
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
+#if defined(CONFIG_LED_REGISTER_GPIO)
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
+#endif
diff -puN include/linux/leds.h~leds-provide-helper-to-register-leds-gpi=
o-devices include/linux/leds.h
--- a/include/linux/leds.h~leds-provide-helper-to-register-leds-gpio-de=
vices
+++ a/include/linux/leds.h
@@ -207,5 +207,17 @@ struct gpio_led_platform_data {
 					unsigned long *delay_off);
 };
=20
+/**
+ * gpio_led_register_device - register a gpio-led device
+ * @pdata: the platform data used for the new device
+ *
+ * Use this function instead of platform_device_add()ing a static stru=
ct
+ * platform_device.
+ *
+ * Note: as pdata and pdata->leds is copied these usually can and shou=
ld be
+ * __initdata.
+ */
+struct platform_device *gpio_led_register_device(
+		int id, const struct gpio_led_platform_data *pdata);
=20
 #endif		/* __LINUX_LEDS_H_INCLUDED */
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

origin.patch
linux-next.patch
leds-provide-helper-to-register-leds-gpio-devices.patch
leds-provide-helper-to-register-leds-gpio-devices-fix.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
