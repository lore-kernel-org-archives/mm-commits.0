From: akpm@linux-foundation.org
Subject: + writeback-safety-margin-for-bdi-stat-error.patch added to -mm tree
Date: Wed, 08 Dec 2010 12:40:46 -0800
Message-ID: <201012082040.oB8Kelat008004@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49450 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756349Ab0LHUlz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Dec 2010 15:41:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, a.p.zijlstra@chello.nl, david@fromorbit.com, hch@lst.de, jack@suse.cz, mel@csn.ul.ie, mrubin@google.com, riel@redhat.com


The patch titled
     writeback: safety margin for bdi stat error
has been added to the -mm tree.  Its filename is
     writeback-safety-margin-for-bdi-stat-error.patch

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
Subject: writeback: safety margin for bdi stat error
From: Wu Fengguang <fengguang.wu@intel.com>

In a simple dd test on a 8p system with "mem=256M", I find all light
dirtier tasks on the root fs are get heavily throttled.  That happens
because the global limit is exceeded.  It's unbelievable at first sight,
because the test fs doing the heavy dd is under its bdi limit.  After
doing some tracing, it's discovered that

	bdi_dirty < bdi_dirty_limit() < global_dirty_limit() < nr_dirty

So the root cause is, the bdi_dirty is well under the global nr_dirty due
to accounting errors.  This can be fixed by using bdi_stat_sum(), however
that's costly on large NUMA machines.  So do a less costly fix of lowering
the bdi limit, so that the accounting errors won't lead to the absurd
situation "global limit exceeded but bdi limit not exceeded".

This provides guarantee when there is only 1 heavily dirtied bdi, and
works by opportunity for 2+ heavy dirtied bdi's (hopefully they won't
reach big error _and_ exceed their bdi limit at the same time).

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Michael Rubin <mrubin@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff -puN mm/page-writeback.c~writeback-safety-margin-for-bdi-stat-error mm/page-writeback.c
--- a/mm/page-writeback.c~writeback-safety-margin-for-bdi-stat-error
+++ a/mm/page-writeback.c
@@ -421,10 +421,16 @@ void global_dirty_limits(unsigned long *
 	*pdirty = dirty;
 }
 
-/*
+/**
  * bdi_dirty_limit - @bdi's share of dirty throttling threshold
+ * @bdi: the backing_dev_info to query
+ * @dirty: global dirty limit in pages
+ * @dirty_pages: current number of dirty pages
  *
- * Allocate high/low dirty limits to fast/slow devices, in order to prevent
+ * Returns @bdi's dirty limit in pages. The term "dirty" in the context of
+ * dirty balancing includes all PG_dirty, PG_writeback and NFS unstable pages.
+ *
+ * It allocates high/low dirty limits to fast/slow devices, in order to prevent
  * - starving fast devices
  * - piling up dirty pages (that will take long time to sync) on slow devices
  *
@@ -445,6 +451,14 @@ unsigned long bdi_dirty_limit(struct bac
 	long numerator, denominator;
 
 	/*
+	 * try to prevent "global limit exceeded but bdi limit not exceeded"
+	 */
+	if (likely(dirty > bdi_stat_error(bdi)))
+		dirty -= bdi_stat_error(bdi);
+	else
+		return 0;
+
+	/*
 	 * Provide a global safety margin of ~1%, or up to 32MB for a 20GB box.
 	 */
 	dirty -= min(dirty / 128, 32768UL >> (PAGE_SHIFT-10));
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

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

