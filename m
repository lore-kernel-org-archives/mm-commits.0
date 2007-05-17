From: akpm@linux-foundation.org
Subject: - sl82c105-switch-to-ref-counting-api.patch removed from -mm tree
Date: Wed, 16 May 2007 20:47:32 -0700
Message-ID: <200705170347.l4H3lVh6016517@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39382 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758635AbXEQDuC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 May 2007 23:50:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, sshtylyov@ru.mvista.com, mm-commits@vger.kernel.org


The patch titled
     sl82c105: Switch to ref counting API
has been removed from the -mm tree.  Its filename was
     sl82c105-switch-to-ref-counting-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sl82c105: Switch to ref counting API
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Not sure how this one got missed in the great purge some time ago but it
did.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/pci/sl82c105.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/ide/pci/sl82c105.c~sl82c105-switch-to-ref-counting-api drivers/ide/pci/sl82c105.c
--- a/drivers/ide/pci/sl82c105.c~sl82c105-switch-to-ref-counting-api
+++ a/drivers/ide/pci/sl82c105.c
@@ -343,7 +343,7 @@ static unsigned int sl82c105_bridge_revi
 	/*
 	 * The bridge should be part of the same device, but function 0.
 	 */
-	bridge = pci_find_slot(dev->bus->number,
+	bridge = pci_get_bus_and_slot(dev->bus->number,
 			       PCI_DEVFN(PCI_SLOT(dev->devfn), 0));
 	if (!bridge)
 		return -1;
@@ -353,13 +353,15 @@ static unsigned int sl82c105_bridge_revi
 	 */
 	if (bridge->vendor != PCI_VENDOR_ID_WINBOND ||
 	    bridge->device != PCI_DEVICE_ID_WINBOND_83C553 ||
-	    bridge->class >> 8 != PCI_CLASS_BRIDGE_ISA)
+	    bridge->class >> 8 != PCI_CLASS_BRIDGE_ISA) {
+	    	pci_dev_put(bridge);
 		return -1;
-
+	}
 	/*
 	 * We need to find function 0's revision, not function 1
 	 */
 	pci_read_config_byte(bridge, PCI_REVISION_ID, &rev);
+	pci_dev_put(bridge);
 
 	return rev;
 }
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
refine-screen_info-sanity-check-for-vgacon-initialization.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
libata-add-support-for-ata_16-on-atapi.patch
fix-build-failure-for-drivers-ata-pata_sccc.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
pata_ali-more-work.patch
serial-use-resource_size_t-for-port-io-addresses.patch
add-pci_try_set_mwi.patch
fix-pci_find_present.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
watchdog-documentation.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
i2o_cfg_passthru-cleanup.patch
i2o_cfg_passthru-cleanup-fix.patch
wrong-memory-access-in-i2o_block_device_lock.patch
i2o-message-leak-in-i2o_msg_post_wait_mem.patch
i2o-proc-reading-oops.patch
i2o-debug-output-cleanup.patch
