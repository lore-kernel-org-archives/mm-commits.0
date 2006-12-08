From: akpm@osdl.org
Subject: - char-istallion-move-init-and-exit-code.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:10:24 -0800
Message-ID: <200612082010.kB8KAOrL002805@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58775 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946511AbWLHUK3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:10:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: istallion, move init and exit code
has been removed from the -mm tree.  Its filename was
     char-istallion-move-init-and-exit-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: istallion, move init and exit code
From: Jiri Slaby <jirislaby@gmail.com>

Let's have these function at the end of the driver and expand stli_init
directly into module_init fucntion, since there is nothing other to have
there.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/istallion.c |  113 +++++++++++++++++--------------------
 1 file changed, 52 insertions(+), 61 deletions(-)

diff -puN drivers/char/istallion.c~char-istallion-move-init-and-exit-code drivers/char/istallion.c
--- a/drivers/char/istallion.c~char-istallion-move-init-and-exit-code
+++ a/drivers/char/istallion.c
@@ -595,7 +595,6 @@ static struct pci_driver stli_pcidriver;
  */
 
 static int	stli_parsebrd(struct stlconf *confp, char **argp);
-static int	stli_init(void);
 static int	stli_open(struct tty_struct *tty, struct file *filp);
 static void	stli_close(struct tty_struct *tty, struct file *filp);
 static int	stli_write(struct tty_struct *tty, const unsigned char *buf, int count);
@@ -744,65 +743,6 @@ static void stli_cleanup_ports(struct st
 	}
 }
 
-/*
- *	Loadable module initialization stuff.
- */
-
-static int __init istallion_module_init(void)
-{
-	stli_init();
-	return 0;
-}
-
-/*****************************************************************************/
-
-static void __exit istallion_module_exit(void)
-{
-	struct stlibrd	*brdp;
-	unsigned int j;
-	int		i;
-
-	printk(KERN_INFO "Unloading %s: version %s\n", stli_drvtitle,
-		stli_drvversion);
-
-	pci_unregister_driver(&stli_pcidriver);
-	/*
-	 *	Free up all allocated resources used by the ports. This includes
-	 *	memory and interrupts.
-	 */
-	if (stli_timeron) {
-		stli_timeron = 0;
-		del_timer_sync(&stli_timerlist);
-	}
-
-	i = tty_unregister_driver(stli_serial);
-	put_tty_driver(stli_serial);
-	for (j = 0; j < 4; j++)
-		class_device_destroy(istallion_class, MKDEV(STL_SIOMEMMAJOR, j));
-	class_destroy(istallion_class);
-	if ((i = unregister_chrdev(STL_SIOMEMMAJOR, "staliomem")))
-		printk("STALLION: failed to un-register serial memory device, "
-			"errno=%d\n", -i);
-
-	kfree(stli_txcookbuf);
-
-	for (j = 0; (j < stli_nrbrds); j++) {
-		if ((brdp = stli_brds[j]) == NULL || (brdp->state & BST_PROBED))
-			continue;
-
-		stli_cleanup_ports(brdp);
-
-		iounmap(brdp->membase);
-		if (brdp->iosize > 0)
-			release_region(brdp->iobase, brdp->iosize);
-		kfree(brdp);
-		stli_brds[j] = NULL;
-	}
-}
-
-module_init(istallion_module_init);
-module_exit(istallion_module_exit);
-
 /*****************************************************************************/
 
 /*
@@ -4601,10 +4541,14 @@ static const struct tty_operations stli_
 };
 
 /*****************************************************************************/
+/*
+ *	Loadable module initialization stuff.
+ */
 
-static int __init stli_init(void)
+static int __init istallion_module_init(void)
 {
 	int i;
+
 	printk(KERN_INFO "%s: version %s\n", stli_drvtitle, stli_drvversion);
 
 	spin_lock_init(&stli_lock);
@@ -4661,3 +4605,50 @@ static int __init stli_init(void)
 }
 
 /*****************************************************************************/
+
+static void __exit istallion_module_exit(void)
+{
+	struct stlibrd	*brdp;
+	unsigned int j;
+	int		i;
+
+	printk(KERN_INFO "Unloading %s: version %s\n", stli_drvtitle,
+		stli_drvversion);
+
+	pci_unregister_driver(&stli_pcidriver);
+	/*
+	 *	Free up all allocated resources used by the ports. This includes
+	 *	memory and interrupts.
+	 */
+	if (stli_timeron) {
+		stli_timeron = 0;
+		del_timer_sync(&stli_timerlist);
+	}
+
+	i = tty_unregister_driver(stli_serial);
+	put_tty_driver(stli_serial);
+	for (j = 0; j < 4; j++)
+		class_device_destroy(istallion_class, MKDEV(STL_SIOMEMMAJOR, j));
+	class_destroy(istallion_class);
+	if ((i = unregister_chrdev(STL_SIOMEMMAJOR, "staliomem")))
+		printk("STALLION: failed to un-register serial memory device, "
+			"errno=%d\n", -i);
+
+	kfree(stli_txcookbuf);
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
+module_init(istallion_module_init);
+module_exit(istallion_module_exit);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

char-istallion-move-init-and-exit-code.patch
char-istallion-change-init-sequence.patch
char-istallion-dynamic-tty-device.patch
char-istallion-use-mod_timer.patch
char-cyclades-save-indent-levels.patch
char-cyclades-lindent-the-code.patch
char-cyclades-cleanup.patch
char-cyclades-fix-warnings.patch

