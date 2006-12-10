From: akpm@osdl.org
Subject: - amiga-pcmcia-ne2000-ethernet-dev-irq-init.patch removed from -mm tree
Date: Sat, 09 Dec 2006 17:53:06 -0800
Message-ID: <200612100153.kBA1r6Wl010629@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:40588 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759338AbWLJBxk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 9 Dec 2006 20:53:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jongk@linux-m68k.org, geert@linux-m68k.org, jeff@garzik.org, linux@dominikbrodowski.net, mm-commits@vger.kernel.org


The patch titled
     Amiga PCMCIA NE2000 Ethernet dev->irq init
has been removed from the -mm tree.  Its filename was
     amiga-pcmcia-ne2000-ethernet-dev-irq-init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Amiga PCMCIA NE2000 Ethernet dev->irq init
From: Kars de Jong <jongk@linux-m68k.org>

Amiga PCMCIA NE2000 Ethernet: Add missing initialization of dev->irq

Signed-off-by: Kars de Jong <jongk@linux-m68k.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/apne.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/net/apne.c~amiga-pcmcia-ne2000-ethernet-dev-irq-init drivers/net/apne.c
--- a/drivers/net/apne.c~amiga-pcmcia-ne2000-ethernet-dev-irq-init
+++ a/drivers/net/apne.c
@@ -311,9 +311,10 @@ static int __init apne_probe1(struct net
 #endif
 
     dev->base_addr = ioaddr;
+    dev->irq = IRQ_AMIGA_PORTS;
 
     /* Install the Interrupt handler */
-    i = request_irq(IRQ_AMIGA_PORTS, apne_interrupt, IRQF_SHARED, DRV_NAME, dev);
+    i = request_irq(dev->irq, apne_interrupt, IRQF_SHARED, DRV_NAME, dev);
     if (i) return i;
 
     for(i = 0; i < ETHER_ADDR_LEN; i++) {
_

Patches currently in -mm which might be from jongk@linux-m68k.org are

origin.patch

