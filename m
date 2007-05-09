From: akpm@linux-foundation.org
Subject: - char-cyclades-clear-interrupts-before-releasing.patch removed from -mm tree
Date: Tue, 08 May 2007 19:57:15 -0700
Message-ID: <200705090257.l492vFXv010161@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39958 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032764AbXEIC5U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:57:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: cyclades, clear interrupts before releasing
has been removed from the -mm tree.  Its filename was
     char-cyclades-clear-interrupts-before-releasing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: cyclades, clear interrupts before releasing
From: Jiri Slaby <jirislaby@gmail.com>

Without this patch, the driver sometimes causes "IRQXX: Nobody cares".  Fix it
by turning off irqs when releasing.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN drivers/char/cyclades.c~char-cyclades-clear-interrupts-before-releasing drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-clear-interrupts-before-releasing
+++ a/drivers/char/cyclades.c
@@ -5341,6 +5341,17 @@ static void __devexit cy_pci_release(str
 	struct cyclades_card *cinfo = pci_get_drvdata(pdev);
 	unsigned int i;
 
+	/* non-Z with old PLX */
+	if (cinfo->num_chips != -1 && (readb(cinfo->base_addr + CyPLX_VER) &
+				0x0f) == PLX_9050)
+		cy_writeb(cinfo->ctl_addr + 0x4c, 0);
+	else
+#ifndef CONFIG_CYZ_INTR
+		if (cinfo->num_chips != -1)
+#endif
+		cy_writew(cinfo->ctl_addr + 0x68,
+				readw(cinfo->ctl_addr + 0x68) & ~0x0900);
+
 	pci_iounmap(pdev, cinfo->base_addr);
 	if (cinfo->ctl_addr)
 		pci_iounmap(pdev, cinfo->ctl_addr);
@@ -5560,6 +5571,8 @@ static void __exit cy_cleanup_module(voi
 				cy_pci_release(cy_card[i].pdev);
 				continue;
 			}
+			/* clear interrupt */
+			cy_writeb(cy_card[i].base_addr + Cy_ClrIntr, 0);
 			iounmap(cy_card[i].base_addr);
 			if (cy_card[i].ctl_addr)
 				iounmap(cy_card[i].ctl_addr);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-dvb.patch
cinergyt2-fix-file-release-handler.patch
auerswald-fix-file-release-handler.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
vmstat-use-our-own-timer-events-fix.patch
shrink_slab-handle-bad-shrinkers.patch
