From: akpm@linux-foundation.org
Subject: + mempolicy-remove-tasklist_lock-from-migrate_pages.patch added to -mm tree
Date: Wed, 08 Dec 2010 15:57:13 -0800
Message-ID: <201012082357.oB8NvD3m017233@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60844 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755283Ab0LHX5W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Dec 2010 18:57:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, cl@linux-foundation.org, peterz@infradead.org


The patch titled
     mempolicy: remove tasklist_lock from migrate_pages
has been added to the -mm tree.  Its filename is
     mempolicy-remove-tasklist_lock-from-migrate_pages.patch

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
Subject: mempolicy: remove tasklist_lock from migrate_pages
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Today, tasklist_lock in migrate_pages doesn't protect anything. 
rcu_read_lock() provide enough protection from pid hash walk.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reported-by: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN mm/mempolicy.c~mempolicy-remove-tasklist_lock-from-migrate_pages mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-remove-tasklist_lock-from-migrate_pages
+++ a/mm/mempolicy.c
@@ -1310,16 +1310,13 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pi
 
 	/* Find the mm_struct */
 	rcu_read_lock();
-	read_lock(&tasklist_lock);
 	task = pid ? find_task_by_vpid(pid) : current;
 	if (!task) {
-		read_unlock(&tasklist_lock);
 		rcu_read_unlock();
 		err = -ESRCH;
 		goto out;
 	}
 	mm = get_task_mm(task);
-	read_unlock(&tasklist_lock);
 	rcu_read_unlock();
 
 	err = -EINVAL;
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

linux-next.patch
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
mlock-only-hold-mmap_sem-in-shared-mode-when-faulting-in-pages.patch
mm-add-foll_mlock-follow_page-flag.patch
mm-move-vm_locked-check-to-__mlock_vma_pages_range.patch
rwsem-implement-rwsem_is_contended.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time.patch
x86-rwsem-more-precise-rwsem_is_contended-implementation.patch
mempolicy-remove-tasklist_lock-from-migrate_pages.patch
kmsg_dump-add-kmsg_dump-calls-to-the-reboot-halt-poweroff-and-emergency_restart-paths.patch

