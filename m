From: akpm@linux-foundation.org
Subject: - revert-x86_64-hpet-tsc-calibration-fix-broken-smi-detection-logic.patch removed from -mm tree
Date: Thu, 19 Jul 2007 12:39:47 -0700
Message-ID: <200707191939.l6JJdl6c018562@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51459 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762802AbXGSTkj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 15:40:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@suse.de, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     revert x86_64-hpet-tsc-calibration-fix-broken-smi-detection-logic
has been removed from the -mm tree.  Its filename was
     revert-x86_64-hpet-tsc-calibration-fix-broken-smi-detection-logic.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: revert x86_64-hpet-tsc-calibration-fix-broken-smi-detection-logic
From: Andrew Morton <akpm@linux-foundation.org>

Revert it again so that x86_64-convert-to-cleckevents/patch will apply.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>                                                     Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/hpet.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86_64/kernel/hpet.c~revert-x86_64-hpet-tsc-calibration-fix-broken-smi-detection-logic arch/x86_64/kernel/hpet.c
--- a/arch/x86_64/kernel/hpet.c~revert-x86_64-hpet-tsc-calibration-fix-broken-smi-detection-logic
+++ a/arch/x86_64/kernel/hpet.c
@@ -190,7 +190,7 @@ int hpet_reenable(void)
  */
 
 #define TICK_COUNT 100000000
-#define SMI_THRESHOLD 50000
+#define TICK_MIN   5000
 #define MAX_TRIES  5
 
 /*
@@ -205,7 +205,7 @@ static void __init read_hpet_tsc(int *hp
 		tsc1 = get_cycles_sync();
 		hpet1 = hpet_readl(HPET_COUNTER);
 		tsc2 = get_cycles_sync();
-		if ((tsc2 - tsc1) < SMI_TRESHOLD)
+		if (tsc2 - tsc1 > TICK_MIN)
 			break;
 	}
 	*hpet = hpet1;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
git-acpi-fix-git-rejects.patch
acpi-add-reboot-mechanism-fix.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
revert-gregkh-driver-block-device.patch
git-dvb.patch
git-input.patch
adbhid-produce-all-capslock-key-events-fix.patch
git-kbuild.patch
git-kvm.patch
git-leds.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
git-mtd.patch
e1000new-build-fix.patch
e1000new-build-fix-2.patch
revert-gregkh-pci-pci_bridge-device.patch
i386-add-support-for-picopower-irq-router.patch
git-scsi-misc.patch
aacraid-rename-check_reset.patch
git-unionfs.patch
git-block-vs-git-unionfs.patch
x86_64-clean-up-apicid_to_node-declaration.patch
ntp-move-the-cmos-update-code-into-ntpc.patch
revert-x86_64-hpet-tsc-calibration-fix-broken-smi-detection-logic.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
x86_64-get-mp_bus_to_node-as-early.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
mmconfig-validate-against-acpi-motherboard-resources.patch
git-xfs.patch
git-kgdb-fixup.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
hugetlbfs-read-support-fix.patch
security-convert-lsm-into-a-static-interface-fix.patch
file-capabilities-clear-caps-cleanup-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
containersv10-basic-container-framework-fix.patch
containersv10-basic-container-framework-fix-2.patch
containersv10-example-cpu-accounting-subsystem-fix.patch
containersv10-add-tasks-file-interface-fix.patch
containersv10-add-fork-exit-hooks-fix.patch
containersv10-add-container_clone-interface-fix.patch
containersv10-add-procfs-interface-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-simple-debug-info-subsystem-fix-2.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
reiser4.patch
git-block-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
check_dirty_inode_list.patch
alloc_pages-debug.patch
w1-build-fix.patch
