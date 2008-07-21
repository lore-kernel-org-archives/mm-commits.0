From: akpm@linux-foundation.org
Subject: - gpio-gpio-driver-for-max7301-spi-gpio-expander-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 21 Jul 2008 14:19:31 -0700
Message-ID: <200807212119.m6LLJVm3025014@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39203 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751214AbYGUVUW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jul 2008 17:20:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, david-b@pacbell.net, g.liakhovetski@pengutronix.de, j.beisert@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     gpio-gpio-driver-for-max7301-spi-gpio-expander-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     gpio-gpio-driver-for-max7301-spi-gpio-expander-checkpatch-fixes.patch

This patch was dropped because it was folded into gpio-gpio-driver-for-max7301-spi-gpio-expander.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio-gpio-driver-for-max7301-spi-gpio-expander-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#124: FILE: drivers/gpio/max7301.c:76:
+static int max7301_write(struct spi_device *spi, unsigned int reg, unsigned int val)

ERROR: "(foo*)" should be "(foo *)"
#127: FILE: drivers/gpio/max7301.c:79:
+	return spi_write(spi, (const u8*)&word, sizeof(word));

ERROR: "(foo*)" should be "(foo *)"
#146: FILE: drivers/gpio/max7301.c:98:
+	if ((ret = spi_write(spi, (const u8*)&word, sizeof(word))) != 0)

ERROR: do not use assignment in if condition
#146: FILE: drivers/gpio/max7301.c:98:
+	if ((ret = spi_write(spi, (const u8*)&word, sizeof(word))) != 0)

ERROR: "(foo*)" should be "(foo *)"
#151: FILE: drivers/gpio/max7301.c:103:
+	if ((ret = spi_read(spi, (u8*)&word, sizeof(word))))

ERROR: do not use assignment in if condition
#151: FILE: drivers/gpio/max7301.c:103:
+	if ((ret = spi_read(spi, (u8*)&word, sizeof(word))))

WARNING: line over 80 characters
#352: FILE: drivers/gpio/max7301.c:304:
+		dev_err(&spi->dev, "Failed to remove the GPIO controller: %d\n", ret);

total: 5 errors, 2 warnings, 361 lines checked

./patches/gpio-gpio-driver-for-max7301-spi-gpio-expander.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: David Brownell <david-b@pacbell.net>
Cc: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Cc: Juergen Beisert <j.beisert@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/max7301.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN drivers/gpio/max7301.c~gpio-gpio-driver-for-max7301-spi-gpio-expander-checkpatch-fixes drivers/gpio/max7301.c
--- a/drivers/gpio/max7301.c~gpio-gpio-driver-for-max7301-spi-gpio-expander-checkpatch-fixes
+++ a/drivers/gpio/max7301.c
@@ -76,7 +76,7 @@ struct max7301 {
 static int max7301_write(struct spi_device *spi, unsigned int reg, unsigned int val)
 {
 	u16 word = ((reg & 0x7F) << 8) | (val & 0xFF);
-	return spi_write(spi, (const u8*)&word, sizeof(word));
+	return spi_write(spi, (const u8 *)&word, sizeof(word));
 }
 
 /**
@@ -95,12 +95,14 @@ static int max7301_read(struct spi_devic
 	u16 word;
 
 	word = 0x8000 | (reg << 8);
-	if ((ret = spi_write(spi, (const u8*)&word, sizeof(word))) != 0)
+	ret = spi_write(spi, (const u8 *)&word, sizeof(word));
+	if (ret)
 		return ret;
 	/*
 	 * FIXME: This read should write 0x0000 (=NOOP at MAX7301 side)
 	 */
-	if ((ret = spi_read(spi, (u8*)&word, sizeof(word))))
+	ret = spi_read(spi, (u8 *)&word, sizeof(word));
+	if (ret)
 		return ret;
 	return word;
 }
@@ -301,7 +303,8 @@ static int max7301_remove(struct spi_dev
 		mutex_destroy(&ts->lock);
 		kfree(ts);
 	} else
-		dev_err(&spi->dev, "Failed to remove the GPIO controller: %d\n", ret);
+		dev_err(&spi->dev, "Failed to remove the GPIO controller: %d\n",
+			ret);
 
 	return ret;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
