From: akpm@linux-foundation.org
Subject: + writeback-do-uninterruptible-sleep-in-balance_dirty_pages.patch added to -mm tree
Date: Wed, 08 Dec 2010 15:55:20 -0800
Message-ID: <201012082355.oB8NtKv6017176@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43635 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753103Ab0LHXzW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Dec 2010 18:55:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com


The patch titled
     writeback: do uninterruptible sleep in balance_dirty_pages()
has been added to the -mm tree.  Its filename is
     writeback-do-uninterruptible-sleep-in-balance_dirty_pages.patch

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
Subject: writeback: do uninterruptible sleep in balance_dirty_pages()
From: Wu Fengguang <fengguang.wu@intel.com>

Using TASK_INTERRUPTIBLE in balance_dirty_pages() seems wrong.  If it's
going to do that then it must break out if signal_pending(), otherwise
it's pretty much guaranteed to degenerate into a busywait loop.  Plus we
*do* want these processes to appear in D state and to contribute to load
average.

So it should be TASK_UNINTERRUPTIBLE.                 -- Andrew Morton

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page-writeback.c~writeback-do-uninterruptible-sleep-in-balance_dirty_pages mm/page-writeback.c
--- a/mm/page-writeback.c~writeback-do-uninterruptible-sleep-in-balance_dirty_pages
+++ a/mm/page-writeback.c
@@ -563,7 +563,7 @@ static void balance_dirty_pages(struct a
 				break;		/* We've done our duty */
 		}
 		trace_wbc_balance_dirty_wait(&wbc, bdi);
-		__set_current_state(TASK_INTERRUPTIBLE);
+		__set_current_state(TASK_UNINTERRUPTIBLE);
 		io_schedule_timeout(pause);
 
 		/*
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
writeback-do-uninterruptible-sleep-in-balance_dirty_pages.patch
writeback-integrated-background-writeback-work.patch
writeback-trace-wakeup-event-for-background-writeback.patch
writeback-stop-background-kupdate-works-from-livelocking-other-works.patch
writeback-stop-background-kupdate-works-from-livelocking-other-works-update.patch
writeback-avoid-livelocking-wb_sync_all-writeback.patch
writeback-avoid-livelocking-wb_sync_all-writeback-update.patch
writeback-check-skipped-pages-on-wb_sync_all.patch
writeback-check-skipped-pages-on-wb_sync_all-update.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
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
writeback-enabling-gate-for-light-dirtied-bdi.patch
writeback-enabling-gate-for-light-dirtied-bdi-fix.patch
writeback-safety-margin-for-bdi-stat-error.patch
mm-page-writebackc-fix-__set_page_dirty_no_writeback-return-value.patch
mm-find_get_pages_contig-fixlet.patch
mm-smaps-export-mlock-information.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
memcg-create-extensible-page-stat-update-routines.patch
memcg-add-lock-to-synchronize-page-accounting-and-migration.patch
memcg-use-zalloc-rather-than-mallocmemset.patch

