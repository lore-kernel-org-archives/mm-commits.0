Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97099C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:30:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357344AbiCYBbu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357323AbiCYBb1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:31:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B557D2DD57
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:29:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 560CDB8272F
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:29:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAAD1C340EE;
        Fri, 25 Mar 2022 01:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171790;
        bh=9ZFZeTrVjAtF0S1GDFIKyvg7WAuVlMDKT9O7QfyOQLE=;
        h=Date:To:From:Subject:From;
        b=JgKThA313rwkj6Ayaiq5q1/5rGj2+fnK/8JFK+fJVgZjMy0H/Q33jMT1oxAux3l9l
         zxxlkaJilj1QZACWSSAo5YYDjnUXUlLYIC4v7QlkfyqZ8p5/e8IyFoTolVZPe4wyfd
         gOwEFfzrKB/NJywUraBYW9Hcu8tGdMFi6mZzS1SA=
Date:   Thu, 24 Mar 2022 18:29:50 -0700
To:     mm-commits@vger.kernel.org, trond.myklebust@hammerspace.com,
        philipp.reisner@linbit.com, paolo.valente@linaro.org,
        miklos@szeredi.hu, lars.ellenberg@linbit.com,
        konishi.ryusuke@gmail.com, jlayton@kernel.org, jaegeuk@kernel.org,
        jack@suse.cz, idryomov@gmail.com, fengguang.wu@intel.com,
        djwong@kernel.org, chao@kernel.org, axboe@kernel.dk,
        Anna.Schumaker@Netapp.com, neilb@suse.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] remove-bdi_congested-and-wb_congested-and-related-functions.patch removed from -mm tree
Message-Id: <20220325012950.DAAD1C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: remove bdi_congested() and wb_congested() and related functions
has been removed from the -mm tree.  Its filename was
     remove-bdi_congested-and-wb_congested-and-related-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: NeilBrown <neilb@suse.de>
Subject: remove bdi_congested() and wb_congested() and related functions

These functions are no longer useful as no BDIs report congestions any
more.

Removing the test on bdi_write_contested() in current_may_throttle() could
cause a small change in behaviour, but only when PF_LOCAL_THROTTLE is set.

So replace the calls by 'false' and simplify the code - and remove the
functions.

[akpm@linux-foundation.org: fix build]
Link: https://lkml.kernel.org/r/164549983742.9187.2570198746005819592.stgit@noble.brown
Signed-off-by: NeilBrown <neilb@suse.de>
Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>	[nilfs]
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
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/drbd/drbd_int.h |    3 ---
 drivers/block/drbd/drbd_req.c |    3 +--
 fs/ext2/ialloc.c              |    5 -----
 fs/nilfs2/segbuf.c            |   16 ----------------
 fs/xfs/xfs_buf.c              |    3 ---
 include/linux/backing-dev.h   |   26 --------------------------
 mm/vmscan.c                   |    4 +---
 7 files changed, 2 insertions(+), 58 deletions(-)

