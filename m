From: akpm@linux-foundation.org
Subject: - char-moxa-cleanup-module-param-passed-isa-init.patch removed from -mm tree
Date: Thu, 01 May 2008 02:28:51 -0700
Message-ID: <200805010928.m419SpaD030611@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43177 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757341AbYEAJ25 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:28:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, Oyvind.Aabling@uni-c.dk, mm-commits@vger.kernel.org


The patch titled
     Char: moxa, cleanup module-param passed isa init
has been removed from the -mm tree.  Its filename was
     char-moxa-cleanup-module-param-passed-isa-init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: moxa, cleanup module-param passed isa init
From: Jiri Slaby <jirislaby@gmail.com>

Make the code more readable, remap the base address directly.  Describe module
parameters.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Tested-by: Oyvind Aabling <Oyvind.Aabling@uni-c.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |   64 +++++++++++++++++++++---------------------
 1 file changed, 33 insertions(+), 31 deletions(-)

diff -puN drivers/char/moxa.c~char-moxa-cleanup-module-param-passed-isa-init drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxa-cleanup-module-param-passed-isa-init
+++ a/drivers/char/moxa.c
@@ -95,7 +95,6 @@ MODULE_DEVICE_TABLE(pci, moxa_pcibrds);
 static struct moxa_board_conf {
 	int boardType;
 	int numPorts;
-	unsigned long baseAddr;
 	int busType;
 
 	int loadstat;
@@ -159,18 +158,21 @@ struct moxa_port {
 static int ttymajor = MOXAMAJOR;
 /* Variables for insmod */
 #ifdef MODULE
-static int baseaddr[4];
-static int type[4];
-static int numports[4];
+static unsigned long baseaddr[MAX_BOARDS];
+static unsigned int type[MAX_BOARDS];
+static unsigned int numports[MAX_BOARDS];
 #endif
 
 MODULE_AUTHOR("William Chen");
 MODULE_DESCRIPTION("MOXA Intellio Family Multiport Board Device Driver");
 MODULE_LICENSE("GPL");
 #ifdef MODULE
-module_param_array(type, int, NULL, 0);
-module_param_array(baseaddr, int, NULL, 0);
-module_param_array(numports, int, NULL, 0);
+module_param_array(type, uint, NULL, 0);
+MODULE_PARM_DESC(type, "card type: C218=2, C320=4");
+module_param_array(baseaddr, ulong, NULL, 0);
+MODULE_PARM_DESC(baseaddr, "base address");
+module_param_array(numports, uint, NULL, 0);
+MODULE_PARM_DESC(numports, "numports (ignored for C218)");
 #endif
 module_param(ttymajor, int, 0);
 
@@ -335,8 +337,9 @@ static struct pci_driver moxa_pci_driver
 
 static int __init moxa_init(void)
 {
-	int i, numBoards = 0, retval = 0;
 	struct moxa_port *ch;
+	unsigned int i, isabrds = 0;
+	int retval = 0;
 
 	printk(KERN_INFO "MOXA Intellio family driver version %s\n",
 			MOXA_VERSION);
@@ -380,46 +383,45 @@ static int __init moxa_init(void)
 
 	mod_timer(&moxaTimer, jiffies + HZ / 50);
 
-	/* Find the boards defined form module args. */
+	/* Find the boards defined from module args. */
 #ifdef MODULE
+	{
+	struct moxa_board_conf *brd = moxa_boards;
 	for (i = 0; i < MAX_BOARDS; i++) {
-		if ((type[i] == MOXA_BOARD_C218_ISA) ||
-		    (type[i] == MOXA_BOARD_C320_ISA)) {
+		if (!baseaddr[i])
+			break;
+		if (type[i] == MOXA_BOARD_C218_ISA ||
+				type[i] == MOXA_BOARD_C320_ISA) {
 			pr_debug("Moxa board %2d: %s board(baseAddr=%lx)\n",
-			       numBoards + 1, moxa_brdname[type[i] - 1],
-			       (unsigned long)baseaddr[i]);
-			if (numBoards >= MAX_BOARDS) {
-				printk(KERN_WARNING "More than %d MOXA "
-					"Intellio family boards found. Board "
-					"is ignored.\n", MAX_BOARDS);
+					isabrds + 1, moxa_brdname[type[i] - 1],
+					baseaddr[i]);
+			brd->boardType = type[i];
+			brd->numPorts = type[i] == MOXA_BOARD_C218_ISA ? 8 :
+					numports[i];
+			brd->busType = MOXA_BUS_TYPE_ISA;
+			brd->basemem = ioremap(baseaddr[i], 0x4000);
+			if (!brd->basemem) {
+				printk(KERN_ERR "moxa: can't remap %lx\n",
+						baseaddr[i]);
 				continue;
 			}
-			moxa_boards[numBoards].boardType = type[i];
-			if (type[i] == MOXA_BOARD_C218_ISA)
-				moxa_boards[numBoards].numPorts = 8;
-			else
-				moxa_boards[numBoards].numPorts = numports[i];
-			moxa_boards[numBoards].busType = MOXA_BUS_TYPE_ISA;
-			moxa_boards[numBoards].baseAddr = baseaddr[i];
-			numBoards++;
+
+			brd++;
+			isabrds++;
 		}
 	}
+	}
 #endif
 
 #ifdef CONFIG_PCI
 	retval = pci_register_driver(&moxa_pci_driver);
 	if (retval) {
 		printk(KERN_ERR "Can't register moxa pci driver!\n");
-		if (numBoards)
+		if (isabrds)
 			retval = 0;
 	}
 #endif
 
-	for (i = 0; i < numBoards; i++) {
-		moxa_boards[i].basemem = ioremap(moxa_boards[i].baseAddr,
-				0x4000);
-	}
