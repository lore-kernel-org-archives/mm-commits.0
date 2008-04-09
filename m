From: akpm@linux-foundation.org
Subject: + spi-fix-platform-driver-hotplug-coldplug.patch added to -mm tree
Date: Wed, 09 Apr 2008 14:46:50 -0700
Message-ID: <200804092146.m39LkoV0031465@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46334 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753446AbYDIVq6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Apr 2008 17:46:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kay.sievers@vrfy.org, dbrownell@users.sourceforge.net


The patch titled
     spi: fix platform driver hotplug/coldplug
has been added to the -mm tree.  Its filename is
     spi-fix-platform-driver-hotplug-coldplug.patch

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
Subject: spi: fix platform driver hotplug/coldplug
From: Kay Sievers <kay.sievers@vrfy.org>

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf, the platform modalias is
prefixed with "platform:".  Add MODULE_ALIAS() to the hotpluggable SPI
platform drivers, to allow module auto loading.

[dbrownell@users.sourceforge.net: more drivers: registration fixes]
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/atmel_spi.c        |    1 +
 drivers/spi/au1550_spi.c       |    3 +++
 drivers/spi/mpc52xx_psc_spi.c  |    3 +++
 drivers/spi/omap2_mcspi.c      |    3 +++
 drivers/spi/omap_uwire.c       |    4 +++-
 drivers/spi/pxa2xx_spi.c       |    2 +-
 drivers/spi/spi_bfin5xx.c      |    2 +-
 drivers/spi/spi_imx.c          |    4 +++-
 drivers/spi/spi_mpc83xx.c      |    5 +++--
 drivers/spi/spi_s3c24xx.c      |    2 +-
 drivers/spi/spi_s3c24xx_gpio.c |    2 ++
 drivers/spi/spi_sh_sci.c       |    1 +
 drivers/spi/spi_txx9.c         |    3 +++
 drivers/spi/xilinx_spi.c       |    3 +++
 14 files changed, 31 insertions(+), 7 deletions(-)

diff -puN drivers/spi/atmel_spi.c~spi-fix-platform-driver-hotplug-coldplug drivers/spi/atmel_spi.c
--- a/drivers/spi/atmel_spi.c~spi-fix-platform-driver-hotplug-coldplug
+++ a/drivers/spi/atmel_spi.c
@@ -863,3 +863,4 @@ module_exit(atmel_spi_exit);
 MODULE_DESCRIPTION("Atmel AT32/AT91 SPI Controller driver");
 MODULE_AUTHOR("Haavard Skinnemoen <hskinnemoen@atmel.com>");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:atmel_spi");
