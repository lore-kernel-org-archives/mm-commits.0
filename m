From: akpm@linux-foundation.org
Subject: + vmscantmpfs-treat-used-once-pages-on-tmpfs-as-used-once.patch added to -mm tree
Date: Fri, 17 Sep 2010 14:14:29 -0700
Message-ID: <201009172114.o8HLETnx010453@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59286 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753671Ab0IQVOx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Sep 2010 17:14:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, hannes@cmpxchg.org, hughd@google.com, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     vmscan,tmpfs: treat used once pages on tmpfs as used once
has been added to the -mm tree.  Its filename is
     vmscantmpfs-treat-used-once-pages-on-tmpfs-as-used-once.patch

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
Subject: vmscan,tmpfs: treat used once pages on tmpfs as used once
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

When a page has PG_referenced, shrink_page_list() discards it only if it
is not dirty.  This rule works fine if the backing filesystem is a regular
one.  PG_dirty is a good signal that the page was used recently because
the flusher threads clean pages periodically.  In addition, page writeback
is costlier than simple page discard.

However, when a page is on tmpfs this heuristic doesn't work because
flusher threads don't write back tmpfs pages.  Consequently tmpfs pages
always rotate around the lru twice at least and adds unnecessary lru
churn.  Simple tmpfs streaming io shouldn't cause large anonymous page
swap-out.

Remove this unncessary reclaim bonus of tmpfs pages.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~vmscantmpfs-treat-used-once-pages-on-tmpfs-as-used-once mm/vmscan.c
--- a/mm/vmscan.c~vmscantmpfs-treat-used-once-pages-on-tmpfs-as-used-once
+++ a/mm/vmscan.c
@@ -670,7 +670,7 @@ static enum page_references page_check_r
 	}
 
 	/* Reclaim if clean, defer dirty pages to writeback */
-	if (referenced_page)
+	if (referenced_page && !PageSwapBacked(page))
 		return PAGEREF_RECLAIM_CLEAN;
 
 	return PAGEREF_RECLAIM;
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

oom-always-return-a-badness-score-of-non-zero-for-eligible-tasks.patch
linux-next.patch
vmscan-check-all_unreclaimable-in-direct-reclaim-path.patch
vmscan-check-all_unreclaimable-in-direct-reclaim-path-v2.patch
proc-pid-smaps-fix-dirty-pages-accounting.patch
proc-pid-smaps-export-amount-of-anonymous-memory-in-a-mapping.patch
oom-filter-unkillable-tasks-from-tasklist-dump.patch
security-add-const-to-security_task_setscheduler.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
oom-add-per-mm-oom-disable-count.patch
oom-add-per-mm-oom-disable-count-protect-oom_disable_count-with-task_lock-in-fork.patch
oom-add-per-mm-oom-disable-count-use-old_mm-for-oom_disable_count-in-exec.patch
oom-avoid-killing-a-task-if-a-thread-sharing-its-mm-cannot-be-killed.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix-fix.patch
oom-rewrite-error-handling-for-oom_adj-and-oom_score_adj-tunables.patch
oom-fix-locking-for-oom_adj-and-oom_score_adj.patch
mm-only-build-per-node-scan_unevictable-functions-when-numa-is-enabled.patch
vmscan-prevent-background-aging-of-anon-page-in-no-swap-system.patch
mm-mempolicy-check-return-code-of-check_range.patch
mm-add-account_page_writeback.patch
writeback-add-nr_dirtied-and-nr_written-to-proc-vmstat.patch
writeback-add-nr_dirtied-and-nr_written-to-proc-vmstat-update.patch
writeback-add-sys-devices-system-node-node-vmstat.patch
writeback-add-sys-devices-system-node-node-vmstat-update.patch
writeback-report-dirty-thresholds-in-proc-vmstat.patch
vmscan-delete-dead-code.patch
tracing-vmscan-add-trace-events-for-lru-list-shrinking.patch
writeback-account-for-time-spent-congestion_waited.patch
vmscan-synchronous-lumpy-reclaim-should-not-call-congestion_wait.patch
vmscan-narrow-the-scenarios-lumpy-reclaim-uses-synchrounous-reclaim.patch
vmscan-remove-dead-code-in-shrink_inactive_list.patch
vmscan-isolated_lru_pages-stop-neighbour-search-if-neighbour-cannot-be-isolated.patch
writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis.patch
writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis-or-if-significant-congestion-is-not-being-encountered-in-the-current-zone.patch
vmscantmpfs-treat-used-once-pages-on-tmpfs-as-used-once.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2.patch
reiser4.patch

