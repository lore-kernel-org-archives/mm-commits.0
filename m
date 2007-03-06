From: akpm@linux-foundation.org
Subject: - statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:08:22 -0800
Message-ID: <200703060208.l2628M4F008925@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47070 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933845AbXCFCLl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:11:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mp3@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy
has been removed from the -mm tree.  Its filename was
     statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy.patch

This patch was dropped because it was folded into statistics-infrastructure.patch

------------------------------------------------------
Subject: statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy
From: Andrew Morton <akpm@osdl.org>

That's what min_t is for.

Cc: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 lib/statistic.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/statistic.c~statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy lib/statistic.c
--- a/lib/statistic.c~statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy
+++ a/lib/statistic.c
@@ -1033,7 +1033,7 @@ static int statistic_histogram_calc_inde
 		return 0;
 	i = value - stat->u.histogram.range_min;
 	do_div(i, stat->u.histogram.base_interval);
-	return min(i, (unsigned long long)(stat->u.histogram.last_index));
+	return min_t(unsigned long long, i, stat->u.histogram.last_index);
 }
 
 static int statistic_histogram_calc_index_log2(struct statistic *stat,
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
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
aio-is-unlikely.patch
mm-implement-swap-prefetching.patch
rcu-preemptible-rcu.patch
readahead-kconfig-options.patch
readahead-minmax_ra_pages.patch
readahead-sysctl-parameters.patch
readahead-context-based-method.patch
readahead-call-scheme.patch
readahead-nfsd-case.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
statistics-infrastructure.patch
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
