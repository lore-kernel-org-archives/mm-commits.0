From: akpm@linux-foundation.org
Subject: - char-cyclades-remove-pause.patch removed from -mm tree
Date: Tue, 08 May 2007 19:56:29 -0700
Message-ID: <200705090256.l492uTYb010053@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51893 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032449AbXEIC4c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:56:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: cyclades, remove PAUSE
has been removed from the -mm tree.  Its filename was
     char-cyclades-remove-pause.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: cyclades, remove PAUSE
From: Jiri Slaby <jirislaby@gmail.com>

cyclades, remove PAUSE

PAUSE expands to do {} while (0), it's useless.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |    9 ---------
 1 file changed, 9 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-remove-pause drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-remove-pause
+++ a/drivers/char/cyclades.c
@@ -624,12 +624,6 @@
 #undef	CY_ENABLE_MONITORING
 #undef	CY_PCI_DEBUG
 
-#if 0
-#define PAUSE __asm__("nop")
-#else
-#define PAUSE do {} while (0)
-#endif
-
 /*
  * Include section 
  */
@@ -5009,7 +5003,6 @@ static int __init cy_detect_pci(void)
 				cy_writel(&((struct RUNTIME_9060 *)
 					(cy_pci_addr0))->loc_addr_base,
 					WIN_CREG);
-				PAUSE;
 				printk("Cyclades-8Zo/PCI: FPGA id %lx, ver "
 					"%lx\n", (ulong) (0xff &
 					cy_readl(&((struct CUSTOM_REG *)
@@ -5030,7 +5023,6 @@ static int __init cy_detect_pci(void)
 			   ensures that the driver will not attempt to talk to
 			   the board until it has been properly initialized.
 			 */
-			PAUSE;
 			if ((mailbox == ZO_V1) || (mailbox == ZO_V2))
 				cy_writel(cy_pci_addr2 + ID_ADDRESS, 0L);
 
@@ -5129,7 +5121,6 @@ static int __init cy_detect_pci(void)
 		printk("Cyclades-Z/PCI: New Cyclades-Z board.  FPGA not "
 				"loaded\n");
 #endif
-		PAUSE;
 		/* This must be the new Cyclades-Ze/PCI. */
 		cy_pci_nchan = ZE_V1_NPORTS;
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-dvb.patch
cinergyt2-fix-file-release-handler.patch
auerswald-fix-file-release-handler.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
vmstat-use-our-own-timer-events-fix.patch
shrink_slab-handle-bad-shrinkers.patch
