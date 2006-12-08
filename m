From: akpm@osdl.org
Subject: - char-stallion-use-dynamic-dev.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:10:00 -0800
Message-ID: <200612082010.kB8KA0gt002759@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58711 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946402AbWLHUKF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:10:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: stallion, use dynamic dev
has been removed from the -mm tree.  Its filename was
     char-stallion-use-dynamic-dev.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: stallion, use dynamic dev
From: Jiri Slaby <jirislaby@gmail.com>

Use dynamic tty device registering depending on board's port count.  (i ->
retval change is relevant, since gcc complains about signedness of i)

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/stallion.c |   33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff -puN drivers/char/stallion.c~char-stallion-use-dynamic-dev drivers/char/stallion.c
--- a/drivers/char/stallion.c~char-stallion-use-dynamic-dev
+++ a/drivers/char/stallion.c
@@ -2348,7 +2348,7 @@ static int __devinit stl_pciprobe(struct
 		const struct pci_device_id *ent)
 {
 	struct stlbrd *brdp;
-	unsigned int brdtype = ent->driver_data;
+	unsigned int i, brdtype = ent->driver_data;
 	int brdnr, retval = -ENODEV;
 
 	if ((pdev->class >> 8) == PCI_CLASS_STORAGE_IDE)
@@ -2409,6 +2409,10 @@ static int __devinit stl_pciprobe(struct
 
 	pci_set_drvdata(pdev, brdp);
 
+	for (i = 0; i < brdp->nrports; i++)
+		tty_register_device(stl_serial,
+				brdp->brdnr * STL_MAXPORTS + i, &pdev->dev);
+
 	return 0;
 err_null:
 	stl_brds[brdp->brdnr] = NULL;
@@ -2421,6 +2425,7 @@ err:
 static void __devexit stl_pciremove(struct pci_dev *pdev)
 {
 	struct stlbrd *brdp = pci_get_drvdata(pdev);
+	unsigned int i;
 
 	free_irq(brdp->irq, brdp);
 
@@ -2430,6 +2435,10 @@ static void __devexit stl_pciremove(stru
 	if (brdp->iosize2 > 0)
 		release_region(brdp->ioaddr2, brdp->iosize2);
 
+	for (i = 0; i < brdp->nrports; i++)
+		tty_unregister_device(stl_serial,
+				brdp->brdnr * STL_MAXPORTS + i);
+
 	stl_brds[brdp->brdnr] = NULL;
 	kfree(brdp);
 }
@@ -4693,7 +4702,7 @@ static int __init stallion_module_init(v
 {
 	struct stlbrd	*brdp;
 	struct stlconf	conf;
-	unsigned int i;
+	unsigned int i, j;
 	int retval;
 
 	printk(KERN_INFO "%s: version %s\n", stl_drvtitle, stl_drvversion);
@@ -4720,6 +4729,9 @@ static int __init stallion_module_init(v
 		if (stl_brdinit(brdp))
 			kfree(brdp);
 		else {
+			for (j = 0; j < brdp->nrports; j++)
+				tty_register_device(stl_serial,
+					brdp->brdnr * STL_MAXPORTS + j, NULL);
 			stl_brds[brdp->brdnr] = brdp;
 			stl_nrbrds = i + 1;
 		}
@@ -4761,7 +4773,7 @@ static int __init stallion_module_init(v
 	stl_serial->type = TTY_DRIVER_TYPE_SERIAL;
 	stl_serial->subtype = SERIAL_TYPE_NORMAL;
 	stl_serial->init_termios = stl_deftermios;
-	stl_serial->flags = TTY_DRIVER_REAL_RAW;
+	stl_serial->flags = TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV;
 	tty_set_operations(stl_serial, &stl_ops);
 
 	retval = tty_register_driver(stl_serial);
@@ -4787,7 +4799,9 @@ err:
 
 static void __exit stallion_module_exit(void)
 {
-	int		i;
+	struct stlbrd *brdp;
+	unsigned int i, j;
+	int retval;
 
 	pr_debug("cleanup_module()\n");
 
@@ -4800,14 +4814,21 @@ static void __exit stallion_module_exit(
  *	a hangup on every open port - to try to flush out any processes
  *	hanging onto ports.
  */
+	for (i = 0; i < stl_nrbrds; i++) {
+		if ((brdp = stl_brds[i]) == NULL || (brdp->state & STL_PROBED))
+			continue;
+		for (j = 0; j < brdp->nrports; j++)
+			tty_unregister_device(stl_serial,
+				brdp->brdnr * STL_MAXPORTS + j);
+	}
 	tty_unregister_driver(stl_serial);
 	put_tty_driver(stl_serial);
 
 	for (i = 0; i < 4; i++)
 		class_device_destroy(stallion_class, MKDEV(STL_SIOMEMMAJOR, i));
-	if ((i = unregister_chrdev(STL_SIOMEMMAJOR, "staliomem")))
+	if ((retval = unregister_chrdev(STL_SIOMEMMAJOR, "staliomem")))
 		printk("STALLION: failed to un-register serial memory device, "
-			"errno=%d\n", -i);
+			"errno=%d\n", -retval);
 	class_destroy(stallion_class);
 
 	pci_unregister_driver(&stl_pcidriver);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

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

