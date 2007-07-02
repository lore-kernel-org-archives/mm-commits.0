From: akpm@linux-foundation.org
Subject: - ethernet-driver-for-eisa-only-sni-rm200-rm400-machines-update-2.patch removed from -mm tree
Date: Mon, 02 Jul 2007 13:16:59 -0700
Message-ID: <200707022016.l62KGxvw004823@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35200 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753743AbXGBUYq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Jul 2007 16:24:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tsbogend@alpha.franken.de, mm-commits@vger.kernel.org


The patch titled
     ethernet-driver-for-eisa-only-sni-rm200-rm400-machines-update 2
has been removed from the -mm tree.  Its filename was
     ethernet-driver-for-eisa-only-sni-rm200-rm400-machines-update-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ethernet-driver-for-eisa-only-sni-rm200-rm400-machines-update 2
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

- spelling fix
- cleaned up probe code

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sni_82596.c |   71 +++++++++++++++-----------------------
 1 files changed, 29 insertions(+), 42 deletions(-)

diff -puN drivers/net/sni_82596.c~ethernet-driver-for-eisa-only-sni-rm200-rm400-machines-update-2 drivers/net/sni_82596.c
--- a/drivers/net/sni_82596.c~ethernet-driver-for-eisa-only-sni-rm200-rm400-machines-update-2
+++ a/drivers/net/sni_82596.c
@@ -80,53 +80,41 @@ static int __devinit sni_82596_probe(str
 	struct	net_device *netdevice;
 	struct i596_private *lp;
 	struct  resource *res, *ca, *idprom, *options;
-	int	retval = -ENODEV;
-	void __iomem *mpu_addr = NULL;
-	void __iomem *ca_addr = NULL;
-	u8 __iomem *eth_addr = NULL;
+	int	retval = -ENOMEM;
+	void __iomem *mpu_addr;
+	void __iomem *ca_addr;
+	u8 __iomem *eth_addr;
 
 	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
-	if (!res)
-		goto probe_failed;
-	mpu_addr = ioremap_nocache(res->start, 4);
-	if (!mpu_addr) {
-		retval = -ENOMEM;
-		goto probe_failed;
-	}
 	ca = platform_get_resource(dev, IORESOURCE_MEM, 1);
-	if (!ca)
-		goto probe_failed;
-	ca_addr = ioremap_nocache(ca->start, 4);
-	if (!ca_addr) {
-		retval = -ENOMEM;
-		goto probe_failed;
-	}
-	idprom = platform_get_resource(dev, IORESOURCE_MEM, 2);
-	if (!idprom)
-		goto probe_failed;
-	eth_addr = ioremap_nocache(idprom->start, 0x10);
-	if (!eth_addr) {
-		retval = -ENOMEM;
-		goto probe_failed;
-	}
 	options = platform_get_resource(dev, 0, 0);
-	if (!options)
-		goto probe_failed;
+	idprom = platform_get_resource(dev, IORESOURCE_MEM, 2);
+	if (!res || !ca || !options || !idprom)
+		return -ENODEV;
+	mpu_addr = ioremap_nocache(res->start, 4);
+	if (!mpu_addr)
+		return -ENOMEM;
+	ca_addr = ioremap_nocache(ca->start, 4);
+	if (!ca_addr)
+		goto probe_failed_free_mpu;
 
 	printk(KERN_INFO "Found i82596 at 0x%x\n", res->start);
 
 	netdevice = alloc_etherdev(sizeof(struct i596_private));
-	if (!netdevice) {
-		retval = -ENOMEM;
-		goto probe_failed;
-	}
+	if (!netdevice)
+		goto probe_failed_free_ca;
+
 	SET_NETDEV_DEV(netdevice, &dev->dev);
 	platform_set_drvdata (dev, netdevice);
 
 	netdevice->base_addr = res->start;
 	netdevice->irq = platform_get_irq(dev, 0);
 
-	/* someone seams to like messed up stuff */
+	eth_addr = ioremap_nocache(idprom->start, 0x10);
+	if (!eth_addr)
+		goto probe_failed;
+
+	/* someone seems to like messed up stuff */
 	netdevice->dev_addr[0] = readb(eth_addr + 0x0b);
 	netdevice->dev_addr[1] = readb(eth_addr + 0x0a);
 	netdevice->dev_addr[2] = readb(eth_addr + 0x09);
@@ -147,16 +135,15 @@ static int __devinit sni_82596_probe(str
 	lp->mpu_port = mpu_addr;
 
 	retval = i82596_probe(netdevice);
-	if (retval) {
-		free_netdev(netdevice);
+	if (retval == 0)
+		return 0;
+
 probe_failed:
-		if (mpu_addr)
-			iounmap(mpu_addr);
-		if (ca_addr)
-			iounmap(ca_addr);
-		if (eth_addr)
-			iounmap(ca_addr);
-	}
+	free_netdev(netdevice);
+probe_failed_free_ca:
+	iounmap(ca_addr);
+probe_failed_free_mpu:
+	iounmap(mpu_addr);
 	return retval;
 }
 
_

Patches currently in -mm which might be from tsbogend@alpha.franken.de are

git-netdev-all.patch
git-scsi-misc.patch
rtc-driver-for-ds1216-chips.patch
rtc-driver-for-ds1216-chips-fix.patch
