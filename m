From: akpm@linux-foundation.org
Subject: + spi-fix-spi_s3c24xx_gpio-device-handle-lookup.patch added to -mm tree
Date: Sat, 22 Nov 2008 13:15:46 -0800
Message-ID: <200811222115.mAMLFkVg024138@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41265 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751751AbYKVVQc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 22 Nov 2008 16:16:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben-linux@fluff.org, dbrownell@users.sourceforge.net


The patch titled
     spi: fix spi_s3c24xx_gpio device handle lookup
has been added to the -mm tree.  Its filename is
     spi-fix-spi_s3c24xx_gpio-device-handle-lookup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
backlight-value-of-ili9320_rgb_if2-register-should-not-be-hardcoded.patch
spi-fix-spi_s3c24xx_gpio-device-handle-lookup.patch
spi-fix-spi_s3c24xx_gpio-num_chipselect.patch
spi-use-generic-gpio-calls-in-spi_s3c24xx_gpio.patch

