From: akpm@linux-foundation.org
Subject: + netpoll-tx-lock-deadlock-fix.patch added to -mm tree
Date: Wed, 30 May 2007 11:29:00 -0700
Message-ID: <200705301829.l4UIT0T5001688@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:41766 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753869AbXE3S3d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 May 2007 14:29:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shemminger@linux-foundation.org, shemminger@linux.foundation.org


The patch titled
     netpoll: tx lock deadlock fix
has been added to the -mm tree.  Its filename is
     netpoll-tx-lock-deadlock-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

touchscreen-fujitsu-touchscreen-driver.patch
netpoll-tx-lock-deadlock-fix.patch
git-r8169.patch
git-wireless.patch
pci-x-pci-express-read-control-interfaces-myrinet.patch
pci-x-pci-express-read-control-interfaces-mthca.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
pci-x-pci-express-read-control-interfaces-qla2xxx.patch