gpio-gpio-driver-for-max7301-spi-gpio-expander.patch
gpio-gpio-driver-for-max7301-spi-gpio-expander-checkpatch-fixes.patch
arm-fix-fls-for-64-bit-arguments.patch
linux-next.patch
linux-next-fixup.patch
next-remove-localversion.patch
kvm-is-busted-on-ia64.patch
drivers-mtd-nand-nandsimc-needs-div64h.patch
pci-make-pci_register_driver-a-macro.patch
git-acpi.patch
git-dvb.patch
i2c-renesas-highlander-fpga-smbus-support.patch
git-hid.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
git-jg-misc.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
git-kvm.patch
git-leds.patch
git-async-tx.patch
git-mtd.patch
bridge-send-correct-mtu-value-in-pmtu-checkpatch-fixes.patch
sundance-set-carrier-status-on-link-change-events.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
use-sysdev_class-in-schedc-fix.patch
git-sh.patch
drivers-scsi-qla2xxx-qla_osc-suppress-uninitialized-var-warning.patch
git-unionfs.patch
git-logfs-git-rejects.patch
git-logfs-fixup.patch
drivers-usb-class-cdc-acmc-use-correct-type-for-cpu-flags.patch
drivers-usb-class-cdc-wdmc-fix-build-with-config_pm=n.patch
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
vma-page-offset-has-no-callees-drop-it.patch
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
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-v850-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-powerpc-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-arm-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-mips-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-dvb.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-mtd-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-powerpc-fixes.patch
mmu-notifiers-add-mm_take_all_locks-operation-checkpatch-fixes.patch
mmu-notifier-core-checkpatch-fixes.patch
mmu-notifier-core-fix.patch
mmu-notifier-core-fix-2.patch
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
seq_file-fix-bug-when-seq_read-reads-nothing-fix.patch
exec-remove-some-includes-fix.patch
inflate-refactor-inflate-malloc-code-checkpatch-fixes.patch
add-a-warn-macro-this-is-warn_on-printk-arguments.patch
flag-parameters-paccept-fix.patch
flag-parameters-paccept-sys_ni.patch
flag-parameters-anon_inode_getfd-extension-fix.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
flag-parameters-inotify_init-fix.patch
flag-parameters-check-magic-constants-alpha.patch
spi-au1550_spi-improve-pio-transfer-mode-checkpatch-fixes.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-fix.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-cleanup.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
atmel_lcdfb-avoid-division-by-zero-checkpatch-fixes.patch
sm501-fixup-allocation-code-to-be-64bit-resource-compliant-sm501-align-panel-fb-to-page_size-fix.patch
lcd-add-platform_lcd-driver-fix.patch
fsl-diu-fb-update-freescale-diu-driver-to-use-page_alloc_exact.patch
fbdev-add-new-cobalt-lcd-framebuffer-driver.patch
eink_apollofb-new-driver-for-apollo-eink-controller-cleanup.patch
fbcon-remove-stray-semicolons-checkpatch-fixes.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes-fix.patch
ext3-handle-corrupted-orphan-list-at-mount-cleanup.patch
ext3-handle-corrupted-orphan-list-at-mount-fix.patch
ext3-handle-corrupted-orphan-list-at-mount-cleanup-fix.patch
ext3-handle-deleting-corrupted-indirect-blocks-fix.patch
jbd-dont-abort-if-flushing-file-data-failed-fix.patch
reiserfs-convert-j_flush_sem-to-mutex.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch
quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix.patch
quota-move-function-macros-from-quotah-to-quotaopsh-jfs-fix-fix.patch
cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup-fix.patch
cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup-checkpatch-fixes.patch
devcgroup-code-cleanup-fix.patch
memcg-remove-refcnt-from-page_cgroup-fix-2.patch
coredump-format_corename-fix-the-core_uses_pid-logic-checkpatch-fixes.patch
workqueues-make-get_online_cpus-useable-for-work-func-fix.patch
ipc-semc-convert-undo-structures-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-convert-sem_arraysem_pending-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-rewrite-undo-list-locking-checkpatch-fixes.patch
fs-partition-checkc-fix-return-value-warning-v2-cleanup.patch
block-ioctlc-and-fs-partition-checkc-checkpatch-fixes.patch
getdelaysc-add-a-usr1-signal-handler-checkpatch-fixes.patch
edac-mpc85xx-fix-pci-ofdev-2nd-pass-checkpatch-fixes.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sge-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-svc_rdma-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-bnx2x.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-s2io.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-pasemi_mac.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix.patch
x86-calgary-fix-handling-of-devices-that-arent-behind-the-calgary-checkpatch-fixes.patch
calgary-iommu-use-the-first-kernels-tce-tables-in-kdump-coding-style-fixes.patch
tpm-increase-size-of-internal-tpm-response-buffers-checkpatch-fixes.patch
memstick-allow-set_param-method-to-return-an-error-code-checkpatch-fixes.patch
memstick-use-fully-asynchronous-request-processing-fix.patch
full-conversion-to-early_initcall-interface-remove-old-interface-cleanup.patch
full-conversion-to-early_initcall-interface-remove-old-interface-fix.patch
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
vmscan-split-lru-lists-into-anon-file-sets-units-fix.patch
unevictable-lru-infrastructure-fix.patch
unevictable-lru-page-statistics-units-fix.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
vmscan-unevictable-lru-scan-sysctl-nommu-fix.patch
slb-drop-kmem-cache-argument-from-constructor-fix.patch
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

