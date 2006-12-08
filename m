From: akpm@osdl.org
Subject: - char-mxser_new-correct-intr-handler-proto.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:07:40 -0800
Message-ID: <200612082007.kB8K7ePj002529@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57970 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946117AbWLHUHq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:07:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: mxser_new, correct intr handler proto
has been removed from the -mm tree.  Its filename was
     char-mxser_new-correct-intr-handler-proto.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: mxser_new, correct intr handler proto
From: Jiri Slaby <jirislaby@gmail.com>

Prototype of the driver's interrupt handler is old-fashioned, past changes
tell us, we won't get pt_regs as the 3rd argument.  There are only 2 params.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/mxser_new.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/mxser_new.c~char-mxser_new-correct-intr-handler-proto drivers/char/mxser_new.c
--- a/drivers/char/mxser_new.c~char-mxser_new-correct-intr-handler-proto
+++ a/drivers/char/mxser_new.c
@@ -2265,7 +2265,7 @@ unlock:
 /*
  * This is the serial driver's generic interrupt routine
  */
-static irqreturn_t mxser_interrupt(int irq, void *dev_id, struct pt_regs *regs)
+static irqreturn_t mxser_interrupt(int irq, void *dev_id)
 {
 	int status, iir, i;
 	struct mxser_board *brd = NULL;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

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

