From: akpm@linux-foundation.org
Subject: - working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch removed from -mm tree
Date: Wed, 23 May 2007 14:13:06 -0700
Message-ID: <200705232113.l4NLD6WJ032183@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:57734 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755981AbXEWVNU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 May 2007 17:13:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andi@lisas.de, davej@codemonkey.org.uk, mm-commits@vger.kernel.org


The patch titled
     working-3d-dri-intel-agpko-resume-for-i815-chip-tidy
has been removed from the -mm tree.  Its filename was
     working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch

This patch was dropped because it was folded into working-3d-dri-intel-agpko-resume-for-i815-chip.patch

------------------------------------------------------
Subject: working-3d-dri-intel-agpko-resume-for-i815-chip-tidy
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Andreas Mohr <andi@lisas.de>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/intel-agp.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff -puN drivers/char/agp/intel-agp.c~working-3d-dri-intel-agpko-resume-for-i815-chip-tidy drivers/char/agp/intel-agp.c
--- a/drivers/char/agp/intel-agp.c~working-3d-dri-intel-agpko-resume-for-i815-chip-tidy
+++ a/drivers/char/agp/intel-agp.c
@@ -2030,8 +2030,10 @@ static int agp_i815_remember_state(struc
 	 * to be able to successfully restore X11 when AGP 3D is enabled
 	 * (register values given are after resume vs. before suspend):
 	 *
-	 * I815_GMCHCFG (0x50; we need to set bit 1 (Aperture Access Global Enable) of I815_APCONT (0x51),
-	 *              thus use I815_GMCHCFG (0x50) as 32bit base register); 0x4fdd0040 instead of 0x4fdd0240
+	 * I815_GMCHCFG (0x50; we need to set bit 1 (Aperture Access Global
+	 *              Enable) of I815_APCONT (0x51),
+	 *              thus use I815_GMCHCFG (0x50) as 32bit base register);
+	 *              0x4fdd0040 instead of 0x4fdd0240
 	 * ??? (0x80); 0x07ce1cde instead of 0x07cb94de
 	 * I815_SM_RCOMP (0x98); 0x80648064 instead of 0x80548054
 	 * I815_SM (0x9c); 0x00c48405 instead of 0x04848405
@@ -2039,7 +2041,8 @@ static int agp_i815_remember_state(struc
 	 * INTEL_AGPCTRL (0xb0); 0x00000000 instead of 0x00000080
 	 * INTEL_APSIZE (0xb4);
 	 * INTEL_ATTBASE (0xb8); 0x00000000 instead of 0x024b0000
-	 * I815_ERRSTS?? (0xc8; undocumented for i815, see above); 0x00000000 instead of 0x00000800
+	 * I815_ERRSTS?? (0xc8; undocumented for i815, see above);
+	 *              0x00000000 instead of 0x00000800
 	 * ??? (0xe8); 0x1c700000 instead of 0x18500000
 	 *
 	 * Other machines/chipsets/BIOS versions may require
@@ -2062,12 +2065,12 @@ static int agp_i815_remember_state(struc
 
 	if (restore) {
 		u32 val;
-		for (p = i815_saved_regs; (p->reg != 0); p++)
-		{
+		for (p = i815_saved_regs; (p->reg != 0); p++) {
 			pci_read_config_dword(pdev, p->reg, &val);
 			if (val != p->value) {
-				printk(KERN_DEBUG "AGP: Writing back config space on "
-					"device %s at offset %x (was %x, writing %x)\n",
+				printk(KERN_DEBUG "AGP: Writing back config "
+					"space on device %s at offset %x (was "
+					"%x, writing %x)\n",
 					pci_name(pdev), p->reg,
 					val, p->value);
 				pci_write_config_dword(pdev, p->reg,
@@ -2096,8 +2099,8 @@ static int agp_i815_remember_state(struc
  * should be cleaned up, probably by implementing a generic Linux
  * PCI function to save/restore extended PCI config space
  * by supplying a register array or so...
- * At this point, it would also be nice to clean up the _suspend()/_resume() functions
- * to use some non-ugly and nicely generic restore mechanism.
+ * At this point, it would also be nice to clean up the _suspend()/_resume()
+ * functions to use some non-ugly and nicely generic restore mechanism.
  */
 #define DEBUG_AGP_PM 0
 
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
working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch
git-cpufreq-fix.patch
8xx-mpc885ads-pcmcia-support-fix.patch
fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
driver-core-check-return-code-of-sysfs_create_link-fix.patch
git-dvb.patch
cinergyt2-fix-file-release-handler.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-input.patch
git-kvm.patch
git-leds.patch
git-leds-fixup.patch
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
