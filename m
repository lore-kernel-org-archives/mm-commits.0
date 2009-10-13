From: akpm@linux-foundation.org
Subject: + spitz-add-gpio-button-support.patch added to -mm tree
Date: Tue, 13 Oct 2009 16:46:33 -0700
Message-ID: <200910132346.n9DNkX8Y010765@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45640 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758967AbZJMXre (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Oct 2009 19:47:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pavel@ucw.cz, broonie@opensource.wolfsonmicro.com, dbaryshkov@gmail.com, eric.y.miao@gmail.com, linux@arm.linux.org.uk, metan@ucw.cz, rjw@sisk.pl, utx@penguin.cz


The patch titled
     spitz: add gpio button support
has been added to the -mm tree.  Its filename is
     spitz-add-gpio-button-support.patch

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
Subject: spitz: add gpio button support
From: Pavel Machek <pavel@ucw.cz>

Spitz switched to generic matrix-gpio keyboard driver in 2.6.32-rc0, but
that means that support for power button and lid switches was lost.  This
restores it, using button-gpio code.

Signed-off-by: Pavel Machek <pavel@ucw.cz>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Stanislav Brabec <utx@penguin.cz>
Cc: Cyril Hrubis <metan@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN arch/arm/mach-pxa/spitz.c~spitz-add-gpio-button-support arch/arm/mach-pxa/spitz.c
--- a/arch/arm/mach-pxa/spitz.c~spitz-add-gpio-button-support
+++ a/arch/arm/mach-pxa/spitz.c
@@ -15,6 +15,7 @@
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
 #include <linux/delay.h>
+#include <linux/gpio_keys.h>
 #include <linux/gpio.h>
 #include <linux/leds.h>
 #include <linux/mtd/physmap.h>
@@ -375,6 +376,51 @@ static struct platform_device spitzkbd_d
 };
 
 
+static struct gpio_keys_button spitz_gpio_keys[] = {
+	{
+		.type	= EV_KEY,
+		.code	= KEY_SUSPEND,
+		.gpio	= SPITZ_GPIO_ON_KEY,
+		.desc	= "Power button",
+		.wakeup	= 1,
+	},
+	/* Two buttons detecting the LID state */
+	{
+		.type	= EV_SW,
+		.code	= 0,
+		.gpio	= SPITZ_GPIO_SWA,
+		.desc	= "Lid SWA",
+	},
+	{
+		.type	= EV_SW,
+		.code	= 1,
+		.gpio	= SPITZ_GPIO_SWB,
+		.desc	= "Lid SWB",
+	},
+	/* This is for remote control support. Zaurus supports wired
+	   remote on headphones. */
+	{
+		.type	= EV_SW,
+		.code	= 2,
+		.gpio	= SPITZ_GPIO_AK_INT,
+		.desc	= "Wired remote (AK_INT)",
+	},
+};
+
+static struct gpio_keys_platform_data spitz_gpio_keys_platform_data = {
+	.buttons	= spitz_gpio_keys,
+	.nbuttons	= ARRAY_SIZE(spitz_gpio_keys),
+};
+
+static struct platform_device spitz_gpio_keys_device = {
+	.name	= "gpio-keys",
+	.id	= -1,
+	.dev	= {
+		.platform_data	= &spitz_gpio_keys_platform_data,
+	},
+};
+
+
 /*
  * Spitz LEDs
  */
@@ -689,6 +735,7 @@ static struct platform_device sharpsl_ro
 static struct platform_device *devices[] __initdata = {
 	&spitzscoop_device,
 	&spitzkbd_device,
+	&spitz_gpio_keys_device,
 	&spitzled_device,
 	&sharpsl_nand_device,
 	&sharpsl_rom_device,
_

Patches currently in -mm which might be from pavel@ucw.cz are

linux-next.patch
synaptics-touchscreen-for-htc-dream-check-that-smbus-is-available.patch
spitz-add-gpio-button-support.patch
lis3lv02d-axis-remap-and-resource-setup-release.patch
lis3lv02d-i2c-support.patch
fatfs-use-common-time_to_tm-in-fat_time_unix2fat.patch

