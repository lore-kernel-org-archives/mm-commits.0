From: akpm@linux-foundation.org
Subject: + e1000-fix-stop-raw-interrupts-disabled-nag-from-rt.patch added to -mm tree
Date: Wed, 07 Mar 2007 14:04:33 -0800
Message-ID: <200703072204.l27M4X70010452@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33270 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992452AbXCGWEv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 17:04:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhuth@mvista.com, auke-jan.h.kok@intel.com


The patch titled
     e1000: FIX: Stop raw interrupts disabled nag from RT
has been added to the -mm tree.  Its filename is
     e1000-fix-stop-raw-interrupts-disabled-nag-from-rt.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

e1000-fix-stop-raw-interrupts-disabled-nag-from-rt.patch
