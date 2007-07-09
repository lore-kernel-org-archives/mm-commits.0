From: akpm@linux-foundation.org
Subject: - spi-add-3wire-mode-flag-fix.patch removed from -mm tree
Date: Mon, 09 Jul 2007 15:05:57 -0700
Message-ID: <200707092205.l69M5vnh015235@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59576 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754636AbXGIWGM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 18:06:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     SPI: add 3wire mode flag (fix)
has been removed from the -mm tree.  Its filename was
     spi-add-3wire-mode-flag-fix.patch

This patch was dropped because it was folded into spi-add-3wire-mode-flag.patch

------------------------------------------------------
Subject: SPI: add 3wire mode flag (fix)
From: David Brownell <david-b@pacbell.net>

Add missing parenthesis ... evidently GCC warns inconsistently.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/lm70.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/hwmon/lm70.c~spi-add-3wire-mode-flag-fix drivers/hwmon/lm70.c
--- a/drivers/hwmon/lm70.c~spi-add-3wire-mode-flag-fix
+++ a/drivers/hwmon/lm70.c
@@ -97,7 +97,7 @@ static int __devinit lm70_probe(struct s
 	int status;
 
 	/* signaling is SPI_MODE_0 on a 3-wire link (shared SI/SO) */
-	if ((spi->mode & (SPI_CPOL|SPI_CPHA)) || !spi->mode & SPI_3WIRE)
+	if ((spi->mode & (SPI_CPOL|SPI_CPHA)) || !(spi->mode & SPI_3WIRE))
 		return -EINVAL;
 
 	p_lm70 = kzalloc(sizeof *p_lm70, GFP_KERNEL);
_

Patches currently in -mm which might be from david-b@pacbell.net are

git-avr32.patch
pm-do-not-use-saved_state-from-struct-dev_pm_info-on-arm.patch
git-leds.patch
git-mmc.patch
git-mtd.patch
git-netdev-all.patch
git-backlight.patch
geode-basic-infrastructure-support-for-amd-geode-class.patch
char-genrtc-use-wait_event_interruptible.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
spi-controller-drivers-check-for-unsupported-modes.patch
spi-add-3wire-mode-flag.patch
spi-add-3wire-mode-flag-fix.patch
spidev-compiler-warning-gone.patch
spi_lm70llp-parport-adapter-driver-correction.patch
spi_mpc83xxc-underclocking-hotfix.patch
atmel_spi-minor-updates.patch
s3c24xx-spi-controllers-both-select-bitbang.patch
spi-master-driver-for-xilinx-virtex-fix-2.patch
spi-omap2_mcspi-driver-cleanups.patch
rtc-ds1307-cleanups.patch
rtc-rs5c372-becomes-a-new-style-i2c-driver.patch
thecus-n2100-register-rtc-rs5c372-i2c-device.patch
rtc-make-example-code-jump-to-done-instead-of-return-when-ioctl-not-supported.patch
rtc-dev-return-enotty-in-ioctl-if-irq_set_freq-is-not-implemented-by-driver.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-fix.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-fix-2.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-fix-3.patch
rtc-kconfig-tweax.patch
rtc-add-rtc-m41t80-driver-take-2.patch
rtc-add-rtc-m41t80-driver-take-2-fix.patch
rtc-watchdog-support-for-rtc-m41t80-driver-take-2.patch
