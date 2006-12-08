From: akpm@osdl.org
Subject: - char-istallion-correct-fail-paths.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:10:20 -0800
Message-ID: <200612082010.kB8KAKcv002799@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58769 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946512AbWLHUK0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:10:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: istallion, correct fail paths
has been removed from the -mm tree.  Its filename was
     char-istallion-correct-fail-paths.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: istallion, correct fail paths
From: Jiri Slaby <jirislaby@gmail.com>

Check more retvals and react somehow.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/istallion.c |  142 +++++++++++++++++++++----------------
 1 file changed, 81 insertions(+), 61 deletions(-)

diff -puN drivers/char/istallion.c~char-istallion-correct-fail-paths drivers/char/istallion.c
--- a/drivers/char/istallion.c~char-istallion-correct-fail-paths
+++ a/drivers/char/istallion.c
@@ -776,11 +776,6 @@ static void __exit istallion_module_exit
 	}
 
 	i = tty_unregister_driver(stli_serial);
-	if (i) {
-		printk("STALLION: failed to un-register tty driver, "
-			"errno=%d\n", -i);
-		return;
-	}
 	put_tty_driver(stli_serial);
 	for (j = 0; j < 4; j++)
 		class_device_destroy(istallion_class, MKDEV(STL_SIOMEMMAJOR, j));
