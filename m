From: akpm@linux-foundation.org
Subject: + intel-agp-rewrite-gtt-on-resume-checkpatch-fixes.patch added to -mm tree
Date: Fri, 06 Jun 2008 13:49:23 -0700
Message-ID: <200806062049.m56KnO1x018722@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47312 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751748AbYFFUtx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jun 2008 16:49:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, airlied@linux.ie, andi@firstfloor.org, davej@codemonkey.org.uk, keithp@keithp.com


The patch titled
     intel-agp-rewrite-gtt-on-resume-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     intel-agp-rewrite-gtt-on-resume-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: intel-agp-rewrite-gtt-on-resume-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: space prohibited between function name and open parenthesis '('
#63: FILE: drivers/char/agp/generic.c:429:
+	list_add (&curr->mapped_list, &agp_bridge->mapped_list);

WARNING: space prohibited between function name and open parenthesis '('
#72: FILE: drivers/char/agp/generic.c:463:
+	list_del (&curr->mapped_list);

WARNING: space prohibited between function name and open parenthesis '('
#80: FILE: drivers/char/agp/generic.c:471:
+int agp_rebind_memory (void)

WARNING: space prohibited between function name and open parenthesis '('
#146: FILE: include/linux/agp_backend.h:111:
+extern int agp_rebind_memory (void);

total: 0 errors, 4 warnings, 93 lines checked

./patches/intel-agp-rewrite-gtt-on-resume.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Andi Kleen <andi@firstfloor.org>
Cc: Dave Airlie <airlied@linux.ie>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Keith Packard <keithp@keithp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/generic.c  |    6 +++---
 include/linux/agp_backend.h |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/char/agp/generic.c~intel-agp-rewrite-gtt-on-resume-checkpatch-fixes drivers/char/agp/generic.c
--- a/drivers/char/agp/generic.c~intel-agp-rewrite-gtt-on-resume-checkpatch-fixes
+++ a/drivers/char/agp/generic.c
@@ -426,7 +426,7 @@ int agp_bind_memory(struct agp_memory *c
 
 	curr->is_bound = TRUE;
 	curr->pg_start = pg_start;
-	list_add (&curr->mapped_list, &agp_bridge->mapped_list);
+	list_add(&curr->mapped_list, &agp_bridge->mapped_list);
 
 	return 0;
 }
@@ -460,7 +460,7 @@ int agp_unbind_memory(struct agp_memory 
 
 	curr->is_bound = FALSE;
 	curr->pg_start = 0;
-	list_del (&curr->mapped_list);
+	list_del(&curr->mapped_list);
 	return 0;
 }
 EXPORT_SYMBOL(agp_unbind_memory);
@@ -468,7 +468,7 @@ EXPORT_SYMBOL(agp_unbind_memory);
 /**
  *	agp_rebind_emmory  -  Rewrite the entire GATT, useful on resume
  */
