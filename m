Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EE11C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jan 2022 22:42:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239064AbiA0Wm4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Jan 2022 17:42:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242272AbiA0Wmz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jan 2022 17:42:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB1DC061714
        for <mm-commits@vger.kernel.org>; Thu, 27 Jan 2022 14:42:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC711B823F6
        for <mm-commits@vger.kernel.org>; Thu, 27 Jan 2022 22:42:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2704DC340E4;
        Thu, 27 Jan 2022 22:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643323372;
        bh=EYZtgyvx9CT9tYUoh69j27Tfejc9Xz/LnvgC8YGpVXg=;
        h=Date:From:To:Subject:From;
        b=LfUtt9gp1o9y1Mk/uxD86mBtWbYIpSsJ+yztkQ6iAiLcE9hQCGb0RJEYBlYRB/zcR
         MputrZCypRLgTdlq7QOo/PXqkllvRMqgZaSZCUXhiK6YViQLKD+zqf6HMW4TWG1eiO
         ccX0O3CCj+1jrGbG1A4lwbptI1wKIN9UmySxsdoQ=
Date:   Thu, 27 Jan 2022 14:42:51 -0800
From:   akpm@linux-foundation.org
To:     Anna.Schumaker@Netapp.com, axboe@kernel.dk, chao@kernel.org,
        david@fromorbit.com, djwong@kernel.org, hch@lst.de,
        idryomov@gmail.com, jaegeuk@kernel.org, jlayton@kernel.org,
        konishi.ryusuke@gmail.com, lars.ellenberg@linbit.com,
        miklos@szeredi.hu, mm-commits@vger.kernel.org, neilb@suse.de,
        paolo.valente@linaro.org, philipp.reisner@linbit.com,
        trond.myklebust@hammerspace.com
Subject:  +
 f2f2-replace-some-congestion_wait-calls-with-io_schedule_timeout.patch
 added to -mm tree
Message-ID: <20220127224251.qQL9OC80U%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: f2f2: replace some congestion_wait() calls with io_schedule_timeout()
has been added to the -mm tree.  Its filename is
     f2f2-replace-some-congestion_wait-calls-with-io_schedule_timeout.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/f2f2-replace-some-congestion_wait-calls-with-io_schedule_timeout.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/f2f2-replace-some-congestion_wait-calls-with-io_schedule_timeout.patch

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
Subject: f2f2: replace some congestion_wait() calls with io_schedule_timeout()

As congestion is no longer tracked, contestion_wait() is effectively
equivalent to io_schedule_timeout().

It isn't clear to me what these contestion_wait() calls are waiting for,
so I cannot change them to wait for some particular event.  So simply
change them to io_schedule_timeout(), which will have exactly the same
behaviour.

Link: https://lkml.kernel.org/r/164325158957.29787.2116312603613564596.stgit@noble.brown
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

 fs/f2fs/segment.c |   14 ++++++++------
 fs/f2fs/super.c   |    8 ++++----
 2 files changed, 12 insertions(+), 10 deletions(-)

--- a/fs/f2fs/segment.c~f2f2-replace-some-congestion_wait-calls-with-io_schedule_timeout
+++ a/fs/f2fs/segment.c
@@ -313,8 +313,8 @@ next:
 skip:
 		iput(inode);
 	}
-	congestion_wait(BLK_RW_ASYNC, DEFAULT_IO_TIMEOUT);
-	cond_resched();
+	set_current_state(TASK_UNINTERRUPTIBLE);
+	io_schedule_timeout(DEFAULT_IO_TIMEOUT);
 	if (gc_failure) {
 		if (++looped >= count)
 			return;
@@ -802,9 +802,10 @@ int f2fs_flush_device_cache(struct f2fs_
 
 		do {
 			ret = __submit_flush_wait(sbi, FDEV(i).bdev);
-			if (ret)
-				congestion_wait(BLK_RW_ASYNC,
-						DEFAULT_IO_TIMEOUT);
+			if (ret) {
+				set_current_state(TASK_UNINTERRUPTIBLE);
+				io_schedule_timeout(DEFAULT_IO_TIMEOUT);
+			}
 		} while (ret && --count);
 
 		if (ret) {
@@ -3133,7 +3134,8 @@ next:
 			blk_finish_plug(&plug);
 			mutex_unlock(&dcc->cmd_lock);
 			trimmed += __wait_all_discard_cmd(sbi, NULL);
-			congestion_wait(BLK_RW_ASYNC, DEFAULT_IO_TIMEOUT);
+			set_current_state(TASK_UNINTERRUPTIBLE);
+			io_schedule_timeout(DEFAULT_IO_TIMEOUT);
 			goto next;
 		}
 skip:
--- a/fs/f2fs/super.c~f2f2-replace-some-congestion_wait-calls-with-io_schedule_timeout
+++ a/fs/f2fs/super.c
@@ -2135,8 +2135,8 @@ static void f2fs_enable_checkpoint(struc
 	/* we should flush all the data to keep data consistency */
 	do {
 		sync_inodes_sb(sbi->sb);
-		cond_resched();
-		congestion_wait(BLK_RW_ASYNC, DEFAULT_IO_TIMEOUT);
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		io_schedule_timeout(DEFAULT_IO_TIMEOUT);
 	} while (get_pages(sbi, F2FS_DIRTY_DATA) && retry--);
 
 	if (unlikely(retry < 0))
@@ -2504,8 +2504,8 @@ retry:
 							&page, &fsdata);
 		if (unlikely(err)) {
 			if (err == -ENOMEM) {
-				congestion_wait(BLK_RW_ASYNC,
-						DEFAULT_IO_TIMEOUT);
+				set_current_state(TASK_UNINTERRUPTIBLE);
+				io_schedule_timeout(DEFAULT_IO_TIMEOUT);
 				goto retry;
 			}
 			set_sbi_flag(F2FS_SB(sb), SBI_QUOTA_NEED_REPAIR);
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

