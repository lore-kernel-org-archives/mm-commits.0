From: akpm@linux-foundation.org
Subject: - char-moxa-remove-static-isa-support.patch removed from -mm tree
Date: Thu, 01 May 2008 02:28:47 -0700
Message-ID: <200805010928.m419Sl46030607@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59545 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757189AbYEAJ25 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:28:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, Oyvind.Aabling@uni-c.dk, mm-commits@vger.kernel.org


The patch titled
     Char: moxa, remove static isa support
has been removed from the -mm tree.  Its filename was
     char-moxa-remove-static-isa-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: moxa, remove static isa support
From: Jiri Slaby <jirislaby@gmail.com>

Static ISA field is empty and probably will never be filled in, remove it. 
The driver still supports ISA cards passed through module parameter.  This
actually fixes one bug inside the initialization of module-param passed cards
initialization.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Tested-by: Oyvind Aabling <Oyvind.Aabling@uni-c.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |   34 ++--------------------------------
 1 file changed, 2 insertions(+), 32 deletions(-)

diff -puN drivers/char/moxa.c~char-moxa-remove-static-isa-support drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxa-remove-static-isa-support
+++ a/drivers/char/moxa.c
@@ -92,17 +92,6 @@ static struct pci_device_id moxa_pcibrds
 MODULE_DEVICE_TABLE(pci, moxa_pcibrds);
 #endif /* CONFIG_PCI */
 
-struct moxa_isa_board_conf {
-	int boardType;
-	int numPorts;
-	unsigned long baseAddr;
-};
-
-static struct moxa_isa_board_conf moxa_isa_boards[] =
-{
-/*       {MOXA_BOARD_C218_ISA,8,0xDC000}, */
-};
-
 static struct moxa_board_conf {
 	int boardType;
 	int numPorts;
@@ -346,7 +335,7 @@ static struct pci_driver moxa_pci_driver
 
 static int __init moxa_init(void)
 {
-	int i, numBoards, retval = 0;
+	int i, numBoards = 0, retval = 0;
 	struct moxa_port *ch;
 
 	printk(KERN_INFO "MOXA Intellio family driver version %s\n",
@@ -391,25 +380,6 @@ static int __init moxa_init(void)
 
 	mod_timer(&moxaTimer, jiffies + HZ / 50);
 
-	/* Find the boards defined in source code */
-	numBoards = 0;
-	for (i = 0; i < MAX_BOARDS; i++) {
-		if ((moxa_isa_boards[i].boardType == MOXA_BOARD_C218_ISA) ||
-		 (moxa_isa_boards[i].boardType == MOXA_BOARD_C320_ISA)) {
-			moxa_boards[numBoards].boardType = moxa_isa_boards[i].boardType;
-			if (moxa_isa_boards[i].boardType == MOXA_BOARD_C218_ISA)
-				moxa_boards[numBoards].numPorts = 8;
-			else
-				moxa_boards[numBoards].numPorts = moxa_isa_boards[i].numPorts;
-			moxa_boards[numBoards].busType = MOXA_BUS_TYPE_ISA;
-			moxa_boards[numBoards].baseAddr = moxa_isa_boards[i].baseAddr;
-			pr_debug("Moxa board %2d: %s board(baseAddr=%lx)\n",
-			       numBoards + 1,
-			       moxa_brdname[moxa_boards[numBoards].boardType-1],
-			       moxa_boards[numBoards].baseAddr);
-			numBoards++;
-		}
-	}
 	/* Find the boards defined form module args. */
 #ifdef MODULE
 	for (i = 0; i < MAX_BOARDS; i++) {
@@ -425,7 +395,7 @@ static int __init moxa_init(void)
 				continue;
 			}
 			moxa_boards[numBoards].boardType = type[i];
-			if (moxa_isa_boards[i].boardType == MOXA_BOARD_C218_ISA)
+			if (type[i] == MOXA_BOARD_C218_ISA)
 				moxa_boards[numBoards].numPorts = 8;
 			else
 				moxa_boards[numBoards].numPorts = numports[i];
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

