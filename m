From: akpm@osdl.org
Subject: - pci-move-pci_vdevice-from-libata-to-core.patch removed from -mm tree
Date: Tue, 19 Dec 2006 12:31:28 -0800
Message-ID: <200612192031.kBJKVS3o009499@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:60608 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932935AbWLSUbh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Dec 2006 15:31:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pci: Move PCI_VDEVICE from libata to core
has been removed from the -mm tree.  Its filename was
     pci-move-pci_vdevice-from-libata-to-core.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pci: Move PCI_VDEVICE from libata to core
From: Alan Cox <alan@redhat.com>

Updated diff which doesn't move the comment as per Jeff's request and
corrects the docs as per report on l/k

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/libata.h |    4 ----
 include/linux/pci.h    |   15 +++++++++++++++
 2 files changed, 15 insertions(+), 4 deletions(-)

diff -puN include/linux/libata.h~pci-move-pci_vdevice-from-libata-to-core include/linux/libata.h
--- a/include/linux/libata.h~pci-move-pci_vdevice-from-libata-to-core
+++ a/include/linux/libata.h
@@ -110,10 +110,6 @@ static inline u32 ata_msg_init(int dval,
 #define ATA_TAG_POISON		0xfafbfcfdU
 
 /* move to PCI layer? */
-#define PCI_VDEVICE(vendor, device)		\
-	PCI_VENDOR_ID_##vendor, (device),	\
-	PCI_ANY_ID, PCI_ANY_ID, 0, 0
-
 static inline struct device *pci_dev_to_dev(struct pci_dev *pdev)
 {
 	return &pdev->dev;
diff -puN include/linux/pci.h~pci-move-pci_vdevice-from-libata-to-core include/linux/pci.h
--- a/include/linux/pci.h~pci-move-pci_vdevice-from-libata-to-core
+++ a/include/linux/pci.h
@@ -394,6 +394,21 @@ struct pci_driver {
  */
 #define pci_module_init	pci_register_driver
 
+/**
+ * PCI_VDEVICE - macro used to describe a specific pci device in short form
+ * @vendor: the vendor name
+ * @device: the 16 bit PCI Device ID
+ *
+ * This macro is used to create a struct pci_device_id that matches a
+ * specific PCI device.  The subvendor, and subdevice fields will be set
+ * to PCI_ANY_ID. The macro allows the next field to follow as the device
+ * private data.
+ */
+
+#define PCI_VDEVICE(vendor, device)		\
+	PCI_VENDOR_ID_##vendor, (device),	\
+	PCI_ANY_ID, PCI_ANY_ID, 0, 0
+
 /* these external functions are only available when PCI support is enabled */
 #ifdef CONFIG_PCI
 
_

Patches currently in -mm which might be from alan@redhat.com are

origin.patch
git-libata-all.patch
pci-move-pci_vdevice-from-libata-to-core.patch
pata_cs5530-suspend-resume-support-tweak.patch
pata_via-suspend-resume-support-fix.patch
git-mtd.patch
resend-iphase-64bit-cleanup.patch
pci-legacy-resource-fix.patch
pci-legacy-resource-fix-tidy.patch
pci_module_init-convertion-in-tmscsimc.patch
remove-drivers-pci-searchcpci_find_device_reverse.patch
toshiba-tc86c001-ide-driver-take-2.patch
edac-fix-in-e752x-mc-driver.patch
edac-add-memory-scrubbing-controls-api-to-core.patch
edac-add-fully-buffered-dimm-apis-to-core.patch
char-isicom-remove-tty_hangwakeup-bottomhalves.patch

