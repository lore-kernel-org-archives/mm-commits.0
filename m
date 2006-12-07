From: akpm@osdl.org
Subject: - trivial-cleanup-in-the-pci-ids-for-the-cs5535.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:16:04 -0800
Message-ID: <200612072316.kB7NG4eO030775@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53611 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163829AbWLGXQS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:16:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jordan.crouse@amd.com, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Trivial cleanup in the PCI IDs for the CS5535
has been removed from the -mm tree.  Its filename was
     trivial-cleanup-in-the-pci-ids-for-the-cs5535.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Trivial cleanup in the PCI IDs for the CS5535
From: "Jordan Crouse" <jordan.crouse@amd.com>

Rename a poorly worded PCI ID for the Geode GX and CS5535 companion chips. 
The graphics processor and host bridge actually live in the northbridge on
the integrated processor, not in the companion chip.

Signed-off-by: Jordan Crouse <jordan.crouse@amd.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/geode/gxfb_core.c |    2 +-
 include/linux/pci_ids.h         |    5 ++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/video/geode/gxfb_core.c~trivial-cleanup-in-the-pci-ids-for-the-cs5535 drivers/video/geode/gxfb_core.c
--- a/drivers/video/geode/gxfb_core.c~trivial-cleanup-in-the-pci-ids-for-the-cs5535
+++ a/drivers/video/geode/gxfb_core.c
@@ -380,7 +380,7 @@ static void gxfb_remove(struct pci_dev *
 }
 
 static struct pci_device_id gxfb_id_table[] = {
-	{ PCI_VENDOR_ID_NS, PCI_DEVICE_ID_NS_CS5535_VIDEO,
+	{ PCI_VENDOR_ID_NS, PCI_DEVICE_ID_NS_GX_VIDEO,
 	  PCI_ANY_ID, PCI_ANY_ID, PCI_BASE_CLASS_DISPLAY << 16,
 	  0xff0000, 0 },
 	{ 0, }
diff -puN include/linux/pci_ids.h~trivial-cleanup-in-the-pci-ids-for-the-cs5535 include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~trivial-cleanup-in-the-pci-ids-for-the-cs5535
+++ a/include/linux/pci_ids.h
@@ -390,7 +390,7 @@
 #define PCI_DEVICE_ID_NS_CS5535_IDE	0x002d
 #define PCI_DEVICE_ID_NS_CS5535_AUDIO	0x002e
 #define PCI_DEVICE_ID_NS_CS5535_USB	0x002f
-#define PCI_DEVICE_ID_NS_CS5535_VIDEO	0x0030
+#define PCI_DEVICE_ID_NS_GX_VIDEO	0x0030
 #define PCI_DEVICE_ID_NS_SATURN		0x0035
 #define PCI_DEVICE_ID_NS_SCx200_BRIDGE	0x0500
 #define PCI_DEVICE_ID_NS_SCx200_SMI	0x0501
@@ -403,8 +403,7 @@
 #define PCI_DEVICE_ID_NS_SC1100_XBUS	0x0515
 #define PCI_DEVICE_ID_NS_87410		0xd001
 
-#define PCI_DEVICE_ID_NS_CS5535_HOST_BRIDGE  0x0028
-#define PCI_DEVICE_ID_NS_CS5535_ISA_BRIDGE   0x002b
+#define PCI_DEVICE_ID_NS_GX_HOST_BRIDGE  0x0028
 
 #define PCI_VENDOR_ID_TSENG		0x100c
 #define PCI_DEVICE_ID_TSENG_W32P_2	0x3202
_

Patches currently in -mm which might be from jordan.crouse@amd.com are

origin.patch
acpi-clear-gpe-before-disabling-it.patch
video-get-the-default-mode-from-the-right-database.patch
fb-get-the-geode-gx-frambuffer-size-from-the-bios.patch
gxfb-fixups-for-the-amd-geode-gx.patch
gxfb-fixups-for-the-amd-geode-gx-tidy.patch
gxfb-support-flat-panel-timings.patch
gxfb-support-flat-panel-timings-tidy.patch
gxfb-support-command-line-options.patch
gxfb-support-command-line-options-tidy.patch
gxfb-fixup-flatpanel-detection.patch
gxfb-turn-on-the-flatpanel-power-and-data.patch

