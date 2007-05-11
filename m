From: akpm@linux-foundation.org
Subject: + lguest-the-net-driver-tidyups.patch added to -mm tree
Date: Thu, 10 May 2007 20:50:58 -0700
Message-ID: <200705110350.l4B3owsC005540@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50573 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757366AbXEKDvD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 23:51:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au


The patch titled
     lguest network driver feedback tidyups
has been added to the -mm tree.  Its filename is
     lguest-the-net-driver-tidyups.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lguest network driver feedback tidyups
From: Rusty Russell <rusty@rustcorp.com.au>

Feedback from Jeff Garzik:
1) Use netdev_priv instead of dev->priv.
2) Check for ioremap failure
3) iounmap on failure.
4) Wrap SEND_DMA and BIND_DMA calls
5) Don't set NETIF_F_SG unless we set NETIF_F_NO_CSUM
6) Use SET_NETDEV_DEV()
7) Don't set dev->irq, mem_start & mem_end (deprecated)

Sparse warnings:
8) __force the ioremap: guests can use it as normal memory.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/lguest_net.c |   51 +++++++++++++++++++++----------------
 1 file changed, 30 insertions(+), 21 deletions(-)

diff -puN drivers/net/lguest_net.c~lguest-the-net-driver-tidyups drivers/net/lguest_net.c
--- a/drivers/net/lguest_net.c~lguest-the-net-driver-tidyups
+++ a/drivers/net/lguest_net.c
@@ -35,6 +35,9 @@ struct lguestnet_info
 	unsigned long peer_phys;
 	unsigned long mapsize;
 
+	/* The lguest_device I come from */
+	struct lguest_device *lgdev;
+
 	/* My peerid. */
 	unsigned int me;
 
