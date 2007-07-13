From: akpm@linux-foundation.org
Subject: + csb337-supports-new-style-rtc-ds1307.patch added to -mm tree
Date: Fri, 13 Jul 2007 01:39:58 -0700
Message-ID: <200707130839.l6D8dwkT009015@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49549 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762643AbXGMIkt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 04:40:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, a.zummo@towertech.it, andrew@sanpeople.com, bgat@billgatliff.com, dbrownell@users.sourceforge.net, rmk@arm.linux.org.uk


The patch titled
     csb337 supports "new style" rtc-ds1307
has been added to the -mm tree.  Its filename is
     csb337-supports-new-style-rtc-ds1307.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
git-avr32.patch
pm-do-not-use-saved_state-from-struct-dev_pm_info-on-arm.patch
git-mmc.patch
git-mtd.patch
geode-basic-infrastructure-support-for-amd-geode-class.patch
char-genrtc-use-wait_event_interruptible.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
gpio-calls-dont-need-i-o-barriers.patch
dev_vdbg-available-with-dverbose_debug.patch
spi-controller-drivers-check-for-unsupported-modes.patch
spi-add-3wire-mode-flag.patch
spidev-compiler-warning-gone.patch
spi_mpc83xxc-underclocking-hotfix.patch
atmel_spi-minor-updates.patch
atmel_spi-dont-always-deselect-chip-between-messages.patch
s3c24xx-spi-controllers-both-select-bitbang.patch
spi-master-driver-for-xilinx-virtex.patch
spi-omap2_mcspi-driver.patch
rtc-ds1307-cleanups.patch
rtc-rs5c372-becomes-a-new-style-i2c-driver.patch
thecus-n2100-register-rtc-rs5c372-i2c-device.patch
rtc-make-example-code-jump-to-done-instead-of-return-when-ioctl-not-supported.patch
rtc-dev-return-enotty-in-ioctl-if-irq_set_freq-is-not-implemented-by-driver.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-update.patch
rtc-kconfig-tweax.patch
rtc-add-rtc-m41t80-driver-take-2.patch
rtc-watchdog-support-for-rtc-m41t80-driver-take-2.patch
csb337-supports-new-style-rtc-ds1307.patch
omap-add-ti-twl92330-menelaus-power-management-chip-driver.patch
