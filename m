From: akpm@linux-foundation.org
Subject: - pci-disable-msi-by-default-on-systems-with-serverworks-ht1000-chips.patch removed from -mm tree
Date: Fri, 01 Jun 2007 00:06:50 -0700
Message-ID: <200706010706.l5176ns1004737@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:59364 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752840AbXFAHGx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 03:06:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andy@greyhouse.net, ebiederm@xmission.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     PCI: disable MSI by default on systems with Serverworks HT1000 chips
has been removed from the -mm tree.  Its filename was
     pci-disable-msi-by-default-on-systems-with-serverworks-ht1000-chips.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PCI: disable MSI by default on systems with Serverworks HT1000 chips
From: Andy Gospodarek <andy@greyhouse.net>

I've been seeing lots of messages like these:

eth0: No interrupt was generated using MSI, switching to INTx mode.  Please
report this failure to the PCI maintainer and include system chipset
information.

On several systems that use the following Severworks HT1000 (also sometimes
labeled as a Broadcom chipset as well) bridge chips.  It doesn't appear MSI
works well (if at all) on these systems.

Signed-off-by: Andy Gospodarek <andy@greyhouse.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/quirks.c    |    1 +
 include/linux/pci_ids.h |    1 +
 2 files changed, 2 insertions(+)

diff -puN drivers/pci/quirks.c~pci-disable-msi-by-default-on-systems-with-serverworks-ht1000-chips drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~pci-disable-msi-by-default-on-systems-with-serverworks-ht1000-chips
+++ a/drivers/pci/quirks.c
@@ -1653,6 +1653,7 @@ static void __init quirk_disable_all_msi
 	printk(KERN_WARNING "PCI: MSI quirk detected. MSI deactivated.\n");
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_GCNB_LE, quirk_disable_all_msi);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_HT1000_PCIX, quirk_disable_all_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS400_200, quirk_disable_all_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS480, quirk_disable_all_msi);
 
diff -puN include/linux/pci_ids.h~pci-disable-msi-by-default-on-systems-with-serverworks-ht1000-chips include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~pci-disable-msi-by-default-on-systems-with-serverworks-ht1000-chips
+++ a/include/linux/pci_ids.h
@@ -1438,6 +1438,7 @@
 #define PCI_DEVICE_ID_SERVERWORKS_LE	  0x0009
 #define PCI_DEVICE_ID_SERVERWORKS_GCNB_LE 0x0017
 #define PCI_DEVICE_ID_SERVERWORKS_EPB	  0x0103
+#define PCI_DEVICE_ID_SERVERWORKS_HT1000_PCIX	0x0104
 #define PCI_DEVICE_ID_SERVERWORKS_HT2000_PCIE	0x0132
 #define PCI_DEVICE_ID_SERVERWORKS_OSB4	  0x0200
 #define PCI_DEVICE_ID_SERVERWORKS_CSB5	  0x0201
_

Patches currently in -mm which might be from andy@greyhouse.net are

origin.patch
