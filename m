From: akpm@linux-foundation.org
Subject: + tg3-debugging.patch added to -mm tree
Date: Thu, 14 Feb 2008 13:33:15 -0800
Message-ID: <200802142133.m1ELXFxJ004035@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46056 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765628AbYBNVeB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 16:34:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mchan@broadcom.com, andy@greyhouse.net, mcarlson@broadcom.com, ralf.hildebrandt@charite.de


The patch titled
     tg3 debugging
has been added to the -mm tree.  Its filename is
     tg3-debugging.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -3324,12 +3324,20 @@ static void tg3_tx(struct tg3 *tp)
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
@@ -3339,7 +3347,7 @@ static void tg3_tx(struct tg3 *tp)
 
 		sw_idx = NEXT_TX(sw_idx);
 
-		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+		for (i = 0; i < nr_frags; i++) {
 			ri = &tp->tx_buffers[sw_idx];
 			if (unlikely(ri->skb != NULL || sw_idx == hw_idx))
 				tx_bug = 1;
@@ -4105,6 +4113,7 @@ static int tigon3_dma_hwbug_workaround(s
 				 len, PCI_DMA_TODEVICE);
 		if (i == 0) {
 			tp->tx_buffers[entry].skb = new_skb;
+			tp->tx_buffers[entry].nr_frags = 0;
 			pci_unmap_addr_set(&tp->tx_buffers[entry], mapping, new_addr);
 		} else {
 			tp->tx_buffers[entry].skb = NULL;
@@ -4211,6 +4220,7 @@ static int tg3_start_xmit(struct sk_buff
 	mapping = pci_map_single(tp->pdev, skb->data, len, PCI_DMA_TODEVICE);
 
 	tp->tx_buffers[entry].skb = skb;
+	tp->tx_buffers[entry].nr_frags = skb_shinfo(skb)->nr_frags;
 	pci_unmap_addr_set(&tp->tx_buffers[entry], mapping, mapping);
 
 	tg3_set_txd(tp, entry, mapping, len, base_flags,
@@ -4388,6 +4398,7 @@ static int tg3_start_xmit_dma_bug(struct
 	mapping = pci_map_single(tp->pdev, skb->data, len, PCI_DMA_TODEVICE);
 
 	tp->tx_buffers[entry].skb = skb;
+	tp->tx_buffers[entry].nr_frags = skb_shinfo(skb)->nr_frags;
 	pci_unmap_addr_set(&tp->tx_buffers[entry], mapping, mapping);
 
 	would_hit_hwbug = 0;
diff -puN drivers/net/tg3.h~tg3-debugging drivers/net/tg3.h
--- a/drivers/net/tg3.h~tg3-debugging
+++ a/drivers/net/tg3.h
@@ -2098,6 +2098,7 @@ struct tx_ring_info {
 	struct sk_buff			*skb;
 	DECLARE_PCI_UNMAP_ADDR(mapping)
 	u32				prev_vlan_tag;
+	unsigned short			nr_frags;
 };
 
 struct tg3_config_info {
_

Patches currently in -mm which might be from mchan@broadcom.com are

tg3-debugging.patch
