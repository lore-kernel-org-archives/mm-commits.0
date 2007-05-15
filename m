From: akpm@linux-foundation.org
Subject: + pci-x-pci-express-read-control-interfaces-fix.patch added to -mm tree
Date: Tue, 15 May 2007 12:39:07 -0700
Message-ID: <200705151939.l4FJd7Bg015936@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48818 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762210AbXEOTjT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 15:39:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, greg@kroah.com, peter.oruba@amd.com, rolandd@cisco.com


The patch titled
     pci-x-pci-express-read-control-interfaces-fix
has been added to the -mm tree.  Its filename is
     pci-x-pci-express-read-control-interfaces-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pci-x-pci-express-read-control-interfaces-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: "Peter Oruba" <peter.oruba@amd.com>
Cc: Greg KH <greg@kroah.com>
Cc: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pci.c    |    6 ++----
 drivers/pci/quirks.c |    6 +++---
 2 files changed, 5 insertions(+), 7 deletions(-)

diff -puN drivers/pci/pci.c~pci-x-pci-express-read-control-interfaces-fix drivers/pci/pci.c
--- a/drivers/pci/pci.c~pci-x-pci-express-read-control-interfaces-fix
+++ a/drivers/pci/pci.c
@@ -1403,7 +1403,7 @@ pci_set_consistent_dma_mask(struct pci_d
 int
 pcix_get_max_mmrbc(struct pci_dev *dev)
 {
-	int ret, err, cap;
+	int err, cap;
 	u32 stat;
 
 	cap = pci_find_capability(dev, PCI_CAP_ID_PCIX);
@@ -1414,9 +1414,7 @@ pcix_get_max_mmrbc(struct pci_dev *dev)
 	if (err)
 		return -EINVAL;
 
-	ret = (stat & PCI_X_STATUS_MAX_READ) >> 12;
-
-	return ret;
+	return (stat & PCI_X_STATUS_MAX_READ) >> 12;
 }
 EXPORT_SYMBOL(pcix_get_max_mmrbc);
 
diff -puN drivers/pci/quirks.c~pci-x-pci-express-read-control-interfaces-fix drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~pci-x-pci-express-read-control-interfaces-fix
+++ a/drivers/pci/quirks.c
@@ -637,9 +637,9 @@ static void __init quirk_amd_8131_mmrbc(
 
 	pci_read_config_byte(dev, PCI_REVISION_ID, &revid);
 	if (dev->subordinate && revid <= 0x12) {
-        	printk(KERN_INFO "AMD8131 rev %x detected, disabling PCI-X MMRBC\n",
-        		revid);
-        	dev->subordinate->bus_flags |= PCI_BUS_FLAGS_NO_MMRBC;
+		printk(KERN_INFO "AMD8131 rev %x detected, disabling PCI-X "
+				"MMRBC\n", revid);
+		dev->subordinate->bus_flags |= PCI_BUS_FLAGS_NO_MMRBC;
 	}
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_8131_BRIDGE, quirk_amd_8131_mmrbc);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-acpi-export-acpi_set_cstate_limit.patch
working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch
fix-agk-dm-dm-io-fix-panic-on-large-request.patch
8xx-mpc885ads-pcmcia-support-fix.patch
git-dvb.patch
cinergyt2-fix-file-release-handler.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-input.patch
git-kvm.patch
git-leds.patch
git-leds-fixup.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
drivers-ata-correct-a-wrong-free-function-for-sata_nv-driver-fix.patch
git-mips-fixup.patch
git-ubi.patch
git-ubi-fixup.patch
git-battery.patch
git-nfs.patch
git-nfs-server-cluster-locking-api-fixup.patch
git-ocfs2.patch
git-parisc.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
pci-x-pci-express-read-control-interfaces-fix.patch
git-pciseg.patch
git-sh64.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-block-fixup.patch
git-unionfs.patch
auerswald-fix-file-release-handler.patch
git-wireless.patch
i386-add-support-for-picopower-irq-router.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources-fix.patch
x86_64-fix-smp_call_function_single-return-value.patch
git-newsetup-fixup.patch
xfs-clean-up-shrinker-games.patch
remove-slab_ctor_constructor-fix.patch
slub-define-functions-for-cpu-slab-handling-instead-of-using-fix.patch
compat_core_sys_select-avoid-kmalloc0.patch
change-zonelist-order-v6-zonelist-fix.patch
lazy-freeing-of-memory-through-madv_free.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
freezer-fix-kthread_create-vs-freezer-theoretical-race.patch
alpha-support-graphics-on-non-zero-pci-domains-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
use-write_trylock_irqsave-in-ptrace_attach-fix.patch
add-lzo1x-compression-support-to-the-kernel-fix.patch
use-no_pci_devices-in-pci-searchc.patch
introduce-boot-based-time-fix.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
check_dirty_inode_list.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
crc7-support-fix.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
lguest-the-host-code-borkages.patch
tglx-debug.patch
reiser4.patch
integrity-new-hooks.patch
integrity-evm-as-an-integrity-service-provider.patch
integrity-ima-integrity_measure-support.patch
integrity-tpm-internal-kernel-interface.patch
git-gccbug-fixup.patch
w1-build-fix.patch
