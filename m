From: akpm@linux-foundation.org
Subject: - spi-fix-spi_s3c24xx_gpio-num_chipselect.patch removed from -mm tree
Date: Tue, 02 Dec 2008 10:38:43 -0800
Message-ID: <200812021838.mB2IchQ9007056@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36139 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754188AbYLBSj1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 13:39:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-linux@fluff.org, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi: fix spi_s3c24xx_gpio num_chipselect
has been removed from the -mm tree.  Its filename was
     spi-fix-spi_s3c24xx_gpio-num_chipselect.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: fix spi_s3c24xx_gpio num_chipselect
From: Ben Dooks <ben-linux@fluff.org>

The spi master driver must have num_chipselect set to allow the bus to
initialise.  Pass this through the platform data.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-s3c2410/include/mach/spi-gpio.h |    1 +
 drivers/spi/spi_s3c24xx_gpio.c                |    1 +
 2 files changed, 2 insertions(+)

diff -puN arch/arm/mach-s3c2410/include/mach/spi-gpio.h~spi-fix-spi_s3c24xx_gpio-num_chipselect arch/arm/mach-s3c2410/include/mach/spi-gpio.h
--- a/arch/arm/mach-s3c2410/include/mach/spi-gpio.h~spi-fix-spi_s3c24xx_gpio-num_chipselect
+++ a/arch/arm/mach-s3c2410/include/mach/spi-gpio.h
@@ -18,6 +18,7 @@ struct s3c2410_spigpio_info {
 	unsigned long		 pin_mosi;
 	unsigned long		 pin_miso;
 
+	int			 num_chipselect;
 	int			 bus_num;
 
 	void (*chip_select)(struct s3c2410_spigpio_info *spi, int cs);
diff -puN drivers/spi/spi_s3c24xx_gpio.c~spi-fix-spi_s3c24xx_gpio-num_chipselect drivers/spi/spi_s3c24xx_gpio.c
--- a/drivers/spi/spi_s3c24xx_gpio.c~spi-fix-spi_s3c24xx_gpio-num_chipselect
+++ a/drivers/spi/spi_s3c24xx_gpio.c
@@ -118,6 +118,7 @@ static int s3c2410_spigpio_probe(struct 
 	/* setup spi bitbang adaptor */
 	sp->bitbang.master = spi_master_get(master);
 	sp->bitbang.master->bus_num = info->bus_num;
+	sp->bitbang.master->num_chipselect = info->num_chipselect;
 	sp->bitbang.chipselect = s3c2410_spigpio_chipselect;
 
 	sp->bitbang.txrx_word[SPI_MODE_0] = s3c2410_spigpio_txrx_mode0;
_

Patches currently in -mm which might be from ben-linux@fluff.org are

linux-next.patch
backlight-value-of-ili9320_rgb_if2-register-should-not-be-hardcoded.patch
spi-use-generic-gpio-calls-in-spi_s3c24xx_gpio.patch