-int agp_rebind_memory (void)
+int agp_rebind_memory(void)
 {
 	struct agp_memory *curr;
 	int ret_val;
diff -puN include/linux/agp_backend.h~intel-agp-rewrite-gtt-on-resume-checkpatch-fixes include/linux/agp_backend.h
--- a/include/linux/agp_backend.h~intel-agp-rewrite-gtt-on-resume-checkpatch-fixes
+++ a/include/linux/agp_backend.h
@@ -108,7 +108,7 @@ extern struct agp_memory *agp_allocate_m
 extern int agp_copy_info(struct agp_bridge_data *, struct agp_kern_info *);
 extern int agp_bind_memory(struct agp_memory *, off_t);
 extern int agp_unbind_memory(struct agp_memory *);
-extern int agp_rebind_memory (void);
+extern int agp_rebind_memory(void);
 extern void agp_enable(struct agp_bridge_data *, u32);
 extern struct agp_bridge_data *agp_backend_acquire(struct pci_dev *);
 extern void agp_backend_release(struct agp_bridge_data *);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

pagemap-fix-bug-in-add_to_pagemap-require-aligned-length-reads-of-proc-pid-pagemap-v2-of-series.patch
rtc-class-driver-for-ppc_md-rtc-functions.patch
proc-calculate-the-correct-proc-pid-link-count.patch
linux-next.patch
next-remove-localversion.patch
linux-next-fixup.patch
linux-next-rtc-fix.patch
fix-kobject-fix-kobject_rename-and-config_sysfs.patch
kvm-is-busted-on-ia64.patch
drivers-net-usb-kawethc-fix-printk-warning.patch
mtd-unbork.patch
revert-x86-remove-the-static-256k-node_to_cpumask_map.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
lguest-use-cpu-capability-accessors.patch
intel-agp-rewrite-gtt-on-resume-checkpatch-fixes.patch
arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex.patch
pcmcia-add-support-the-cf-pcmcia-driver-for-blackfin-try-2.patch
arch-powerpc-platforms-pseries-eeh_driverc-fix-warning.patch
arch-powerpc-platforms-pseries-eeh_driverc-fix-warning-checkpatch-fixes.patch
i2c-renesas-highlander-fpga-smbus-support.patch
git-jg-misc-git-rejects.patch
drivers-scsi-broadsasc-fix-uninitialised-var-warning.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
git-leds.patch
fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch
mmc-sd-host-driver-for-ricoh-bay1controllers.patch
drivers-mtd-devices-block2mtdc-suppress-warning.patch
bluetooth-hci_bcspc-small-cleanups-api-users-fix.patch
sundance-set-carrier-status-on-link-change-events.patch
net-sh_eth-add-support-for-renesas-superh-ethernet-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
pci-introduce-pci_slot.patch
acpi-pci-slot-detection-driver.patch
git-scsi-misc-fix-scsi_dh-build-errors.patch
drivers-scsi-qla2xxx-qla_osc-suppress-uninitialized-var-warning.patch
s390-uninline-spinlock-functions-which-use-smp_processor_id.patch
pktcdvd-push-bkl-down-into-driver-fix.patch
git-unionfs.patch
git-unionfs-fixup.patch
git-logfs-fixup.patch
drivers-usb-host-isp1760-hcdc-procesxor-flags-have-type-unsigned-long.patch
drivers-uwb-wlp-sysfsc-dead-code.patch
usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues-fix.patch
usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues-fix-2.patch
watchdog-pcwd-clean-up-unlocked_ioctl-usage-fix.patch
watchdog-wdt501-pci-clean-up-coding-style-and-switch-to-unlocked_ioctl-fix.patch
git-xtensa.patch
ext4-is-busted-on-m68k.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
forcedeth-msi-interrupts-uninlining.patch
mm-verify-the-page-links-and-memory-model.patch
mspec-convert-nopfn-to-fault-fix.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
kill-generic_file_direct_io-checkpatch-fixes.patch
use-generic_access_phys-for-dev-mem-mappings-fix.patch
spufs-use-the-new-vm_ops-access-fix.patch
fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries-fix.patch
page-flags-record-page-flag-overlays-explicitly-xen.patch
mapping_set_error-add-unlikely.patch
huge-page-private-reservation-review-cleanups-fix.patch
sync_file_range_write-may-and-will-block-document-that-fix.patch
vmallocinfo-add-numa-information-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
security-protect-legacy-apps-from-insufficient-privilege-cleanup.patch
swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option-fix.patch
split-the-typecheck-macros-out-of-include-linux-kernelh.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-fix.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
build-kernel-profileo-only-when-requested-cleanups.patch
fs-partition-checkc-fix-return-value-warning-v2-cleanup.patch
block-ioctlc-and-fs-partition-checkc-checkpatch-fixes.patch
rename-warn-to-warning-to-clear-the-namespace-fix.patch
add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch
flag-parameters-paccept-fix.patch
flag-parameters-paccept-sys_ni.patch
flag-parameters-anon_inode_getfd-extension-fix.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
flag-parameters-inotify_init-fix.patch
flag-parameters-check-magic-constants-alpha.patch
cputopology-always-define-cpu-topology-information-cleanup.patch
oprofile-multiplexing-checkpatch-fixes.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
pnp-convert-resource-options-to-single-linked-list-checkpatch-fixes.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes-fix.patch
reiserfs-convert-j_flush_sem-to-mutex.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch
quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix.patch
quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix-fix.patch
jbd2-fix-race-between-jbd2_journal_try_to_free_buffers-and-jbd2-commit-transaction-cleanup.patch
ipc-semc-convert-undo-structures-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-convert-sem_arraysem_pending-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-rewrite-undo-list-locking-checkpatch-fixes.patch
getdelaysc-add-a-usr1-signal-handler-checkpatch-fixes.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sge-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-svc_rdma-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-bnx2x.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sparc32.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
reiser4.patch
reiser4-semaphore-fix.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

