From: akpm@linux-foundation.org
Subject: - extract-chip-specific-code-out-of-lasi_82596c-update.patch removed from -mm tree
Date: Mon, 02 Jul 2007 13:16:51 -0700
Message-ID: <200707022016.l62KGpAs004809@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41839 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754249AbXGBUYs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Jul 2007 16:24:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tsbogend@alpha.franken.de, mm-commits@vger.kernel.org


The patch titled
     Extract chip specific code out of lasi_82596.c (update)
has been removed from the -mm tree.  Its filename was
     extract-chip-specific-code-out-of-lasi_82596c-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Extract chip specific code out of lasi_82596.c (update)
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

Below is an updated patch with changes recommended/requested by Andrew

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/lasi_82596.c |   14 +++-----------
 drivers/net/lib82596.c   |   22 ++++++++++++----------
 2 files changed, 15 insertions(+), 21 deletions(-)

diff -puN drivers/net/lasi_82596.c~extract-chip-specific-code-out-of-lasi_82596c-update drivers/net/lasi_82596.c
--- a/drivers/net/lasi_82596.c~extract-chip-specific-code-out-of-lasi_82596c-update
+++ a/drivers/net/lasi_82596.c
@@ -115,9 +115,6 @@
 #define SWAP32(x)   (((u32)(x)<<16) | ((((u32)(x)))>>16))
 #define SWAP16(x)   (x)
 
-static inline void CA(struct net_device *dev);
-static inline void MPU_PORT(struct net_device *dev, int c, dma_addr_t x);
-
 #include "lib82596.c"
 
 MODULE_AUTHOR("Richard Hirst");
@@ -126,13 +123,13 @@ MODULE_LICENSE("GPL");
 module_param(i596_debug, int, 0);
 MODULE_PARM_DESC(i596_debug, "lasi_82596 debug mask");
 
-static inline void CA(struct net_device *dev)
+static inline void ca(struct net_device *dev)
 {
 	gsc_writel(0, dev->base_addr + PA_CHANNEL_ATTENTION);
 }
 
 
