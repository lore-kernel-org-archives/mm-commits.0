From: akpm@osdl.org
Subject: - char-stallion-move-init-deinit.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:08:04 -0800
Message-ID: <200612082008.kB8K84il002569@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58138 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946092AbWLHUIL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:08:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: stallion, move init/deinit
has been removed from the -mm tree.  Its filename was
     char-stallion-move-init-deinit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: stallion, move init/deinit
From: Jiri Slaby <jirislaby@gmail.com>

- Move code from stl_init into module init function, because calling it was the
  only one thing, that it did.
- Move this code to the end of the driver (usual place for this) to resolve
  dependencies simply -- without prototypes.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/stallion.c |  256 +++++++++++++++++---------------------
 1 file changed, 120 insertions(+), 136 deletions(-)

diff -puN drivers/char/stallion.c~char-stallion-move-init-deinit drivers/char/stallion.c
--- a/drivers/char/stallion.c~char-stallion-move-init-deinit
+++ a/drivers/char/stallion.c
@@ -278,9 +278,6 @@ static struct {
 /*
  *	Define the module agruments.
  */
-MODULE_AUTHOR("Greg Ungerer");
-MODULE_DESCRIPTION("Stallion Multiport Serial Driver");
-MODULE_LICENSE("GPL");
 
 module_param_array(board0, charp, &stl_nargs, 0);
 MODULE_PARM_DESC(board0, "Board 0 config -> name[,ioaddr[,ioaddr2][,irq]]");
@@ -458,7 +455,6 @@ static int	stl_parsebrd(struct stlconf *
 
 static unsigned long stl_atol(char *str);
 
-static int	stl_init(void);
 static int	stl_open(struct tty_struct *tty, struct file *filp);
 static void	stl_close(struct tty_struct *tty, struct file *filp);
 static int	stl_write(struct tty_struct *tty, const unsigned char *buf, int count);
@@ -708,91 +704,9 @@ static const struct file_operations	stl_
 	.ioctl		= stl_memioctl,
 };
 
-/*****************************************************************************/
-
 static struct class *stallion_class;
 
 /*
- *	Loadable module initialization stuff.
- */
-
-static int __init stallion_module_init(void)
-{
-	stl_init();
-	return 0;
-}
-
-/*****************************************************************************/
-
-static void __exit stallion_module_exit(void)
-{
-	struct stlbrd	*brdp;
-	struct stlpanel	*panelp;
-	struct stlport	*portp;
-	int		i, j, k;
-
-	pr_debug("cleanup_module()\n");
-
-	printk(KERN_INFO "Unloading %s: version %s\n", stl_drvtitle,
-		stl_drvversion);
-
-/*
- *	Free up all allocated resources used by the ports. This includes
- *	memory and interrupts. As part of this process we will also do
- *	a hangup on every open port - to try to flush out any processes
- *	hanging onto ports.
- */
-	i = tty_unregister_driver(stl_serial);
-	put_tty_driver(stl_serial);
-	if (i) {
-		printk("STALLION: failed to un-register tty driver, "
-			"errno=%d\n", -i);
-		return;
-	}
-	for (i = 0; i < 4; i++)
-		class_device_destroy(stallion_class, MKDEV(STL_SIOMEMMAJOR, i));
-	if ((i = unregister_chrdev(STL_SIOMEMMAJOR, "staliomem")))
-		printk("STALLION: failed to un-register serial memory device, "
-			"errno=%d\n", -i);
-	class_destroy(stallion_class);
-
-	for (i = 0; (i < stl_nrbrds); i++) {
-		if ((brdp = stl_brds[i]) == NULL)
-			continue;
-
-		free_irq(brdp->irq, brdp);
-
-		for (j = 0; (j < STL_MAXPANELS); j++) {
-			panelp = brdp->panels[j];
-			if (panelp == NULL)
-				continue;
-			for (k = 0; (k < STL_PORTSPERPANEL); k++) {
-				portp = panelp->ports[k];
-				if (portp == NULL)
-					continue;
-				if (portp->tty != NULL)
-					stl_hangup(portp->tty);
-				kfree(portp->tx.buf);
-				kfree(portp);
-			}
-			kfree(panelp);
-		}
-
-		release_region(brdp->ioaddr1, brdp->iosize1);
-		if (brdp->iosize2 > 0)
-			release_region(brdp->ioaddr2, brdp->iosize2);
-
-		kfree(brdp);
-		stl_brds[i] = NULL;
-	}
-}
-
-module_init(stallion_module_init);
-module_exit(stallion_module_exit);
-
-/*****************************************************************************/
-
-/*
  *	Check for any arguments passed in on the module load command line.
  */
 
@@ -2935,55 +2849,6 @@ static const struct tty_operations stl_o
 };
 
 /*****************************************************************************/
