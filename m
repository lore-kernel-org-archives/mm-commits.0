From: akpm@linux-foundation.org
Subject: - tg3-debugging.patch removed from -mm tree
Date: Thu, 18 Sep 2008 13:40:54 -0700
Message-ID: <200809182040.m8IKesr4018516@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45754 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755271AbYIRUl1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Sep 2008 16:41:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mchan@broadcom.com, andy@greyhouse.net, mcarlson@broadcom.com, ralf.hildebrandt@charite.de, mm-commits@vger.kernel.org


The patch titled
     tg3 debugging
has been removed from the -mm tree.  Its filename was
     tg3-debugging.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tg3 debugging
From: "Michael Chan" <mchan@broadcom.com>

http://bugzilla.kernel.org/show_bug.cgi?id=9990

This patch stores the nr_frags when transmitting an SKB.  During tx
completion, it will compare the stored nr_frags with the one in the SKB and
will print out something in dmesg if they don't match.

Cc: "Andy Gospodarek" <andy@greyhouse.net>
Cc: "Matt Carlson" <mcarlson@broadcom.com>
Cc: <ralf.hildebrandt@charite.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/tg3.c |   13 ++++++++++++-
 drivers/net/tg3.h |    1 +
 2 files changed, 13 insertions(+), 1 deletion(-)

diff -puN drivers/net/tg3.c~tg3-debugging drivers/net/tg3.c
--- a/drivers/net/tg3.c~tg3-debugging
+++ a/drivers/net/tg3.c
@@ -3859,12 +3859,20 @@ static void tg3_tx(struct tg3 *tp)
 		struct tx_ring_info *ri = &tp->tx_buffers[sw_idx];
 		struct sk_buff *skb = ri->skb;
 		int i, tx_bug = 0;
+		unsigned short nr_frags = ri->nr_frags;
 
 		if (unlikely(skb == NULL)) {
 			tg3_tx_recover(tp);
 			return;
 		}
 
+		if (nr_frags != skb_shinfo(skb)->nr_frags) {
+			printk(KERN_ALERT "tg3: %s: Tx skb->nr_frags corrupted "
+				"before skb is freed. Expected nr_frags %d, "
+				"corrupted nr_frags %d\n", tp->dev->name,
+				nr_frags, skb_shinfo(skb)->nr_frags);
+		}
+
 		pci_unmap_single(tp->pdev,
 				 pci_unmap_addr(ri, mapping),
 				 skb_headlen(skb),
@@ -3874,7 +3882,7 @@ static void tg3_tx(struct tg3 *tp)
 
 		sw_idx = NEXT_TX(sw_idx);
 
-		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+		for (i = 0; i < nr_frags; i++) {
 			ri = &tp->tx_buffers[sw_idx];
 			if (unlikely(ri->skb != NULL || sw_idx == hw_idx))
 				tx_bug = 1;
@@ -4667,6 +4675,7 @@ static int tigon3_dma_hwbug_workaround(s
 				 len, PCI_DMA_TODEVICE);
 		if (i == 0) {
 			tp->tx_buffers[entry].skb = new_skb;
+			tp->tx_buffers[entry].nr_frags = 0;
 			pci_unmap_addr_set(&tp->tx_buffers[entry], mapping, new_addr);
 		} else {
 			tp->tx_buffers[entry].skb = NULL;
@@ -4773,6 +4782,7 @@ static int tg3_start_xmit(struct sk_buff
 	mapping = pci_map_single(tp->pdev, skb->data, len, PCI_DMA_TODEVICE);
 
 	tp->tx_buffers[entry].skb = skb;
+	tp->tx_buffers[entry].nr_frags = skb_shinfo(skb)->nr_frags;
 	pci_unmap_addr_set(&tp->tx_buffers[entry], mapping, mapping);
 
 	tg3_set_txd(tp, entry, mapping, len, base_flags,
@@ -4950,6 +4960,7 @@ static int tg3_start_xmit_dma_bug(struct
 	mapping = pci_map_single(tp->pdev, skb->data, len, PCI_DMA_TODEVICE);
 
 	tp->tx_buffers[entry].skb = skb;
+	tp->tx_buffers[entry].nr_frags = skb_shinfo(skb)->nr_frags;
 	pci_unmap_addr_set(&tp->tx_buffers[entry], mapping, mapping);
 
 	would_hit_hwbug = 0;
diff -puN drivers/net/tg3.h~tg3-debugging drivers/net/tg3.h
--- a/drivers/net/tg3.h~tg3-debugging
+++ a/drivers/net/tg3.h
@@ -2199,6 +2199,7 @@ struct tx_ring_info {
 	struct sk_buff			*skb;
 	DECLARE_PCI_UNMAP_ADDR(mapping)
 	u32				prev_vlan_tag;
+	unsigned short			nr_frags;
 };
 
 struct tg3_config_info {
_

Patches currently in -mm which might be from mchan@broadcom.com are

bnx2-promote-vector-field-in-bnx2_irq-structure-from-u16-to-unsigned-int.patch
tg3-debugging.patch

