From: akpm@linux-foundation.org
Subject: - s3c2410-add-bus-number-to-spi-gpio-driver.patch removed from -mm tree
Date: Fri, 30 Nov 2007 16:21:22 -0800
Message-ID: <200712010021.lB10LMaP031761@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34581 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757182AbXLAAWI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Nov 2007 19:22:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, ben-linux@fluff.org, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi: S3C2410: add bus number to SPI GPIO driver
has been removed from the -mm tree.  Its filename was
     s3c2410-add-bus-number-to-spi-gpio-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spi: S3C2410: add bus number to SPI GPIO driver
From: David Brownell <david-b@pacbell.net>

Allow passing a bus number through the platform data for the S3C2410 SPI
GPIO driver.   This is needed to support multiple SPI busses.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_s3c24xx_gpio.c          |    1 +
 include/asm-arm/arch-s3c2410/spi-gpio.h |    2 ++
 2 files changed, 3 insertions(+)

diff -puN drivers/spi/spi_s3c24xx_gpio.c~s3c2410-add-bus-number-to-spi-gpio-driver drivers/spi/spi_s3c24xx_gpio.c
--- a/drivers/spi/spi_s3c24xx_gpio.c~s3c2410-add-bus-number-to-spi-gpio-driver
+++ a/drivers/spi/spi_s3c24xx_gpio.c
@@ -118,6 +118,7 @@ static int s3c2410_spigpio_probe(struct 
 
 	/* setup spi bitbang adaptor */
 	sp->bitbang.master = spi_master_get(master);
+	sp->bitbang.master->bus_num = info->bus_num;
 	sp->bitbang.chipselect = s3c2410_spigpio_chipselect;
 
 	sp->bitbang.txrx_word[SPI_MODE_0] = s3c2410_spigpio_txrx_mode0;
diff -puN include/asm-arm/arch-s3c2410/spi-gpio.h~s3c2410-add-bus-number-to-spi-gpio-driver include/asm-arm/arch-s3c2410/spi-gpio.h
--- a/include/asm-arm/arch-s3c2410/spi-gpio.h~s3c2410-add-bus-number-to-spi-gpio-driver
+++ a/include/asm-arm/arch-s3c2410/spi-gpio.h
@@ -21,6 +21,8 @@ struct s3c2410_spigpio_info {
 	unsigned long		 pin_mosi;
 	unsigned long		 pin_miso;
 
+	int			 bus_num;
+
 	unsigned long		 board_size;
 	struct spi_board_info	*board_info;
 
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
rtc-dont-write-rtc-century-when-setting-a-wake-alarm.patch
git-mmc.patch
git-mtd.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
remove-pointless-casts-from-void-pointers.patch
spi-at25-driver-is-for-eeprom-not-flash.patch
spi-use-mutex-not-semaphore.patch
blackfin-spi-driver-use-cpu_relax-to-replace-continue-in-while-busywait.patch
blackfin-spi-driver-use-void-__iomem-for-regs_base.patch
blackfin-spi-driver-move-hard-coded-pin_req-to-board-file.patch
blackfin-spi-driver-reconfigure-speed_hz-and-bits_per_word-in-each-spi-transfer.patch
cosmetic-fixes-to-rtc-subsystems-kconfig.patch
rtc-pcf8583-dont-abuse-i2c_m_nostart.patch
rtc-s3c-use-is_power_of_2-macro-for-simplicity.patch
rtc-cmos-exports-nvram-in-sysfs.patch
rtc-cmos-alarm-acts-as-oneshot.patch
generic-gpio-gpio_chip-support.patch
generic-gpio-gpio_chip-support-fix.patch
generic-gpio-gpio_chip-support-gpiolib-locking-simplified.patch
avr32-uses-gpio_chip.patch
mcp23s08-spi-gpio-expander.patch
mcp23s08-spi-gpio-expander-checkpatch-fixes.patch
arm-pxa-gpiolib-support-make-pxa_gpio_chip-static.patch
pnp-request-ioport-and-iomem-resources-used-by-active-devices.patch
