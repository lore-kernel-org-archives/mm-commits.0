From: akpm@linux-foundation.org
Subject: - freezer_cg-use-thaw_process-in-unfreeze_cgroup-fix.patch removed from -mm tree
Date: Wed, 29 Oct 2008 12:57:24 -0700
Message-ID: <200810291957.m9TJvPvJ020258@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53749 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752449AbYJ2T7N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Oct 2008 15:59:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, clg@fr.ibm.com, lizf@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     freezer_cg-use-thaw_process-in-unfreeze_cgroup-fix
has been removed from the -mm tree.  Its filename was
     freezer_cg-use-thaw_process-in-unfreeze_cgroup-fix.patch

This patch was dropped because it was folded into freezer_cg-use-thaw_process-in-unfreeze_cgroup.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: freezer_cg-use-thaw_process-in-unfreeze_cgroup-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/freezer.h |    5 -----
 kernel/freezer.c        |   20 ++++++++++----------
 2 files changed, 10 insertions(+), 15 deletions(-)

diff -puN include/linux/freezer.h~freezer_cg-use-thaw_process-in-unfreeze_cgroup-fix include/linux/freezer.h
--- a/include/linux/freezer.h~freezer_cg-use-thaw_process-in-unfreeze_cgroup-fix
+++ a/include/linux/freezer.h
@@ -44,11 +44,6 @@ static inline bool should_send_signal(st
 	return !(p->flags & PF_FREEZER_NOSIG);
 }
 
-/*
- * Wake up a frozen process
- */
-extern int __thaw_process(struct task_struct *p);
-
 /* Takes and releases task alloc lock using task_lock() */
 extern int thaw_process(struct task_struct *p);
 
diff -puN kernel/freezer.c~freezer_cg-use-thaw_process-in-unfreeze_cgroup-fix kernel/freezer.c
--- a/kernel/freezer.c~freezer_cg-use-thaw_process-in-unfreeze_cgroup-fix
+++ a/kernel/freezer.c
@@ -121,16 +121,7 @@ void cancel_freezing(struct task_struct 
 	}
 }
 
-/*
- * Wake up a frozen process
- *
- * task_lock() is needed to prevent the race with refrigerator() which may
- * occur if the freezing of tasks fails.  Namely, without the lock, if the
- * freezing of tasks failed, thaw_tasks() might have run before a task in
- * refrigerator() could call frozen_process(), in which case the task would be
- * frozen and no one would thaw it.
- */
-int __thaw_process(struct task_struct *p)
+static int __thaw_process(struct task_struct *p)
 {
 	if (frozen(p)) {
 		p->flags &= ~PF_FROZEN;
@@ -140,6 +131,15 @@ int __thaw_process(struct task_struct *p
 	return 0;
 }
 
+/*
+ * Wake up a frozen process
+ *
+ * task_lock() is needed to prevent the race with refrigerator() which may
+ * occur if the freezing of tasks fails.  Namely, without the lock, if the
+ * freezing of tasks failed, thaw_tasks() might have run before a task in
+ * refrigerator() could call frozen_process(), in which case the task would be
+ * frozen and no one would thaw it.
+ */
 int thaw_process(struct task_struct *p)
 {
 	task_lock(p);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

epoll-avoid-double-inserts-in-case-of-efault-checkpatch-fixes.patch
freezer_cg-use-thaw_process-in-unfreeze_cgroup.patch
freezer_cg-use-thaw_process-in-unfreeze_cgroup-fix.patch
fs-remove-prepare_write-commit_write-fix.patch
mm-write_cache_pages-writepage-error-fix.patch
nfsd-fix-vm-overcommit-crash-checkpatch-fixes.patch
nfsd-fix-vm-overcommit-crash-fix.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
linux-next-rejects.patch
next-remove-localversion.patch
arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
linux-timexh-cleanup-for-userspace-checkpatch-fixes.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
drivers-rtc-rtc-ds1286c-is-borked.patch
drivers-rtc-rtc-m48t35c-is-borked-too.patch
drivers-net-sfc-falconc-fix-min-warnings.patch
pci-uninline-pci_ioremap_bar.patch
autofs4-collect-version-check-return-checkpatch-fixes.patch
maintainers-make-ioat-easier-to-find.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
fs-truncate-blocks-outside-i_size-after-generic_file_direct_write-error-fix.patch
init-properly-placing-noinline-keyword.patch
spi_gpio-driver-cleanups.patch
rtc-rtc-wm8350-add-support-for-wm8350-rtc.patch
rtc-basic-implementation-of-epson-rx-8581-i2c-real-time-clock-fix.patch
quota-move-quotaio_vh-from-include-linux-to-fs-fix.patch
quota-move-quotaio_vh-from-include-linux-to-fs-fix-2.patch
quota-convert-union-in-mem_dqinfo-to-a-pointer-cleanup.patch
quota-support-64-bit-quota-format-fix.patch
quota-support-64-bit-quota-format-fix-2.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
w1-export-w1_read_8-function-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
reiser4-broke.patch
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

