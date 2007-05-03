From: akpm@linux-foundation.org
Subject: + ne-add-platform_driver.patch added to -mm tree
Date: Wed, 02 May 2007 20:39:50 -0700
Message-ID: <200705030339.l433donQ004094@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49718 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767351AbXECDkG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 May 2007 23:40:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, ralf@linux-mips.org


The patch titled
     ne: add platform_driver
has been added to the -mm tree.  Its filename is
     ne-add-platform_driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ne: add platform_driver
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Add a platform_driver interface to ne driver.  (Existing legacy ports did not
covered by this ne_driver for now)

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ne.c |   91 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 89 insertions(+), 2 deletions(-)

diff -puN drivers/net/ne.c~ne-add-platform_driver drivers/net/ne.c
--- a/drivers/net/ne.c~ne-add-platform_driver
+++ a/drivers/net/ne.c
@@ -51,6 +51,7 @@ static const char version2[] =
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/jiffies.h>
+#include <linux/platform_device.h>
 
 #include <asm/system.h>
 #include <asm/io.h>
@@ -807,6 +808,87 @@ retry:
 	return;
 }
 
+static int __init ne_drv_probe(struct platform_device *pdev)
+{
+	struct net_device *dev;
+	struct resource *res;
+	int err, irq;
+
+	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
+	irq = platform_get_irq(pdev, 0);
+	if (!res || irq < 0)
+		return -ENODEV;
+
+	dev = alloc_ei_netdev();
+	if (!dev)
+		return -ENOMEM;
+	dev->irq = irq;
+	dev->base_addr = res->start;
+	err = do_ne_probe(dev);
+	if (err) {
+		free_netdev(dev);
+		return err;
+	}
+	platform_set_drvdata(pdev, dev);
+	return 0;
+}
+
+static int __exit ne_drv_remove(struct platform_device *pdev)
+{
+	struct net_device *dev = platform_get_drvdata(pdev);
+
+	unregister_netdev(dev);
+	free_irq(dev->irq, dev);
+	release_region(dev->base_addr, NE_IO_EXTENT);
+	free_netdev(dev);
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int ne_drv_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct net_device *dev = platform_get_drvdata(pdev);
+
+	if (netif_running(dev))
+		netif_device_detach(dev);
+	return 0;
+}
+
+static int ne_drv_resume(struct platform_device *pdev)
+{
+	struct net_device *dev = platform_get_drvdata(pdev);
+
+	if (netif_running(dev)) {
+		ne_reset_8390(dev);
+		NS8390_init(dev, 1);
+		netif_device_attach(dev);
+	}
+	return 0;
+}
+#else
+#define ne_drv_suspend NULL
+#define ne_drv_resume NULL
+#endif
+
+static struct platform_driver ne_driver = {
+	.remove		= __exit_p(ne_drv_remove),
+	.suspend	= ne_drv_suspend,
+	.resume		= ne_drv_resume,
+	.driver		= {
+		.name	= DRV_NAME,
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init ne_init(void)
+{
+	return platform_driver_probe(&ne_driver, ne_drv_probe);
+}
+
+static void __exit ne_exit(void)
+{
+	platform_driver_unregister(&ne_driver);
+}
 
 #ifdef MODULE
 #define MAX_NE_CARDS	4	/* Max number of NE cards per module */
@@ -832,6 +914,7 @@ ISA device autoprobes on a running machi
 int __init init_module(void)
 {
 	int this_dev, found = 0;
+	int plat_found = !ne_init();
 
 	for (this_dev = 0; this_dev < MAX_NE_CARDS; this_dev++) {
 		struct net_device *dev = alloc_ei_netdev();
@@ -845,7 +928,7 @@ int __init init_module(void)
 			continue;
 		}
 		free_netdev(dev);
-		if (found)
+		if (found || plat_found)
 			break;
 		if (io[this_dev] != 0)
 			printk(KERN_WARNING "ne.c: No NE*000 card found at i/o = %#x\n", io[this_dev]);
@@ -853,7 +936,7 @@ int __init init_module(void)
 			printk(KERN_NOTICE "ne.c: You must supply \"io=0xNNN\" value(s) for ISA cards.\n");
 		return -ENXIO;
 	}
-	if (found)
+	if (found || plat_found)
 		return 0;
 	return -ENODEV;
 }
@@ -871,6 +954,7 @@ void __exit cleanup_module(void)
 {
 	int this_dev;
 
+	ne_exit();
 	for (this_dev = 0; this_dev < MAX_NE_CARDS; this_dev++) {
 		struct net_device *dev = dev_ne[this_dev];
 		if (dev) {
@@ -880,4 +964,7 @@ void __exit cleanup_module(void)
 		}
 	}
 }
+#else /* MODULE */
+module_init(ne_init);
+module_exit(ne_exit);
 #endif /* MODULE */
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
git-kbuild.patch
git-mips.patch
mips-drop-unnecessary-config_isa-from-rbtx49xx.patch
ne-add-platform_driver.patch
ne-misc-fixes-for-platform-driver.patch
ne-add-needs_portlist-to-control-isa-auto-probe.patch
ne-mips-use-platform_driver-for-ne-on-rbtx49xx.patch
serial_txx9-use-assigned-device-numbers.patch
serial_txx9-zap-changelog-from-source-code.patch
