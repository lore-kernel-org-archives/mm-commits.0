From: akpm@linux-foundation.org
Subject: - wan-add-missing-skb-dev-assignment-in-frame-relay-rx-code-cleanup.patch removed from -mm tree
Date: Sun, 29 Jun 2008 16:59:41 -0700
Message-ID: <200806292359.m5TNxgff012066@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51195 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751941AbYF3AAb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jun 2008 20:00:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@vyatta.com, acme@redhat.com, davem@davemloft.net, jeff@garzik.org, khc@pm.waw.pl, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     wan-add-missing-skb-dev-assignment-in-frame-relay-rx-code cleanup
has been removed from the -mm tree.  Its filename was
     wan-add-missing-skb-dev-assignment-in-frame-relay-rx-code-cleanup.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: wan-add-missing-skb-dev-assignment-in-frame-relay-rx-code cleanup
From: Stephen Hemminger <shemminger@vyatta.com>

Better to use netdev_alloc_skb for receive buffers instead.

Cc: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wan/hdlc_fr.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/net/wan/hdlc_fr.c~wan-add-missing-skb-dev-assignment-in-frame-relay-rx-code-cleanup drivers/net/wan/hdlc_fr.c
--- a/drivers/net/wan/hdlc_fr.c~wan-add-missing-skb-dev-assignment-in-frame-relay-rx-code-cleanup
+++ a/drivers/net/wan/hdlc_fr.c
@@ -515,7 +515,7 @@ static void fr_lmi_send(struct net_devic
 		}
 	}
 
-	skb = dev_alloc_skb(len);
+	skb = netdev_alloc_skb(dev, len);
 	if (!skb) {
 		printk(KERN_WARNING "%s: Memory squeeze on fr_lmi_send()\n",
 		       dev->name);
@@ -1008,7 +1008,6 @@ static int fr_rx(struct sk_buff *skb)
 		stats->rx_bytes += skb->len;
 		if (pvc->state.becn)
 			stats->rx_compressed++;
-		skb->dev = dev;
 		netif_rx(skb);
 		return NET_RX_SUCCESS;
 	} else {
_

Patches currently in -mm which might be from shemminger@vyatta.com are

origin.patch
wan-add-missing-skb-dev-assignment-in-frame-relay-rx-code-cleanup.patch
sysctl-allow-override-of-proc-sys-net-with-cap_net_admin.patch

