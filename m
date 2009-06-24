From: akpm@linux-foundation.org
Subject: + mm-prevent-balance_dirty_pages-from-doing-too-much-work.patch added to -mm tree
Date: Wed, 24 Jun 2009 15:28:43 -0700
Message-ID: <200906242228.n5OMShXj028134@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49334 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751169AbZFXW3N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jun 2009 18:29:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@rsk.demon.co.uk, a.p.zijlstra@chello.nl, jens.axboe@oracle.com


The patch titled
     mm: prevent balance_dirty_pages() from doing too much work
has been added to the -mm tree.  Its filename is
     mm-prevent-balance_dirty_pages-from-doing-too-much-work.patch

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

fio --name=f1 --directory=/disk1 --size=2G -rw=write
	--name=f2 --directory=/disk2 --size=1G --rw=write 		--startdelay=10

This is the simplest fix I could find, but I'm not entirely sure that it
alone will be enough for all cases.  But it certainly is an improvement on
my desktop machine writing to 2 disks.

Do we need something more for machines with large arrays where
bdi_threshold * number_of_drives is greater than the dirty_ratio ?

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/page-writeback.c~mm-prevent-balance_dirty_pages-from-doing-too-much-work mm/page-writeback.c
--- a/mm/page-writeback.c~mm-prevent-balance_dirty_pages-from-doing-too-much-work
+++ a/mm/page-writeback.c
@@ -541,8 +541,11 @@ static void balance_dirty_pages(struct a
 		 * filesystems (i.e. NFS) in which data may have been
 		 * written to the server's write cache, but has not yet
 		 * been flushed to permanent storage.
+		 * Only move pages to writeback if this bdi is over its
+		 * threshold otherwise wait until the disk writes catch
+		 * up.
 		 */
-		if (bdi_nr_reclaimable) {
+		if (bdi_nr_reclaimable > bdi_thresh) {
 			writeback_inodes(&wbc);
 			pages_written += write_chunk - wbc.nr_to_write;
 			get_dirty_limits(&background_thresh, &dirty_thresh,
_

Patches currently in -mm which might be from richard@rsk.demon.co.uk are

origin.patch
mm-prevent-balance_dirty_pages-from-doing-too-much-work.patch

