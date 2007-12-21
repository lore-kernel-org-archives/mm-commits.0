From: akpm@linux-foundation.org
Subject: - quirk-enable-msi-mapping-on-ht1000.patch removed from -mm tree
Date: Fri, 21 Dec 2007 14:08:14 -0800
Message-ID: <200712212208.lBLM8EaK001698@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37729 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756312AbXLUWJc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Dec 2007 17:09:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sebastien.dugue@bull.net, acurrid@nvidia.com, akpm@linux-foundation.org, ebiederm@xmission.com, greg@kroah.com, mchan@broadcom.com, pchen@nvidia.com, prakash@punnoor.de, mm-commits@vg


The patch titled
     quirk: enable MSI Mapping on HT1000
has been removed from the -mm tree.  Its filename was
     quirk-enable-msi-mapping-on-ht1000.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 drivers/pci/quirks.c |   30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff -puN drivers/pci/quirks.c~quirk-enable-msi-mapping-on-ht1000 drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~quirk-enable-msi-mapping-on-ht1000
+++ a/drivers/pci/quirks.c
@@ -1711,9 +1711,33 @@ static void __devinit quirk_msi_ht_cap(s
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_HT2000_PCIE,
 			quirk_msi_ht_cap);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS,
-			PCI_DEVICE_ID_SERVERWORKS_HT1000_PXB,
-			quirk_msi_ht_cap);
+
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
 
 /* The nVidia CK804 chipset may have 2 HT MSI mappings.
  * MSI are supported if the MSI capability set in any of these mappings.
_

Patches currently in -mm which might be from sebastien.dugue@bull.net are
