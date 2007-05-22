From: akpm@linux-foundation.org
Subject: - declance-remove-a-dangling-spin_unlock_irq-thingy.patch removed from -mm tree
Date: Mon, 21 May 2007 22:56:52 -0700
Message-ID: <200705220556.l4M5up1h028416@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43965 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756497AbXEVGAU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 May 2007 02:00:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macro@linux-mips.org, jeff@garzik.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     declance: remove a dangling spin_unlock_irq() thingy
has been removed from the -mm tree.  Its filename was
     declance-remove-a-dangling-spin_unlock_irq-thingy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: declance: remove a dangling spin_unlock_irq() thingy
From: "Maciej W. Rozycki" <macro@linux-mips.org>

The spin_unlock_irq() invocation in lance_start_xmit() has no matching
locking request.  The call is already protected by netif_tx_lock, so remove
the statement.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/declance.c |    2 --
 1 files changed, 2 deletions(-)

diff -puN drivers/net/declance.c~declance-remove-a-dangling-spin_unlock_irq-thingy drivers/net/declance.c
--- a/drivers/net/declance.c~declance-remove-a-dangling-spin_unlock_irq-thingy
+++ a/drivers/net/declance.c
@@ -932,8 +932,6 @@ static int lance_start_xmit(struct sk_bu
 	/* Kick the lance: transmit now */
 	writereg(&ll->rdp, LE_C0_INEA | LE_C0_TDMD);
 
-	spin_unlock_irq(&lp->lock);
-
 	dev->trans_start = jiffies;
 	dev_kfree_skb(skb);
 
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
