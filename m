From: akpm@linux-foundation.org
Subject: + tpm_tis-fix-interrupt-probing.patch added to -mm tree
Date: Tue, 31 Jul 2007 14:44:29 -0700
Message-ID: <200707312144.l6VLiTt4024159@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51973 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756904AbXGaVoj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 17:44:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, valdis.kletnieks@vt.edu


The patch titled
     tpm_tis: fix interrupt probing
has been added to the -mm tree.  Its filename is
     tpm_tis-fix-interrupt-probing.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tpm_tis: fix interrupt probing
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

<stuff goes here>

Tested-by: <valdis.kletnieks@vt.edu>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm_tis.c |   22 +++++++++++++---------
 1 files changed, 13 insertions(+), 9 deletions(-)

diff -puN drivers/char/tpm/tpm_tis.c~tpm_tis-fix-interrupt-probing drivers/char/tpm/tpm_tis.c
--- a/drivers/char/tpm/tpm_tis.c~tpm_tis-fix-interrupt-probing
+++ a/drivers/char/tpm/tpm_tis.c
@@ -433,17 +433,12 @@ module_param(interrupts, bool, 0444);
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
 
@@ -510,7 +505,9 @@ static int tpm_tis_init(struct device *d
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
@@ -595,10 +592,17 @@ static int __devinit tpm_tis_pnp_init(st
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
@@ -658,7 +662,7 @@ static int __init init_tis(void)
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
revert-x86-serial-convert-legacy-com-ports-to-platform-devices.patch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr.patch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr-fix.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch
move-free-pages-between-lists-on-steal.patch
convert-ill-defined-log2-to-ilog2.patch
tpm_tis-fix-interrupt-probing.patch
