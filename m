From: akpm@linux-foundation.org
Subject: - sm501-guess-n-giggle-build-fix.patch removed from -mm tree
Date: Wed, 02 Jul 2008 01:54:17 -0700
Message-ID: <200807020854.m628sHtZ008280@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50811 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753418AbYGBIyz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 04:54:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ben-linux@fluff.org, lizf@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     sm501: guess-n-giggle build fix?
has been removed from the -mm tree.  Its filename was
     sm501-guess-n-giggle-build-fix.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sm501: guess-n-giggle build fix?
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/sm501.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff -puN drivers/mfd/sm501.c~sm501-guess-n-giggle-build-fix drivers/mfd/sm501.c
--- a/drivers/mfd/sm501.c~sm501-guess-n-giggle-build-fix
+++ a/drivers/mfd/sm501.c
@@ -19,7 +19,9 @@
 #include <linux/device.h>
 #include <linux/platform_device.h>
 #include <linux/pci.h>
+#ifdef CONFIG_MFD_SM501_GPIO
 #include <linux/gpio.h>
+#endif
 #include <linux/i2c-gpio.h>
 
 #include <linux/sm501.h>
@@ -33,6 +35,7 @@ struct sm501_device {
 	struct platform_device		pdev;
 };
 
+#ifdef CONFIG_MFD_SM501_GPIO
 struct sm501_gpio;
 
 struct sm501_gpio_chip {
@@ -50,13 +53,15 @@ struct sm501_gpio {
 	void __iomem		*regs;
 	struct resource		*regs_res;
 };
+#endif
 
 struct sm501_devdata {
 	spinlock_t			 reg_lock;
 	struct mutex			 clock_lock;
 	struct list_head		 devices;
+#ifdef CONFIG_MFD_SM501_GPIO
 	struct sm501_gpio		 gpio;
-
+#endif
 	struct device			*dev;
 	struct resource			*io_res;
 	struct resource			*mem_res;
@@ -1116,6 +1121,7 @@ static inline int sm501_gpio_pin2nr(stru
 }
 #endif
 
+#ifdef CONFIG_MFD_SM501_GPIO
 static int sm501_register_gpio_i2c_instance(struct sm501_devdata *sm,
 					    struct sm501_platdata_gpio_i2c *iic)
 {
@@ -1168,6 +1174,7 @@ static int sm501_register_gpio_i2c(struc
 
 	return 0;
 }
+#endif
 
 /* sm501_dbg_regs
  *
@@ -1329,12 +1336,14 @@ static int sm501_init_dev(struct sm501_d
 			sm501_register_gpio(sm);
 	}
 
+#ifdef CONFIG_MFD_SM501_GPIO
 	if (pdata->gpio_i2c != NULL && pdata->gpio_i2c_nr > 0) {
 		if (!sm->gpio.registered)
 			dev_err(sm->dev, "no gpio registered for i2c gpio.\n");
 		else
 			sm501_register_gpio_i2c(sm, pdata);
 	}
+#endif
 
 	ret = sm501_check_clocks(sm);
 	if (ret) {
@@ -1643,8 +1652,10 @@ static void sm501_dev_remove(struct sm50
 
 	device_remove_file(sm->dev, &dev_attr_dbg_regs);
 
+#ifdef CONFIG_MFD_SM501_GPIO
 	if (sm->gpio.registered)
 		sm501_gpio_remove(sm);
+#endif
 }
 
 static void sm501_pci_remove(struct pci_dev *dev)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
rtc-x1205-fix-alarm-set-fix.patch
update-ntfs-help-text-fix.patch
cgroups-document-the-effect-of-attaching-pid-0-to-a-cgroup-fix.patch
spi-fix-the-read-path-in-spidev-cleanup.patch
security-filesystem-capabilities-fix-fragile-setuid-fixup-code-checkpatch-fixes.patch
doc-document-the-relax_domain_level-kernel-boot-argument-fix.patch
revert-introduce-rculisth.patch
linux-next.patch
next-remove-localversion.patch
linux-next-fixups.patch
fix-kobject-fix-kobject_rename-and-config_sysfs.patch
kvm-is-busted-on-ia64.patch
drivers-mtd-nand-nandsimc-needs-div64h.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
i2c-renesas-highlander-fpga-smbus-support.patch
tick-schedc-suppress-needless-timer-reprogramming-checkpatch-fixes.patch
git-jg-misc-git-rejects.patch
drivers-scsi-broadsasc-fix-uninitialised-var-warning.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
mmc-sd-host-driver-for-ricoh-bay1controllers.patch
drivers-mtd-devices-block2mtdc-suppress-warning.patch
bug-in-random32c-all-zero-outputs-with-probability-1-232-other-seeding-bugs-checkpatch-fixes.patch
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
hugetlb-reservations-fix-hugetlb-map_private-reservations-across-vma-splits-v2-fix.patch
linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
revert-revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
revert-revert-revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
bootmem-add-debugging-framework-fix.patch
bootmem-clean-up-free_all_bootmem_core-fix.patch
bootmem-free-reserve-helpers-fix.patch
revert-revert-revert-revert-linux-next-revert-bootmem-add-return-value-to-reserve_bootmem_node.patch
bootmem-factor-out-the-marking-of-a-pfn-range-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-v850-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-powerpc-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
security-protect-legacy-apps-from-insufficient-privilege-cleanup.patch
security-protect-legacy-applications-from-executing-with-insufficient-privilege-checkpatch-fixes.patch
swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option-fix.patch
split-the-typecheck-macros-out-of-include-linux-kernelh.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-fix.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
build-kernel-profileo-only-when-requested-cleanups.patch
fs-partition-checkc-fix-return-value-warning-v2-cleanup.patch
block-ioctlc-and-fs-partition-checkc-checkpatch-fixes.patch
seq_file-fix-bug-when-seq_read-reads-nothing-fix.patch
inflate-refactor-inflate-malloc-code-checkpatch-fixes.patch
add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch
flag-parameters-paccept-fix.patch
flag-parameters-paccept-sys_ni.patch
flag-parameters-anon_inode_getfd-extension-fix.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
flag-parameters-inotify_init-fix.patch
flag-parameters-check-magic-constants-alpha.patch
spi-au1550_spi-improve-pio-transfer-mode-checkpatch-fixes.patch
sm501-guess-n-giggle-build-fix.patch
gpio-gpio-driver-for-max7301-spi-gpio-expander-checkpatch-fixes.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-fix.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-cleanup.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
atmel_lcdfb-avoid-division-by-zero-checkpatch-fixes.patch
fsl-diu-fb-update-freescale-diu-driver-to-use-page_alloc_exact-fix.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes-fix.patch
ext3-handle-corrupted-orphan-list-at-mount-cleanup.patch
ext3-handle-corrupted-orphan-list-at-mount-fix.patch
ext3-handle-corrupted-orphan-list-at-mount-cleanup-fix.patch
jbd-dont-abort-if-flushing-file-data-failed-fix.patch
reiserfs-convert-j_flush_sem-to-mutex.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch
quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix.patch
quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix-fix.patch
cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup-checkpatch-fixes.patch
memcg-remove-refcnt-from-page_cgroup-fix-2.patch
workqueues-make-get_online_cpus-useable-for-work-func-fix.patch
jbd2-fix-race-between-jbd2_journal_try_to_free_buffers-and-jbd2-commit-transaction-cleanup.patch
ipc-semc-convert-undo-structures-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-convert-sem_arraysem_pending-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-rewrite-undo-list-locking-checkpatch-fixes.patch
getdelaysc-add-a-usr1-signal-handler-checkpatch-fixes.patch
edac-mpc85xx-fix-pci-ofdev-2nd-pass-checkpatch-fixes.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sge-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-svc_rdma-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-bnx2x.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sparc32.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix.patch
x86-calgary-fix-handling-of-devices-that-arent-behind-the-calgary-checkpatch-fixes.patch
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
video-console-sticonrec-make-code-static-checkpatch-fixes.patch
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

