From: akpm@linux-foundation.org
Subject: + edd-switch-to-pci_get-based-api.patch added to -mm tree
Date: Mon, 21 May 2007 14:17:01 -0700
Message-ID: <200705212117.l4LLH1dx020239@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35303 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762291AbXEUVUB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 17:20:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, Matt_Domsch@dell.com, alan@redhat.com


The patch titled
     From: Alan Cox <alan@lxorguk.ukuu.org.uk>
has been added to the -mm tree.  Its filename is
     edd-switch-to-pci_get-based-api.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: From: Alan Cox <alan@lxorguk.ukuu.org.uk>


Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/edd.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

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

pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
libata-add-support-for-ata_16-on-atapi.patch
fix-build-failure-for-drivers-ata-pata_sccc.patch
pata_hpt366-enable-bits-are-unreliable-so-dont-use-them.patch
hpt3x2n-correct-revision-boundary.patch
pata_sis-fix-and-clean-up-some-timing-setups.patch
ata_piix-clean-up.patch
libata-kiss-post_set_mode-goodbye.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
pata_ali-more-work.patch
serial-use-resource_size_t-for-port-io-addresses.patch
add-pci_try_set_mwi.patch
fix-pci_find_present.patch
pci_find_slot-mark-deprecated.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
watchdog-documentation.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
make-proc-tty-drivers-use-seq_list_xxx-helpers.patch
update-zilog-timeout.patch
edd-switch-to-pci_get-based-api.patch
i2o_cfg_passthru-cleanup.patch
i2o_cfg_passthru-cleanup-fix.patch
wrong-memory-access-in-i2o_block_device_lock.patch
i2o-message-leak-in-i2o_msg_post_wait_mem.patch
i2o-proc-reading-oops.patch
i2o-debug-output-cleanup.patch
