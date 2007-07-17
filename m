From: akpm@linux-foundation.org
Subject: - oss-trident-replace-deprecated-pci_find_device-with-pci_get_device.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:06:07 -0700
Message-ID: <200707172306.l6HN67x3011985@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57445 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758190AbXGQXPT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: muli@il.ibm.com, mm-commits@vger.kernel.org


The patch titled
     OSS trident: replace deprecated pci_find_device with pci_get_device
has been removed from the -mm tree.  Its filename was
     oss-trident-replace-deprecated-pci_find_device-with-pci_get_device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: OSS trident: replace deprecated pci_find_device with pci_get_device
From: Muli Ben-Yehuda <muli@il.ibm.com>

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/oss/trident.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN sound/oss/trident.c~oss-trident-replace-deprecated-pci_find_device-with-pci_get_device sound/oss/trident.c
--- a/sound/oss/trident.c~oss-trident-replace-deprecated-pci_find_device-with-pci_get_device
+++ a/sound/oss/trident.c
@@ -4454,9 +4454,9 @@ trident_probe(struct pci_dev *pci_dev, c
 
 		/* Add H/W Volume Control By Matt Wu Jul. 06, 2001 */
 		card->hwvolctl = 0;
-		pci_dev_m1533 = pci_find_device(PCI_VENDOR_ID_AL,
-						PCI_DEVICE_ID_AL_M1533,
-						pci_dev_m1533);
+		pci_dev_m1533 = pci_get_device(PCI_VENDOR_ID_AL,
+					       PCI_DEVICE_ID_AL_M1533,
+					       pci_dev_m1533);
 		rc = -ENODEV;
 		if (pci_dev_m1533 == NULL)
 			goto out_proc_fs;
@@ -4470,6 +4470,8 @@ trident_probe(struct pci_dev *pci_dev, c
 			bits &= 0xbf;	/*clear bit 6 */
 			pci_write_config_byte(pci_dev_m1533, 0x7b, bits);
 		}
+		pci_dev_put(pci_dev_m1533);
+
 	} else if (card->pci_id == PCI_DEVICE_ID_INTERG_5050) {
 		card->alloc_pcm_channel = cyber_alloc_pcm_channel;
 		card->alloc_rec_pcm_channel = cyber_alloc_pcm_channel;
_

Patches currently in -mm which might be from muli@il.ibm.com are

origin.patch
x86-64-calgary-generalize-calgary_increase_split_completion_timeout.patch
x86-64-calgary-update-copyright-notice.patch
x86-64-calgary-introduce-handle_quirks-for-various-chipset-quirks.patch
x86-64-calgary-introduce-chipset-specific-ops.patch
x86-64-calgary-abstract-how-we-find-the-iommu_table-for-a-device.patch
x86-64-calgary-introduce-calioc2-support.patch
x86-64-calgary-add-chip_ops-and-a-quirk-function-for-calioc2.patch
x86-64-calgary-implement-calioc2-tce-cache-flush-sequence.patch
x86-64-calgary-make-dump_error_regs-a-chip-op.patch
x86-64-calgary-grab-plssr-too-when-a-dma-error-occurs.patch
x86-64-calgary-reserve-tces-with-the-same-address-as-mem-regions.patch
x86-64-calgary-cleanup-of-unneeded-macros.patch
x86-64-calgary-tabify-and-trim-trailing-whitespace.patch
x86-64-calgary-only-reserve-the-first-1mb-of-io-space-for-calioc2.patch
x86-64-calgary-tidy-up-debug-printks.patch
x86-64-calgary-fix-few-style-problems-pointed-out-by-checkpatchpl.patch
x86-64-calgary-tighten-up-the-bitmap-locking.patch
x86-64-calgary-fold-in-redundant-functions.patch
x86_64-calgary-change-_map_single-etc-to-static.patch
x86-64-disable-the-gart-in-shutdown.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
