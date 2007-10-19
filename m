From: akpm@linux-foundation.org
Subject: - char-moxa-cleanup-prints.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:44:26 -0700
Message-ID: <200710190344.l9J3iQru013143@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42224 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764000AbXJSDzm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: moxa, cleanup prints
has been removed from the -mm tree.  Its filename was
     char-moxa-cleanup-prints.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: moxa, cleanup prints
From: Jiri Slaby <jirislaby@gmail.com>

- use dev_* where pdev is available (probe function)
- add some printks on fail paths
- add KERN_ macros otherwise
- remove useless verbose variable
- wrap lines to 80 cols at most

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |   73 +++++++++++++++++-------------------------
 1 file changed, 31 insertions(+), 42 deletions(-)

diff -puN drivers/char/moxa.c~char-moxa-cleanup-prints drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxa-cleanup-prints
+++ a/drivers/char/moxa.c
@@ -166,7 +166,6 @@ struct moxa_port {
 
 #define WAKEUP_CHARS		256
 
-static int verbose = 0;
 static int ttymajor = MOXAMAJOR;
 /* Variables for insmod */
 #ifdef MODULE
@@ -184,7 +183,6 @@ module_param_array(baseaddr, int, NULL, 
 module_param_array(numports, int, NULL, 0);
 #endif
 module_param(ttymajor, int, 0);
-module_param(verbose, bool, 0644);
 
 /*
  * static functions:
@@ -283,8 +281,10 @@ static int __devinit moxa_pci_probe(stru
 	int retval;
 
 	retval = pci_enable_device(pdev);
-	if (retval)
+	if (retval) {
+		dev_err(&pdev->dev, "can't enable pci device\n");
 		goto err;
+	}
 
 	for (i = 0; i < MAX_BOARDS; i++)
 		if (moxa_boards[i].basemem == NULL)
@@ -292,16 +292,17 @@ static int __devinit moxa_pci_probe(stru
 
 	retval = -ENODEV;
 	if (i >= MAX_BOARDS) {
-		if (verbose)
-			printk("More than %d MOXA Intellio family boards "
+		dev_warn(&pdev->dev, "more than %u MOXA Intellio family boards "
 				"found. Board is ignored.\n", MAX_BOARDS);
 		goto err;
 	}
 
 	board = &moxa_boards[i];
 	board->basemem = pci_iomap(pdev, 2, 0x4000);
-	if (board->basemem == NULL)
+	if (board->basemem == NULL) {
+		dev_err(&pdev->dev, "can't remap io space 2\n");
 		goto err;
+	}
 
 	board->boardType = board_type;
 	switch (board_type) {
@@ -347,7 +348,8 @@ static int __init moxa_init(void)
 	int i, numBoards, retval = 0;
 	struct moxa_port *ch;
 
-	printk(KERN_INFO "MOXA Intellio family driver version %s\n", MOXA_VERSION);
+	printk(KERN_INFO "MOXA Intellio family driver version %s\n",
+			MOXA_VERSION);
 	moxaDriver = alloc_tty_driver(MAX_PORTS + 1);
 	if (!moxaDriver)
 		return -ENOMEM;
@@ -378,7 +380,7 @@ static int __init moxa_init(void)
 				(unsigned long)ch);
 	}
 
-	printk("Tty devices major number = %d\n", ttymajor);
+	pr_debug("Moxa tty devices major number = %d\n", ttymajor);
 
 	if (tty_register_driver(moxaDriver)) {
 		printk(KERN_ERR "Couldn't install MOXA Smartio family driver !\n");
@@ -400,11 +402,10 @@ static int __init moxa_init(void)
 				moxa_boards[numBoards].numPorts = moxa_isa_boards[i].numPorts;
 			moxa_boards[numBoards].busType = MOXA_BUS_TYPE_ISA;
 			moxa_boards[numBoards].baseAddr = moxa_isa_boards[i].baseAddr;
-			if (verbose)
-				printk("Board %2d: %s board(baseAddr=%lx)\n",
-				       numBoards + 1,
-				       moxa_brdname[moxa_boards[numBoards].boardType - 1],
-				       moxa_boards[numBoards].baseAddr);
+			pr_debug("Moxa board %2d: %s board(baseAddr=%lx)\n",
+			       numBoards + 1,
+			       moxa_brdname[moxa_boards[numBoards].boardType-1],
+			       moxa_boards[numBoards].baseAddr);
 			numBoards++;
 		}
 	}
@@ -413,14 +414,13 @@ static int __init moxa_init(void)
 	for (i = 0; i < MAX_BOARDS; i++) {
 		if ((type[i] == MOXA_BOARD_C218_ISA) ||
 		    (type[i] == MOXA_BOARD_C320_ISA)) {
-			if (verbose)
-				printk("Board %2d: %s board(baseAddr=%lx)\n",
-				       numBoards + 1,
-				       moxa_brdname[type[i] - 1],
-				       (unsigned long) baseaddr[i]);
+			pr_debug("Moxa board %2d: %s board(baseAddr=%lx)\n",
+			       numBoards + 1, moxa_brdname[type[i] - 1],
+			       (unsigned long)baseaddr[i]);
 			if (numBoards >= MAX_BOARDS) {
-				if (verbose)
-					printk("More than %d MOXA Intellio family boards found. Board is ignored.", MAX_BOARDS);
+				printk(KERN_WARNING "More than %d MOXA "
+					"Intellio family boards found. Board "
+					"is ignored.\n", MAX_BOARDS);
 				continue;
 			}
 			moxa_boards[numBoards].boardType = type[i];
@@ -456,16 +456,14 @@ static void __exit moxa_exit(void)
 {
 	int i;
 
-	if (verbose)
-		printk("Unloading module moxa ...\n");
-
 	del_timer_sync(&moxaTimer);
 
 	for (i = 0; i < MAX_PORTS; i++)
 		del_timer_sync(&moxa_ports[i].emptyTimer);
 
 	if (tty_unregister_driver(moxaDriver))
-		printk("Couldn't unregister MOXA Intellio family serial driver\n");
+		printk(KERN_ERR "Couldn't unregister MOXA Intellio family "
+				"serial driver\n");
 	put_tty_driver(moxaDriver);
 
 #ifdef CONFIG_PCI
@@ -475,9 +473,6 @@ static void __exit moxa_exit(void)
 	for (i = 0; i < MAX_BOARDS; i++)
 		if (moxa_boards[i].basemem)
 			iounmap(moxa_boards[i].basemem);
-
-	if (verbose)
-		printk("Done\n");
 }
 
 module_init(moxa_init);
@@ -532,9 +527,7 @@ static void moxa_close(struct tty_struct
 		return;
 	}
 	if (!MoxaPortIsValid(port)) {
-#ifdef SERIAL_DEBUG_CLOSE
-		printk("Invalid portno in moxa_close\n");
-#endif
+		pr_debug("Invalid portno in moxa_close\n");
 		tty->driver_data = NULL;
 		return;
 	}
@@ -547,13 +540,13 @@ static void moxa_close(struct tty_struct
 	ch = (struct moxa_port *) tty->driver_data;
 
 	if ((tty->count == 1) && (ch->count != 1)) {
-		printk("moxa_close: bad serial port count; tty->count is 1, "
-		       "ch->count is %d\n", ch->count);
+		printk(KERN_WARNING "moxa_close: bad serial port count; "
+			"tty->count is 1, ch->count is %d\n", ch->count);
 		ch->count = 1;
 	}
 	if (--ch->count < 0) {
-		printk("moxa_close: bad serial port count, device=%s\n",
-		       tty->name);
+		printk(KERN_WARNING "moxa_close: bad serial port count, "
+			"device=%s\n", tty->name);
 		ch->count = 0;
 	}
 	if (ch->count) {
@@ -971,10 +964,8 @@ static int block_till_ready(struct tty_s
 	 */
 	retval = 0;
 	add_wait_queue(&ch->open_wait, &wait);
-#ifdef SERIAL_DEBUG_OPEN
-	printk("block_til_ready before block: ttys%d, count = %d\n",
-	       ch->line, ch->count);
-#endif
+	pr_debug("block_til_ready before block: ttys%d, count = %d\n",
+		ch->port, ch->count);
 	spin_lock_irqsave(&moxa_lock, flags);
 	if (!tty_hung_up_p(filp))
 		ch->count--;
@@ -1013,10 +1004,8 @@ static int block_till_ready(struct tty_s
 		ch->count++;
 	ch->blocked_open--;
 	spin_unlock_irqrestore(&moxa_lock, flags);
-#ifdef SERIAL_DEBUG_OPEN
-	printk("block_til_ready after blocking: ttys%d, count = %d\n",
-	       ch->line, ch->count);
-#endif
+	pr_debug("block_til_ready after blocking: ttys%d, count = %d\n",
+		ch->port, ch->count);
 	if (retval)
 		return (retval);
 	/* FIXME: review to see if we need to use set_bit on these */
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-dvb.patch
v4l-stk11xx-add-a-new-webcam-driver.patch
v4l-stk11xx-use-array_size-in-another-2-cases.patch
v4l-stk11xx-use-retval-from-stk11xx_check_device.patch
v4l-stk11xx-add-static-to-tables.patch
git-wireless.patch
misc-phantom-synchronize_irq-on-suspend.patch
misc-phantom-add-comment-about-openhaptics.patch
misc-phantom-improved-data-passing.patch
fs-select-remove-unused-macros.patch
remove-asm-bitopsh-includes.patch
forbid-asm-bitopsh-direct-inclusion.patch
cyber2000fb-rename-bit-macro.patch
i2c-pxa-rename-bit-macro-to-pxa_bit.patch
s2io-rename-bit-macro.patch
amba-pl011-rename-bit-macro.patch
define-first-set-of-bit-macros.patch
get-rid-of-input-bit-duplicate-defines.patch
define-global-bit-macro.patch
flashpoint-use-bit-instead-of-bitw.patch
remove-bits_to_type-macro.patch
remove-bits_to_type-macro-fix.patch
remove-asm-bitopsh-includes-reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
