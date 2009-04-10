From: akpm@linux-foundation.org
Subject: + skge-fix-occasional-bug-during-mtu-change.patch added to -mm tree
Date: Thu, 09 Apr 2009 21:59:10 -0700
Message-ID: <200904100459.n3A4xAQl032058@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59450 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752506AbZDJFA3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 01:00:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mschmidt@redhat.com


The patch titled
     skge: fix occasional BUG during MTU change
has been added to the -mm tree.  Its filename is
     skge-fix-occasional-bug-during-mtu-change.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: skge: fix occasional BUG during MTU change
From: Michal Schmidt <mschmidt@redhat.com>

The BUG_ON(skge->tx_ring.to_use != skge->tx_ring.to_clean) in skge_up()
was sometimes observed when setting MTU.

skge_down() disables the TX queue, but then reenables it by mistake via
skge_tx_clean().

Fix it by moving the waking of the queue from skge_tx_clean() to the other
caller.  And to make sure start_xmit is not in progress on another CPU,
skge_down() should call netif_tx_disable().

The bug was reported to me by Jiri Jilek whose Debian system sometimes
failed to boot.  He tested the patch and the bug did not happen anymore.

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/skge.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/skge.c~skge-fix-occasional-bug-during-mtu-change drivers/net/skge.c
--- a/drivers/net/skge.c~skge-fix-occasional-bug-during-mtu-change
+++ a/drivers/net/skge.c
@@ -2674,7 +2674,7 @@ static int skge_down(struct net_device *
 	if (netif_msg_ifdown(skge))
 		printk(KERN_INFO PFX "%s: disabling interface\n", dev->name);
 
-	netif_stop_queue(dev);
+	netif_tx_disable(dev);
 
 	if (hw->chip_id == CHIP_ID_GENESIS && hw->phy_type == SK_PHY_XMAC)
 		del_timer_sync(&skge->link_timer);
@@ -2881,7 +2881,6 @@ static void skge_tx_clean(struct net_dev
 	}
 
 	skge->tx_ring.to_clean = e;
-	netif_wake_queue(dev);
 }
 
 static void skge_tx_timeout(struct net_device *dev)
@@ -2893,6 +2892,7 @@ static void skge_tx_timeout(struct net_d
 
 	skge_write8(skge->hw, Q_ADDR(txqaddr[skge->port], Q_CSR), CSR_STOP);
 	skge_tx_clean(dev);
+	netif_wake_queue(dev);
 }
 
 static int skge_change_mtu(struct net_device *dev, int new_mtu)
_

Patches currently in -mm which might be from mschmidt@redhat.com are

skge-fix-occasional-bug-during-mtu-change.patch

