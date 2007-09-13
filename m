From: akpm@linux-foundation.org
Subject: + remove-setup-of-platform-device-from-jazzsonicc.patch added to -mm tree
Date: Thu, 13 Sep 2007 00:27:34 -0700
Message-ID: <200709130727.l8D7RYx2007705@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55065 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751619AbXIMH2K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Sep 2007 03:28:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tsbogend@alpha.franken.de, greg@kroah.com, jeff@garzik.org, ralf@linux-mips.org


The patch titled
     remove setup of platform device from jazzsonic.c
has been added to the -mm tree.  Its filename is
     remove-setup-of-platform-device-from-jazzsonicc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: remove setup of platform device from jazzsonic.c
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

Remove setup platform device from jazzsonic, which is done in arch code now

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Greg KH <greg@kroah.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/jazzsonic.c |   61 ++++----------------------------------
 1 file changed, 7 insertions(+), 54 deletions(-)

diff -puN drivers/net/jazzsonic.c~remove-setup-of-platform-device-from-jazzsonicc drivers/net/jazzsonic.c
--- a/drivers/net/jazzsonic.c~remove-setup-of-platform-device-from-jazzsonicc
+++ a/drivers/net/jazzsonic.c
@@ -45,7 +45,6 @@
 #include <asm/jazzdma.h>
 
 static char jazz_sonic_string[] = "jazzsonic";
-static struct platform_device *jazz_sonic_device;
 
 #define SONIC_MEM_SIZE	0x100
 
@@ -70,14 +69,6 @@ static unsigned int sonic_debug = 1;
 #endif
 
 /*
- * Base address and interrupt of the SONIC controller on JAZZ boards
- */
-static struct {
-	unsigned int port;
-	unsigned int irq;
-} sonic_portlist[] = { {JAZZ_ETHERNET_BASE, JAZZ_ETHERNET_IRQ}, {0, 0}};
-
-/*
  * We cannot use station (ethernet) address prefixes to detect the
  * sonic controller since these are board manufacturer depended.
  * So we check for known Silicon Revision IDs instead.
@@ -215,13 +206,12 @@ static int __init jazz_sonic_probe(struc
 {
 	struct net_device *dev;
 	struct sonic_local *lp;
+	struct resource *res;
 	int err = 0;
 	int i;
 
-	/*
-	 * Don't probe if we're not running on a Jazz board.
-	 */
-	if (mips_machgroup != MACH_GROUP_JAZZ)
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
 		return -ENODEV;
 
 	dev = alloc_etherdev(sizeof(struct sonic_local));
@@ -235,20 +225,9 @@ static int __init jazz_sonic_probe(struc
 
 	netdev_boot_setup_check(dev);
 
-	if (dev->base_addr >= KSEG0) { /* Check a single specified location. */
-		err = sonic_probe1(dev);
-	} else if (dev->base_addr != 0) { /* Don't probe at all. */
-		err = -ENXIO;
-	} else {
-		for (i = 0; sonic_portlist[i].port; i++) {
-			dev->base_addr = sonic_portlist[i].port;
-			dev->irq = sonic_portlist[i].irq;
-			if (sonic_probe1(dev) == 0)
-				break;
-		}
-		if (!sonic_portlist[i].port)
-			err = -ENODEV;
-	}
+	dev->base_addr = res->start;
+	dev->irq = platform_get_irq(pdev, 0);
+	err = sonic_probe1(dev);
 	if (err)
 		goto out;
 	err = register_netdev(dev);
@@ -303,38 +282,12 @@ static struct platform_driver jazz_sonic
 
 static int __init jazz_sonic_init_module(void)
 {
-	int err;
-
-	if ((err = platform_driver_register(&jazz_sonic_driver))) {
-		printk(KERN_ERR "Driver registration failed\n");
-		return err;
-	}
-
-	jazz_sonic_device = platform_device_alloc(jazz_sonic_string, 0);
-	if (!jazz_sonic_device)
-		goto out_unregister;
-
-	if (platform_device_add(jazz_sonic_device)) {
-		platform_device_put(jazz_sonic_device);
-		jazz_sonic_device = NULL;
-	}
-
-	return 0;
-
-out_unregister:
-	platform_driver_unregister(&jazz_sonic_driver);
-
-	return -ENOMEM;
+	return platform_driver_register(&jazz_sonic_driver);
 }
 
 static void __exit jazz_sonic_cleanup_module(void)
 {
 	platform_driver_unregister(&jazz_sonic_driver);
-
-	if (jazz_sonic_device) {
-		platform_device_unregister(jazz_sonic_device);
-		jazz_sonic_device = NULL;
-	}
 }
 
 module_init(jazz_sonic_init_module);
_

Patches currently in -mm which might be from tsbogend@alpha.franken.de are

git-mips.patch
remove-setup-of-platform-device-from-jazzsonicc.patch
