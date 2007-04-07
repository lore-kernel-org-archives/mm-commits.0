From: akpm@linux-foundation.org
Subject: + char-cyclades-remove-pause.patch added to -mm tree
Date: Fri, 06 Apr 2007 17:14:14 -0700
Message-ID: <200704070014.l370EEMd023439@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39901 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933584AbXDGAOb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 20:14:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: cyclades, remove PAUSE
has been added to the -mm tree.  Its filename is
     char-cyclades-remove-pause.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

char-rocket-add-module_device_table.patch
char-cs5535_gpio-add-module_device_table.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
char-cyclades-remove-pause.patch
char-cyclades-cy_readx-writex-cleanup.patch
char-cyclades-timer-cleanup.patch
char-cyclades-remove-volatiles.patch
char-cyclades-remove-useless-casts.patch
shrink_slab-handle-bad-shrinkers.patch
