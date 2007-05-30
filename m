From: akpm@linux-foundation.org
Subject: - fix-soft-lockup-when-removing-netconsole-module.patch removed from -mm tree
Date: Wed, 30 May 2007 15:45:05 -0700
Message-ID: <200705302245.l4UMj6bb007049@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:42043 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751370AbXE3WpQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 May 2007 18:45:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jason.wessel@windriver.com, davem@davemloft.net, shemminger@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     fix soft lockup when removing netconsole module
has been removed from the -mm tree.  Its filename was
     fix-soft-lockup-when-removing-netconsole-module.patch

This patch was dropped because it's unneeded in 2.6.22

------------------------------------------------------
Subject: fix soft lockup when removing netconsole module
From: Jason Wessel <jason.wessel@windriver.com>

The netpoll_cleanup handler can hang the kernel if there is no work in the
work queue because a call to cancel_rearming_delayed_work() with no work
goes into an infinite loop.

The typical case where this is a problem is on removing a kernel module
such as the netconsole driver or kgdboe.

To maintain 80 column code, the function had to have one level of braces
dropped.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Cc: Stephen Hemminger <shemminger@osdl.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/netpoll.c |   36 +++++++++++++++++++-----------------
 1 files changed, 19 insertions(+), 17 deletions(-)

diff -puN net/core/netpoll.c~fix-soft-lockup-when-removing-netconsole-module net/core/netpoll.c
--- a/net/core/netpoll.c~fix-soft-lockup-when-removing-netconsole-module
+++ a/net/core/netpoll.c
@@ -771,30 +771,32 @@ void netpoll_cleanup(struct netpoll *np)
 	struct netpoll_info *npinfo;
 	unsigned long flags;
 
-	if (np->dev) {
-		npinfo = np->dev->npinfo;
-		if (npinfo) {
-			if (npinfo->rx_np == np) {
-				spin_lock_irqsave(&npinfo->rx_lock, flags);
-				npinfo->rx_np = NULL;
-				npinfo->rx_flags &= ~NETPOLL_RX_ENABLED;
-				spin_unlock_irqrestore(&npinfo->rx_lock, flags);
-			}
+	if (!np->dev)
+		return;
+
+	npinfo = np->dev->npinfo;
+	if (npinfo) {
+		if (npinfo->rx_np == np) {
+			spin_lock_irqsave(&npinfo->rx_lock, flags);
+			npinfo->rx_np = NULL;
+			npinfo->rx_flags &= ~NETPOLL_RX_ENABLED;
+			spin_unlock_irqrestore(&npinfo->rx_lock, flags);
+		}
 
-			np->dev->npinfo = NULL;
-			if (atomic_dec_and_test(&npinfo->refcnt)) {
-				skb_queue_purge(&npinfo->arp_tx);
-				skb_queue_purge(&npinfo->txq);
+		np->dev->npinfo = NULL;
+		if (atomic_dec_and_test(&npinfo->refcnt)) {
+			skb_queue_purge(&npinfo->arp_tx);
+			skb_queue_purge(&npinfo->txq);
+			if (delayed_work_pending(&npinfo->tx_work)) {
 				cancel_rearming_delayed_work(&npinfo->tx_work);
 				flush_scheduled_work();
-
-				kfree(npinfo);
 			}
-		}
 
-		dev_put(np->dev);
+			kfree(npinfo);
+		}
 	}
 
+	dev_put(np->dev);
 	np->dev = NULL;
 }
 
_

Patches currently in -mm which might be from jason.wessel@windriver.com are

fix-soft-lockup-when-removing-netconsole-module.patch
