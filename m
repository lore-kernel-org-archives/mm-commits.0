From: akpm@linux-foundation.org
Subject: [merged] inotify-use-gfp_nofs-in-kernel_event-to-work-around-a-lockdep-false-positive.patch removed from -mm tree
Date: Thu, 07 May 2009 12:15:49 -0700
Message-ID: <200905071915.n47JFnBG019907@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753920AbZEGTVa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 May 2009 15:21:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, a.p.zijlstra@chello.nl, clameter@sgi.com, eparis@redhat.com, mpm@selenic.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     inotify: use GFP_NOFS in kernel_event() to work around a lockdep false-positive
has been removed from the -mm tree.  Its filename was
     inotify-use-gfp_nofs-in-kernel_event-to-work-around-a-lockdep-false-positive.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: inotify: use GFP_NOFS in kernel_event() to work around a lockdep false-positive
From: Wu Fengguang <fengguang.wu@intel.com>

There is what we believe to be a false positive reported by lockdep.

inotify_inode_queue_event() => take inotify_mutex => kernel_event() =>
kmalloc() => SLOB => alloc_pages_node() => page reclaim => slab reclaim =>
dcache reclaim => inotify_inode_is_dead => take inotify_mutex => deadlock

The plan is to fix this via lockdep annotation, but that is proving to be
quite involved.

The patch flips the allocation over to GFP_NFS to shut the warning up, for
the 2.6.30 release.

Hopefully we will fix this for real in 2.6.31.  I'll queue a patch in -mm
to switch it back to GFP_KERNEL so we don't forget.


