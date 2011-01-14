From: akpm@linux-foundation.org
Subject: [merged] mempolicy-remove-tasklist_lock-from-migrate_pages.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:45:40 -0800
Message-ID: <201101142248.p0EMmUQC005205@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41416 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752643Ab1ANWsf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:48:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, cl@linux-foundation.org, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mempolicy: remove tasklist_lock from migrate_pages
has been removed from the -mm tree.  Its filename was
     mempolicy-remove-tasklist_lock-from-migrate_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
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
mm-deactivate-invalidated-pages.patch
mm-deactivate-invalidated-pages-fix.patch

