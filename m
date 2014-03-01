From: akpm@linux-foundation.org
Subject: + zram-delete-zram_init_device-fix.patch added to -mm tree
Date: Fri, 28 Feb 2014 16:23:33 -0800
Message-ID: <53112885.szGicJUYpNnSR5cq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52854 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbaCAAXe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Feb 2014 19:23:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com, sasha.levin@oracle.com, minchan@kernel.org

Subject: + zram-delete-zram_init_device-fix.patch added to -mm tree
To: minchan@kernel.org,sasha.levin@oracle.com,sergey.senozhatsky@gmail.com
From: akpm@linux-foundation.org
Date: Fri, 28 Feb 2014 16:23:33 -0800


The patch titled
     Subject: zram: prevent lockdep spew of init_lock
has been added to the -mm tree.  Its filename is
     zram-delete-zram_init_device-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-delete-zram_init_device-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-delete-zram_init_device-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram: prevent lockdep spew of init_lock

Sasha reported following below lockdep spew of zram.

It was introduced by [1] in recent linux-next but it's false positive
because zram_meta_alloc with down_write(init_lock) couldn't be called
during zram is working as swap device so we could annotate the lock.

But I don't think it's worthy because it would make greate lockdep
less effective. Instead, move zram_meta_alloc out of the lock as good
old day so we could do unnecessary allocation/free of zram_meta for
initialied device as Sergey claimed in [1] but it wouldn't be common
and be harmful if someone might do it. Rather than, I'd like to respect
lockdep which is great tool to prevent upcoming subtle bugs.

[1] zram: delete zram_init_device

