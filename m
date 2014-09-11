From: akpm@linux-foundation.org
Subject: +
 rtc-bq32000-add-trickle-charger-option-with-device-tree-binding.patch added to -mm tree
Date: Thu, 11 Sep 2014 13:27:29 -0700
Message-ID: <541205b1.OBIJbyG0/ZhCCg7x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43134 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889AbaIKU1a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Sep 2014 16:27:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@ucw.cz, a.zummo@towertech.it, ijc+devicetree@hellion.org.uk, jason@lakedameon.net, linux@roeck-us.net, matti.vaittinen@nsn.com, pavel@denx.de, robh+dt@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: bq32000: add trickle charger option, with device tree binding
has been added to the -mm tree.  Its filename is
     rtc-bq32000-add-trickle-charger-option-with-device-tree-binding.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-bq32000-add-trickle-charger-option-with-device-tree-binding.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-bq32000-add-trickle-charger-option-with-device-tree-binding.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pavel Machek <pavel@ucw.cz>
Subject: rtc: bq32000: add trickle charger option, with device tree binding

BQ32000 devices have "trickle chargers".  Introduce a code to enable the
charger, based on device tree.

Without charger, RTC does not keep time after power off.

Signed-off-by: Pavel Machek <pavel@denx.de>
Cc: Jason Cooper <jason@lakedameon.net>
Cc: Matti Vaittinen <matti.vaittinen@nsn.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-bq32k.c |   65 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff -puN drivers/rtc/rtc-bq32k.c~rtc-bq32000-add-trickle-charger-option-with-device-tree-binding drivers/rtc/rtc-bq32k.c
--- a/drivers/rtc/rtc-bq32k.c~rtc-bq32000-add-trickle-charger-option-with-device-tree-binding
+++ a/drivers/rtc/rtc-bq32k.c
@@ -2,10 +2,14 @@
  * Driver for TI BQ32000 RTC.
  *
  * Copyright (C) 2009 Semihalf.
+ * Copyright (C) 2014 Pavel Machek <pavel@denx.de>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
+ *
+ * You can get hardware description at
+ * http://www.ti.com/lit/ds/symlink/bq32000.pdf
  */
 
 #include <linux/module.h>
@@ -27,6 +31,10 @@
 #define BQ32K_CENT		0x40	/* Century flag */
 #define BQ32K_CENT_EN		0x80	/* Century flag enable bit */
 
+#define BQ32K_CALIBRATION	0x07	/* CAL_CFG1, calibration and control */
+#define BQ32K_TCH2		0x08	/* Trickle charge enable */
+#define BQ32K_CFG2		0x09	/* Trickle charger control */
+
 struct bq32k_regs {
 	uint8_t		seconds;
 	uint8_t		minutes;
@@ -122,6 +130,59 @@ static const struct rtc_class_ops bq32k_
 	.set_time	= bq32k_rtc_set_time,
 };
 
+static int trickle_charger_of_init(struct device *dev, struct device_node *node)
+{
+	int plen = 0;
+	const uint32_t *setup;
+	const uint32_t *reg;
+	int error;
+	u32 ohms = 0;
+
+	if (of_property_read_u32(node, "trickle-resistor-ohms" , &ohms))
+		return 0;
+
+	switch (ohms) {
+	case 180+940:
+		/*
+		 * TCHE[3:0] == 0x05, TCH2 == 1, TCFE == 0 (charging
+		 * over diode and 940ohm resistor)
+		 */
+
+		if (of_property_read_bool(node, "trickle-diode-disable")) {
+			dev_err(dev, "diode and resistor mismatch\n");
+			return -EINVAL;
+		}
+		reg = 0x05;
+		break;
+
+	case 180+20000:
+		/* diode disabled */
+
+		if (!of_property_read_bool(node, "trickle-diode-disable")) {
+			dev_err(dev, "bq32k: diode and resistor mismatch\n");
+			return -EINVAL;
+		}
+		reg = 0x25;
+		break;
+
+	default:
+		dev_err(dev, "invalid resistor value (%d)\n", *setup);
+		return -EINVAL;
+	}
+
+	error = bq32k_write(dev, &reg, BQ32K_CFG2, 1);
+	if (error)
+		return error;
+
+	reg = 0x20;
+	error = bq32k_write(dev, &reg, BQ32K_TCH2, 1);
+	if (error)
+		return error;
+
+	dev_info(dev, "Enabled trickle RTC battery charge.\n");
+	return 0;
+}
+
 static int bq32k_probe(struct i2c_client *client,
 				const struct i2c_device_id *id)
 {
@@ -153,6 +214,10 @@ static int bq32k_probe(struct i2c_client
 	if (error)
 		return error;
 
+	if (client && client->dev.of_node) {
+		trickle_charger_of_init(dev, client->dev.of_node);
+	}
+
 	rtc = devm_rtc_device_register(&client->dev, bq32k_driver.driver.name,
 						&bq32k_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc))
_

Patches currently in -mm which might be from pavel@ucw.cz are

input-route-kbd-leds-through-the-generic-leds-layer.patch
lib-vsprintf-add-%pt-format-specifier.patch
rtc-bq32000-add-trickle-charger-option-with-device-tree-binding.patch
rtc-bq32000-add-trickle-charger-device-tree-binding.patch
linux-next.patch

