From: akpm@linux-foundation.org
Subject: - forcedeth-fixed-missing-call-in-napi-poll.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:52:35 -0800
Message-ID: <200702282352.l1SNqZs4031006@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48257 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932629AbXB1Xwn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:52:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aabdulla@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     forcedeth: fixed missing call in napi poll
has been removed from the -mm tree.  Its filename was
     forcedeth-fixed-missing-call-in-napi-poll.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: forcedeth: fixed missing call in napi poll
From: Ayaz Abdulla <aabdulla@nvidia.com>

The napi poll routine was missing the call to the optimized rx process
routine.  This patch adds the missing call for the optimized path.

Signed-off-by: Ayaz Abdulla <aabdulla@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/forcedeth.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff -puN drivers/net/forcedeth.c~forcedeth-fixed-missing-call-in-napi-poll drivers/net/forcedeth.c
--- a/drivers/net/forcedeth.c~forcedeth-fixed-missing-call-in-napi-poll
+++ a/drivers/net/forcedeth.c
@@ -3104,13 +3104,17 @@ static int nv_napi_poll(struct net_devic
 	struct fe_priv *np = netdev_priv(dev);
 	u8 __iomem *base = get_hwbase(dev);
 	unsigned long flags;
+	u32 retcode;
 
-	if (np->desc_ver == DESC_VER_1 || np->desc_ver == DESC_VER_2)
+	if (np->desc_ver == DESC_VER_1 || np->desc_ver == DESC_VER_2) {
 		pkts = nv_rx_process(dev, limit);
-	else
+		retcode = nv_alloc_rx(dev);
+	} else {
 		pkts = nv_rx_process_optimized(dev, limit);
+		retcode = nv_alloc_rx_optimized(dev);
+	}
 
-	if (nv_alloc_rx(dev)) {
+	if (retcode) {
 		spin_lock_irqsave(&np->lock, flags);
 		if (!np->in_shutdown)
 			mod_timer(&np->oom_kick, jiffies + OOM_REFILL);
_

Patches currently in -mm which might be from aabdulla@nvidia.com are
