From: akpm@linux-foundation.org
Subject: + meth-driver-renovation.patch added to -mm tree
Date: Wed, 23 May 2007 11:10:05 -0700
Message-ID: <200705231810.l4NIA4v8028850@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:40848 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754956AbXEWSKX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 May 2007 14:10:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org, jeff@garzik.org


The patch titled
     meth driver renovation
has been added to the -mm tree.  Its filename is
     meth-driver-renovation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: meth driver renovation
From: Ralf Baechle <ralf@linux-mips.org>

The meth ethernet driver for the SGI IP32 aka O2 is so far still an old
style driver which does not use the device driver model.  This is now
causing issues with some udev based gadgetry in debian-stable.  Fixed by
converting the meth driver to a platform device.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/sgi-ip32/Makefile        |    2 
 arch/mips/sgi-ip32/ip32-platform.c |   20 +++++++
 drivers/net/meth.c                 |   68 +++++++++++++++++----------
 3 files changed, 66 insertions(+), 24 deletions(-)

diff -puN /dev/null arch/mips/sgi-ip32/ip32-platform.c
--- /dev/null
+++ a/arch/mips/sgi-ip32/ip32-platform.c
@@ -0,0 +1,20 @@
+#include <linux/init.h>
+#include <linux/platform_device.h>
+
+static __init int meth_devinit(void)
+{
+	struct platform_device *pd;
+	int ret;
+
+	pd = platform_device_alloc("meth", -1);
+	if (!pd)
+		return -ENOMEM;
+
+	ret = platform_device_add(pd);
+	if (ret)
+		platform_device_put(pd);
+
+	return ret;
+}
+
+device_initcall(meth_devinit);
diff -puN arch/mips/sgi-ip32/Makefile~meth-driver-renovation arch/mips/sgi-ip32/Makefile
--- a/arch/mips/sgi-ip32/Makefile~meth-driver-renovation
+++ a/arch/mips/sgi-ip32/Makefile
@@ -3,5 +3,5 @@
 # under Linux.
 #
 
-obj-y	+= ip32-berr.o ip32-irq.o ip32-setup.o ip32-reset.o \
+obj-y	+= ip32-berr.o ip32-irq.o ip32-platform.o ip32-setup.o ip32-reset.o \
 	   crime.o ip32-memory.o
diff -puN drivers/net/meth.c~meth-driver-renovation drivers/net/meth.c
--- a/drivers/net/meth.c~meth-driver-renovation
+++ a/drivers/net/meth.c
@@ -8,15 +8,16 @@
  *	as published by the Free Software Foundation; either version
  *	2 of the License, or (at your option) any later version.
  */
-#include <linux/module.h>
-#include <linux/init.h>
-
-#include <linux/kernel.h> /* printk() */
 #include <linux/delay.h>
+#include <linux/dma-mapping.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
 #include <linux/slab.h>
-#include <linux/errno.h>  /* error codes */
-#include <linux/types.h>  /* size_t */
-#include <linux/interrupt.h> /* mark_bh */
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/interrupt.h>
 
 #include <linux/in.h>
 #include <linux/in6.h>
@@ -33,7 +34,6 @@
 
 #include <asm/io.h>
 #include <asm/scatterlist.h>
-#include <linux/dma-mapping.h>
 
 #include "meth.h"
 
@@ -51,8 +51,6 @@
 
 
 static const char *meth_str="SGI O2 Fast Ethernet";
-MODULE_AUTHOR("Ilya Volynets <ilya@theIlya.com>");
-MODULE_DESCRIPTION("SGI O2 Builtin Fast Ethernet driver");
 
 #define HAVE_TX_TIMEOUT
 /* The maximum time waited (in jiffies) before assuming a Tx failed. (400ms) */
@@ -784,15 +782,15 @@ static struct net_device_stats *meth_sta
 /*
  * The init function.
  */
-static struct net_device *meth_init(void)
+static int __init meth_probe(struct platform_device *pdev)
 {
 	struct net_device *dev;
 	struct meth_private *priv;
-	int ret;
+	int err;
 
 	dev = alloc_etherdev(sizeof(struct meth_private));
 	if (!dev)
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
 
 	dev->open            = meth_open;
 	dev->stop            = meth_release;
@@ -808,11 +806,12 @@ static struct net_device *meth_init(void
 
 	priv = netdev_priv(dev);
 	spin_lock_init(&priv->meth_lock);
+	SET_NETDEV_DEV(dev, &pdev->dev);
 
-	ret = register_netdev(dev);
-	if (ret) {
+	err = register_netdev(dev);
+	if (err) {
 		free_netdev(dev);
-		return ERR_PTR(ret);
+		return err;
 	}
 
 	printk(KERN_INFO "%s: SGI MACE Ethernet rev. %d\n",
@@ -820,21 +819,44 @@ static struct net_device *meth_init(void
 	return 0;
 }
 
-static struct net_device *meth_dev;
+static int __exit meth_remove(struct platform_device *pdev)
+{
+	struct net_device *dev = platform_get_drvdata(pdev);
+
+	unregister_netdev(dev);
+	free_netdev(dev);
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+static struct platform_driver meth_driver = {
+	.probe	= meth_probe,
+	.remove	= __devexit_p(meth_remove),
+	.driver = {
+		.name	= "meth",
+	}
+};
 
 static int __init meth_init_module(void)
 {
-	meth_dev = meth_init();
-	if (IS_ERR(meth_dev))
-		return PTR_ERR(meth_dev);
-	return 0;
+	int err;
+
+	err = platform_driver_register(&meth_driver);
+	if (err)
+		printk(KERN_ERR "Driver registration failed\n");
+
+	return err;
 }
 
 static void __exit meth_exit_module(void)
 {
-	unregister_netdev(meth_dev);
-	free_netdev(meth_dev);
+	platform_driver_register(&meth_driver);
 }
 
 module_init(meth_init_module);
 module_exit(meth_exit_module);
+
+MODULE_AUTHOR("Ilya Volynets <ilya@theIlya.com>");
+MODULE_DESCRIPTION("SGI O2 Builtin Fast Ethernet driver");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from ralf@linux-mips.org are

git-mips.patch
serial-use-resource_size_t-for-port-io-addresses.patch
meth-driver-renovation.patch
update-zilog-timeout.patch
