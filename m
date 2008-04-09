From: akpm@linux-foundation.org
Subject: + usb-host-fix-platform-driver-hotplug-coldplug.patch added to -mm tree
Date: Wed, 09 Apr 2008 15:22:12 -0700
Message-ID: <200804092222.m39MMCCf000313@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59665 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753931AbYDIWWX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Apr 2008 18:22:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kay.sievers@vrfy.org, dbrownell@users.sourceforge.net, greg@kroah.com


The patch titled
     usb host: fix platform driver hotplug/coldplug
has been added to the -mm tree.  Its filename is
     usb-host-fix-platform-driver-hotplug-coldplug.patch

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
Subject: usb host: fix platform driver hotplug/coldplug
From: Kay Sievers <kay.sievers@vrfy.org>

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf, the platform modalias is
prefixed with "platform:".  Add MODULE_ALIAS() to the hotpluggable USB HCDs,
to allow re-enable auto loading.

[dbrownell@users.sourceforge.net: more drivers; registration fixes]
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/isp116x-hcd.c  |    8 ++++++--
 drivers/usb/host/ohci-at91.c    |    3 +--
 drivers/usb/host/ohci-au1xxx.c  |    1 +
 drivers/usb/host/ohci-ep93xx.c  |    2 ++
 drivers/usb/host/ohci-lh7a404.c |    1 +
 drivers/usb/host/ohci-omap.c    |    1 +
 drivers/usb/host/ohci-pnx4008.c |    4 ++++
 drivers/usb/host/ohci-pnx8550.c |    5 +++--
 drivers/usb/host/ohci-ppc-soc.c |    1 +
 drivers/usb/host/ohci-pxa27x.c  |    3 +++
 drivers/usb/host/ohci-s3c2410.c |    1 +
 drivers/usb/host/ohci-sh.c      |    1 +
 drivers/usb/host/ohci-sm501.c   |    1 +
 drivers/usb/host/r8a66597-hcd.c |    2 ++
 drivers/usb/host/sl811-hcd.c    |    1 +
 drivers/usb/host/u132-hcd.c     |    1 +
 16 files changed, 30 insertions(+), 6 deletions(-)

diff -puN drivers/usb/host/isp116x-hcd.c~usb-host-fix-platform-driver-hotplug-coldplug drivers/usb/host/isp116x-hcd.c
--- a/drivers/usb/host/isp116x-hcd.c~usb-host-fix-platform-driver-hotplug-coldplug
+++ a/drivers/usb/host/isp116x-hcd.c
@@ -1684,14 +1684,18 @@ static int isp116x_resume(struct platfor
 
 #endif
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:isp116x-hcd");
+
 static struct platform_driver isp116x_driver = {
 	.probe = isp116x_probe,
 	.remove = isp116x_remove,
 	.suspend = isp116x_suspend,
 	.resume = isp116x_resume,
 	.driver = {
-		   .name = (char *)hcd_name,
-		   },
+		.name = (char *)hcd_name,
+		.owner	= THIS_MODULE,
+	},
 };
 
 /*-----------------------------------------------------------------*/
diff -puN drivers/usb/host/ohci-at91.c~usb-host-fix-platform-driver-hotplug-coldplug drivers/usb/host/ohci-at91.c
--- a/drivers/usb/host/ohci-at91.c~usb-host-fix-platform-driver-hotplug-coldplug
+++ a/drivers/usb/host/ohci-at91.c
@@ -355,7 +355,7 @@ static int ohci_hcd_at91_drv_resume(stru
 #define ohci_hcd_at91_drv_resume  NULL
 #endif
 
-MODULE_ALIAS("at91_ohci");
+MODULE_ALIAS("platform:at91_ohci");
 
 static struct platform_driver ohci_hcd_at91_driver = {
 	.probe		= ohci_hcd_at91_drv_probe,
@@ -368,4 +368,3 @@ static struct platform_driver ohci_hcd_a
 		.owner	= THIS_MODULE,
 	},
 };
-
diff -puN drivers/usb/host/ohci-au1xxx.c~usb-host-fix-platform-driver-hotplug-coldplug drivers/usb/host/ohci-au1xxx.c
--- a/drivers/usb/host/ohci-au1xxx.c~usb-host-fix-platform-driver-hotplug-coldplug
+++ a/drivers/usb/host/ohci-au1xxx.c
@@ -345,3 +345,4 @@ static struct platform_driver ohci_hcd_a
 	},
 };
 
