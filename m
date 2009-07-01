From: akpm@linux-foundation.org
Subject: [merged] mm-prevent-balance_dirty_pages-from-doing-too-much-work.patch removed from -mm tree
Date: Wed, 01 Jul 2009 10:28:21 -0700
Message-ID: <200907011728.n61HSLV4003229@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58564 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755721AbZGAR2s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jul 2009 13:28:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@rsk.demon.co.uk, a.p.zijlstra@chello.nl, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     mm: prevent balance_dirty_pages() from doing too much work
has been removed from the -mm tree.  Its filename was
     mm-prevent-balance_dirty_pages-from-doing-too-much-work.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: prevent balance_dirty_pages() from doing too much work
From: Richard Kennedy <richard@rsk.demon.co.uk>

balance_dirty_pages can overreact and move all of the dirty pages to
writeback unnecessarily.

balance_dirty_pages makes its decision to throttle based on the number of
dirty plus writeback pages that are over the calculated limit,so it will
continue to move pages even when there are plenty of pages in writeback
and less than the threshold still dirty.

This allows it to overshoot its limits and move all the dirty pages to
writeback while waiting for the drives to catch up and empty the writeback
list.

A simple fio test easily demonstrates this problem.

fio --name=f1 --directory=/disk1 --size=2G -rw=write --name=f2 --directory=/disk2 --size=1G --rw=write --startdelay=10

This is the simplest fix I could find, but I'm not entirely sure that it
alone will be enough for all cases.  But it certainly is an improvement on
my desktop machine writing to 2 disks.

Do we need something more for machines with large arrays where
bdi_threshold * number_of_drives is greater than the dirty_ratio ?

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/page-writeback.c~mm-prevent-balance_dirty_pages-from-doing-too-much-work mm/page-writeback.c
--- a/mm/page-writeback.c~mm-prevent-balance_dirty_pages-from-doing-too-much-work
+++ a/mm/page-writeback.c
@@ -527,8 +527,11 @@ static void balance_dirty_pages(struct a
 		 * filesystems (i.e. NFS) in which data may have been
 		 * written to the server's write cache, but has not yet
 		 * been flushed to permanent storage.
+		 * Only move pages to writeback if this bdi is over its
+		 * threshold otherwise wait until the disk writes catch
+		 * up.
 		 */
-		if (bdi_nr_reclaimable) {
+		if (bdi_nr_reclaimable > bdi_thresh) {
 			generic_sync_bdi_inodes(NULL, &wbc);
 			pages_written += write_chunk - wbc.nr_to_write;
 			get_dirty_limits(&background_thresh, &dirty_thresh,
_

Patches currently in -mm which might be from richard@rsk.demon.co.uk are

origin.patch
revert-mm-prevent-balance_dirty_pages-from-doing-too-much-work.patch

