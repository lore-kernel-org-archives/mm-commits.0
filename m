From: akpm@linux-foundation.org
Subject: + netconsole-fix-soft-lockup-when-removing-module.patch added to -mm tree
Date: Tue, 26 Jun 2007 17:59:46 -0700
Message-ID: <200706270059.l5R0xkw0006840@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51954 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751114AbXF0BA0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 21:00:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jarkao2@o2.pl


The patch titled
     netconsole: fix soft lockup when removing module
has been added to the -mm tree.  Its filename is
     netconsole-fix-soft-lockup-when-removing-module.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: netconsole: fix soft lockup when removing module
From: Jarek Poplawski <jarkao2@o2.pl>

Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/netpoll.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN net/core/netpoll.c~netconsole-fix-soft-lockup-when-removing-module net/core/netpoll.c
--- a/net/core/netpoll.c~netconsole-fix-soft-lockup-when-removing-module
+++ a/net/core/netpoll.c
@@ -72,7 +72,8 @@ static void queue_process(struct work_st
 			netif_tx_unlock(dev);
 			local_irq_restore(flags);
 
-			schedule_delayed_work(&npinfo->tx_work, HZ/10);
+			if (atomic_read(&npinfo->refcnt))
+				schedule_delayed_work(&npinfo->tx_work, HZ/10);
 			return;
 		}
 		netif_tx_unlock(dev);
@@ -785,9 +786,15 @@ void netpoll_cleanup(struct netpoll *np)
 			if (atomic_dec_and_test(&npinfo->refcnt)) {
 				skb_queue_purge(&npinfo->arp_tx);
 				skb_queue_purge(&npinfo->txq);
-				cancel_rearming_delayed_work(&npinfo->tx_work);
+				cancel_delayed_work(&npinfo->tx_work);
 				flush_scheduled_work();
 
+				/* clean after last, unfinished work */
+				if (!skb_queue_empty(&npinfo->txq)) {
+					struct sk_buff *skb;
+					skb = __skb_dequeue(&npinfo->txq);
+					kfree_skb(skb);
+				}
 				kfree(npinfo);
 			}
 		}
_

Patches currently in -mm which might be from jarkao2@o2.pl are

netconsole-fix-soft-lockup-when-removing-module.patch
