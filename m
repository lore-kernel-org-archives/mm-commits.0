From: akpm@linux-foundation.org
Subject: - spi-controller-drivers-check-for-unsupported-modes-update.patch removed from -mm tree
Date: Mon, 09 Jul 2007 15:05:46 -0700
Message-ID: <200707092205.l69M5kKO015232@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49844 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756198AbXGIWGA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 18:06:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi controller mode check update
has been removed from the -mm tree.  Its filename was
     spi-controller-drivers-check-for-unsupported-modes-update.patch

This patch was dropped because it was folded into spi-controller-drivers-check-for-unsupported-modes.patch

------------------------------------------------------
Subject: spi controller mode check update
From: David Brownell <david-b@pacbell.net>

This lets bitbanging SPI controller drivers declare that they
support modes like SPI_CS_HIGH and SPI_3WIRE.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bitbang.c       |   12 +++---------
 include/linux/spi/spi_bitbang.h |    1 +
 2 files changed, 4 insertions(+), 9 deletions(-)

diff -puN drivers/spi/spi_bitbang.c~spi-controller-drivers-check-for-unsupported-modes-update drivers/spi/spi_bitbang.c
--- a/drivers/spi/spi_bitbang.c~spi-controller-drivers-check-for-unsupported-modes-update
+++ a/drivers/spi/spi_bitbang.c
@@ -187,16 +187,10 @@ int spi_bitbang_setup(struct spi_device 
 
 	bitbang = spi_master_get_devdata(spi->master);
 
-	/* REVISIT: some systems will want to support devices using lsb-first
-	 * bit encodings on the wire.  In pure software that would be trivial,
-	 * just bitbang_txrx_le_cphaX() routines shifting the other way, and
-	 * some hardware controllers also have this support.
-	 *
-	 * REVISIT: we should accept SPI_CS_HIGH in some cases; it's
-	 * easy to implement that with GPIOs, but we don't know if the
-	 * underlying chipselect() method support that...
+	/* Bitbangers can support SPI_CS_HIGH, SPI_3WIRE, and so on;
+	 * add those to master->flags, and provide the other support.
 	 */
-	if ((spi->mode & ~(SPI_CPOL|SPI_CPHA)) != 0)
+	if ((spi->mode & ~(SPI_CPOL|SPI_CPHA|bitbang->flags)) != 0)
 		return -EINVAL;
 
 	if (!cs) {
diff -puN include/linux/spi/spi_bitbang.h~spi-controller-drivers-check-for-unsupported-modes-update include/linux/spi/spi_bitbang.h
--- a/include/linux/spi/spi_bitbang.h~spi-controller-drivers-check-for-unsupported-modes-update
+++ a/include/linux/spi/spi_bitbang.h
@@ -26,6 +26,7 @@ struct spi_bitbang {
 	struct list_head	queue;
 	u8			busy;
 	u8			use_dma;
+	u8			flags;		/* extra spi->mode support */
 
 	struct spi_master	*master;
 
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
spi-controller-drivers-check-for-unsupported-modes-update.patch
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
