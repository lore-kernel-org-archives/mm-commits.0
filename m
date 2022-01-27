Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED061C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jan 2022 22:43:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241930AbiA0WnC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Jan 2022 17:43:02 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34752 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238592AbiA0WnB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jan 2022 17:43:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E32E0B818E6
        for <mm-commits@vger.kernel.org>; Thu, 27 Jan 2022 22:42:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA3EC340E6;
        Thu, 27 Jan 2022 22:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643323378;
        bh=aAh0hURQB3tZN64RZ8E+7CMM+znm4dkYB2+ulRckJL8=;
        h=Date:From:To:Subject:From;
        b=2Qsd5mytNDMutw4RlamZGE00BAFfEkUTvpsbqes1s+cNo/d7HhpJvLpNRXOoYgANk
         8IEad4PnsSLKLppS1MHW5gDMAzOkQ1ywAaflWatkxbKNVFW3XXPE+0NezQf1w8m2fe
         9mS8NWnG8BaY/FyHbgMCwwRrWuVwdp70Og7P9RSk=
Date:   Thu, 27 Jan 2022 14:42:57 -0800
From:   akpm@linux-foundation.org
To:     Anna.Schumaker@Netapp.com, axboe@kernel.dk, chao@kernel.org,
        david@fromorbit.com, djwong@kernel.org, hch@lst.de,
        idryomov@gmail.com, jaegeuk@kernel.org, jlayton@kernel.org,
        konishi.ryusuke@gmail.com, lars.ellenberg@linbit.com,
        miklos@szeredi.hu, mm-commits@vger.kernel.org, neilb@suse.de,
        paolo.valente@linaro.org, philipp.reisner@linbit.com,
        trond.myklebust@hammerspace.com
Subject:  + fuse-dont-set-clear-bdi_congested.patch added to -mm
 tree
Message-ID: <20220127224257.b_yZFBJgH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fuse: don't set/clear bdi_congested
has been added to the -mm tree.  Its filename is
     fuse-dont-set-clear-bdi_congested.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fuse-dont-set-clear-bdi_congested.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fuse-dont-set-clear-bdi_congested.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: NeilBrown <neilb@suse.de>
Subject: fuse: don't set/clear bdi_congested

The bdo congestion framework is no longer used to manage writeout etc, so
drop updating it in fuse.

Link: https://lkml.kernel.org/r/164325158958.29787.9472805850412952920.stgit@noble.brown
Signed-off-by: NeilBrown <neilb@suse.de>
Cc: Anna Schumaker <Anna.Schumaker@Netapp.com>
Cc: Chao Yu <chao@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Paolo Valente <paolo.valente@linaro.org>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/control.c |   17 -----------------
 fs/fuse/dev.c     |    8 --------
 2 files changed, 25 deletions(-)

--- a/fs/fuse/control.c~fuse-dont-set-clear-bdi_congested
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
--- a/fs/fuse/dev.c~fuse-dont-set-clear-bdi_congested
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
_

Patches currently in -mm which might be from neilb@suse.de are

remove-inode_congested.patch
remove-bdi_congested-and-wb_congested-and-related-functions.patch
f2fs-change-retry-waiting-for-f2fs_write_single_data_page.patch
f2f2-replace-some-congestion_wait-calls-with-io_schedule_timeout.patch
cephfs-dont-set-clear-bdi_congestion.patch
fuse-dont-set-clear-bdi_congested.patch
nfs-remove-congestion-control.patch
block-bfq-ioschedc-use-false-rather-than-blk_rw_async.patch
remove-congestion-tracking-framework.patch
mm-discard-__gfp_atomic.patch

