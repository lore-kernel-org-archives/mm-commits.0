From: akpm@osdl.org
Subject: - char-mxser_new-compress-isa-finding.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:07:27 -0800
Message-ID: <200612082007.kB8K7Rdc002514@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57935 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946098AbWLHUHd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:07:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: mxser_new, compress isa finding
has been removed from the -mm tree.  Its filename was
     char-mxser_new-compress-isa-finding.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: mxser_new, compress isa finding
From: Jiri Slaby <jirislaby@gmail.com>

ISA cards finding was too complex -- 2 (module params + predefined) absolutely
same routines, join them together with one for loop, one if and one indent
level.

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/mxser_new.c |  109 +++++++++++++------------------------
 1 file changed, 40 insertions(+), 69 deletions(-)

diff -puN drivers/char/mxser_new.c~char-mxser_new-compress-isa-finding drivers/char/mxser_new.c
--- a/drivers/char/mxser_new.c~char-mxser_new-compress-isa-finding
+++ a/drivers/char/mxser_new.c
@@ -2803,7 +2803,8 @@ static int __init mxser_module_init(void
 {
 	struct pci_dev *pdev = NULL;
 	struct mxser_board *brd;
-	unsigned int i, m;
+	unsigned long cap;
+	unsigned int i, m, isaloop;
 	int retval, b, n;
 
 	pr_debug("Loading module mxser ...\n");
@@ -2839,84 +2840,54 @@ static int __init mxser_module_init(void
 
 	m = 0;
 	/* Start finding ISA boards here */
-	for (b = 0; b < MXSER_BOARDS && m < MXSER_BOARDS; b++) {
-		int cap;
+	for (isaloop = 0; isaloop < 2; isaloop++)
+		for (b = 0; b < MXSER_BOARDS && m < MXSER_BOARDS; b++) {
+			if (!isaloop)
+				cap = mxserBoardCAP[b]; /* predefined */
+			else
+				cap = ioaddr[b]; /* module param */
 
-		if (!(cap = mxserBoardCAP[b]))
-			continue;
-
-		brd = &mxser_boards[m];
-		retval = mxser_get_ISA_conf(cap, brd);
-
-		if (retval != 0)
-			printk(KERN_INFO "Found MOXA %s board (CAP=0x%x)\n",
-				mxser_brdname[brd->board_type - 1], ioaddr[b]);
-
-		if (retval <= 0) {
-			if (retval == MXSER_ERR_IRQ)
-				printk(KERN_ERR "Invalid interrupt number, "
-					"board not configured\n");
-			else if (retval == MXSER_ERR_IRQ_CONFLIT)
-				printk(KERN_ERR "Invalid interrupt number, "
-					"board not configured\n");
-			else if (retval == MXSER_ERR_VECTOR)
-				printk(KERN_ERR "Invalid interrupt vector, "
-					"board not configured\n");
-			else if (retval == MXSER_ERR_IOADDR)
-				printk(KERN_ERR "Invalid I/O address, "
-					"board not configured\n");
-
-			continue;
-		}
-
-		brd->pdev = NULL;
+			if (!cap)
+				continue;
 
-		/* mxser_initbrd will hook ISR. */
-		if (mxser_initbrd(brd) < 0)
-			continue;
+			brd = &mxser_boards[m];
+			retval = mxser_get_ISA_conf(cap, brd);
 
-		m++;
-	}
+			if (retval != 0)
+				printk(KERN_INFO "Found MOXA %s board "
+					"(CAP=0x%x)\n",
+					mxser_brdname[brd->board_type - 1],
+					ioaddr[b]);
 
-	/* Start finding ISA boards from module arg */
-	for (b = 0; b < MXSER_BOARDS && m < MXSER_BOARDS; b++) {
-		unsigned long cap;
+			if (retval <= 0) {
+				if (retval == MXSER_ERR_IRQ)
+					printk(KERN_ERR "Invalid interrupt "
+						"number, board not "
+						"configured\n");
+				else if (retval == MXSER_ERR_IRQ_CONFLIT)
+					printk(KERN_ERR "Invalid interrupt "
+						"number, board not "
+						"configured\n");
+				else if (retval == MXSER_ERR_VECTOR)
+					printk(KERN_ERR "Invalid interrupt "
+						"vector, board not "
+						"configured\n");
+				else if (retval == MXSER_ERR_IOADDR)
+					printk(KERN_ERR "Invalid I/O address, "
+						"board not configured\n");
 
-		if (!(cap = ioaddr[b]))
-			continue;
+				continue;
+			}
 
-		brd = &mxser_boards[m];
-		retval = mxser_get_ISA_conf(cap, &mxser_boards[m]);
+			brd->pdev = NULL;
 
-		if (retval != 0)
-			printk(KERN_INFO "Found MOXA %s board (CAP=0x%x)\n",
-				mxser_brdname[brd->board_type - 1], ioaddr[b]);
-
-		if (retval <= 0) {
-			if (retval == MXSER_ERR_IRQ)
-				printk(KERN_ERR "Invalid interrupt number, "
-					"board not configured\n");
-			else if (retval == MXSER_ERR_IRQ_CONFLIT)
-				printk(KERN_ERR "Invalid interrupt number, "
-					"board not configured\n");
-			else if (retval == MXSER_ERR_VECTOR)
-				printk(KERN_ERR "Invalid interrupt vector, "
-					"board not configured\n");
-			else if (retval == MXSER_ERR_IOADDR)
-				printk(KERN_ERR "Invalid I/O address, "
-					"board not configured\n");
+			/* mxser_initbrd will hook ISR. */
+			if (mxser_initbrd(brd) < 0)
+				continue;
 
-			continue;
+			m++;
 		}
 
-		brd->pdev = NULL;
-		/* mxser_initbrd will hook ISR. */
-		if (mxser_initbrd(brd) < 0)
-			continue;
-
-		m++;
-	}
-
 	/* start finding PCI board here */
 	n = ARRAY_SIZE(mxser_pcibrds) - 1;
 	b = 0;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

char-mxser_new-compress-isa-finding.patch
char-mxser_new-register-tty-devices-on-the-fly.patch
char-mxser_new-compact-structures-round2.patch
char-mxser_new-reverse-if-else-paths-patch.patch
char-mxser_new-comments-cleanup.patch
char-mxser_new-correct-intr-handler-proto.patch
char-mxser_new-delete-ttys-and-termios.patch
char-mxser_new-pci-probing.patch
char-mxser_new-clean-macros.patch
maintainers-add-me-to-isicom-mxser.patch
mxser_new-correct-tty-driver-name.patch
mxser-workqueue-fixes.patch
char-stallion-use-pr_debug-macro.patch
char-stallion-remove-unneeded-casts.patch
char-stallion-kill-typedefs.patch
char-stallion-move-init-deinit.patch
char-stallion-uninline-functions.patch
char-stallion-mark-functions-as-init.patch
char-stallion-remove-many-prototypes.patch
char-isicom-expand-function.patch
char-isicom-rename-init-function.patch
char-isicom-remove-isa-code.patch
char-isicom-remove-unneeded-memset.patch
char-isicom-move-to-tty_register_device.patch
char-isicom-use-pci_request_region.patch
char-isicom-check-kmalloc-retval.patch
char-isicom-use-completion.patch
char-isicom-simplify-timer.patch
char-isicom-remove-cvs-stuff.patch
char-isicom-fix-tty-index-check.patch
char-sx-convert-to-pci-probing.patch
char-sx-use-kcalloc.patch
char-sx-mark-functions-as-devinit.patch
char-sx-use-eisa-probing.patch
char-sx-ifdef-isa-code.patch
char-sx-lock-boards-struct.patch
char-sx-remove-duplicite-code.patch
char-sx-whitespace-cleanup.patch
char-sx-simplify-timer-logic.patch
char-sx-fix-return-in-module-init.patch
char-sx-use-pci_iomap.patch
char-sx-request-regions.patch
char-stallion-convert-to-pci-probing.patch
char-stallion-prints-cleanup.patch
char-stallion-implement-fail-paths.patch
char-stallion-correct-__init-macros.patch
char-stallion-functions-cleanup.patch
char-stallion-fix-fail-paths.patch
char-stallion-brd-struct-locking.patch
char-stallion-remove-syntactic-sugar.patch
char-stallion-variables-cleanup.patch
char-stallion-use-dynamic-dev.patch
char-istallion-convert-to-pci-probing.patch
char-istallion-remove-the-mess.patch
char-istallion-eliminate-typedefs.patch
char-istallion-variables-cleanup.patch
char-istallion-ifdef-eisa-code.patch
char-istallion-brdnr-locking.patch
char-istallion-free-only-isa.patch
char-istallion-correct-fail-paths.patch
char-istallion-fix-enabling.patch
char-istallion-move-init-and-exit-code.patch
char-istallion-change-init-sequence.patch
char-istallion-dynamic-tty-device.patch
char-istallion-use-mod_timer.patch
char-cyclades-save-indent-levels.patch
char-cyclades-lindent-the-code.patch
char-cyclades-cleanup.patch
char-cyclades-fix-warnings.patch

