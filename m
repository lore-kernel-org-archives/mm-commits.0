From: akpm@linux-foundation.org
Subject: + vmstat-fix-dirty-threshold-ordering.patch added to -mm tree
Date: Mon, 29 Nov 2010 13:14:49 -0800
Message-ID: <201011292114.oATLEnBR011494@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58582 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751498Ab0K2VPO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Nov 2010 16:15:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, kosaki.motohiro@jp.fujitsu.com, mrubin@google.com


The patch titled
     vmstat: fix dirty threshold ordering
has been added to the -mm tree.  Its filename is
     vmstat-fix-dirty-threshold-ordering.patch

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
Subject: vmstat: fix dirty threshold ordering
From: Wu Fengguang <fengguang.wu@intel.com>

The nr_dirty_[background_]threshold fields are misplaced before the numa_*
fields, and users will read strange values.

This is the right order. Before patch, nr_dirty_background_threshold
will read as 0 (the value from numa_miss).

	numa_hit 128501
	numa_miss 0
	numa_foreign 0
	numa_interleave 7388
	numa_local 128501
	numa_other 0
	nr_dirty_threshold 144291
	nr_dirty_background_threshold 72145

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Michael Rubin <mrubin@google.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/vmstat.c~vmstat-fix-dirty-threshold-ordering mm/vmstat.c
--- a/mm/vmstat.c~vmstat-fix-dirty-threshold-ordering
+++ a/mm/vmstat.c
@@ -750,8 +750,6 @@ static const char * const vmstat_text[] 
 	"nr_shmem",
 	"nr_dirtied",
 	"nr_written",
-	"nr_dirty_threshold",
-	"nr_dirty_background_threshold",
 
 #ifdef CONFIG_NUMA
 	"numa_hit",
@@ -761,6 +759,8 @@ static const char * const vmstat_text[] 
 	"numa_local",
 	"numa_other",
 #endif
+	"nr_dirty_threshold",
+	"nr_dirty_background_threshold",
 
 #ifdef CONFIG_VM_EVENT_COUNTERS
 	"pgpgin",
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
vmstat-fix-dirty-threshold-ordering.patch
linux-next.patch
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
mm-page-writebackc-fix-__set_page_dirty_no_writeback-return-value.patch
mm-find_get_pages_contig-fixlet.patch
mm-smaps-export-mlock-information.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
memcg-create-extensible-page-stat-update-routines.patch
memcg-add-lock-to-synchronize-page-accounting-and-migration.patch
memcg-use-zalloc-rather-than-mallocmemset.patch

