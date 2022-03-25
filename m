Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43C3BC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:29:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345861AbiCYBb1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357312AbiCYBbV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:31:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BCBB286EA
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:29:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7497DB826FE
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:29:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33337C340ED;
        Fri, 25 Mar 2022 01:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171786;
        bh=K+7LPgSS6lNzBPJrrSILBM3JJuArLe2A90zcA7Kiq1M=;
        h=Date:To:From:Subject:From;
        b=oObHi4tVINeLsMlF1CYvBiMdSR8ZMQskzQ7vJpqORuMzAGsIFKTwGcriFqCSrwgN5
         bOivMzOLF3ZQ0X5bETdDD1oYZJHozYy/X+ldGHLteIQlejIj/nSJReF7VhIQsHnupb
         tlC4/1kn2G9qcL7MkJo9oiawDBYDfcbv5zLWp5qc=
Date:   Thu, 24 Mar 2022 18:29:45 -0700
To:     mm-commits@vger.kernel.org, trond.myklebust@hammerspace.com,
        philipp.reisner@linbit.com, paolo.valente@linaro.org,
        miklos@szeredi.hu, lars.ellenberg@linbit.com,
        konishi.ryusuke@gmail.com, jlayton@kernel.org, jaegeuk@kernel.org,
        jack@suse.cz, idryomov@gmail.com, fengguang.wu@intel.com,
        djwong@kernel.org, chao@kernel.org, axboe@kernel.dk,
        Anna.Schumaker@Netapp.com, neilb@suse.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] fuse-remove-reliance-on-bdi-congestion.patch removed from -mm tree
Message-Id: <20220325012946.33337C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fuse: remove reliance on bdi congestion
has been removed from the -mm tree.  Its filename was
     fuse-remove-reliance-on-bdi-congestion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: NeilBrown <neilb@suse.de>
Subject: fuse: remove reliance on bdi congestion

The bdi congestion tracking in not widely used and will be removed.

Fuse is one of a small number of filesystems that uses it, setting both
the sync (read) and async (write) congestion flags at what it determines
are appropriate times.

The only remaining effect of the sync flag is to cause read-ahead to be
skipped.  The only remaining effect of the async flag is to cause (some)
WB_SYNC_NONE writes to be skipped.

So instead of setting the flags, change:
 - .readahead to stop when it has submitted all non-async pages
    for read.
 - .writepages to do nothing if WB_SYNC_NONE and the flag would be set
 - .writepage to return AOP_WRITEPAGE_ACTIVATE if WB_SYNC_NONE
    and the flag would be set.

The writepages change causes a behavioural change in that pageout() can
now return PAGE_ACTIVATE instead of PAGE_KEEP, so SetPageActive() will be
called on the page which (I think) will further delay the next attempt at
writeout.  This might be a good thing.

Link: https://lkml.kernel.org/r/164549983737.9187.2627117501000365074.stgit@noble.brown
Signed-off-by: NeilBrown <neilb@suse.de>
Cc: Anna Schumaker <Anna.Schumaker@Netapp.com>
Cc: Chao Yu <chao@kernel.org>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Paolo Valente <paolo.valente@linaro.org>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/control.c |   17 -----------------
 fs/fuse/dev.c     |    8 --------
 fs/fuse/file.c    |   17 +++++++++++++++++
 3 files changed, 17 insertions(+), 25 deletions(-)

