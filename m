From: akpm@linux-foundation.org
Subject: + rapidio-rionet-rework-to-support-multiple-rio-master-ports.patch added to -mm tree
Date: Wed, 03 Oct 2012 15:37:11 -0700
Message-ID: <20121003223712.BD2BA20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:48085 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756629Ab2JCWhP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Oct 2012 18:37:15 -0400
Received: by wibhr7 with SMTP id hr7so166838wib.1
        for <mm-commits@vger.kernel.org>; Wed, 03 Oct 2012 15:37:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, davem@davemloft.net, leoli@freescale.com, mporter@kernel.crashing.org


The patch titled
     Subject: rapidio/rionet: rework to support multiple RIO master ports
has been added to the -mm tree.  Its filename is
     rapidio-rionet-rework-to-support-multiple-rio-master-ports.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio/rionet: rework to support multiple RIO master ports

Make RIONET driver multi-net safe/capable by introducing per-net lists of
RapidIO network peers.  Rework registration of network adapters to support
all available RIO master port devices.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/rionet.c |  133 +++++++++++++++++++++--------------------
 1 file changed, 70 insertions(+), 63 deletions(-)

diff -puN drivers/net/rionet.c~rapidio-rionet-rework-to-support-multiple-rio-master-ports drivers/net/rionet.c
--- a/drivers/net/rionet.c~rapidio-rionet-rework-to-support-multiple-rio-master-ports
+++ a/drivers/net/rionet.c
@@ -26,7 +26,7 @@
 #include <linux/ethtool.h>
 
 #define DRV_NAME        "rionet"
-#define DRV_VERSION     "0.2"
+#define DRV_VERSION     "0.3"
 #define DRV_AUTHOR      "Matt Porter <mporter@kernel.crashing.org>"
 #define DRV_DESC        "Ethernet over RapidIO"
 
@@ -47,8 +47,7 @@ MODULE_LICENSE("GPL");
 
 #define RIONET_TX_RING_SIZE	CONFIG_RIONET_TX_SIZE
 #define RIONET_RX_RING_SIZE	CONFIG_RIONET_RX_SIZE
