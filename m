From: akpm@linux-foundation.org
Subject: + plip-use-netif_rx_ni.patch added to -mm tree
Date: Mon, 26 Nov 2007 21:36:25 -0800
Message-ID: <200711270536.lAR5aPNs029306@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41140 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751235AbXK0FhG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 00:37:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mikulas@artax.karlin.mff.cuni.cz, davem@davemloft.net, herbert@gondor.apana.org.au, jeff@garzik.org


The patch titled
     plip: use netif_rx_ni()
has been added to the -mm tree.  Its filename is
     plip-use-netif_rx_ni.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: plip: use netif_rx_ni()
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>

netif_rx is meant to be called from interrupts because it doesn't wake up
ksoftirqd.  For calling from outside interrupts, netif_rx_ni exists.

This patch fixes plip to use netif_rx_ni.  It fixes the infamous error
"NOHZ: local_softirq_panding 08" that happens on some machines with NOHZ
and plip --- it is caused by the fact that softirq is pending and ksoftirqd
is sleeping.

Signed-off-by: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/plip.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/plip.c~plip-use-netif_rx_ni drivers/net/plip.c
--- a/drivers/net/plip.c~plip-use-netif_rx_ni
+++ a/drivers/net/plip.c
@@ -663,7 +663,7 @@ plip_receive_packet(struct net_device *d
 	case PLIP_PK_DONE:
 		/* Inform the upper layer for the arrival of a packet. */
 		rcv->skb->protocol=plip_type_trans(rcv->skb, dev);
-		netif_rx(rcv->skb);
+		netif_rx_ni(rcv->skb);
 		dev->last_rx = jiffies;
 		dev->stats.rx_bytes += rcv->length.h;
 		dev->stats.rx_packets++;
_

Patches currently in -mm which might be from mikulas@artax.karlin.mff.cuni.cz are

plip-use-netif_rx_ni.patch
fix-plip-2.patch
