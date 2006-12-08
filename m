From: akpm@osdl.org
Subject: - char-stallion-implement-fail-paths.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:09:39 -0800
Message-ID: <200612082009.kB8K9duR002729@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58658 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946306AbWLHUJp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:09:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: stallion, implement fail paths
has been removed from the -mm tree.  Its filename was
     char-stallion-implement-fail-paths.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: stallion, implement fail paths
From: Jiri Slaby <jirislaby@gmail.com>

This driver expect everything to work.  Implement fail paths logic to release
regions, irq hangler, memory...  if something is in bad state.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/stallion.c |  199 ++++++++++++++++++++++++--------------
 1 file changed, 128 insertions(+), 71 deletions(-)

diff -puN drivers/char/stallion.c~char-stallion-implement-fail-paths drivers/char/stallion.c
--- a/drivers/char/stallion.c~char-stallion-implement-fail-paths
+++ a/drivers/char/stallion.c
@@ -779,7 +779,8 @@ static void __init stl_argbrds(void)
 		brdp->ioaddr2 = conf.ioaddr2;
 		brdp->irq = conf.irq;
 		brdp->irqtype = conf.irqtype;
-		stl_brdinit(brdp);
+		if (stl_brdinit(brdp))
+			kfree(brdp);
 	}
 }
 
@@ -1965,6 +1966,29 @@ static int __init stl_initports(struct s
 	return(0);
 }
 
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
+
 /*****************************************************************************/
 
 /*
@@ -1976,7 +2000,7 @@ static int __init stl_initeio(struct stl
 	struct stlpanel	*panelp;
 	unsigned int	status;
 	char		*name;
-	int		rc;
+	int		retval;
 
 	pr_debug("stl_initeio(brdp=%p)\n", brdp);
 
@@ -2003,18 +2027,20 @@ static int __init stl_initeio(struct stl
 		    (stl_vecmap[brdp->irq] == (unsigned char) 0xff)) {
 			printk("STALLION: invalid irq=%d for brd=%d\n",
 				brdp->irq, brdp->brdnr);
-			return(-EINVAL);
+			retval = -EINVAL;
+			goto err;
 		}
 		outb((stl_vecmap[brdp->irq] | EIO_0WS |
 			((brdp->irqtype) ? EIO_INTLEVEL : EIO_INTEDGE)),
 			brdp->ioctrl);
 	}
 
+	retval = -EBUSY;
 	if (!request_region(brdp->ioaddr1, brdp->iosize1, name)) {
 		printk(KERN_WARNING "STALLION: Warning, board %d I/O address "
 			"%x conflicts with another device\n", brdp->brdnr, 
 			brdp->ioaddr1);
-		return(-EBUSY);
+		goto err;
 	}
 	
 	if (brdp->iosize2 > 0)
@@ -2025,8 +2051,7 @@ static int __init stl_initeio(struct stl
 			printk(KERN_WARNING "STALLION: Warning, also "
 				"releasing board %d I/O address %x \n", 
 				brdp->brdnr, brdp->ioaddr1);
-			release_region(brdp->ioaddr1, brdp->iosize1);
-        		return(-EBUSY);
+			goto err_rel1;
 		}
 
 /*
@@ -2035,6 +2060,7 @@ static int __init stl_initeio(struct stl
 	brdp->clk = CD1400_CLK;
 	brdp->isr = stl_eiointr;
 
+	retval = -ENODEV;
 	switch (status & EIO_IDBITMASK) {
 	case EIO_8PORTM:
 		brdp->clk = CD1400_CLK8M;
@@ -2058,11 +2084,11 @@ static int __init stl_initeio(struct stl
 			brdp->nrports = 16;
 			break;
 		default:
-			return(-ENODEV);
+			goto err_rel2;
 		}
 		break;
 	default:
-		return(-ENODEV);
+		goto err_rel2;
 	}
 
 /*
@@ -2074,7 +2100,8 @@ static int __init stl_initeio(struct stl
 	if (!panelp) {
 		printk(KERN_WARNING "STALLION: failed to allocate memory "
 			"(size=%Zd)\n", sizeof(struct stlpanel));
-		return -ENOMEM;
+		retval = -ENOMEM;
+		goto err_rel2;
 	}
 
 	panelp->magic = STL_PANELMAGIC;
@@ -2098,11 +2125,20 @@ static int __init stl_initeio(struct stl
 	if (request_irq(brdp->irq, stl_intr, IRQF_SHARED, name, brdp) != 0) {
 		printk("STALLION: failed to register interrupt "
 		    "routine for %s irq=%d\n", name, brdp->irq);
-		rc = -ENODEV;
-	} else {
-		rc = 0;
+		retval = -ENODEV;
+		goto err_fr;
 	}
-	return rc;
+
+	return 0;
+err_fr:
+	stl_cleanup_panels(brdp);
+err_rel2:
+	if (brdp->iosize2 > 0)
+		release_region(brdp->ioaddr2, brdp->iosize2);
+err_rel1:
+	release_region(brdp->ioaddr1, brdp->iosize1);
+err:
+	return retval;
 }
 
 /*****************************************************************************/