[ 2668.325318]
[ 2668.325322] =================================
[ 2668.327448] [ INFO: inconsistent lock state ]
[ 2668.327448] 2.6.30-rc2-next-20090417 #203
[ 2668.327448] ---------------------------------
[ 2668.327448] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
[ 2668.327448] kswapd0/380 [HC0[0]:SC0[0]:HE1:SE1] takes:
[ 2668.327448]  (&inode->inotify_mutex){+.+.?.}, at: [<ffffffff8112f1b5>] inotify_inode_is_dead+0x35/0xb0
[ 2668.327448] {RECLAIM_FS-ON-W} state was registered at:
[ 2668.327448]   [<ffffffff81079188>] mark_held_locks+0x68/0x90
[ 2668.327448]   [<ffffffff810792a5>] lockdep_trace_alloc+0xf5/0x100
[ 2668.327448]   [<ffffffff810f5261>] __kmalloc_node+0x31/0x1e0
[ 2668.327448]   [<ffffffff81130652>] kernel_event+0xe2/0x190
[ 2668.327448]   [<ffffffff81130826>] inotify_dev_queue_event+0x126/0x230
[ 2668.327448]   [<ffffffff8112f096>] inotify_inode_queue_event+0xc6/0x110
[ 2668.327448]   [<ffffffff8110444d>] vfs_create+0xcd/0x140
[ 2668.327448]   [<ffffffff8110825d>] do_filp_open+0x88d/0xa20
[ 2668.327448]   [<ffffffff810f6b68>] do_sys_open+0x98/0x140
[ 2668.327448]   [<ffffffff810f6c50>] sys_open+0x20/0x30
[ 2668.327448]   [<ffffffff8100c272>] system_call_fastpath+0x16/0x1b
[ 2668.327448]   [<ffffffffffffffff>] 0xffffffffffffffff
[ 2668.327448] irq event stamp: 690455
[ 2668.327448] hardirqs last  enabled at (690455): [<ffffffff81564fe4>] _spin_unlock_irqrestore+0x44/0x80
[ 2668.327448] hardirqs last disabled at (690454): [<ffffffff81565372>] _spin_lock_irqsave+0x32/0xa0
[ 2668.327448] softirqs last  enabled at (690178): [<ffffffff81052282>] __do_softirq+0x202/0x220
[ 2668.327448] softirqs last disabled at (690157): [<ffffffff8100d50c>] call_softirq+0x1c/0x50
[ 2668.327448]
[ 2668.327448] other info that might help us debug this:
[ 2668.327448] 2 locks held by kswapd0/380:
[ 2668.327448]  #0:  (shrinker_rwsem){++++..}, at: [<ffffffff810d0bd7>] shrink_slab+0x37/0x180
[ 2668.327448]  #1:  (&type->s_umount_key#17){++++..}, at: [<ffffffff8110cfbf>] shrink_dcache_memory+0x11f/0x1e0
[ 2668.327448]
[ 2668.327448] stack backtrace:
[ 2668.327448] Pid: 380, comm: kswapd0 Not tainted 2.6.30-rc2-next-20090417 #203
[ 2668.327448] Call Trace:
[ 2668.327448]  [<ffffffff810789ef>] print_usage_bug+0x19f/0x200
[ 2668.327448]  [<ffffffff81018bff>] ? save_stack_trace+0x2f/0x50
[ 2668.327448]  [<ffffffff81078f0b>] mark_lock+0x4bb/0x6d0
[ 2668.327448]  [<ffffffff810799e0>] ? check_usage_forwards+0x0/0xc0
[ 2668.327448]  [<ffffffff8107b142>] __lock_acquire+0xc62/0x1ae0
[ 2668.327448]  [<ffffffff810f478c>] ? slob_free+0x10c/0x370
[ 2668.327448]  [<ffffffff8107c0a1>] lock_acquire+0xe1/0x120
[ 2668.327448]  [<ffffffff8112f1b5>] ? inotify_inode_is_dead+0x35/0xb0
[ 2668.327448]  [<ffffffff81562d43>] mutex_lock_nested+0x63/0x420
[ 2668.327448]  [<ffffffff8112f1b5>] ? inotify_inode_is_dead+0x35/0xb0
[ 2668.327448]  [<ffffffff8112f1b5>] ? inotify_inode_is_dead+0x35/0xb0
[ 2668.327448]  [<ffffffff81012fe9>] ? sched_clock+0x9/0x10
[ 2668.327448]  [<ffffffff81077165>] ? lock_release_holdtime+0x35/0x1c0
[ 2668.327448]  [<ffffffff8112f1b5>] inotify_inode_is_dead+0x35/0xb0
[ 2668.327448]  [<ffffffff8110c9dc>] dentry_iput+0xbc/0xe0
[ 2668.327448]  [<ffffffff8110cb23>] d_kill+0x33/0x60
[ 2668.327448]  [<ffffffff8110ce23>] __shrink_dcache_sb+0x2d3/0x350
[ 2668.327448]  [<ffffffff8110cffa>] shrink_dcache_memory+0x15a/0x1e0
[ 2668.327448]  [<ffffffff810d0cc5>] shrink_slab+0x125/0x180
[ 2668.327448]  [<ffffffff810d1540>] kswapd+0x560/0x7a0
[ 2668.327448]  [<ffffffff810ce160>] ? isolate_pages_global+0x0/0x2c0
[ 2668.327448]  [<ffffffff81065a30>] ? autoremove_wake_function+0x0/0x40
[ 2668.327448]  [<ffffffff8107953d>] ? trace_hardirqs_on+0xd/0x10
[ 2668.327448]  [<ffffffff810d0fe0>] ? kswapd+0x0/0x7a0
[ 2668.327448]  [<ffffffff8106555b>] kthread+0x5b/0xa0
[ 2668.327448]  [<ffffffff8100d40a>] child_rip+0xa/0x20
[ 2668.327448]  [<ffffffff8100cdd0>] ? restore_args+0x0/0x30
[ 2668.327448]  [<ffffffff81065500>] ? kthread+0x0/0xa0
[ 2668.327448]  [<ffffffff8100d400>] ? child_rip+0x0/0x20

