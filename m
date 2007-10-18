From: akpm@linux-foundation.org
Subject: - tpm_tis-fix-interrupt-probing.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:55:02 -0700
Message-ID: <200710180655.l9I6t2QD030572@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32790 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761497AbXJRHqu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:46:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, kjhall@us.ibm.com, tpm@selhorst.net, valdis.kletnieks@vt.edu, mm-commits@vger.kernel.org


The patch titled
     tpm: pay attention to IRQ info from PNP
has been removed from the -mm tree.  Its filename was
     tpm_tis-fix-interrupt-probing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: tpm: pay attention to IRQ info from PNP
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

If we discover the TIS TPM device via PNP, use the PNP IRQ information rather
than probing for an IRQ.  If PNP shows no IRQ, run the TPM in polling mode.

Tested-by: <valdis.kletnieks@vt.edu>
Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Kylene Hall <kjhall@us.ibm.com>
Cc: <tpm@selhorst.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm_tis.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff -puN drivers/char/tpm/tpm_tis.c~tpm_tis-fix-interrupt-probing drivers/char/tpm/tpm_tis.c
--- a/drivers/char/tpm/tpm_tis.c~tpm_tis-fix-interrupt-probing
+++ a/drivers/char/tpm/tpm_tis.c
@@ -435,17 +435,12 @@ module_param(interrupts, bool, 0444);
 MODULE_PARM_DESC(interrupts, "Enable interrupts");
 
 static int tpm_tis_init(struct device *dev, resource_size_t start,
-			resource_size_t len)
+			resource_size_t len, unsigned int irq)
 {
 	u32 vendor, intfcaps, intmask;
 	int rc, i;
 	struct tpm_chip *chip;
 
-	if (!start)
-		start = TIS_MEM_BASE;
-	if (!len)
-		len = TIS_MEM_LEN;
-
 	if (!(chip = tpm_register_hardware(dev, &tpm_tis)))
 		return -ENODEV;
 
@@ -512,7 +507,9 @@ static int tpm_tis_init(struct device *d
 	iowrite32(intmask,
 		  chip->vendor.iobase +
 		  TPM_INT_ENABLE(chip->vendor.locality));
-	if (interrupts) {
+	if (interrupts)
+		chip->vendor.irq = irq;
+	if (interrupts && !chip->vendor.irq) {
 		chip->vendor.irq =
 		    ioread8(chip->vendor.iobase +
 			    TPM_INT_VECTOR(chip->vendor.locality));
@@ -597,10 +594,17 @@ static int __devinit tpm_tis_pnp_init(st
 				      const struct pnp_device_id *pnp_id)
 {
 	resource_size_t start, len;
+	unsigned int irq = 0;
+
 	start = pnp_mem_start(pnp_dev, 0);
 	len = pnp_mem_len(pnp_dev, 0);
 
-	return tpm_tis_init(&pnp_dev->dev, start, len);
+	if (pnp_irq_valid(pnp_dev, 0))
+		irq = pnp_irq(pnp_dev, 0);
+	else
+		interrupts = 0;
+
+	return tpm_tis_init(&pnp_dev->dev, start, len, irq);
 }
 
 static int tpm_tis_pnp_suspend(struct pnp_dev *dev, pm_message_t msg)
@@ -660,7 +664,7 @@ static int __init init_tis(void)
 			return rc;
 		if (IS_ERR(pdev=platform_device_register_simple("tpm_tis", -1, NULL, 0)))
 			return PTR_ERR(pdev);
-		if((rc=tpm_tis_init(&pdev->dev, 0, 0)) != 0) {
+		if((rc=tpm_tis_init(&pdev->dev, TIS_MEM_BASE, TIS_MEM_LEN, 0)) != 0) {
 			platform_device_unregister(pdev);
 			driver_unregister(&tis_drv);
 		}
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

origin.patch
serial-keep-the-dtr-setting-for-serial-console.patch
