From: akpm@linux-foundation.org
Subject: - cputopology-always-define-cpu-topology-information-cleanup.patch removed from -mm tree
Date: Mon, 23 Jun 2008 14:02:44 -0700
Message-ID: <200806232102.m5NL2ic0016103@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36589 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755541AbYFWVDb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jun 2008 17:03:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bhutchings@solarflare.com, clameter@sgi.com, hawkes@sgi.com, mingo@elte.hu, nickpiggin@yahoo.com.au, sekharan@us.ibm.com, suresh.b.siddha@intel.com, travis@


The patch titled
     cputopology-always-define-cpu-topology-information-cleanup
has been removed from the -mm tree.  Its filename was
     cputopology-always-define-cpu-topology-information-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cputopology-always-define-cpu-topology-information-cleanup
From: Andrew Morton <akpm@linux-foundation.org>

- fold now-duplicated code

- fix layout

Cc: Ben Hutchings <bhutchings@solarflare.com>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: John Hawkes <hawkes@sgi.com>
Cc: Mike Travis <travis@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Zhang, Yanmin <yanmin.zhang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/topology.c |   23 ++---------------------
 1 file changed, 2 insertions(+), 21 deletions(-)

diff -puN drivers/base/topology.c~cputopology-always-define-cpu-topology-information-cleanup drivers/base/topology.c
--- a/drivers/base/topology.c~cputopology-always-define-cpu-topology-information-cleanup
+++ a/drivers/base/topology.c
@@ -57,9 +57,8 @@ static ssize_t show_cpumap(int type, cpu
 }
 #endif
 
-#ifdef arch_provides_topology_pointers
 #define define_siblings_show_map(name)					\
-static ssize_t show_##name(struct sys_device *dev, char *buf)	\
+static ssize_t show_##name(struct sys_device *dev, char *buf)		\
 {									\
 	unsigned int cpu = dev->id;					\
 	cpumask_t siblings = topology_##name(cpu);			\
@@ -67,31 +66,13 @@ static ssize_t show_##name(struct sys_de
 }
 
 #define define_siblings_show_list(name)					\
-static ssize_t show_##name##_list(struct sys_device *dev, char *buf) \
+static ssize_t show_##name##_list(struct sys_device *dev, char *buf)	\
 {									\
 	unsigned int cpu = dev->id;					\
 	cpumask_t siblings = topology_##name(cpu);			\
 	return show_cpumap(1, &siblings, buf);				\
 }
 
-#else
-#define define_siblings_show_map(name)					\
-static ssize_t show_##name(struct sys_device *dev, char *buf)	\
-{									\
-	unsigned int cpu = dev->id;					\
-	cpumask_t mask = topology_##name(cpu);				\
-	return show_cpumap(0, &mask, buf);				\
-}
-
-#define define_siblings_show_list(name)					\
-static ssize_t show_##name##_list(struct sys_device *dev, char *buf) \
-{									\
-	unsigned int cpu = dev->id;					\
-	cpumask_t mask = topology_##name(cpu);				\
-	return show_cpumap(1, &mask, buf);				\
-}
-#endif
-
 #define define_siblings_show_func(name)		\
 	define_siblings_show_map(name); define_siblings_show_list(name)
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
revert-git-pekka.patch
fix-kobject-fix-kobject_rename-and-config_sysfs.patch
kvm-is-busted-on-ia64.patch
drivers-mtd-nand-nandsimc-needs-div64h.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex.patch
i2c-renesas-highlander-fpga-smbus-support.patch
git-jg-misc-git-rejects.patch
drivers-scsi-broadsasc-fix-uninitialised-var-warning.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
mmc-sd-host-driver-for-ricoh-bay1controllers.patch
drivers-mtd-devices-block2mtdc-suppress-warning.patch
sundance-set-carrier-status-on-link-change-events.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix-fix.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-scsi-misc-fix-scsi_dh-build-errors.patch
drivers-scsi-qla2xxx-qla_osc-suppress-uninitialized-var-warning.patch
s390-uninline-spinlock-functions-which-use-smp_processor_id.patch
pktcdvd-push-bkl-down-into-driver-fix.patch
git-unionfs.patch
git-unionfs-fixup.patch
git-logfs-fixup.patch
watchdog-wdt501-pci-clean-up-coding-style-and-switch-to-unlocked_ioctl.patch
git-xtensa.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
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
hugetlb-modular-state-for-hugetlb-page-size-checkpatch-fixes.patch
hugetlb-multiple-hstates-for-multiple-page-sizes-checkpatch-fixes.patch
hugetlb-override-default-huge-page-size-ia64-build.patch
linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
revert-revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
revert-revert-revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
bootmem-add-debugging-framework-fix.patch
bootmem-clean-up-free_all_bootmem_core-fix.patch
bootmem-free-reserve-helpers-fix.patch
revert-revert-revert-revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
bootmem-factor-out-the-marking-of-a-pfn-range-fix.patch
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
oprofile-multiplexing-checkpatch-fixes.patch
gpio-gpio-driver-for-max7301-spi-gpio-expander-checkpatch-fixes.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
atmel_lcdfb-avoid-division-by-zero-checkpatch-fixes.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes-fix.patch
reiserfs-convert-j_flush_sem-to-mutex.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch
quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix.patch
quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix-fix.patch
memcg-remove-refcnt-from-page_cgroup-fix-2.patch
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
tpm-increase-size-of-internal-tpm-response-buffers-checkpatch-fixes.patch
memstick-allow-set_param-method-to-return-an-error-code-checkpatch-fixes.patch
memstick-use-fully-asynchronous-request-processing-fix.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
mm-introduce-get_user_pages_fast-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-2.patch
x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
vmscan-move-isolate_lru_page-to-vmscanc-fix.patch
define-page_file_cache-function-fix.patch
unevictable-lru-infrastructure-fix.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
vmscan-unevictable-lru-scan-sysctl-nommu-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
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

