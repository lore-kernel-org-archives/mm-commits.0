From: akpm@linux-foundation.org
Subject: + led-driver-for-the-soekris-net5501-board.patch added to -mm tree
Date: Tue, 02 Mar 2010 15:07:59 -0800
Message-ID: <201003022308.o22N80sX002766@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41047 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751787Ab0CBXIq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Mar 2010 18:08:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gurligebis@gentoo.org, a.zummo@towertech.it, rpurdie@rpsys.net


The patch titled
     LED driver for the Soekris net5501 board
has been added to the -mm tree.  Its filename is
     led-driver-for-the-soekris-net5501-board.patch

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
Subject: LED driver for the Soekris net5501 board
From: Bjarke Istrup Pedersen <gurligebis@gentoo.org>

LED driver for the Soekris net5501 board.

It is based on the previously submitted code by Alessandro Zummo, but is
changed to use the new GPIO driver with 2.6.33, and the driver has been
moved to drivers/leds where it belongs.

Signed-off-by: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/Kconfig        |    9 +++
 drivers/leds/Makefile       |    1 
 drivers/leds/leds-net5501.c |   95 ++++++++++++++++++++++++++++++++++
 3 files changed, 105 insertions(+)

diff -puN drivers/leds/Kconfig~led-driver-for-the-soekris-net5501-board drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~led-driver-for-the-soekris-net5501-board
+++ a/drivers/leds/Kconfig
@@ -67,6 +67,15 @@ config LEDS_NET48XX
 	  This option enables support for the Soekris net4801 and net4826 error
 	  LED.
 
+config LEDS_NET5501
+	tristate "LED Support for Soekris net5501 series Error LED"
+	depends on LEDS_CLASS && LEDS_GPIO_PLATFORM && GPIO_CS5535
+	select LEDS_TRIGGER_DEFAULT_ON
+	default n
+	help
+	  Add support for the Soekris net5501 board (detection, error led
+	  and GPIO).
+
 config LEDS_FSG
 	tristate "LED Support for the Freecom FSG-3"
 	depends on MACH_FSG
diff -puN drivers/leds/Makefile~led-driver-for-the-soekris-net5501-board drivers/leds/Makefile
--- a/drivers/leds/Makefile~led-driver-for-the-soekris-net5501-board
+++ a/drivers/leds/Makefile
@@ -13,6 +13,7 @@ obj-$(CONFIG_LEDS_MIKROTIK_RB532)	+= led
 obj-$(CONFIG_LEDS_S3C24XX)		+= leds-s3c24xx.o
 obj-$(CONFIG_LEDS_AMS_DELTA)		+= leds-ams-delta.o
 obj-$(CONFIG_LEDS_NET48XX)		+= leds-net48xx.o
+obj-$(CONFIG_LEDS_NET5501)		+= leds-net5501.o
 obj-$(CONFIG_LEDS_WRAP)			+= leds-wrap.o
 obj-$(CONFIG_LEDS_ALIX2)		+= leds-alix2.o
 obj-$(CONFIG_LEDS_H1940)		+= leds-h1940.o
diff -puN /dev/null drivers/leds/leds-net5501.c
--- /dev/null
+++ a/drivers/leds/leds-net5501.c
@@ -0,0 +1,95 @@
+/*
+ * Soekris board support code
+ *
+ * Copyright (C) 2008-2009 Tower Technologies
+ * Written by Alessandro Zummo <a.zummo@towertech.it>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/string.h>
+#include <linux/leds.h>
+#include <linux/platform_device.h>
+#include <linux/gpio.h>
+
+#include <asm/geode.h>
+
+static struct gpio_led net5501_leds[] = {
+	{
+		.name = "error",
+		.gpio = 6,
+		.default_trigger = "default-on",
+	},
+};
+
+static struct gpio_led_platform_data net5501_leds_data = {
+	.num_leds = ARRAY_SIZE(net5501_leds),
+	.leds = net5501_leds,
+};
+
+static struct platform_device net5501_leds_dev = {
+	.name = "leds-gpio",
+	.id = -1,
+	.dev.platform_data = &net5501_leds_data,
+};
+
+static void __init init_net5501(void)
+{
+	platform_device_register(&net5501_leds_dev);
+}
+
+struct soekris_board {
+	u16	offset;
+	char	*sig;
+	u8	len;
+	void	(*init)(void);
+};
+
+static struct soekris_board __initdata boards[] = {
+	{ 0xb7b, "net5501", 7, init_net5501 },	/* net5501 v1.33/1.33c */
+	{ 0xb1f, "net5501", 7, init_net5501 },	/* net5501 v1.32i */
+};
+
+static int __init soekris_init(void)
+{
+	int i;
+	unsigned char *rombase, *bios;
+
+	if (!is_geode())
+		return 0;
+
+	rombase = ioremap(0xffff0000, 0xffff);
+	if (!rombase)
+	{
+		printk(KERN_INFO "Soekris net5501 LED driver failed to get rombase");
+		return 0;
+	}
+
+	bios = rombase + 0x20;	/* null terminated */
+
+	if (strncmp(bios, "comBIOS", 7))
+		goto unmap;
+
+	for (i = 0; i < ARRAY_SIZE(boards); i++) {
+		unsigned char *model = rombase + boards[i].offset;
+
+		if (strncmp(model, boards[i].sig, boards[i].len) == 0) {
+			printk(KERN_INFO "Soekris %s: %s\n", model, bios);
+
+			if (boards[i].init)
+				boards[i].init();
+			break;
+		}
+	}
+
+unmap:
+	iounmap(rombase);
+	return 0;
+}
+
+arch_initcall(soekris_init);
_

Patches currently in -mm which might be from gurligebis@gentoo.org are

led-driver-for-the-soekris-net5501-board.patch
led-driver-for-the-soekris-net5501-board-checkpatch-fixes.patch

