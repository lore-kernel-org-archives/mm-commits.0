From: akpm@osdl.org
Subject: - m68k-hp300-hp-lance-updates.patch removed from -mm tree
Date: Sat, 09 Dec 2006 17:52:53 -0800
Message-ID: <200612100152.kBA1qrWp010609@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:40579 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759288AbWLJBxa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 9 Dec 2006 20:53:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jongk@linux-m68k.org, geert@linux-m68k.org, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     m68k/HP300: HP LANCE updates
has been removed from the -mm tree.  Its filename was
     m68k-hp300-hp-lance-updates.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: m68k/HP300: HP LANCE updates
From: Kars de Jong <jongk@linux-m68k.org>

- 7990: request_irq() should have SA_SHIRQ flag set
- hplance_init() printed dev->name before register_netdev() had filled it in

Signed-off-by: Kars de Jong <jongk@linux-m68k.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/7990.c    |    2 +-
 drivers/net/hplance.c |   14 ++++++++++----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff -puN drivers/net/7990.c~m68k-hp300-hp-lance-updates drivers/net/7990.c
--- a/drivers/net/7990.c~m68k-hp300-hp-lance-updates
+++ a/drivers/net/7990.c
@@ -500,7 +500,7 @@ int lance_open (struct net_device *dev)
 	int res;
 
         /* Install the Interrupt handler. Or we could shunt this out to specific drivers? */
-        if (request_irq(lp->irq, lance_interrupt, 0, lp->name, dev))
+        if (request_irq(lp->irq, lance_interrupt, SA_SHIRQ, lp->name, dev))
                 return -EAGAIN;
 
         res = lance_reset(dev);
diff -puN drivers/net/hplance.c~m68k-hp300-hp-lance-updates drivers/net/hplance.c
--- a/drivers/net/hplance.c~m68k-hp300-hp-lance-updates
+++ a/drivers/net/hplance.c
@@ -77,6 +77,7 @@ static int __devinit hplance_init_one(st
 {
 	struct net_device *dev;
 	int err = -ENOMEM;
+	int i;
 
 	dev = alloc_etherdev(sizeof(struct hplance_private));
 	if (!dev)
@@ -93,6 +94,15 @@ static int __devinit hplance_init_one(st
 		goto out_release_mem_region;
 
 	dio_set_drvdata(d, dev);
+
+	printk(KERN_INFO "%s: %s; select code %d, addr %2.2x", dev->name, d->name, d->scode, dev->dev_addr[0]);
+
+	for (i=1; i<6; i++) {
+		printk(":%2.2x", dev->dev_addr[i]);
+	}
+
+	printk(", irq %d\n", d->ipl);
+
 	return 0;
 
  out_release_mem_region:
@@ -119,8 +129,6 @@ static void __init hplance_init(struct n
         struct hplance_private *lp;
         int i;
 
-        printk(KERN_INFO "%s: %s; select code %d, addr", dev->name, d->name, d->scode);
-
         /* reset the board */
         out_8(va+DIO_IDOFF, 0xff);
         udelay(100);                              /* ariba! ariba! udelay! udelay! */
@@ -143,7 +151,6 @@ static void __init hplance_init(struct n
                  */
                 dev->dev_addr[i] = ((in_8(va + HPLANCE_NVRAMOFF + i*4 + 1) & 0xF) << 4)
                         | (in_8(va + HPLANCE_NVRAMOFF + i*4 + 3) & 0xF);
-                printk("%c%2.2x", i == 0 ? ' ' : ':', dev->dev_addr[i]);
         }
 
         lp = netdev_priv(dev);
@@ -160,7 +167,6 @@ static void __init hplance_init(struct n
         lp->lance.lance_log_tx_bufs = LANCE_LOG_TX_BUFFERS;
         lp->lance.rx_ring_mod_mask = RX_RING_MOD_MASK;
         lp->lance.tx_ring_mod_mask = TX_RING_MOD_MASK;
-	printk(", irq %d\n", lp->lance.irq);
 }
 
 /* This is disgusting. We have to check the DIO status register for ack every
_

Patches currently in -mm which might be from jongk@linux-m68k.org are

origin.patch

