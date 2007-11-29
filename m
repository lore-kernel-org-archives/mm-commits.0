From: akpm@linux-foundation.org
Subject: + cxgb-fix-t2-gso.patch added to -mm tree
Date: Thu, 29 Nov 2007 12:35:51 -0800
Message-ID: <200711292035.lATKZpv4006198@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58045 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757719AbXK2Uf6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 15:35:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: divy@chelsio.com, jeff@garzik.org


The patch titled
     cxgb: fix T2 GSO
has been added to the -mm tree.  Its filename is
     cxgb-fix-t2-gso.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cxgb: fix T2 GSO
From: Divy Le Ray <divy@chelsio.com>

The patch ensures that a GSO skb has enough headroom to push an encapsulating
cpl_tx_pkt_lso header.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/chelsio/cxgb2.c |    1 +
 drivers/net/chelsio/sge.c   |   34 +++++++++++++++-------------------
 drivers/net/chelsio/sge.h   |    1 +
 3 files changed, 17 insertions(+), 19 deletions(-)

diff -puN drivers/net/chelsio/cxgb2.c~cxgb-fix-t2-gso drivers/net/chelsio/cxgb2.c
--- a/drivers/net/chelsio/cxgb2.c~cxgb-fix-t2-gso
+++ a/drivers/net/chelsio/cxgb2.c
@@ -401,6 +401,7 @@ static char stats_strings[][ETH_GSTRING_
 	"TxTso",
 	"RxVlan",
 	"TxVlan",
+	"TxNeedHeadroom",
 
 	/* Interrupt stats */
 	"rx drops",
diff -puN drivers/net/chelsio/sge.c~cxgb-fix-t2-gso drivers/net/chelsio/sge.c
--- a/drivers/net/chelsio/sge.c~cxgb-fix-t2-gso
+++ a/drivers/net/chelsio/sge.c
@@ -995,6 +995,7 @@ void t1_sge_get_port_stats(const struct 
 		ss->tx_packets += st->tx_packets;
 		ss->tx_cso += st->tx_cso;
 		ss->tx_tso += st->tx_tso;
+		ss->tx_need_hdrroom += st->tx_need_hdrroom;
 		ss->vlan_xtract += st->vlan_xtract;
 		ss->vlan_insert += st->vlan_insert;
 	}
@@ -1852,7 +1853,8 @@ int t1_start_xmit(struct sk_buff *skb, s
 {
 	struct adapter *adapter = dev->priv;
 	struct sge *sge = adapter->sge;
-	struct sge_port_stats *st = per_cpu_ptr(sge->port_stats[dev->if_port], smp_processor_id());
+	struct sge_port_stats *st = per_cpu_ptr(sge->port_stats[dev->if_port],
+						smp_processor_id());
 	struct cpl_tx_pkt *cpl;
 	struct sk_buff *orig_skb = skb;
 	int ret;
@@ -1860,6 +1862,18 @@ int t1_start_xmit(struct sk_buff *skb, s
 	if (skb->protocol == htons(ETH_P_CPL5))
 		goto send;
 
+	/*
+	 * We are using a non-standard hard_header_len.
+	 * Allocate more header room in the rare cases it is not big enough.
+	 */
+	if (unlikely(skb_headroom(skb) < dev->hard_header_len - ETH_HLEN)) {
+		skb = skb_realloc_headroom(skb, sizeof(struct cpl_tx_pkt_lso));
+		++st->tx_need_hdrroom;
+		dev_kfree_skb_any(orig_skb);
+		if (!skb)
+			return NETDEV_TX_OK;
+	}
+
 	if (skb_shinfo(skb)->gso_size) {
 		int eth_type;
 		struct cpl_tx_pkt_lso *hdr;
@@ -1893,24 +1907,6 @@ int t1_start_xmit(struct sk_buff *skb, s
 			return NETDEV_TX_OK;
 		}
 
-		/*
-		 * We are using a non-standard hard_header_len and some kernel
-		 * components, such as pktgen, do not handle it right.
-		 * Complain when this happens but try to fix things up.
-		 */
-		if (unlikely(skb_headroom(skb) < dev->hard_header_len - ETH_HLEN)) {
-			pr_debug("%s: headroom %d header_len %d\n", dev->name,
-				 skb_headroom(skb), dev->hard_header_len);
-
-			if (net_ratelimit())
-				printk(KERN_ERR "%s: inadequate headroom in "
-				       "Tx packet\n", dev->name);
-			skb = skb_realloc_headroom(skb, sizeof(*cpl));
-			dev_kfree_skb_any(orig_skb);
-			if (!skb)
-				return NETDEV_TX_OK;
-		}
-
 		if (!(adapter->flags & UDP_CSUM_CAPABLE) &&
 		    skb->ip_summed == CHECKSUM_PARTIAL &&
 		    ip_hdr(skb)->protocol == IPPROTO_UDP) {
diff -puN drivers/net/chelsio/sge.h~cxgb-fix-t2-gso drivers/net/chelsio/sge.h
--- a/drivers/net/chelsio/sge.h~cxgb-fix-t2-gso
+++ a/drivers/net/chelsio/sge.h
@@ -64,6 +64,7 @@ struct sge_port_stats {
 	u64 tx_tso;          /* # of TSO requests */
 	u64 vlan_xtract;     /* # of VLAN tag extractions */
 	u64 vlan_insert;     /* # of VLAN tag insertions */
+	u64 tx_need_hdrroom; /* # of TX skbs in need of more header room */
 };
 
 struct sk_buff;
_

Patches currently in -mm which might be from divy@chelsio.com are

git-netdev-all.patch
cxgb-fix-t2-gso.patch
cxgb-fix-napi.patch
cxgb-fix-stats.patch
