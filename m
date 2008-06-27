From: akpm@linux-foundation.org
Subject: + edac-mv64x60-add-pci-fixup.patch added to -mm tree
Date: Fri, 27 Jun 2008 16:09:22 -0700
Message-ID: <200806272309.m5RN9MSl010836@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59040 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932305AbYF0XKR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Jun 2008 19:10:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: djiang@mvista.com


The patch titled
     edac: mv64x60 add pci fixup
has been added to the -mm tree.  Its filename is
     edac-mv64x60-add-pci-fixup.patch

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
Subject: edac: mv64x60 add pci fixup
From: Dave Jiang <djiang@mvista.com>

Fixup of missing bit 0 on 64360 PCIx_ERR_MASK and errata FEr-#11 and
FEr-#16 for the 64460.  Bit 0 must remain 0.

Signed-off-by: Dave Jiang <djiang@mvista.com>
Signed-off-by: Doug Thompson <dougthompson.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/mv64x60_edac.c |   35 ++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff -puN drivers/edac/mv64x60_edac.c~edac-mv64x60-add-pci-fixup drivers/edac/mv64x60_edac.c
--- a/drivers/edac/mv64x60_edac.c~edac-mv64x60-add-pci-fixup
+++ a/drivers/edac/mv64x60_edac.c
@@ -71,6 +71,35 @@ static irqreturn_t mv64x60_pci_isr(int i
 	return IRQ_HANDLED;
 }
 
+/*
+ * Bit 0 of MV64x60_PCIx_ERR_MASK does not exist on the 64360 and because of
+ * errata FEr-#11 and FEr-##16 for the 64460, it should be 0 on that chip as
+ * well.  IOW, don't set bit 0.
+ */
+
+/* Erratum FEr PCI-#16: clear bit 0 of PCI SERRn Mask reg. */
+static int __init mv64x60_pci_fixup(struct platform_device *pdev)
+{
+	struct resource *r;
+	void __iomem *pci_serr;
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	if (!r) {
+		printk(KERN_ERR "%s: Unable to get resource for "
+		       "PCI err regs\n", __func__);
+		return -ENOENT;
+	}
+
+	pci_serr = ioremap(r->start, r->end - r->start + 1);
+	if (!pci_serr)
+		return -ENOMEM;
+
+	out_le32(pci_serr, in_le32(pci_serr) & ~0x1);
+	iounmap(pci_serr);
+
+	return 0;
+}
+
 static int __devinit mv64x60_pci_err_probe(struct platform_device *pdev)
 {
 	struct edac_pci_ctl_info *pci;
@@ -128,6 +157,12 @@ static int __devinit mv64x60_pci_err_pro
 		goto err;
 	}
 
+	res = mv64x60_pci_fixup(pdev);
+	if (res < 0) {
+		printk(KERN_ERR "%s: PCI fixup failed\n", __func__);
+		goto err;
+	}
+
 	out_le32(pdata->pci_vbase + MV64X60_PCI_ERROR_CAUSE, 0);
 	out_le32(pdata->pci_vbase + MV64X60_PCI_ERROR_MASK, 0);
 	out_le32(pdata->pci_vbase + MV64X60_PCI_ERROR_MASK,
_

Patches currently in -mm which might be from djiang@mvista.com are

edac-mv64x60-fix-get_property.patch
edac-mv64x60-add-pci-fixup.patch

