From: akpm@linux-foundation.org
Subject: - irq-irq-and-pci_ids-patch-for-intel-tolapai.patch removed from -mm tree
Date: Sun, 16 Sep 2007 02:27:28 -0700
Message-ID: <200709160927.l8G9RSVj009262@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55104 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752032AbXIPJic (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 05:38:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jason.d.gaston@intel.com, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     irq: irq and pci_ids patch for Intel Tolapai
has been removed from the -mm tree.  Its filename was
     irq-irq-and-pci_ids-patch-for-intel-tolapai.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: irq: irq and pci_ids patch for Intel Tolapai
From: Jason Gaston <jason.d.gaston@intel.com>

Add the Intel Tolapai LPC and SMBus Controller DID's.

(akpm: for 2.6.23 because various other Tolapai patches need this, and they
need to go into various subsystem trees)

Signed-off-by: Jason Gaston <jason.d.gaston@intel.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/pci/irq.c     |    1 +
 include/linux/pci_ids.h |    2 ++
 2 files changed, 3 insertions(+)

diff -puN arch/i386/pci/irq.c~irq-irq-and-pci_ids-patch-for-intel-tolapai arch/i386/pci/irq.c
--- a/arch/i386/pci/irq.c~irq-irq-and-pci_ids-patch-for-intel-tolapai
+++ a/arch/i386/pci/irq.c
@@ -550,6 +550,7 @@ static __init int intel_router_probe(str
 		case PCI_DEVICE_ID_INTEL_ICH9_3:
 		case PCI_DEVICE_ID_INTEL_ICH9_4:
 		case PCI_DEVICE_ID_INTEL_ICH9_5:
+		case PCI_DEVICE_ID_INTEL_Tolapai_0:
 			r->name = "PIIX/ICH";
 			r->get = pirq_piix_get;
 			r->set = pirq_piix_set;
diff -puN include/linux/pci_ids.h~irq-irq-and-pci_ids-patch-for-intel-tolapai include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~irq-irq-and-pci_ids-patch-for-intel-tolapai
+++ a/include/linux/pci_ids.h
@@ -2292,6 +2292,8 @@
 #define PCI_DEVICE_ID_INTEL_MCH_PC	0x3599
 #define PCI_DEVICE_ID_INTEL_MCH_PC1	0x359a
 #define PCI_DEVICE_ID_INTEL_E7525_MCH	0x359e
+#define PCI_DEVICE_ID_INTEL_Tolapai_0	0x5031
+#define PCI_DEVICE_ID_INTEL_Tolapai_1	0x5032
 #define PCI_DEVICE_ID_INTEL_82371SB_0	0x7000
 #define PCI_DEVICE_ID_INTEL_82371SB_1	0x7010
 #define PCI_DEVICE_ID_INTEL_82371SB_2	0x7020
_

Patches currently in -mm which might be from jason.d.gaston@intel.com are

origin.patch
i2c-i801-documentation-patch-for-intel-tolapai.patch
i2c-i801-smbus-patch-for-intel-tolapai.patch
i2c-i801-smbus-patch-for-intel-tolapai-fix.patch
ahci-raid-mode-sata-patch-for-intel-tolapai.patch
ata_piix-replace-spaces-with-tabs.patch
