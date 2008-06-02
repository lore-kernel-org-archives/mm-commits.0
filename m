From: akpm@linux-foundation.org
Subject: - leds-add-pca9532-platform-data-for-thecus-n2100.patch removed from -mm tree
Date: Mon, 02 Jun 2008 13:00:53 -0700
Message-ID: <200806022000.m52K0rWj030111@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35087 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752078AbYFBUBt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Jun 2008 16:01:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riku.voipio@iki.fi, buytenh@wantstofly.org, rmk@arm.linux.org.uk, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     leds: add pca9532 platform data for Thecus N2100
has been removed from the -mm tree.  Its filename was
     leds-add-pca9532-platform-data-for-thecus-n2100.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds: add pca9532 platform data for Thecus N2100
From: Riku Voipio <riku.voipio@iki.fi>

Thecus N2100 has leds and a buzzer attached to a pca9532 controller.  Attach
the driver to the i2c bus and define the pca9532 pin coniguration for this
platform in n2100_leds.

With this patch, support for N2100 should be complete in mainline Linux.

Signed-off-by: Riku Voipio <riku.voipio@iki.fi>
Acked-by: Richard Purdie <rpurdie@rpsys.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Acked-by: Lennert Buytenhek <buytenh@wantstofly.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-iop32x/n2100.c |   52 +++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff -puN arch/arm/mach-iop32x/n2100.c~leds-add-pca9532-platform-data-for-thecus-n2100 arch/arm/mach-iop32x/n2100.c
--- a/arch/arm/mach-iop32x/n2100.c~leds-add-pca9532-platform-data-for-thecus-n2100
+++ a/arch/arm/mach-iop32x/n2100.c
@@ -17,6 +17,7 @@
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/f75375s.h>
+#include <linux/leds-pca9532.h>
 #include <linux/delay.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
@@ -206,6 +207,53 @@ static struct f75375s_platform_data n210
 	.pwm_enable = { 0, 0 },
 };
 
+static struct pca9532_platform_data n2100_leds = {
+	.leds = {
+	{	.name = "n2100:red:satafail0",
+		.state = PCA9532_OFF,
+		.type = PCA9532_TYPE_LED,
+	},
+	{	.name = "n2100:red:satafail1",
+		.state = PCA9532_OFF,
+		.type = PCA9532_TYPE_LED,
+	},
+	{	.name = "n2100:blue:usb",
+		.state = PCA9532_OFF,
+		.type = PCA9532_TYPE_LED,
+	},
+	{ 	.type = PCA9532_TYPE_NONE },
+
+	{ 	.type = PCA9532_TYPE_NONE },
+	{ 	.type = PCA9532_TYPE_NONE },
+	{ 	.type = PCA9532_TYPE_NONE },
+	{	.name = "n2100:red:usb",
+		.state = PCA9532_OFF,
+		.type = PCA9532_TYPE_LED,
+	},
+
+	{	.type = PCA9532_TYPE_NONE }, /* power OFF gpio */
+	{	.type = PCA9532_TYPE_NONE }, /* reset gpio */
+	{	.type = PCA9532_TYPE_NONE },
+	{	.type = PCA9532_TYPE_NONE },
+
+	{	.type = PCA9532_TYPE_NONE },
+	{	.name = "n2100:orange:system",
+		.state = PCA9532_OFF,
+		.type = PCA9532_TYPE_LED,
+	},
+	{	.name = "n2100:red:system",
+		.state = PCA9532_OFF,
+		.type = PCA9532_TYPE_LED,
+	},
+	{	.name = "N2100 beeper"  ,
+		.state =  PCA9532_OFF,
+		.type = PCA9532_TYPE_N2100_BEEP,
+	},
+	},
+	.psc = { 0, 0 },
+	.pwm = { 0, 0 },
+};
+
 static struct i2c_board_info __initdata n2100_i2c_devices[] = {
 	{
 		I2C_BOARD_INFO("rs5c372b", 0x32),
@@ -214,6 +262,10 @@ static struct i2c_board_info __initdata 
 		I2C_BOARD_INFO("f75375", 0x2e),
 		.platform_data = &n2100_f75375s,
 	},
+	{
+		I2C_BOARD_INFO("pca9532", 0x60),
+		.platform_data = &n2100_leds,
+	},
 };
 
 /*
_

Patches currently in -mm which might be from riku.voipio@iki.fi are

git-leds.patch

