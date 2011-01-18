From: akpm@linux-foundation.org
Subject: [folded] writeback-per-task-rate-limit-on-balance_dirty_pages-fix.patch removed from -mm tree
Date: Tue, 18 Jan 2011 14:04:41 -0800
Message-ID: <201101182204.p0IM4f6e008055@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40353 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751644Ab1ARWGH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Jan 2011 17:06:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, a.p.zijlstra@chello.nl, axboe@kernel.dk, chris.mason@oracle.com, david@fromorbit.com, hch@lst.de, jack@suse.cz, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie


The patch titled
     writeback: fix increasement of nr_dirtied_pause
has been removed from the -mm tree.  Its filename was
     writeback-per-task-rate-limit-on-balance_dirty_pages-fix.patch

This patch was dropped because it was folded into writeback-per-task-rate-limit-on-balance_dirty_pages.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: writeback: fix increasement of nr_dirtied_pause
From: Wu Fengguang <fengguang.wu@intel.com>

Date: Wed Nov 17 22:31:26 CST 2010

Fix a bug that

	current->nr_dirtied_pause += current->nr_dirtied_pause >> 5;

does not effectively increase nr_dirtied_pause when it's <= 32.
Thus nr_dirtied_pause may never grow up..

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Cc: Michael Rubin <mrubin@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page-writeback.c~writeback-per-task-rate-limit-on-balance_dirty_pages-fix mm/page-writeback.c
--- a/mm/page-writeback.c~writeback-per-task-rate-limit-on-balance_dirty_pages-fix
+++ a/mm/page-writeback.c
@@ -580,7 +580,7 @@ pause:
 	if (pause == 0 && nr_dirty < background_thresh)
 		current->nr_dirtied_pause = ratelimit_pages(bdi);
 	else if (pause == 1)
-		current->nr_dirtied_pause += current->nr_dirtied_pause >> 5;
+		current->nr_dirtied_pause += current->nr_dirtied_pause / 32 + 1;
 	else if (pause >= HZ/10)
 		/*
 		 * when repeated, writing 1 page per 100ms on slow devices,
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
writeback-check-skipped-pages-on-wb_sync_all.patch
writeback-io-less-balance_dirty_pages.patch
writeback-consolidate-variable-names-in-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages.patch
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