[ 2655.365684] =================================
[ 2655.368278] [ INFO: inconsistent lock state ]
[ 2655.370163] 3.14.0-rc4-next-20140226-sasha-00013-g082bdac-dirty #4 Tainted: G        W
[ 2655.371972] ---------------------------------
[ 2655.371972] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-R} usage.
[ 2655.371972] kswapd30/5352 [HC0[0]:SC0[0]:HE1:SE1] takes:
[ 2655.371972]  (&zram->init_lock){+++++-}, at: [<drivers/block/zram/zram_drv.c:663>]
zram_make_request+0x2a/0xc0
[ 2655.371972] {RECLAIM_FS-ON-W} state was registered at:
[ 2655.371972]   [<kernel/locking/lockdep.c:2523>] mark_held_locks+0x6c/0x90
[ 2655.371972]   [<kernel/locking/lockdep.c:2745 kernel/locking/lockdep.c:2760>]
lockdep_trace_alloc+0xfd/0x140
[ 2655.371972]   [<mm/slub.c:965 mm/slub.c:2402 mm/slub.c:2475 mm/slub.c:2492>]
kmem_cache_alloc_trace+0x32/0x2e0
[ 2655.371972]   [<include/linux/slab.h:453 drivers/block/zram/zram_drv.c:172>]
zram_meta_alloc+0x20/0x150
[ 2655.371972]   [<drivers/block/zram/zram_drv.c:554>] disksize_store+0x8e/0xf0
[ 2655.371972]   [<drivers/base/core.c:139>] dev_attr_store+0x1b/0x20
[ 2655.371972]   [<fs/sysfs/file.c:114>] sysfs_kf_write+0x4a/0x60
[ 2655.371972]   [<fs/kernfs/file.c:299>] kernfs_fop_write+0x110/0x190
[ 2655.371972]   [<fs/read_write.c:473>] vfs_write+0xe3/0x1d0
[ 2655.371972]   [<fs/read_write.c:523 fs/read_write.c:515>] SyS_write+0x5d/0xa0
[ 2655.371972]   [<arch/x86/kernel/entry_64.S:749>] tracesys+0xdd/0xe2
[ 2655.371972] irq event stamp: 10207
[ 2655.371972] hardirqs last  enabled at (10207): [<arch/x86/include/asm/paravirt.h:809
block/blk-throttle.c:982>] throtl_update_dispatch_stats+0x15d/0x1a0
[ 2655.371972] hardirqs last disabled at (10206): [<block/blk-throttle.c:977>]
throtl_update_dispatch_stats+0xa4/0x1a0
[ 2655.371972] softirqs last  enabled at (10172): [<arch/x86/include/asm/preempt.h:22
kernel/softirq.c:297>] __do_softirq+0x447/0x4f0
[ 2655.371972] softirqs last disabled at (10165): [<kernel/softirq.c:347 kernel/softirq.c:388>]
irq_exit+0x83/0x160
[ 2655.371972]
[ 2655.371972] other info that might help us debug this:
[ 2655.371972]  Possible unsafe locking scenario:
[ 2655.371972]
[ 2655.371972]        CPU0
[ 2655.371972]        ----
[ 2655.371972]   lock(&zram->init_lock);
[ 2655.371972]   <Interrupt>
[ 2655.371972]     lock(&zram->init_lock);
[ 2655.371972]
[ 2655.371972]  *** DEADLOCK ***
[ 2655.371972]
[ 2655.371972] no locks held by kswapd30/5352.
[ 2655.371972]
[ 2655.371972] stack backtrace:
[ 2655.371972] CPU: 78 PID: 5352 Comm: kswapd30 Tainted: G        W
3.14.0-rc4-next-20140226-sasha-00013-g082bdac-dirty #4
[ 2655.371972]  ffff880636f98cc0 ffff880636f8d3f8 ffffffff843882e5 0000000000000000
[ 2655.371972]  ffff880636f98000 ffff880636f8d458 ffffffff811a09f7 0000000000000000
[ 2655.371972]  0000000000000001 ffff880600000001 ffffffff876c2060 0000000000000009
[ 2655.371972] Call Trace:
[ 2655.371972]  [<lib/dump_stack.c:52>] dump_stack+0x52/0x7f
[ 2655.371972]  [<kernel/locking/lockdep.c:2254>] print_usage_bug+0x1a7/0x1e0
[ 2655.371972]  [<kernel/locking/lockdep.c:2347>] ? print_usage_bug+0x1e0/0x1e0
[ 2655.371972]  [<kernel/locking/lockdep.c:2465>] mark_lock_irq+0xd9/0x2a0
[ 2655.371972]  [<kernel/locking/lockdep.c:2920>] mark_lock+0x128/0x210
[ 2655.371972]  [<kernel/locking/lockdep.c:2821>] mark_irqflags+0x144/0x170
[ 2655.371972]  [<kernel/locking/lockdep.c:3138>] __lock_acquire+0x2de/0x5a0
[ 2655.371972]  [<arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602>]
lock_acquire+0x182/0x1d0
[ 2655.371972]  [<drivers/block/zram/zram_drv.c:663>] ? zram_make_request+0x2a/0xc0
[ 2655.371972]  [<arch/x86/include/asm/rwsem.h:83 kernel/locking/rwsem.c:23>] down_read+0x47/0xa0
[ 2655.371972]  [<drivers/block/zram/zram_drv.c:663>] ? zram_make_request+0x2a/0xc0
[ 2655.371972]  [<arch/x86/include/asm/current.h:14 kernel/sched/core.c:2508>] ?
preempt_count_add+0x96/0xc0
[ 2655.371972]  [<drivers/block/zram/zram_drv.c:663>] zram_make_request+0x2a/0xc0
[ 2655.371972]  [<block/blk-core.c:1862>] generic_make_request+0xb6/0x110
[ 2655.371972]  [<block/blk-core.c:1913>] submit_bio+0x148/0x170
[ 2655.371972]  [<include/linux/rcupdate.h:800 include/linux/memcontrol.h:180
mm/page-writeback.c:2408>] ? test_set_page_writeback+0x24e/0x2a0
[ 2655.371972]  [<mm/page_io.c:315>] __swap_writepage+0x1fc/0x220
[ 2655.371972]  [<arch/x86/include/asm/preempt.h:98 include/linux/spinlock_api_smp.h:152
kernel/locking/spinlock.c:183>] ? _raw_spin_unlock+0x30/0x50
[ 2655.371972]  [<mm/swapfile.c:898>] ? page_swapcount+0x4e/0x60
[ 2655.371972]  [<mm/page_io.c:249>] swap_writepage+0x72/0x80
[ 2655.371972]  [<mm/vmscan.c:502>] pageout+0x167/0x2e0
[ 2655.371972]  [<mm/vmscan.c:1015>] shrink_page_list+0x4f4/0x7c0
[ 2655.371972]  [<include/linux/spinlock.h:328 mm/vmscan.c:1503>] shrink_inactive_list+0x31c/0x570
[ 2655.371972]  [<mm/vmscan.c:1744>] ? shrink_active_list+0x30b/0x320
[ 2655.371972]  [<mm/vmscan.c:1830 mm/vmscan.c:2054>] shrink_lruvec+0x124/0x300
[ 2655.371972]  [<arch/x86/include/asm/paravirt.h:192 arch/x86/kernel/tsc.c:305>] ?
sched_clock+0x1d/0x30
[ 2655.371972]  [<mm/vmscan.c:2235>] shrink_zone+0x8e/0x1d0
[ 2655.371972]  [<include/linux/bitmap.h:165 include/linux/nodemask.h:131 mm/vmscan.c:2904>]
kswapd_shrink_zone+0xf1/0x1b0
[ 2655.371972]  [<mm/vmscan.c:3088>] balance_pgdat+0x363/0x540
[ 2655.371972]  [<kernel/sched/wait.c:254>] ? finish_wait+0x70/0x90
[ 2655.371972]  [<mm/vmscan.c:3296>] kswapd+0x2eb/0x350
[ 2655.371972]  [<mm/vmscan.c:3213>] ? ftrace_raw_event_mm_vmscan_writepage+0x180/0x180
[ 2655.371972]  [<kernel/kthread.c:216>] kthread+0x105/0x110
[ 2655.371972]  [<kernel/locking/lockdep.c:3506>] ? __lock_release+0x1e2/0x200
[ 2655.371972]  [<kernel/kthread.c:185>] ? set_kthreadd_affinity+0x30/0x30
[ 2655.371972]  [<arch/x86/kernel/entry_64.S:555>] ret_from_fork+0x7c/0xb0
[ 2655.371972]  [<kernel/kthread.c:185>] ? set_kthreadd_affinity+0x30/0x30

