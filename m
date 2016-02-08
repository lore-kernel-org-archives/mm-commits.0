From: akpm@linux-foundation.org
Subject: + rapidio-rionet-fix-deadlock-on-smp.patch added to -mm tree
Date: Mon, 08 Feb 2016 13:21:54 -0800
Message-ID: <56b906f2.arpwJwdyGAMP5H10%akpm__1393.76747324622$1454966527$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35719 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682AbcBHVVz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2016 16:21:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a-jacquiot@ti.com, alexandre.bounine@idt.com, andre.van.herk@prodrive-technologies.com, mporter@kernel.crashing.org, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/rionet: fix deadlock on SMP
has been added to the -mm tree.  Its filename is
     rapidio-rionet-fix-deadlock-on-smp.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-rionet-fix-deadlock-on-smp.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-rionet-fix-deadlock-on-smp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

rapidio-rionet-fix-deadlock-on-smp.patch
rapidio-rionet-add-capability-to-change-mtu.patch

