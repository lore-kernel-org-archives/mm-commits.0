From: akpm@linux-foundation.org
Subject: - cpqphp_ctrlc-remove-dead-code.patch removed from -mm tree
Date: Thu, 09 Aug 2007 15:59:50 -0700
Message-ID: <200708092259.l79MxoDe023950@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36867 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753466AbXHIXAH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 19:00:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, greg@kroah.com, kristen.c.accardi@intel.com, mm-commits@vger.kernel.org


The patch titled
     cpqphp_ctrl.c: remove dead code
has been removed from the -mm tree.  Its filename was
     cpqphp_ctrlc-remove-dead-code.patch

This patch was dropped because it was withdrawn

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
@@ -2553,29 +2553,15 @@ static int configure_new_function(struct
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

slow-down-printk-during-boot-fix-3.patch
git-acpi.patch
make-drivers-acpi-eventcacpi_event_seqnum-static.patch
git-alsa.patch
allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default-kconfig-fix.patch
drivers-base-power-make-2-functions-static.patch
git-drm.patch
git-dvb.patch
include-linux-kbuild-remove-duplicate-entries.patch
git-kvm.patch
git-mmc.patch
git-mtd.patch
remove-fs-jffs2-ioctlc.patch
drivers-net-cxgb3-xgmacc-remove-dead-code.patch
e1000-if-0-two-functions.patch
fore200e_param_bs_queue-must-be-__devinit.patch
backlight-make-2-structs-static.patch
git-ocfs2.patch
parisc-extern-inline-static-inline.patch
cpqphp_ctrlc-remove-dead-code.patch
kernel-schedc-make-code-static.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
nsp32_restart_autoscsi-remove-error-check.patch
drivers-scsi-scsi_errorc-should-include.patch
drivers-scsi-constantsc-make-2-functions-static.patch
git-unionfs.patch
git-v9fs.patch
git-wireless.patch
git-ipwireless_cs.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
i386-remove-maccumulate-outgoing-args.patch
arch-i386-mach-generic-probec-make-struct-apic_probe.patch
arch-i386-mach-es7000-es7000platc-cleanups.patch
i386-alternativec-really-stop-mces-during-code.patch
i386-no-need-to-make-enable_cpu_hotplug-a-variable.patch
arch-i386-mm-discontigc-make-some-variables-static.patch
git-cryptodev.patch
kernel-auditscc-fix-an-off-by-one.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
mm-page_allocc-make-code-static.patch
maps2-add-proc-kpagemap-interface.patch
hugetlbfs-read-support-fix-2.patch
mm-shmemc-make-3-functions-static.patch
mm-mempolicyc-cleanups.patch
mm-vmstatc-cleanups.patch
cleanup-arch-alpha-makefile.patch
unexport-pm_power_off_prepare.patch
fs-reiserfs-cleanups.patch
remove-unsafe-from-module-struct.patch
kernel-rtmutex-debugc-cleanups.patch
fs-afs-possible-cleanups.patch
lib-ioremapc-should-include-linux-ioh.patch
ipc-shmc-make-2-functions-static.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
fs-nfsd-exportc-make-3-functions-static.patch
radeon_driver_vblank_do_wait-static.patch
unexport-fb_prepare_logo.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-kernel-pidc-remove-unused-exports.patch
the-next-round-of-scheduled-oss-code-removal.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
