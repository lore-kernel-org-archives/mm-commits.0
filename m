From: akpm@linux-foundation.org
Subject: - relayfs-use-flush_keventd_work.patch removed from -mm tree
Date: Tue, 08 May 2007 14:01:52 -0700
Message-ID: <200705082101.l48L1qwM001570@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43955 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032143AbXEHVCR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 17:02:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, axboe@suse.de, dhowells@redhat.com, macro@linux-mips.org, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     relayfs: use flush_work_keventd()
has been removed from the -mm tree.  Its filename was
     relayfs-use-flush_keventd_work.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: relayfs: use flush_work_keventd()
From: Andrew Morton <akpm@osdl.org>

Cc: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Jens Axboe <axboe@suse.de>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/relay.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/relay.c~relayfs-use-flush_keventd_work kernel/relay.c
--- a/kernel/relay.c~relayfs-use-flush_keventd_work
+++ a/kernel/relay.c
@@ -340,7 +340,7 @@ static void __relay_reset(struct rchan_b
 		INIT_DELAYED_WORK(&buf->wake_readers, NULL);
 	} else {
 		cancel_delayed_work(&buf->wake_readers);
-		flush_scheduled_work();
+		flush_work_keventd(&buf->wake_readers.work);
 	}
 
 	buf->subbufs_produced = 0;
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
block_write_full_page-handle-enospc.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
epoll-optimizations-and-cleanups.patch
git-ieee1394.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
git-ioat-vs-git-md-accel.patch
ioat-warning-fix.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
git-ipwireless_cs.patch
lumpy-reclaim-v4.patch
deprecate-smbfs-in-favour-of-cifs.patch
sync_sb_inodes-propagate-errors.patch
schedule_on_each_cpu-use-preempt_disable.patch
implement-flush_work.patch
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
