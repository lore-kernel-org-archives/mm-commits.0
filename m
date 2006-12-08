From: akpm@osdl.org
Subject: - char-mxser_new-register-tty-devices-on-the-fly.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:07:29 -0800
Message-ID: <200612082007.kB8K7TSf002517@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57940 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946064AbWLHUHg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:07:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: mxser_new, register tty devices on the fly
has been removed from the -mm tree.  Its filename was
     char-mxser_new-register-tty-devices-on-the-fly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: mxser_new, register tty devices on the fly
From: Jiri Slaby <jirislaby@gmail.com>

Register tty indexes only for real devices, udev then creates nodes for them
(and only for them).  Move tty_register_driver before probing, to be correct
when calling tty_register_device.  Also tell tty layer by tty_driver flags,
that we are registering devices.

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/mxser_new.c |   38 ++++++++++++++++++++++++++-----------
 1 file changed, 27 insertions(+), 11 deletions(-)

diff -puN drivers/char/mxser_new.c~char-mxser_new-register-tty-devices-on-the-fly drivers/char/mxser_new.c
--- a/drivers/char/mxser_new.c~char-mxser_new-register-tty-devices-on-the-fly
+++ a/drivers/char/mxser_new.c
@@ -2830,12 +2830,19 @@ static int __init mxser_module_init(void
 	mxvar_sdriver->subtype = SERIAL_TYPE_NORMAL;
 	mxvar_sdriver->init_termios = tty_std_termios;
 	mxvar_sdriver->init_termios.c_cflag = B9600|CS8|CREAD|HUPCL|CLOCAL;
-	mxvar_sdriver->flags = TTY_DRIVER_REAL_RAW;
+	mxvar_sdriver->flags = TTY_DRIVER_REAL_RAW|TTY_DRIVER_DYNAMIC_DEV;
 	tty_set_operations(mxvar_sdriver, &mxser_ops);
 	mxvar_sdriver->ttys = mxvar_tty;
 	mxvar_sdriver->termios = mxvar_termios;
 	mxvar_sdriver->termios_locked = mxvar_termios_locked;
 
+	retval = tty_register_driver(mxvar_sdriver);
+	if (retval) {
+		printk(KERN_ERR "Couldn't install MOXA Smartio/Industio family "
+				"tty driver !\n");
+		goto err_put;
+	}
+
 	mxvar_diagflag = 0;
 
 	m = 0;
@@ -2885,6 +2892,10 @@ static int __init mxser_module_init(void
 			if (mxser_initbrd(brd) < 0)
 				continue;
 
+			for (i = 0; i < brd->nports; i++)
+				tty_register_device(mxvar_sdriver,
+					m * MXSER_PORTS_PER_BOARD + i, NULL);
+
 			m++;
 		}
 
@@ -2939,6 +2950,11 @@ static int __init mxser_module_init(void
 			/* mxser_initbrd will hook ISR. */
 			if (mxser_initbrd(brd) < 0)
 				continue;
+			for (i = 0; i < brd->nports; i++)
+				tty_register_device(mxvar_sdriver,
+					m * MXSER_PORTS_PER_BOARD + i,
+					&pdev->dev);
+
 			m++;
 			/* Keep an extra reference if we succeeded. It will
 			   be returned at unload time */
@@ -2946,20 +2962,18 @@ static int __init mxser_module_init(void
 		}
 	}
 
-	retval = tty_register_driver(mxvar_sdriver);
-	if (retval) {
-		printk(KERN_ERR "Couldn't install MOXA Smartio/Industio family"
-				" driver !\n");
-		put_tty_driver(mxvar_sdriver);
-
-		for (i = 0; i < MXSER_BOARDS; i++)
-			if (mxser_boards[i].board_type != -1)
-				mxser_release_res(&mxser_boards[i], 1);
-		return retval;
+	if (!m) {
+		retval = -ENODEV;
+		goto err_unr;
 	}
 
 	pr_debug("Done.\n");
 
+	return 0;
+err_unr:
+	tty_unregister_driver(mxvar_sdriver);
+err_put:
+	put_tty_driver(mxvar_sdriver);
 	return retval;
 }
 
@@ -2969,6 +2983,8 @@ static void __exit mxser_module_exit(voi
 
 	pr_debug("Unloading module mxser ...\n");
 
+	for (i = 0; i < MXSER_PORTS; i++)
+		tty_unregister_device(mxvar_sdriver, i);
 	tty_unregister_driver(mxvar_sdriver);
 	put_tty_driver(mxvar_sdriver);
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

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

