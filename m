From: akpm@linux-foundation.org
Subject: - spi-eeprom-driver-cleanups.patch removed from -mm tree
Date: Sun, 11 Feb 2007 23:22:54 -0800
Message-ID: <200702120722.l1C7Msvn024707@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44753 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932939AbXBLHW6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 02:22:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     SPI eeprom driver minor updates
has been removed from the -mm tree.  Its filename was
     spi-eeprom-driver-cleanups.patch

This patch was dropped because it was folded into spi-eeprom-driver.patch

------------------------------------------------------
Subject: SPI eeprom driver minor updates
From: David Brownell <david-b@pacbell.net>

Minor cleanups to the SPI EEPROM driver:  remove yield() micro-optimization
(that can sometimes misbehave) and needless cast; fix typo.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/at25.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN drivers/spi/at25.c~spi-eeprom-driver-cleanups drivers/spi/at25.c
--- a/drivers/spi/at25.c~spi-eeprom-driver-cleanups
+++ a/drivers/spi/at25.c
@@ -171,12 +171,9 @@ at25_ee_write(struct at25_data *at25, ch
 		 * to readonly sections of the EEPROM...
 		 */
 
-		/* Wait for non-busy status, to avoid a potentially
-		 * slooow msleep() but always checking a few times.
-		 */
+		/* Wait for non-busy status */
 		timeout = jiffies + msecs_to_jiffies(EE_TIMEOUT);
 		retries = 0;
-		yield();
 		do {
 			int	sr;
 
@@ -264,7 +261,7 @@ static int at25_probe(struct spi_device 
 	}
 
 	/* Ping the chip ... the status register is pretty portable,
-	 * unlike probing manufacturer ides.  We do expect that system
+	 * unlike probing manufacturer IDs.  We do expect that system
 	 * firmware didn't write it in the past few milliseconds!
 	 */
 	sr = spi_w8r8(spi, AT25_RDSR);
@@ -320,7 +317,7 @@ static int __devexit at25_remove(struct 
 	struct at25_data	*at25;
 
 	at25 = dev_get_drvdata(&spi->dev);
-	(void) sysfs_remove_bin_file(&spi->dev.kobj, &at25->bin);
+	sysfs_remove_bin_file(&spi->dev.kobj, &at25->bin);
 	kfree(at25);
 	return 0;
 }
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
spi-kconfig-fix.patch
spi-controller-driver-for-omap-microwire.patch
spi-freescale-imx-spi-controller-driver-bis.patch
spi-doc-clarifications.patch
rtc-gets-sysfs-wakealarm-attribute.patch
spi-eeprom-driver.patch
spi-eeprom-driver-cleanups.patch
gpio-core.patch
omap-gpio-wrappers.patch
at91-gpio-wrappers.patch
