From: akpm@linux-foundation.org
Subject: + i2c-fix-platform-driver-hotplug-coldplug.patch added to -mm tree
Date: Wed, 09 Apr 2008 14:13:41 -0700
Message-ID: <200804092113.m39LDfXg030334@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55712 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750942AbYDIVOE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Apr 2008 17:14:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kay.sievers@vrfy.org, dbrownell@users.sourceforge.net, greg@kroah.com, khali@linux-fr.org


The patch titled
     i2c: fix platform driver hotplug/coldplug
has been added to the -mm tree.  Its filename is
     i2c-fix-platform-driver-hotplug-coldplug.patch

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
Subject: i2c: fix platform driver hotplug/coldplug
From: Kay Sievers <kay.sievers@vrfy.org>

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf, the platform modalias is
prefixed with "platform:".  Add MODULE_ALIAS() to the hotpluggable I2C
platform drivers, to allow module auto loading.

[dbrownell@users.sourceforge.net: add some more drivers]
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg KH <greg@kroah.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/busses/i2c-at91.c      |    2 +-
 drivers/i2c/busses/i2c-au1550.c    |    1 +
 drivers/i2c/busses/i2c-bfin-twi.c  |    1 +
 drivers/i2c/busses/i2c-davinci.c   |    3 +++
 drivers/i2c/busses/i2c-gpio.c      |    1 +
 drivers/i2c/busses/i2c-iop3xx.c    |    1 +
 drivers/i2c/busses/i2c-ixp2000.c   |    1 +
 drivers/i2c/busses/i2c-mpc.c       |    3 +++
 drivers/i2c/busses/i2c-ocores.c    |    3 +++
 drivers/i2c/busses/i2c-omap.c      |    1 +
 drivers/i2c/busses/i2c-pmcmsp.c    |    3 +++
 drivers/i2c/busses/i2c-pnx.c       |    1 +
 drivers/i2c/busses/i2c-powermac.c  |    3 +++
 drivers/i2c/busses/i2c-pxa.c       |    1 +
 drivers/i2c/busses/i2c-s3c2410.c   |    1 +
 drivers/i2c/busses/i2c-simtec.c    |    3 +++
 drivers/i2c/busses/i2c-versatile.c |    1 +
 17 files changed, 29 insertions(+), 1 deletion(-)

