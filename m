From: akpm@linux-foundation.org
Subject: + writeback-stop-background-kupdate-works-from-livelocking-other-works.patch added to -mm tree
Date: Tue, 09 Nov 2010 14:47:45 -0800
Message-ID: <201011092247.oA9MljXc011854@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42674 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754424Ab0KIWsg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Nov 2010 17:48:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, axboe@kernel.dk, david@fromorbit.com, fengguang.wu@intel.com, hannes@cmpxchg.org, hch@lst.de, jengelh@medozas.de


The patch titled
     writeback: stop background/kupdate works from livelocking other works
has been added to the -mm tree.  Its filename is
     writeback-stop-background-kupdate-works-from-livelocking-other-works.patch

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
Subject: writeback: stop background/kupdate works from livelocking other works
From: Jan Kara <jack@suse.cz>

Background writeback are easily livelockable (from a definition of their
target).  This is inconvenient because it can make sync(1) stall forever
waiting on its queued work to be finished.  Generally, when a flusher
thread has some work queued, someone submitted the work to achieve a goal
more specific than what background writeback does.  So it makes sense to
give it a priority over a generic page cleaning.

Thus we interrupt background writeback if there is some other work to do. 
We return to the background writeback after completing all the queued
work.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de> 
Cc: Jan Engelhardt <jengelh@medozas.de>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN fs/fs-writeback.c~writeback-stop-background-kupdate-works-from-livelocking-other-works fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-stop-background-kupdate-works-from-livelocking-other-works
+++ a/fs/fs-writeback.c
@@ -651,6 +651,15 @@ static long wb_writeback(struct bdi_writ
 			break;
 
 		/*
+		 * Background writeout and kupdate-style writeback are
+		 * easily livelockable. Stop them if there is other work
+		 * to do so that e.g. sync can proceed.
+		 */
+		if ((work->for_background || work->for_kupdate) &&
+		    !list_empty(&wb->bdi->work_list))
+			break;
+
+		/*
 		 * For background writeout, stop when we are below the
 		 * background dirty threshold
 		 */
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
writeback-integrated-background-writeback-work.patch
writeback-trace-wakeup-event-for-background-writeback.patch
writeback-stop-background-kupdate-works-from-livelocking-other-works.patch
writeback-avoid-livelocking-wb_sync_all-writeback.patch
writeback-check-skipped-pages-on-wb_sync_all.patch

