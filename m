From: akpm@linux-foundation.org
Subject: - csb337-supports-new-style-rtc-ds1307.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:06:00 -0700
Message-ID: <200707172306.l6HN60Vx011967@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36162 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936811AbXGQXQz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:16:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, a.zummo@towertech.it, andrew@sanpeople.com, bgat@billgatliff.com, dbrownell@users.sourceforge.net, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     csb337 supports "new style" rtc-ds1307
has been removed from the -mm tree.  Its filename was
     csb337-supports-new-style-rtc-ds1307.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: csb337 supports "new style" rtc-ds1307
From: David Brownell <david-b@pacbell.net>

Update csb337 board specific init to support "new style" rtc-ds1307 code.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Andrew Victor <andrew@sanpeople.com>
Cc: Bill Gatliff <bgat@billgatliff.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-at91/board-csb337.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN arch/arm/mach-at91/board-csb337.c~csb337-supports-new-style-rtc-ds1307 arch/arm/mach-at91/board-csb337.c
--- a/arch/arm/mach-at91/board-csb337.c~csb337-supports-new-style-rtc-ds1307
+++ a/arch/arm/mach-at91/board-csb337.c
@@ -23,6 +23,7 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/i2c.h>
 #include <linux/spi/spi.h>
 #include <linux/mtd/physmap.h>
 
@@ -83,6 +84,13 @@ static struct at91_udc_data __initdata c
 	.pullup_pin	= AT91_PIN_PA24,
 };
 
+static struct i2c_board_info __initdata csb337_i2c_devices[] = {
+	{ I2C_BOARD_INFO("rtc-ds1307", 0x68),
+	  .type = "ds1307",
+	},
+};
+
+
 static struct at91_cf_data __initdata csb337_cf_data = {
 	/*
 	 * connector P4 on the CSB 337 mates to
@@ -161,6 +169,8 @@ static void __init csb337_board_init(voi
 	at91_add_device_udc(&csb337_udc_data);
 	/* I2C */
 	at91_add_device_i2c();
+	i2c_register_board_info(0, csb337_i2c_devices,
+			ARRAY_SIZE(csb337_i2c_devices));
 	/* Compact Flash */
 	at91_set_gpio_input(AT91_PIN_PB22, 1);		/* IOIS16 */
 	at91_add_device_cf(&csb337_cf_data);
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
git-leds.patch
git-mmc.patch
git-mtd.patch
git-backlight.patch
use-mutex-instead-of-semaphore-in-the-usb-gadget-serial-driver.patch
geode-basic-infrastructure-support-for-amd-geode-class.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
gpio-calls-dont-need-i-o-barriers.patch
dev_vdbg-available-with-dverbose_debug.patch
dev_vdbg-available-with-dverbose_debug-docs.patch
