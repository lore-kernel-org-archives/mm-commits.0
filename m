From: akpm@linux-foundation.org
Subject: [merged] rapidio-rionet-fix-deadlock-on-smp.patch removed from
 -mm tree
Date: Wed, 23 Mar 2016 10:41:11 -0700
Message-ID: <56f2d537.7IxKQ56Xr5P06HYF%akpm__2479.63283113695$1458754892$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59145 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756338AbcCWRlM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:41:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a-jacquiot@ti.com, alexandre.bounine@idt.com, andre.van.herk@prodrive-technologies.com, mporter@kernel.crashing.org, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/rionet: fix deadlock on SMP
has been removed from the -mm tree.  Its filename was
     rapidio-rionet-fix-deadlock-on-smp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Aurelien Jacquiot <a-jacquiot@ti.com>
Subject: rapidio/rionet: fix deadlock on SMP

Fix deadlocking during concurrent receive and transmit operations on SMP
platforms caused by the use of incorrect lock: on transmit 'tx_lock'
spinlock should be used instead of 'lock' which is used for receive
operation.

This fix is applicable to kernel versions starting from v2.15.

Signed-off-by: Aurelien Jacquiot <a-jacquiot@ti.com>
Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/rionet.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/rionet.c~rapidio-rionet-fix-deadlock-on-smp drivers/net/rionet.c
--- a/drivers/net/rionet.c~rapidio-rionet-fix-deadlock-on-smp
+++ a/drivers/net/rionet.c
@@ -280,7 +280,7 @@ static void rionet_outb_msg_event(struct
 	struct net_device *ndev = dev_id;
 	struct rionet_private *rnet = netdev_priv(ndev);
 
-	spin_lock(&rnet->lock);
+	spin_lock(&rnet->tx_lock);
 
 	if (netif_msg_intr(rnet))
 		printk(KERN_INFO
@@ -299,7 +299,7 @@ static void rionet_outb_msg_event(struct
 	if (rnet->tx_cnt < RIONET_TX_RING_SIZE)
 		netif_wake_queue(ndev);
 
-	spin_unlock(&rnet->lock);
+	spin_unlock(&rnet->tx_lock);
 }
 
 static int rionet_open(struct net_device *ndev)
_

Patches currently in -mm which might be from a-jacquiot@ti.com are


