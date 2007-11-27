From: akpm@linux-foundation.org
Subject: - pci-add-pci-quirk-function-for-some-chipsets.patch removed from -mm tree
Date: Tue, 27 Nov 2007 12:33:50 -0800
Message-ID: <200711272033.lARKXoMq029006@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45260 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755914AbXK0Udy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 15:33:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yakui.zhao@intel.com, greg@kroah.com, shaohua.li@intel.com, mm-commits@vger.kernel.org


The patch titled
     PCI: add PCI quirk function for some chipsets
has been removed from the -mm tree.  Its filename was
     pci-add-pci-quirk-function-for-some-chipsets.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PCI: add PCI quirk function for some chipsets
From: Zhao Yakui <yakui.zhao@intel.com>

PCI quirk function is added for some chipsets so that the resources
behind LPC bridge can be reserved.

Signed-off-by: Li Shaohua <shaohua.li@intel.com>
Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/quirks.c    |    6 ++++++
 include/linux/pci_ids.h |    2 ++
 2 files changed, 8 insertions(+)

diff -puN drivers/pci/quirks.c~pci-add-pci-quirk-function-for-some-chipsets drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~pci-add-pci-quirk-function-for-some-chipsets
+++ a/drivers/pci/quirks.c
@@ -462,6 +462,12 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_I
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH8_0, quirk_ich6_lpc_acpi );
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH8_2, quirk_ich6_lpc_acpi );
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH8_3, quirk_ich6_lpc_acpi );
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH8_1, quirk_ich6_lpc_acpi );
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH8_4, quirk_ich6_lpc_acpi );
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH9_2, quirk_ich6_lpc_acpi );
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH9_4, quirk_ich6_lpc_acpi );
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH9_7, quirk_ich6_lpc_acpi );
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH9_8, quirk_ich6_lpc_acpi );
 
 /*
  * VIA ACPI: One IO region pointed to by longword at
diff -puN include/linux/pci_ids.h~pci-add-pci-quirk-function-for-some-chipsets include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~pci-add-pci-quirk-function-for-some-chipsets
+++ a/include/linux/pci_ids.h
@@ -2321,6 +2321,8 @@
 #define PCI_DEVICE_ID_INTEL_ICH9_4	0x2914
 #define PCI_DEVICE_ID_INTEL_ICH9_5	0x2919
 #define PCI_DEVICE_ID_INTEL_ICH9_6	0x2930
+#define PCI_DEVICE_ID_INTEL_ICH9_7	0x2916
+#define PCI_DEVICE_ID_INTEL_ICH9_8	0x2918
 #define PCI_DEVICE_ID_INTEL_82855PM_HB	0x3340
 #define PCI_DEVICE_ID_INTEL_82830_HB	0x3575
 #define PCI_DEVICE_ID_INTEL_82830_CGC	0x3577
_

Patches currently in -mm which might be from yakui.zhao@intel.com are

origin.patch
pnp-increase-the-maximum-number-of-resources.patch
pnp-increase-the-maximum-number-of-resources-fix.patch
