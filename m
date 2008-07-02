From: akpm@linux-foundation.org
Subject: + edac-mpc85xx-fix-pci-ofdev-2nd-pass.patch added to -mm tree
Date: Wed, 02 Jul 2008 01:33:52 -0700
Message-ID: <200807020833.m628XqGQ007423@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40505 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752716AbYGBIjC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 04:39:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: djiang@mvista.com, dougthompson@xmission.com


The patch titled
     edac: mpc85xx fix pci ofdev 2nd pass
has been added to the -mm tree.  Its filename is
     edac-mpc85xx-fix-pci-ofdev-2nd-pass.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: mpc85xx fix pci ofdev 2nd pass
From: Dave Jiang <djiang@mvista.com>

Convert PCI err device from platform to open firmware of_dev to comply
with powerpc schemes.

Signed-off-by: Dave Jiang <djiang@mvista.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/mpc85xx_edac.c |   67 +++++++++++++++++++++-------------
 1 file changed, 43 insertions(+), 24 deletions(-)

diff -puN drivers/edac/mpc85xx_edac.c~edac-mpc85xx-fix-pci-ofdev-2nd-pass drivers/edac/mpc85xx_edac.c
--- a/drivers/edac/mpc85xx_edac.c~edac-mpc85xx-fix-pci-ofdev-2nd-pass
+++ a/drivers/edac/mpc85xx_edac.c
@@ -195,14 +195,15 @@ static irqreturn_t mpc85xx_pci_isr(int i
 	return IRQ_HANDLED;
 }
 
