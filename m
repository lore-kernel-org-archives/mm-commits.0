From: akpm@osdl.org
Subject: - char-mxser_new-check-request_region-retvals.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:06:49 -0800
Message-ID: <200612082006.kB8K6ngZ002442@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57781 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426348AbWLHUGz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:06:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     char: mxser_new, check request_region retvals
has been removed from the -mm tree.  Its filename was
     char-mxser_new-check-request_region-retvals.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: char: mxser_new, check request_region retvals
From: Jiri Slaby <jirislaby@gmail.com>

mxser_new, check request_region retvals

Return values of (pci_)request_region should be checked and error should be
returned if something is in bad state.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/mxser_new.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff -puN drivers/char/mxser_new.c~char-mxser_new-check-request_region-retvals drivers/char/mxser_new.c
--- a/drivers/char/mxser_new.c~char-mxser_new-check-request_region-retvals
+++ a/drivers/char/mxser_new.c
@@ -622,19 +622,24 @@ static int __init mxser_get_PCI_conf(int
 {
 	unsigned int i, j;
 	unsigned long ioaddress;
+	int retval;
 
 	/* io address */
 	brd->board_type = board_type;
 	brd->nports = mxser_numports[board_type - 1];
 	ioaddress = pci_resource_start(pdev, 2);
-	pci_request_region(pdev, 2, "mxser(IO)");
+	retval = pci_request_region(pdev, 2, "mxser(IO)");
+	if (retval)
+		goto err;
 
 	for (i = 0; i < brd->nports; i++)
 		brd->ports[i].ioaddr = ioaddress + 8 * i;
 
 	/* vector */
 	ioaddress = pci_resource_start(pdev, 3);
-	pci_request_region(pdev, 3, "mxser(vector)");
+	retval = pci_request_region(pdev, 3, "mxser(vector)");
+	if (retval)
+		goto err_relio;
 	brd->vector = ioaddress;
 
 	/* irq */
@@ -674,6 +679,10 @@ static int __init mxser_get_PCI_conf(int
 		brd->ports[i].baud_base = 921600;
 	}
 	return 0;
+err_relio:
+	pci_release_region(pdev, 2);
+err:
+	return retval;
 }
 
 static int __init mxser_init(void)
@@ -3009,8 +3018,12 @@ static int __init mxser_get_ISA_conf(int
 		brd->nports = 8;
 	else
 		brd->nports = 4;
-	request_region(brd->ports[0].ioaddr, 8 * brd->nports, "mxser(IO)");
-	request_region(brd->vector, 1, "mxser(vector)");
+	if (!request_region(brd->ports[0].ioaddr, 8 * brd->nports, "mxser(IO)"))
+		return MXSER_ERR_IOADDR;
+	if (!request_region(brd->vector, 1, "mxser(vector)")) {
+		release_region(brd->ports[0].ioaddr, 8 * brd->nports);
+		return MXSER_ERR_VECTOR;
+	}
 	return brd->nports;
 }
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

char-mxser_new-check-request_region-retvals.patch
char-mxser_new-kill-unneeded-memsets.patch
char-mxser_new-revert-spin_lock-changes.patch
char-mxser_new-remove-request-for-testers-line.patch
char-mxser_new-debug-printk-dependent-on-debug.patch
char-mxser_new-alter-license-terms.patch
char-mxser_new-code-upside-down.patch
char-mxser_new-cmspar-is-defined.patch
char-remove-unneded-termbits-redefinitions-mxser_new.patch
char-mxser_new-eliminate-tty-ldisc-deref.patch
char-mxser_new-testbit-for-bit-testing.patch
char-mxser_new-correct-fail-paths.patch
char-mxser_new-dont-check-tty_unregister-retval.patch
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

