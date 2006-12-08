From: akpm@osdl.org
Subject: - char-istallion-change-init-sequence.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:10:26 -0800
Message-ID: <200612082010.kB8KAQxh002808@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58786 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946505AbWLHUKb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:10:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: istallion, change init sequence
has been removed from the -mm tree.  Its filename was
     char-istallion-change-init-sequence.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: istallion, change init sequence
From: Jiri Slaby <jirislaby@gmail.com>

Reorganizate module init and exit and implement logic, when something fails in
these functions.  The former is needed for proper handling dynamic
tty_register_device.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/istallion.c |  130 +++++++++++++++++++++----------------
 1 file changed, 75 insertions(+), 55 deletions(-)

diff -puN drivers/char/istallion.c~char-istallion-change-init-sequence drivers/char/istallion.c
--- a/drivers/char/istallion.c~char-istallion-change-init-sequence
+++ a/drivers/char/istallion.c
@@ -4545,46 +4545,49 @@ static const struct tty_operations stli_
  *	Loadable module initialization stuff.
  */
 
+static void istallion_cleanup_isa(void)
+{
+	struct stlibrd	*brdp;
+	unsigned int j;
+
+	for (j = 0; (j < stli_nrbrds); j++) {
+		if ((brdp = stli_brds[j]) == NULL || (brdp->state & BST_PROBED))
+			continue;
+
+		stli_cleanup_ports(brdp);
+
+		iounmap(brdp->membase);
+		if (brdp->iosize > 0)
+			release_region(brdp->iobase, brdp->iosize);
+		kfree(brdp);
+		stli_brds[j] = NULL;
+	}
+}
+
 static int __init istallion_module_init(void)
 {
-	int i;
+	unsigned int i;
+	int retval;
 
 	printk(KERN_INFO "%s: version %s\n", stli_drvtitle, stli_drvversion);
 
 	spin_lock_init(&stli_lock);
 	spin_lock_init(&brd_lock);
 
-	stli_initbrds();
-
-	stli_serial = alloc_tty_driver(STL_MAXBRDS * STL_MAXPORTS);
-	if (!stli_serial)
-		return -ENOMEM;
-
-/*
- *	Allocate a temporary write buffer.
- */
 	stli_txcookbuf = kmalloc(STLI_TXBUFSIZE, GFP_KERNEL);
-	if (!stli_txcookbuf)
+	if (!stli_txcookbuf) {
 		printk(KERN_ERR "STALLION: failed to allocate memory "
 				"(size=%d)\n", STLI_TXBUFSIZE);
+		retval = -ENOMEM;
+		goto err;
+	}
 
-/*
- *	Set up a character driver for the shared memory region. We need this
- *	to down load the slave code image. Also it is a useful debugging tool.
- */
-	if (register_chrdev(STL_SIOMEMMAJOR, "staliomem", &stli_fsiomem))
-		printk(KERN_ERR "STALLION: failed to register serial memory "
-				"device\n");
-
-	istallion_class = class_create(THIS_MODULE, "staliomem");
-	for (i = 0; i < 4; i++)
-		class_device_create(istallion_class, NULL,
-				MKDEV(STL_SIOMEMMAJOR, i),
-				NULL, "staliomem%d", i);
+	stli_serial = alloc_tty_driver(STL_MAXBRDS * STL_MAXPORTS);
+	if (!stli_serial) {
+		retval = -ENOMEM;
+		goto err_free;
+	}
 
-/*
- *	Set up the tty driver structure and register us as a driver.
- */
 	stli_serial->owner = THIS_MODULE;
 	stli_serial->driver_name = stli_drvname;
 	stli_serial->name = stli_serialname;
@@ -4596,58 +4599,75 @@ static int __init istallion_module_init(
 	stli_serial->flags = TTY_DRIVER_REAL_RAW;
 	tty_set_operations(stli_serial, &stli_ops);
 
-	if (tty_register_driver(stli_serial)) {
-		put_tty_driver(stli_serial);
+	retval = tty_register_driver(stli_serial);
+	if (retval) {
 		printk(KERN_ERR "STALLION: failed to register serial driver\n");
-		return -EBUSY;
+		goto err_ttyput;
+	}
+
+	retval = stli_initbrds();
+	if (retval)
+		goto err_ttyunr;
+
+/*
+ *	Set up a character driver for the shared memory region. We need this
+ *	to down load the slave code image. Also it is a useful debugging tool.
+ */
+	retval = register_chrdev(STL_SIOMEMMAJOR, "staliomem", &stli_fsiomem);
+	if (retval) {
+		printk(KERN_ERR "STALLION: failed to register serial memory "
+				"device\n");
+		goto err_deinit;
 	}
+
+	istallion_class = class_create(THIS_MODULE, "staliomem");
+	for (i = 0; i < 4; i++)
+		class_device_create(istallion_class, NULL,
+				MKDEV(STL_SIOMEMMAJOR, i),
+				NULL, "staliomem%d", i);
+
 	return 0;
+err_deinit:
+	pci_unregister_driver(&stli_pcidriver);
+	istallion_cleanup_isa();
+err_ttyunr:
+	tty_unregister_driver(stli_serial);
+err_ttyput:
+	put_tty_driver(stli_serial);
+err_free:
+	kfree(stli_txcookbuf);
+err:
+	return retval;
 }
 
 /*****************************************************************************/
 
 static void __exit istallion_module_exit(void)
 {
-	struct stlibrd	*brdp;
 	unsigned int j;
-	int		i;
 
 	printk(KERN_INFO "Unloading %s: version %s\n", stli_drvtitle,
 		stli_drvversion);
 
-	pci_unregister_driver(&stli_pcidriver);
-	/*
-	 *	Free up all allocated resources used by the ports. This includes
-	 *	memory and interrupts.
-	 */
 	if (stli_timeron) {
 		stli_timeron = 0;
 		del_timer_sync(&stli_timerlist);
 	}
 
-	i = tty_unregister_driver(stli_serial);
-	put_tty_driver(stli_serial);
+	unregister_chrdev(STL_SIOMEMMAJOR, "staliomem");
+
 	for (j = 0; j < 4; j++)
-		class_device_destroy(istallion_class, MKDEV(STL_SIOMEMMAJOR, j));
+		class_device_destroy(istallion_class, MKDEV(STL_SIOMEMMAJOR,
+					j));
 	class_destroy(istallion_class);
-	if ((i = unregister_chrdev(STL_SIOMEMMAJOR, "staliomem")))
-		printk("STALLION: failed to un-register serial memory device, "
-			"errno=%d\n", -i);
-
-	kfree(stli_txcookbuf);
 
-	for (j = 0; (j < stli_nrbrds); j++) {
-		if ((brdp = stli_brds[j]) == NULL || (brdp->state & BST_PROBED))
-			continue;
+	pci_unregister_driver(&stli_pcidriver);
+	istallion_cleanup_isa();
 
-		stli_cleanup_ports(brdp);
+	tty_unregister_driver(stli_serial);
+	put_tty_driver(stli_serial);
 
-		iounmap(brdp->membase);
-		if (brdp->iosize > 0)
-			release_region(brdp->iobase, brdp->iosize);
-		kfree(brdp);
-		stli_brds[j] = NULL;
-	}
+	kfree(stli_txcookbuf);
 }
 
 module_init(istallion_module_init);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

char-istallion-change-init-sequence.patch
char-istallion-dynamic-tty-device.patch
char-istallion-use-mod_timer.patch
char-cyclades-save-indent-levels.patch
char-cyclades-lindent-the-code.patch
char-cyclades-cleanup.patch
char-cyclades-fix-warnings.patch