-
-static int __init stl_init(void)
-{
-	int i;
-	printk(KERN_INFO "%s: version %s\n", stl_drvtitle, stl_drvversion);
-
-	spin_lock_init(&stallion_lock);
-	spin_lock_init(&brd_lock);
-
-	stl_initbrds();
-
-	stl_serial = alloc_tty_driver(STL_MAXBRDS * STL_MAXPORTS);
-	if (!stl_serial)
-		return -1;
-
-/*
- *	Set up a character driver for per board stuff. This is mainly used
- *	to do stats ioctls on the ports.
- */
-	if (register_chrdev(STL_SIOMEMMAJOR, "staliomem", &stl_fsiomem))
-		printk("STALLION: failed to register serial board device\n");
-
-	stallion_class = class_create(THIS_MODULE, "staliomem");
-	for (i = 0; i < 4; i++)
-		class_device_create(stallion_class, NULL,
-				    MKDEV(STL_SIOMEMMAJOR, i), NULL,
-				    "staliomem%d", i);
-
-	stl_serial->owner = THIS_MODULE;
-	stl_serial->driver_name = stl_drvname;
-	stl_serial->name = "ttyE";
-	stl_serial->major = STL_SERIALMAJOR;
-	stl_serial->minor_start = 0;
-	stl_serial->type = TTY_DRIVER_TYPE_SERIAL;
-	stl_serial->subtype = SERIAL_TYPE_NORMAL;
-	stl_serial->init_termios = stl_deftermios;
-	stl_serial->flags = TTY_DRIVER_REAL_RAW;
-	tty_set_operations(stl_serial, &stl_ops);
-
-	if (tty_register_driver(stl_serial)) {
-		put_tty_driver(stl_serial);
-		printk("STALLION: failed to register serial driver\n");
-		return -1;
-	}
-
-	return 0;
-}
-
-/*****************************************************************************/
 /*                       CD1400 HARDWARE FUNCTIONS                           */
 /*****************************************************************************/
 
@@ -4954,4 +4819,123 @@ static void stl_sc26198otherisr(struct s
 	}
 }
 
-/*****************************************************************************/
+/*
+ *	Loadable module initialization stuff.
+ */
+static int __init stallion_module_init(void)
+{
+	unsigned int i;
+
+	printk(KERN_INFO "%s: version %s\n", stl_drvtitle, stl_drvversion);
+
+	spin_lock_init(&stallion_lock);
+	spin_lock_init(&brd_lock);
+
+	stl_initbrds();
+
+	stl_serial = alloc_tty_driver(STL_MAXBRDS * STL_MAXPORTS);
+	if (!stl_serial)
+		return -1;
+
+/*
+ *	Set up a character driver for per board stuff. This is mainly used
+ *	to do stats ioctls on the ports.
+ */
+	if (register_chrdev(STL_SIOMEMMAJOR, "staliomem", &stl_fsiomem))
+		printk("STALLION: failed to register serial board device\n");
+
+	stallion_class = class_create(THIS_MODULE, "staliomem");
+	for (i = 0; i < 4; i++)
+		class_device_create(stallion_class, NULL,
+				    MKDEV(STL_SIOMEMMAJOR, i), NULL,
+				    "staliomem%d", i);
+
+	stl_serial->owner = THIS_MODULE;
+	stl_serial->driver_name = stl_drvname;
+	stl_serial->name = "ttyE";
+	stl_serial->major = STL_SERIALMAJOR;
+	stl_serial->minor_start = 0;
+	stl_serial->type = TTY_DRIVER_TYPE_SERIAL;
+	stl_serial->subtype = SERIAL_TYPE_NORMAL;
+	stl_serial->init_termios = stl_deftermios;
+	stl_serial->flags = TTY_DRIVER_REAL_RAW;
+	tty_set_operations(stl_serial, &stl_ops);
+
+	if (tty_register_driver(stl_serial)) {
+		put_tty_driver(stl_serial);
+		printk("STALLION: failed to register serial driver\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+static void __exit stallion_module_exit(void)
+{
+	struct stlbrd	*brdp;
+	struct stlpanel	*panelp;
+	struct stlport	*portp;
+	int		i, j, k;
+
+	pr_debug("cleanup_module()\n");
+
+	printk(KERN_INFO "Unloading %s: version %s\n", stl_drvtitle,
+		stl_drvversion);
+
+/*
+ *	Free up all allocated resources used by the ports. This includes
+ *	memory and interrupts. As part of this process we will also do
+ *	a hangup on every open port - to try to flush out any processes
+ *	hanging onto ports.
+ */
+	i = tty_unregister_driver(stl_serial);
+	put_tty_driver(stl_serial);
+	if (i) {
+		printk("STALLION: failed to un-register tty driver, "
+			"errno=%d\n", -i);
+		return;
+	}
+	for (i = 0; i < 4; i++)
+		class_device_destroy(stallion_class, MKDEV(STL_SIOMEMMAJOR, i));
+	if ((i = unregister_chrdev(STL_SIOMEMMAJOR, "staliomem")))
+		printk("STALLION: failed to un-register serial memory device, "
+			"errno=%d\n", -i);
+	class_destroy(stallion_class);
+
+	for (i = 0; (i < stl_nrbrds); i++) {
+		if ((brdp = stl_brds[i]) == NULL)
+			continue;
+
+		free_irq(brdp->irq, brdp);
+
+		for (j = 0; (j < STL_MAXPANELS); j++) {
+			panelp = brdp->panels[j];
+			if (panelp == NULL)
+				continue;
+			for (k = 0; (k < STL_PORTSPERPANEL); k++) {
+				portp = panelp->ports[k];
+				if (portp == NULL)
+					continue;
+				if (portp->tty != NULL)
+					stl_hangup(portp->tty);
+				kfree(portp->tx.buf);
+				kfree(portp);
+			}
+			kfree(panelp);
+		}
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
+module_init(stallion_module_init);
+module_exit(stallion_module_exit);
+
+MODULE_AUTHOR("Greg Ungerer");
+MODULE_DESCRIPTION("Stallion Multiport Serial Driver");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from jirislaby@gmail.com are

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