diff -puN drivers/i2c/busses/i2c-at91.c~i2c-fix-platform-driver-hotplug-coldplug drivers/i2c/busses/i2c-at91.c
--- a/drivers/i2c/busses/i2c-at91.c~i2c-fix-platform-driver-hotplug-coldplug
+++ a/drivers/i2c/busses/i2c-at91.c
@@ -298,7 +298,7 @@ static int at91_i2c_resume(struct platfo
 #endif
 
 /* work with "modprobe at91_i2c" from hotplugging or coldplugging */
-MODULE_ALIAS("at91_i2c");
+MODULE_ALIAS("platform:at91_i2c");
 
 static struct platform_driver at91_i2c_driver = {
 	.probe		= at91_i2c_probe,
diff -puN drivers/i2c/busses/i2c-au1550.c~i2c-fix-platform-driver-hotplug-coldplug drivers/i2c/busses/i2c-au1550.c
--- a/drivers/i2c/busses/i2c-au1550.c~i2c-fix-platform-driver-hotplug-coldplug
+++ a/drivers/i2c/busses/i2c-au1550.c
@@ -472,6 +472,7 @@ i2c_au1550_exit(void)
 MODULE_AUTHOR("Dan Malek, Embedded Edge, LLC.");
 MODULE_DESCRIPTION("SMBus adapter Alchemy pb1550");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:au1xpsc_smbus");
 
 module_init (i2c_au1550_init);
 module_exit (i2c_au1550_exit);
diff -puN drivers/i2c/busses/i2c-bfin-twi.c~i2c-fix-platform-driver-hotplug-coldplug drivers/i2c/busses/i2c-bfin-twi.c
--- a/drivers/i2c/busses/i2c-bfin-twi.c~i2c-fix-platform-driver-hotplug-coldplug
+++ a/drivers/i2c/busses/i2c-bfin-twi.c
@@ -624,6 +624,7 @@ static void __exit i2c_bfin_twi_exit(voi
 MODULE_AUTHOR("Sonic Zhang <sonic.zhang@analog.com>");
 MODULE_DESCRIPTION("I2C-Bus adapter routines for Blackfin TWI");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:i2c-bfin-twi");
 
 module_init(i2c_bfin_twi_init);
 module_exit(i2c_bfin_twi_exit);
diff -puN drivers/i2c/busses/i2c-davinci.c~i2c-fix-platform-driver-hotplug-coldplug drivers/i2c/busses/i2c-davinci.c
--- a/drivers/i2c/busses/i2c-davinci.c~i2c-fix-platform-driver-hotplug-coldplug
+++ a/drivers/i2c/busses/i2c-davinci.c
@@ -558,6 +558,9 @@ static int davinci_i2c_remove(struct pla
 	return 0;
 }
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:i2c_davinci");
+
 static struct platform_driver davinci_i2c_driver = {
 	.probe		= davinci_i2c_probe,
 	.remove		= davinci_i2c_remove,
diff -puN drivers/i2c/busses/i2c-gpio.c~i2c-fix-platform-driver-hotplug-coldplug drivers/i2c/busses/i2c-gpio.c
--- a/drivers/i2c/busses/i2c-gpio.c~i2c-fix-platform-driver-hotplug-coldplug
+++ a/drivers/i2c/busses/i2c-gpio.c
@@ -220,3 +220,4 @@ module_exit(i2c_gpio_exit);
 MODULE_AUTHOR("Haavard Skinnemoen <hskinnemoen@atmel.com>");
 MODULE_DESCRIPTION("Platform-independent bitbanging I2C driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:i2c-gpio");
diff -puN drivers/i2c/busses/i2c-iop3xx.c~i2c-fix-platform-driver-hotplug-coldplug drivers/i2c/busses/i2c-iop3xx.c
--- a/drivers/i2c/busses/i2c-iop3xx.c~i2c-fix-platform-driver-hotplug-coldplug
+++ a/drivers/i2c/busses/i2c-iop3xx.c
@@ -550,3 +550,4 @@ module_exit (i2c_iop3xx_exit);
 MODULE_AUTHOR("D-TACQ Solutions Ltd <www.d-tacq.com>");
 MODULE_DESCRIPTION("IOP3xx iic algorithm and driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:IOP3xx-I2C");
diff -puN drivers/i2c/busses/i2c-ixp2000.c~i2c-fix-platform-driver-hotplug-coldplug drivers/i2c/busses/i2c-ixp2000.c
--- a/drivers/i2c/busses/i2c-ixp2000.c~i2c-fix-platform-driver-hotplug-coldplug
+++ a/drivers/i2c/busses/i2c-ixp2000.c
@@ -164,4 +164,5 @@ module_exit(ixp2000_i2c_exit);
 MODULE_AUTHOR ("Deepak Saxena <dsaxena@plexity.net>");
 MODULE_DESCRIPTION("IXP2000 GPIO-based I2C bus driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:IXP2000-I2C");
 
diff -puN drivers/i2c/busses/i2c-mpc.c~i2c-fix-platform-driver-hotplug-coldplug drivers/i2c/busses/i2c-mpc.c
--- a/drivers/i2c/busses/i2c-mpc.c~i2c-fix-platform-driver-hotplug-coldplug
+++ a/drivers/i2c/busses/i2c-mpc.c
@@ -392,6 +392,9 @@ static int fsl_i2c_remove(struct platfor
 	return 0;
 };
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:fsl-i2c");
+
 /* Structure for a device driver */
 static struct platform_driver fsl_i2c_driver = {
 	.probe = fsl_i2c_probe,
diff -puN drivers/i2c/busses/i2c-ocores.c~i2c-fix-platform-driver-hotplug-coldplug drivers/i2c/busses/i2c-ocores.c
--- a/drivers/i2c/busses/i2c-ocores.c~i2c-fix-platform-driver-hotplug-coldplug
+++ a/drivers/i2c/busses/i2c-ocores.c
@@ -312,6 +312,9 @@ static int __devexit ocores_i2c_remove(s
 	return 0;
 }
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:ocores-i2c");
+
 static struct platform_driver ocores_i2c_driver = {
 	.probe  = ocores_i2c_probe,
 	.remove = __devexit_p(ocores_i2c_remove),
diff -puN drivers/i2c/busses/i2c-omap.c~i2c-fix-platform-driver-hotplug-coldplug drivers/i2c/busses/i2c-omap.c
--- a/drivers/i2c/busses/i2c-omap.c~i2c-fix-platform-driver-hotplug-coldplug
+++ a/drivers/i2c/busses/i2c-omap.c
@@ -693,3 +693,4 @@ module_exit(omap_i2c_exit_driver);
 MODULE_AUTHOR("MontaVista Software, Inc. (and others)");
 MODULE_DESCRIPTION("TI OMAP I2C bus adapter");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:i2c_omap");
diff -puN drivers/i2c/busses/i2c-pmcmsp.c~i2c-fix-platform-driver-hotplug-coldplug drivers/i2c/busses/i2c-pmcmsp.c
--- a/drivers/i2c/busses/i2c-pmcmsp.c~i2c-fix-platform-driver-hotplug-coldplug
+++ a/drivers/i2c/busses/i2c-pmcmsp.c
@@ -627,6 +627,9 @@ static struct i2c_adapter pmcmsptwi_adap
 	.name		= DRV_NAME,
 };
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:" DRV_NAME);
+
 static struct platform_driver pmcmsptwi_driver = {
 	.probe  = pmcmsptwi_probe,
 	.remove	= __devexit_p(pmcmsptwi_remove),
diff -puN drivers/i2c/busses/i2c-pnx.c~i2c-fix-platform-driver-hotplug-coldplug drivers/i2c/busses/i2c-pnx.c
--- a/drivers/i2c/busses/i2c-pnx.c~i2c-fix-platform-driver-hotplug-coldplug
+++ a/drivers/i2c/busses/i2c-pnx.c
@@ -697,6 +697,7 @@ static void __exit i2c_adap_pnx_exit(voi
 MODULE_AUTHOR("Vitaly Wool, Dennis Kovalev <source@mvista.com>");
 MODULE_DESCRIPTION("I2C driver for Philips IP3204-based I2C busses");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:pnx-i2c");
 
 /* We need to make sure I2C is initialized before USB */
 subsys_initcall(i2c_adap_pnx_init);
diff -puN drivers/i2c/busses/i2c-powermac.c~i2c-fix-platform-driver-hotplug-coldplug drivers/i2c/busses/i2c-powermac.c
--- a/drivers/i2c/busses/i2c-powermac.c~i2c-fix-platform-driver-hotplug-coldplug
+++ a/drivers/i2c/busses/i2c-powermac.c
@@ -263,6 +263,9 @@ static int __devexit i2c_powermac_probe(
 }
 
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:i2c-powermac");
+
 static struct platform_driver i2c_powermac_driver = {
 	.probe = i2c_powermac_probe,
 	.remove = __devexit_p(i2c_powermac_remove),
diff -puN drivers/i2c/busses/i2c-pxa.c~i2c-fix-platform-driver-hotplug-coldplug drivers/i2c/busses/i2c-pxa.c
--- a/drivers/i2c/busses/i2c-pxa.c~i2c-fix-platform-driver-hotplug-coldplug
+++ a/drivers/i2c/busses/i2c-pxa.c
@@ -1131,6 +1131,7 @@ static void __exit i2c_adap_pxa_exit(voi
 }
 
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:pxa2xx-i2c");
 
 module_init(i2c_adap_pxa_init);
 module_exit(i2c_adap_pxa_exit);
diff -puN drivers/i2c/busses/i2c-s3c2410.c~i2c-fix-platform-driver-hotplug-coldplug drivers/i2c/busses/i2c-s3c2410.c
--- a/drivers/i2c/busses/i2c-s3c2410.c~i2c-fix-platform-driver-hotplug-coldplug
+++ a/drivers/i2c/busses/i2c-s3c2410.c
@@ -948,3 +948,4 @@ module_exit(i2c_adap_s3c_exit);
 MODULE_DESCRIPTION("S3C24XX I2C Bus driver");
 MODULE_AUTHOR("Ben Dooks, <ben@simtec.co.uk>");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:s3c2410-i2c");
diff -puN drivers/i2c/busses/i2c-simtec.c~i2c-fix-platform-driver-hotplug-coldplug drivers/i2c/busses/i2c-simtec.c
--- a/drivers/i2c/busses/i2c-simtec.c~i2c-fix-platform-driver-hotplug-coldplug
+++ a/drivers/i2c/busses/i2c-simtec.c
@@ -159,6 +159,9 @@ static int simtec_i2c_remove(struct plat
 
 /* device driver */
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:simtec-i2c");
+
 static struct platform_driver simtec_i2c_driver = {
 	.driver		= {
 		.name		= "simtec-i2c",
diff -puN drivers/i2c/busses/i2c-versatile.c~i2c-fix-platform-driver-hotplug-coldplug drivers/i2c/busses/i2c-versatile.c
--- a/drivers/i2c/busses/i2c-versatile.c~i2c-fix-platform-driver-hotplug-coldplug
+++ a/drivers/i2c/busses/i2c-versatile.c
@@ -151,3 +151,4 @@ module_exit(i2c_versatile_exit);
 
 MODULE_DESCRIPTION("ARM Versatile I2C bus driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:versatile-i2c");
_

Patches currently in -mm which might be from kay.sievers@vrfy.org are

i2c-fix-platform-driver-hotplug-coldplug.patch
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

