From: akpm@linux-foundation.org
Subject: [merged] writeback-refill-b_io-iff-empty.patch removed from -mm tree
Date: Thu, 09 Jun 2011 12:05:32 -0700
Message-ID: <201106091904.p59J4J3G025389@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60235 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752683Ab1FITGL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jun 2011 15:06:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, david@fromorbit.com, jack@suse.cz, kitayama@cl.bb4u.ne.jp, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     writeback: refill b_io iff empty
has been removed from the -mm tree.  Its filename was
     writeback-refill-b_io-iff-empty.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: writeback: refill b_io iff empty
From: Wu Fengguang <fengguang.wu@intel.com>

There is no point in carrying different refill policies between
for_kupdate and other type of works.  Use a consistent "refill b_io iff
empty" policy which can guarantee fairness in an easy to understand way.

A b_io refill will setup a _fixed_ work set with all currently eligible
inodes and start a new round of walking through b_io.  The "fixed" work
set means no new inodes will be added to the work set during the walk. 
Only when a complete walk over b_io is done, new inodes that are eligible
at the time will be enqueued and the walk will be started over.

This procedure provides fairness among the inodes because it guarantees
that each inode will be synced once and only once in each round.  So all
inodes will be free from starvation.

This change relies on wb_writeback() keeping retrying as long as we made
some progress on cleaning some pages and/or inodes.  Without that ability,
the old logic for background works relies on aggressively queuing all
eligible inodes into b_io at every time.  But that's not a guarantee.

The below test script completes slightly faster now on XFS:

             2.6.39-rc3	  2.6.39-rc3-dyn-expire+
================================================
all elapsed     256.043      252.367
stddev           24.381       12.530

tar elapsed      30.097       28.808
dd  elapsed      13.214       11.782

	#!/bin/zsh

	cp /c/linux-2.6.38.3.tar.bz2 /dev/shm/

	umount /dev/sda7
	mkfs.xfs -f /dev/sda7
	mount /dev/sda7 /fs

	echo 3 > /proc/sys/vm/drop_caches

	tic=$(cat /proc/uptime|cut -d' ' -f2)

	cd /fs
	time tar jxf /dev/shm/linux-2.6.38.3.tar.bz2 &
	time dd if=/dev/zero of=/fs/zero bs=1M count=1000 &

	wait
	sync
	tac=$(cat /proc/uptime|cut -d' ' -f2)
	echo elapsed: $((tac - tic))

It maintains roughly the same small vs.  large file writeout shares, and
offers large files better chances to be written in nice 4M chunks.

Analysis from Dave Chinner in great detail:

Let's say we have lots of inodes with 100 dirty pages being created, and
one large writeback going on.  We expire 8 new inodes for every 1024 pages
we write back.

With the old code, we do:

	b_more_io (large inode) -> b_io (1l)
	8 newly expired inodes -> b_io (1l, 8s)

	writeback  large inode 1024 pages -> b_more_io

	b_more_io (large inode) -> b_io (8s, 1l)
	8 newly expired inodes -> b_io (8s, 1l, 8s)

	writeback  8 small inodes 800 pages
		   1 large inode 224 pages -> b_more_io

	b_more_io (large inode) -> b_io (8s, 1l)
	8 newly expired inodes -> b_io (8s, 1l, 8s)
	.....

Your new code:

	b_more_io (large inode) -> b_io (1l)
	8 newly expired inodes -> b_io (1l, 8s)

	writeback  large inode 1024 pages -> b_more_io
	(b_io == 8s)
	writeback  8 small inodes 800 pages

	b_io empty: (1800 pages written)
		b_more_io (large inode) -> b_io (1l)
		14 newly expired inodes -> b_io (1l, 14s)

	writeback  large inode 1024 pages -> b_more_io
	(b_io == 14s)
	writeback  10 small inodes 1000 pages
		   1 small inode 24 pages -> b_more_io (1l, 1s(24))
	writeback  5 small inodes 500 pages
	b_io empty: (2548 pages written)
		b_more_io (large inode) -> b_io (1l, 1s(24))
		20 newly expired inodes -> b_io (1l, 1s(24), 20s)
	......

Rough progression of pages written at b_io refill:

Old code:

	total	large file	% of writeback
	1024	224		21.9% (fixed)

New code:
	total	large file	% of writeback
	1800	1024		~55%
	2550	1024		~40%
	3050	1024		~33%
	3500	1024		~29%
	3950	1024		~26%
	4250	1024		~24%
	4500	1024		~22.7%
	4700	1024		~21.7%
	4800	1024		~21.3%
	4800	1024		~21.3%
	(pretty much steady state from here)

Ok, so the steady state is reached with a similar percentage of writeback
to the large file as the existing code.  Ok, that's good, but providing
some evidence that is doesn't change the shared of writeback to the large
should be in the commit message ;)

The other advantage to this is that we always write 1024 page chunks to
the large file, rather than smaller "whatever remains" chunks.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/fs-writeback.c~writeback-refill-b_io-iff-empty fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-refill-b_io-iff-empty
+++ a/fs/fs-writeback.c
@@ -579,7 +579,8 @@ void writeback_inodes_wb(struct bdi_writ
 	if (!wbc->wb_start)
 		wbc->wb_start = jiffies; /* livelock avoidance */
 	spin_lock(&inode_wb_list_lock);
-	if (!wbc->for_kupdate || list_empty(&wb->b_io))
+
+	if (list_empty(&wb->b_io))
 		queue_io(wb, wbc);
 
 	while (!list_empty(&wb->b_io)) {
@@ -606,7 +607,7 @@ static void __writeback_inodes_sb(struct
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
 	spin_lock(&inode_wb_list_lock);
-	if (!wbc->for_kupdate || list_empty(&wb->b_io))
+	if (list_empty(&wb->b_io))
 		queue_io(wb, wbc);
 	writeback_sb_inodes(sb, wb, wbc, true);
 	spin_unlock(&inode_wb_list_lock);
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
bdi_min_ratio-never-shrinks-ultimately-preventing-valid-setting-of-min_ratio.patch

