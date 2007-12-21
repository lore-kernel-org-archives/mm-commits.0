From: akpm@linux-foundation.org
Subject: - netdev-remove-netif_running-check-from-myri10ge_poll.patch removed from -mm tree
Date: Thu, 20 Dec 2007 16:56:03 -0800
Message-ID: <200712210056.lBL0u3Kc022107@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59053 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756183AbXLUA4s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Dec 2007 19:56:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gallatin@myri.com, davem@davemloft.net, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     netdev: remove netif_running() check from myri10ge_poll()
has been removed from the -mm tree.  Its filename was
     netdev-remove-netif_running-check-from-myri10ge_poll.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: netdev: remove netif_running() check from myri10ge_poll()
From: Andrew Gallatin <gallatin@myri.com>

Remove the bogus netif_running() check from myri10ge_poll().

This eliminates any chance that myri10ge_poll() can trigger an oops by
calling netif_rx_complete() and returning with work_done == budget.

Signed-off-by: Andrew Gallatin <gallatin@myri.com>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/myri10ge/myri10ge.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/myri10ge/myri10ge.c~netdev-remove-netif_running-check-from-myri10ge_poll drivers/net/myri10ge/myri10ge.c
--- a/drivers/net/myri10ge/myri10ge.c~netdev-remove-netif_running-check-from-myri10ge_poll
+++ a/drivers/net/myri10ge/myri10ge.c
@@ -1239,7 +1239,7 @@ static int myri10ge_poll(struct napi_str
 	/* process as many rx events as NAPI will allow */
 	work_done = myri10ge_clean_rx_done(mgp, budget);
 
-	if (work_done < budget || !netif_running(netdev)) {
+	if (work_done < budget) {
 		netif_rx_complete(netdev, napi);
 		put_be32(htonl(3), mgp->irq_claim);
 	}
_

Patches currently in -mm which might be from gallatin@myri.com are

git-net.patch
netdev-remove-netif_running-check-from-myri10ge_poll.patch
