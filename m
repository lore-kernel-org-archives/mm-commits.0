From: akpm@linux-foundation.org
Subject: - spi-driver-hotplug-coldplug-fixes.patch removed from -mm tree
Date: Fri, 31 Aug 2007 09:55:55 -0700
Message-ID: <200708311655.l7VGttZr017442@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33487 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760808AbXHaQ4h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 12:56:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, akonovalov@ru.mvista.com, dbrownell@users.sourceforge.net, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     SPI driver hotplug/coldplug fixes
has been removed from the -mm tree.  Its filename was
     spi-driver-hotplug-coldplug-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SPI driver hotplug/coldplug fixes
From: David Brownell <david-b@pacbell.net>

Update various SPI drivers so they properly support

  - coldplug through "modprobe $(cat /sys/devices/.../modalias)"

  - hotplug through "modprobe $(MODALIAS)"

The basic rule for platform, SPI, and (new style) I2C drivers is just
to make sure that modprobing the driver name works.  In this case, all
the relevant drivers are platform drivers, and this patch either

  (a)	Changes the driver name, if no in-tree code would break;
	this is simpler and thus preferable in the long term.

  (b)	Adds MODULE_ALIAS directives, when in-tree platforms declare
	devices using the current driver name; less desirable.

Most systems will link SPI controller drivers statically, but
there's no point in being needlessly broken.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Jean Delvare <khali@linux-fr.org>
Acked-by: Andrei Konovalov <akonovalov@ru.mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c      |    3 ++-
 drivers/spi/spi_imx.c          |    2 +-
 drivers/spi/spi_mpc83xx.c      |    1 +
 drivers/spi/spi_s3c24xx.c      |    1 +
 drivers/spi/spi_s3c24xx_gpio.c |    2 +-
 drivers/spi/spi_txx9.c         |    1 +
 drivers/spi/xilinx_spi.c       |    2 +-
 7 files changed, 8 insertions(+), 4 deletions(-)

diff -puN drivers/spi/spi_bfin5xx.c~spi-driver-hotplug-coldplug-fixes drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~spi-driver-hotplug-coldplug-fixes
+++ a/drivers/spi/spi_bfin5xx.c
@@ -1303,8 +1303,9 @@ static int bfin5xx_spi_resume(struct pla
 #define bfin5xx_spi_resume NULL
 #endif				/* CONFIG_PM */
 
+MODULE_ALIAS("bfin-spi-master");	/* for platform bus hotplug */
 static struct platform_driver bfin5xx_spi_driver = {
-	.driver 	= {
+	.driver	= {
 		.name	= "bfin-spi-master",
 		.owner	= THIS_MODULE,
 	},
diff -puN drivers/spi/spi_imx.c~spi-driver-hotplug-coldplug-fixes drivers/spi/spi_imx.c
--- a/drivers/spi/spi_imx.c~spi-driver-hotplug-coldplug-fixes
+++ a/drivers/spi/spi_imx.c
@@ -1735,7 +1735,7 @@ static int spi_imx_resume(struct platfor
 
 static struct platform_driver driver = {
 	.driver = {
-		.name = "imx-spi",
+		.name = "spi_imx",
 		.bus = &platform_bus_type,
 		.owner = THIS_MODULE,
 	},
diff -puN drivers/spi/spi_mpc83xx.c~spi-driver-hotplug-coldplug-fixes drivers/spi/spi_mpc83xx.c
--- a/drivers/spi/spi_mpc83xx.c~spi-driver-hotplug-coldplug-fixes
+++ a/drivers/spi/spi_mpc83xx.c
@@ -530,6 +530,7 @@ static int __devexit mpc83xx_spi_remove(
 	return 0;
 }
 
+MODULE_ALIAS("mpc83xx_spi");			/* for platform bus hotplug */
 static struct platform_driver mpc83xx_spi_driver = {
 	.probe = mpc83xx_spi_probe,
 	.remove = __devexit_p(mpc83xx_spi_remove),
diff -puN drivers/spi/spi_s3c24xx.c~spi-driver-hotplug-coldplug-fixes drivers/spi/spi_s3c24xx.c
--- a/drivers/spi/spi_s3c24xx.c~spi-driver-hotplug-coldplug-fixes
+++ a/drivers/spi/spi_s3c24xx.c
@@ -427,6 +427,7 @@ static int s3c24xx_spi_resume(struct pla
 #define s3c24xx_spi_resume  NULL
 #endif
 
+MODULE_ALIAS("s3c2410_spi");			/* for platform bus hotplug */
 static struct platform_driver s3c24xx_spidrv = {
 	.probe		= s3c24xx_spi_probe,
 	.remove		= s3c24xx_spi_remove,
diff -puN drivers/spi/spi_s3c24xx_gpio.c~spi-driver-hotplug-coldplug-fixes drivers/spi/spi_s3c24xx_gpio.c
--- a/drivers/spi/spi_s3c24xx_gpio.c~spi-driver-hotplug-coldplug-fixes
+++ a/drivers/spi/spi_s3c24xx_gpio.c
@@ -180,7 +180,7 @@ static struct platform_driver s3c2410_sp
         .suspend	= s3c2410_spigpio_suspend,
         .resume		= s3c2410_spigpio_resume,
         .driver		= {
-		.name	= "s3c24xx-spi-gpio",
+		.name	= "spi_s3c24xx_gpio",
 		.owner	= THIS_MODULE,
         },
 };
diff -puN drivers/spi/spi_txx9.c~spi-driver-hotplug-coldplug-fixes drivers/spi/spi_txx9.c
--- a/drivers/spi/spi_txx9.c~spi-driver-hotplug-coldplug-fixes
+++ a/drivers/spi/spi_txx9.c
@@ -450,6 +450,7 @@ static int __exit txx9spi_remove(struct 
 	return 0;
 }
 
+MODULE_ALIAS("txx9spi");			/* for platform bus hotplug */
 static struct platform_driver txx9spi_driver = {
 	.remove = __exit_p(txx9spi_remove),
 	.driver = {
diff -puN drivers/spi/xilinx_spi.c~spi-driver-hotplug-coldplug-fixes drivers/spi/xilinx_spi.c
--- a/drivers/spi/xilinx_spi.c~spi-driver-hotplug-coldplug-fixes
+++ a/drivers/spi/xilinx_spi.c
@@ -21,7 +21,7 @@
 
 #include <syslib/virtex_devices.h>
 
-#define XILINX_SPI_NAME "xspi"
+#define XILINX_SPI_NAME "xilinx_spi"
 
 /* Register definitions as per "OPB Serial Peripheral Interface (SPI) (v1.00e)
  * Product Specification", DS464
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
git-avr32.patch
mips-add-gpio-support-to-the-bcm947xx-platform.patch
mips-gpio-led-driver-for-the-wgt634u-machine.patch
git-mmc.patch
git-mtd.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91.patch
clean-up-duplicate-includes-in-drivers-spi.patch
spi-driver-runtime-footprint-shrinkage.patch
rtc-periodic-irq-fix.patch
rtc_irq_set_freq-requires-power-of-two-and-associated-kerneldoc.patch
add-missing-newlines-to-some-uses-of-dev_level-messages.patch