-
-static LIST_HEAD(rionet_peers);
+#define RIONET_MAX_NETS		8
 
 struct rionet_private {
 	struct rio_mport *mport;
@@ -69,17 +68,14 @@ struct rionet_peer {
 	struct resource *res;
 };
 
-static int rionet_check = 0;
-static int rionet_capable = 1;
+struct rionet_net {
+	struct net_device *ndev;
+	struct list_head peers;
+	struct rio_dev **active;
+	int nact;	/* number of active peers */
+};
 
-/*
- * This is a fast lookup table for translating TX
- * Ethernet packets into a destination RIO device. It
- * could be made into a hash table to save memory depending
- * on system trade-offs.
- */
-static struct rio_dev **rionet_active;
-static int nact;	/* total number of active rionet peers */
+static struct rionet_net nets[RIONET_MAX_NETS];
 
 #define is_rionet_capable(src_ops, dst_ops)			\
 			((src_ops & RIO_SRC_OPS_DATA_MSG) &&	\
@@ -185,7 +181,7 @@ static int rionet_start_xmit(struct sk_b
 	}
 
 	if (is_multicast_ether_addr(eth->h_dest))
-		add_num = nact;
+		add_num = nets[rnet->mport->id].nact;
 
 	if ((rnet->tx_cnt + add_num) > RIONET_TX_RING_SIZE) {
 		netif_stop_queue(ndev);
@@ -197,19 +193,21 @@ static int rionet_start_xmit(struct sk_b
 
 	if (is_multicast_ether_addr(eth->h_dest)) {
 		int count = 0;
+
 		for (i = 0; i < RIO_MAX_ROUTE_ENTRIES(rnet->mport->sys_size);
 				i++)
-			if (rionet_active[i]) {
+			if (nets[rnet->mport->id].active[i]) {
 				rionet_queue_tx_msg(skb, ndev,
-						    rionet_active[i]);
+					nets[rnet->mport->id].active[i]);
 				if (count)
 					atomic_inc(&skb->users);
 				count++;
 			}
 	} else if (RIONET_MAC_MATCH(eth->h_dest)) {
 		destid = RIONET_GET_DESTID(eth->h_dest);
-		if (rionet_active[destid])
-			rionet_queue_tx_msg(skb, ndev, rionet_active[destid]);
+		if (nets[rnet->mport->id].active[destid])
+			rionet_queue_tx_msg(skb, ndev,
+					nets[rnet->mport->id].active[destid]);
 	}
 
 	spin_unlock_irqrestore(&rnet->tx_lock, flags);
@@ -228,19 +226,21 @@ static void rionet_dbell_event(struct ri
 		printk(KERN_INFO "%s: doorbell sid %4.4x tid %4.4x info %4.4x",
 		       DRV_NAME, sid, tid, info);
 	if (info == RIONET_DOORBELL_JOIN) {
-		if (!rionet_active[sid]) {
-			list_for_each_entry(peer, &rionet_peers, node) {
+		if (!nets[rnet->mport->id].active[sid]) {
+			list_for_each_entry(peer,
+					   &nets[rnet->mport->id].peers, node) {
 				if (peer->rdev->destid == sid) {
-					rionet_active[sid] = peer->rdev;
-					nact++;
+					nets[rnet->mport->id].active[sid] =
+								peer->rdev;
+					nets[rnet->mport->id].nact++;
 				}
 			}
 			rio_mport_send_doorbell(mport, sid,
 						RIONET_DOORBELL_JOIN);
 		}
 	} else if (info == RIONET_DOORBELL_LEAVE) {
-		rionet_active[sid] = NULL;
-		nact--;
+		nets[rnet->mport->id].active[sid] = NULL;
+		nets[rnet->mport->id].nact--;
 	} else {
 		if (netif_msg_intr(rnet))
 			printk(KERN_WARNING "%s: unhandled doorbell\n",
@@ -334,7 +334,8 @@ static int rionet_open(struct net_device
 	netif_carrier_on(ndev);
 	netif_start_queue(ndev);
 
-	list_for_each_entry_safe(peer, tmp, &rionet_peers, node) {
+	list_for_each_entry_safe(peer, tmp,
+				 &nets[rnet->mport->id].peers, node) {
 		if (!(peer->res = rio_request_outb_dbell(peer->rdev,
 							 RIONET_DOORBELL_JOIN,
 							 RIONET_DOORBELL_LEAVE)))
@@ -359,7 +360,7 @@ static int rionet_close(struct net_devic
 	int i;
 
 	if (netif_msg_ifup(rnet))
-		printk(KERN_INFO "%s: close\n", DRV_NAME);
+		printk(KERN_INFO "%s: close %s\n", DRV_NAME, ndev->name);
 
 	netif_stop_queue(ndev);
 	netif_carrier_off(ndev);
@@ -367,10 +368,11 @@ static int rionet_close(struct net_devic
 	for (i = 0; i < RIONET_RX_RING_SIZE; i++)
 		kfree_skb(rnet->rx_skb[i]);
 
-	list_for_each_entry_safe(peer, tmp, &rionet_peers, node) {
-		if (rionet_active[peer->rdev->destid]) {
+	list_for_each_entry_safe(peer, tmp,
+				 &nets[rnet->mport->id].peers, node) {
+		if (nets[rnet->mport->id].active[peer->rdev->destid]) {
 			rio_send_doorbell(peer->rdev, RIONET_DOORBELL_LEAVE);
-			rionet_active[peer->rdev->destid] = NULL;
+			nets[rnet->mport->id].active[peer->rdev->destid] = NULL;
 		}
 		rio_release_outb_dbell(peer->rdev, peer->res);
 	}
@@ -386,17 +388,21 @@ static int rionet_close(struct net_devic
 static void rionet_remove(struct rio_dev *rdev)
 {
 	struct net_device *ndev = rio_get_drvdata(rdev);
+	unsigned char netid = rdev->net->hport->id;
 	struct rionet_peer *peer, *tmp;
 
-	free_pages((unsigned long)rionet_active, get_order(sizeof(void *) *
-			RIO_MAX_ROUTE_ENTRIES(rdev->net->hport->sys_size)));
 	unregister_netdev(ndev);
-	free_netdev(ndev);
 
-	list_for_each_entry_safe(peer, tmp, &rionet_peers, node) {
+	free_pages((unsigned long)nets[netid].active, get_order(sizeof(void *) *
+			RIO_MAX_ROUTE_ENTRIES(rdev->net->hport->sys_size)));
+	nets[netid].active = NULL;
+
+	list_for_each_entry_safe(peer, tmp, &nets[netid].peers, node) {
 		list_del(&peer->node);
 		kfree(peer);
 	}
+
+	free_netdev(ndev);
 }
 
 static void rionet_get_drvinfo(struct net_device *ndev,
@@ -448,13 +454,13 @@ static int rionet_setup_netdev(struct ri
 	const size_t rionet_active_bytes = sizeof(void *) *
 				RIO_MAX_ROUTE_ENTRIES(mport->sys_size);
 
-	rionet_active = (struct rio_dev **)__get_free_pages(GFP_KERNEL,
-			get_order(rionet_active_bytes));
-	if (!rionet_active) {
+	nets[mport->id].active = (struct rio_dev **)__get_free_pages(GFP_KERNEL,
+						get_order(rionet_active_bytes));
+	if (!nets[mport->id].active) {
 		rc = -ENOMEM;
 		goto out;
 	}
-	memset((void *)rionet_active, 0, rionet_active_bytes);
+	memset((void *)nets[mport->id].active, 0, rionet_active_bytes);
 
 	/* Set up private area */
 	rnet = netdev_priv(ndev);
@@ -483,61 +489,62 @@ static int rionet_setup_netdev(struct ri
 	if (rc != 0)
 		goto out;
 
-	printk("%s: %s %s Version %s, MAC %pM\n",
+	printk(KERN_INFO "%s: %s %s Version %s, MAC %pM, %s\n",
 	       ndev->name,
 	       DRV_NAME,
 	       DRV_DESC,
 	       DRV_VERSION,
-	       ndev->dev_addr);
+	       ndev->dev_addr,
+	       mport->name);
 
       out:
 	return rc;
 }
 
-/*
- * XXX Make multi-net safe
- */
+static unsigned long net_table[RIONET_MAX_NETS/sizeof(unsigned long) + 1];
+
 static int rionet_probe(struct rio_dev *rdev, const struct rio_device_id *id)
 {
 	int rc = -ENODEV;
 	u32 lsrc_ops, ldst_ops;
 	struct rionet_peer *peer;
 	struct net_device *ndev = NULL;
+	unsigned char netid = rdev->net->hport->id;
+	int oldnet;
 
-	/* If local device is not rionet capable, give up quickly */
-	if (!rionet_capable)
-		goto out;
+	if (netid >= RIONET_MAX_NETS)
+		return rc;
 
-	/* Allocate our net_device structure */
-	ndev = alloc_etherdev(sizeof(struct rionet_private));
-	if (ndev == NULL) {
-		rc = -ENOMEM;
-		goto out;
-	}
+	oldnet = test_and_set_bit(netid, net_table);
 
 	/*
 	 * First time through, make sure local device is rionet
-	 * capable, setup netdev,  and set flags so this is skipped
-	 * on later probes
+	 * capable, setup netdev (will be skipped on later probes)
 	 */
-	if (!rionet_check) {
+	if (!oldnet) {
 		rio_local_read_config_32(rdev->net->hport, RIO_SRC_OPS_CAR,
 					 &lsrc_ops);
 		rio_local_read_config_32(rdev->net->hport, RIO_DST_OPS_CAR,
 					 &ldst_ops);
 		if (!is_rionet_capable(lsrc_ops, ldst_ops)) {
 			printk(KERN_ERR
-			       "%s: local device is not network capable\n",
-			       DRV_NAME);
-			rionet_check = 1;
-			rionet_capable = 0;
+			       "%s: local device %s is not network capable\n",
+			       DRV_NAME, rdev->net->hport->name);
 			goto out;
 		}
 
+		/* Allocate our net_device structure */
+		ndev = alloc_etherdev(sizeof(struct rionet_private));
+		if (ndev == NULL) {
+			rc = -ENOMEM;
+			goto out;
+		}
+		nets[netid].ndev = ndev;
 		rc = rionet_setup_netdev(rdev->net->hport, ndev);
-		rionet_check = 1;
-		nact = 0;
-	}
+		INIT_LIST_HEAD(&nets[netid].peers);
+		nets[netid].nact = 0;
+	} else if (nets[netid].ndev == NULL)
+		goto out;
 
 	/*
 	 * If the remote device has mailbox/doorbell capabilities,
@@ -549,10 +556,10 @@ static int rionet_probe(struct rio_dev *
 			goto out;
 		}
 		peer->rdev = rdev;
-		list_add_tail(&peer->node, &rionet_peers);
+		list_add_tail(&peer->node, &nets[netid].peers);
 	}
 
-	rio_set_drvdata(rdev, ndev);
+	rio_set_drvdata(rdev, nets[netid].ndev);
 
       out:
 	return rc;
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

origin.patch
rapidio-rionet-fix-multicast-packet-transmit-logic.patch
rapidio-tsi721-modify-mport-name-assignment.patch
rapidio-fix-kerneldoc-warnings-after-dma-support-was-added.patch
drivers-rapidio-devices-tsi721c-fix-error-return-code.patch
rapidio-add-inbound-memory-mapping-interface.patch
rapidio-tsi721-add-inbound-memory-mapping-callbacks.patch
rapidio-apply-rx-tx-enable-to-active-switch-ports-only.patch
rapidio-fix-blocking-wait-for-discovery-ready.patch
rapidio-use-device-lists-handling-on-per-net-basis.patch
rapidio-run-discovery-as-an-asynchronous-process.patch
rapidio-run-discovery-as-an-asynchronous-process-fix.patch
rapidio-rionet-rework-to-support-multiple-rio-master-ports.patch
rapidio-add-destination-id-allocation-mechanism.patch

