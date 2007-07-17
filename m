From: akpm@linux-foundation.org
Subject: - isdn-capi-warning-fixes.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:03:48 -0700
Message-ID: <200707172303.l6HN3m1V011740@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34027 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936153AbXGQXP2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     isdn/capi warning fixes
has been removed from the -mm tree.  Its filename was
     isdn-capi-warning-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: isdn/capi warning fixes
From: Andrew Morton <akpm@linux-foundation.org>

drivers/isdn/capi/capi.c: In function 'handle_minor_send':
drivers/isdn/capi/capi.c:552: warning: cast from pointer to integer of different size

Of course, the code here might actually be buggy, in which case this patch
should not be applied?

Answer:

  No this field is ignored inside linux kernel.Yes this is ugly, but it's
  the CAPI spec for all OS.

  CAPI DATA_B3 Request/Indication CAPI Message has a mandatory field which
  represent the 32 bit buffer address of the payload data.  In linux the
  payload data do not use a sperate buffer, data follows directely after the
  CAPI Message in the same skb and we use this assumption inside the drivers,
  so we can ignore this field.

  Inside the linux CAPI implemetation we never use this field, so it could
  also have no value, but since random data in a message is bad as well (e.g. 
  displayed in CAPI traces) we set is to the most adequate value.

  Outside the kernel the capi20 library sets the correct addresses (there is
  an optional second field for 64 bit adresses for 64 bit systems, we do not
  use here).

Acked-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/capi/capi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/isdn/capi/capi.c~isdn-capi-warning-fixes drivers/isdn/capi/capi.c
--- a/drivers/isdn/capi/capi.c~isdn-capi-warning-fixes
+++ a/drivers/isdn/capi/capi.c
@@ -549,7 +549,7 @@ static int handle_minor_send(struct capi
 		capimsg_setu8 (skb->data, 5, CAPI_REQ);
 		capimsg_setu16(skb->data, 6, mp->msgid++);
 		capimsg_setu32(skb->data, 8, mp->ncci);	/* NCCI */
-		capimsg_setu32(skb->data, 12, (u32) skb->data); /* Data32 */
+		capimsg_setu32(skb->data, 12, (u32)(long)skb->data);/* Data32 */
 		capimsg_setu16(skb->data, 16, len);	/* Data length */
 		capimsg_setu16(skb->data, 18, datahandle);
 		capimsg_setu16(skb->data, 20, 0);	/* Flags */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-acpi.patch
git-acpi-fix-git-rejects.patch
acpi-add-reboot-mechanism-fix.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-cifs.patch
revert-gregkh-driver-block-device.patch
driver-core-check-return-code-of-sysfs_create_link.patch
revert-saa7134-fix-thread-shutdown-handling.patch
git-dvb.patch
git-dvb-saa7134-tvaudio-fix.patch
git-kbuild.patch
git-kvm.patch
git-leds.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
git-mips-fixup.patch
git-mtd.patch
git-ubi.patch
e1000new-build-fix.patch
e1000new-build-fix-2.patch
revert-gregkh-pci-pci_bridge-device.patch
aacraid-rename-check_reset.patch
git-unionfs.patch
git-block-vs-git-unionfs.patch
git-watchdog.patch
x86_64-mm-xen-attempt-to-patch-inline-versions-of-common-operations.patch
fix-x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
fix-x86_64-mm-sched-clock-share.patch
fix-x86_64-mm-add-common-orderly_poweroff.patch
i386-add-support-for-picopower-irq-router.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources.patch
x86_64-fix-smp_call_function_single-return-value.patch
i386-flush_tlb_kernel_range-add-reference-to-the-arguments.patch
mmconfig-validate-against-acpi-motherboard-resources.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch
x86-64-calgary-introduce-chipset-specific-ops.patch
x86-64-calgary-add-chip_ops-and-a-quirk-function-for-calioc2.patch
x86-64-calgary-reserve-tces-with-the-same-address-as-mem-regions.patch
x86-64-calgary-fix-few-style-problems-pointed-out-by-checkpatchpl.patch
i386-do-not-restore-reserved-memory-after-hibernation.patch
paravirt-helper-to-disable-all-io-space-fix.patch
i386-show-unhandled-signals.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh.patch
i386-add-cpu_relax-to-cmos_lock.patch
x86_64-flush_tlb_kernel_range-warning-fix.patch
x86_64-add-ioapic-nmi-support.patch
ntp-move-the-cmos-update-code-into-ntpc.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
x86_64-get-mp_bus_to_node-as-early.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
git-xfs.patch
git-kgdb-fixup.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
file-capabilities-clear-caps-cleanup-fix.patch
freezer-run-show_state-when-freezing-times-out.patch
pm-introduce-hibernation-and-suspend-notifiers.patch
pm-disable-usermode-helper-before-hibernation-and-suspend.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
lguest-the-host-code.patch
lguest-the-net-driver.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
drivers-edac-new-i82443bxgz-mc-driver-broken.patch
drivers-edac-fix-e752x-reversed-csrows-fix.patch
drivers-edac-new-pasemi-driver-fix.patch
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
lockstat-core-infrastructure.patch
lockdep-various-fixes.patch
lockstat-measure-lock-bouncing.patch
some-kmalloc-memset-kzalloc-tree-wide.patch
reiser4.patch
git-block-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
check_dirty_inode_list.patch
alloc_pages-debug.patch
w1-build-fix.patch
