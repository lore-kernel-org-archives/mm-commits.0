From: akpm@linux-foundation.org
Subject: [merged] aoe-print-warning-regarding-a-common-reason-for-dropped-transmits.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:09:38 -0800
Message-ID: <20121218200939.1B414200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f201.google.com ([209.85.212.201]:59048 "EHLO
	mail-wi0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262Ab2LRUJl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:09:41 -0500
Received: by mail-wi0-f201.google.com with SMTP id hm2so63391wib.4
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:09:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, dan.carpenter@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: print warning regarding a common reason for dropped transmits
has been removed from the -mm tree.  Its filename was
     aoe-print-warning-regarding-a-common-reason-for-dropped-transmits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: print warning regarding a common reason for dropped transmits

Dropped transmits are not common, but when they do occur, increasing
the transmit queue length often helps.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoenet.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN drivers/block/aoe/aoenet.c~aoe-print-warning-regarding-a-common-reason-for-dropped-transmits drivers/block/aoe/aoenet.c
--- a/drivers/block/aoe/aoenet.c~aoe-print-warning-regarding-a-common-reason-for-dropped-transmits
+++ a/drivers/block/aoe/aoenet.c
@@ -52,13 +52,18 @@ static struct sk_buff_head skbtxq;
 
 /* enters with txlock held */
 static int
-tx(void)
+tx(void) __must_hold(&txlock)
 {
 	struct sk_buff *skb;
+	struct net_device *ifp;
 
 	while ((skb = skb_dequeue(&skbtxq))) {
 		spin_unlock_irq(&txlock);
-		dev_queue_xmit(skb);
+		ifp = skb->dev;
+		if (dev_queue_xmit(skb) == NET_XMIT_DROP && net_ratelimit())
+			pr_warn("aoe: packet could not be sent on %s.  %s\n",
+				ifp ? ifp->name : "netif",
+				"consider increasing tx_queue_len");
 		spin_lock_irq(&txlock);
 	}
 	return 0;
_

Patches currently in -mm which might be from ecashin@coraid.com are

origin.patch
linux-next.patch

