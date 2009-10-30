From: akpm@linux-foundation.org
Subject: [merged] congestion_wait-dont-use-write.patch removed from -mm tree
Date: Fri, 30 Oct 2009 13:48:30 -0700
Message-ID: <200910302048.n9UKmUrF005965@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52228 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757471AbZJ3UtO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Oct 2009 16:49:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, jens.axboe@oracle.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     congestion_wait(): don't use WRITE
has been removed from the -mm tree.  Its filename was
     congestion_wait-dont-use-write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: congestion_wait(): don't use WRITE
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit 8aa7e847d (Fix congestion_wait() sync/async vs read/write
confusion) replace WRITE with BLK_RW_ASYNC.  Unfortunately, concurrent mm
development made the unchanged place accidentally.

This patch fixes it too.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN mm/vmscan.c~congestion_wait-dont-use-write mm/vmscan.c
--- a/mm/vmscan.c~congestion_wait-dont-use-write
+++ a/mm/vmscan.c
@@ -1088,7 +1088,7 @@ static unsigned long shrink_inactive_lis
 	int lumpy_reclaim = 0;
 
 	while (unlikely(too_many_isolated(zone, file, sc))) {
-		congestion_wait(WRITE, HZ/10);
+		congestion_wait(BLK_RW_ASYNC, HZ/10);
 
 		/* We are about to die and free our memory. Return now. */
 		if (fatal_signal_pending(current))
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
page-allocator-always-wake-kswapd-when-restarting-an-allocation-attempt-after-direct-reclaim-failed.patch
page-allocator-do-not-allow-interrupts-to-use-alloc_harder.patch
linux-next.patch
oom-dump-stack-and-vm-state-when-oom-killer-panics.patch
readahead-add-blk_run_backing_dev.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch
mm-move-inc_zone_page_statenr_isolated-to-just-isolated-place.patch
oom_kill-use-rss-value-instead-of-vm-size-for-badness.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

