From: akpm@linux-foundation.org
Subject: + m68knommu-fix-fec-driver-interrupt-races.patch added to -mm tree
Date: Tue, 04 Mar 2008 01:33:41 -0800
Message-ID: <200803040933.m249XfER001533@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51233 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755691AbYCDJjU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 04:39:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gerg@snapgear.com, gerg@uclinux.org, jeff@garzik.org


The patch titled
     m68knommu: fix fec driver interrupt races
has been added to the -mm tree.  Its filename is
     m68knommu-fix-fec-driver-interrupt-races.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

m68knommu-update-defconfig.patch
m68knommu-remove-duplicate-hw_tick-code.patch
m68knommu-declare-do_irq.patch
m68knommu-fix-fec-driver-interrupt-races.patch