-static int __devinit mpc85xx_pci_err_probe(struct platform_device *pdev)
+static int __devinit mpc85xx_pci_err_probe(struct of_device *op,
+					   const struct of_device_id *match)
 {
 	struct edac_pci_ctl_info *pci;
 	struct mpc85xx_pci_pdata *pdata;
-	struct resource *r;
+	struct resource r;
 	int res = 0;
 
-	if (!devres_open_group(&pdev->dev, mpc85xx_pci_err_probe, GFP_KERNEL))
+	if (!devres_open_group(&op->dev, mpc85xx_pci_err_probe, GFP_KERNEL))
 		return -ENOMEM;
 
 	pci = edac_pci_alloc_ctl_info(sizeof(*pdata), "mpc85xx_pci_err");
@@ -212,34 +213,37 @@ static int __devinit mpc85xx_pci_err_pro
 	pdata = pci->pvt_info;
 	pdata->name = "mpc85xx_pci_err";
 	pdata->irq = NO_IRQ;
-	platform_set_drvdata(pdev, pci);
-	pci->dev = &pdev->dev;
+ 	dev_set_drvdata(&op->dev, pci);
+ 	pci->dev = &op->dev;
 	pci->mod_name = EDAC_MOD_STR;
 	pci->ctl_name = pdata->name;
-	pci->dev_name = pdev->dev.bus_id;
+	pci->dev_name = op->dev.bus_id;
 
 	if (edac_op_state == EDAC_OPSTATE_POLL)
 		pci->edac_check = mpc85xx_pci_check;
 
 	pdata->edac_idx = edac_pci_idx++;
 
-	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!r) {
+	res = of_address_to_resource(op->node, 0, &r);
+	if (res) {
 		printk(KERN_ERR "%s: Unable to get resource for "
 		       "PCI err regs\n", __func__);
 		goto err;
 	}
 
-	if (!devm_request_mem_region(&pdev->dev, r->start,
-				     r->end - r->start + 1, pdata->name)) {
+	/* we only need the error registers */
+	r.start += 0xe00;
+
+	if (!devm_request_mem_region(&op->dev, r.start,
+ 				     r.end - r.start + 1, pdata->name)) {
 		printk(KERN_ERR "%s: Error while requesting mem region\n",
 		       __func__);
 		res = -EBUSY;
 		goto err;
 	}
 
-	pdata->pci_vbase = devm_ioremap(&pdev->dev, r->start,
-					r->end - r->start + 1);
+	pdata->pci_vbase = devm_ioremap(&op->dev, r.start,
+					r.end - r.start + 1);
 	if (!pdata->pci_vbase) {
 		printk(KERN_ERR "%s: Unable to setup PCI err regs\n", __func__);
 		res = -ENOMEM;
@@ -266,14 +270,15 @@ static int __devinit mpc85xx_pci_err_pro
 	}
 
 	if (edac_op_state == EDAC_OPSTATE_INT) {
-		pdata->irq = platform_get_irq(pdev, 0);
-		res = devm_request_irq(&pdev->dev, pdata->irq,
+		pdata->irq = irq_of_parse_and_map(op->node, 0);
+		res = devm_request_irq(&op->dev, pdata->irq,
 				       mpc85xx_pci_isr, IRQF_DISABLED,
 				       "[EDAC] PCI err", pci);
 		if (res < 0) {
 			printk(KERN_ERR
 			       "%s: Unable to requiest irq %d for "
 			       "MPC85xx PCI err\n", __func__, pdata->irq);
+			irq_dispose_mapping(pdata->irq);
 			res = -ENODEV;
 			goto err2;
 		}
@@ -282,23 +287,23 @@ static int __devinit mpc85xx_pci_err_pro
 		       pdata->irq);
 	}
 
-	devres_remove_group(&pdev->dev, mpc85xx_pci_err_probe);
+	devres_remove_group(&op->dev, mpc85xx_pci_err_probe);
 	debugf3("%s(): success\n", __func__);
 	printk(KERN_INFO EDAC_MOD_STR " PCI err registered\n");
 
 	return 0;
 
 err2:
-	edac_pci_del_device(&pdev->dev);
+	edac_pci_del_device(&op->dev);
 err:
 	edac_pci_free_ctl_info(pci);
-	devres_release_group(&pdev->dev, mpc85xx_pci_err_probe);
+	devres_release_group(&op->dev, mpc85xx_pci_err_probe);
 	return res;
 }
 
-static int mpc85xx_pci_err_remove(struct platform_device *pdev)
+static int mpc85xx_pci_err_remove(struct of_device *op)
 {
-	struct edac_pci_ctl_info *pci = platform_get_drvdata(pdev);
+	struct edac_pci_ctl_info *pci = dev_get_drvdata(&op->dev);
 	struct mpc85xx_pci_pdata *pdata = pci->pvt_info;
 
 	debugf0("%s()\n", __func__);
@@ -318,12 +323,26 @@ static int mpc85xx_pci_err_remove(struct
 	return 0;
 }
 
-static struct platform_driver mpc85xx_pci_err_driver = {
+static struct of_device_id mpc85xx_pci_err_of_match[] = {
+	{
+	 .compatible = "fsl,mpc8540-pcix",
+	 },
+	{
+	 .compatible = "fsl,mpc8540-pci",
+	},
+	{},
+};
+
+static struct of_platform_driver mpc85xx_pci_err_driver = {
+	.owner = THIS_MODULE,
+	.name = "mpc85xx_pci_err",
+	.match_table = mpc85xx_pci_err_of_match,
 	.probe = mpc85xx_pci_err_probe,
 	.remove = __devexit_p(mpc85xx_pci_err_remove),
 	.driver = {
-		.name = "mpc85xx_pci_err",
-	}
+		   .name = "mpc85xx_pci_err",
+		   .owner = THIS_MODULE,
+		   },
 };
 
 #endif				/* CONFIG_PCI */
@@ -1002,7 +1021,7 @@ static int __init mpc85xx_mc_init(void)
 		printk(KERN_WARNING EDAC_MOD_STR "L2 fails to register\n");
 
 #ifdef CONFIG_PCI
-	res = platform_driver_register(&mpc85xx_pci_err_driver);
+	res = of_register_platform_driver(&mpc85xx_pci_err_driver);
 	if (res)
 		printk(KERN_WARNING EDAC_MOD_STR "PCI fails to register\n");
 #endif
@@ -1025,7 +1044,7 @@ static void __exit mpc85xx_mc_exit(void)
 {
 	mtspr(SPRN_HID1, orig_hid1);
 #ifdef CONFIG_PCI
-	platform_driver_unregister(&mpc85xx_pci_err_driver);
+	of_unregister_platform_driver(&mpc85xx_pci_err_driver);
 #endif
 	of_unregister_platform_driver(&mpc85xx_l2_err_driver);
 	of_unregister_platform_driver(&mpc85xx_mc_err_driver);
_

Patches currently in -mm which might be from djiang@mvista.com are

edac-mv64x60-fix-get_property.patch
edac-mv64x60-add-pci-fixup.patch
edac-mpc85xx-fix-pci-ofdev-2nd-pass.patch

