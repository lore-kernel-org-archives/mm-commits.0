From: akpm@linux-foundation.org
Subject: [merged] rapidio-rionet-add-capability-to-change-mtu.patch
 removed from -mm tree
Date: Wed, 23 Mar 2016 10:41:13 -0700
Message-ID: <56f2d539.JuWU5BHnaHfb58mK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59152 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756516AbcCWRlO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:41:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a-jacquiot@ti.com, alexandre.bounine@idt.com, andre.van.herk@prodrive-technologies.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/rionet: add capability to change MTU
has been removed from the -mm tree.  Its filename was
     rapidio-rionet-add-capability-to-change-mtu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Aurelien Jacquiot <a-jacquiot@ti.com>
Subject: rapidio/rionet: add capability to change MTU

These patches are the result of extensive collaboration within the
RapidIO.org Software Task Group between Texas Instruments, Freescale,
Prodrive Technologies, Nokia Networks, BAE and IDT.  Additional input was
received from other members of RapidIO.org.  The objective was to create a
character mode driver interface which exposes the capabilities of RapidIO
devices directly to applications, in a manner that allows the numerous and
varied RapidIO implementations to interoperate.

The Software Task Group has also developed fabric management, Remote
Memory Access, and sockets applications which make use of these interfaces
in user space.  Intensive testing with these applications prompted the
RapidIO subsystem updates provided within this set of patches.


This patch (of 29):

Replace default Ethernet-specific routine by the custom one to allow
setting of larger MTU supported by RapidIO messaging (max RIO packet size
is 4096 bytes).

Signed-off-by: Aurelien Jacquiot <a-jacquiot@ti.com>
Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/rionet.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff -puN drivers/net/rionet.c~rapidio-rionet-add-capability-to-change-mtu drivers/net/rionet.c
--- a/drivers/net/rionet.c~rapidio-rionet-add-capability-to-change-mtu
+++ a/drivers/net/rionet.c
@@ -48,6 +48,8 @@ MODULE_LICENSE("GPL");
 #define RIONET_TX_RING_SIZE	CONFIG_RIONET_TX_SIZE
 #define RIONET_RX_RING_SIZE	CONFIG_RIONET_RX_SIZE
 #define RIONET_MAX_NETS		8
+#define RIONET_MSG_SIZE         RIO_MAX_MSG_SIZE
+#define RIONET_MAX_MTU          (RIONET_MSG_SIZE - ETH_HLEN)
 
 struct rionet_private {
 	struct rio_mport *mport;
@@ -443,6 +445,17 @@ static void rionet_set_msglevel(struct n
 	rnet->msg_enable = value;
 }
 
+static int rionet_change_mtu(struct net_device *ndev, int new_mtu)
+{
+	if ((new_mtu < 68) || (new_mtu > RIONET_MAX_MTU)) {
+		printk(KERN_ERR "%s: Invalid MTU size %d\n",
+		       ndev->name, new_mtu);
+		return -EINVAL;
+	}
+	ndev->mtu = new_mtu;
+	return 0;
+}
+
 static const struct ethtool_ops rionet_ethtool_ops = {
 	.get_drvinfo = rionet_get_drvinfo,
 	.get_msglevel = rionet_get_msglevel,
@@ -454,7 +467,7 @@ static const struct net_device_ops rione
 	.ndo_open		= rionet_open,
 	.ndo_stop		= rionet_close,
 	.ndo_start_xmit		= rionet_start_xmit,
-	.ndo_change_mtu		= eth_change_mtu,
+	.ndo_change_mtu		= rionet_change_mtu,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address	= eth_mac_addr,
 };
@@ -489,7 +502,7 @@ static int rionet_setup_netdev(struct ri
 	ndev->dev_addr[5] = device_id & 0xff;
 
 	ndev->netdev_ops = &rionet_netdev_ops;
-	ndev->mtu = RIO_MAX_MSG_SIZE - 14;
+	ndev->mtu = RIONET_MAX_MTU;
 	ndev->features = NETIF_F_LLTX;
 	SET_NETDEV_DEV(ndev, &mport->dev);
 	ndev->ethtool_ops = &rionet_ethtool_ops;
_

Patches currently in -mm which might be from a-jacquiot@ti.com are


