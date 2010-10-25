From: akpm@linux-foundation.org
Subject: + mm-fix-is_mem_section_removable-page_order-bug_on-check.patch added to -mm tree
Date: Mon, 25 Oct 2010 14:25:35 -0700
Message-ID: <201010252125.o9PLPZam017266@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50655 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751053Ab0JYV0E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Oct 2010 17:26:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, fengguang.wu@intel.com, mel@csn.ul.ie, mhocko@suse.cz, stable@kernel.org


The patch titled
     mm: fix is_mem_section_removable() page_order BUG_ON check
has been added to the -mm tree.  Its filename is
     mm-fix-is_mem_section_removable-page_order-bug_on-check.patch

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
Subject: mm: fix is_mem_section_removable() page_order BUG_ON check
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

page_order() is called by memory hotplug's user interface to check the
section is removable or not.  (is_mem_section_removable())

It calls page_order() withoug holding zone->lock.
So, even if the caller does

	if (PageBuddy(page))
		ret = page_order(page) ...
The caller may hit BUG_ON().

For fixing this, there are 2 choices.
  1. add zone->lock.
  2. remove BUG_ON().

is_mem_section_removable() is used for some "advice" and doesn't need to
be 100% accurate.  This is_removable() can be called via user program.. 
We don't want to take this important lock for long by user's request.  So,
this patch removes BUG_ON().

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/internal.h~mm-fix-is_mem_section_removable-page_order-bug_on-check mm/internal.h
--- a/mm/internal.h~mm-fix-is_mem_section_removable-page_order-bug_on-check
+++ a/mm/internal.h
@@ -62,7 +62,7 @@ extern bool is_free_buddy_page(struct pa
  */
 static inline unsigned long page_order(struct page *page)
 {
-	VM_BUG_ON(!PageBuddy(page));
+	/* PageBuddy() must be checked by the caller */
 	return page_private(page);
 }
 
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
mm-fix-return-value-of-scan_lru_pages-in-memory-unplug.patch
linux-next.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
oom-add-per-mm-oom-disable-count.patch
oom-add-per-mm-oom-disable-count-protect-oom_disable_count-with-task_lock-in-fork.patch
oom-add-per-mm-oom-disable-count-use-old_mm-for-oom_disable_count-in-exec.patch
oom-avoid-killing-a-task-if-a-thread-sharing-its-mm-cannot-be-killed.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix-fix.patch
oom-rewrite-error-handling-for-oom_adj-and-oom_score_adj-tunables.patch
oom-fix-locking-for-oom_adj-and-oom_score_adj.patch
memory-hotplug-fix-notifiers-return-value-check.patch
memory-hotplug-unify-is_removable-and-offline-detection-code.patch
memory-hotplug-unify-is_removable-and-offline-detection-code-checkpatch-fixes.patch
tracing-vmscan-add-trace-events-for-lru-list-shrinking.patch
writeback-account-for-time-spent-congestion_waited.patch
vmscan-synchronous-lumpy-reclaim-should-not-call-congestion_wait.patch
vmscan-narrow-the-scenarios-lumpy-reclaim-uses-synchrounous-reclaim.patch
vmscan-remove-dead-code-in-shrink_inactive_list.patch
vmscan-isolated_lru_pages-stop-neighbour-search-if-neighbour-cannot-be-isolated.patch
writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis.patch
writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis-or-if-significant-congestion-is-not-being-encountered-in-the-current-zone.patch
writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis-or-if-significant-congestion-is-not-being-encounted-in-the-current-zone-fix.patch
mm-memory_hotplugc-make-scan_lru_pages-static.patch
mm-fix-error-reporting-in-move_pages-syscall.patch
mm-fix-is_mem_section_removable-page_order-bug_on-check.patch
memcg-fix-race-in-file_mapped-accouting-flag-management.patch
memcg-avoid-lock-in-updating-file_mapped-was-fix-race-in-file_mapped-accouting-flag-management.patch
memcg-use-for_each_mem_cgroup.patch
memcg-cpu-hotplug-aware-percpu-count-updates.patch
memcg-cpu-hotplug-aware-percpu-count-updates-fix.patch
memcg-cpu-hotplug-aware-quick-acount_move-detection.patch
memcg-cpu-hotplug-aware-quick-acount_move-detection-checkpatch-fixes.patch
memcg-generic-filestat-update-interface.patch
proc-stat-scalability-of-irq-num-per-cpu.patch
proc-stat-fix-scalability-of-irq-sum-of-all-cpu.patch
proc-stat-fix-scalability-of-irq-sum-of-all-cpu-fix.patch