--- a/drivers/block/drbd/drbd_int.h~remove-bdi_congested-and-wb_congested-and-related-functions
+++ a/drivers/block/drbd/drbd_int.h
@@ -638,9 +638,6 @@ enum {
 	STATE_SENT,		/* Do not change state/UUIDs while this is set */
 	CALLBACK_PENDING,	/* Whether we have a call_usermodehelper(, UMH_WAIT_PROC)
 				 * pending, from drbd worker context.
-				 * If set, bdi_write_congested() returns true,
-				 * so shrink_page_list() would not recurse into,
-				 * and potentially deadlock on, this drbd worker.
 				 */
 	DISCONNECT_SENT,
 
--- a/drivers/block/drbd/drbd_req.c~remove-bdi_congested-and-wb_congested-and-related-functions
+++ a/drivers/block/drbd/drbd_req.c
@@ -909,8 +909,7 @@ static bool remote_due_to_read_balancing
 
 	switch (rbm) {
 	case RB_CONGESTED_REMOTE:
-		return bdi_read_congested(
-			device->ldev->backing_bdev->bd_disk->bdi);
+		return 0;
 	case RB_LEAST_PENDING:
 		return atomic_read(&device->local_cnt) >
 			atomic_read(&device->ap_pending_cnt) + atomic_read(&device->rs_pending_cnt);
--- a/fs/ext2/ialloc.c~remove-bdi_congested-and-wb_congested-and-related-functions
+++ a/fs/ext2/ialloc.c
@@ -170,11 +170,6 @@ static void ext2_preread_inode(struct in
 	unsigned long offset;
 	unsigned long block;
 	struct ext2_group_desc * gdp;
-	struct backing_dev_info *bdi;
-
-	bdi = inode_to_bdi(inode);
-	if (bdi_rw_congested(bdi))
-		return;
 
 	block_group = (inode->i_ino - 1) / EXT2_INODES_PER_GROUP(inode->i_sb);
 	gdp = ext2_get_group_desc(inode->i_sb, block_group, NULL);
--- a/fs/nilfs2/segbuf.c~remove-bdi_congested-and-wb_congested-and-related-functions
+++ a/fs/nilfs2/segbuf.c
@@ -341,18 +341,6 @@ static int nilfs_segbuf_submit_bio(struc
 				   int mode_flags)
 {
 	struct bio *bio = wi->bio;
-	int err;
-
-	if (segbuf->sb_nbio > 0 &&
-	    bdi_write_congested(segbuf->sb_super->s_bdi)) {
-		wait_for_completion(&segbuf->sb_bio_event);
-		segbuf->sb_nbio--;
-		if (unlikely(atomic_read(&segbuf->sb_err))) {
-			bio_put(bio);
-			err = -EIO;
-			goto failed;
-		}
-	}
 
 	bio->bi_end_io = nilfs_end_bio_write;
 	bio->bi_private = segbuf;
@@ -365,10 +353,6 @@ static int nilfs_segbuf_submit_bio(struc
 	wi->nr_vecs = min(wi->max_pages, wi->rest_blocks);
 	wi->start = wi->end;
 	return 0;
-
- failed:
-	wi->bio = NULL;
-	return err;
 }
 
 /**
--- a/fs/xfs/xfs_buf.c~remove-bdi_congested-and-wb_congested-and-related-functions
+++ a/fs/xfs/xfs_buf.c
@@ -843,9 +843,6 @@ xfs_buf_readahead_map(
 {
 	struct xfs_buf		*bp;
 
-	if (bdi_read_congested(target->bt_bdev->bd_disk->bdi))
-		return;
-
 	xfs_buf_read_map(target, map, nmaps,
 		     XBF_TRYLOCK | XBF_ASYNC | XBF_READ_AHEAD, &bp, ops,
 		     __this_address);
--- a/include/linux/backing-dev.h~remove-bdi_congested-and-wb_congested-and-related-functions
+++ a/include/linux/backing-dev.h
@@ -135,11 +135,6 @@ static inline bool writeback_in_progress
 
 struct backing_dev_info *inode_to_bdi(struct inode *inode);
 
-static inline int wb_congested(struct bdi_writeback *wb, int cong_bits)
-{
-	return wb->congested & cong_bits;
-}
-
 long congestion_wait(int sync, long timeout);
 
 static inline bool mapping_can_writeback(struct address_space *mapping)
@@ -391,27 +386,6 @@ static inline void wb_blkcg_offline(stru
 
 #endif	/* CONFIG_CGROUP_WRITEBACK */
 
-static inline int bdi_congested(struct backing_dev_info *bdi, int cong_bits)
-{
-	return wb_congested(&bdi->wb, cong_bits);
-}
-
-static inline int bdi_read_congested(struct backing_dev_info *bdi)
-{
-	return bdi_congested(bdi, 1 << WB_sync_congested);
-}
-
-static inline int bdi_write_congested(struct backing_dev_info *bdi)
-{
-	return bdi_congested(bdi, 1 << WB_async_congested);
-}
-
-static inline int bdi_rw_congested(struct backing_dev_info *bdi)
-{
-	return bdi_congested(bdi, (1 << WB_sync_congested) |
-				  (1 << WB_async_congested));
-}
-
 const char *bdi_dev_name(struct backing_dev_info *bdi);
 
 #endif	/* _LINUX_BACKING_DEV_H */
--- a/mm/vmscan.c~remove-bdi_congested-and-wb_congested-and-related-functions
+++ a/mm/vmscan.c
@@ -2364,9 +2364,7 @@ static unsigned int move_pages_to_lru(st
  */
 static int current_may_throttle(void)
 {
-	return !(current->flags & PF_LOCAL_THROTTLE) ||
-		current->backing_dev_info == NULL ||
-		bdi_write_congested(current->backing_dev_info);
+	return !(current->flags & PF_LOCAL_THROTTLE);
 }
 
 /*
_

Patches currently in -mm which might be from neilb@suse.de are

mm-discard-__gfp_atomic.patch