Signed-off-by: Minchan Kim <minchan@kernel.org>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-delete-zram_init_device-fix drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-delete-zram_init_device-fix
+++ a/drivers/block/zram/zram_drv.c
@@ -537,26 +537,27 @@ static ssize_t disksize_store(struct dev
 		struct device_attribute *attr, const char *buf, size_t len)
 {
 	u64 disksize;
+	struct zram_meta *meta;
 	struct zram *zram = dev_to_zram(dev);
 
 	disksize = memparse(buf, NULL);
 	if (!disksize)
 		return -EINVAL;
 
+	disksize = PAGE_ALIGN(disksize);
+	meta = zram_meta_alloc(disksize);
+	if (!meta)
+		return -ENOMEM;
+
 	down_write(&zram->init_lock);
 	if (init_done(zram)) {
+		zram_meta_free(meta);
 		up_write(&zram->init_lock);
 		pr_info("Cannot change disksize for initialized device\n");
 		return -EBUSY;
 	}
 
-	disksize = PAGE_ALIGN(disksize);
-	zram->meta = zram_meta_alloc(disksize);
-	if (!zram->meta) {
-		up_write(&zram->init_lock);
-		return -ENOMEM;
-	}
-
+	zram->meta = meta;
 	zram->disksize = disksize;
 	set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT);
 	up_write(&zram->init_lock);
_

Patches currently in -mm which might be from minchan@kernel.org are

zram-avoid-null-access-when-fail-to-alloc-meta.patch
fs-cachefiles-use-add_to_page_cache_lru.patch
lib-radix-tree-radix_tree_delete_item.patch
mm-shmem-save-one-radix-tree-lookup-when-truncating-swapped-pages.patch
mm-filemap-move-radix-tree-hole-searching-here.patch
mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees.patch
mm-fs-store-shadow-entries-in-page-cache.patch
mm-thrash-detection-based-file-cache-sizing.patch
mm-keep-page-cache-radix-tree-nodes-in-check.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
zram-drop-init_done-struct-zram-member.patch
zram-do-not-pass-rw-argument-to-__zram_make_request.patch
zram-remove-good-and-bad-compress-stats.patch
zram-use-atomic64_t-for-all-zram-stats.patch
zram-remove-zram-stats-code-duplication.patch
zram-report-failed-read-and-write-stats.patch
zram-drop-not-used-table-count-member.patch
zram-move-zram-size-warning-to-documentation.patch
zram-document-failed_reads-failed_writes-stats.patch
zram-delete-zram_init_device.patch
zram-delete-zram_init_device-fix.patch
zram-introduce-compressing-backend-abstraction.patch
zram-use-zcomp-compressing-backends.patch
zram-factor-out-single-stream-compression.patch
zram-add-multi-stream-functionality.patch
zram-add-set_max_streams-knob.patch
zram-make-compression-algorithm-selection-possible.patch
zram-add-lz4-algorithm-backend.patch
mm-zswap-fix-trivial-typo-and-arrange-indentation.patch
mm-zswap-update-zsmalloc-in-comment-to-zbud.patch
mm-zswap-support-multiple-swap-devices.patch
debugging-keep-track-of-page-owners.patch

