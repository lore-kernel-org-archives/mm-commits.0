From: akpm@linux-foundation.org
Subject: - spi-fix-spi_s3c24xx_gpio-device-handle-lookup.patch removed from -mm tree
Date: Tue, 02 Dec 2008 10:38:40 -0800
Message-ID: <200812021838.mB2Icev5007052@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41900 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753564AbYLBSjT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 13:39:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-linux@fluff.org, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi: fix spi_s3c24xx_gpio device handle lookup
has been removed from the -mm tree.  Its filename was
     spi-fix-spi_s3c24xx_gpio-device-handle-lookup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: fix spi_s3c24xx_gpio device handle lookup
From: Ben Dooks <ben-linux@fluff.org>

The spidev_to_sg() call in spi_s3c24xx_gpio.c was using the wrong method
to convert the spi device into the private data for the driver.  Fix this
by using spi_master_get_devdata.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_s3c24xx_gpio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/spi/spi_s3c24xx_gpio.c~spi-fix-spi_s3c24xx_gpio-device-handle-lookup drivers/spi/spi_s3c24xx_gpio.c
--- a/drivers/spi/spi_s3c24xx_gpio.c~spi-fix-spi_s3c24xx_gpio-device-handle-lookup
+++ a/drivers/spi/spi_s3c24xx_gpio.c
@@ -34,7 +34,7 @@ struct s3c2410_spigpio {
 
 static inline struct s3c2410_spigpio *spidev_to_sg(struct spi_device *spi)
 {
-	return spi->controller_data;
+	return spi_master_get_devdata(spi->master);
 }
 
 static inline void setsck(struct spi_device *dev, int on)
_

Patches currently in -mm which might be from ben-linux@fluff.org are

linux-next.patch
backlight-value-of-ili9320_rgb_if2-register-should-not-be-hardcoded.patch
spi-use-generic-gpio-calls-in-spi_s3c24xx_gpio.patch