-static inline void MPU_PORT(struct net_device *dev, int c, dma_addr_t x)
+static void mpu_port(struct net_device *dev, int c, dma_addr_t x)
 {
 	struct i596_private *lp = netdev_priv(dev);
 
@@ -160,14 +157,8 @@ lan_init_chip(struct parisc_device *dev)
 	struct	net_device *netdevice;
 	struct i596_private *lp;
 	int	retval;
-	static int init;
 	int i;
 
-	if (init == 0) {
-		printk(KERN_INFO LASI_82596_DRIVER_VERSION "\n");
-		init++;
-	}
-
 	if (!dev->irq) {
 		printk(KERN_ERR "%s: IRQ not found for i82596 at 0x%lx\n",
 			__FILE__, dev->hpa.start);
@@ -234,6 +225,7 @@ static struct parisc_driver lan_driver =
 
 static int __devinit lasi_82596_init(void)
 {
+	printk(KERN_INFO LASI_82596_DRIVER_VERSION "\n");
 	return register_parisc_driver(&lan_driver);
 }
 
diff -puN drivers/net/lib82596.c~extract-chip-specific-code-out-of-lasi_82596c-update drivers/net/lib82596.c
--- a/drivers/net/lib82596.c~extract-chip-specific-code-out-of-lasi_82596c-update
+++ a/drivers/net/lib82596.c
@@ -357,6 +357,8 @@ static void i596_add_cmd(struct net_devi
 static void i596_tx_timeout (struct net_device *dev);
 static void print_eth(unsigned char *buf, char *str);
 static void set_multicast_list(struct net_device *dev);
+static inline void ca(struct net_device *dev);
+static void mpu_port(struct net_device *dev, int c, dma_addr_t x);
 
 static int rx_ring_size = RX_RING_SIZE;
 static int ticks_limit = 100;
@@ -558,7 +560,7 @@ static int init_i596_mem(struct net_devi
 	struct i596_dma *dma = lp->dma;
 	unsigned long flags;
 
-	MPU_PORT(dev, PORT_RESET, 0);
+	mpu_port(dev, PORT_RESET, 0);
 	udelay(100);			/* Wait 100us - seems to help */
 
 	/* change the scp address */
@@ -580,8 +582,8 @@ static int init_i596_mem(struct net_devi
 	DMA_WBACK(dev, &(dma->iscp), sizeof(struct i596_iscp));
 	DMA_WBACK(dev, &(dma->scb), sizeof(struct i596_scb));
 
-	MPU_PORT(dev, PORT_ALTSCP, virt_to_dma(lp, &dma->scp));
-	CA(dev);
+	mpu_port(dev, PORT_ALTSCP, virt_to_dma(lp, &dma->scp));
+	ca(dev);
 	if (wait_istat(dev, dma, 1000, "initialization timed out"))
 		goto failed;
 	DEB(DEB_INIT, printk(KERN_DEBUG
@@ -628,7 +630,7 @@ static int init_i596_mem(struct net_devi
 	dma->scb.rfd = SWAP32(virt_to_dma(lp, dma->rfds));
 	DMA_WBACK(dev, &(dma->scb), sizeof(struct i596_scb));
 
-	CA(dev);
+	ca(dev);
 
 	spin_unlock_irqrestore (&lp->lock, flags);
 	if (wait_cmd(dev, dma, 1000, "RX_START not processed"))
@@ -641,7 +643,7 @@ failed_free_irq:
 	free_irq(dev->irq, dev);
 failed:
 	printk(KERN_ERR "%s: Failed to initialise 82596\n", dev->name);
-	MPU_PORT(dev, PORT_RESET, 0);
+	mpu_port(dev, PORT_RESET, 0);
 	return -1;
 }
 
@@ -857,7 +859,7 @@ static inline void i596_reset(struct net
 	/* FIXME: this command might cause an lpmc */
 	lp->dma->scb.command = SWAP16(CUC_ABORT | RX_ABORT);
 	DMA_WBACK(dev, &(lp->dma->scb), sizeof(struct i596_scb));
-	CA(dev);
+	ca(dev);
 
 	/* wait for shutdown */
 	wait_cmd(dev, lp->dma, 1000, "i596_reset 2 timed out");
@@ -898,7 +900,7 @@ static void i596_add_cmd(struct net_devi
 		dma->scb.cmd = SWAP32(virt_to_dma(lp, &cmd->status));
 		dma->scb.command = SWAP16(CUC_START);
 		DMA_WBACK(dev, &(dma->scb), sizeof(struct i596_scb));
-		CA(dev);
+		ca(dev);
 	}
 	lp->cmd_tail = cmd;
 	lp->cmd_backlog++;
@@ -961,7 +963,7 @@ static void i596_tx_timeout (struct net_
 		DEB(DEB_ERRORS, printk(KERN_DEBUG "Kicking board.\n"));
 		lp->dma->scb.command = SWAP16(CUC_START | RX_START);
 		DMA_WBACK_INV(dev, &(lp->dma->scb), sizeof(struct i596_scb));
-		CA (dev);
+		ca (dev);
 		lp->last_restart = lp->stats.tx_packets;
 	}
 
@@ -1304,7 +1306,7 @@ static irqreturn_t i596_interrupt(int ir
 	 acknowledgement aside from acking the 82596 might be needed
 	 here...  but it's running acceptably without */
 
-	CA(dev);
+	ca(dev);
 
 	wait_cmd(dev, dma, 100, "i596 interrupt, exit timeout");
 	DEB(DEB_INTS, printk(KERN_DEBUG "%s: exiting interrupt.\n", dev->name));
@@ -1331,7 +1333,7 @@ static int i596_close(struct net_device 
 	lp->dma->scb.command = SWAP16(CUC_ABORT | RX_ABORT);
 	DMA_WBACK(dev, &lp->dma->scb, sizeof(struct i596_scb));
 
-	CA(dev);
+	ca(dev);
 
 	wait_cmd(dev, lp->dma, 100, "close2 timed out");
 	spin_unlock_irqrestore(&lp->lock, flags);
_

Patches currently in -mm which might be from tsbogend@alpha.franken.de are

git-netdev-all.patch
git-scsi-misc.patch
rtc-driver-for-ds1216-chips.patch
rtc-driver-for-ds1216-chips-fix.patch
