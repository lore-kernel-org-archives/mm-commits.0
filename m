From: akpm@linux-foundation.org
Subject: - cxgb-fix-napi.patch removed from -mm tree
Date: Mon, 03 Dec 2007 23:38:25 -0800
Message-ID: <200712040738.lB47cPcD006896@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46963 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751882AbXLDHtU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 02:49:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: divy@chelsio.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     cxgb: fix NAPI
has been removed from the -mm tree.  Its filename was
     cxgb-fix-napi.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cxgb: fix NAPI
From: Divy Le Ray <divy@chelsio.com>

netif_rx_complete() should be called only when work_done < budget.

Signed-off-by: Divy Le ray <divy@chelsio.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/chelsio/sge.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/net/chelsio/sge.c~cxgb-fix-napi drivers/net/chelsio/sge.c
--- a/drivers/net/chelsio/sge.c~cxgb-fix-napi
+++ a/drivers/net/chelsio/sge.c
@@ -1629,11 +1629,9 @@ int t1_poll(struct napi_struct *napi, in
 {
 	struct adapter *adapter = container_of(napi, struct adapter, napi);
 	struct net_device *dev = adapter->port[0].dev;
-	int work_done;
-
-	work_done = process_responses(adapter, budget);
+	int work_done = process_responses(adapter, budget);
 
-	if (likely(!responses_pending(adapter))) {
+	if (likely(work_done < budget)) {
 		netif_rx_complete(dev, napi);
 		writel(adapter->sge->respQ.cidx,
 		       adapter->regs + A_SG_SLEEPING);
_

Patches currently in -mm which might be from divy@chelsio.com are

git-netdev-all.patch
