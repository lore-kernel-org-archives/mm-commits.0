From: akpm@linux-foundation.org
Subject: - gdth-remove-redundant-pci-stuff-update.patch removed from -mm tree
Date: Mon, 23 Jul 2007 02:35:34 -0700
Message-ID: <200707230935.l6N9ZY9X016500@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40851 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758864AbXGWJpW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 05:45:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff@garzik.org, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     gdth-remove-redundant-pci-stuff update
has been removed from the -mm tree.  Its filename was
     gdth-remove-redundant-pci-stuff-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: gdth-remove-redundant-pci-stuff update
From: Jeff Garzik <jeff@garzik.org>

Attached is the version updated with Christoph's "don't lose info
contained in PCI_DEVICE_ID constants" request.

Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/gdth.h |   39 ++++++++++++++++++++++++++++++++++++++-
 1 files changed, 38 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/gdth.h~gdth-remove-redundant-pci-stuff-update drivers/scsi/gdth.h
--- a/drivers/scsi/gdth.h~gdth-remove-redundant-pci-stuff-update
+++ a/drivers/scsi/gdth.h
@@ -51,8 +51,45 @@
 #define GDT2_ID         0x0120941c              /* GDT2000/2020 */
 
 /* vendor ID, device IDs (PCI) */
-/* these defines should be moved to <linux/pci.h> */
+/* these defines should already exist in <linux/pci.h> */
+#ifndef PCI_VENDOR_ID_VORTEX
+#define PCI_VENDOR_ID_VORTEX            0x1119  /* PCI controller vendor ID */
+#endif
+#ifndef PCI_VENDOR_ID_INTEL
+#define PCI_VENDOR_ID_INTEL             0x8086  
+#endif
 
+#ifndef PCI_DEVICE_ID_VORTEX_GDT60x0
+/* GDT_PCI */
+#define PCI_DEVICE_ID_VORTEX_GDT60x0    0       /* GDT6000/6020/6050 */
+#define PCI_DEVICE_ID_VORTEX_GDT6000B   1       /* GDT6000B/6010 */
+/* GDT_PCINEW */
+#define PCI_DEVICE_ID_VORTEX_GDT6x10    2       /* GDT6110/6510 */
+#define PCI_DEVICE_ID_VORTEX_GDT6x20    3       /* GDT6120/6520 */
+#define PCI_DEVICE_ID_VORTEX_GDT6530    4       /* GDT6530 */
+#define PCI_DEVICE_ID_VORTEX_GDT6550    5       /* GDT6550 */
+/* GDT_PCINEW, wide/ultra SCSI controllers */
+#define PCI_DEVICE_ID_VORTEX_GDT6x17    6       /* GDT6117/6517 */
+#define PCI_DEVICE_ID_VORTEX_GDT6x27    7       /* GDT6127/6527 */
+#define PCI_DEVICE_ID_VORTEX_GDT6537    8       /* GDT6537 */
+#define PCI_DEVICE_ID_VORTEX_GDT6557    9       /* GDT6557/6557-ECC */
+/* GDT_PCINEW, wide SCSI controllers */
+#define PCI_DEVICE_ID_VORTEX_GDT6x15    10      /* GDT6115/6515 */
+#define PCI_DEVICE_ID_VORTEX_GDT6x25    11      /* GDT6125/6525 */
+#define PCI_DEVICE_ID_VORTEX_GDT6535    12      /* GDT6535 */
+#define PCI_DEVICE_ID_VORTEX_GDT6555    13      /* GDT6555/6555-ECC */
+#endif
+
+#ifndef PCI_DEVICE_ID_VORTEX_GDT6x17RP
+/* GDT_MPR, RP series, wide/ultra SCSI */
+#define PCI_DEVICE_ID_VORTEX_GDT6x17RP  0x100   /* GDT6117RP/GDT6517RP */
+#define PCI_DEVICE_ID_VORTEX_GDT6x27RP  0x101   /* GDT6127RP/GDT6527RP */
+#define PCI_DEVICE_ID_VORTEX_GDT6537RP  0x102   /* GDT6537RP */
+#define PCI_DEVICE_ID_VORTEX_GDT6557RP  0x103   /* GDT6557RP */
+/* GDT_MPR, RP series, narrow/ultra SCSI */
+#define PCI_DEVICE_ID_VORTEX_GDT6x11RP  0x104   /* GDT6111RP/GDT6511RP */
+#define PCI_DEVICE_ID_VORTEX_GDT6x21RP  0x105   /* GDT6121RP/GDT6521RP */
+#endif
 #ifndef PCI_DEVICE_ID_VORTEX_GDT6x17RD
 /* GDT_MPR, RD series, wide/ultra SCSI */
 #define PCI_DEVICE_ID_VORTEX_GDT6x17RD  0x110   /* GDT6117RD/GDT6517RD */
_

Patches currently in -mm which might be from jeff@garzik.org are

git-jg-misc.patch
git-libata-all.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
libata-adjust-libata-to-ignore-errors-after.patch
libata-check-for-an-support.patch
scsi-expose-an-to-user-space.patch
libata-expose-an-to-user-space.patch
scsi-save-disk-in-scsi_device.patch
libata-send-event-when-an-received.patch
ata-ahci-alpm-store-interrupt-value.patch
ata-ahci-alpm-expose-power-management-policy-option-to-users.patch
ata-ahci-alpm-enable-link-power-management-for-ata-drivers.patch
ata-ahci-alpm-enable-aggressive-link-power-management-for-ahci-controllers.patch
8139too-force-media-setting-fix.patch
sundance-phy-address-form-0-only-for-device-id-0x0200.patch
via-rhine-disable-rx_copybreak-on-archs-that.patch
netdev-i82596-ethernet-needs-asm-cacheflushh.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
e1000new-build-fix.patch
bpqether-fix-rcu-usage.patch
typo-fixes-errror-error.patch
iomap-sort-out-the-broken-address-reporting-caused-by-the-iomap-layer.patch
iomap-sort-out-the-broken-address-reporting-caused-by-the-iomap-layer-iomap-allow-space-for-64bit-i-o-ports.patch
ata-use-iomap_name.patch
