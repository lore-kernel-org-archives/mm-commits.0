From: akpm@linux-foundation.org
Subject: + leds-add-pca9532-platform-data-for-thecus-n2100.patch added to -mm tree
Date: Tue, 29 Apr 2008 13:26:35 -0700
Message-ID: <200804292026.m3TKQZge008024@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41372 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762177AbYD2U11 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 16:27:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riku.voipio@iki.fi, rmk@arm.linux.org.uk, rpurdie@rpsys.net


The patch titled
     leds: add pca9532 platform data for Thecus N2100
has been added to the -mm tree.  Its filename is
     leds-add-pca9532-platform-data-for-thecus-n2100.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds: add pca9532 platform data for Thecus N2100
From: Riku Voipio <riku.voipio@iki.fi>

Thecus N2100 has leds and a buzzer attached to a pca9532 controller.  Attach
the driver to the i2c bus and define the pca9532 pin coniguration for this
platform in n2100_leds.

With this patch, support for N2100 should be complete in mainline Linux.

Signed-off-by: Riku Voipio <riku.voipio@iki.fi>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Russell King <rmk@arm.linux.org.uk>
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
 		I2C_BOARD_INFO("rtc-rs5c372", 0x32),
@@ -216,6 +264,10 @@ static struct i2c_board_info __initdata 
 		.type = "f75375",
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

leds-add-pca9532-led-driver.patch
leds-add-pca9532-platform-data-for-thecus-n2100.patch

