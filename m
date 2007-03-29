From: akpm@linux-foundation.org
Subject: - sun3-3x-lance-trivial-fix-improved.patch removed from -mm tree
Date: Thu, 29 Mar 2007 00:43:07 -0700
Message-ID: <200703290743.l2T7h7E8030358@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46187 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964960AbXC2HnJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 03:43:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     SUN3/3X Lance trivial fix improved
has been removed from the -mm tree.  Its filename was
     sun3-3x-lance-trivial-fix-improved.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SUN3/3X Lance trivial fix improved
From: "Cyrill V. Gorcunov" <gorcunov@gmail.com>

This patch adds checking for allocated DVMA memory and granted IRQ line.

Signed-off-by: Cyrill V. Gorcunov <gorcunov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sun3lance.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff -puN drivers/net/sun3lance.c~sun3-3x-lance-trivial-fix-improved drivers/net/sun3lance.c
--- a/drivers/net/sun3lance.c~sun3-3x-lance-trivial-fix-improved
+++ a/drivers/net/sun3lance.c
@@ -336,13 +336,27 @@ static int __init lance_probe( struct ne
 
 	/* XXX - leak? */
 	MEM = dvma_malloc_align(sizeof(struct lance_memory), 0x10000);
+	if (MEM == NULL) {
+#ifdef CONFIG_SUN3
+		iounmap((void __iomem *)ioaddr);
+#endif
+		printk(KERN_WARNING "SUN3 Lance couldn't allocate DVMA memory\n");
+		return 0;
+	}
 
 	lp->iobase = (volatile unsigned short *)ioaddr;
 	dev->base_addr = (unsigned long)ioaddr; /* informational only */
 
 	REGA(CSR0) = CSR0_STOP;
 
-	request_irq(LANCE_IRQ, lance_interrupt, IRQF_DISABLED, "SUN3 Lance", dev);
+	if (request_irq(LANCE_IRQ, lance_interrupt, IRQF_DISABLED, "SUN3 Lance", dev) < 0) {
+#ifdef CONFIG_SUN3
+		iounmap((void __iomem *)ioaddr);
+#endif
+		dvma_free((void *)MEM);
+		printk(KERN_WARNING "SUN3 Lance unable to allocate IRQ\n");
+		return 0;
+	}
 	dev->irq = (unsigned short)LANCE_IRQ;
 
 
_

Patches currently in -mm which might be from gorcunov@gmail.com are

origin.patch
git-kbuild.patch
usb-elan-ftdi-check-for-driver-registration-status-v2.patch
cris-check-for-memory-allocation.patch
