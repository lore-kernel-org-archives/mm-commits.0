From: akpm@osdl.org
Subject: + via-sb600-sata-quirk.patch added to -mm tree
Date: Wed, 06 Dec 2006 14:39:33 -0800
Message-ID: <200612062239.kB6MdXt7019101@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49965 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937754AbWLFWjr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 6 Dec 2006 17:39:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: conke.hu@gmail.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com, jeff@garzik.org


The patch titled
     via sb600 sata quirk
has been added to the -mm tree.  Its filename is
     via-sb600-sata-quirk.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: via sb600 sata quirk
From: Conke Hu <conke.hu@gmail.com>

Cc: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/pci/quirks.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+)

diff -puN drivers/pci/quirks.c~via-sb600-sata-quirk drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~via-sb600-sata-quirk
+++ a/drivers/pci/quirks.c
@@ -826,6 +826,23 @@ static void quirk_mediagx_master(struct 
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_CYRIX,	PCI_DEVICE_ID_CYRIX_PCI_MASTER, quirk_mediagx_master );
 DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_CYRIX,	PCI_DEVICE_ID_CYRIX_PCI_MASTER, quirk_mediagx_master );
 
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
  *	Ensure C0 rev restreaming is off. This is normally done by
  *	the BIOS but in the odd case it is not the results are corruption
_

Patches currently in -mm which might be from conke.hu@gmail.com are

via-sb600-sata-quirk.patch

