From: akpm@linux-foundation.org
Subject: - implement-flush_work_keventd.patch removed from -mm tree
Date: Mon, 30 Apr 2007 13:16:57 -0700
Message-ID: <200704302016.l3UKGwf7013979@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34918 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946754AbXD3URd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 16:17:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     implement flush_work_keventd()
has been removed from the -mm tree.  Its filename was
     implement-flush_work_keventd.patch

This patch was dropped because it was folded into implement-flush_work.patch

------------------------------------------------------
Subject: implement flush_work_keventd()
From: Andrew Morton <akpm@osdl.org>

flush_work() requires that the caller pass in the workqueue to be flushed. 
But for keventd-based works, callers require access to keventd_wq, which is
provate to workqueue.c.

Add the new flush_work_keventd() wrapper to handle this.

The naming in there is insane.  We should come up with some consistent scheme
to distinguish the things which operate on keventd_wq from the things which
operate upon caller-owned workqueues.  I'd propose "name of the function with
_keventd" appended, as in this patch.

Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/workqueue.h |    1 +
 kernel/workqueue.c        |    6 ++++++
 2 files changed, 7 insertions(+)

diff -puN include/linux/workqueue.h~implement-flush_work_keventd include/linux/workqueue.h
--- a/include/linux/workqueue.h~implement-flush_work_keventd
+++ a/include/linux/workqueue.h
@@ -179,6 +179,7 @@ extern int queue_delayed_work_on(int cpu
 	struct delayed_work *work, unsigned long delay);
 extern void FASTCALL(flush_workqueue(struct workqueue_struct *wq));
 extern void flush_work(struct workqueue_struct *wq, struct work_struct *work);
+extern void flush_work_keventd(struct work_struct *work);
 
 extern int FASTCALL(schedule_work(struct work_struct *work));
 extern int FASTCALL(run_scheduled_work(struct work_struct *work));
diff -puN kernel/workqueue.c~implement-flush_work_keventd kernel/workqueue.c
--- a/kernel/workqueue.c~implement-flush_work_keventd
+++ a/kernel/workqueue.c
@@ -733,6 +733,12 @@ void flush_scheduled_work(void)
 }
 EXPORT_SYMBOL(flush_scheduled_work);
 
+void flush_work_keventd(struct work_struct *work)
+{
+	flush_work(keventd_wq, work);
+}
+EXPORT_SYMBOL(flush_work_keventd);
+
 /**
  * cancel_rearming_delayed_workqueue - reliably kill off a delayed work whose handler rearms the delayed work.
  * @wq:   the controlling workqueue structure
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
git-powerpc.patch
git-ia64.patch
git-ieee1394.patch
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
epoll-optimizations-and-cleanups.patch
sync_sb_inodes-propagate-errors.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
schedule_on_each_cpu-use-preempt_disable.patch
implement-flush_work.patch
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
