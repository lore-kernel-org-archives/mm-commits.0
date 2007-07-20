From: akpm@linux-foundation.org
Subject: + atl1-use-kernel-provided-ethernet-length-constants.patch added to -mm tree
Date: Fri, 20 Jul 2007 14:45:21 -0700
Message-ID: <200707202145.l6KLjLOt018088@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52820 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759317AbXGTVp3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 17:45:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jacliburn@bellsouth.net


The patch titled
     atl1: use kernel provided ethernet length constants
has been added to the -mm tree.  Its filename is
     atl1-use-kernel-provided-ethernet-length-constants.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: atl1: use kernel provided ethernet length constants
From: Jay Cliburn <jacliburn@bellsouth.net>

Use constants already provided by the kernel for ethernet related lengths.

Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/atl1/atl1_hw.h   |    5 -----
 drivers/net/atl1/atl1_main.c |   13 +++++++------
 2 files changed, 7 insertions(+), 11 deletions(-)

diff -puN drivers/net/atl1/atl1_hw.h~atl1-use-kernel-provided-ethernet-length-constants drivers/net/atl1/atl1_hw.h
--- a/drivers/net/atl1/atl1_hw.h~atl1-use-kernel-provided-ethernet-length-constants
+++ a/drivers/net/atl1/atl1_hw.h
@@ -680,11 +680,6 @@ void atl1_check_options(struct atl1_adap
 #define AUTONEG_ADVERTISE_10_100_ALL	0x000F	/* All 10/100 speeds */
 #define AUTONEG_ADVERTISE_10_ALL	0x0003	/* 10Mbps Full & Half speeds */
 
-/* The size (in bytes) of a ethernet packet */
-#define ENET_HEADER_SIZE		14
-#define MAXIMUM_ETHERNET_FRAME_SIZE	1518	/* with FCS */
-#define MINIMUM_ETHERNET_FRAME_SIZE	64	/* with FCS */
-#define ETHERNET_FCS_SIZE		4
 #define MAX_JUMBO_FRAME_SIZE		0x2800
 
 #define PHY_AUTO_NEG_TIME	45	/* 4.5 Seconds */
diff -puN drivers/net/atl1/atl1_main.c~atl1-use-kernel-provided-ethernet-length-constants drivers/net/atl1/atl1_main.c
--- a/drivers/net/atl1/atl1_main.c~atl1-use-kernel-provided-ethernet-length-constants
+++ a/drivers/net/atl1/atl1_main.c
@@ -59,6 +59,7 @@
 #include <linux/skbuff.h>
 #include <linux/etherdevice.h>
 #include <linux/if_vlan.h>
+#include <linux/if_ether.h>
 #include <linux/irqreturn.h>
 #include <linux/workqueue.h>
 #include <linux/timer.h>
@@ -120,8 +121,8 @@ static int __devinit atl1_sw_init(struct
 	struct atl1_hw *hw = &adapter->hw;
 	struct net_device *netdev = adapter->netdev;
 
-	hw->max_frame_size = netdev->mtu + ENET_HEADER_SIZE + ETHERNET_FCS_SIZE;
-	hw->min_frame_size = MINIMUM_ETHERNET_FRAME_SIZE;
+	hw->max_frame_size = netdev->mtu + ETH_HLEN + ETH_FCS_LEN;
+	hw->min_frame_size = ETH_ZLEN + ETH_FCS_LEN;
 
 	adapter->wol = 0;
 	adapter->rx_buffer_len = (hw->max_frame_size + 7) & ~7;
@@ -688,9 +689,9 @@ static int atl1_change_mtu(struct net_de
 {
 	struct atl1_adapter *adapter = netdev_priv(netdev);
 	int old_mtu = netdev->mtu;
-	int max_frame = new_mtu + ENET_HEADER_SIZE + ETHERNET_FCS_SIZE;
+	int max_frame = new_mtu + ETH_HLEN + ETH_FCS_LEN;
 
-	if ((max_frame < MINIMUM_ETHERNET_FRAME_SIZE) ||
+	if ((max_frame < ETH_ZLEN + ETH_FCS_LEN) ||
 	    (max_frame > MAX_JUMBO_FRAME_SIZE)) {
 		dev_warn(&adapter->pdev->dev, "invalid MTU setting\n");
 		return -EINVAL;
@@ -1337,7 +1338,7 @@ rrd_ok:
 		skb = buffer_info->skb;
 		length = le16_to_cpu(rrd->xsz.xsum_sz.pkt_size);
 
-		skb_put(skb, length - ETHERNET_FCS_SIZE);
+		skb_put(skb, length - ETH_FCS_LEN);
 
 		/* Receive Checksum Offload */
 		atl1_rx_checksum(adapter, rrd, skb);
@@ -1456,7 +1457,7 @@ static int atl1_tso(struct atl1_adapter 
 			tcp_hdr(skb)->check = ~csum_tcpudp_magic(iph->saddr,
 				iph->daddr, 0, IPPROTO_TCP, 0);
 			ipofst = skb_network_offset(skb);
-			if (ipofst != ENET_HEADER_SIZE) /* 802.3 frame */
+			if (ipofst != ETH_HLEN) /* 802.3 frame */
 				tso->tsopl |= 1 << TSO_PARAM_ETHTYPE_SHIFT;
 
 			tso->tsopl |= (iph->ihl &
_

Patches currently in -mm which might be from jacliburn@bellsouth.net are

origin.patch
atl1-change-tpd_avail-function-name.patch
atl1-fix-typo-in-dma-engine-setup.patch
atl1-change-cmb-write-threshold.patch
atl1-fix-typo-in-dma_req_block.patch
atl1-use-kernel-provided-ethernet-length-constants.patch
