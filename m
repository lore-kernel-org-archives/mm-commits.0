From: akpm@osdl.org
Subject: - via-sb600-sata-quirk.patch removed from -mm tree
Date: Wed, 20 Dec 2006 16:37:03 -0800
Message-ID: <200612210037.kBL0b3Pq011259@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53435 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161122AbWLUAhR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Dec 2006 19:37:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: conke.hu@gmail.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     ATI sb600 sata quirk
has been removed from the -mm tree.  Its filename was
     via-sb600-sata-quirk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ATI sb600 sata quirk
From: Conke Hu <conke.hu@gmail.com>

Cc: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ide/pci/atiixp.c |    1 -
 drivers/pci/quirks.c     |   17 +++++++++++++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff -puN drivers/ide/pci/atiixp.c~via-sb600-sata-quirk drivers/ide/pci/atiixp.c
--- a/drivers/ide/pci/atiixp.c~via-sb600-sata-quirk
+++ a/drivers/ide/pci/atiixp.c
@@ -368,7 +368,6 @@ static struct pci_device_id atiixp_pci_t
 	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP300_IDE, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP400_IDE, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP600_IDE, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP600_SATA, PCI_ANY_ID, PCI_ANY_ID, (PCI_CLASS_STORAGE_IDE<<8)|0x8a, 0xffff05, 1},
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, atiixp_pci_tbl);
diff -puN drivers/pci/quirks.c~via-sb600-sata-quirk drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~via-sb600-sata-quirk
+++ a/drivers/pci/quirks.c
@@ -850,6 +850,23 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_IN
 DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82454NX,	quirk_disable_pxb );
 
 
+static void __devinit quirk_sb600_sata(struct pci_dev *pdev)
+{
+	/* set sb600 sata to ahci mode */
+	if ((pdev->class >> 8) == PCI_CLASS_STORAGE_IDE) {
+		u8 tmp;
+
+		pci_read_config_byte(pdev, 0x40, &tmp);
+		pci_write_config_byte(pdev, 0x40, tmp|1);
+		pci_write_config_byte(pdev, 0x9, 1);
+		pci_write_config_byte(pdev, 0xa, 6);
+		pci_write_config_byte(pdev, 0x40, tmp);
+
+		pdev->class = 0x010601;
+	}
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP600_SATA, quirk_sb600_sata);
+
 /*
  *	Serverworks CSB5 IDE does not fully support native mode
  */
_

Patches currently in -mm which might be from conke.hu@gmail.com are