@@ -84,7 +87,7 @@ static void skb_to_dma(const struct sk_b
 
 static void lguestnet_set_multicast(struct net_device *dev)
 {
-	struct lguestnet_info *info = dev->priv;
+	struct lguestnet_info *info = netdev_priv(dev);
 
 	if ((dev->flags & (IFF_PROMISC|IFF_ALLMULTI)) || dev->mc_count)
 		info->peer[info->me].mac[0] |= PROMISC_BIT;
@@ -110,13 +113,13 @@ static void transfer_packet(struct net_d
 			    struct sk_buff *skb,
 			    unsigned int peernum)
 {
-	struct lguestnet_info *info = dev->priv;
+	struct lguestnet_info *info = netdev_priv(dev);
 	struct lguest_dma dma;
 
 	skb_to_dma(skb, skb_headlen(skb), &dma);
 	pr_debug("xfer length %04x (%u)\n", htons(skb->len), skb->len);
 
-	hcall(LHCALL_SEND_DMA, peer_key(info,peernum), __pa(&dma), 0);
+	lguest_send_dma(peer_key(info, peernum), &dma);
 	if (dma.used_len != skb->len) {
 		dev->stats.tx_carrier_errors++;
 		pr_debug("Bad xfer to peer %i: %i of %i (dma %p/%i)\n",
@@ -137,7 +140,7 @@ static int lguestnet_start_xmit(struct s
 {
 	unsigned int i;
 	int broadcast;
-	struct lguestnet_info *info = dev->priv;
+	struct lguestnet_info *info = netdev_priv(dev);
 	const unsigned char *dest = ((struct ethhdr *)skb->data)->h_dest;
 
 	pr_debug("%s: xmit %02x:%02x:%02x:%02x:%02x:%02x\n",
@@ -162,7 +165,7 @@ static int lguestnet_start_xmit(struct s
 /* Find a new skb to put in this slot in shared mem. */
 static int fill_slot(struct net_device *dev, unsigned int slot)
 {
-	struct lguestnet_info *info = dev->priv;
+	struct lguestnet_info *info = netdev_priv(dev);
 	/* Try to create and register a new one. */
 	info->skb[slot] = netdev_alloc_skb(dev, ETH_HLEN + ETH_DATA_LEN);
 	if (!info->skb[slot]) {
@@ -180,7 +183,7 @@ static int fill_slot(struct net_device *
 static irqreturn_t lguestnet_rcv(int irq, void *dev_id)
 {
 	struct net_device *dev = dev_id;
-	struct lguestnet_info *info = dev->priv;
+	struct lguestnet_info *info = netdev_priv(dev);
 	unsigned int i, done = 0;
 
 	for (i = 0; i < ARRAY_SIZE(info->dma); i++) {
@@ -220,7 +223,7 @@ static irqreturn_t lguestnet_rcv(int irq
 static int lguestnet_open(struct net_device *dev)
 {
 	int i;
-	struct lguestnet_info *info = dev->priv;
+	struct lguestnet_info *info = netdev_priv(dev);
 
 	/* Set up our MAC address */
 	memcpy(info->peer[info->me].mac, dev->dev_addr, ETH_ALEN);
@@ -232,8 +235,8 @@ static int lguestnet_open(struct net_dev
 		if (fill_slot(dev, i) != 0)
 			goto cleanup;
 	}
-	if (!hcall(LHCALL_BIND_DMA, peer_key(info, info->me), __pa(info->dma),
-		   (NUM_SKBS << 8) | dev->irq))
+	if (lguest_bind_dma(peer_key(info,info->me), info->dma,
+			    NUM_SKBS, lgdev_irq(info->lgdev)) != 0)
 		goto cleanup;
 	return 0;
 
@@ -246,13 +249,13 @@ cleanup:
 static int lguestnet_close(struct net_device *dev)
 {
 	unsigned int i;
-	struct lguestnet_info *info = dev->priv;
+	struct lguestnet_info *info = netdev_priv(dev);
 
 	/* Clear all trace: others might deliver packets, we'll ignore it. */
 	memset(&info->peer[info->me], 0, sizeof(info->peer[info->me]));
 
 	/* Deregister sg lists. */
-	hcall(LHCALL_BIND_DMA, peer_key(info, info->me), __pa(info->dma), 0);
+	lguest_unbind_dma(peer_key(info, info->me), info->dma);
 	for (i = 0; i < ARRAY_SIZE(info->dma); i++)
 		dev_kfree_skb(info->skb[i]);
 	return 0;
@@ -290,30 +293,34 @@ static int lguestnet_probe(struct lguest
 	/* Turning on/off promisc will call dev->set_multicast_list.
 	 * We don't actually support multicast yet */
 	dev->set_multicast_list = lguestnet_set_multicast;
-	dev->mem_start = ((unsigned long)desc->pfn << PAGE_SHIFT);
-	dev->mem_end = dev->mem_start + PAGE_SIZE * desc->num_pages;
-	dev->irq = lgdev->index+1;
-	dev->features = NETIF_F_SG;
+	SET_NETDEV_DEV(dev, &lgdev->dev);
 	if (desc->features & LGUEST_NET_F_NOCSUM)
-		dev->features |= NETIF_F_NO_CSUM;
+		dev->features = NETIF_F_SG|NETIF_F_NO_CSUM;
 
-	info = dev->priv;
+	info = netdev_priv(dev);
 	info->mapsize = PAGE_SIZE * desc->num_pages;
 	info->peer_phys = ((unsigned long)desc->pfn << PAGE_SHIFT);
-	info->peer = (void *)ioremap(info->peer_phys, info->mapsize);
+	info->lgdev = lgdev;
+	info->peer = (__force void *)ioremap(info->peer_phys, info->mapsize);
+	if (!info->peer) {
+		err = -ENOMEM;
+		goto free;
+	}
+
 	/* This stores our peerid (upper bits reserved for future). */
 	info->me = (desc->features & (info->mapsize-1));
 
 	err = register_netdev(dev);
 	if (err) {
 		pr_debug("lguestnet: registering device failed\n");
-		goto free;
+		goto unmap;
 	}
 
 	if (lguest_devices[lgdev->index].features & LGUEST_DEVICE_F_RANDOMNESS)
 		irqf |= IRQF_SAMPLE_RANDOM;
-	if (request_irq(dev->irq, lguestnet_rcv, irqf, "lguestnet", dev) != 0) {
-		pr_debug("lguestnet: could not get net irq %i\n", dev->irq);
+	if (request_irq(lgdev_irq(lgdev), lguestnet_rcv, irqf, "lguestnet",
+			dev) != 0) {
+		pr_debug("lguestnet: cannot get irq %i\n", lgdev_irq(lgdev));
 		goto unregister;
 	}
 
@@ -323,6 +330,8 @@ static int lguestnet_probe(struct lguest
 
 unregister:
 	unregister_netdev(dev);
+unmap:
+	iounmap((__force void __iomem *)info->peer);
 free:
 	free_netdev(dev);
 	return err;
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
xfs-clean-up-shrinker-games.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-fix.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
powerpc-fixup-hard_irq_disable-semantics.patch
add-hard_irq_disable.patch
stop_machine-now-uses-hard_irq_disable.patch
stop_machine-now-uses-hard_irq_disable-fix.patch
use-menuconfig-objects-ii-module-menu.patch
module_author-dont-advice-putting-in-an-email-address.patch
lguest-export-symbols-for-lguest-as-a-module.patch
lguest-the-guest-code.patch
lguest-the-guest-code-tidyups.patch
lguest-the-host-code.patch
lguest-the-host-code-tidyups.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-makefile-and-kconfig-tidyups.patch
lguest-the-console-driver.patch
lguest-the-console-driver-tidyups.patch
lguest-the-net-driver.patch
lguest-the-net-driver-tidyups.patch
lguest-the-block-driver.patch
lguest-the-block-driver-tidyups.patch
lguest-the-documentation-example-launcher.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
