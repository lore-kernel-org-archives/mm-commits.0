From: akpm@linux-foundation.org
Subject: - mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources-fix.patch removed from -mm tree
Date: Wed, 23 May 2007 14:45:59 -0700
Message-ID: <200705232145.l4NLjxv2001549@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53048 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755407AbXEWVqS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 May 2007 17:46:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adurbin@google.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources-fix
has been removed from the -mm tree.  Its filename was
     mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources-fix.patch

This patch was dropped because it was folded into mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources.patch

------------------------------------------------------
Subject: mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Aaron Durbin <adurbin@google.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/pci/mmconfig-shared.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff -puN arch/i386/pci/mmconfig-shared.c~mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources-fix arch/i386/pci/mmconfig-shared.c
--- a/arch/i386/pci/mmconfig-shared.c~mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources-fix
+++ a/arch/i386/pci/mmconfig-shared.c
@@ -25,7 +25,7 @@
 DECLARE_BITMAP(pci_mmcfg_fallback_slots, 32*PCI_MMCFG_MAX_CHECK_BUS);
 
 /* Indicate if the mmcfg resources have been placed into the resource table. */
-static int __initdata pci_mmcfg_resources_inserted = 0;
+static int __initdata pci_mmcfg_resources_inserted;
 
 /* K8 systems have some devices (typically in the builtin northbridge)
    that are only accessible using type1
@@ -275,12 +275,13 @@ void __init pci_mmcfg_init(int type)
 		if (known_bridge)
 			pci_mmcfg_insert_resources(IORESOURCE_BUSY);
 		pci_probe = (pci_probe & ~PCI_PROBE_MASK) | PCI_PROBE_MMCONF;
-	} else
+	} else {
 		/*
 		 * Signal not to attempt to insert mmcfg resources because
 		 * the architecture mmcfg setup could not initialize.
 		 */
 		pci_mmcfg_resources_inserted = 1;
+	}
 }
 
 static int __init pci_mmcfg_late_insert_resources(void)
@@ -288,7 +289,7 @@ static int __init pci_mmcfg_late_insert_
 	/*
 	 * If resources are already inserted or we are not using MMCONFIG,
 	 * don't insert the resources.
-	 * */
+	 */
 	if ((pci_mmcfg_resources_inserted == 1) ||
 	    (pci_probe & PCI_PROBE_MMCONF) == 0 ||
 	    (pci_mmcfg_config_num == 0) ||
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
freezer-fix-kthread_create-vs-freezer-theoretical-race.patch
capabilityh-warning-fix.patch
simplify-cleanup_workqueue_thread.patch
capifunc-warning-fixes.patch
hardware-eicon-messagec-warning-fixes.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
invalidate_mapping_pages-add-cond_resched.patch
git-acpi-export-acpi_set_cstate_limit.patch
git-alsa-fixup.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-cpufreq-fix.patch
8xx-mpc885ads-pcmcia-support.patch
fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
driver-core-check-return-code-of-sysfs_create_link.patch
git-dvb.patch
cinergyt2-fix-file-release-handler.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-input.patch
git-kvm.patch
git-leds.patch
git-leds-fixup.patch
drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61.patch
ide-warning-fixes.patch
git-mips-fixup.patch
git-mtd.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver.patch
git-ubi.patch
git-battery.patch
git-nfs-server-cluster-locking-api-fixup.patch
git-parisc.patch
pci-x-pci-express-read-control-interfaces-fix.patch
git-pciseg.patch
sh-support-older-gccs.patch
scsi-fix-config_scsi_wait_scan=m.patch
ncr5380-warning-fixes.patch
git-unionfs.patch
fix-gregkh-usb-usb-r8a66597-hcd-host-controller-driver-for-r8a66597.patch
git-wireless.patch
arch-x86_64-vdso-vmac-needs-schedh.patch
fix-x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
i386-add-support-for-picopower-irq-router.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources-fix.patch
x86_64-fix-smp_call_function_single-return-value.patch
xfs-clean-up-shrinker-games.patch
git-cryptodev.patch
x86_64-allocate-sparsemem-memmap-above-4g-fix.patch
change-zonelist-order-v6-zonelist-fix.patch
lazy-freeing-of-memory-through-madv_free.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
create-the-zone_movable-zone-fix.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix-2.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
maps2-add-proc-pid-pagemap-interface.patch
fs-introduce-some-page-buffer-invariants-obnoxiousness.patch
alpha-support-graphics-on-non-zero-pci-domains-fix.patch
alpha-support-graphics-on-non-zero-pci-domains-fix-2.patch
freezer-run-show_state-when-freezing-times-out.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
use-write_trylock_irqsave-in-ptrace_attach-fix.patch
add-lzo1x-compression-support-to-the-kernel-fix.patch
use-no_pci_devices-in-pci-searchc.patch
introduce-boot-based-time-fix.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
fuse-warning-fix.patch
vxfs-warning-fixes.patch
percpu_counters-use-cpu-notifiers.patch
percpu_counters-use-for_each_online_cpu.patch
rd-mark-ramdisk-buffer-heads-dirty-in-ramdisk_set_page_dirty-fix.patch
mpu401-warning-fixes.patch
procfs-directory-entry-cleanup-fix.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
crc7-support-fix.patch
i2o_cfg_passthru-cleanup-fix.patch
knfsd-exportfs-add-exportfsh-header-fix.patch
knfsd-exportfs-remove-iget-abuse-fix.patch
nfsd-warning-fix.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
lguest-the-host-code-borkages.patch
cfs-scheduler-vs-detach-schedh-from-mmh.patch
cfs-scheduler-warning-fixes.patch
reiser4.patch
reiser4-fix.patch
vdso-print-fatal-signals.patch
check_dirty_inode_list.patch
w1-build-fix.patch
