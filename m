From: akpm@linux-foundation.org
Subject: - shm-make-sysv-ipc-shared-memory-use-stacked-files-fix.patch removed from -mm tree
Date: Thu, 15 Feb 2007 16:32:34 -0800
Message-ID: <200702160032.l1G0WZDL013786@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40170 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422874AbXBPAci (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 19:32:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ebiederm@xmission.com, michal.k.k.piotrowski@gmail.com, mm-commits@vger.kernel.org


The patch titled
     shm-make-sysv-ipc-shared-memory-use-stacked-files-fix
has been removed from the -mm tree.  Its filename was
     shm-make-sysv-ipc-shared-memory-use-stacked-files-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: shm-make-sysv-ipc-shared-memory-use-stacked-files-fix
From: Andrew Morton <akpm@osdl.org>

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff -puN ipc/shm.c~shm-make-sysv-ipc-shared-memory-use-stacked-files-fix ipc/shm.c
--- a/ipc/shm.c~shm-make-sysv-ipc-shared-memory-use-stacked-files-fix
+++ a/ipc/shm.c
@@ -818,7 +818,7 @@ long do_shmat(int shmid, char __user *sh
 	int acc_mode;
 	void *user_addr;
 	struct ipc_namespace *ns;
-	struct shm_file_data *sfd;
+	struct shm_file_data *sfd = NULL;
 	mode_t f_mode;
 
 	if (shmid < 0) {
@@ -856,6 +856,8 @@ long do_shmat(int shmid, char __user *sh
 		acc_mode |= S_IXUGO;
 	}
 
+	sfd = kzalloc(sizeof(*sfd), GFP_KERNEL);
+
 	/*
 	 * We cannot rely on the fs check since SYSV IPC does have an
 	 * additional creator id...
@@ -879,13 +881,12 @@ long do_shmat(int shmid, char __user *sh
 		goto out_unlock;
 
 	err = -ENOMEM;
-	sfd = kzalloc(sizeof(*sfd), GFP_KERNEL);
 	if (!sfd)
 		goto out_unlock;
 
 	file = get_empty_filp();
 	if (!file)
-		goto out_free;
+		goto out_unlock;
 
 	file->f_op = &shm_file_operations;
 	file->private_data = sfd;
@@ -939,9 +940,8 @@ invalid:
 	if (IS_ERR(user_addr))
 		err = PTR_ERR(user_addr);
 out:
-	return err;
-out_free:
 	kfree(sfd);
+	return err;
 out_unlock:
 	shm_unlock(shp);
 	goto out;
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-acpi.patch
git-agpgart.patch
git-dvb.patch
git-ia64.patch
git-ieee1394.patch
git-libata-all.patch
git-lxdialog-fixup.patch
git-mtd.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
git-backlight.patch
net-uninline-skb_put.patch
git-ioat-vs-git-md-accel.patch
ioat-warning-fix.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
git-block-xfs-barriers-broke.patch
nokia-e70-is-an-unusual-device.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-dont-include-bugsh.patch
lumpy-reclaim-v2-page_to_pfn-fix.patch
lumpy-reclaim-v2-tidy.patch
deprecate-smbfs-in-favour-of-cifs.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
block_write_full_page-handle-enospc.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
shm-make-sysv-ipc-shared-memory-use-stacked-files-fix.patch
factor-outstanding-i-o-error-handling-tidy.patch
sync_sb_inodes-propagate-errors.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
vmi-versus-hrtimers.patch
add-a-functions-to-handle-interrupt-affinity-setting-alpha-fix.patch
i386-use-gtod-persistent-clock-support.patch
hrtimers-namespace-and-enum-cleanup-vs-git-input.patch
hrtimers-cleanup-locking.patch
hrtimers-add-state-tracking.patch
clockevents-i383-drivers.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
revert-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-fix.patch
reapply-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-convert-x86_64-to-use-generic_time-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
schedule_on_each_cpu-use-preempt_disable.patch
implement-flush_work-sanity.patch
implement-flush_work_keventd.patch
flush_workqueue-use-preempt_disable-to-hold-off-cpu-hotplug.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-2.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release-fix.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc-fix.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine-gfs2-fix.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix.patch
aio-is-unlikely.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
swap_prefetch-vs-zoned-counters.patch
add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
rcu-preemptible-rcu.patch
local_t-powerpc-extension-fix.patch
readahead-kconfig-options-fix.patch
readahead-minmax_ra_pages.patch
readahead-sysctl-parameters.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
readahead-context-based-method-locking-fix.patch
readahead-context-based-method-locking-fix-2.patch
readahead-call-scheme-ifdef-fix.patch
readahead-call-scheme-build-fix.patch
readahead-nfsd-case-fix.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
resier4-add-include-linux-freezerh-and-move-definitions-from.patch
make-kmem_cache_destroy-return-void-reiser4.patch
reiser4-hardirq-include-fix.patch
reiser4-run-truncate_inode_pages-in-reiser4_delete_inode.patch
reiser4-get_sb_dev-fix.patch
reiser4-vs-zoned-allocator.patch
reiser4-temp-fix.patch
reiser4-kmem_cache_t-removal.patch
reiser4-test_clear_page_dirty.patch
reiser4-vs-git-block.patch
reiser4-vs-git-block-2.patch
statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy.patch
slim-main-include-fix.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
e1000-printk-warning-fixes.patch
acpi_format_exception-debug.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
ia64-enable-config_debug_spinlock_sleep.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch
