From: akpm@linux-foundation.org
Subject: + usb-gadget-fix-platform-driver-hotplug-coldplug.patch added to -mm tree
Date: Wed, 09 Apr 2008 14:56:59 -0700
Message-ID: <200804092156.m39LuxwQ031799@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41000 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752333AbYDIV5k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Apr 2008 17:57:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kay.sievers@vrfy.org, dbrownell@users.sourceforge.net, greg@kroah.com


The patch titled
     usb gadget: fix platform driver hotplug/coldplug
has been added to the -mm tree.  Its filename is
     usb-gadget-fix-platform-driver-hotplug-coldplug.patch

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
Subject: usb gadget: fix platform driver hotplug/coldplug
From: Kay Sievers <kay.sievers@vrfy.org>

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf, the platform modalias is
prefixed with "platform:".  Add MODULE_ALIAS() to the hotpluggable usb
peripheral drivers, to re-eable module auto loading.

[dbrownell@users.sourceforge.net: registration fixes]
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/at91_udc.c       |    1 +
 drivers/usb/gadget/atmel_usba_udc.c |    2 ++
 drivers/usb/gadget/fsl_usb2_udc.c   |    1 +
 drivers/usb/gadget/lh7a40x_udc.c    |    1 +
 drivers/usb/gadget/m66592-udc.c     |    2 ++
 drivers/usb/gadget/omap_udc.c       |    2 +-
 drivers/usb/gadget/pxa2xx_udc.c     |    2 +-
 drivers/usb/gadget/s3c2410_udc.c    |    2 ++
 8 files changed, 11 insertions(+), 2 deletions(-)

diff -puN drivers/usb/gadget/at91_udc.c~usb-gadget-fix-platform-driver-hotplug-coldplug drivers/usb/gadget/at91_udc.c
--- a/drivers/usb/gadget/at91_udc.c~usb-gadget-fix-platform-driver-hotplug-coldplug
+++ a/drivers/usb/gadget/at91_udc.c
@@ -1884,3 +1884,4 @@ module_exit(udc_exit_module);
 MODULE_DESCRIPTION("AT91 udc driver");
 MODULE_AUTHOR("Thomas Rathbone, David Brownell");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:at91_udc");
diff -puN drivers/usb/gadget/atmel_usba_udc.c~usb-gadget-fix-platform-driver-hotplug-coldplug drivers/usb/gadget/atmel_usba_udc.c
--- a/drivers/usb/gadget/atmel_usba_udc.c~usb-gadget-fix-platform-driver-hotplug-coldplug
+++ a/drivers/usb/gadget/atmel_usba_udc.c
@@ -2054,6 +2054,7 @@ static struct platform_driver udc_driver
 	.remove		= __exit_p(usba_udc_remove),
 	.driver		= {
 		.name		= "atmel_usba_udc",
+		.owner		= THIS_MODULE,
 	},
 };
 
@@ -2072,3 +2073,4 @@ module_exit(udc_exit);
 MODULE_DESCRIPTION("Atmel USBA UDC driver");
 MODULE_AUTHOR("Haavard Skinnemoen <hskinnemoen@atmel.com>");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:atmel_usba_udc");
diff -puN drivers/usb/gadget/fsl_usb2_udc.c~usb-gadget-fix-platform-driver-hotplug-coldplug drivers/usb/gadget/fsl_usb2_udc.c
--- a/drivers/usb/gadget/fsl_usb2_udc.c~usb-gadget-fix-platform-driver-hotplug-coldplug
+++ a/drivers/usb/gadget/fsl_usb2_udc.c
@@ -2475,3 +2475,4 @@ module_exit(udc_exit);
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:fsl-usb2-udc");
diff -puN drivers/usb/gadget/lh7a40x_udc.c~usb-gadget-fix-platform-driver-hotplug-coldplug drivers/usb/gadget/lh7a40x_udc.c
--- a/drivers/usb/gadget/lh7a40x_udc.c~usb-gadget-fix-platform-driver-hotplug-coldplug
+++ a/drivers/usb/gadget/lh7a40x_udc.c
@@ -2146,3 +2146,4 @@ module_exit(udc_exit);
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_AUTHOR("Mikko Lahteenmaki, Bo Henriksen");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:lh7a40x_udc");
diff -puN drivers/usb/gadget/m66592-udc.c~usb-gadget-fix-platform-driver-hotplug-coldplug drivers/usb/gadget/m66592-udc.c
--- a/drivers/usb/gadget/m66592-udc.c~usb-gadget-fix-platform-driver-hotplug-coldplug
+++ a/drivers/usb/gadget/m66592-udc.c
@@ -35,6 +35,7 @@
 MODULE_DESCRIPTION("M66592 USB gadget driver");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Yoshihiro Shimoda");
