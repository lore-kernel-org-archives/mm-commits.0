From: akpm@linux-foundation.org
Subject: + memory-hotplug-fix-notifiers-return-value-check.patch added to -mm tree
Date: Tue, 07 Sep 2010 14:04:46 -0700
Message-ID: <201009072104.o87L4kq7006042@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34849 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751795Ab0IGVGF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Sep 2010 17:06:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, fengguang.wu@intel.com, mel@csn.ul.ie, mhocko@suse.cz


The patch titled
     memory hotplug: fix notifier's return value check
has been added to the -mm tree.  Its filename is
     memory-hotplug-fix-notifiers-return-value-check.patch

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
Subject: memory hotplug: fix notifier's return value check
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Even if notifier cannot find any pages, it doesn't mean no pages are
available...And, if there are no notifiers registered, this condition will
be always true and memory hotplug will show -EBUSY.

This is a bug but not critical.

In most case, a pageblock which will be offlined is MIGRATE_MOVABLE This
"notifier" is called only when the pageblock is _not_ MIGRATE_MOVABLE. 
But if not MIGRATE_MOVABLE, it's common case that memory hotplug will
fail.  So, no one notice this bug.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~memory-hotplug-fix-notifiers-return-value-check mm/page_alloc.c
--- a/mm/page_alloc.c~memory-hotplug-fix-notifiers-return-value-check
+++ a/mm/page_alloc.c
@@ -5320,7 +5320,7 @@ int set_migratetype_isolate(struct page 
 	 */
 	notifier_ret = memory_isolate_notify(MEM_ISOLATE_COUNT, &arg);
 	notifier_ret = notifier_to_errno(notifier_ret);
-	if (notifier_ret || !arg.pages_found)
+	if (notifier_ret)
 		goto out;
 
 	for (iter = pfn; iter < (pfn + pageblock_nr_pages); iter++) {
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

linux-next.patch
memory-hotplug-fix-next-block-calculation-in-is_removable.patch
swap-revert-special-hibernation-allocation.patch
swap-prevent-reuse-during-hibernation.patch
vmstat-update-zone-stat-threshold-when-onlining-a-cpu.patch
mm-page-allocator-update-free-page-counters-after-pages-are-placed-on-the-free-list.patch
mm-page-allocator-update-free-page-counters-after-pages-are-placed-on-the-free-list-fix.patch
mm-page-allocator-drain-per-cpu-lists-after-direct-reclaim-allocation-fails.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
vmscan-kick-flusher-threads-to-clean-pages-when-reclaim-is-encountering-dirty-pages.patch
oom-add-per-mm-oom-disable-count.patch
oom-avoid-killing-a-task-if-a-thread-sharing-its-mm-cannot-be-killed.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix-fix.patch
oom-rewrite-error-handling-for-oom_adj-and-oom_score_adj-tunables.patch
oom-fix-locking-for-oom_adj-and-oom_score_adj.patch
memory-hotplug-fix-notifiers-return-value-check.patch
memory-hotplug-unify-is_removable-and-offline-detection-code.patch

