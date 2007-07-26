From: akpm@linux-foundation.org
Subject: + cpqphp_ctrlc-remove-dead-code.patch added to -mm tree
Date: Thu, 26 Jul 2007 13:30:23 -0700
Message-ID: <200707262030.l6QKUNvK019456@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35960 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933310AbXGZUai (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 16:30:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, greg@kroah.com, kristen.c.accardi@intel.com


The patch titled
     cpqphp_ctrl.c: remove dead code
has been added to the -mm tree.  Its filename is
     cpqphp_ctrlc-remove-dead-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cpqphp_ctrl.c: remove dead code
From: Adrian Bunk <bunk@stusta.de>

If !mem_node we did already return -ENOMEM above in the function.

Spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Greg KH <greg@kroah.com>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/hotplug/cpqphp_ctrl.c |   28 +++++++---------------------
 1 file changed, 7 insertions(+), 21 deletions(-)

diff -puN drivers/pci/hotplug/cpqphp_ctrl.c~cpqphp_ctrlc-remove-dead-code drivers/pci/hotplug/cpqphp_ctrl.c
--- a/drivers/pci/hotplug/cpqphp_ctrl.c~cpqphp_ctrlc-remove-dead-code
+++ a/drivers/pci/hotplug/cpqphp_ctrl.c
@@ -2558,29 +2558,15 @@ static int configure_new_function(struct
 			hold_IO_node = NULL;
 		}
 
-		/* If we have memory resources copy them and fill in the
-		 * bridge's memory range registers.  Otherwise, fill in the
-		 * range registers with values that disable them. */
-		if (mem_node) {
-			memcpy(hold_mem_node, mem_node, sizeof(struct pci_resource));
-			mem_node->next = NULL;
-
-			/* set Mem base and Limit registers */
-			temp_word = mem_node->base >> 16;
-			rc = pci_bus_write_config_word(pci_bus, devfn, PCI_MEMORY_BASE, temp_word);
+		memcpy(hold_mem_node, mem_node, sizeof(struct pci_resource));
+		mem_node->next = NULL;
 
-			temp_word = (mem_node->base + mem_node->length - 1) >> 16;
-			rc = pci_bus_write_config_word(pci_bus, devfn, PCI_MEMORY_LIMIT, temp_word);
-		} else {
-			temp_word = 0xFFFF;
-			rc = pci_bus_write_config_word(pci_bus, devfn, PCI_MEMORY_BASE, temp_word);
-
-			temp_word = 0x0000;
-			rc = pci_bus_write_config_word(pci_bus, devfn, PCI_MEMORY_LIMIT, temp_word);
+		/* set Mem base and Limit registers */
+		temp_word = mem_node->base >> 16;
+		rc = pci_bus_write_config_word(pci_bus, devfn, PCI_MEMORY_BASE, temp_word);
 
-			kfree(hold_mem_node);
-			hold_mem_node = NULL;
-		}
+		temp_word = (mem_node->base + mem_node->length - 1) >> 16;
+		rc = pci_bus_write_config_word(pci_bus, devfn, PCI_MEMORY_LIMIT, temp_word);
 
 		memcpy(hold_p_mem_node, p_mem_node, sizeof(struct pci_resource));
 		p_mem_node->next = NULL;
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
x86_powernow_k8_acpi-must-depend-on-acpi.patch
xenbus_xsc-fix-a-use-after-free.patch
git-acpi.patch
drivers-acpi-sbsc-remove-dead-code.patch
git-alsa.patch
kernel-auditscc-fix-an-off-by-one.patch
git-drm.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mtd.patch
fore200e_param_bs_queue-must-be-__devinit.patch
git-ocfs2.patch
cpqphp_ctrlc-remove-dead-code.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
git-unionfs.patch
dvb-usb-af9005-fec-error-check-fixes.patch
git-v9fs.patch
git-ipwireless_cs.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
serial-sh-sci-fix-build-failure-from-kgdb-fallout.patch
net-bluetooth-rfcomm-ttyc-use-after-free.patch
usb_serial_suspend-buggy-code.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
maps2-add-proc-kpagemap-interface.patch
fs-reiserfs-cleanups.patch
anon_inodes-shouldnt-be-user-visible.patch
remove-unsafe-from-module-struct.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
the-next-round-of-scheduled-oss-code-removal.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
