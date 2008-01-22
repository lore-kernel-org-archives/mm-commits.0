From: akpm@linux-foundation.org
Subject: + spi-s3c-drivers-shouldnt-care-about-spi_board_info.patch added to -mm tree
Date: Tue, 22 Jan 2008 00:09:24 -0800
Message-ID: <200801220809.m0M895av011603@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44346 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751742AbYAVIKJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jan 2008 03:10:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, ben-linux@fluff.org, dbrownell@users.sourceforge.net, rmk@arm.linux.org.uk


The patch titled
     spi: s3c drivers shouldn't care about spi_board_info
has been added to the -mm tree.  Its filename is
     spi-s3c-drivers-shouldnt-care-about-spi_board_info.patch

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
Subject: spi: s3c drivers shouldn't care about spi_board_info
From: David Brownell <david-b@pacbell.net>

The two S3C SPI master drivers got merged without much review, so I just
noticed that they're doing something that the SPI core code is responsible
for, rather than any adapter driver: they try to register SPI devices.

This removes that support from those drivers so they act normally. 
Interestingly, none of the current boards are affected.  So it's a net code
shrink with no loss of functionality.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_s3c24xx.c               |   12 ------------
 drivers/spi/spi_s3c24xx_gpio.c          |   12 ------------
 include/asm-arm/arch-s3c2410/spi-gpio.h |    6 ------
 include/asm-arm/arch-s3c2410/spi.h      |    6 ------
 4 files changed, 36 deletions(-)

diff -puN drivers/spi/spi_s3c24xx.c~spi-s3c-drivers-shouldnt-care-about-spi_board_info drivers/spi/spi_s3c24xx.c
--- a/drivers/spi/spi_s3c24xx.c~spi-s3c-drivers-shouldnt-care-about-spi_board_info
+++ a/drivers/spi/spi_s3c24xx.c
@@ -237,10 +237,8 @@ static int __init s3c24xx_spi_probe(stru
 {
 	struct s3c24xx_spi *hw;
 	struct spi_master *master;
-	struct spi_board_info *bi;
 	struct resource *res;
 	int err = 0;
-	int i;
 
 	master = spi_alloc_master(&pdev->dev, sizeof(struct s3c24xx_spi));
 	if (master == NULL) {
@@ -348,16 +346,6 @@ static int __init s3c24xx_spi_probe(stru
 		goto err_register;
 	}
 
-	/* register all the devices associated */
-
-	bi = &hw->pdata->board_info[0];
-	for (i = 0; i < hw->pdata->board_size; i++, bi++) {
-		dev_info(hw->dev, "registering %s\n", bi->modalias);
-
-		bi->controller_data = hw;
-		spi_new_device(master, bi);
-	}
-
 	return 0;
 
  err_register:
diff -puN drivers/spi/spi_s3c24xx_gpio.c~spi-s3c-drivers-shouldnt-care-about-spi_board_info drivers/spi/spi_s3c24xx_gpio.c
--- a/drivers/spi/spi_s3c24xx_gpio.c~spi-s3c-drivers-shouldnt-care-about-spi_board_info
+++ a/drivers/spi/spi_s3c24xx_gpio.c
@@ -100,7 +100,6 @@ static int s3c2410_spigpio_probe(struct 
 	struct spi_master	*master;
 	struct s3c2410_spigpio  *sp;
 	int ret;
-	int i;
 
 	master = spi_alloc_master(&dev->dev, sizeof(struct s3c2410_spigpio));
 	if (master == NULL) {
@@ -143,17 +142,6 @@ static int s3c2410_spigpio_probe(struct 
 	if (ret)
 		goto err_no_bitbang;
 
-	/* register the chips to go with the board */
-
-	for (i = 0; i < sp->info->board_size; i++) {
-		dev_info(&dev->dev, "registering %p: %s\n",
-			 &sp->info->board_info[i],
-			 sp->info->board_info[i].modalias);
-
-		sp->info->board_info[i].controller_data = sp;
-		spi_new_device(master, sp->info->board_info + i);
-	}
-
 	return 0;
 
  err_no_bitbang:
diff -puN include/asm-arm/arch-s3c2410/spi-gpio.h~spi-s3c-drivers-shouldnt-care-about-spi_board_info include/asm-arm/arch-s3c2410/spi-gpio.h
--- a/include/asm-arm/arch-s3c2410/spi-gpio.h~spi-s3c-drivers-shouldnt-care-about-spi_board_info
+++ a/include/asm-arm/arch-s3c2410/spi-gpio.h
@@ -13,9 +13,6 @@
 #ifndef __ASM_ARCH_SPIGPIO_H
 #define __ASM_ARCH_SPIGPIO_H __FILE__
 
-struct s3c2410_spigpio_info;
-struct spi_board_info;
-
 struct s3c2410_spigpio_info {
 	unsigned long		 pin_clk;
 	unsigned long		 pin_mosi;
@@ -23,9 +20,6 @@ struct s3c2410_spigpio_info {
 
 	int			 bus_num;
 
-	unsigned long		 board_size;
-	struct spi_board_info	*board_info;
-
 	void (*chip_select)(struct s3c2410_spigpio_info *spi, int cs);
 };
 
diff -puN include/asm-arm/arch-s3c2410/spi.h~spi-s3c-drivers-shouldnt-care-about-spi_board_info include/asm-arm/arch-s3c2410/spi.h
--- a/include/asm-arm/arch-s3c2410/spi.h~spi-s3c-drivers-shouldnt-care-about-spi_board_info
+++ a/include/asm-arm/arch-s3c2410/spi.h
@@ -13,15 +13,9 @@
 #ifndef __ASM_ARCH_SPI_H
 #define __ASM_ARCH_SPI_H __FILE__
 
-struct s3c2410_spi_info;
-struct spi_board_info;
-
 struct s3c2410_spi_info {
 	unsigned long		 pin_cs;	/* simple gpio cs */
 
-	unsigned long		 board_size;
-	struct spi_board_info	*board_info;
-
 	void (*set_cs)(struct s3c2410_spi_info *spi, int cs, int pol);
 };
 
_

Patches currently in -mm which might be from david-b@pacbell.net are

git-acpi.patch
git-arm.patch
i2c-isp1301_omap-new-style-i2c-driver-updates-part-1.patch
i2c-isp1301_omap-new-style-i2c-driver-updates-part-2.patch
git-input.patch
git-mmc.patch
git-mtd.patch
pcmcia-stop-updating-dev-powerpower_state.patch
usb-dma-bounce-buffer-support-v3-fix.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
remove-pointless-casts-from-void-pointers.patch
spi-core-stop-updating-dev-powerpower_state.patch
spi-s3c-drivers-shouldnt-care-about-spi_board_info.patch
cosmetic-fixes-to-rtc-subsystems-kconfig.patch
rtc-pcf8583-dont-abuse-i2c_m_nostart.patch
rtc-s3c-use-is_power_of_2-macro-for-simplicity.patch
rtc-cmos-exports-nvram-in-sysfs.patch
rtc-cmos-alarm-acts-as-oneshot.patch
platform-real-time-clock-driver-for-dallas-1511-chip.patch
make-config_hpet_emulate_rtc-usable-from-modules.patch
use-the-irq-callback-interface-in-old-rtc-driver.patch
add-hpet-rtc-emulation-to-rtc_drv_cmos.patch
w1-gpio-add-gpio-w1-bus-master-driver.patch
w1-gpio-add-gpio-w1-bus-master-driver-v3.patch
