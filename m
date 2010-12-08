From: akpm@linux-foundation.org
Subject: + writeback-enabling-gate-for-light-dirtied-bdi-fix.patch added to -mm tree
Date: Wed, 08 Dec 2010 12:40:44 -0800
Message-ID: <201012082040.oB8Kei2E008001@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45003 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756662Ab0LHUlu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Dec 2010 15:41:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, a.p.zijlstra@chello.nl, david@fromorbit.com, hch@lst.de, jack@suse.cz, mel@csn.ul.ie, mrubin@google.com, riel@redhat.com


The patch titled
     writeback-enabling-gate-for-light-dirtied-bdi-fix
has been added to the -mm tree.  Its filename is
     writeback-enabling-gate-for-light-dirtied-bdi-fix.patch

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
Subject: writeback-enabling-gate-for-light-dirtied-bdi-fix
From: Wu Fengguang <fengguang.wu@intel.com>

> +	 * Provide a global safety margin of ~1%, or up to 32MB for a 20GB box.
> +	 */
> +	dirty -= min(dirty / 128, 32768ULL >> (PAGE_SHIFT-10));

/home/wfg/cc/linux-next/mm/page-writeback.c: In function `bdi_dirty_limit':
/home/wfg/cc/linux-next/mm/page-writeback.c:464:133: warning: comparison of distinct pointer types lacks a cast

Sorry, here is the fixed version.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Michael Rubin <mrubin@google.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page-writeback.c~writeback-enabling-gate-for-light-dirtied-bdi-fix mm/page-writeback.c
--- a/mm/page-writeback.c~writeback-enabling-gate-for-light-dirtied-bdi-fix
+++ a/mm/page-writeback.c
@@ -447,7 +447,7 @@ unsigned long bdi_dirty_limit(struct bac
 	/*
 	 * Provide a global safety margin of ~1%, or up to 32MB for a 20GB box.
 	 */
-	dirty -= min(dirty / 128, 32768ULL >> (PAGE_SHIFT-10));
+	dirty -= min(dirty / 128, 32768UL >> (PAGE_SHIFT-10));
 
 	/*
 	 * Calculate this BDI's share of the dirty ratio.
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

