From: akpm@linux-foundation.org
Subject: + char-moxa-pci-io-space-fixup.patch added to -mm tree
Date: Wed, 27 Feb 2008 15:12:50 -0800
Message-ID: <200802272312.m1RNCouu003231@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53781 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762274AbYB0XNZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 18:13:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, Oyvind.Aabling@uni-c.dk


The patch titled
     Char: moxa, pci io space fixup
has been added to the -mm tree.  Its filename is
     char-moxa-pci-io-space-fixup.patch

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
Subject: Char: moxa, pci io space fixup
From: Jiri Slaby <jirislaby@gmail.com>

- request region before remapping pci io space
- use ioremap, iounmap istead of iomap interface, because we use
  readX/writeX for accessing this space because of isa support

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Tested-by: Oyvind Aabling <Oyvind.Aabling@uni-c.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff -puN drivers/char/moxa.c~char-moxa-pci-io-space-fixup drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxa-pci-io-space-fixup
+++ a/drivers/char/moxa.c
@@ -290,10 +290,17 @@ static int __devinit moxa_pci_probe(stru
 	}
 
 	board = &moxa_boards[i];
-	board->basemem = pci_iomap(pdev, 2, 0x4000);
+
+	retval = pci_request_region(pdev, 2, "moxa-base");
+	if (retval) {
+		dev_err(&pdev->dev, "can't request pci region 2\n");
+		goto err;
+	}
+
+	board->basemem = ioremap(pci_resource_start(pdev, 2), 0x4000);
 	if (board->basemem == NULL) {
 		dev_err(&pdev->dev, "can't remap io space 2\n");
-		goto err;
+		goto err_reg;
 	}
 
 	board->boardType = board_type;
@@ -315,6 +322,8 @@ static int __devinit moxa_pci_probe(stru
 	pci_set_drvdata(pdev, board);
 
 	return (0);
+err_reg:
+	pci_release_region(pdev, 2);
 err:
 	return retval;
 }
@@ -323,8 +332,9 @@ static void __devexit moxa_pci_remove(st
 {
 	struct moxa_board_conf *brd = pci_get_drvdata(pdev);
 
-	pci_iounmap(pdev, brd->basemem);
+	iounmap(brd->basemem);
 	brd->basemem = NULL;
+	pci_release_region(pdev, 2);
 }
 
 static struct pci_driver moxa_pci_driver = {
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
