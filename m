From: akpm@linux-foundation.org
Subject: - ide-add-helper-__ide_setup_pci_device.patch removed from -mm tree
Date: Wed, 21 Nov 2007 15:28:39 -0800
Message-ID: <200711212328.lALNSdLb014768@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56048 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752207AbXKUX3U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Nov 2007 18:29:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff@garzik.org, bzolnier@gmail.com, jgarzik@redhat.com, mm-commits@vger.kernel.org


The patch titled
     IDE: add helper __ide_setup_pci_device()
has been removed from the -mm tree.  Its filename was
     ide-add-helper-__ide_setup_pci_device.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
Subject: IDE: add helper __ide_setup_pci_device()
From: Jeff Garzik <jeff@garzik.org>

Like ide_setup_pci_device(), except with additional array argument 'u8
*idx' that permits low-level driver to become aware of its assigned hwifs.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/setup-pci.c |   17 ++++++++++++-----
 include/linux/ide.h     |    1 +
 2 files changed, 13 insertions(+), 5 deletions(-)

diff -puN drivers/ide/setup-pci.c~ide-add-helper-__ide_setup_pci_device drivers/ide/setup-pci.c
--- a/drivers/ide/setup-pci.c~ide-add-helper-__ide_setup_pci_device
+++ a/drivers/ide/setup-pci.c
@@ -665,12 +665,10 @@ out:
 	return ret;
 }
 
-int ide_setup_pci_device(struct pci_dev *dev, const struct ide_port_info *d)
+int __ide_setup_pci_device(struct pci_dev *dev, const struct ide_port_info *d,
+			   u8 *idx)
 {
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
-	int ret;
-
-	ret = do_ide_setup_pci_device(dev, d, &idx[0], 1);
+	int ret = do_ide_setup_pci_device(dev, d, idx, 1);
 
 	if (ret >= 0)
 		ide_device_add(idx);
@@ -678,6 +676,15 @@ int ide_setup_pci_device(struct pci_dev 
 	return ret;
 }
 
+EXPORT_SYMBOL_GPL(__ide_setup_pci_device);
+
+int ide_setup_pci_device(struct pci_dev *dev, const struct ide_port_info *d)
+{
+	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
+
+	return __ide_setup_pci_device(dev, d, &idx[0]);
+}
+
 EXPORT_SYMBOL_GPL(ide_setup_pci_device);
 
 int ide_setup_pci_devices(struct pci_dev *dev1, struct pci_dev *dev2,
diff -puN include/linux/ide.h~ide-add-helper-__ide_setup_pci_device include/linux/ide.h
--- a/include/linux/ide.h~ide-add-helper-__ide_setup_pci_device
+++ a/include/linux/ide.h
@@ -1119,6 +1119,7 @@ struct ide_port_info {
 	u8			udma_mask;
 };
 
+int __ide_setup_pci_device(struct pci_dev *, const struct ide_port_info *, u8 *);
 int ide_setup_pci_device(struct pci_dev *, const struct ide_port_info *);
 int ide_setup_pci_devices(struct pci_dev *, struct pci_dev *, const struct ide_port_info *);
 
_

Patches currently in -mm which might be from jeff@garzik.org are

git-arm.patch
powerpc-fix-typo-ifdef-ifndef.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
pata_sisc-add-packard-bell-easynote-k5305-to-laptops.patch
libata-add-toshiba-mk1637gsx-to-spurious-command-completion-list.patch
ide-add-helper-__ide_setup_pci_device.patch
git-netdev-all.patch
forcedeth-power-down-phy-when-interface-is-down.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
drivers-net-chelsio-if-0-unused-functions.patch
pcmcia-net-use-roundup_pow_of_two-macro-instead-of-grotesque-loop.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
hptiop-fix-type-mismatch-warning.patch
ips-remove-ips_ha-members-that-duplicate-struct-pci_dev-members.patch
ips-trim-trailing-whitespace.patch
ips-pci-api-cleanups.patch
ips-handle-scsi_add_host-failure-and-other-err-cleanups.patch
scsi-gdth-kill-unneeded-irq-argument.patch
scsi-sym53c416-kill-pointless-irq-handler-loop-and-test.patch
scsi-fix-bugs-and-canonicalize-ncr5380_intr-drivers.patch
scsi-ncr5380-minor-irq-handler-cleanups.patch
iommu-sg-merging-add-device_dma_parameters-structure.patch
iommu-sg-merging-pci-add-device_dma_parameters-support.patch
iommu-sg-merging-x86-make-pci-gart-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-ppc-make-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-ia64-make-sba_iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-alpha-make-pci_iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-sparc64-make-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-parisc-make-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-call-blk_queue_segment_boundary-in-__scsi_alloc_queue.patch
iommu-sg-merging-sata_inic162x-use-pci_set_dma_max_seg_size.patch
iommu-sg-merging-aacraid-use-pci_set_dma_max_seg_size.patch
usb-s3c2410_udc-minor-irq-handler-cleanups.patch
git-wireless.patch
tty-fix-tty-network-driver-interactions-with-tcget-tcset-calls-x86-fix.patch
pata_amd-pata_via-de-couple-programming-of-pio-mwdma-and-udma-timings.patch
fix-versus-precedence-in-various-places.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
riscom8-fix-smp-brokenness.patch
riscom8-fix-smp-brokenness-fix.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
sound-oss-sb_commonc-fix-casting-warning.patch
remove-warnings-for-longstanding-conditions.patch
remove-warnings-for-longstanding-conditions-fix.patch
remove-pointless-casts-from-void-pointers.patch
i8k-allow-i8k-driver-to-be-built-on-x86_64-systems.patch
i8k-adds-i8k-driver-to-the-x86_64-kconfig.patch
i8k-inspiron-e1705-fix.patch
