From: akpm@linux-foundation.org
Subject: - plip-use-netif_rx_ni.patch removed from -mm tree
Date: Tue, 27 Nov 2007 12:34:15 -0800
Message-ID: <200711272034.lARKYFri029106@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55526 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756592AbXK0Uhs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 15:37:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mikulas@artax.karlin.mff.cuni.cz, davem@davemloft.net, herbert@gondor.apana.org.au, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     plip: use netif_rx_ni()
has been removed from the -mm tree.  Its filename was
     plip-use-netif_rx_ni.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: plip: use netif_rx_ni()
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>

netif_rx is meant to be called from interrupts because it doesn't wake up
ksoftirqd.  For calling from outside interrupts, netif_rx_ni exists.

This patch fixes plip to use netif_rx_ni.  It fixes the infamous error "NOHZ:
local_softirq_panding 08" that happens on some machines with NOHZ and plip ---
it is caused by the fact that softirq is pending and ksoftirqd is sleeping.

Signed-off-by: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
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

origin.patch
