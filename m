From: akpm@linux-foundation.org
Subject: + spi-eeprom-driver-cleanups.patch added to -mm tree
Date: Fri, 02 Feb 2007 15:18:28 -0800
Message-ID: <200702022318.l12NISom020561@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44140 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946157AbXBBXTY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Feb 2007 18:19:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net


The patch titled
     SPI eeprom driver minor updates
has been added to the -mm tree.  Its filename is
     spi-eeprom-driver-cleanups.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SPI eeprom driver minor updates
From: David Brownell <david-b@pacbell.net>

Minor cleanups to the SPI EEPROM driver:  remove yield() micro-optimization
(that can sometimes misbehave) and needless cast; fix typo.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/spi/at25.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

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

acpi-updates-rtc-cmos-device-platform_data.patch
git-mmc.patch
8250-make-probing-for-txen-bug-a-config-option.patch
pnp-export-pnp_bus_type.patch
rtc-framework-driver-for-cmos-rtcs.patch
spi-kconfig-fix.patch
spi-controller-driver-for-omap-microwire.patch
spi-controller-driver-for-omap-microwire-update.patch
spi-controller-driver-for-omap-microwire-update-fix.patch
spi-freescale-imx-spi-controller-driver-v5.patch
spi-doc-clarifications.patch
rtc-gets-sysfs-wakealarm-attribute.patch
spi-eeprom-driver.patch
spi-eeprom-driver-cleanups.patch
gpio-core.patch
omap-gpio-wrappers.patch
at91-gpio-wrappers.patch
