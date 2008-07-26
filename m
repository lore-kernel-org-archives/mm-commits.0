From: akpm@linux-foundation.org
Subject: - git-block-ia64-build-fix.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:18:30 -0700
Message-ID: <200807262118.m6QLIU2s020098@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48435 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757719AbYGZVT2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:19:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     git-block: ia64 build fix
has been removed from the -mm tree.  Its filename was
     git-block-ia64-build-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: git-block: ia64 build fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/smp.c |   25 -------------------------
 1 file changed, 25 deletions(-)

diff -puN arch/ia64/kernel/smp.c~git-block-ia64-build-fix arch/ia64/kernel/smp.c
--- a/arch/ia64/kernel/smp.c~git-block-ia64-build-fix
+++ a/arch/ia64/kernel/smp.c
@@ -82,31 +82,6 @@ unlock_ipi_calllock(void)
 	spin_unlock_irq(&call_function_lock);
 }
 
-static inline void
-handle_call_data(void)
-{
-	struct call_data_struct *data;
-	void (*func)(void *info);
-	void *info;
-	int wait;
-
-	/* release the 'pointer lock' */
-	data = (struct call_data_struct *)call_data;
-	func = data->func;
-	info = data->info;
-	wait = data->wait;
-
-	mb();
-	atomic_inc(&data->started);
-	/* At this point the structure may be gone unless wait is true. */
-	(*func)(info);
-
-	/* Notify the sending CPU that the task is done. */
-	mb();
-	if (wait)
-		atomic_inc(&data->finished);
-}
-
 static void
 stop_this_cpu(void)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
hugetlb-remove-unused-variable-warning-checkpatch-fixes.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
linux-next.patch
linux-next-fixups.patch
linux-next-rejects.patch
next-remove-localversion.patch
drivers-mtd-nand-nandsimc-needs-div64h.patch
pci-make-pci_register_driver-a-macro.patch
x86-pci-replace-dbg-with-pr_debug-fix.patch
x86-pci-replace-dbg-with-pr_debug-fix-2.patch
include-asm-generic-pgtable-nopmdh-macros-are-noxious-reason-435.patch
arch-x86-pci-i386c-fix-printk-warnings.patch
drm-fix-sparc64-build.patch
i2c-renesas-highlander-fpga-smbus-support.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
git-jg-misc.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
git-ubi-git-rejects.patch
bridge-send-correct-mtu-value-in-pmtu-checkpatch-fixes.patch
sundance-set-carrier-status-on-link-change-events.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-scsi-qla2xxx-qla_osc-suppress-uninitialized-var-warning.patch
scsi-gdthc-use-unaligned-access-helpers-checkpatch-fixes.patch
git-block-git-rejects.patch
git-unionfs.patch
git-logfs-git-rejects.patch
git-logfs-fixup.patch
drivers-usb-class-cdc-acmc-use-correct-type-for-cpu-flags.patch
drivers-usb-class-cdc-wdmc-fix-build-with-config_pm=n.patch
drivers-net-wireless-iwlwifi-iwl-ledc-printk-fix.patch
git-xtensa.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
ftrace-disable-function-tracing-bringing-up-new-cpu-fix.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifier-core.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
eink_apollofb-new-driver-for-apollo-eink-controller.patch
getdelaysc-add-a-usr1-signal-handler-checkpatch-fixes.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
gru-driver-v3-hardware-data-structures-fix.patch
gru-driver-v3-hardware-data-structures-fix-fix.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
vmscan-move-isolate_lru_page-to-vmscanc-fix.patch
define-page_file_cache-function-fix.patch
vmscan-split-lru-lists-into-anon-file-sets-units-fix.patch
unevictable-lru-infrastructure-fix.patch
unevictable-lru-page-statistics-units-fix.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
introduce-__get_user_pages-fix.patch
vmscan-unevictable-lru-scan-sysctl-nommu-fix.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix-logfs.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
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

