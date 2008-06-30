From: akpm@linux-foundation.org
Subject: + char-mxser-remove-predefined-isa-support.patch added to -mm tree
Date: Mon, 30 Jun 2008 14:21:50 -0700
Message-ID: <200806302121.m5ULLowV026007@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38360 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762068AbYF3VW3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 17:22:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, alan@redhat.com


The patch titled
     Char: mxser, remove predefined isa support
has been added to the -mm tree.  Its filename is
     char-mxser-remove-predefined-isa-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 
@@ -289,11 +290,6 @@ struct mxser_mstatus {
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
@@ -2772,9 +2768,8 @@ static struct pci_driver mxser_driver = 
 static int __init mxser_module_init(void)
 {
 	struct mxser_board *brd;
-	unsigned long cap;
-	unsigned int i, m, isaloop;
-	int retval, b;
+	unsigned int b, i, m;
+	int retval;
 
 	pr_debug("Loading module mxser ...\n");
 
@@ -2806,41 +2801,33 @@ static int __init mxser_module_init(void
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

add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch
serial-z85c30-avoid-a-hang-at-console-switch-over.patch
serial-dz11-avoid-a-hang-at-console-switch-over.patch
vt-hold-console_sem-across-sysfs-operations.patch
ip2-push-bkl-down-for-the-firmware-interface.patch
rio-push-down-the-bkl-into-the-firmware-ioctl-handler.patch
sx-push-bkl-down-into-the-firmware-ioctl-handler.patch
ppdev-wrap-ioctl-handler-in-driver-and-push-lock-down.patch
dsp56k-bkl-pushdown.patch
char-mxser-ioctl-cleanup.patch
char-mxser-globals-cleanup.patch
char-mxser-add-cp-102uf-support.patch
char-mxser-update-documentation.patch
char-mxser-prints-cleanup.patch
char-mxser-remove-predefined-isa-support.patch
char-mxser-various-cleanups.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

