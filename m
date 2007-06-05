From: akpm@linux-foundation.org
Subject: + thecus-n2100-register-rtc-rs5c372-i2c-device.patch added to -mm tree
Date: Mon, 04 Jun 2007 20:36:57 -0700
Message-ID: <200706050336.l553atXR028490@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45946 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756873AbXFEDhZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jun 2007 23:37:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tbm@cyrius.com, Riku.Voipio@movial.fi, buytenh@wantstofly.org, david-b@pacbell.net, khali@linux-fr.org, rmk@arm.linux.org.uk


The patch titled
     Thecus N2100: register rtc-rs5c372 i2c device
has been added to the -mm tree.  Its filename is
     thecus-n2100-register-rtc-rs5c372-i2c-device.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 arch/arm/mach-iop32x/n2100.c |    9 +++++++++
 1 file changed, 9 insertions(+)

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
@@ -245,6 +252,8 @@ static void __init n2100_init_machine(vo
 	platform_device_register(&iop3xx_i2c0_device);
 	platform_device_register(&n2100_flash_device);
 	platform_device_register(&n2100_serial_device);
+	i2c_register_board_info(0, n2100_i2c_devices,
+		ARRAY_SIZE(n2100_i2c_devices));
 
 	pm_power_off = n2100_power_off;
 
_

Patches currently in -mm which might be from tbm@cyrius.com are

i2c-iop3xx-switch-to-static-adapter-numbering.patch
thecus-n2100-register-rtc-rs5c372-i2c-device.patch
update-zilog-timeout.patch
rtc-rs5c372-becomes-a-new-style-i2c-driver.patch
