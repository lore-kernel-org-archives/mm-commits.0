From: akpm@linux-foundation.org
Subject: + dm9000-fix-interface-hang-under-load.patch added to -mm tree
Date: Tue, 21 Aug 2007 12:58:02 -0700
Message-ID: <200708211958.l7LJw3pe008077@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53348 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750787AbXHUT6e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Aug 2007 15:58:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fw@strlen.de


The patch titled
     DM9000: fix interface hang under load
has been added to the -mm tree.  Its filename is
     dm9000-fix-interface-hang-under-load.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: DM9000: fix interface hang under load
From: Florian Westphal <fw@strlen.de>

When transferring data at full speed, the DM9000 network interface
sometimes stops sending/receiving data.  Worse, ksoftirqd consumes 100% cpu
and the net tx watchdog never triggers.  Fix by spin_lock_irqsave() in
dm9000_start_xmit() to prevent the interrupt handler from interfering.

Actually the comments ('Disable all interrupts, iow(db, DM9000_IMR,
IMR_PAR) etc) give the impression that the interrupt handler cannot run
during dm9000_start_xmit(), however this isn't correct (perhaps the chipset
has some weird timing issues?).  The interface lockup usually occurs
between 30 and 360 seconds after starting transmitting data (netcat
/dev/zero) at full speed; with this patch applied I haven't been able to
reproduce hangs yet (ran for > 2h).

FTR: This is a dm9000 on XScale-PXA255 rev 6 (ARMv5TE)/Compulab CM-x255,
i.e.  a module not supported by the vanilla kernel.  Tested on (patched)
2.6.18.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/dm9000.c |   25 +++++++------------------
 1 files changed, 7 insertions(+), 18 deletions(-)

diff -puN drivers/net/dm9000.c~dm9000-fix-interface-hang-under-load drivers/net/dm9000.c
--- a/drivers/net/dm9000.c~dm9000-fix-interface-hang-under-load
+++ a/drivers/net/dm9000.c
@@ -700,6 +700,7 @@ dm9000_init_dm9000(struct net_device *de
 static int
 dm9000_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
+	unsigned long flags;
 	board_info_t *db = (board_info_t *) dev->priv;
 
 	PRINTK3("dm9000_start_xmit\n");
@@ -707,10 +708,7 @@ dm9000_start_xmit(struct sk_buff *skb, s
 	if (db->tx_pkt_cnt > 1)
 		return 1;
 
-	netif_stop_queue(dev);
-
-	/* Disable all interrupts */
-	iow(db, DM9000_IMR, IMR_PAR);
+	spin_lock_irqsave(&db->lock, flags);
 
 	/* Move data to DM9000 TX RAM */
 	writeb(DM9000_MWCMD, db->io_addr);
@@ -718,12 +716,9 @@ dm9000_start_xmit(struct sk_buff *skb, s
 	(db->outblk)(db->io_data, skb->data, skb->len);
 	db->stats.tx_bytes += skb->len;
 
+	db->tx_pkt_cnt++;
 	/* TX control: First packet immediately send, second packet queue */
-	if (db->tx_pkt_cnt == 0) {
-
-		/* First Packet */
-		db->tx_pkt_cnt++;
-
+	if (db->tx_pkt_cnt == 1) {
 		/* Set TX length to DM9000 */
 		iow(db, DM9000_TXPLL, skb->len & 0xff);
 		iow(db, DM9000_TXPLH, (skb->len >> 8) & 0xff);
@@ -732,23 +727,17 @@ dm9000_start_xmit(struct sk_buff *skb, s
 		iow(db, DM9000_TCR, TCR_TXREQ);	/* Cleared after TX complete */
 
 		dev->trans_start = jiffies;	/* save the time stamp */
-
 	} else {
 		/* Second packet */
-		db->tx_pkt_cnt++;
 		db->queue_pkt_len = skb->len;
+		netif_stop_queue(dev);
 	}
 
+	spin_unlock_irqrestore(&db->lock, flags);
+
 	/* free this SKB */
 	dev_kfree_skb(skb);
 
-	/* Re-enable resource check */
-	if (db->tx_pkt_cnt == 1)
-		netif_wake_queue(dev);
-
-	/* Re-enable interrupt */
-	iow(db, DM9000_IMR, IMR_PAR | IMR_PTM | IMR_PRM);
-
 	return 0;
 }
 
_

Patches currently in -mm which might be from fw@strlen.de are

dm9000-fix-interface-hang-under-load.patch
