From: akpm@osdl.org
Subject: - char-sx-mark-functions-as-devinit.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:09:05 -0800
Message-ID: <200612082009.kB8K95EM002663@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58464 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946221AbWLHUJQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:09:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, R.E.Wolff@BitWizard.nl, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: sx, mark functions as devinit
has been removed from the -mm tree.  Its filename was
     char-sx-mark-functions-as-devinit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: sx, mark functions as devinit
From: Jiri Slaby <jirislaby@gmail.com>

Mark as much as possible functions as __devinit to free them after driver
initialization (if no hotplug).

Cc: <R.E.Wolff@BitWizard.nl>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/sx.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/char/sx.c~char-sx-mark-functions-as-devinit drivers/char/sx.c
--- a/drivers/char/sx.c~char-sx-mark-functions-as-devinit
+++ a/drivers/char/sx.c
@@ -2034,7 +2034,7 @@ static int sx_init_board (struct sx_boar
 }
 
 
-static void printheader(void)
+static void __devinit printheader(void)
 {
 	static int header_printed;
 
@@ -2047,7 +2047,7 @@ static void printheader(void)
 }
 
 
-static int probe_sx (struct sx_board *board)
+static int __devinit probe_sx (struct sx_board *board)
 {
 	struct vpd_prom vpdp;
 	char *p;
@@ -2125,7 +2125,7 @@ static int probe_sx (struct sx_board *bo
    card. 0xe0000 and 0xf0000 are taken by the BIOS. That only leaves 
    0xc0000, 0xc8000, 0xd0000 and 0xd8000 . */
 
-static int probe_si (struct sx_board *board)
+static int __devinit probe_si (struct sx_board *board)
 {
 	int i;
 
@@ -2364,7 +2364,7 @@ static void __exit sx_release_drivers(vo
    EEprom.  As the bit is read/write for the CPU, we can fix it here,
    if we detect that it isn't set correctly. -- REW */
 
-static void fix_sx_pci (struct pci_dev *pdev, struct sx_board *board)
+static void __devinit fix_sx_pci(struct pci_dev *pdev, struct sx_board *board)
 {
 	unsigned int hwbase;
 	void __iomem *rebase;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

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

