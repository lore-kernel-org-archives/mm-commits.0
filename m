From: akpm@linux-foundation.org
Subject: - char-cyclades-use-is_cyc_z-macro.patch removed from -mm tree
Date: Tue, 08 May 2007 19:57:22 -0700
Message-ID: <200705090257.l492vM04010179@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53951 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032772AbXEIC50 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:57:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: cyclades, use IS_CYC_Z macro
has been removed from the -mm tree.  Its filename was
     char-cyclades-use-is_cyc_z-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: cyclades, use IS_CYC_Z macro
From: Jiri Slaby <jirislaby@gmail.com>

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-use-is_cyc_z-macro drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-use-is_cyc_z-macro
+++ a/drivers/char/cyclades.c
@@ -3616,11 +3616,6 @@ static int cy_tiocmget(struct tty_struct
 			((status & CyCTS) ? TIOCM_CTS : 0);
 	} else {
 		base_addr = cy_card[card].base_addr;
-
-		if (cy_card[card].num_chips != -1) {
-			return -EINVAL;
-		}
-
 		firm_id = cy_card[card].base_addr + ID_ADDRESS;
 		if (ISZLOADED(cy_card[card])) {
 			zfw_ctrl = cy_card[card].base_addr +
@@ -4513,7 +4508,7 @@ static void __devinit cy_init_card(struc
 	unsigned short chip_number;
 	int index, port;
 
-	if (cinfo->num_chips == -1) {	/* Cyclades-Z */
+	if (IS_CYC_Z(*cinfo)) {	/* Cyclades-Z */
 		mailbox = readl(&((struct RUNTIME_9060 __iomem *)
 				     cinfo->ctl_addr)->mail_box_0);
 		nports = (mailbox == ZE_V1) ? ZE_V1_NPORTS : 8;
@@ -5346,12 +5341,12 @@ static void __devexit cy_pci_release(str
 	unsigned int i;
 
 	/* non-Z with old PLX */
-	if (cinfo->num_chips != -1 && (readb(cinfo->base_addr + CyPLX_VER) &
-				0x0f) == PLX_9050)
+	if (!IS_CYC_Z(*cinfo) && (readb(cinfo->base_addr + CyPLX_VER) & 0x0f) ==
+			PLX_9050)
 		cy_writeb(cinfo->ctl_addr + 0x4c, 0);
 	else
 #ifndef CONFIG_CYZ_INTR
-		if (cinfo->num_chips != -1)
+		if (!IS_CYC_Z(*cinfo))
 #endif
 		cy_writew(cinfo->ctl_addr + 0x68,
 				readw(cinfo->ctl_addr + 0x68) & ~0x0900);
@@ -5361,7 +5356,7 @@ static void __devexit cy_pci_release(str
 		pci_iounmap(pdev, cinfo->ctl_addr);
 	if (cinfo->irq
 #ifndef CONFIG_CYZ_INTR
-		&& cinfo->num_chips != -1 /* not a Z card */
+		&& !IS_CYC_Z(*cinfo)
 #endif /* CONFIG_CYZ_INTR */
 		)
 		free_irq(cinfo->irq, cinfo);
@@ -5582,7 +5577,7 @@ static void __exit cy_cleanup_module(voi
 				iounmap(cy_card[i].ctl_addr);
 			if (cy_card[i].irq
 #ifndef CONFIG_CYZ_INTR
-				&& cy_card[i].num_chips != -1 /* not a Z card */
+				&& !IS_CYC_Z(cy_card[i])
 #endif /* CONFIG_CYZ_INTR */
 				)
 				free_irq(cy_card[i].irq, &cy_card[i]);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-dvb.patch
cinergyt2-fix-file-release-handler.patch
auerswald-fix-file-release-handler.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
vmstat-use-our-own-timer-events-fix.patch
shrink_slab-handle-bad-shrinkers.patch
