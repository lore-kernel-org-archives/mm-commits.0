From: akpm@linux-foundation.org
Subject: - char-mxser-remove-predefined-isa-support.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:01:48 -0700
Message-ID: <200807252301.m6PN1mMs003738@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753345AbYGYXC3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:02:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Char: mxser, remove predefined isa support
has been removed from the -mm tree.  Its filename was
     char-mxser-remove-predefined-isa-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: mxser, remove predefined isa support
From: Jiri Slaby <jirislaby@gmail.com>

Remove a support of ISA addresses predefined at compile time.  It is
unused (filled by zeroes) and prolongs the code.  Don't initialize global
array and add `ioaddr' module param description.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser.c |   65 ++++++++++++++++-------------------------
 1 file changed, 26 insertions(+), 39 deletions(-)

diff -puN drivers/char/mxser.c~char-mxser-remove-predefined-isa-support drivers/char/mxser.c
--- a/drivers/char/mxser.c~char-mxser-remove-predefined-isa-support
+++ a/drivers/char/mxser.c
@@ -173,14 +173,15 @@ static struct pci_device_id mxser_pcibrd
 };
 MODULE_DEVICE_TABLE(pci, mxser_pcibrds);
 
-static int ioaddr[MXSER_BOARDS] = { 0, 0, 0, 0 };
+static unsigned long ioaddr[MXSER_BOARDS];
 static int ttymajor = MXSERMAJOR;
 
 /* Variables for insmod */
 
 MODULE_AUTHOR("Casper Yang");
 MODULE_DESCRIPTION("MOXA Smartio/Industio Family Multiport Board Device Driver");
-module_param_array(ioaddr, int, NULL, 0);
+module_param_array(ioaddr, ulong, NULL, 0);
+MODULE_PARM_DESC(ioaddr, "ISA io addresses to look for a moxa board");
 module_param(ttymajor, int, 0);
 MODULE_LICENSE("GPL");
 
@@ -281,11 +282,6 @@ struct mxser_mstatus {
 	int dcd;
 };
 
-static int mxserBoardCAP[MXSER_BOARDS] = {
-	0, 0, 0, 0
-	/*  0x180, 0x280, 0x200, 0x320 */
-};
-
 static struct mxser_board mxser_boards[MXSER_BOARDS];
 static struct tty_driver *mxvar_sdriver;
 static struct mxser_log mxvar_log;
@@ -2763,9 +2759,8 @@ static struct pci_driver mxser_driver = 
 static int __init mxser_module_init(void)
 {
 	struct mxser_board *brd;
-	unsigned long cap;
-	unsigned int i, m, isaloop;
-	int retval, b;
+	unsigned int b, i, m;
+	int retval;
 
 	pr_debug("Loading module mxser ...\n");
 
@@ -2797,41 +2792,33 @@ static int __init mxser_module_init(void
 		goto err_put;
 	}
 
-	m = 0;
 	/* Start finding ISA boards here */
-	for (isaloop = 0; isaloop < 2; isaloop++)
-		for (b = 0; b < MXSER_BOARDS && m < MXSER_BOARDS; b++) {
-			if (!isaloop)
-				cap = mxserBoardCAP[b]; /* predefined */
-			else
-				cap = ioaddr[b]; /* module param */
+	for (m = 0, b = 0; b < MXSER_BOARDS; b++) {
+		if (!ioaddr[b])
+			continue;
 
-			if (!cap)
-				continue;
-
-			brd = &mxser_boards[m];
-			retval = mxser_get_ISA_conf(cap, brd);
-			if (retval <= 0) {
-				brd->info = NULL;
-				continue;
-			}
+		brd = &mxser_boards[m];
+		retval = mxser_get_ISA_conf(!ioaddr[b], brd);
+		if (retval <= 0) {
+			brd->info = NULL;
+			continue;
+		}
 
-			printk(KERN_INFO "mxser: found MOXA %s board "
-				"(CAP=0x%x)\n",	brd->info->name, ioaddr[b]);
+		printk(KERN_INFO "mxser: found MOXA %s board (CAP=0x%lx)\n",
+				brd->info->name, ioaddr[b]);
 
-			/* mxser_initbrd will hook ISR. */
-			if (mxser_initbrd(brd, NULL) < 0) {
-				brd->info = NULL;
-				continue;
-			}
+		/* mxser_initbrd will hook ISR. */
+		if (mxser_initbrd(brd, NULL) < 0) {
+			brd->info = NULL;
+			continue;
+		}
 
-			brd->idx = m * MXSER_PORTS_PER_BOARD;
-			for (i = 0; i < brd->info->nports; i++)
-				tty_register_device(mxvar_sdriver, brd->idx + i,
-						NULL);
+		brd->idx = m * MXSER_PORTS_PER_BOARD;
+		for (i = 0; i < brd->info->nports; i++)
+			tty_register_device(mxvar_sdriver, brd->idx + i, NULL);
 
-			m++;
-		}
+		m++;
+	}
 
 	retval = pci_register_driver(&mxser_driver);
 	if (retval) {
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