+MODULE_ALIAS("platform:au1xxx-ohci");
diff -puN drivers/usb/host/ohci-ep93xx.c~usb-host-fix-platform-driver-hotplug-coldplug drivers/usb/host/ohci-ep93xx.c
--- a/drivers/usb/host/ohci-ep93xx.c~usb-host-fix-platform-driver-hotplug-coldplug
+++ a/drivers/usb/host/ohci-ep93xx.c
@@ -211,6 +211,8 @@ static struct platform_driver ohci_hcd_e
 #endif
 	.driver		= {
 		.name	= "ep93xx-ohci",
+		.owner	= THIS_MODULE,
 	},
 };
 
+MODULE_ALIAS("platform:ep93xx-ohci");
diff -puN drivers/usb/host/ohci-lh7a404.c~usb-host-fix-platform-driver-hotplug-coldplug drivers/usb/host/ohci-lh7a404.c
--- a/drivers/usb/host/ohci-lh7a404.c~usb-host-fix-platform-driver-hotplug-coldplug
+++ a/drivers/usb/host/ohci-lh7a404.c
@@ -251,3 +251,4 @@ static struct platform_driver ohci_hcd_l
 	},
 };
 
+MODULE_ALIAS("platform:lh7a404-ohci");
diff -puN drivers/usb/host/ohci-omap.c~usb-host-fix-platform-driver-hotplug-coldplug drivers/usb/host/ohci-omap.c
--- a/drivers/usb/host/ohci-omap.c~usb-host-fix-platform-driver-hotplug-coldplug
+++ a/drivers/usb/host/ohci-omap.c
@@ -544,3 +544,4 @@ static struct platform_driver ohci_hcd_o
 	},
 };
 
+MODULE_ALIAS("platform:ohci");
diff -puN drivers/usb/host/ohci-pnx4008.c~usb-host-fix-platform-driver-hotplug-coldplug drivers/usb/host/ohci-pnx4008.c
--- a/drivers/usb/host/ohci-pnx4008.c~usb-host-fix-platform-driver-hotplug-coldplug
+++ a/drivers/usb/host/ohci-pnx4008.c
@@ -456,9 +456,13 @@ static int usb_hcd_pnx4008_remove(struct
 	return 0;
 }
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:usb-ohci");
+
 static struct platform_driver usb_hcd_pnx4008_driver = {
 	.driver = {
 		.name = "usb-ohci",
+		.owner	= THIS_MODULE,
 	},
 	.probe = usb_hcd_pnx4008_probe,
 	.remove = usb_hcd_pnx4008_remove,
diff -puN drivers/usb/host/ohci-pnx8550.c~usb-host-fix-platform-driver-hotplug-coldplug drivers/usb/host/ohci-pnx8550.c
--- a/drivers/usb/host/ohci-pnx8550.c~usb-host-fix-platform-driver-hotplug-coldplug
+++ a/drivers/usb/host/ohci-pnx8550.c
@@ -230,11 +230,12 @@ static int ohci_hcd_pnx8550_drv_remove(s
 	return 0;
 }
 
-MODULE_ALIAS("pnx8550-ohci");
+MODULE_ALIAS("platform:pnx8550-ohci");
 
 static struct platform_driver ohci_hcd_pnx8550_driver = {
 	.driver = {
-		.name		= "pnx8550-ohci",
+		.name	= "pnx8550-ohci",
+		.owner	= THIS_MODULE,
 	},
 	.probe		= ohci_hcd_pnx8550_drv_probe,
 	.remove		= ohci_hcd_pnx8550_drv_remove,
diff -puN drivers/usb/host/ohci-ppc-soc.c~usb-host-fix-platform-driver-hotplug-coldplug drivers/usb/host/ohci-ppc-soc.c
--- a/drivers/usb/host/ohci-ppc-soc.c~usb-host-fix-platform-driver-hotplug-coldplug
+++ a/drivers/usb/host/ohci-ppc-soc.c
@@ -213,3 +213,4 @@ static struct platform_driver ohci_hcd_p
 	},
 };
 