[eparis@redhat.com: fix audit too]
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/inotify/inotify_user.c |    2 +-
 kernel/auditfilter.c             |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/notify/inotify/inotify_user.c~inotify-use-gfp_nofs-in-kernel_event-to-work-around-a-lockdep-false-positive fs/notify/inotify/inotify_user.c
--- a/fs/notify/inotify/inotify_user.c~inotify-use-gfp_nofs-in-kernel_event-to-work-around-a-lockdep-false-positive
+++ a/fs/notify/inotify/inotify_user.c
@@ -220,7 +220,7 @@ static struct inotify_kernel_event * ker
 				rem = 0;
 		}
 
-		kevent->name = kmalloc(len + rem, GFP_KERNEL);
+		kevent->name = kmalloc(len + rem, GFP_NOFS);
 		if (unlikely(!kevent->name)) {
 			kmem_cache_free(event_cachep, kevent);
 			return NULL;
diff -puN kernel/auditfilter.c~inotify-use-gfp_nofs-in-kernel_event-to-work-around-a-lockdep-false-positive kernel/auditfilter.c
--- a/kernel/auditfilter.c~inotify-use-gfp_nofs-in-kernel_event-to-work-around-a-lockdep-false-positive
+++ a/kernel/auditfilter.c
@@ -1028,7 +1028,7 @@ static void audit_update_watch(struct au
 
 		if (audit_enabled) {
 			struct audit_buffer *ab;
-			ab = audit_log_start(NULL, GFP_KERNEL,
+			ab = audit_log_start(NULL, GFP_NOFS,
 				AUDIT_CONFIG_CHANGE);
 			audit_log_format(ab, "auid=%u ses=%u",
 				audit_get_loginuid(current),
@@ -1067,7 +1067,7 @@ static void audit_remove_parent_watches(
 			e = container_of(r, struct audit_entry, rule);
 			if (audit_enabled) {
 				struct audit_buffer *ab;
-				ab = audit_log_start(NULL, GFP_KERNEL,
+				ab = audit_log_start(NULL, GFP_NOFS,
 					AUDIT_CONFIG_CHANGE);
 				audit_log_format(ab, "auid=%u ses=%u",
 					audit_get_loginuid(current),
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch
readahead-make-mmap_miss-an-unsigned-int.patch
readahead-move-max_sane_readahead-calls-into-force_page_cache_readahead.patch
readahead-apply-max_sane_readahead-limit-in-ondemand_readahead.patch
readahead-remove-one-unnecessary-radix-tree-lookup.patch
readahead-increase-interleaved-readahead-size.patch
readahead-remove-sync-async-readahead-call-dependency.patch
readahead-clean-up-and-simplify-the-code-for-filemap-page-fault-readahead.patch
readahead-sequential-mmap-readahead.patch
readahead-enforce-full-readahead-size-on-async-mmap-readahead.patch
readahead-record-mmap-read-around-states-in-file_ra_state.patch
radix-tree-add-radix_tree_prev_hole.patch
readahead-move-the-random-read-case-to-bottom.patch
readahead-introduce-context-readahead-algorithm.patch
readahead-introduce-context-readahead-algorithm-update.patch
readahead-remove-redundant-test-in-shrink_readahead_size_eio.patch
readahead-enforce-full-sync-mmap-readahead-size.patch
pagemap-document-clarifications.patch
pagemap-documentation-9-more-exported-page-flags.patch
mm-introduce-pagehuge-for-testing-huge-gigantic-pages.patch
proc-kpagecount-kpageflags-code-cleanup.patch
proc-export-more-page-flags-in-proc-kpageflags.patch
vmscan-cleanup-the-scan-batching-code.patch
vmscan-dont-export-nr_saved_scan-in-proc-zoneinfo.patch
vmscan-zvc-updates-in-shrink_active_list-can-be-done-once.patch

