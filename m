From: akpm@osdl.org
Subject: + amiga-pcmcia-ne2000-ethernet-dev-irq-init.patch added to -mm tree
Date: Sat, 09 Dec 2006 14:34:25 -0800
Message-ID: <200612092234.kB9MYPXL006127@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:55632 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758882AbWLIWev (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 9 Dec 2006 17:34:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jongk@linux-m68k.org, geert@linux-m68k.org, jeff@garzik.org, linux@dominikbrodowski.net


The patch titled
     Amiga PCMCIA NE2000 Ethernet dev->irq init
has been added to the -mm tree.  Its filename is
     amiga-pcmcia-ne2000-ethernet-dev-irq-init.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

m68k-hp300-hp-lance-updates.patch
amiga-pcmcia-ne2000-ethernet-dev-irq-init.patch