@@ -2116,7 +2152,7 @@ static int __init stl_initech(struct stl
 {
 	struct stlpanel	*panelp;
 	unsigned int	status, nxtid, ioaddr, conflict;
-	int		panelnr, banknr, i;
+	int		panelnr, banknr, i, retval;
 	char		*name;
 
 	pr_debug("stl_initech(brdp=%p)\n", brdp);
@@ -2136,13 +2172,16 @@ static int __init stl_initech(struct stl
 		brdp->ioctrl = brdp->ioaddr1 + 1;
 		brdp->iostatus = brdp->ioaddr1 + 1;
 		status = inb(brdp->iostatus);
-		if ((status & ECH_IDBITMASK) != ECH_ID)
-			return(-ENODEV);
+		if ((status & ECH_IDBITMASK) != ECH_ID) {
+			retval = -ENODEV;
+			goto err;
+		}
 		if ((brdp->irq < 0) || (brdp->irq > 15) ||
 		    (stl_vecmap[brdp->irq] == (unsigned char) 0xff)) {
 			printk("STALLION: invalid irq=%d for brd=%d\n",
 				brdp->irq, brdp->brdnr);
-			return(-EINVAL);
+			retval = -EINVAL;
+			goto err;
 		}
 		status = ((brdp->ioaddr2 & ECH_ADDR2MASK) >> 1);
 		status |= (stl_vecmap[brdp->irq] << 1);
@@ -2162,13 +2201,16 @@ static int __init stl_initech(struct stl
 		brdp->ioctrl = brdp->ioaddr1 + 0x20;
 		brdp->iostatus = brdp->ioctrl;
 		status = inb(brdp->iostatus);
-		if ((status & ECH_IDBITMASK) != ECH_ID)
-			return(-ENODEV);
+		if ((status & ECH_IDBITMASK) != ECH_ID) {
+			retval = -ENODEV;
+			goto err;
+		}
 		if ((brdp->irq < 0) || (brdp->irq > 15) ||
 		    (stl_vecmap[brdp->irq] == (unsigned char) 0xff)) {
 			printk("STALLION: invalid irq=%d for brd=%d\n",
 				brdp->irq, brdp->brdnr);
-			return(-EINVAL);
+			retval = -EINVAL;
+			goto err;
 		}
 		outb(ECHMC_BRDRESET, brdp->ioctrl);
 		outb(ECHMC_INTENABLE, brdp->ioctrl);
@@ -2195,19 +2237,20 @@ static int __init stl_initech(struct stl
 
 	default:
 		printk("STALLION: unknown board type=%d\n", brdp->brdtype);
-		return(-EINVAL);
-		break;
+		retval = -EINVAL;
+		goto err;
 	}
 
 /*
  *	Check boards for possible IO address conflicts and return fail status 
  * 	if an IO conflict found.
  */
+	retval = -EBUSY;
 	if (!request_region(brdp->ioaddr1, brdp->iosize1, name)) {
 		printk(KERN_WARNING "STALLION: Warning, board %d I/O address "
 			"%x conflicts with another device\n", brdp->brdnr, 
 			brdp->ioaddr1);
-		return(-EBUSY);
+		goto err;
 	}
 	
 	if (brdp->iosize2 > 0)
@@ -2218,8 +2261,7 @@ static int __init stl_initech(struct stl
 			printk(KERN_WARNING "STALLION: Warning, also "
 				"releasing board %d I/O address %x \n", 
 				brdp->brdnr, brdp->ioaddr1);
-			release_region(brdp->ioaddr1, brdp->iosize1);
-			return(-EBUSY);
+			goto err_rel1;
 		}
 
 /*
@@ -2241,12 +2283,12 @@ static int __init stl_initech(struct stl
 		}
 		status = inb(ioaddr + ECH_PNLSTATUS);
 		if ((status & ECH_PNLIDMASK) != nxtid)
-			break;
+			goto err_fr;
 		panelp = kzalloc(sizeof(struct stlpanel), GFP_KERNEL);
 		if (!panelp) {
 			printk("STALLION: failed to allocate memory "
 				"(size=%Zd)\n", sizeof(struct stlpanel));
-			break;
+			goto err_fr;
 		}
 		panelp->magic = STL_PANELMAGIC;
 		panelp->brdnr = brdp->brdnr;
@@ -2294,7 +2336,7 @@ static int __init stl_initech(struct stl
 		brdp->panels[panelnr++] = panelp;
 		if ((brdp->brdtype != BRD_ECHPCI) &&
 		    (ioaddr >= (brdp->ioaddr2 + brdp->iosize2)))
-			break;
+			goto err_fr;
 	}
 
 	brdp->nrpanels = panelnr;
@@ -2306,12 +2348,19 @@ static int __init stl_initech(struct stl
 	if (request_irq(brdp->irq, stl_intr, IRQF_SHARED, name, brdp) != 0) {
 		printk("STALLION: failed to register interrupt "
 		    "routine for %s irq=%d\n", name, brdp->irq);
-		i = -ENODEV;
-	} else {
-		i = 0;
+		retval = -ENODEV;
+		goto err_fr;
 	}
 
-	return(i);
+	return 0;
+err_fr:
+	stl_cleanup_panels(brdp);
+	if (brdp->iosize2 > 0)
+		release_region(brdp->ioaddr2, brdp->iosize2);
+err_rel1:
+	release_region(brdp->ioaddr1, brdp->iosize1);
+err:
+	return retval;
 }
 
 /*****************************************************************************/
@@ -2325,25 +2374,30 @@ static int __init stl_initech(struct stl
 
 static int __init stl_brdinit(struct stlbrd *brdp)
 {
-	int	i;
+	int i, retval;
 
 	pr_debug("stl_brdinit(brdp=%p)\n", brdp);
 
 	switch (brdp->brdtype) {
 	case BRD_EASYIO:
 	case BRD_EASYIOPCI:
-		stl_initeio(brdp);
+		retval = stl_initeio(brdp);
+		if (retval)
+			goto err;
 		break;
 	case BRD_ECH:
 	case BRD_ECHMC:
 	case BRD_ECHPCI:
 	case BRD_ECH64PCI:
-		stl_initech(brdp);
+		retval = stl_initech(brdp);
+		if (retval)
+			goto err;
 		break;
 	default:
 		printk("STALLION: board=%d is unknown board type=%d\n",
 			brdp->brdnr, brdp->brdtype);
-		return(ENODEV);
+		retval = -ENODEV;
+		goto err;
 	}
 
 	stl_brds[brdp->brdnr] = brdp;
@@ -2351,7 +2405,7 @@ static int __init stl_brdinit(struct stl
 		printk("STALLION: %s board not found, board=%d io=%x irq=%d\n",
 			stl_brdnames[brdp->brdtype], brdp->brdnr,
 			brdp->ioaddr1, brdp->irq);
-		return(ENODEV);
+		goto err_free;
 	}
 
 	for (i = 0; (i < STL_MAXPANELS); i++)
@@ -2362,7 +2416,20 @@ static int __init stl_brdinit(struct stl
 		"nrpanels=%d nrports=%d\n", stl_brdnames[brdp->brdtype],
 		brdp->brdnr, brdp->ioaddr1, brdp->irq, brdp->nrpanels,
 		brdp->nrports);
-	return(0);
+
+	return 0;
+err_free:
+	free_irq(brdp->irq, brdp);
+
+	stl_cleanup_panels(brdp);
+
+	release_region(brdp->ioaddr1, brdp->iosize1);
+	if (brdp->iosize2 > 0)
+		release_region(brdp->ioaddr2, brdp->iosize2);
+
+	stl_brds[brdp->brdnr] = NULL;
+err:
+	return retval;
 }
 
 /*****************************************************************************/
@@ -2385,29 +2452,6 @@ static int __init stl_getbrdnr(void)
 	return(-1);
 }
 
-static void stl_cleanup_panels(struct stlbrd *brdp)
-{
-	struct stlpanel *panelp;
-	struct stlport *portp;
-	unsigned int j, k;
-
-	for (j = 0; j < STL_MAXPANELS; j++) {
-		panelp = brdp->panels[j];
-		if (panelp == NULL)
-			continue;
-		for (k = 0; k < STL_PORTSPERPANEL; k++) {
-			portp = panelp->ports[k];
-			if (portp == NULL)
-				continue;
-			if (portp->tty != NULL)
-				stl_hangup(portp->tty);
-			kfree(portp->tx.buf);
-			kfree(portp);
-		}
-		kfree(panelp);
-	}
-}
-
 /*****************************************************************************/
 /*
  *	We have a Stallion board. Allocate a board structure and
@@ -2420,21 +2464,27 @@ static int __devinit stl_pciprobe(struct
 {
 	struct stlbrd *brdp;
 	unsigned int brdtype = ent->driver_data;
+	int retval = -ENODEV;
 
 	if ((pdev->class >> 8) == PCI_CLASS_STORAGE_IDE)
-		return -ENODEV;
+		goto err;
 
 	dev_info(&pdev->dev, "please, report this to LKML: %x/%x/%x\n",
 			pdev->vendor, pdev->device, pdev->class);
 
-	if (pci_enable_device(pdev))
-		return(-EIO);
-	if ((brdp = stl_allocbrd()) == NULL)
-		return(-ENOMEM);
-	if ((brdp->brdnr = stl_getbrdnr()) < 0) {
+	retval = pci_enable_device(pdev);
+	if (retval)
+		goto err;
+	brdp = stl_allocbrd();
+	if (brdp == NULL) {
+		retval = -ENOMEM;
+		goto err;
+	}
+	brdp->brdnr = stl_getbrdnr();
+	if (brdp->brdnr < 0) {
 		dev_err(&pdev->dev, "too many boards found, "
 			"maximum supported %d\n", STL_MAXBRDS);
-		return(0);
+		goto err_fr;
 	}
 	brdp->brdtype = brdtype;
 
@@ -2461,11 +2511,17 @@ static int __devinit stl_pciprobe(struct
 	}
 
 	brdp->irq = pdev->irq;
-	stl_brdinit(brdp);
+	retval = stl_brdinit(brdp);
+	if (retval)
+		goto err_fr;
 
 	pci_set_drvdata(pdev, brdp);
 
-	return(0);
+	return 0;
+err_fr:
+	kfree(brdp);
+err:
+	return retval;
 }
 
 static void __devexit stl_pciremove(struct pci_dev *pdev)
@@ -2528,7 +2584,8 @@ static int __init stl_initbrds(void)
 		brdp->ioaddr2 = confp->ioaddr2;
 		brdp->irq = confp->irq;
 		brdp->irqtype = confp->irqtype;
-		stl_brdinit(brdp);
+		if (stl_brdinit(brdp))
+			kfree(brdp);
 	}
 
 /*
_

Patches currently in -mm which might be from jirislaby@gmail.com are

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

