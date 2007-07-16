From: akpm@linux-foundation.org
Subject: - edd-switch-to-pci_get-based-api.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:54:08 -0700
Message-ID: <200707162054.l6GKs8bY001781@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50732 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756416AbXGPVd4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:33:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, Matt_Domsch@dell.com, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     edd: switch to pci_get based API
has been removed from the -mm tree.  Its filename was
     edd-switch-to-pci_get-based-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: edd: switch to pci_get based API
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/edd.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/firmware/edd.c~edd-switch-to-pci_get-based-api drivers/firmware/edd.c
--- a/drivers/firmware/edd.c~edd-switch-to-pci_get-based-api
+++ a/drivers/firmware/edd.c
@@ -669,7 +669,7 @@ edd_get_pci_dev(struct edd_device *edev)
 	struct edd_info *info = edd_dev_get_info(edev);
 
 	if (edd_dev_is_type(edev, "PCI")) {
-		return pci_find_slot(info->params.interface_path.pci.bus,
+		return pci_get_bus_and_slot(info->params.interface_path.pci.bus,
 				     PCI_DEVFN(info->params.interface_path.pci.slot,
 					       info->params.interface_path.pci.
 					       function));
@@ -682,9 +682,12 @@ edd_create_symlink_to_pcidev(struct edd_
 {
 
 	struct pci_dev *pci_dev = edd_get_pci_dev(edev);
+	int ret;
 	if (!pci_dev)
 		return 1;
-	return sysfs_create_link(&edev->kobj,&pci_dev->dev.kobj,"pci_dev");
+	ret = sysfs_create_link(&edev->kobj,&pci_dev->dev.kobj,"pci_dev");
+	pci_dev_put(pci_dev);
+	return ret;
 }
 
 static inline void
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
git-powerpc.patch
git-ia64.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
iomap-sort-out-the-broken-address-reporting-caused-by-the-iomap-layer.patch
ata-use-iomap_name.patch
sata_mv-test-patch-for-hightpoint-rocketraid-1740-1742.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
pata_ali-more-work.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
x86-64-disable-the-gart-in-shutdown.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh.patch
geode-basic-infrastructure-support-for-amd-geode-class.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
blackfin-enable-arbitary-speed-serial-setting.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
sb1250-duartc-sb1250-duart-serial-support.patch
mbcs-remove-lots-of-global-symbols.patch
i2o_cfg_passthru-cleanup.patch
wrong-memory-access-in-i2o_block_device_lock.patch
i2o-message-leak-in-i2o_msg_post_wait_mem.patch
i2o-proc-reading-oops.patch
i2o-debug-output-cleanup.patch
stallion-remove-unneeded-lock_kernel.patch
coredump-masking-bound-suid_dumpable-sysctl.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
coredump-masking-add-an-interface-for-core-dump-filter.patch
coredump-masking-elf-enable-core-dump-filtering.patch
coredump-masking-elf-fdpic-remove-an-unused-argument.patch
coredump-masking-elf-fdpic-enable-core-dump-filtering.patch
coredump-masking-documentation-for-proc-pid-coredump_filter.patch
driver-edac-add-mips-and-ppc-visibility.patch
driver-edac-mod-race-fix-i82875p.patch
driver-edac-fix-ignored-return-i82875p.patch
include-linux-pci_id-h-add-amd-northbridge-defines.patch
drivers-edac-fix-edac_device-semaphore-to-mutex.patch
drivers-edac-fix-e752x-reversed-csrows.patch
drivers-edac-fix-e752x-reversed-csrows-fix.patch
drivers-edac-new-pasemi-driver.patch
drivers-edac-new-pasemi-driver-fix.patch
drivers-edac-fix-leaf-sysfs-attribute.patch
drivers-edac-fix-edac_mc-init-apis.patch
drivers-edac-fix-edac_device-init-apis.patch
drivers-edac-fix-edac_mc-sysfs-completion-code.patch
drivers-edac-fix-edac_device-sysfs-completion-code.patch
