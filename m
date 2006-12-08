From: akpm@osdl.org
Subject: - char-mxser_new-debug-printk-dependent-on-debug.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:07:02 -0800
Message-ID: <200612082007.kB8K721X002473@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57810 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426347AbWLHUHH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:07:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: mxser_new, debug printk dependent on DEBUG
has been removed from the -mm tree.  Its filename was
     char-mxser_new-debug-printk-dependent-on-debug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: mxser_new, debug printk dependent on DEBUG
From: Jiri Slaby <jirislaby@gmail.com>

Print some debug info only when DEBUG is enabled (use pr_debug macro). 
Eliminate verbose kernel parameter which takes care of this.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/mxser_new.c |   19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff -puN drivers/char/mxser_new.c~char-mxser_new-debug-printk-dependent-on-debug drivers/char/mxser_new.c
--- a/drivers/char/mxser_new.c~char-mxser_new-debug-printk-dependent-on-debug
+++ a/drivers/char/mxser_new.c
@@ -244,7 +244,6 @@ MODULE_DEVICE_TABLE(pci, mxser_pcibrds);
 static int ioaddr[MXSER_BOARDS] = { 0, 0, 0, 0 };
 static int ttymajor = MXSERMAJOR;
 static int calloutmajor = MXSERCUMAJOR;
-static int verbose = 0;
 
 /* Variables for insmod */
 
@@ -252,7 +251,6 @@ MODULE_AUTHOR("Casper Yang");
 MODULE_DESCRIPTION("MOXA Smartio/Industio Family Multiport Board Device Driver");
 module_param_array(ioaddr, int, NULL, 0);
 module_param(ttymajor, int, 0);
-module_param(verbose, bool, 0);
 MODULE_LICENSE("GPL");
 
 struct mxser_log {
@@ -493,11 +491,9 @@ static int __init mxser_module_init(void
 {
 	int ret;
 
-	if (verbose)
-		printk(KERN_DEBUG "Loading module mxser ...\n");
+	pr_debug("Loading module mxser ...\n");
 	ret = mxser_init();
-	if (verbose)
-		printk(KERN_DEBUG "Done.\n");
+	pr_debug("Done.\n");
 	return ret;
 }
 
@@ -505,8 +501,7 @@ static void __exit mxser_module_exit(voi
 {
 	int i, err;
 
-	if (verbose)
-		printk(KERN_DEBUG "Unloading module mxser ...\n");
+	pr_debug("Unloading module mxser ...\n");
 
 	err = tty_unregister_driver(mxvar_sdriver);
 	if (!err)
@@ -532,8 +527,7 @@ static void __exit mxser_module_exit(voi
 			}
 		}
 	}
-	if (verbose)
-		printk(KERN_DEBUG "Done.\n");
+	pr_debug("Done.\n");
 }
 
 static void process_txrx_fifo(struct mxser_port *info)
@@ -562,10 +556,7 @@ static int __devinit mxser_initbrd(struc
 	unsigned int i;
 	int retval;
 
-	/*if (verbose) */  {
-		printk(" max. baud rate = %d bps.\n",
-			brd->ports[0].max_baud);
-	}
+	printk(KERN_INFO "max. baud rate = %d bps.\n", brd->ports[0].max_baud);
 
 	for (i = 0; i < brd->nports; i++) {
 		info = &brd->ports[i];
_

Patches currently in -mm which might be from jirislaby@gmail.com are

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

