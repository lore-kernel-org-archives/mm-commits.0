From: akpm@linux-foundation.org
Subject: - writeback-introduce-writeback_controlmore_io-to-indicate-more-io.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:02:37 -0700
Message-ID: <200710180702.l9I72bQ3031290@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42058 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756357AbXJRHeA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:34:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, dgc@sgi.com, kenchen@google.com, mm-commits@vger.kernel.org


The patch titled
     writeback: introduce writeback_control.more_io to indicate more io
has been removed from the -mm tree.  Its filename was
     writeback-introduce-writeback_controlmore_io-to-indicate-more-io.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: writeback: introduce writeback_control.more_io to indicate more io
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

After making dirty a 100M file, the normal behavior is to start the writeback
for all data after 30s delays.  But sometimes the following happens instead:

	- after 30s:    ~4M
	- after 5s:     ~4M
	- after 5s:     all remaining 92M

Some analyze shows that the internal io dispatch queues goes like this:

		s_io            s_more_io
		-------------------------
	1)	100M,1K         0
	2)	1K              96M
	3)	0               96M

1) initial state with a 100M file and a 1K file
2) 4M written, nr_to_write <= 0, so write more
3) 1K written, nr_to_write > 0, no more writes(BUG)

nr_to_write > 0 in (3) fools the upper layer to think that data have all been
written out.  The big dirty file is actually still sitting in s_more_io.  We
cannot simply splice s_more_io back to s_io as soon as s_io becomes empty, and
let the loop in generic_sync_sb_inodes() continue: this may starve newly
expired inodes in s_dirty.  It is also not an option to draw inodes from both
s_more_io and s_dirty, an let the loop go on: this might lead to live locks,
and might also starve other superblocks in sync time(well kupdate may still
starve some superblocks, that's another bug).

We have to return when a full scan of s_io completes.  So nr_to_write > 0 does
not necessarily mean that "all data are written".  This patch introduces a
flag writeback_control.more_io to indicate this situation.  With it the big
dirty file no longer has to wait for the next kupdate invocation 5s later.

Cc: David Chinner <dgc@sgi.com>
Cc: Ken Chen <kenchen@google.com>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c         |    2 ++
 include/linux/writeback.h |    1 +
 mm/page-writeback.c       |    9 ++++++---
 3 files changed, 9 insertions(+), 3 deletions(-)

diff -puN fs/fs-writeback.c~writeback-introduce-writeback_controlmore_io-to-indicate-more-io fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-introduce-writeback_controlmore_io-to-indicate-more-io
+++ a/fs/fs-writeback.c
@@ -473,6 +473,8 @@ sync_sb_inodes(struct super_block *sb, s
 		if (wbc->nr_to_write <= 0)
 			break;
 	}
+	if (!list_empty(&sb->s_more_io))
+		wbc->more_io = 1;
 	return;		/* Leave any unwritten inodes on s_io */
 }
 
diff -puN include/linux/writeback.h~writeback-introduce-writeback_controlmore_io-to-indicate-more-io include/linux/writeback.h
--- a/include/linux/writeback.h~writeback-introduce-writeback_controlmore_io-to-indicate-more-io
+++ a/include/linux/writeback.h
@@ -62,6 +62,7 @@ struct writeback_control {
 	unsigned for_reclaim:1;		/* Invoked from the page allocator */
 	unsigned for_writepages:1;	/* This is a writepages() call */
 	unsigned range_cyclic:1;	/* range_start is cyclic */
+	unsigned more_io:1;		/* more io to be dispatched */
 };
 
 /*
diff -puN mm/page-writeback.c~writeback-introduce-writeback_controlmore_io-to-indicate-more-io mm/page-writeback.c
--- a/mm/page-writeback.c~writeback-introduce-writeback_controlmore_io-to-indicate-more-io
+++ a/mm/page-writeback.c
@@ -553,6 +553,7 @@ static void background_writeout(unsigned
 			global_page_state(NR_UNSTABLE_NFS) < background_thresh
 				&& min_pages <= 0)
 			break;
+		wbc.more_io = 0;
 		wbc.encountered_congestion = 0;
 		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
 		wbc.pages_skipped = 0;
@@ -560,8 +561,9 @@ static void background_writeout(unsigned
 		min_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
 		if (wbc.nr_to_write > 0 || wbc.pages_skipped > 0) {
 			/* Wrote less than expected */
-			congestion_wait(WRITE, HZ/10);
-			if (!wbc.encountered_congestion)
+			if (wbc.encountered_congestion || wbc.more_io)
+				congestion_wait(WRITE, HZ/10);
+			else
 				break;
 		}
 	}
@@ -626,11 +628,12 @@ static void wb_kupdate(unsigned long arg
 			global_page_state(NR_UNSTABLE_NFS) +
 			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
 	while (nr_to_write > 0) {
+		wbc.more_io = 0;
 		wbc.encountered_congestion = 0;
 		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
 		writeback_inodes(&wbc);
 		if (wbc.nr_to_write > 0) {
-			if (wbc.encountered_congestion)
+			if (wbc.encountered_congestion || wbc.more_io)
 				congestion_wait(WRITE, HZ/10);
 			else
 				break;	/* All the old data is written */
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
