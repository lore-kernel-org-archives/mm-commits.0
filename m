From: akpm@linux-foundation.org
Subject: + pci-populate-subsystem-vendor-and-device-ids-for-pci-bridges.patch added to -mm tree
Date: Tue, 13 Oct 2009 18:45:19 -0700
Message-ID: <200910140145.n9E1jJW8001156@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49417 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759327AbZJNBqQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Oct 2009 21:46:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gabe.black@ni.com, jbarnes@virtuousgeek.org, mike.hoogendyk@ni.com, shawn.bohrer@ni.com


The patch titled
     pci: populate subsystem vendor and device IDs for PCI-Bridges
has been added to the -mm tree.  Its filename is
     pci-populate-subsystem-vendor-and-device-ids-for-pci-bridges.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci: populate subsystem vendor and device IDs for PCI-Bridges
From: Gabe Black <gabe.black@ni.com>

Populate the subsystem vendor and subsytem device IDs for PCI-PCI bridges
that implement the PCI Subsystem Vendor ID capability.  Previously bridges
left subsystem vendor IDs unpopulated.

Signed-off-by: Gabe Black <gabe.black@ni.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: <shawn.bohrer@ni.com>
Cc: <mike.hoogendyk@ni.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/probe.c      |    6 ++++++
 include/linux/pci_regs.h |    5 +++++
 2 files changed, 11 insertions(+)

diff -puN drivers/pci/probe.c~pci-populate-subsystem-vendor-and-device-ids-for-pci-bridges drivers/pci/probe.c
--- a/drivers/pci/probe.c~pci-populate-subsystem-vendor-and-device-ids-for-pci-bridges
+++ a/drivers/pci/probe.c
@@ -731,6 +731,7 @@ int pci_setup_device(struct pci_dev *dev
 	u32 class;
 	u8 hdr_type;
 	struct pci_slot *slot;
+	int pos = 0;
 
 	if (pci_read_config_byte(dev, PCI_HEADER_TYPE, &hdr_type))
 		return -EIO;
@@ -822,6 +823,11 @@ int pci_setup_device(struct pci_dev *dev
 		dev->transparent = ((dev->class & 0xff) == 1);
 		pci_read_bases(dev, 2, PCI_ROM_ADDRESS1);
 		set_pcie_hotplug_bridge(dev);
+		pos = pci_find_capability(dev, PCI_CAP_ID_SSVID);
+		if (pos) {
+			pci_read_config_word(dev, pos + PCI_SSVID_VENDOR_ID, &dev->subsystem_vendor);
+			pci_read_config_word(dev, pos + PCI_SSVID_DEVICE_ID, &dev->subsystem_device);
+		}
 		break;
 
 	case PCI_HEADER_TYPE_CARDBUS:		    /* CardBus bridge header */
diff -puN include/linux/pci_regs.h~pci-populate-subsystem-vendor-and-device-ids-for-pci-bridges include/linux/pci_regs.h
--- a/include/linux/pci_regs.h~pci-populate-subsystem-vendor-and-device-ids-for-pci-bridges
+++ a/include/linux/pci_regs.h
@@ -365,6 +365,11 @@
 #define  PCI_X_STATUS_266MHZ	0x40000000	/* 266 MHz capable */
 #define  PCI_X_STATUS_533MHZ	0x80000000	/* 533 MHz capable */
 
+/* PCI Bridge Subsystem ID registers */
+
+#define PCI_SSVID_VENDOR_ID     4	/* PCI-Bridge subsystem vendor id register */
+#define PCI_SSVID_DEVICE_ID     6	/* PCI-Bridge subsystem device id register */
+
 /* PCI Express capability registers */
 
 #define PCI_EXP_FLAGS		2	/* Capabilities register */
_

Patches currently in -mm which might be from gabe.black@ni.com are

origin.patch
pci-populate-subsystem-vendor-and-device-ids-for-pci-bridges.patch