+MODULE_ALIAS("platform:m66592_udc");
 
 #define DRIVER_VERSION	"18 Oct 2007"
 
@@ -1671,6 +1672,7 @@ static struct platform_driver m66592_dri
 	.remove =	__exit_p(m66592_remove),
 	.driver		= {
 		.name =	(char *) udc_name,
+		.owner	= THIS_MODULE,
 	},
 };
 
diff -puN drivers/usb/gadget/omap_udc.c~usb-gadget-fix-platform-driver-hotplug-coldplug drivers/usb/gadget/omap_udc.c
--- a/drivers/usb/gadget/omap_udc.c~usb-gadget-fix-platform-driver-hotplug-coldplug
+++ a/drivers/usb/gadget/omap_udc.c
@@ -3109,4 +3109,4 @@ module_exit(udc_exit);
 
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
-
+MODULE_ALIAS("platform:omap_udc");
diff -puN drivers/usb/gadget/pxa2xx_udc.c~usb-gadget-fix-platform-driver-hotplug-coldplug drivers/usb/gadget/pxa2xx_udc.c
--- a/drivers/usb/gadget/pxa2xx_udc.c~usb-gadget-fix-platform-driver-hotplug-coldplug
+++ a/drivers/usb/gadget/pxa2xx_udc.c
@@ -2380,4 +2380,4 @@ module_exit(udc_exit);
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_AUTHOR("Frank Becker, Robert Schwebel, David Brownell");
 MODULE_LICENSE("GPL");
-
+MODULE_ALIAS("platform:pxa2xx-udc");
diff -puN drivers/usb/gadget/s3c2410_udc.c~usb-gadget-fix-platform-driver-hotplug-coldplug drivers/usb/gadget/s3c2410_udc.c
--- a/drivers/usb/gadget/s3c2410_udc.c~usb-gadget-fix-platform-driver-hotplug-coldplug
+++ a/drivers/usb/gadget/s3c2410_udc.c
@@ -2047,3 +2047,5 @@ MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_VERSION(DRIVER_VERSION);
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:s3c2410-usbgadget");
+MODULE_ALIAS("platform:s3c2440-usbgadget");
_

Patches currently in -mm which might be from kay.sievers@vrfy.org are

i2c-fix-platform-driver-hotplug-coldplug.patch
spi-fix-platform-driver-hotplug-coldplug.patch
usb-gadget-fix-platform-driver-hotplug-coldplug.patch
pm-remove-destroy_suspended_device.patch
sysfs-refill-attribute-buffer-when-reading-from-offset-0.patch
pm-introduce-new-top-level-suspend-and-hibernation-callbacks-rev-7.patch
pm-introduce-new-top-level-suspend-and-hibernation-callbacks-rev-7-fix.patch
pm-new-suspend-and-hibernation-callbacks-for-platform-bus-type-rev-3.patch
pm-new-suspend-and-hibernation-callbacks-for-pci-bus-type-rev-3.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
infrastructure-to-debug-dynamic-objects.patch
debugobjects-add-documentation.patch
debugobjects-add-timer-specific-object-debugging-code.patch
add-hrtimer-specific-debugobjects-code.patch
cpu-change-cpu_sys_devices-from-array-to-per_cpu-variable.patch

