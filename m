From: akpm@linux-foundation.org
Subject: + quirk-enable-msi-mapping-on-ht1000.patch added to -mm tree
Date: Tue, 27 Nov 2007 14:21:46 -0800
Message-ID: <200711272221.lARMLkmv002397@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44269 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751745AbXK0WWb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 17:22:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sebastien.dugue@bull.net, acurrid@nvidia.com, akpm@linux-foundation.org, ebiederm@xmission.com, greg@kroah.com, mchan@broadcom.com, pchen@nvidia.com, prakash@punnoor.de


The patch titled
     quirk: enable MSI Mapping on HT1000
has been added to the -mm tree.  Its filename is
     quirk-enable-msi-mapping-on-ht1000.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: quirk: enable MSI Mapping on HT1000
From: Sebastien Dugue <sebastien.dugue@bull.net>

Add a quirk to enable the MSI mapping capability on HyperTransport bridges.

Wire Broadcom's HT1000 to use the quirk.

Signed-off-by: Sebastien Dugue <sebastien.dugue@bull.net>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andy Currid <acurrid@nvidia.com>
Cc: Peer Chen <pchen@nvidia.com>
Cc: Prakash Punnoor <prakash@punnoor.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Michael Chan <mchan@broadcom.com>
Cc: Greg KH <greg@kroah.com>
Cc: Andy Currid <acurrid@nvidia.com>
Cc: Peer Chen <pchen@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/quirks.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff -puN drivers/pci/quirks.c~quirk-enable-msi-mapping-on-ht1000 drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~quirk-enable-msi-mapping-on-ht1000
+++ a/drivers/pci/quirks.c
@@ -1715,6 +1715,33 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SE
 			PCI_DEVICE_ID_SERVERWORKS_HT1000_PXB,
 			quirk_msi_ht_cap);
 
+
+/*
+ *  Force enable MSI mapping capability on HT bridges
+ */
+static void __devinit quirk_msi_ht_cap_enable(struct pci_dev *dev)
+{
+	int pos, ttl = 48;
+
+	pos = pci_find_ht_capability(dev, HT_CAPTYPE_MSI_MAPPING);
+	while (pos && ttl--) {
+		u8 flags;
+
+		if (pci_read_config_byte(dev, pos + HT_MSI_FLAGS, &flags) == 0) {
+			printk(KERN_INFO "PCI: Enabling HT MSI Mapping on %s\n",
+			       pci_name(dev));
+
+			pci_write_config_byte(dev, pos + HT_MSI_FLAGS,
+					      flags | HT_MSI_FLAGS_ENABLE);
+		}
+		pos = pci_find_next_ht_capability(dev, pos,
+						  HT_CAPTYPE_MSI_MAPPING);
+	}
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SERVERWORKS,
+			 PCI_DEVICE_ID_SERVERWORKS_HT1000_PXB,
+			 quirk_msi_ht_cap_enable);
+
 /* The nVidia CK804 chipset may have 2 HT MSI mappings.
  * MSI are supported if the MSI capability set in any of these mappings.
  */
_

Patches currently in -mm which might be from sebastien.dugue@bull.net are

quirk-enable-msi-mapping-on-ht1000.patch
msi-set-en-bit-of-msi-mapping-capability-on-ht-platform.patch
msi-set-en-bit-of-msi-mapping-capability-on-ht-platform-fix.patch
