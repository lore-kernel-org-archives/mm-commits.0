From: akpm@linux-foundation.org
Subject: - linux-next-git-rejects.patch removed from -mm tree
Date: Mon, 23 Jun 2008 12:34:37 -0700
Message-ID: <200806231934.m5NJYbgF012510@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59076 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754226AbYFWTen (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jun 2008 15:34:43 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m5NJYfHJ031558
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Mon, 23 Jun 2008 12:34:42 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/pci/opti621.c |   51 ------------------------------------
 drivers/net/smc911x.c     |    4 --
 include/asm-m68k/bitops.h |    5 ---
 3 files changed, 60 deletions(-)

diff -puN drivers/ide/pci/opti621.c~linux-next-git-rejects drivers/ide/pci/opti621.c
--- a/drivers/ide/pci/opti621.c~linux-next-git-rejects
+++ a/drivers/ide/pci/opti621.c
@@ -132,47 +132,6 @@ static u8 read_reg(int reg)
 	return ret;
 }
 
-<<<<<<< HEAD:drivers/ide/pci/opti621.c
-=======
-typedef struct pio_clocks_s {
-	int	address_time;	/* Address setup (clocks) */
-	int	data_time;	/* Active/data pulse (clocks) */
-	int	recovery_time;	/* Recovery time (clocks) */
-} pio_clocks_t;
-
-static void compute_clocks(int pio, pio_clocks_t *clks)
-{
-	if (pio != PIO_NOT_EXIST) {
-		struct ide_timing *t = ide_timing_find_mode(XFER_PIO_0 + pio);
-		int adr_setup = t->setup, data_pls = t->active;
-		int bus_speed = ide_pci_clk ? ide_pci_clk : 33;
-
-		clks->address_time = cmpt_clk(adr_setup, bus_speed);
-		clks->data_time = cmpt_clk(data_pls, bus_speed);
-		clks->recovery_time = cmpt_clk(t->cycle	- adr_setup - data_pls,
-					       bus_speed);
-
-		if (clks->address_time < 1)
-			clks->address_time = 1;
-		if (clks->address_time > 4)
-			clks->address_time = 4;
-		if (clks->data_time < 1)
-			clks->data_time = 1;
-		if (clks->data_time > 16)
-			clks->data_time = 16;
-		if (clks->recovery_time < 2)
-			clks->recovery_time = 2;
-		if (clks->recovery_time > 17)
-			clks->recovery_time = 17;
-	} else {
-		clks->address_time = 1;
-		clks->data_time = 1;
-		clks->recovery_time = 2;
-		/* minimal values */
-	}
-}
-
->>>>>>> FETCH_HEAD:drivers/ide/pci/opti621.c
 static void opti621_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 	ide_hwif_t *hwif = drive->hwif;
@@ -236,17 +195,7 @@ static void opti621_set_pio_mode(ide_dri
 	spin_unlock_irqrestore(&opti621_lock, flags);
 }
 
-<<<<<<< HEAD:drivers/ide/pci/opti621.c
-static const struct ide_port_ops opti621_port_ops = {
-=======
-static void __devinit opti621_init_dev(ide_drive_t *drive)
-{
-	drive->drive_data = PIO_DONT_KNOW;
-}
-
 static const struct ide_port_ops opti621_port_ops = {
-	.init_dev		= opti621_init_dev,
->>>>>>> FETCH_HEAD:drivers/ide/pci/opti621.c
 	.set_pio_mode		= opti621_set_pio_mode,
 };
 
diff -puN drivers/net/smc911x.c~linux-next-git-rejects drivers/net/smc911x.c
--- a/drivers/net/smc911x.c~linux-next-git-rejects
+++ a/drivers/net/smc911x.c
@@ -106,8 +106,6 @@ MODULE_ALIAS("platform:smc911x");
  */
 #define POWER_DOWN		 1
 
-<<<<<<< HEAD:drivers/net/smc911x.c
-
 /* store this information for the driver.. */
 struct smc911x_local {
 	/*
@@ -156,8 +154,6 @@ struct smc911x_local {
 #endif
 };
 
-=======
->>>>>>> FETCH_HEAD:drivers/net/smc911x.c
 #if SMC_DEBUG > 0
 #define DBG(n, args...)				 \
 	do {					 \
diff -puN include/asm-m68k/bitops.h~linux-next-git-rejects include/asm-m68k/bitops.h
--- a/include/asm-m68k/bitops.h~linux-next-git-rejects
+++ a/include/asm-m68k/bitops.h
@@ -420,12 +420,7 @@ static inline int ext2_find_first_bit(co
 		return 0;
 
 	size = (size >> 5) + ((size & 31) > 0);
-<<<<<<< HEAD:include/asm-m68k/bitops.h
 	while (*p++ == 0UL) {
-=======
-	while (*p++ == 0UL)
-	{
->>>>>>> FETCH_HEAD:include/asm-m68k/bitops.h
 		if (--size == 0)
 			return (p - addr) << 5;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
linux-next-git-rejects.patch
fix-kobject-fix-kobject_rename-and-config_sysfs.patch
kvm-is-busted-on-ia64.patch
drivers-mtd-nand-nandsimc-needs-div64h.patch
git-acpi.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
lguest-use-cpu-capability-accessors.patch
intel-agp-rewrite-gtt-on-resume.patch
arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex.patch
git-pcmcia.patch
pcmcia-add-support-the-cf-pcmcia-driver-for-blackfin-try-2.patch
arch-powerpc-platforms-pseries-eeh_driverc-fix-warning.patch
git-dvb.patch
i2c-renesas-highlander-fpga-smbus-support.patch
git-hid.patch
git-input.patch
git-jg-misc-git-rejects.patch
drivers-scsi-broadsasc-fix-uninitialised-var-warning.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
git-kvm.patch
git-leds.patch
git-mmc.patch
mmc-sd-host-driver-for-ricoh-bay1controllers.patch
drivers-mtd-devices-block2mtdc-suppress-warning.patch
git-ubifs.patch
git-net-next.patch
sundance-set-carrier-status-on-link-change-events.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix-fix.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
git-ocfs2.patch
git-pci-next.patch
git-scsi-misc-fix-scsi_dh-build-errors.patch
drivers-scsi-qla2xxx-qla_osc-suppress-uninitialized-var-warning.patch
s390-uninline-spinlock-functions-which-use-smp_processor_id.patch
pktcdvd-push-bkl-down-into-driver-fix.patch
git-unionfs.patch
git-unionfs-fixup.patch
git-logfs-fixup.patch
drivers-usb-host-isp1760-hcdc-procesxor-flags-have-type-unsigned-long.patch
usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues.patch
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
cputopology-always-define-cpu-topology-information-cleanup.patch
oprofile-multiplexing-checkpatch-fixes.patch
gpio-gpio-driver-for-max7301-spi-gpio-expander-checkpatch-fixes.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
atmel_lcdfb-avoid-division-by-zero-checkpatch-fixes.patch
pnp-add-pnp_possible_config-can-a-device-could-be-configured-this-way-fix.patch
pnp-convert-resource-options-to-single-linked-list-checkpatch-fixes.patch
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

