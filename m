From: akpm@linux-foundation.org
Subject: - char-stallion-alloc-tty-before-pci-devices-init.patch removed from -mm tree
Date: Tue, 12 Jun 2007 11:57:02 -0700
Message-ID: <200706121857.l5CIv22m018439@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34122 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753338AbXFLS5R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 14:57:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, ingo@akana.de, mm-commits@vger.kernel.org


The patch titled
     Char: stallion, alloc tty before pci devices init
has been removed from the -mm tree.  Its filename was
     char-stallion-alloc-tty-before-pci-devices-init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: stallion, alloc tty before pci devices init
From: Jiri Slaby <jirislaby@gmail.com>

this causes oops, because pci probe function calls tty_register_device for
each device found. Thanks to Ingo.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: "Ingo Korb" <ingo@akana.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/stallion.c |   73 +++++++++++++++++---------------------
 1 files changed, 34 insertions(+), 39 deletions(-)

diff -puN drivers/char/stallion.c~char-stallion-alloc-tty-before-pci-devices-init drivers/char/stallion.c
--- a/drivers/char/stallion.c~char-stallion-alloc-tty-before-pci-devices-init
+++ a/drivers/char/stallion.c
@@ -4710,6 +4710,29 @@ static int __init stallion_module_init(v
 	spin_lock_init(&stallion_lock);
 	spin_lock_init(&brd_lock);
 
+	stl_serial = alloc_tty_driver(STL_MAXBRDS * STL_MAXPORTS);
+	if (!stl_serial) {
+		retval = -ENOMEM;
+		goto err;
+	}
+
+	stl_serial->owner = THIS_MODULE;
+	stl_serial->driver_name = stl_drvname;
+	stl_serial->name = "ttyE";
+	stl_serial->major = STL_SERIALMAJOR;
+	stl_serial->minor_start = 0;
+	stl_serial->type = TTY_DRIVER_TYPE_SERIAL;
+	stl_serial->subtype = SERIAL_TYPE_NORMAL;
+	stl_serial->init_termios = stl_deftermios;
+	stl_serial->flags = TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV;
+	tty_set_operations(stl_serial, &stl_ops);
+
+	retval = tty_register_driver(stl_serial);
+	if (retval) {
+		printk("STALLION: failed to register serial driver\n");
+		goto err_frtty;
+	}
+
 /*
  *	Find any dynamically supported boards. That is via module load
  *	line options.
@@ -4739,13 +4762,9 @@ static int __init stallion_module_init(v
 
 	/* this has to be _after_ isa finding because of locking */
 	retval = pci_register_driver(&stl_pcidriver);
-	if (retval && stl_nrbrds == 0)
-		goto err;
-
-	stl_serial = alloc_tty_driver(STL_MAXBRDS * STL_MAXPORTS);
-	if (!stl_serial) {
-		retval = -ENOMEM;
-		goto err_pcidr;
+	if (retval && stl_nrbrds == 0) {
+		printk(KERN_ERR "STALLION: can't register pci driver\n");
+		goto err_unrtty;
 	}
 
 /*
@@ -4756,43 +4775,18 @@ static int __init stallion_module_init(v
 		printk("STALLION: failed to register serial board device\n");
 
 	stallion_class = class_create(THIS_MODULE, "staliomem");
-	if (IS_ERR(stallion_class)) {
-		retval = PTR_ERR(stallion_class);
-		goto err_reg;
-	}
+	if (IS_ERR(stallion_class))
+		printk("STALLION: failed to create class\n");
 	for (i = 0; i < 4; i++)
 		class_device_create(stallion_class, NULL,
 				    MKDEV(STL_SIOMEMMAJOR, i), NULL,
 				    "staliomem%d", i);
 
-	stl_serial->owner = THIS_MODULE;
-	stl_serial->driver_name = stl_drvname;
-	stl_serial->name = "ttyE";
-	stl_serial->major = STL_SERIALMAJOR;
-	stl_serial->minor_start = 0;
-	stl_serial->type = TTY_DRIVER_TYPE_SERIAL;
-	stl_serial->subtype = SERIAL_TYPE_NORMAL;
-	stl_serial->init_termios = stl_deftermios;
-	stl_serial->flags = TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV;
-	tty_set_operations(stl_serial, &stl_ops);
-
-	retval = tty_register_driver(stl_serial);
-	if (retval) {
-		printk("STALLION: failed to register serial driver\n");
-		goto err_clsdev;
-	}
-
 	return 0;
-err_clsdev:
-	for (i = 0; i < 4; i++)
-		class_device_destroy(stallion_class, MKDEV(STL_SIOMEMMAJOR, i));
-	class_destroy(stallion_class);
-err_reg:
-	unregister_chrdev(STL_SIOMEMMAJOR, "staliomem");
+err_unrtty:
+	tty_unregister_driver(stl_serial);
+err_frtty:
 	put_tty_driver(stl_serial);
-err_pcidr:
-	pci_unregister_driver(&stl_pcidriver);
-	stl_free_isabrds();
 err:
 	return retval;
 }
@@ -4821,8 +4815,6 @@ static void __exit stallion_module_exit(
 			tty_unregister_device(stl_serial,
 				brdp->brdnr * STL_MAXPORTS + j);
 	}
-	tty_unregister_driver(stl_serial);
-	put_tty_driver(stl_serial);
 
 	for (i = 0; i < 4; i++)
 		class_device_destroy(stallion_class, MKDEV(STL_SIOMEMMAJOR, i));
@@ -4834,6 +4826,9 @@ static void __exit stallion_module_exit(
 	pci_unregister_driver(&stl_pcidriver);
 
 	stl_free_isabrds();
+
+	tty_unregister_driver(stl_serial);
+	put_tty_driver(stl_serial);
 }
 
 module_init(stallion_module_init);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
rocketc-fix-unchecked-mutex_lock_interruptible.patch
char-n_hdlc-allow-restartsys-retval-of-tty-write.patch
char-mxser_new-fix-sparse-warning.patch
char-tty_ioctl-use-wait_event_interruptible_timeout.patch
char-tty_ioctl-little-whitespace-cleanup.patch
char-genrtc-use-wait_event_interruptible.patch
char-n_r3964-use-wait_event_interruptible.patch
char-ip2-use-msleep-for-sleeping.patch
drop-an-empty-isicomh-from-being-exported-to-user-space.patch
char-cyclades-add-firmware-loading.patch
char-cyclades-fix-sparse-warning.patch
char-isicom-cleanup-locking.patch
char-isicom-del_timer-at-exit.patch
char-isicom-proper-variables-types.patch
char-moxa-eliminate-busy-waiting.patch
char-specialix-remove-busy-waiting.patch
char-riscom8-eliminate-busy-loop.patch
char-vt-use-kzalloc.patch
char-vt-use-array_size.patch
char-kconfig-mxser_new-remove-experimental-comment.patch
char-stallion-remove-user-class-report-request.patch
shrink_slab-handle-bad-shrinkers.patch
