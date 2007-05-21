From: akpm@linux-foundation.org
Subject: + pci_find_slot-mark-deprecated.patch added to -mm tree
Date: Mon, 21 May 2007 14:16:17 -0700
Message-ID: <200705212116.l4LLGHOU020230@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35107 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761764AbXEUVS4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 17:18:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, greg@kroah.com


The patch titled
     pci_find_slot: mark deprecated
has been added to the -mm tree.  Its filename is
     pci_find_slot-mark-deprecated.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pci_find_slot: mark deprecated
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

We've now fixed up most users of pci_find_slot, and the remainder are either
hard and need someone with the hardware and info to work on it, or patches
exist but are not yet merged.

Time therefore for some gentle encouragement

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pci.h |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/pci.h~pci_find_slot-mark-deprecated include/linux/pci.h
--- a/include/linux/pci.h~pci_find_slot-mark-deprecated
+++ a/include/linux/pci.h
@@ -475,7 +475,7 @@ extern void pci_sort_breadthfirst(void);
 /* Generic PCI functions exported to card drivers */
 
 struct pci_dev __deprecated *pci_find_device (unsigned int vendor, unsigned int device, const struct pci_dev *from);
-struct pci_dev *pci_find_slot (unsigned int bus, unsigned int devfn);
+struct pci_dev __deprecated *pci_find_slot (unsigned int bus, unsigned int devfn);
 int pci_find_capability (struct pci_dev *dev, int cap);
 int pci_find_next_capability (struct pci_dev *dev, u8 pos, int cap);
 int pci_find_ext_capability (struct pci_dev *dev, int cap);
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
i2o_cfg_passthru-cleanup.patch
i2o_cfg_passthru-cleanup-fix.patch
wrong-memory-access-in-i2o_block_device_lock.patch
i2o-message-leak-in-i2o_msg_post_wait_mem.patch
i2o-proc-reading-oops.patch
i2o-debug-output-cleanup.patch
edd-switch-to-pci_get-based-api.patch