--- a/fs/fuse/control.c~fuse-remove-reliance-on-bdi-congestion
+++ a/fs/fuse/control.c
@@ -164,7 +164,6 @@ static ssize_t fuse_conn_congestion_thre
 {
 	unsigned val;
 	struct fuse_conn *fc;
-	struct fuse_mount *fm;
 	ssize_t ret;
 
 	ret = fuse_conn_limit_write(file, buf, count, ppos, &val,
@@ -178,22 +177,6 @@ static ssize_t fuse_conn_congestion_thre
 	down_read(&fc->killsb);
 	spin_lock(&fc->bg_lock);
 	fc->congestion_threshold = val;
-
-	/*
-	 * Get any fuse_mount belonging to this fuse_conn; s_bdi is
-	 * shared between all of them
-	 */
-
-	if (!list_empty(&fc->mounts)) {
-		fm = list_first_entry(&fc->mounts, struct fuse_mount, fc_entry);
-		if (fc->num_background < fc->congestion_threshold) {
-			clear_bdi_congested(fm->sb->s_bdi, BLK_RW_SYNC);
-			clear_bdi_congested(fm->sb->s_bdi, BLK_RW_ASYNC);
-		} else {
-			set_bdi_congested(fm->sb->s_bdi, BLK_RW_SYNC);
-			set_bdi_congested(fm->sb->s_bdi, BLK_RW_ASYNC);
-		}
-	}
 	spin_unlock(&fc->bg_lock);
 	up_read(&fc->killsb);
 	fuse_conn_put(fc);
--- a/fs/fuse/dev.c~fuse-remove-reliance-on-bdi-congestion
+++ a/fs/fuse/dev.c
@@ -315,10 +315,6 @@ void fuse_request_end(struct fuse_req *r
 				wake_up(&fc->blocked_waitq);
 		}
 
-		if (fc->num_background == fc->congestion_threshold && fm->sb) {
-			clear_bdi_congested(fm->sb->s_bdi, BLK_RW_SYNC);
-			clear_bdi_congested(fm->sb->s_bdi, BLK_RW_ASYNC);
-		}
 		fc->num_background--;
 		fc->active_background--;
 		flush_bg_queue(fc);
@@ -540,10 +536,6 @@ static bool fuse_request_queue_backgroun
 		fc->num_background++;
 		if (fc->num_background == fc->max_background)
 			fc->blocked = 1;
-		if (fc->num_background == fc->congestion_threshold && fm->sb) {
-			set_bdi_congested(fm->sb->s_bdi, BLK_RW_SYNC);
-			set_bdi_congested(fm->sb->s_bdi, BLK_RW_ASYNC);
-		}
 		list_add_tail(&req->list, &fc->bg_queue);
 		flush_bg_queue(fc);
 		queued = true;
--- a/fs/fuse/file.c~fuse-remove-reliance-on-bdi-congestion
+++ a/fs/fuse/file.c
@@ -966,6 +966,14 @@ static void fuse_readahead(struct readah
 		struct fuse_io_args *ia;
 		struct fuse_args_pages *ap;
 
+		if (fc->num_background >= fc->congestion_threshold &&
+		    rac->ra->async_size >= readahead_count(rac))
+			/*
+			 * Congested and only async pages left, so skip the
+			 * rest.
+			 */
+			break;
+
 		nr_pages = readahead_count(rac) - nr_pages;
 		if (nr_pages > max_pages)
 			nr_pages = max_pages;
@@ -1959,6 +1967,7 @@ err:
 
 static int fuse_writepage(struct page *page, struct writeback_control *wbc)
 {
+	struct fuse_conn *fc = get_fuse_conn(page->mapping->host);
 	int err;
 
 	if (fuse_page_is_writeback(page->mapping->host, page->index)) {
@@ -1974,6 +1983,10 @@ static int fuse_writepage(struct page *p
 		return 0;
 	}
 
+	if (wbc->sync_mode == WB_SYNC_NONE &&
+	    fc->num_background >= fc->congestion_threshold)
+		return AOP_WRITEPAGE_ACTIVATE;
+
 	err = fuse_writepage_locked(page);
 	unlock_page(page);
 
@@ -2227,6 +2240,10 @@ static int fuse_writepages(struct addres
 	if (fuse_is_bad(inode))
 		goto out;
 
+	if (wbc->sync_mode == WB_SYNC_NONE &&
+	    fc->num_background >= fc->congestion_threshold)
+		return 0;
+
 	data.inode = inode;
 	data.wpa = NULL;
 	data.ff = NULL;
_

Patches currently in -mm which might be from neilb@suse.de are

mm-discard-__gfp_atomic.patch

