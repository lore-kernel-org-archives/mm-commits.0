From: akpm@linux-foundation.org
Subject: + cxgb-fix-napi.patch added to -mm tree
Date: Thu, 29 Nov 2007 12:35:32 -0800
Message-ID: <200711292035.lATKZWQg006192@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47407 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760953AbXK2Ufn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 15:35:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: divy@chelsio.com, jeff@garzik.org


The patch titled
     cxgb: fix NAPI
has been added to the -mm tree.  Its filename is
     cxgb-fix-napi.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
cxgb-fix-t2-gso.patch
cxgb-fix-napi.patch
cxgb-fix-stats.patch
