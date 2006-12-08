From: akpm@osdl.org
Subject: - char-istallion-convert-to-pci-probing.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:10:03 -0800
Message-ID: <200612082010.kB8KA3dW002769@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58716 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946406AbWLHUKJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:10:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: istallion, convert to pci probing
has been removed from the -mm tree.  Its filename was
     char-istallion-convert-to-pci-probing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: istallion, convert to pci probing
From: Jiri Slaby <jirislaby@gmail.com>

Use probing for pci devices.  Change some __inits to __devinits to use these
functions in probe function.  Create stli_cleanup_ports and move there cleanup
code from module_exit() code to not have duplicite cleanup code.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/istallion.c |  114 +++++++++++++++++++++----------------
 1 file changed, 66 insertions(+), 48 deletions(-)

diff -puN drivers/char/istallion.c~char-istallion-convert-to-pci-probing drivers/char/istallion.c
--- a/drivers/char/istallion.c~char-istallion-convert-to-pci-probing
+++ a/drivers/char/istallion.c
@@ -402,7 +402,6 @@ static int	stli_eisamempsize = ARRAY_SIZ
 /*
  *	Define the Stallion PCI vendor and device IDs.
  */
-#ifdef CONFIG_PCI
 #ifndef	PCI_VENDOR_ID_STALLION
 #define	PCI_VENDOR_ID_STALLION		0x124d
 #endif
@@ -416,7 +415,7 @@ static struct pci_device_id istallion_pc
 };
 MODULE_DEVICE_TABLE(pci, istallion_pci_tbl);
 
-#endif /* CONFIG_PCI */
+static struct pci_driver stli_pcidriver;
 
 /*****************************************************************************/
 
@@ -728,10 +727,6 @@ static int	stli_initonb(stlibrd_t *brdp)
 static int	stli_eisamemprobe(stlibrd_t *brdp);
 static int	stli_initports(stlibrd_t *brdp);
 
-#ifdef	CONFIG_PCI
-static int	stli_initpcibrd(int brdtype, struct pci_dev *devp);
-#endif
-
 /*****************************************************************************/
 
 /*
@@ -768,6 +763,21 @@ static int	stli_timeron;
 
 static struct class *istallion_class;
 
+static void stli_cleanup_ports(stlibrd_t *brdp)
+{
+	stliport_t *portp;
+	unsigned int j;
+
+	for (j = 0; j < STL_MAXPORTS; j++) {
+		portp = brdp->ports[j];
+		if (portp != NULL) {
+			if (portp->tty != NULL)
+				tty_hangup(portp->tty);
+			kfree(portp);
+		}
+	}
+}
+
 /*
  *	Loadable module initialization stuff.
  */
