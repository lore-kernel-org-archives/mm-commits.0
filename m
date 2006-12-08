From: akpm@osdl.org
Subject: - char-stallion-convert-to-pci-probing.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:09:33 -0800
Message-ID: <200612082009.kB8K9XQG002716@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58646 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946274AbWLHUJl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:09:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: stallion, convert to pci probing
has been removed from the -mm tree.  Its filename was
     char-stallion-convert-to-pci-probing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: stallion, convert to pci probing
From: Jiri Slaby <jirislaby@gmail.com>

Convert stallion driver to pci probing instead of pci_dev_get iteration.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/stallion.c |  167 +++++++++++++++++++-------------------
 1 file changed, 84 insertions(+), 83 deletions(-)

diff -puN drivers/char/stallion.c~char-stallion-convert-to-pci-probing drivers/char/stallion.c
--- a/drivers/char/stallion.c~char-stallion-convert-to-pci-probing
+++ a/drivers/char/stallion.c
@@ -381,8 +381,6 @@ static spinlock_t stallion_lock;	/* Guar
 
 /*****************************************************************************/
 
-#ifdef CONFIG_PCI
-
 /*
  *	Define the Stallion PCI vendor and device IDs.
  */
@@ -402,22 +400,19 @@ static spinlock_t stallion_lock;	/* Guar
 /*
  *	Define structure to hold all Stallion PCI boards.
  */
-typedef struct stlpcibrd {
-	unsigned short		vendid;
-	unsigned short		devid;
-	int			brdtype;
-} stlpcibrd_t;
-
-static stlpcibrd_t	stl_pcibrds[] = {
-	{ PCI_VENDOR_ID_STALLION, PCI_DEVICE_ID_ECHPCI864, BRD_ECH64PCI },
-	{ PCI_VENDOR_ID_STALLION, PCI_DEVICE_ID_EIOPCI, BRD_EASYIOPCI },
-	{ PCI_VENDOR_ID_STALLION, PCI_DEVICE_ID_ECHPCI832, BRD_ECHPCI },
-	{ PCI_VENDOR_ID_NS, PCI_DEVICE_ID_NS_87410, BRD_ECHPCI },
-};
-
-static int	stl_nrpcibrds = ARRAY_SIZE(stl_pcibrds);
 
-#endif
+static struct pci_device_id stl_pcibrds[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_STALLION, PCI_DEVICE_ID_ECHPCI864),
+		.driver_data = BRD_ECH64PCI },
+	{ PCI_DEVICE(PCI_VENDOR_ID_STALLION, PCI_DEVICE_ID_EIOPCI),
+		.driver_data = BRD_EASYIOPCI },
+	{ PCI_DEVICE(PCI_VENDOR_ID_STALLION, PCI_DEVICE_ID_ECHPCI832),
+		.driver_data = BRD_ECHPCI },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NS, PCI_DEVICE_ID_NS_87410),
+		.driver_data = BRD_ECHPCI },
+	{ }
+};
+MODULE_DEVICE_TABLE(pci, stl_pcibrds);
 
 /*****************************************************************************/
 
@@ -2390,24 +2385,52 @@ static int __init stl_getbrdnr(void)
 	return(-1);
 }
 
-/*****************************************************************************/
-
-#ifdef	CONFIG_PCI
+static void stl_cleanup_panels(struct stlbrd *brdp)
+{
+	struct stlpanel *panelp;
+	struct stlport *portp;
+	unsigned int j, k;
+
+	for (j = 0; j < STL_MAXPANELS; j++) {
+		panelp = brdp->panels[j];
+		if (panelp == NULL)
+			continue;
+		for (k = 0; k < STL_PORTSPERPANEL; k++) {
+			portp = panelp->ports[k];
+			if (portp == NULL)
+				continue;
+			if (portp->tty != NULL)
+				stl_hangup(portp->tty);
+			kfree(portp->tx.buf);
+			kfree(portp);
+		}
+		kfree(panelp);
+	}
+}
 
+/*****************************************************************************/
 /*
  *	We have a Stallion board. Allocate a board structure and
  *	initialize it. Read its IO and IRQ resources from PCI
  *	configuration space.
  */
 
-static int __init stl_initpcibrd(int brdtype, struct pci_dev *devp)
+static int __devinit stl_pciprobe(struct pci_dev *pdev,
+		const struct pci_device_id *ent)
 {
-	struct stlbrd	*brdp;
+	struct stlbrd *brdp;
+	unsigned int brdtype = ent->driver_data;
 
 	pr_debug("stl_initpcibrd(brdtype=%d,busnr=%x,devnr=%x)\n", brdtype,
-		devp->bus->number, devp->devfn);
+		pdev->bus->number, pdev->devfn);
+
+	if ((pdev->class >> 8) == PCI_CLASS_STORAGE_IDE)
+		return -ENODEV;
+
+	dev_info(&pdev->dev, "please, report this to LKML: %x/%x/%x\n",
+			pdev->vendor, pdev->device, pdev->class);
 
-	if (pci_enable_device(devp))
+	if (pci_enable_device(pdev))
 		return(-EIO);
 	if ((brdp = stl_allocbrd()) == NULL)
 		return(-ENOMEM);
