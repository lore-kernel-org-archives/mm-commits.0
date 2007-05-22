From: akpm@linux-foundation.org
Subject: - pci_find_slot-mark-deprecated.patch removed from -mm tree
Date: Tue, 22 May 2007 13:56:52 -0700
Message-ID: <200705222056.l4MKupfm009592@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43936 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755873AbXEVU7Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 May 2007 16:59:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     pci_find_slot: mark deprecated
has been removed from the -mm tree.  Its filename was
     pci_find_slot-mark-deprecated.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
libata-add-support-for-ata_16-on-atapi.patch
fix-build-failure-for-drivers-ata-pata_sccc.patch
hpt3x2n-correct-revision-boundary.patch
pata_sis-fix-and-clean-up-some-timing-setups.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
pata_ali-more-work.patch
ide-add-seagate-stt20000a-to-dma-blacklist.patch
serial-use-resource_size_t-for-port-io-addresses.patch
add-pci_try_set_mwi.patch
fix-pci_find_present.patch
git-scsi-misc.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
watchdog-documentation.patch
add-pci_try_set_mwi-prism54pci.patch
fix-crash-with-irqpoll-due-to-the-irqf_irqpoll-flag.patch
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