+MODULE_ALIAS("platform:ppc-soc-ohci");
diff -puN drivers/usb/host/ohci-pxa27x.c~usb-host-fix-platform-driver-hotplug-coldplug drivers/usb/host/ohci-pxa27x.c
--- a/drivers/usb/host/ohci-pxa27x.c~usb-host-fix-platform-driver-hotplug-coldplug
+++ a/drivers/usb/host/ohci-pxa27x.c
@@ -364,6 +364,8 @@ static int ohci_hcd_pxa27x_drv_resume(st
 }
 #endif
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:pxa27x-ohci");
 
 static struct platform_driver ohci_hcd_pxa27x_driver = {
 	.probe		= ohci_hcd_pxa27x_drv_probe,
@@ -375,6 +377,7 @@ static struct platform_driver ohci_hcd_p
 #endif
 	.driver		= {
 		.name	= "pxa27x-ohci",
+		.owner	= THIS_MODULE,
 	},
 };
 
diff -puN drivers/usb/host/ohci-s3c2410.c~usb-host-fix-platform-driver-hotplug-coldplug drivers/usb/host/ohci-s3c2410.c
--- a/drivers/usb/host/ohci-s3c2410.c~usb-host-fix-platform-driver-hotplug-coldplug
+++ a/drivers/usb/host/ohci-s3c2410.c
@@ -501,3 +501,4 @@ static struct platform_driver ohci_hcd_s
 	},
 };
 
+MODULE_ALIAS("platform:s3c2410-ohci");
diff -puN drivers/usb/host/ohci-sh.c~usb-host-fix-platform-driver-hotplug-coldplug drivers/usb/host/ohci-sh.c
--- a/drivers/usb/host/ohci-sh.c~usb-host-fix-platform-driver-hotplug-coldplug
+++ a/drivers/usb/host/ohci-sh.c
@@ -141,3 +141,4 @@ static struct platform_driver ohci_hcd_s
 	},
 };
 
+MODULE_ALIAS("platform:sh_ohci");
diff -puN drivers/usb/host/ohci-sm501.c~usb-host-fix-platform-driver-hotplug-coldplug drivers/usb/host/ohci-sm501.c
--- a/drivers/usb/host/ohci-sm501.c~usb-host-fix-platform-driver-hotplug-coldplug
+++ a/drivers/usb/host/ohci-sm501.c
@@ -262,3 +262,4 @@ static struct platform_driver ohci_hcd_s
 		.name	= "sm501-usb",
 	},
 };
+MODULE_ALIAS("platform:sm501-usb");
diff -puN drivers/usb/host/r8a66597-hcd.c~usb-host-fix-platform-driver-hotplug-coldplug drivers/usb/host/r8a66597-hcd.c
--- a/drivers/usb/host/r8a66597-hcd.c~usb-host-fix-platform-driver-hotplug-coldplug
+++ a/drivers/usb/host/r8a66597-hcd.c
@@ -44,6 +44,7 @@
 MODULE_DESCRIPTION("R8A66597 USB Host Controller Driver");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Yoshihiro Shimoda");
+MODULE_ALIAS("platform:r8a66597_hcd");
 
 #define DRIVER_VERSION	"29 May 2007"
 
@@ -2219,6 +2220,7 @@ static struct platform_driver r8a66597_d
 	.resume =	r8a66597_resume,
 	.driver		= {
 		.name = (char *) hcd_name,
+		.owner	= THIS_MODULE,
 	},
 };
 
diff -puN drivers/usb/host/sl811-hcd.c~usb-host-fix-platform-driver-hotplug-coldplug drivers/usb/host/sl811-hcd.c
--- a/drivers/usb/host/sl811-hcd.c~usb-host-fix-platform-driver-hotplug-coldplug
+++ a/drivers/usb/host/sl811-hcd.c
@@ -58,6 +58,7 @@
 
 MODULE_DESCRIPTION("SL811HS USB Host Controller Driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:sl811-hcd");
 
 #define DRIVER_VERSION	"19 May 2005"
 
diff -puN drivers/usb/host/u132-hcd.c~usb-host-fix-platform-driver-hotplug-coldplug drivers/usb/host/u132-hcd.c
--- a/drivers/usb/host/u132-hcd.c~usb-host-fix-platform-driver-hotplug-coldplug
+++ a/drivers/usb/host/u132-hcd.c
@@ -3316,3 +3316,4 @@ static void __exit u132_hcd_exit(void)
 
 module_exit(u132_hcd_exit);
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:u132_hcd");
_

Patches currently in -mm which might be from kay.sievers@vrfy.org are

i2c-fix-platform-driver-hotplug-coldplug.patch
spi-fix-platform-driver-hotplug-coldplug.patch
usb-gadget-fix-platform-driver-hotplug-coldplug.patch
usb-host-fix-platform-driver-hotplug-coldplug.patch
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

