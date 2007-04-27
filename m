From: akpm@linux-foundation.org
Subject: - congestion-wait-dont-wait-when-there-are-no-pages-under-writeback-debug.patch removed from -mm tree
Date: Fri, 27 Apr 2007 00:16:21 -0700
Message-ID: <200704270716.l3R7GLLU021996@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59626 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755436AbXD0HQX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 03:16:23 -0400
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l3R7GLkN012657
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Fri, 27 Apr 2007 00:16:22 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     congestion-wait-dont-wait-when-there-are-no-pages-under-writeback-debug
has been removed from the -mm tree.  Its filename was
     congestion-wait-dont-wait-when-there-are-no-pages-under-writeback-debug.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: congestion-wait-dont-wait-when-there-are-no-pages-under-writeback-debug
From: Andrew Morton <akpm@osdl.org>

Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/backing-dev.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/backing-dev.c~congestion-wait-dont-wait-when-there-are-no-pages-under-writeback-debug mm/backing-dev.c
--- a/mm/backing-dev.c~congestion-wait-dont-wait-when-there-are-no-pages-under-writeback-debug
+++ a/mm/backing-dev.c
@@ -50,8 +50,11 @@ long congestion_wait(int rw, long timeou
 	DEFINE_WAIT(wait);
 	wait_queue_head_t *wqh = &congestion_wqh[rw];
 
-	if (rw == WRITE && global_page_state(NR_WRITEBACK) == 0)
+	if (rw == WRITE && global_page_state(NR_WRITEBACK) == 0) {
+		printk("%s: no pages are under writeback\n", __FUNCTION__);
+		dump_stack();
 		return timeout;
+	}
 	prepare_to_wait(wqh, &wait, TASK_UNINTERRUPTIBLE);
 	ret = io_schedule_timeout(timeout);
 	finish_wait(wqh, &wait);
_

Patches currently in -mm which might be from akpm@osdl.org are

git-powerpc.patch
git-ia64.patch
git-ieee1394.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
git-ubi.patch
git-netdev-all.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
git-ioat-vs-git-md-accel.patch
ioat-warning-fix.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
git-ipwireless_cs.patch
lumpy-reclaim-v4.patch
deprecate-smbfs-in-favour-of-cifs.patch
block_write_full_page-handle-enospc.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
epoll-optimizations-and-cleanups-tidy.patch
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
ext2-reservations.patch
aio-is-unlikely.patch
mm-implement-swap-prefetching.patch
readahead-kconfig-options.patch
readahead-minmax_ra_pages.patch
readahead-sysctl-parameters.patch
readahead-context-based-method.patch
readahead-call-scheme.patch
readahead-nfsd-case.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
slab-leaks3-default-y.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
acpi_format_exception-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
squash-ipc-warnings.patch
