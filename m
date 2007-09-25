From: akpm@linux-foundation.org
Subject: - mips-gpio-led-driver-for-the-wgt634u-machine.patch removed from -mm tree
Date: Mon, 24 Sep 2007 20:58:08 -0700
Message-ID: <200709250358.l8P3w84D031919@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49245 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760001AbXIYD7V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Sep 2007 23:59:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aurelien@aurel32.net, david-b@pacbell.net, geert@linux-m68k.org, mb@bu3sch.de, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     mips: GPIO LED driver for the WGT634U machine
has been removed from the -mm tree.  Its filename was
     mips-gpio-led-driver-for-the-wgt634u-machine.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mips: GPIO LED driver for the WGT634U machine
From: Aurelien Jarno <aurelien@aurel32.net>

Add GPIO support to the BCM947xx platform.  It uses the new gpio-led driver
and a platform driver for the pin definitions.

Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: David Brownell <david-b@pacbell.net>
Cc: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/bcm947xx/Makefile  |    2 -
 arch/mips/bcm947xx/wgt634u.c |   64 +++++++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+), 1 deletion(-)

diff -puN arch/mips/bcm947xx/Makefile~mips-gpio-led-driver-for-the-wgt634u-machine arch/mips/bcm947xx/Makefile
--- a/arch/mips/bcm947xx/Makefile~mips-gpio-led-driver-for-the-wgt634u-machine
+++ a/arch/mips/bcm947xx/Makefile
@@ -3,4 +3,4 @@
 # under Linux.
 #
 
-obj-y := gpio.o irq.o prom.o serial.o setup.o time.o
+obj-y := gpio.o irq.o prom.o serial.o setup.o time.o wgt634u.o
diff -puN arch/mips/bcm947xx/wgt634u.c~mips-gpio-led-driver-for-the-wgt634u-machine arch/mips/bcm947xx/wgt634u.c
--- a/arch/mips/bcm947xx/wgt634u.c~mips-gpio-led-driver-for-the-wgt634u-machine
+++ a/arch/mips/bcm947xx/wgt634u.c
@@ -0,0 +1,64 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2007 Aurelien Jarno <aurelien@aurel32.net>
+ */
+
+#include <linux/platform_device.h>
+#include <linux/module.h>
+#include <linux/leds.h>
+#include <linux/ssb/ssb.h>
+#include <asm/mach-bcm947xx/bcm947xx.h>
+
+/* GPIO definitions for the WGT634U */
+#define WGT634U_GPIO_LED	3
+#define WGT634U_GPIO_RESET	2
+#define WGT634U_GPIO_TP1	7
+#define WGT634U_GPIO_TP2	6
+#define WGT634U_GPIO_TP3	5
+#define WGT634U_GPIO_TP4	4
+#define WGT634U_GPIO_TP5	1
+
+static struct gpio_led wgt634u_leds[] = {
+	{
+		.name = "power",
+		.gpio = WGT634U_GPIO_LED,
+		.active_low = 1,
+		.default_trigger = "heartbeat",
+	},
+};
+
+static struct gpio_led_platform_data wgt634u_led_data = {
+	.num_leds =     ARRAY_SIZE(wgt634u_leds),
+	.leds =         wgt634u_leds,
+};
+
+static struct platform_device wgt634u_gpio_leds = {
+	.name =         "leds-gpio",
+	.id =           -1,
+	.dev = {
+		.platform_data = &wgt634u_led_data,
+	}
+};
+
+static int __init wgt634u_init(void)
+{
+	/* There is no easy way to detect that we are running on a WGT634U
+	 * machine. Use the MAC address as an heuristic. Netgear Inc. has
+	 * been allocated ranges 00:09:5b:xx:xx:xx and 00:0f:b5:xx:xx:xx.
+	 */
+
+	u8 *et0mac = ssb_bcm947xx.sprom.r1.et0mac;
+
+	if (et0mac[0] == 0x00 &&
+	    ((et0mac[1] == 0x09 && et0mac[2] == 0x5b) ||
+	     (et0mac[1] == 0x0f && et0mac[2] == 0xb5)))
+		return platform_device_register(&wgt634u_gpio_leds);
+	else
+		return -ENODEV;
+}
+
+module_init(wgt634u_init);
+
_

Patches currently in -mm which might be from aurelien@aurel32.net are

git-kvm.patch
git-mips.patch
mips-add-gpio-support-to-the-bcm947xx-platform.patch
git-wireless.patch
move-mm_struct-and-vm_area_struct-fix.patch
