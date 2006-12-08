From: akpm@osdl.org
Subject: - char-isicom-rename-init-function.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:08:35 -0800
Message-ID: <200612082008.kB8K8Zb5002618@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58270 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946171AbWLHUIo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:08:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Char: isicom, rename init function
has been removed from the -mm tree.  Its filename was
     char-isicom-rename-init-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: isicom, rename init function
From: Jiri Slaby <jirislaby@gmail.com>

Rename init function from setup to init and mark it as __init, not __devinit.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/isicom.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/isicom.c~char-isicom-rename-init-function drivers/char/isicom.c
--- a/drivers/char/isicom.c~char-isicom-rename-init-function
+++ a/drivers/char/isicom.c
@@ -1861,7 +1861,7 @@ static void __devexit isicom_remove(stru
 	release_region(board->base, 16);
 }
 
-static int __devinit isicom_setup(void)
+static int __init isicom_init(void)
 {
 	int retval, idx, channel;
 	struct isi_port *port;
@@ -1965,7 +1965,7 @@ static void __exit isicom_exit(void)
 	put_tty_driver(isicom_normal);
 }
 
-module_init(isicom_setup);
+module_init(isicom_init);
 module_exit(isicom_exit);
 
 MODULE_AUTHOR("MultiTech");
_

Patches currently in -mm which might be from jirislaby@gmail.com are

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

