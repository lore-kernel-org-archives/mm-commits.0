From: akpm@linux-foundation.org
Subject: + s3c24xx-spi-controllers-both-select-bitbang.patch added to -mm tree
Date: Mon, 11 Jun 2007 21:20:47 -0700
Message-ID: <200706120420.l5C4Kl6h004115@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36834 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755582AbXFLEVK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 00:21:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net


The patch titled
     S3c24xx SPI controllers both select 'bitbang'
has been added to the -mm tree.  Its filename is
     s3c24xx-spi-controllers-both-select-bitbang.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: S3c24xx SPI controllers both select 'bitbang'
From: David Brownell <david-b@pacbell.net>

Tweak Kconfig for the S3C24XX SPI controller drivers.  Both use the bitbang
framework; only one previously said that.  Plus in this case "select" is
the right way to manage that dependency, since folk will not know up front
to enable bitbang in order to even see those S3C drivers in order to enable
them.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/Kconfig |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/spi/Kconfig~s3c24xx-spi-controllers-both-select-bitbang drivers/spi/Kconfig
--- a/drivers/spi/Kconfig~s3c24xx-spi-controllers-both-select-bitbang
+++ a/drivers/spi/Kconfig
@@ -154,12 +154,14 @@ config SPI_PXA2XX
 config SPI_S3C24XX
 	tristate "Samsung S3C24XX series SPI"
 	depends on SPI_MASTER && ARCH_S3C2410 && EXPERIMENTAL
+	select SPI_BITBANG
 	help
 	  SPI driver for Samsung S3C24XX series ARM SoCs
 
 config SPI_S3C24XX_GPIO
 	tristate "Samsung S3C24XX series SPI by GPIO"
-	depends on SPI_MASTER && ARCH_S3C2410 && SPI_BITBANG && EXPERIMENTAL
+	depends on SPI_MASTER && ARCH_S3C2410 && EXPERIMENTAL
+	select SPI_BITBANG
 	help
 	  SPI driver for Samsung S3C24XX series ARM SoCs using
 	  GPIO lines to provide the SPI bus. This can be used where
_

Patches currently in -mm which might be from david-b@pacbell.net are

git-avr32.patch
git-leds.patch
git-mmc.patch
git-backlight.patch
char-genrtc-use-wait_event_interruptible.patch
spi-controller-drivers-check-for-unsupported-modes.patch
spi-controller-drivers-check-for-unsupported-modes-update.patch
spi-add-3wire-mode-flag.patch
spi-add-3wire-mode-flag-fix.patch
spidev-compiler-warning-gone.patch
spi_lm70llp-parport-adapter-driver-correction.patch
spi_mpc83xxc-underclocking-hotfix.patch
atmel_spi-minor-updates.patch
s3c24xx-spi-controllers-both-select-bitbang.patch
rtc-ds1307-cleanups.patch
rtc-rs5c372-becomes-a-new-style-i2c-driver.patch
thecus-n2100-register-rtc-rs5c372-i2c-device.patch
rtc-make-example-code-jump-to-done-instead-of-return-when-ioctl-not-supported.patch
rtc-dev-return-enotty-in-ioctl-if-irq_set_freq-is-not-implemented-by-driver.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-fix.patch
