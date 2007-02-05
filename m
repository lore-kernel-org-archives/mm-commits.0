From: akpm@linux-foundation.org
Subject: - net-smc911x-match-up-spin-lock-unlock.patch removed from -mm tree
Date: Mon, 05 Feb 2007 01:25:18 -0800
Message-ID: <200702050925.l159PIAN016431@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37384 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255AbXBEJ0v (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 04:26:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jacmet@sunsite.dk, jeff@garzik.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     net/smc911x: match up spin lock/unlock
has been removed from the -mm tree.  Its filename was
     net-smc911x-match-up-spin-lock-unlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: net/smc911x: match up spin lock/unlock
From: Peter Korsgaard <jacmet@sunsite.dk>

smc911x_phy_configure's error handling unconditionally unlocks the
spinlock even if it wasn't locked. Patch fixes it.

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/smc911x.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/net/smc911x.c~net-smc911x-match-up-spin-lock-unlock drivers/net/smc911x.c
--- a/drivers/net/smc911x.c~net-smc911x-match-up-spin-lock-unlock
+++ a/drivers/net/smc911x.c
@@ -968,11 +968,11 @@ static void smc911x_phy_configure(struct
 	 * We should not be called if phy_type is zero.
 	 */
 	if (lp->phy_type == 0)
-		 goto smc911x_phy_configure_exit;
+		 goto smc911x_phy_configure_exit_nolock;
 
 	if (smc911x_phy_reset(dev, phyaddr)) {
 		printk("%s: PHY reset timed out\n", dev->name);
-		goto smc911x_phy_configure_exit;
+		goto smc911x_phy_configure_exit_nolock;
 	}
 	spin_lock_irqsave(&lp->lock, flags);
 
@@ -1041,6 +1041,7 @@ static void smc911x_phy_configure(struct
 
 smc911x_phy_configure_exit:
 	spin_unlock_irqrestore(&lp->lock, flags);
+smc911x_phy_configure_exit_nolock:
 	lp->work_pending = 0;
 }
 
_

Patches currently in -mm which might be from jacmet@sunsite.dk are