@@ -3278,15 +3273,16 @@ static int stli_initecp(struct stlibrd *
 	cdkecpsig_t __iomem *sigsp;
 	unsigned int status, nxtid;
 	char *name;
-	int panelnr, nrports;
+	int retval, panelnr, nrports;
 
-	if (!request_region(brdp->iobase, brdp->iosize, "istallion"))
-		return -EIO;
-	
-	if ((brdp->iobase == 0) || (brdp->memaddr == 0))
-	{
-		release_region(brdp->iobase, brdp->iosize);
-		return -ENODEV;
+	if ((brdp->iobase == 0) || (brdp->memaddr == 0)) {
+		retval = -ENODEV;
+		goto err;
+	}
+
+	if (!request_region(brdp->iobase, brdp->iosize, "istallion")) {
+		retval = -EIO;
+		goto err;
 	}
 
 	brdp->iosize = ECP_IOSIZE;
@@ -3350,8 +3346,8 @@ static int stli_initecp(struct stlibrd *
 		break;
 
 	default:
-		release_region(brdp->iobase, brdp->iosize);
-		return -EINVAL;
+		retval = -EINVAL;
+		goto err_reg;
 	}
 
 /*
@@ -3363,10 +3359,9 @@ static int stli_initecp(struct stlibrd *
 	EBRDINIT(brdp);
 
 	brdp->membase = ioremap(brdp->memaddr, brdp->memsize);
-	if (brdp->membase == NULL)
-	{
-		release_region(brdp->iobase, brdp->iosize);
-		return -ENOMEM;
+	if (brdp->membase == NULL) {
+		retval = -ENOMEM;
+		goto err_reg;
 	}
 
 /*
@@ -3379,12 +3374,9 @@ static int stli_initecp(struct stlibrd *
 	memcpy_fromio(&sig, sigsp, sizeof(cdkecpsig_t));
 	EBRDDISABLE(brdp);
 
-	if (sig.magic != cpu_to_le32(ECP_MAGIC))
-	{
-		release_region(brdp->iobase, brdp->iosize);
-		iounmap(brdp->membase);
-		brdp->membase = NULL;
-		return -ENODEV;
+	if (sig.magic != cpu_to_le32(ECP_MAGIC)) {
+		retval = -ENODEV;
+		goto err_unmap;
 	}
 
 /*
@@ -3409,6 +3401,13 @@ static int stli_initecp(struct stlibrd *
 
 	brdp->state |= BST_FOUND;
 	return 0;
+err_unmap:
+	iounmap(brdp->membase);
+	brdp->membase = NULL;
+err_reg:
+	release_region(brdp->iobase, brdp->iosize);
+err:
+	return retval;
 }
 
 /*****************************************************************************/
@@ -3423,18 +3422,22 @@ static int stli_initonb(struct stlibrd *
 	cdkonbsig_t sig;
 	cdkonbsig_t __iomem *sigsp;
 	char *name;
-	int i;
+	int i, retval;
 
 /*
  *	Do a basic sanity check on the IO and memory addresses.
  */
-	if (brdp->iobase == 0 || brdp->memaddr == 0)
-		return -ENODEV;
+	if (brdp->iobase == 0 || brdp->memaddr == 0) {
+		retval = -ENODEV;
+		goto err;
+	}
 
 	brdp->iosize = ONB_IOSIZE;
 	
-	if (!request_region(brdp->iobase, brdp->iosize, "istallion"))
-		return -EIO;
+	if (!request_region(brdp->iobase, brdp->iosize, "istallion")) {
+		retval = -EIO;
+		goto err;
+	}
 
 /*
  *	Based on the specific board type setup the common vars to access
@@ -3500,8 +3503,8 @@ static int stli_initonb(struct stlibrd *
 		break;
 
 	default:
-		release_region(brdp->iobase, brdp->iosize);
-		return -EINVAL;
+		retval = -EINVAL;
+		goto err_reg;
 	}
 
 /*
@@ -3513,10 +3516,9 @@ static int stli_initonb(struct stlibrd *
 	EBRDINIT(brdp);
 
 	brdp->membase = ioremap(brdp->memaddr, brdp->memsize);
-	if (brdp->membase == NULL)
-	{
-		release_region(brdp->iobase, brdp->iosize);
-		return -ENOMEM;
+	if (brdp->membase == NULL) {
+		retval = -ENOMEM;
+		goto err_reg;
 	}
 
 /*
@@ -3532,12 +3534,9 @@ static int stli_initonb(struct stlibrd *
 	if (sig.magic0 != cpu_to_le16(ONB_MAGIC0) ||
 	    sig.magic1 != cpu_to_le16(ONB_MAGIC1) ||
 	    sig.magic2 != cpu_to_le16(ONB_MAGIC2) ||
-	    sig.magic3 != cpu_to_le16(ONB_MAGIC3))
-	{
-		release_region(brdp->iobase, brdp->iosize);
-		iounmap(brdp->membase);
-		brdp->membase = NULL;
-		return -ENODEV;
+	    sig.magic3 != cpu_to_le16(ONB_MAGIC3)) {
+		retval = -ENODEV;
+		goto err_unmap;
 	}
 
 /*
@@ -3559,6 +3558,13 @@ static int stli_initonb(struct stlibrd *
 
 	brdp->state |= BST_FOUND;
 	return 0;
+err_unmap:
+	iounmap(brdp->membase);
+	brdp->membase = NULL;
+err_reg:
+	release_region(brdp->iobase, brdp->iosize);
+err:
+	return retval;
 }
 
 /*****************************************************************************/
@@ -3679,33 +3685,30 @@ stli_donestartup:
 
 static int __devinit stli_brdinit(struct stlibrd *brdp)
 {
+	int retval;
+
 	switch (brdp->brdtype) {
 	case BRD_ECP:
 	case BRD_ECPE:
 	case BRD_ECPMC:
 	case BRD_ECPPCI:
-		stli_initecp(brdp);
+		retval = stli_initecp(brdp);
 		break;
 	case BRD_ONBOARD:
 	case BRD_ONBOARDE:
 	case BRD_ONBOARD2:
 	case BRD_BRUMBY4:
 	case BRD_STALLION:
-		stli_initonb(brdp);
+		retval = stli_initonb(brdp);
 		break;
 	default:
 		printk(KERN_ERR "STALLION: board=%d is unknown board "
 				"type=%d\n", brdp->brdnr, brdp->brdtype);
-		return -ENODEV;
+		retval = -ENODEV;
 	}
 
-	if ((brdp->state & BST_FOUND) == 0) {
-		printk(KERN_ERR "STALLION: %s board not found, board=%d "
-				"io=%x mem=%x\n",
-			stli_brdnames[brdp->brdtype], brdp->brdnr,
-			brdp->iobase, (int) brdp->memaddr);
-		return -ENODEV;
-	}
+	if (retval)
+		return retval;
 
 	stli_initports(brdp);
 	printk(KERN_INFO "STALLION: %s found, board=%d io=%x mem=%x "
@@ -3842,7 +3845,7 @@ static int stli_findeisabrds(void)
 {
 	struct stlibrd *brdp;
 	unsigned int iobase, eid, i;
-	int brdnr;
+	int brdnr, found = 0;
 
 /*
  *	Firstly check if this is an EISA system.  If this is not an EISA system then
@@ -3880,10 +3883,10 @@ static int stli_findeisabrds(void)
  *		Allocate a board structure and initialize it.
  */
 		if ((brdp = stli_allocbrd()) == NULL)
-			return -ENOMEM;
+			return found ? : -ENOMEM;
 		brdnr = stli_getbrdnr();
 		if (brdnr < 0)
-			return -ENOMEM;
+			return found ? : -ENOMEM;
 		brdp->brdnr = (unsigned int)brdnr;
 		eid = inb(iobase + 0xc82);
 		if (eid == ECP_EISAID)
@@ -3896,11 +3899,16 @@ static int stli_findeisabrds(void)
 		outb(0x1, (iobase + 0xc84));
 		if (stli_eisamemprobe(brdp))
 			outb(0, (iobase + 0xc84));
+		if (stli_brdinit(brdp) < 0) {
+			kfree(brdp);
+			continue;
+		}
+
 		stli_brds[brdp->brdnr] = brdp;
-		stli_brdinit(brdp);
+		found++;
 	}
 
-	return 0;
+	return found;
 }
 #else
 static inline int stli_findeisabrds(void) { return 0; }
@@ -4020,7 +4028,7 @@ static int stli_initbrds(void)
 {
 	struct stlibrd *brdp, *nxtbrdp;
 	struct stlconf conf;
-	unsigned int i, j;
+	unsigned int i, j, found = 0;
 	int retval;
 
 	for (stli_nrbrds = 0; stli_nrbrds < ARRAY_SIZE(stli_brdsp);
@@ -4034,14 +4042,24 @@ static int stli_initbrds(void)
 		brdp->brdtype = conf.brdtype;
 		brdp->iobase = conf.ioaddr1;
 		brdp->memaddr = conf.memaddr;
+		if (stli_brdinit(brdp) < 0) {
+			kfree(brdp);
+			continue;
+		}
 		stli_brds[brdp->brdnr] = brdp;
-		stli_brdinit(brdp);
+		found++;
 	}
 
-	stli_findeisabrds();
+	retval = stli_findeisabrds();
+	if (retval > 0)
+		found += retval;
 
 	retval = pci_register_driver(&stli_pcidriver);
-	/* TODO: check retval and do something */
+	if (retval && found == 0) {
+		printk(KERN_ERR "Neither isa nor eisa cards found nor pci "
+				"driver can be registered!\n");
+		goto err;
+	}
 
 /*
  *	All found boards are initialized. Now for a little optimization, if
@@ -4082,6 +4100,8 @@ static int stli_initbrds(void)
 	}
 
 	return 0;
+err:
+	return retval;
 }
 
 /*****************************************************************************/
_

Patches currently in -mm which might be from jirislaby@gmail.com are

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

