From: akpm@linux-foundation.org
Subject: - git-tehuti-vs-git-net.patch removed from -mm tree
Date: Thu, 20 Sep 2007 14:17:05 -0700
Message-ID: <200709202117.l8KLH5RC003054@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35306 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753207AbXITV2k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 17:28:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: baum@tehutinetworks.net, mm-commits@vger.kernel.org


The patch titled
     git-tehuti: fixes for net-2.6.24
has been removed from the -mm tree.  Its filename was
     git-tehuti-vs-git-net.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: git-tehuti: fixes for net-2.6.24
From: "Alexander Indenbaum" <baum@tehutinetworks.net>

Cc: "Alexander Indenbaum" <baum@tehutinetworks.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/tehuti.c |   40 +++++++++++++++++++---------------------
 drivers/net/tehuti.h |    1 +
 2 files changed, 20 insertions(+), 21 deletions(-)

diff -puN drivers/net/tehuti.c~git-tehuti-vs-git-net drivers/net/tehuti.c
--- a/drivers/net/tehuti.c~git-tehuti-vs-git-net
+++ a/drivers/net/tehuti.c
@@ -77,7 +77,7 @@ MODULE_DEVICE_TABLE(pci, bdx_pci_tbl);
 /* Definitions needed by ISR or NAPI functions */
 static void bdx_rx_alloc_skbs(struct bdx_priv *priv, struct rxf_fifo *f);
 static void bdx_tx_cleanup(struct bdx_priv *priv);
-static int bdx_rx_receive(struct bdx_priv *priv, struct rxd_fifo *f, int *budget);
+static int bdx_rx_receive(struct bdx_priv *priv, struct rxd_fifo *f, int budget);
 
 /* Definitions needed by FW loading */
 static void bdx_tx_push_desc_safe(struct bdx_priv *priv, void *data, int size);
