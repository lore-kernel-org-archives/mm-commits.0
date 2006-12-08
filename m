From: akpm@osdl.org
Subject: - mxser-correct-tty-driver-name.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:06:22 -0800
Message-ID: <200612082006.kB8K6MsP002390@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57686 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426335AbWLHUG1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:06:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     mxser: correct tty driver name
has been removed from the -mm tree.  Its filename was
     mxser-correct-tty-driver-name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mxser: correct tty driver name
From: Jiri Slaby <jirislaby@gmail.com>

Mxser tty driver name should be ttyMI, not ttyM.  Correct this in mxser to
avoid conflicts with isicom driver, which is ttyM.

Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/mxser.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/mxser.c~mxser-correct-tty-driver-name drivers/char/mxser.c
--- a/drivers/char/mxser.c~mxser-correct-tty-driver-name
+++ a/drivers/char/mxser.c
@@ -556,7 +556,7 @@ static int mxser_initbrd(int board, stru
 	n = board * MXSER_PORTS_PER_BOARD;
 	info = &mxvar_table[n];
 	/*if (verbose) */  {
-		printk(KERN_DEBUG "        ttyM%d - ttyM%d ",
+		printk(KERN_DEBUG "        ttyMI%d - ttyMI%d ",
 			n, n + hwconf->ports - 1);
 		printk(" max. baud rate = %d bps.\n",
 			hwconf->MaxCanSetBaudRate[0]);
@@ -717,7 +717,7 @@ static int mxser_init(void)
 	/* Initialize the tty_driver structure */
 	memset(mxvar_sdriver, 0, sizeof(struct tty_driver));
 	mxvar_sdriver->magic = TTY_DRIVER_MAGIC;
-	mxvar_sdriver->name = "ttyM";
+	mxvar_sdriver->name = "ttyMI";
 	mxvar_sdriver->major = ttymajor;
 	mxvar_sdriver->minor_start = 0;
 	mxvar_sdriver->num = MXSER_PORTS + 1;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

mxser-correct-tty-driver-name.patch
pci-mxser-pci-refcounts.patch
mxser-make-an-experimental-clone.patch
char-mxser_new-correct-include-file.patch
char-mxser_new-upgrade-to-191.patch
char-mxser_new-rework-to-allow-dynamic-structs.patch
char-mxser_new-use-__devinit-macros.patch
char-mxser_new-pci_request_region-for-pci-regions.patch
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

