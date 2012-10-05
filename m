From: akpm@linux-foundation.org
Subject: [merged] rapidio-rionet-fix-multicast-packet-transmit-logic.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:20:12 -0700
Message-ID: <20121005202012.B5A9B1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:51176 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2JEUUN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:20:13 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so236894ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:20:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, davem@davemloft.net, mporter@kernel.crashing.org, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/rionet: fix multicast packet transmit logic
has been removed from the -mm tree.  Its filename was
     rapidio-rionet-fix-multicast-packet-transmit-logic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio/rionet: fix multicast packet transmit logic

Fix multicast packet transmit logic to account for repetitive transmission
of single skb:
- correct check for available buffers (this bug may produce NULL pointer
  crash dump in case of heavy traffic);
- update skb user count (incorrect user counter causes a warning dump from
  net_tx_action routine during multicast transfers in systems with three or
  more rionet participants).

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/rionet.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff -puN drivers/net/rionet.c~rapidio-rionet-fix-multicast-packet-transmit-logic drivers/net/rionet.c
--- a/drivers/net/rionet.c~rapidio-rionet-fix-multicast-packet-transmit-logic
+++ a/drivers/net/rionet.c
@@ -79,6 +79,7 @@ static int rionet_capable = 1;
  * on system trade-offs.
  */
 static struct rio_dev **rionet_active;
+static int nact;	/* total number of active rionet peers */
 
 #define is_rionet_capable(src_ops, dst_ops)			\
 			((src_ops & RIO_SRC_OPS_DATA_MSG) &&	\
@@ -175,6 +176,7 @@ static int rionet_start_xmit(struct sk_b
 	struct ethhdr *eth = (struct ethhdr *)skb->data;
 	u16 destid;
 	unsigned long flags;
+	int add_num = 1;
 
 	local_irq_save(flags);
 	if (!spin_trylock(&rnet->tx_lock)) {
@@ -182,7 +184,10 @@ static int rionet_start_xmit(struct sk_b
 		return NETDEV_TX_LOCKED;
 	}
 
-	if ((rnet->tx_cnt + 1) > RIONET_TX_RING_SIZE) {
+	if (is_multicast_ether_addr(eth->h_dest))
+		add_num = nact;
+
+	if ((rnet->tx_cnt + add_num) > RIONET_TX_RING_SIZE) {
 		netif_stop_queue(ndev);
 		spin_unlock_irqrestore(&rnet->tx_lock, flags);
 		printk(KERN_ERR "%s: BUG! Tx Ring full when queue awake!\n",
@@ -191,11 +196,16 @@ static int rionet_start_xmit(struct sk_b
 	}
 
 	if (is_multicast_ether_addr(eth->h_dest)) {
+		int count = 0;
 		for (i = 0; i < RIO_MAX_ROUTE_ENTRIES(rnet->mport->sys_size);
 				i++)
-			if (rionet_active[i])
+			if (rionet_active[i]) {
 				rionet_queue_tx_msg(skb, ndev,
 						    rionet_active[i]);
+				if (count)
+					atomic_inc(&skb->users);
+				count++;
+			}
 	} else if (RIONET_MAC_MATCH(eth->h_dest)) {
 		destid = RIONET_GET_DESTID(eth->h_dest);
 		if (rionet_active[destid])
@@ -220,14 +230,17 @@ static void rionet_dbell_event(struct ri
 	if (info == RIONET_DOORBELL_JOIN) {
 		if (!rionet_active[sid]) {
 			list_for_each_entry(peer, &rionet_peers, node) {
-				if (peer->rdev->destid == sid)
+				if (peer->rdev->destid == sid) {
 					rionet_active[sid] = peer->rdev;
+					nact++;
+				}
 			}
 			rio_mport_send_doorbell(mport, sid,
 						RIONET_DOORBELL_JOIN);
 		}
 	} else if (info == RIONET_DOORBELL_LEAVE) {
 		rionet_active[sid] = NULL;
+		nact--;
 	} else {
 		if (netif_msg_intr(rnet))
 			printk(KERN_WARNING "%s: unhandled doorbell\n",
@@ -523,6 +536,7 @@ static int rionet_probe(struct rio_dev *
 
 		rc = rionet_setup_netdev(rdev->net->hport, ndev);
 		rionet_check = 1;
+		nact = 0;
 	}
 
 	/*
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

origin.patch

