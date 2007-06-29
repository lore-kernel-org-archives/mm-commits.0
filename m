From: akpm@linux-foundation.org
Subject: - netpoll-tx-lock-deadlock-fix.patch removed from -mm tree
Date: Fri, 29 Jun 2007 13:41:37 -0700
Message-ID: <200706292041.l5TKfbDm022590@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35505 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751803AbXF2UqC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Jun 2007 16:46:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@linux-foundation.org, shemminger@linux.foundation.org, mm-commits@vger.kernel.org


The patch titled
     netpoll: tx lock deadlock fix
has been removed from the -mm tree.  Its filename was
     netpoll-tx-lock-deadlock-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: netpoll: tx lock deadlock fix
From: Stephen Hemminger <shemminger@linux-foundation.org>

If sky2 device poll routine is called from netpoll_send_skb, it would
deadlock.  The netpoll_send_skb held the netif_tx_lock, and the poll
routine could acquire it to clean up skb's.  Other drivers might use same
locking model.

The driver is correct, netpoll should not introduce more locking problems
than it causes already.  So change the code to drop lock before calling
poll handler.

Signed-off-by: Stephen Hemminger <shemminger@linux.foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/netpoll.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff -puN net/core/netpoll.c~netpoll-tx-lock-deadlock-fix net/core/netpoll.c
--- a/net/core/netpoll.c~netpoll-tx-lock-deadlock-fix
+++ a/net/core/netpoll.c
@@ -250,22 +250,23 @@ static void netpoll_send_skb(struct netp
 		unsigned long flags;
 
 		local_irq_save(flags);
-		if (netif_tx_trylock(dev)) {
-			/* try until next clock tick */
-			for (tries = jiffies_to_usecs(1)/USEC_PER_POLL;
-					tries > 0; --tries) {
+		/* try until next clock tick */
+		for (tries = jiffies_to_usecs(1)/USEC_PER_POLL;
+		     tries > 0; --tries) {
+			if (netif_tx_trylock(dev)) {
 				if (!netif_queue_stopped(dev))
 					status = dev->hard_start_xmit(skb, dev);
+				netif_tx_unlock(dev);
 
 				if (status == NETDEV_TX_OK)
 					break;
 
-				/* tickle device maybe there is some cleanup */
-				netpoll_poll(np);
-
-				udelay(USEC_PER_POLL);
 			}
-			netif_tx_unlock(dev);
+
+			/* tickle device maybe there is some cleanup */
+			netpoll_poll(np);
+
+			udelay(USEC_PER_POLL);
 		}
 		local_irq_restore(flags);
 	}
_

Patches currently in -mm which might be from shemminger@linux-foundation.org are

origin.patch
touchscreen-fujitsu-touchscreen-driver.patch
git-netdev-all.patch
git-net.patch
git-r8169.patch
pci-x-pci-express-read-control-interfaces-myrinet.patch
pci-x-pci-express-read-control-interfaces-mthca.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
pci-x-pci-express-read-control-interfaces-qla2xxx.patch
pci-x-pci-express-read-control-interfaces-qla2xxx-fix.patch
