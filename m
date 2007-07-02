From: akpm@linux-foundation.org
Subject: - netconsole-fix-soft-lockup-when-removing-module.patch removed from -mm tree
Date: Mon, 02 Jul 2007 13:17:08 -0700
Message-ID: <200707022017.l62KH8Me004843@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48853 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754565AbXGBUSF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Jul 2007 16:18:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jarkao2@o2.pl, jason.wessel@windriver.com, mm-commits@vger.kernel.org


The patch titled
     netconsole: fix soft lockup when removing module
has been removed from the -mm tree.  Its filename was
     netconsole-fix-soft-lockup-when-removing-module.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: netconsole: fix soft lockup when removing module
From: Jarek Poplawski <jarkao2@o2.pl>

#1
Until kernel ver. 2.6.21 (including) cancel_rearming_delayed_work()
required a work function should always (unconditionally) rearm with
delay > 0 - otherwise it would endlessly loop. This patch replaces
this function with cancel_delayed_work(). Later kernel versions don't
require this, so here it's only for uniformity.

#2
After deleting a timer in cancel_[rearming_]delayed_work() there could
stay a last skb queued in npinfo->txq causing a memory leak after
kfree(npinfo).

Initial patch & testing by: Jason Wessel <jason.wessel@windriver.com>

Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/netpoll.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

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
@@ -784,9 +785,15 @@ void netpoll_cleanup(struct netpoll *np)
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

gen_estimator-fix-locking-and-timer-related-bugs.patch
