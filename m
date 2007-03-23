From: akpm@linux-foundation.org
Subject: - 8139too-fix-irq-problem-with-napi-netpoll.patch removed from -mm tree
Date: Thu, 22 Mar 2007 17:02:22 -0800
Message-ID: <200703230102.l2N12NRN002845@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59764 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932664AbXCWBCj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Mar 2007 21:02:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, davem@davemloft.net, jeff@garzik.org, romieu@fr.zoreil.com, mm-commits@vger.kernel.org


The patch titled
     fix irq problem with NAPI + NETPOLL
has been removed from the -mm tree.  Its filename was
     8139too-fix-irq-problem-with-napi-netpoll.patch

This patch was dropped because it was nacked by the maintainer

------------------------------------------------------
Subject: fix irq problem with NAPI + NETPOLL
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

It seems netif_receive_skb() was designed not to call from irq context, but
NAPI + NETPOLL break this rule.  If netif_receive_skb() was called from irq
context, redirect to netif_rx() instead of processing the skb in that
context.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Francois Romieu <romieu@fr.zoreil.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/dev.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN net/core/dev.c~8139too-fix-irq-problem-with-napi-netpoll net/core/dev.c
--- a/net/core/dev.c~8139too-fix-irq-problem-with-napi-netpoll
+++ a/net/core/dev.c
@@ -1759,8 +1759,15 @@ int netif_receive_skb(struct sk_buff *sk
 	__be16 type;
 
 	/* if we've gotten here through NAPI, check netpoll */
-	if (skb->dev->poll && netpoll_rx(skb))
-		return NET_RX_DROP;
+#ifdef CONFIG_NET_POLL_CONTROLLER
+	if (skb->dev->poll && skb->dev->poll_controller) {
+		/* NAPI poll might be called in irq context on NETPOLL */
+		if (in_irq() || irqs_disabled())
+			return netif_rx(skb);
+		if (netpoll_rx(skb))
+			return NET_RX_DROP;
+	}
+#endif
 
 	if (!skb->tstamp.tv64)
 		net_timestamp(skb);
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
git-kbuild.patch
git-netdev-all.patch
8139too-fix-irq-problem-with-napi-netpoll.patch
serial-allocate-minor-device-numbers-for.patch
