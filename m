From: akpm@linux-foundation.org
Subject: - pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch removed from -mm tree
Date: Wed, 23 May 2007 14:22:32 -0700
Message-ID: <200705232122.l4NLMXpT032429@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46879 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754072AbXEWVWi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 May 2007 17:22:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, htejun@gmail.com, mm-commits@vger.kernel.org


The patch titled
     pata_acpi-restore-driver versus libata-clean-up-sff-init-mess
has been removed from the -mm tree.  Its filename was
     pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch

This patch was dropped because it was folded into pata_acpi-restore-driver.patch

------------------------------------------------------
Subject: pata_acpi-restore-driver versus libata-clean-up-sff-init-mess
From: Andrew Morton <akpm@linux-foundation.org>

If you apply both libata-clean-up-sff-init-mess.patch and
pata_acpi-restore-driver.patch, you'll need to add this patch to
pata_acpi-restore-driver.patch

Cc: Tejun Heo <htejun@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_acpi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/ata/pata_acpi.c~pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix drivers/ata/pata_acpi.c
--- a/drivers/ata/pata_acpi.c~pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix
+++ a/drivers/ata/pata_acpi.c
@@ -371,7 +371,7 @@ static const struct ata_port_operations 
 
 static int pacpi_init_one (struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	static struct ata_port_info info = {
+	static const struct ata_port_info info = {
 		.sht		= &pacpi_sht,
 		.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 
@@ -381,11 +381,11 @@ static int pacpi_init_one (struct pci_de
 
 		.port_ops	= &pacpi_ops,
 	};
-	struct ata_port_info *port_info[1] = { &info };
+	const struct ata_port_info *ppi[] = { &info, NULL };
 
 	if (!ata_pata_acpi_present(pdev))
 		return -ENODEV;
-	return ata_pci_init_one(pdev, port_info, 1);
+	return ata_pci_init_one(pdev, ppi);
 }
 
 static const struct pci_device_id pacpi_pci_tbl[] = {
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
pata_acpi-restore-driver.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix.patch
drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix-tidy.patch
ide-warning-fixes.patch
git-mips-fixup.patch
git-mtd.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices-fix.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver-build-fix.patch
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