@@ -85,6 +85,7 @@ static void bdx_tx_push_desc_safe(struct
 /* Definitions needed by hw_start */
 static int bdx_tx_init(struct bdx_priv *priv);
 static int bdx_rx_init(struct bdx_priv *priv);
+static void bdx_setmulti(struct net_device *ndev);
 
 /* Definitions needed by bdx_close */
 static void bdx_rx_free(struct bdx_priv *priv);
@@ -265,8 +266,8 @@ static irqreturn_t bdx_isr_napi(int irq,
 		bdx_isr_extra(priv, isr);
 
 	if (isr & (IR_RX_DESC_0 | IR_TX_FREE_0)) {
-		if (likely(netif_rx_schedule_prep(ndev))) {
-			__netif_rx_schedule(ndev);
+		if (likely(netif_rx_schedule_prep(ndev, &priv->napi))) {
+			__netif_rx_schedule(ndev, &priv->napi);
 			RET(IRQ_HANDLED);
 		} else {
 			/* NOTE: we get here if intr has slipped into window
@@ -286,24 +287,26 @@ static irqreturn_t bdx_isr_napi(int irq,
 	RET(IRQ_HANDLED);
 }
 
-static int bdx_poll(struct net_device *ndev, int *budget)
+static int bdx_poll(struct napi_struct *napi, int budget)
 {
-	struct bdx_priv *priv = ndev->priv;
+	struct bdx_priv *priv = container_of(napi, struct bdx_priv, napi);
+	struct net_device *ndev = priv->ndev;
+	int work_done = 0;
 	ENTER;
 	bdx_tx_cleanup(priv);
-	if (!bdx_rx_receive(priv, &priv->rxd_fifo0, budget)
-	    || (priv->napi_stop++ >= 30)) {
+	work_done = bdx_rx_receive(priv, &priv->rxd_fifo0, budget);
+	if ((work_done == 0) || (priv->napi_stop++ >= 30)) {
 		DBG("rx poll is done. backing to isr-driven\n");
 
 		/* from time to time we exit to let NAPI layer release
 		 * device lock and allow waiting tasks (eg rmmod) to advance) */
 		priv->napi_stop = 0;
 
-		netif_rx_complete(ndev);
+		netif_rx_complete(ndev, napi);
 		bdx_enable_interrupts(priv);
 		return 0;
 	}
-	return 1;
+	return work_done;
 }
 
 /* bdx_fw_load - loads firmware to NIC
@@ -411,7 +414,7 @@ static int bdx_hw_start(struct bdx_priv 
 		goto err_irq;
 	bdx_enable_interrupts(priv);
 
-	netif_poll_enable(priv->ndev);
+	napi_enable(&priv->napi);
 
 	RET(0);
 
@@ -425,7 +428,7 @@ static void bdx_hw_stop(struct bdx_priv 
 	bdx_disable_interrupts(priv);
 	free_irq(priv->pdev->irq, priv->ndev);
 
-	netif_poll_disable(priv->ndev);
+	napi_disable(&priv->napi);
 	netif_carrier_off(priv->ndev);
 	netif_stop_queue(priv->ndev);
 
@@ -1200,7 +1203,7 @@ static void bdx_recycle_skb(struct bdx_p
 
 /* TBD: replace memcpy func call by explicite inline asm */
 
-static int bdx_rx_receive(struct bdx_priv *priv, struct rxd_fifo *f, int *budget)
+static int bdx_rx_receive(struct bdx_priv *priv, struct rxd_fifo *f, int budget)
 {
 	struct sk_buff *skb, *skb2;
 	struct rxd_desc *rxdd;
@@ -1208,7 +1211,6 @@ static int bdx_rx_receive(struct bdx_pri
 	struct rxf_fifo *rxf_fifo;
 	int tmp_len, size;
 	int done = 0;
-	int max_done = BDX_MAX_RX_DONE;
 	struct rxdb *db = NULL;
 	/* Unmarshalled descriptor - copy of descriptor in host order */
 	u32 rxd_val1;
@@ -1216,7 +1218,6 @@ static int bdx_rx_receive(struct bdx_pri
 	u16 rxd_vlan;
 
 	ENTER;
-	max_done = min(*budget, priv->ndev->quota);
 
 	priv->ndev->last_rx = jiffies;
 	f->m.wptr = READ_REG(priv, f->m.reg_WPTR) & TXF_WPTR_WR_PTR;
@@ -1296,7 +1297,7 @@ static int bdx_rx_receive(struct bdx_pri
 
 		NETIF_RX_MUX(priv, rxd_val1, rxd_vlan, skb);
 
-		if (++done >= max_done)
+		if (++done >= budget)
 			break;
 	}
 
@@ -1307,9 +1308,7 @@ static int bdx_rx_receive(struct bdx_pri
 
 	bdx_rx_alloc_skbs(priv, &priv->rxf_fifo0);
 
-	*budget -= done;
-	priv->ndev->quota -= done;
-	RET(done == max_done);
+	return done;
 }
 
 /*************************************************************************
@@ -1991,8 +1990,6 @@ bdx_probe(struct pci_dev *pdev, const st
 		ndev->vlan_rx_register = bdx_vlan_rx_register;
 		ndev->vlan_rx_add_vid = bdx_vlan_rx_add_vid;
 		ndev->vlan_rx_kill_vid = bdx_vlan_rx_kill_vid;
-		ndev->poll = bdx_poll;
-		ndev->weight = 64;
 
 		bdx_ethtool_ops(ndev);	/* ethtool interface */
 
@@ -2050,12 +2047,13 @@ bdx_probe(struct pci_dev *pdev, const st
 #endif
 		spin_lock_init(&priv->tx_lock);
 
+		netif_napi_add(ndev, &priv->napi, bdx_poll, 64);
+
 		/*bdx_hw_reset(priv); */
 		if (bdx_read_mac(priv)) {
 			printk(KERN_ERR "tehuti: load MAC address failed\n");
 			goto err_out_iomap;
 		}
-		SET_MODULE_OWNER(ndev);
 		SET_NETDEV_DEV(ndev, &pdev->dev);
 		if ((err = register_netdev(ndev))) {
 			printk(KERN_ERR "tehuti: register_netdev failed\n");
diff -puN drivers/net/tehuti.h~git-tehuti-vs-git-net drivers/net/tehuti.h
--- a/drivers/net/tehuti.h~git-tehuti-vs-git-net
+++ a/drivers/net/tehuti.h
@@ -251,6 +251,7 @@ struct bdx_priv {
 	void __iomem *pBdxRegs;
 	struct net_device *ndev;
 
+	struct napi_struct		napi;
 	/* RX FIFOs: 1 for data (full) descs, and 2 for free descs */
 	struct rxd_fifo rxd_fifo0;
 	struct rxf_fifo rxf_fifo0;
_

Patches currently in -mm which might be from baum@tehutinetworks.net are
