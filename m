From: akpm@linux-foundation.org
Subject: + ethernet-driver-for-eisa-only-sni-rm200-rm400-machines-update.patch added to -mm tree
Date: Tue, 26 Jun 2007 14:29:41 -0700
Message-ID: <200706262129.l5QLTfG7002462@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49569 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752379AbXFZVaQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 17:30:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tsbogend@alpha.franken.de


The patch titled
     Ethernet driver for EISA only SNI RM200/RM400 machines (update)
has been added to the -mm tree.  Its filename is
     ethernet-driver-for-eisa-only-sni-rm200-rm400-machines-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Ethernet driver for EISA only SNI RM200/RM400 machines (update)
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

Below is an updated patch with changes recommended/requested by Andrew

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sni_82596.c |   26 ++++++++++----------------
 1 files changed, 10 insertions(+), 16 deletions(-)

diff -puN drivers/net/sni_82596.c~ethernet-driver-for-eisa-only-sni-rm200-rm400-machines-update drivers/net/sni_82596.c
--- a/drivers/net/sni_82596.c~ethernet-driver-for-eisa-only-sni-rm200-rm400-machines-update
+++ a/drivers/net/sni_82596.c
@@ -23,7 +23,7 @@
 
 #define SNI_82596_DRIVER_VERSION "SNI RM 82596 driver - Revision: 0.01"
 
-static char sni_82596_string[] = "snirm_82596";
+static const char sni_82596_string[] = "snirm_82596";
 
 #define DMA_ALLOC                      dma_alloc_coherent
 #define DMA_FREE                       dma_free_coherent
@@ -39,9 +39,6 @@ static char sni_82596_string[] = "snirm_
 
 #define OPT_MPU_16BIT    0x01
 
-static inline void CA(struct net_device *dev);
-static inline void MPU_PORT(struct net_device *dev, int c, dma_addr_t x);
-
 #include "lib82596.c"
 
 MODULE_AUTHOR("Thomas Bogendoerfer");
@@ -50,7 +47,7 @@ MODULE_LICENSE("GPL");
 module_param(i596_debug, int, 0);
 MODULE_PARM_DESC(i596_debug, "82596 debug mask");
 
-static inline void CA(struct net_device *dev)
+static inline void ca(struct net_device *dev)
 {
 	struct i596_private *lp = netdev_priv(dev);
 
@@ -58,7 +55,7 @@ static inline void CA(struct net_device 
 }
 
 
-static inline void MPU_PORT(struct net_device *dev, int c, dma_addr_t x)
+static void mpu_port(struct net_device *dev, int c, dma_addr_t x)
 {
 	struct i596_private *lp = netdev_priv(dev);
 
@@ -66,11 +63,13 @@ static inline void MPU_PORT(struct net_d
 
 	if (lp->options & OPT_MPU_16BIT) {
 		writew(v & 0xffff, lp->mpu_port);
-		wmb(); udelay(1); /* order writes to MPU port */
+		wmb();  /* order writes to MPU port */
+		udelay(1);
 		writew(v >> 16, lp->mpu_port);
 	} else {
 		writel(v, lp->mpu_port);
-		wmb(); udelay(1); /* order writes to MPU port */
+		wmb();  /* order writes to MPU port */
+		udelay(1);
 		writel(v, lp->mpu_port);
 	}
 }
@@ -82,16 +81,10 @@ static int __devinit sni_82596_probe(str
 	struct i596_private *lp;
 	struct  resource *res, *ca, *idprom, *options;
 	int	retval = -ENODEV;
-	static int init;
 	void __iomem *mpu_addr = NULL;
 	void __iomem *ca_addr = NULL;
 	u8 __iomem *eth_addr = NULL;
 
-	if (init == 0) {
-		printk(KERN_INFO SNI_82596_DRIVER_VERSION "\n");
-		init++;
-	}
-
 	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
 	if (!res)
 		goto probe_failed;
@@ -167,12 +160,12 @@ probe_failed:
 	return retval;
 }
 
-static int __devexit sni_82596_driver_remove (struct platform_device *pdev)
+static int __devexit sni_82596_driver_remove(struct platform_device *pdev)
 {
 	struct net_device *dev = platform_get_drvdata(pdev);
 	struct i596_private *lp = netdev_priv(dev);
 
-	unregister_netdev (dev);
+	unregister_netdev(dev);
 	DMA_FREE(dev->dev.parent, sizeof(struct i596_private),
 		 lp->dma, lp->dma_addr);
 	iounmap(lp->ca);
@@ -191,6 +184,7 @@ static struct platform_driver sni_82596_
 
 static int __devinit sni_82596_init(void)
 {
+	printk(KERN_INFO SNI_82596_DRIVER_VERSION "\n");
 	return platform_driver_register(&sni_82596_driver);
 }
 
_

Patches currently in -mm which might be from tsbogend@alpha.franken.de are

extract-chip-specific-code-out-of-lasi_82596c.patch
extract-chip-specific-code-out-of-lasi_82596c-update.patch
ethernet-driver-for-eisa-only-sni-rm200-rm400-machines.patch
ethernet-driver-for-eisa-only-sni-rm200-rm400-machines-update.patch
git-scsi-misc.patch
