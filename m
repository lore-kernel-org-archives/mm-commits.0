From: akpm@linux-foundation.org
Subject: - e1000-fix-stop-raw-interrupts-disabled-nag-from-rt.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:58:53 -0800
Message-ID: <200703152158.l2FLwrkX027767@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42520 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbXCOV7E (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 17:59:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhuth@mvista.com, auke-jan.h.kok@intel.com, mm-commits@vger.kernel.org


The patch titled
     e1000: FIX: Stop raw interrupts disabled nag from RT
has been removed from the -mm tree.  Its filename was
     e1000-fix-stop-raw-interrupts-disabled-nag-from-rt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: e1000: FIX: Stop raw interrupts disabled nag from RT
From: Mark Huth <mhuth@mvista.com>

Current e1000_xmit_frame spews raw interrupt disabled nag messages when used
with RT kernel patches.  This patch uses spin_trylock_irqsave, which allows RT
patches to properly manage the irq semantics.

Signed-off-by: Mark Huth <mhuth@mvista.com>
Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e1000/e1000_main.c |    5 +----
 1 files changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/net/e1000/e1000_main.c~e1000-fix-stop-raw-interrupts-disabled-nag-from-rt drivers/net/e1000/e1000_main.c
--- a/drivers/net/e1000/e1000_main.c~e1000-fix-stop-raw-interrupts-disabled-nag-from-rt
+++ a/drivers/net/e1000/e1000_main.c
@@ -3378,12 +3378,9 @@ e1000_xmit_frame(struct sk_buff *skb, st
 	    (adapter->hw.mac_type == e1000_82573))
 		e1000_transfer_dhcp_info(adapter, skb);
 
-	local_irq_save(flags);
-	if (!spin_trylock(&tx_ring->tx_lock)) {
+	if (!spin_trylock_irqsave(&tx_ring->tx_lock, flags))
 		/* Collision - tell upper layer to requeue */
-		local_irq_restore(flags);
 		return NETDEV_TX_LOCKED;
-	}
 
 	/* need: count + 2 desc gap to keep tail from touching
 	 * head, otherwise try next time */
_

Patches currently in -mm which might be from mhuth@mvista.com are

git-netdev-all.patch
