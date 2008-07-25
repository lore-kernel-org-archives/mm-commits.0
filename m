From: akpm@linux-foundation.org
Subject: - char-mxser-prints-cleanup.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:01:46 -0700
Message-ID: <200807252301.m6PN1kCQ003735@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51548 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753202AbYGYXC1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:02:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Char: mxser, prints cleanup
has been removed from the -mm tree.  Its filename was
     char-mxser-prints-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: mxser, prints cleanup
From: Jiri Slaby <jirislaby@gmail.com>

- use dev_* for printing in pci probe function
- move ISA p[rints directly into isa find function, do not postpone it.
  Remove macros bound to it then.
- prepend some prints by "mxser: " to know what it belongs to

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser.c |   80 ++++++++++++++++++-----------------------
 1 file changed, 37 insertions(+), 43 deletions(-)

diff -puN drivers/char/mxser.c~char-mxser-prints-cleanup drivers/char/mxser.c
--- a/drivers/char/mxser.c~char-mxser-prints-cleanup
+++ a/drivers/char/mxser.c
@@ -55,11 +55,6 @@
 #define MXSER_PORTS		(MXSER_BOARDS * MXSER_PORTS_PER_BOARD)
 #define MXSER_ISR_PASS_LIMIT	100
 
-#define	MXSER_ERR_IOADDR	-1
-#define	MXSER_ERR_IRQ		-2
-#define	MXSER_ERR_IRQ_CONFLIT	-3
-#define	MXSER_ERR_VECTOR	-4
-
 /*CheckIsMoxaMust return value*/
 #define MOXA_OTHER_UART		0x00
 #define MOXA_MUST_MU150_HWID	0x01
@@ -2481,7 +2476,8 @@ static int __devinit mxser_initbrd(struc
 	unsigned int i;
 	int retval;
 
-	printk(KERN_INFO "max. baud rate = %d bps.\n", brd->ports[0].max_baud);
+	printk(KERN_INFO "mxser: max. baud rate = %d bps\n",
+			brd->ports[0].max_baud);
 
 	for (i = 0; i < brd->info->nports; i++) {
 		info = &brd->ports[i];
@@ -2564,28 +2560,32 @@ static int __init mxser_get_ISA_conf(int
 		irq = regs[9] & 0xF000;
 		irq = irq | (irq >> 4);
 		if (irq != (regs[9] & 0xFF00))
-			return MXSER_ERR_IRQ_CONFLIT;
+			goto err_irqconflict;
 	} else if (brd->info->nports == 4) {
 		irq = regs[9] & 0xF000;
 		irq = irq | (irq >> 4);
 		irq = irq | (irq >> 8);
 		if (irq != regs[9])
-			return MXSER_ERR_IRQ_CONFLIT;
+			goto err_irqconflict;
 	} else if (brd->info->nports == 8) {
 		irq = regs[9] & 0xF000;
 		irq = irq | (irq >> 4);
 		irq = irq | (irq >> 8);
 		if ((irq != regs[9]) || (irq != regs[10]))
-			return MXSER_ERR_IRQ_CONFLIT;
+			goto err_irqconflict;
 	}
 
-	if (!irq)
-		return MXSER_ERR_IRQ;
+	if (!irq) {
+		printk(KERN_ERR "mxser: interrupt number unset\n");
+		return -EIO;
+	}
 	brd->irq = ((int)(irq & 0xF000) >> 12);
 	for (i = 0; i < 8; i++)
 		brd->ports[i].ioaddr = (int) regs[i + 1] & 0xFFF8;
-	if ((regs[12] & 0x80) == 0)
-		return MXSER_ERR_VECTOR;
+	if ((regs[12] & 0x80) == 0) {
+		printk(KERN_ERR "mxser: invalid interrupt vector\n");
+		return -EIO;
+	}
 	brd->vector = (int)regs[11];	/* interrupt vector */
 	if (id == 1)
 		brd->vector_mask = 0x00FF;
@@ -2612,13 +2612,26 @@ static int __init mxser_get_ISA_conf(int
 	else
 		brd->uart_type = PORT_16450;
 	if (!request_region(brd->ports[0].ioaddr, 8 * brd->info->nports,
-			"mxser(IO)"))
-		return MXSER_ERR_IOADDR;
+			"mxser(IO)")) {
+		printk(KERN_ERR "mxser: can't request ports I/O region: "
+				"0x%.8lx-0x%.8lx\n",
+				brd->ports[0].ioaddr, brd->ports[0].ioaddr +
+				8 * brd->info->nports - 1);
+		return -EIO;
+	}
 	if (!request_region(brd->vector, 1, "mxser(vector)")) {
 		release_region(brd->ports[0].ioaddr, 8 * brd->info->nports);
-		return MXSER_ERR_VECTOR;
+		printk(KERN_ERR "mxser: can't request interrupt vector region: "
+				"0x%.8lx-0x%.8lx\n",
+				brd->ports[0].ioaddr, brd->ports[0].ioaddr +
+				8 * brd->info->nports - 1);
+		return -EIO;
 	}
 	return brd->info->nports;
+
+err_irqconflict:
+	printk(KERN_ERR "mxser: invalid interrupt number\n");
+	return -EIO;
 }
 
 static int __devinit mxser_probe(struct pci_dev *pdev,
@@ -2635,20 +2648,20 @@ static int __devinit mxser_probe(struct 
 			break;
 
 	if (i >= MXSER_BOARDS) {
-		printk(KERN_ERR "Too many Smartio/Industio family boards found "
-			"(maximum %d), board not configured\n", MXSER_BOARDS);
+		dev_err(&pdev->dev, "too many boards found (maximum %d), board "
+				"not configured\n", MXSER_BOARDS);
 		goto err;
 	}
 
 	brd = &mxser_boards[i];
 	brd->idx = i * MXSER_PORTS_PER_BOARD;
-	printk(KERN_INFO "Found MOXA %s board (BusNo=%d, DevNo=%d)\n",
+	dev_info(&pdev->dev, "found MOXA %s board (BusNo=%d, DevNo=%d)\n",
 		mxser_cards[ent->driver_data].name,
 		pdev->bus->number, PCI_SLOT(pdev->devfn));
 
 	retval = pci_enable_device(pdev);
 	if (retval) {
-		printk(KERN_ERR "Moxa SmartI/O PCI enable fail !\n");
+		dev_err(&pdev->dev, "PCI enable failed\n");
 		goto err;
 	}
 
@@ -2798,33 +2811,14 @@ static int __init mxser_module_init(void
 
 			brd = &mxser_boards[m];
 			retval = mxser_get_ISA_conf(cap, brd);
-
-			if (retval != 0)
-				printk(KERN_INFO "Found MOXA %s board "
-					"(CAP=0x%x)\n",
-					brd->info->name, ioaddr[b]);
-
 			if (retval <= 0) {
-				if (retval == MXSER_ERR_IRQ)
-					printk(KERN_ERR "Invalid interrupt "
-						"number, board not "
-						"configured\n");
-				else if (retval == MXSER_ERR_IRQ_CONFLIT)
-					printk(KERN_ERR "Invalid interrupt "
-						"number, board not "
-						"configured\n");
-				else if (retval == MXSER_ERR_VECTOR)
-					printk(KERN_ERR "Invalid interrupt "
-						"vector, board not "
-						"configured\n");
-				else if (retval == MXSER_ERR_IOADDR)
-					printk(KERN_ERR "Invalid I/O address, "
-						"board not configured\n");
-
 				brd->info = NULL;
 				continue;
 			}
 
+			printk(KERN_INFO "mxser: found MOXA %s board "
+				"(CAP=0x%x)\n",	brd->info->name, ioaddr[b]);
+
 			/* mxser_initbrd will hook ISR. */
 			if (mxser_initbrd(brd, NULL) < 0) {
 				brd->info = NULL;
@@ -2841,7 +2835,7 @@ static int __init mxser_module_init(void
 
 	retval = pci_register_driver(&mxser_driver);
 	if (retval) {
-		printk(KERN_ERR "Can't register pci driver\n");
+		printk(KERN_ERR "mxser: can't register pci driver\n");
 		if (!m) {
 			retval = -ENODEV;
 			goto err_unr;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
ath5k-fix-memory-corruption.patch
ath5k-kill-tasklets-on-shutdown.patch
ath5k-flush-work.patch
ath5k-fix-dma-operation.patch
ath5k-suspend-resume-fixes.patch
ath5k-fix-beacon-update-deadlock.patch
ath5k-mask-out-unneeded-interrupts.patch
ath5k-unify-resets.patch
mac80211-tx-use-dev_kfree_skb_any-for-beacon_get.patch
mac80211-return-correct-error-return-from-ieee80211_wep_init.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
char-merge-ip2main-and-ip2base.patch
char-ip2-cleanup-globals.patch
char-ip2-fix-sparse-warnings.patch
char-ip2-init-deinit-cleanup.patch
ip2-avoid-add_timer-with-pending-timer.patch
char-ds1286-eliminate-busy-waiting.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

