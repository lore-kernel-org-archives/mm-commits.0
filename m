From: akpm@linux-foundation.org
Subject: + char-moxa-remove-static-isa-support.patch added to -mm tree
Date: Wed, 27 Feb 2008 15:12:45 -0800
Message-ID: <200802272312.m1RNCjmd003221@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:39065 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761925AbYB0XNX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 18:13:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, Oyvind.Aabling@uni-c.dk


The patch titled
     Char: moxa, remove static isa support
has been added to the -mm tree.  Its filename is
     char-moxa-remove-static-isa-support.patch

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

git-drm.patch
drm-i915-fix-oops-after-killing-x.patch
wdev-ath5k-typecheck-on-nondebug.patch
misc-phantom-add-compat-ioctl.patch
misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
misc-phantom-fix-poll.patch
mxser-prepare-for-bkl-pushdown.patch
tty-bkl-pushdown-fix.patch
tty-bkl-pushdown-fix1.patch
char-moxa-remove-static-isa-support.patch
char-moxa-cleanup-module-param-passed-isa-init.patch
char-moxa-pci-io-space-fixup.patch
char-moxa-fix-tiocg-ssoftcar-param.patch
char-moxa-add-firmware-loading.patch
char-moxa-merge-c2xx-and-c320-firmware-loading.patch
char-moxa-remove-port-port.patch
char-moxa-remove-unused-port-entries.patch
char-moxa-centralize-board-readiness.patch
char-moxa-timer-cleanup.patch
char-moxa-ioctl-cleanup.patch
char-moxa-merge-2-poll-functions.patch
char-moxa-cleanup-rx-tx.patch
char-moxa-serialise-timer.patch
char-moxa-rework-open-close.patch
char-moxa-little-cleanup.patch
char-moxa-remove-useless-tty-functions.patch
char-moxa-introduce-moxa_is_320-macro.patch
char-moxa-notify-about-board-readiness.patch
char-moxa-update-credits.patch
char-moxa-add-firmware-loading-fix.patch
mxser-convert-large-macros-to-functions.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
