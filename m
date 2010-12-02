From: akpm@linux-foundation.org
Subject: + ksm-annotate-ksm_thread_mutex-is-no-deadlock-source.patch added to -mm tree
Date: Wed, 01 Dec 2010 16:10:10 -0800
Message-ID: <201012020010.oB20AAT7019996@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46935 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752844Ab0LBAKg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Dec 2010 19:10:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, aarcange@redhat.com, andi@firstfloor.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     ksm: annotate ksm_thread_mutex is no deadlock source
has been added to the -mm tree.  Its filename is
     ksm-annotate-ksm_thread_mutex-is-no-deadlock-source.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ksm: annotate ksm_thread_mutex is no deadlock source
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit 62b61f611e ("ksm: memory hotremove migration only") caused the
following new lockdep warning.

  =======================================================
  [ INFO: possible circular locking dependency detected ]
  -------------------------------------------------------
  bash/1621 is trying to acquire lock:
   ((memory_chain).rwsem){.+.+.+}, at: [<ffffffff81079339>]
  __blocking_notifier_call_chain+0x69/0xc0

  but task is already holding lock:
   (ksm_thread_mutex){+.+.+.}, at: [<ffffffff8113a3aa>]
  ksm_memory_callback+0x3a/0xc0

  which lock already depends on the new lock.

  the existing dependency chain (in reverse order) is:

  -> #1 (ksm_thread_mutex){+.+.+.}:
       [<ffffffff8108b70a>] lock_acquire+0xaa/0x140
       [<ffffffff81505d74>] __mutex_lock_common+0x44/0x3f0
       [<ffffffff81506228>] mutex_lock_nested+0x48/0x60
       [<ffffffff8113a3aa>] ksm_memory_callback+0x3a/0xc0
       [<ffffffff8150c21c>] notifier_call_chain+0x8c/0xe0
       [<ffffffff8107934e>] __blocking_notifier_call_chain+0x7e/0xc0
       [<ffffffff810793a6>] blocking_notifier_call_chain+0x16/0x20
       [<ffffffff813afbfb>] memory_notify+0x1b/0x20
       [<ffffffff81141b7c>] remove_memory+0x1cc/0x5f0
       [<ffffffff813af53d>] memory_block_change_state+0xfd/0x1a0
       [<ffffffff813afd62>] store_mem_state+0xe2/0xf0
       [<ffffffff813a0bb0>] sysdev_store+0x20/0x30
       [<ffffffff811bc116>] sysfs_write_file+0xe6/0x170
       [<ffffffff8114f398>] vfs_write+0xc8/0x190
       [<ffffffff8114fc14>] sys_write+0x54/0x90
       [<ffffffff810028b2>] system_call_fastpath+0x16/0x1b

  -> #0 ((memory_chain).rwsem){.+.+.+}:
       [<ffffffff8108b5ba>] __lock_acquire+0x155a/0x1600
       [<ffffffff8108b70a>] lock_acquire+0xaa/0x140
       [<ffffffff81506601>] down_read+0x51/0xa0
       [<ffffffff81079339>] __blocking_notifier_call_chain+0x69/0xc0
       [<ffffffff810793a6>] blocking_notifier_call_chain+0x16/0x20
       [<ffffffff813afbfb>] memory_notify+0x1b/0x20
       [<ffffffff81141f1e>] remove_memory+0x56e/0x5f0
       [<ffffffff813af53d>] memory_block_change_state+0xfd/0x1a0
       [<ffffffff813afd62>] store_mem_state+0xe2/0xf0
       [<ffffffff813a0bb0>] sysdev_store+0x20/0x30
       [<ffffffff811bc116>] sysfs_write_file+0xe6/0x170
       [<ffffffff8114f398>] vfs_write+0xc8/0x190
       [<ffffffff8114fc14>] sys_write+0x54/0x90
       [<ffffffff810028b2>] system_call_fastpath+0x16/0x1b

But it's a false positive.  Both memory_chain.rwsem and ksm_thread_mutex
have an outer lock (mem_hotplug_mutex).  So they cannot deadlock.

Thus, This patch annotate ksm_thread_mutex is not deadlock source.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/ksm.c~ksm-annotate-ksm_thread_mutex-is-no-deadlock-source mm/ksm.c
--- a/mm/ksm.c~ksm-annotate-ksm_thread_mutex-is-no-deadlock-source
+++ a/mm/ksm.c
@@ -1724,8 +1724,10 @@ static int ksm_memory_callback(struct no
 		/*
 		 * Keep it very simple for now: just lock out ksmd and
 		 * MADV_UNMERGEABLE while any memory is going offline.
+		 * Mutex_lock_nested() is necessary to tell that
+		 * ksm_thread_mutex is not unlocked here intentionally.
 		 */
-		mutex_lock(&ksm_thread_mutex);
+		mutex_lock_nested(&ksm_thread_mutex, SINGLE_DEPTH_NESTING);
 		break;
 
 	case MEM_OFFLINE:
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
mm-mempolicyc-add-rcu-read-lock-to-protect-pid-structure.patch
vmstat-fix-dirty-threshold-ordering.patch
linux-next.patch
ksm-annotate-ksm_thread_mutex-is-no-deadlock-source.patch
ksm-annotate-ksm_thread_mutex-is-no-deadlock-source-fix.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-update.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix-set_pgdat_percpu_threshold-dont-use-for_each_online_cpu.patch
writeback-io-less-balance_dirty_pages.patch
writeback-consolidate-variable-names-in-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages-fix.patch
writeback-prevent-duplicate-balance_dirty_pages_ratelimited-calls.patch
writeback-account-per-bdi-accumulated-written-pages.patch
writeback-bdi-write-bandwidth-estimation.patch
writeback-bdi-write-bandwidth-estimation-fix.patch
writeback-show-bdi-write-bandwidth-in-debugfs.patch
writeback-quit-throttling-when-bdi-dirty-pages-dropped-low.patch
writeback-reduce-per-bdi-dirty-threshold-ramp-up-time.patch
writeback-make-reasonable-gap-between-the-dirty-background-thresholds.patch
writeback-scale-down-max-throttle-bandwidth-on-concurrent-dirtiers.patch
writeback-add-trace-event-for-balance_dirty_pages.patch
writeback-make-nr_to_write-a-per-file-limit.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
vmscan-factor-out-kswapd-sleeping-logic-from-kswapd.patch
mm-compaction-add-trace-events-for-memory-compaction-activity.patch
mm-vmscan-convert-lumpy_mode-into-a-bitmask.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path-fix.patch
mm-migration-cleanup-migrate_pages-api-by-matching-types-for-offlining-and-sync.patch
mm-compaction-perform-a-faster-migration-scan-when-migrating-asynchronously.patch
mm-vmscan-rename-lumpy_mode-to-reclaim_mode.patch
mm-deactivate-invalidated-pages.patch
mm-deactivate-invalidated-pages-fix.patch
oom-allow-a-non-cap_sys_resource-proces-to-oom_score_adj-down.patch
do_wp_page-remove-the-reuse-flag.patch
do_wp_page-clarify-dirty_page-handling.patch
mlock-avoid-dirtying-pages-and-triggering-writeback.patch
kmsg_dump-add-kmsg_dump-calls-to-the-reboot-halt-poweroff-and-emergency_restart-paths.patch