@@ -2423,8 +2446,8 @@ static int __init stl_initpcibrd(int brd
  *	so set up io addresses based on board type.
  */
 	pr_debug("%s(%d): BAR[]=%Lx,%Lx,%Lx,%Lx IRQ=%x\n", __FILE__, __LINE__,
-		pci_resource_start(devp, 0), pci_resource_start(devp, 1),
-		pci_resource_start(devp, 2), pci_resource_start(devp, 3), devp->irq);
+		pci_resource_start(pdev, 0), pci_resource_start(pdev, 1),
+		pci_resource_start(pdev, 2), pci_resource_start(pdev, 3), pdev->irq);
 
 /*
  *	We have all resources from the board, so let's setup the actual
@@ -2432,63 +2455,52 @@ static int __init stl_initpcibrd(int brd
  */
 	switch (brdtype) {
 	case BRD_ECHPCI:
-		brdp->ioaddr2 = pci_resource_start(devp, 0);
-		brdp->ioaddr1 = pci_resource_start(devp, 1);
+		brdp->ioaddr2 = pci_resource_start(pdev, 0);
+		brdp->ioaddr1 = pci_resource_start(pdev, 1);
 		break;
 	case BRD_ECH64PCI:
-		brdp->ioaddr2 = pci_resource_start(devp, 2);
-		brdp->ioaddr1 = pci_resource_start(devp, 1);
+		brdp->ioaddr2 = pci_resource_start(pdev, 2);
+		brdp->ioaddr1 = pci_resource_start(pdev, 1);
 		break;
 	case BRD_EASYIOPCI:
-		brdp->ioaddr1 = pci_resource_start(devp, 2);
-		brdp->ioaddr2 = pci_resource_start(devp, 1);
+		brdp->ioaddr1 = pci_resource_start(pdev, 2);
+		brdp->ioaddr2 = pci_resource_start(pdev, 1);
 		break;
 	default:
 		printk("STALLION: unknown PCI board type=%d\n", brdtype);
 		break;
 	}
 
-	brdp->irq = devp->irq;
+	brdp->irq = pdev->irq;
 	stl_brdinit(brdp);
 
+	pci_set_drvdata(pdev, brdp);
+
 	return(0);
 }
 
-/*****************************************************************************/
-
-/*
- *	Find all Stallion PCI boards that might be installed. Initialize each
- *	one as it is found.
- */
-
-
-static int __init stl_findpcibrds(void)
+static void __devexit stl_pciremove(struct pci_dev *pdev)
 {
-	struct pci_dev	*dev = NULL;
-	int		i, rc;
-
-	pr_debug("stl_findpcibrds()\n");
+	struct stlbrd *brdp = pci_get_drvdata(pdev);
 
-	for (i = 0; (i < stl_nrpcibrds); i++)
-		while ((dev = pci_get_device(stl_pcibrds[i].vendid,
-		    stl_pcibrds[i].devid, dev))) {
+	free_irq(brdp->irq, brdp);
 
-/*
- *			Found a device on the PCI bus that has our vendor and
- *			device ID. Need to check now that it is really us.
- */
-			if ((dev->class >> 8) == PCI_CLASS_STORAGE_IDE)
-				continue;
+	stl_cleanup_panels(brdp);
 
-			rc = stl_initpcibrd(stl_pcibrds[i].brdtype, dev);
-			if (rc)
-				return(rc);
-		}
+	release_region(brdp->ioaddr1, brdp->iosize1);
+	if (brdp->iosize2 > 0)
+		release_region(brdp->ioaddr2, brdp->iosize2);
 
-	return(0);
+	stl_brds[brdp->brdnr] = NULL;
+	kfree(brdp);
 }
 
-#endif
+static struct pci_driver stl_pcidriver = {
+	.name = "stallion",
+	.id_table = stl_pcibrds,
+	.probe = stl_pciprobe,
+	.remove = __devexit_p(stl_pciremove)
+};
 
 /*****************************************************************************/
 
@@ -2535,9 +2547,6 @@ static int __init stl_initbrds(void)
  *	line options or auto-detected on the PCI bus.
  */
 	stl_argbrds();
-#ifdef CONFIG_PCI
-	stl_findpcibrds();
-#endif
 
 	return(0);
 }
@@ -4776,7 +4785,7 @@ static void stl_sc26198otherisr(struct s
  */
 static int __init stallion_module_init(void)
 {
-	unsigned int i;
+	unsigned int i, retval;
 
 	printk(KERN_INFO "%s: version %s\n", stl_drvtitle, stl_drvversion);
 
@@ -4785,6 +4794,10 @@ static int __init stallion_module_init(v
 
 	stl_initbrds();
 
+	retval = pci_register_driver(&stl_pcidriver);
+	if (retval)
+		goto err;
+
 	stl_serial = alloc_tty_driver(STL_MAXBRDS * STL_MAXPORTS);
 	if (!stl_serial)
 		return -1;
@@ -4820,14 +4833,14 @@ static int __init stallion_module_init(v
 	}
 
 	return 0;
+err:
+	return retval;
 }
 
 static void __exit stallion_module_exit(void)
 {
 	struct stlbrd	*brdp;
-	struct stlpanel	*panelp;
-	struct stlport	*portp;
-	int		i, j, k;
+	int		i;
 
 	pr_debug("cleanup_module()\n");
 
@@ -4854,27 +4867,15 @@ static void __exit stallion_module_exit(
 			"errno=%d\n", -i);
 	class_destroy(stallion_class);
 
+	pci_unregister_driver(&stl_pcidriver);
+
 	for (i = 0; (i < stl_nrbrds); i++) {
 		if ((brdp = stl_brds[i]) == NULL)
 			continue;
 
 		free_irq(brdp->irq, brdp);
 
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
+		stl_cleanup_panels(brdp);
 
 		release_region(brdp->ioaddr1, brdp->iosize1);
 		if (brdp->iosize2 > 0)
_

Patches currently in -mm which might be from jirislaby@gmail.com are

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