diff -puN drivers/spi/au1550_spi.c~spi-fix-platform-driver-hotplug-coldplug drivers/spi/au1550_spi.c
--- a/drivers/spi/au1550_spi.c~spi-fix-platform-driver-hotplug-coldplug
+++ a/drivers/spi/au1550_spi.c
@@ -958,6 +958,9 @@ static int __exit au1550_spi_remove(stru
 	return 0;
 }
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:au1550-spi");
+
 static struct platform_driver au1550_spi_drv = {
 	.remove = __exit_p(au1550_spi_remove),
 	.driver = {
diff -puN drivers/spi/mpc52xx_psc_spi.c~spi-fix-platform-driver-hotplug-coldplug drivers/spi/mpc52xx_psc_spi.c
--- a/drivers/spi/mpc52xx_psc_spi.c~spi-fix-platform-driver-hotplug-coldplug
+++ a/drivers/spi/mpc52xx_psc_spi.c
@@ -500,6 +500,9 @@ static int __exit mpc52xx_psc_spi_remove
 	return mpc52xx_psc_spi_do_remove(&dev->dev);
 }
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:mpc52xx-psc-spi");
+
 static struct platform_driver mpc52xx_psc_spi_platform_driver = {
 	.remove = __exit_p(mpc52xx_psc_spi_remove),
 	.driver = {
diff -puN drivers/spi/omap2_mcspi.c~spi-fix-platform-driver-hotplug-coldplug drivers/spi/omap2_mcspi.c
--- a/drivers/spi/omap2_mcspi.c~spi-fix-platform-driver-hotplug-coldplug
+++ a/drivers/spi/omap2_mcspi.c
@@ -1084,6 +1084,9 @@ static int __exit omap2_mcspi_remove(str
 	return 0;
 }
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:omap2_mcspi");
+
 static struct platform_driver omap2_mcspi_driver = {
 	.driver = {
 		.name =		"omap2_mcspi",
diff -puN drivers/spi/omap_uwire.c~spi-fix-platform-driver-hotplug-coldplug drivers/spi/omap_uwire.c
--- a/drivers/spi/omap_uwire.c~spi-fix-platform-driver-hotplug-coldplug
+++ a/drivers/spi/omap_uwire.c
@@ -537,10 +537,12 @@ static int __exit uwire_remove(struct pl
 	return status;
 }
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:omap_uwire");
+
 static struct platform_driver uwire_driver = {
 	.driver = {
 		.name		= "omap_uwire",
-		.bus		= &platform_bus_type,
 		.owner		= THIS_MODULE,
 	},
 	.remove		= __exit_p(uwire_remove),
diff -puN drivers/spi/pxa2xx_spi.c~spi-fix-platform-driver-hotplug-coldplug drivers/spi/pxa2xx_spi.c
--- a/drivers/spi/pxa2xx_spi.c~spi-fix-platform-driver-hotplug-coldplug
+++ a/drivers/spi/pxa2xx_spi.c
@@ -44,6 +44,7 @@
 MODULE_AUTHOR("Stephen Street");
 MODULE_DESCRIPTION("PXA2xx SSP SPI Controller");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:pxa2xx-spi");
 
 #define MAX_BUSES 3
 
@@ -1581,7 +1582,6 @@ static int pxa2xx_spi_resume(struct plat
 static struct platform_driver driver = {
 	.driver = {
 		.name = "pxa2xx-spi",
-		.bus = &platform_bus_type,
 		.owner = THIS_MODULE,
 	},
 	.remove = pxa2xx_spi_remove,
diff -puN drivers/spi/spi_bfin5xx.c~spi-fix-platform-driver-hotplug-coldplug drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~spi-fix-platform-driver-hotplug-coldplug
+++ a/drivers/spi/spi_bfin5xx.c
@@ -1396,7 +1396,7 @@ static int bfin5xx_spi_resume(struct pla
 #define bfin5xx_spi_resume NULL
 #endif				/* CONFIG_PM */
 
-MODULE_ALIAS("bfin-spi-master");	/* for platform bus hotplug */
+MODULE_ALIAS("platform:bfin-spi");
 static struct platform_driver bfin5xx_spi_driver = {
 	.driver	= {
 		.name	= DRV_NAME,
diff -puN drivers/spi/spi_imx.c~spi-fix-platform-driver-hotplug-coldplug drivers/spi/spi_imx.c
--- a/drivers/spi/spi_imx.c~spi-fix-platform-driver-hotplug-coldplug
+++ a/drivers/spi/spi_imx.c
@@ -1722,10 +1722,12 @@ static int spi_imx_resume(struct platfor
 #define spi_imx_resume NULL
 #endif /* CONFIG_PM */
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:spi_imx");
+
 static struct platform_driver driver = {
 	.driver = {
 		.name = "spi_imx",
-		.bus = &platform_bus_type,
 		.owner = THIS_MODULE,
 	},
 	.remove = __exit_p(spi_imx_remove),
diff -puN drivers/spi/spi_mpc83xx.c~spi-fix-platform-driver-hotplug-coldplug drivers/spi/spi_mpc83xx.c
--- a/drivers/spi/spi_mpc83xx.c~spi-fix-platform-driver-hotplug-coldplug
+++ a/drivers/spi/spi_mpc83xx.c
@@ -523,11 +523,12 @@ static int __exit mpc83xx_spi_remove(str
 	return 0;
 }
 
-MODULE_ALIAS("mpc83xx_spi");			/* for platform bus hotplug */
+MODULE_ALIAS("platform:mpc83xx_spi");
 static struct platform_driver mpc83xx_spi_driver = {
 	.remove = __exit_p(mpc83xx_spi_remove),
 	.driver = {
-		   .name = "mpc83xx_spi",
+		.name = "mpc83xx_spi",
+		.owner = THIS_MODULE,
 	},
 };
 
diff -puN drivers/spi/spi_s3c24xx.c~spi-fix-platform-driver-hotplug-coldplug drivers/spi/spi_s3c24xx.c
--- a/drivers/spi/spi_s3c24xx.c~spi-fix-platform-driver-hotplug-coldplug
+++ a/drivers/spi/spi_s3c24xx.c
@@ -415,7 +415,7 @@ static int s3c24xx_spi_resume(struct pla
 #define s3c24xx_spi_resume  NULL
 #endif
 
-MODULE_ALIAS("s3c2410_spi");			/* for platform bus hotplug */
+MODULE_ALIAS("platform:s3c2410-spi");
 static struct platform_driver s3c24xx_spidrv = {
 	.remove		= __exit_p(s3c24xx_spi_remove),
 	.suspend	= s3c24xx_spi_suspend,
diff -puN drivers/spi/spi_s3c24xx_gpio.c~spi-fix-platform-driver-hotplug-coldplug drivers/spi/spi_s3c24xx_gpio.c
--- a/drivers/spi/spi_s3c24xx_gpio.c~spi-fix-platform-driver-hotplug-coldplug
+++ a/drivers/spi/spi_s3c24xx_gpio.c
@@ -168,6 +168,8 @@ static int s3c2410_spigpio_remove(struct
 #define s3c2410_spigpio_suspend NULL
 #define s3c2410_spigpio_resume NULL
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:spi_s3c24xx_gpio");
 
 static struct platform_driver s3c2410_spigpio_drv = {
 	.probe		= s3c2410_spigpio_probe,
diff -puN drivers/spi/spi_sh_sci.c~spi-fix-platform-driver-hotplug-coldplug drivers/spi/spi_sh_sci.c
--- a/drivers/spi/spi_sh_sci.c~spi-fix-platform-driver-hotplug-coldplug
+++ a/drivers/spi/spi_sh_sci.c
@@ -203,3 +203,4 @@ module_exit(sh_sci_spi_exit);
 MODULE_DESCRIPTION("SH SCI SPI Driver");
 MODULE_AUTHOR("Magnus Damm <damm@opensource.se>");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:spi_sh_sci");
diff -puN drivers/spi/spi_txx9.c~spi-fix-platform-driver-hotplug-coldplug drivers/spi/spi_txx9.c
--- a/drivers/spi/spi_txx9.c~spi-fix-platform-driver-hotplug-coldplug
+++ a/drivers/spi/spi_txx9.c
@@ -450,6 +450,9 @@ static int __exit txx9spi_remove(struct 
 	return 0;
 }
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:spi_txx9");
+
 static struct platform_driver txx9spi_driver = {
 	.remove = __exit_p(txx9spi_remove),
 	.driver = {
diff -puN drivers/spi/xilinx_spi.c~spi-fix-platform-driver-hotplug-coldplug drivers/spi/xilinx_spi.c
--- a/drivers/spi/xilinx_spi.c~spi-fix-platform-driver-hotplug-coldplug
+++ a/drivers/spi/xilinx_spi.c
@@ -408,6 +408,9 @@ static int __devexit xilinx_spi_remove(s
 	return 0;
 }
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:" XILINX_SPI_NAME);
+
 static struct platform_driver xilinx_spi_driver = {
 	.probe	= xilinx_spi_probe,
 	.remove	= __devexit_p(xilinx_spi_remove),
_

Patches currently in -mm which might be from kay.sievers@vrfy.org are

i2c-fix-platform-driver-hotplug-coldplug.patch
spi-fix-platform-driver-hotplug-coldplug.patch
pm-remove-destroy_suspended_device.patch
sysfs-refill-attribute-buffer-when-reading-from-offset-0.patch
pm-introduce-new-top-level-suspend-and-hibernation-callbacks-rev-7.patch
pm-new-suspend-and-hibernation-callbacks-for-platform-bus-type-rev-3.patch
pm-new-suspend-and-hibernation-callbacks-for-pci-bus-type-rev-3.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
infrastructure-to-debug-dynamic-objects.patch
debugobjects-add-documentation.patch
debugobjects-add-timer-specific-object-debugging-code.patch
add-hrtimer-specific-debugobjects-code.patch
cpu-change-cpu_sys_devices-from-array-to-per_cpu-variable.patch

