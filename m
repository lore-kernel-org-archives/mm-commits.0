From: akpm@linux-foundation.org
Subject: - thecus-n2100-register-rtc-rs5c372-i2c-device.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:05:28 -0700
Message-ID: <200707172305.l6HN5Sgd011925@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55651 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936788AbXGQXQt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:16:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tbm@cyrius.com, Riku.Voipio@movial.fi, buytenh@wantstofly.org, david-b@pacbell.net, khali@linux-fr.org, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Thecus N2100: register rtc-rs5c372 i2c device
has been removed from the -mm tree.  Its filename was
     thecus-n2100-register-rtc-rs5c372-i2c-device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Thecus N2100: register rtc-rs5c372 i2c device
From: Martin Michlmayr <tbm@cyrius.com>

Use the new i2c framework to load rtc-rs5c372 for the Thecus N2100.

Signed-off-by: Martin Michlmayr <tbm@cyrius.com>
Tested-by: Voipio Riku <Riku.Voipio@movial.fi>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-iop32x/n2100.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN arch/arm/mach-iop32x/n2100.c~thecus-n2100-register-rtc-rs5c372-i2c-device arch/arm/mach-iop32x/n2100.c
--- a/arch/arm/mach-iop32x/n2100.c~thecus-n2100-register-rtc-rs5c372-i2c-device
+++ a/arch/arm/mach-iop32x/n2100.c
@@ -25,6 +25,7 @@
 #include <linux/serial_core.h>
 #include <linux/serial_8250.h>
 #include <linux/mtd/physmap.h>
+#include <linux/i2c.h>
 #include <linux/platform_device.h>
 #include <linux/reboot.h>
 #include <asm/hardware.h>
@@ -199,6 +200,12 @@ static struct platform_device n2100_seri
 	.resource	= &n2100_uart_resource,
 };
 
+static struct i2c_board_info __initdata n2100_i2c_devices[] = {
+	{
+		I2C_BOARD_INFO("rtc-rs5c372", 0x32),
+		.type = "rs5c372b",
+	},
+};
 
 /*
  * Pull PCA9532 GPIO #8 low to power off the machine.
@@ -248,6 +255,9 @@ static void __init n2100_init_machine(vo
 	platform_device_register(&iop3xx_dma_0_channel);
 	platform_device_register(&iop3xx_dma_1_channel);
 
+	i2c_register_board_info(0, n2100_i2c_devices,
+		ARRAY_SIZE(n2100_i2c_devices));
+
 	pm_power_off = n2100_power_off;
 
 	init_timer(&power_button_poll_timer);
_

Patches currently in -mm which might be from tbm@cyrius.com are

origin.patch