@@ -783,12 +793,12 @@ static int __init istallion_module_init(
 static void __exit istallion_module_exit(void)
 {
 	stlibrd_t	*brdp;
-	stliport_t	*portp;
-	int		i, j;
+	int		i;
 
 	printk(KERN_INFO "Unloading %s: version %s\n", stli_drvtitle,
 		stli_drvversion);
 
+	pci_unregister_driver(&stli_pcidriver);
 	/*
 	 *	Free up all allocated resources used by the ports. This includes
 	 *	memory and interrupts.
@@ -817,14 +827,8 @@ static void __exit istallion_module_exit
 	for (i = 0; (i < stli_nrbrds); i++) {
 		if ((brdp = stli_brds[i]) == NULL)
 			continue;
-		for (j = 0; (j < STL_MAXPORTS); j++) {
-			portp = brdp->ports[j];
-			if (portp != NULL) {
-				if (portp->tty != NULL)
-					tty_hangup(portp->tty);
-				kfree(portp);
-			}
-		}
+
+		stli_cleanup_ports(brdp);
 
 		iounmap(brdp->membase);
 		if (brdp->iosize > 0)
@@ -3777,7 +3781,7 @@ stli_donestartup:
  *	Probe and initialize the specified board.
  */
 
-static int __init stli_brdinit(stlibrd_t *brdp)
+static int __devinit stli_brdinit(stlibrd_t *brdp)
 {
 	stli_brds[brdp->brdnr] = brdp;
 
@@ -4019,58 +4023,72 @@ static int stli_findeisabrds(void)
 
 /*****************************************************************************/
 
-#ifdef	CONFIG_PCI
-
 /*
  *	We have a Stallion board. Allocate a board structure and
  *	initialize it. Read its IO and MEMORY resources from PCI
  *	configuration space.
  */
 
-static int stli_initpcibrd(int brdtype, struct pci_dev *devp)
+static int __devinit stli_pciprobe(struct pci_dev *pdev,
+		const struct pci_device_id *ent)
 {
 	stlibrd_t *brdp;
+	int retval = -EIO;
 
-	if (pci_enable_device(devp))
-		return -EIO;
-	if ((brdp = stli_allocbrd()) == NULL)
-		return -ENOMEM;
-	if ((brdp->brdnr = stli_getbrdnr()) < 0) {
+	retval = pci_enable_device(pdev);
+	if (retval)
+		goto err;
+	brdp = stli_allocbrd();
+	if (brdp == NULL) {
+		retval = -ENOMEM;
+		goto err;
+	}
+	if ((brdp->brdnr = stli_getbrdnr()) < 0) { /* TODO: locking */
 		printk(KERN_INFO "STALLION: too many boards found, "
 			"maximum supported %d\n", STL_MAXBRDS);
-		return 0;
+		retval = -EIO;
+		goto err_fr;
 	}
-	brdp->brdtype = brdtype;
+	brdp->brdtype = BRD_ECPPCI;
 /*
  *	We have all resources from the board, so lets setup the actual
  *	board structure now.
  */
-	brdp->iobase = pci_resource_start(devp, 3);
-	brdp->memaddr = pci_resource_start(devp, 2);
-	stli_brdinit(brdp);
+	brdp->iobase = pci_resource_start(pdev, 3);
+	brdp->memaddr = pci_resource_start(pdev, 2);
+	retval = stli_brdinit(brdp);
+	if (retval)
+		goto err_fr;
+
+	pci_set_drvdata(pdev, brdp);
 
 	return 0;
+err_fr:
+	kfree(brdp);
+err:
+	return retval;
 }
 
-/*****************************************************************************/
+static void stli_pciremove(struct pci_dev *pdev)
+{
+	stlibrd_t *brdp = pci_get_drvdata(pdev);
 
-/*
- *	Find all Stallion PCI boards that might be installed. Initialize each
- *	one as it is found.
- */
+	stli_cleanup_ports(brdp);
 
-static int stli_findpcibrds(void)
-{
-	struct pci_dev *dev = NULL;
+	iounmap(brdp->membase);
+	if (brdp->iosize > 0)
+		release_region(brdp->iobase, brdp->iosize);
 
-	while ((dev = pci_get_device(PCI_VENDOR_ID_STALLION, PCI_DEVICE_ID_ECRA, dev))) {
-		stli_initpcibrd(BRD_ECPPCI, dev);
-	}
-	return 0;
+	stli_brds[brdp->brdnr] = NULL;
+	kfree(brdp);
 }
 
-#endif
-
+static struct pci_driver stli_pcidriver = {
+	.name = "istallion",
+	.id_table = istallion_pci_tbl,
+	.probe = stli_pciprobe,
+	.remove = __devexit_p(stli_pciremove)
+};
 /*****************************************************************************/
 
 /*
@@ -4102,7 +4120,7 @@ static int stli_initbrds(void)
 {
 	stlibrd_t *brdp, *nxtbrdp;
 	stlconf_t *confp;
-	int i, j;
+	int i, j, retval;
 
 	if (stli_nrbrds > STL_MAXBRDS) {
 		printk(KERN_INFO "STALLION: too many boards in configuration "
@@ -4134,9 +4152,9 @@ static int stli_initbrds(void)
 	stli_argbrds();
 	if (STLI_EISAPROBE)
 		stli_findeisabrds();
-#ifdef CONFIG_PCI
-	stli_findpcibrds();
-#endif
+
+	retval = pci_register_driver(&stli_pcidriver);
+	/* TODO: check retval and do something */
 
 /*
  *	All found boards are initialized. Now for a little optimization, if
_

Patches currently in -mm which might be from jirislaby@gmail.com are

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

