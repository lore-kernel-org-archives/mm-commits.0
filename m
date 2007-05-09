From: akpm@linux-foundation.org
Subject: - lguest-the-net-driver-lguest-2621-mm1-update-lguest-net-stats-inlinepatch.patch removed from -mm tree
Date: Wed, 09 May 2007 02:43:36 -0700
Message-ID: <200705090943.l499hac0020222@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57976 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754720AbXEIJoJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 05:44:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, ak@suse.de, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     lguest: 2.6.21-mm1 update: lguest-net-stats-inline.patch
has been removed from the -mm tree.  Its filename was
     lguest-the-net-driver-lguest-2621-mm1-update-lguest-net-stats-inlinepatch.patch

This patch was dropped because it was folded into lguest-the-net-driver.patch

------------------------------------------------------
Subject: lguest: 2.6.21-mm1 update: lguest-net-stats-inline.patch
From: Rusty Russell <rusty@rustcorp.com.au>

Now inline net_device_stats is upstream, we can use it in the lguest net
driver.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/lguest_net.c |   20 +++++---------------
 1 files changed, 5 insertions(+), 15 deletions(-)

diff -puN drivers/net/lguest_net.c~lguest-the-net-driver-lguest-2621-mm1-update-lguest-net-stats-inlinepatch drivers/net/lguest_net.c
--- a/drivers/net/lguest_net.c~lguest-the-net-driver-lguest-2621-mm1-update-lguest-net-stats-inlinepatch
+++ a/drivers/net/lguest_net.c
@@ -38,8 +38,6 @@ struct lguestnet_info
 	/* My peerid. */
 	unsigned int me;
 
-	struct net_device_stats stats;
-
 	/* Receive queue. */
 	struct sk_buff *skb[NUM_SKBS];
 	struct lguest_dma dma[NUM_SKBS];
@@ -120,13 +118,13 @@ static void transfer_packet(struct net_d
 
 	hcall(LHCALL_SEND_DMA, peer_key(info,peernum), __pa(&dma), 0);
 	if (dma.used_len != skb->len) {
-		info->stats.tx_carrier_errors++;
+		dev->stats.tx_carrier_errors++;
 		pr_debug("Bad xfer to peer %i: %i of %i (dma %p/%i)\n",
 			 peernum, dma.used_len, skb->len,
 			 (void *)dma.addr[0], dma.len[0]);
 	} else {
-		info->stats.tx_bytes += skb->len;
-		info->stats.tx_packets++;
+		dev->stats.tx_bytes += skb->len;
+		dev->stats.tx_packets++;
 	}
 }
 
@@ -212,8 +210,8 @@ static irqreturn_t lguestnet_rcv(int irq
 		pr_debug("Receiving skb proto 0x%04x len %i type %i\n",
 			 ntohs(skb->protocol), skb->len, skb->pkt_type);
 
-		info->stats.rx_bytes += skb->len;
-		info->stats.rx_packets++;
+		dev->stats.rx_bytes += skb->len;
+		dev->stats.rx_packets++;
 		netif_rx(skb);
 	}
 	return done ? IRQ_HANDLED : IRQ_NONE;
@@ -260,13 +258,6 @@ static int lguestnet_close(struct net_de
 	return 0;
 }
 
-static struct net_device_stats *lguestnet_get_stats(struct net_device *dev)
-{
-	struct lguestnet_info *info = dev->priv;
-
-	return &info->stats;
-}
-
 static int lguestnet_probe(struct lguest_device *lgdev)
 {
 	int err, irqf = IRQF_SHARED;
@@ -295,7 +286,6 @@ static int lguestnet_probe(struct lguest
 	dev->open = lguestnet_open;
 	dev->stop = lguestnet_close;
 	dev->hard_start_xmit = lguestnet_start_xmit;
-	dev->get_stats = lguestnet_get_stats;
 
 	/* Turning on/off promisc will call dev->set_multicast_list.
 	 * We don't actually support multicast yet */
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
____call_usermodehelper-dont-flush_signals.patch
wait_for_helper-remove-unneeded-do_sigaction.patch
futex-new-private-futexes.patch
compiler-introduce-__used-and-__maybe_unused.patch
xfs-clean-up-shrinker-games.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-fix.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
lguest-export-symbols-for-lguest-as-a-module.patch
lguest-the-guest-code.patch
lguest-the-host-code.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-console-driver.patch
lguest-the-net-driver.patch
lguest-the-net-driver-lguest-2621-mm1-update-lguest-net-stats-inlinepatch.patch
lguest-the-net-driver-two-net-bugfixes.patch
lguest-the-block-driver.patch
lguest-the-documentation-example-launcher.patch
lguest-the-documentation-example-launcher-fix-lguest-documentation-error.patch
lguest-documentation-and-example-updates.patch
lguest-the-documentation-example-launcher-dont-use-paravirt_probe-its-dying-doc.patch
lguest-use-standard-bootloader-format-fix-badly-sized-doc.patch
lguest-two-net-bugfixes-doc.patch
lguest-the-host-code-vs-futex-new-private-futexes.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
