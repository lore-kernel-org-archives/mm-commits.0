From: akpm@linux-foundation.org
Subject: - m68knommu-fix-fec-driver-interrupt-races.patch removed from -mm tree
Date: Tue, 04 Mar 2008 12:10:00 -0800
Message-ID: <200803042010.m24KA0Tl026802@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33590 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763812AbYCDUTk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 15:19:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gerg@snapgear.com, gerg@uclinux.org, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     m68knommu: fix fec driver interrupt races
has been removed from the -mm tree.  Its filename was
     m68knommu-fix-fec-driver-interrupt-races.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68knommu: fix fec driver interrupt races
From: Greg Ungerer <gerg@snapgear.com>

The FEC driver has a common interrupt handler for all interrupt event types. 
It is raised on a number of distinct interrupt vectors.  This handler can't be
re-entered while processing an interrupt, so make sure all requested vectors
are flagged as IRQF_DISABLED.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/fec.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/net/fec.c~m68knommu-fix-fec-driver-interrupt-races drivers/net/fec.c
--- a/drivers/net/fec.c~m68knommu-fix-fec-driver-interrupt-races
+++ a/drivers/net/fec.c
@@ -1253,7 +1253,7 @@ static void __inline__ fec_request_intrs
 
 	/* Setup interrupt handlers. */
 	for (idp = id; idp->name; idp++) {
-		if (request_irq(idp->irq, idp->handler, 0, idp->name, dev) != 0)
+		if (request_irq(idp->irq, idp->handler, IRQF_DISABLED, idp->name, dev) != 0)
 			printk("FEC: Could not allocate %s IRQ(%d)!\n", idp->name, idp->irq);
 	}
 
@@ -1382,7 +1382,7 @@ static void __inline__ fec_request_intrs
 
 	/* Setup interrupt handlers. */
 	for (idp = id; idp->name; idp++) {
-		if (request_irq(b+idp->irq, fec_enet_interrupt, 0, idp->name, dev) != 0)
+		if (request_irq(b+idp->irq, fec_enet_interrupt, IRQF_DISABLED, idp->name, dev) != 0)
 			printk("FEC: Could not allocate %s IRQ(%d)!\n", idp->name, b+idp->irq);
 	}
 
@@ -1553,7 +1553,7 @@ static void __inline__ fec_request_intrs
 
 	/* Setup interrupt handlers. */
 	for (idp = id; idp->name; idp++) {
-		if (request_irq(b+idp->irq,fec_enet_interrupt,0,idp->name,dev)!=0)
+		if (request_irq(b+idp->irq, fec_enet_interrupt, IRQF_DISABLED, idp->name,dev) != 0)
 			printk("FEC: Could not allocate %s IRQ(%d)!\n", idp->name, b+idp->irq);
 	}
 
@@ -1680,7 +1680,7 @@ static void __inline__ fec_request_intrs
 
 	/* Setup interrupt handlers. */
 	for (idp = id; idp->name; idp++) {
-		if (request_irq(b+idp->irq,fec_enet_interrupt,0,idp->name,dev)!=0)
+		if (request_irq(b+idp->irq, fec_enet_interrupt, IRQF_DISABLED, idp->name,dev) != 0)
 			printk("FEC: Could not allocate %s IRQ(%d)!\n",
 				idp->name, b+idp->irq);
 	}
_

Patches currently in -mm which might be from gerg@snapgear.com are

origin.patch

