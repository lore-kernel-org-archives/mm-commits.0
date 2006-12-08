From: akpm@osdl.org
Subject: - char-stallion-fix-fail-paths.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:09:49 -0800
Message-ID: <200612082009.kB8K9nQ8002744@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58678 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946372AbWLHUJy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:09:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: stallion, fix fail paths
has been removed from the -mm tree.  Its filename was
     char-stallion-fix-fail-paths.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: stallion, fix fail paths
From: Jiri Slaby <jirislaby@gmail.com>

Release everything what was allocated and check return value of isa probing. 
Release only ISA boards in module exit, since pci have their own
pci-probing-remove.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/stallion.c |   81 ++++++++++++++++++++++++--------------
 1 file changed, 52 insertions(+), 29 deletions(-)

diff -puN drivers/char/stallion.c~char-stallion-fix-fail-paths drivers/char/stallion.c
--- a/drivers/char/stallion.c~char-stallion-fix-fail-paths
+++ a/drivers/char/stallion.c
@@ -143,6 +143,8 @@ static struct stlbrd		*stl_brds[STL_MAXB
  *	Not really much here!
  */
 #define	BRD_FOUND	0x1
+#define STL_PROBED	0x2
+
 
 /*
  *	Define the port structure istate flags. These set of flags are
@@ -2388,6 +2390,7 @@ static int __devinit stl_pciprobe(struct
 		goto err_fr;
 	}
 	brdp->brdtype = brdtype;
+	brdp->state |= STL_PROBED;
 
 /*
  *	We have all resources from the board, so let's setup the actual
@@ -4677,6 +4680,28 @@ static void stl_sc26198otherisr(struct s
 	}
 }
 
+static void stl_free_isabrds(void)
+{
+	struct stlbrd *brdp;
+	unsigned int i;
+
+	for (i = 0; i < stl_nrbrds; i++) {
+		if ((brdp = stl_brds[i]) == NULL || (brdp->state & STL_PROBED))
+			continue;
+
+		free_irq(brdp->irq, brdp);
+
+		stl_cleanup_panels(brdp);
+
+		release_region(brdp->ioaddr1, brdp->iosize1);
+		if (brdp->iosize2 > 0)
+			release_region(brdp->ioaddr2, brdp->iosize2);
+
+		kfree(brdp);
+		stl_brds[i] = NULL;
+	}
+}
+
 /*
  *	Loadable module initialization stuff.
  */
@@ -4684,7 +4709,8 @@ static int __init stallion_module_init(v
 {
 	struct stlbrd	*brdp;
 	struct stlconf	conf;
-	unsigned int i, retval;
+	unsigned int i;
+	int retval;
 
 	printk(KERN_INFO "%s: version %s\n", stl_drvtitle, stl_drvversion);
 
@@ -4714,12 +4740,14 @@ static int __init stallion_module_init(v
 	}
 
 	retval = pci_register_driver(&stl_pcidriver);
-	if (retval)
+	if (retval && stl_nrbrds == 0)
 		goto err;
 
 	stl_serial = alloc_tty_driver(STL_MAXBRDS * STL_MAXPORTS);
-	if (!stl_serial)
-		return -1;
+	if (!stl_serial) {
+		retval = -ENOMEM;
+		goto err_pcidr;
+	}
 
 /*
  *	Set up a character driver for per board stuff. This is mainly used
@@ -4729,6 +4757,10 @@ static int __init stallion_module_init(v
 		printk("STALLION: failed to register serial board device\n");
 
 	stallion_class = class_create(THIS_MODULE, "staliomem");
+	if (IS_ERR(stallion_class)) {
+		retval = PTR_ERR(stallion_class);
+		goto err_reg;
+	}
 	for (i = 0; i < 4; i++)
 		class_device_create(stallion_class, NULL,
 				    MKDEV(STL_SIOMEMMAJOR, i), NULL,
@@ -4745,20 +4777,29 @@ static int __init stallion_module_init(v
 	stl_serial->flags = TTY_DRIVER_REAL_RAW;
 	tty_set_operations(stl_serial, &stl_ops);
 
-	if (tty_register_driver(stl_serial)) {
-		put_tty_driver(stl_serial);
+	retval = tty_register_driver(stl_serial);
+	if (retval) {
 		printk("STALLION: failed to register serial driver\n");
-		return -1;
+		goto err_clsdev;
 	}
 
 	return 0;
+err_clsdev:
+	for (i = 0; i < 4; i++)
+		class_device_destroy(stallion_class, MKDEV(STL_SIOMEMMAJOR, i));
+	class_destroy(stallion_class);
+err_reg:
+	unregister_chrdev(STL_SIOMEMMAJOR, "staliomem");
+	put_tty_driver(stl_serial);
+err_pcidr:
+	pci_unregister_driver(&stl_pcidriver);
+	stl_free_isabrds();
 err:
 	return retval;
 }
 
 static void __exit stallion_module_exit(void)
 {
-	struct stlbrd	*brdp;
 	int		i;
 
 	pr_debug("cleanup_module()\n");
@@ -4772,13 +4813,9 @@ static void __exit stallion_module_exit(
  *	a hangup on every open port - to try to flush out any processes
  *	hanging onto ports.
  */
-	i = tty_unregister_driver(stl_serial);
+	tty_unregister_driver(stl_serial);
 	put_tty_driver(stl_serial);
-	if (i) {
-		printk("STALLION: failed to un-register tty driver, "
-			"errno=%d\n", -i);
-		return;
-	}
+
 	for (i = 0; i < 4; i++)
 		class_device_destroy(stallion_class, MKDEV(STL_SIOMEMMAJOR, i));
 	if ((i = unregister_chrdev(STL_SIOMEMMAJOR, "staliomem")))
@@ -4788,21 +4825,7 @@ static void __exit stallion_module_exit(
 
 	pci_unregister_driver(&stl_pcidriver);
 
-	for (i = 0; (i < stl_nrbrds); i++) {
-		if ((brdp = stl_brds[i]) == NULL)
-			continue;
-
-		free_irq(brdp->irq, brdp);
-
-		stl_cleanup_panels(brdp);
-
-		release_region(brdp->ioaddr1, brdp->iosize1);
-		if (brdp->iosize2 > 0)
-			release_region(brdp->ioaddr2, brdp->iosize2);
-
-		kfree(brdp);
-		stl_brds[i] = NULL;
-	}
+	stl_free_isabrds();
 }
 
 module_init(stallion_module_init);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

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

