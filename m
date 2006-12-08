From: akpm@osdl.org
Subject: - char-isicom-use-pci_request_region.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:08:43 -0800
Message-ID: <200612082008.kB8K8h7i002633@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58312 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946263AbWLHUIz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:08:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Char: isicom, use pci_request_region
has been removed from the -mm tree.  Its filename was
     char-isicom-use-pci_request_region.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: isicom, use pci_request_region
From: Jiri Slaby <jirislaby@gmail.com>

Use pci_request_region in pci probing function instead of request_region.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/isicom.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/char/isicom.c~char-isicom-use-pci_request_region drivers/char/isicom.c
--- a/drivers/char/isicom.c~char-isicom-use-pci_request_region
+++ a/drivers/char/isicom.c
@@ -1789,7 +1789,8 @@ static int __devinit isicom_probe(struct
 
 	pci_set_drvdata(pdev, board);
 
-	if (!request_region(board->base, 16, ISICOM_NAME)) {
+	retval = pci_request_region(pdev, 3, ISICOM_NAME);
+	if (retval) {
 		dev_err(&pdev->dev, "I/O Region 0x%lx-0x%lx is busy. Card%d "
 			"will be disabled.\n", board->base, board->base + 15,
 			index + 1);
@@ -1822,7 +1823,7 @@ static int __devinit isicom_probe(struct
 errunri:
 	free_irq(board->irq, board);
 errunrr:
-	release_region(board->base, 16);
+	pci_release_region(pdev, 3);
 err:
 	board->base = 0;
 	return retval;
@@ -1837,7 +1838,7 @@ static void __devexit isicom_remove(stru
 		tty_unregister_device(isicom_normal, board->index * 16 + i);
 
 	free_irq(board->irq, board);
-	release_region(board->base, 16);
+	pci_release_region(pdev, 3);
 }
 
 static int __init isicom_init(void)
_

Patches currently in -mm which might be from jirislaby@gmail.com are

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

