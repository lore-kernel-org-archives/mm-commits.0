From: akpm@linux-foundation.org
Subject: - eliminate-lock_cpu_hotplug-in-kernel-schedc-fix.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:11:31 -0800
Message-ID: <200703060111.l261BWtf007261@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44293 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933749AbXCFBLt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:11:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ego@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     eliminate-lock_cpu_hotplug-in-kernel-schedc-fix
has been removed from the -mm tree.  Its filename was
     eliminate-lock_cpu_hotplug-in-kernel-schedc-fix.patch

This patch was dropped because it was folded into eliminate-lock_cpu_hotplug-in-kernel-schedc.patch

------------------------------------------------------
Subject: eliminate-lock_cpu_hotplug-in-kernel-schedc-fix
From: Andrew Morton <akpm@osdl.org>

migration_call() is called during CPU bringup even if CONFIG_HOTPLUG_CPU=n. 
So we need to release that lock, else it deadlocks.

Cc: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN kernel/sched.c~eliminate-lock_cpu_hotplug-in-kernel-schedc-fix kernel/sched.c
--- a/kernel/sched.c~eliminate-lock_cpu_hotplug-in-kernel-schedc-fix
+++ a/kernel/sched.c
@@ -5255,11 +5255,10 @@ migration_call(struct notifier_block *nf
 		}
 		spin_unlock_irq(&rq->lock);
 		break;
-
+#endif
 	case CPU_LOCK_RELEASE:
 		mutex_unlock(&sched_hotcpu_mutex);
 		break;
-#endif
 	}
 	return NOTIFY_OK;
 }
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-ia64.patch
git-ieee1394.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
git-ubi.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
net-uninline-skb_put.patch
git-ioat-vs-git-md-accel.patch
ioat-warning-fix.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-dont-include-bugsh.patch
deprecate-smbfs-in-favour-of-cifs.patch
block_write_full_page-handle-enospc.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
sync_sb_inodes-propagate-errors.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
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
eliminate-lock_cpu_hotplug-in-kernel-schedc.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc-fix.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
aio-is-unlikely.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
swap_prefetch-vs-zoned-counters.patch
add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
rcu-preemptible-rcu.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc-fix-2.patch
local_t-powerpc-extension-fix.patch
local_t-powerpc-extension-fix-build-fix.patch
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
