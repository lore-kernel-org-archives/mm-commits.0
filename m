Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06826C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:30:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357314AbiCYBbw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:31:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357325AbiCYBbb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:31:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96EB52E6AE
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:29:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4FC04B82726
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:29:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1359CC340EC;
        Fri, 25 Mar 2022 01:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171792;
        bh=RQcIiujiawS7Q9T3Uf2eCceW/5vvUudsjx1q3UimtX8=;
        h=Date:To:From:Subject:From;
        b=dq5XdA9IKP+DVf444zN6sR1cw8S4hoHcPH1jPwOdNF4GBC+g7TAD0SFfNNadcoQl/
         NaRpthyakacT9ZK8RD5EvjH173B97mPTSG0Nk3sdfKoRC8YkAD9ytHZNodcNYjSVWP
         vGwdpV7Y5wg2yMpk92eLmh21ECfSD6pX+dQ6JIB0=
Date:   Thu, 24 Mar 2022 18:29:51 -0700
To:     mm-commits@vger.kernel.org, trond.myklebust@hammerspace.com,
        philipp.reisner@linbit.com, paolo.valente@linaro.org,
        miklos@szeredi.hu, lars.ellenberg@linbit.com,
        konishi.ryusuke@gmail.com, jlayton@kernel.org, jaegeuk@kernel.org,
        jack@suse.cz, idryomov@gmail.com, fengguang.wu@intel.com,
        djwong@kernel.org, chao@kernel.org, axboe@kernel.dk,
        Anna.Schumaker@Netapp.com, neilb@suse.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] f2fs-replace-congestion_wait-calls-with-io_schedule_timeout.patch removed from -mm tree
Message-Id: <20220325012952.1359CC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: f2fs: replace congestion_wait() calls with io_schedule_timeout()
has been removed from the -mm tree.  Its filename was
     f2fs-replace-congestion_wait-calls-with-io_schedule_timeout.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: NeilBrown <neilb@suse.de>
Subject: f2fs: replace congestion_wait() calls with io_schedule_timeout()

As congestion is no longer tracked, congestion_wait() is effectively
equivalent to io_schedule_timeout().  So introduce
f2fs_io_schedule_timeout() which sets TASK_UNINTERRUPTIBLE and call that
instead.

Link: https://lkml.kernel.org/r/164549983744.9187.6425865370954230902.stgit@noble.brown
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

 fs/f2fs/compress.c |    4 +---
 fs/f2fs/data.c     |    3 +--
 fs/f2fs/f2fs.h     |    6 ++++++
 fs/f2fs/segment.c  |    8 +++-----
 fs/f2fs/super.c    |    6 ++----
 5 files changed, 13 insertions(+), 14 deletions(-)

--- a/fs/f2fs/compress.c~f2fs-replace-congestion_wait-calls-with-io_schedule_timeout
+++ a/fs/f2fs/compress.c
@@ -1505,9 +1505,7 @@ continue_unlock:
 				if (IS_NOQUOTA(cc->inode))
 					return 0;
 				ret = 0;
-				cond_resched();
-				congestion_wait(BLK_RW_ASYNC,
-						DEFAULT_IO_TIMEOUT);
+				f2fs_io_schedule_timeout(DEFAULT_IO_TIMEOUT);
 				goto retry_write;
 			}
 			return ret;
--- a/fs/f2fs/data.c~f2fs-replace-congestion_wait-calls-with-io_schedule_timeout
+++ a/fs/f2fs/data.c
@@ -3047,8 +3047,7 @@ result:
 				} else if (ret == -EAGAIN) {
 					ret = 0;
 					if (wbc->sync_mode == WB_SYNC_ALL) {
-						cond_resched();
-						congestion_wait(BLK_RW_ASYNC,
+						f2fs_io_schedule_timeout(
 							DEFAULT_IO_TIMEOUT);
 						goto retry_write;
 					}
--- a/fs/f2fs/f2fs.h~f2fs-replace-congestion_wait-calls-with-io_schedule_timeout
+++ a/fs/f2fs/f2fs.h
@@ -4426,6 +4426,12 @@ static inline bool f2fs_block_unit_disca
 	return F2FS_OPTION(sbi).discard_unit == DISCARD_UNIT_BLOCK;
 }
 
+static inline void f2fs_io_schedule_timeout(long timeout)
+{
+	set_current_state(TASK_UNINTERRUPTIBLE);
+	io_schedule_timeout(timeout);
+}
+
 #define EFSBADCRC	EBADMSG		/* Bad CRC detected */
 #define EFSCORRUPTED	EUCLEAN		/* Filesystem is corrupted */
 
--- a/fs/f2fs/segment.c~f2fs-replace-congestion_wait-calls-with-io_schedule_timeout
+++ a/fs/f2fs/segment.c
@@ -313,8 +313,7 @@ next:
 skip:
 		iput(inode);
 	}
-	congestion_wait(BLK_RW_ASYNC, DEFAULT_IO_TIMEOUT);
-	cond_resched();
+	f2fs_io_schedule_timeout(DEFAULT_IO_TIMEOUT);
 	if (gc_failure) {
 		if (++looped >= count)
 			return;
@@ -803,8 +802,7 @@ int f2fs_flush_device_cache(struct f2fs_
 		do {
 			ret = __submit_flush_wait(sbi, FDEV(i).bdev);
 			if (ret)
-				congestion_wait(BLK_RW_ASYNC,
-						DEFAULT_IO_TIMEOUT);
+				f2fs_io_schedule_timeout(DEFAULT_IO_TIMEOUT);
 		} while (ret && --count);
 
 		if (ret) {
@@ -3133,7 +3131,7 @@ next:
 			blk_finish_plug(&plug);
 			mutex_unlock(&dcc->cmd_lock);
 			trimmed += __wait_all_discard_cmd(sbi, NULL);
-			congestion_wait(BLK_RW_ASYNC, DEFAULT_IO_TIMEOUT);
+			f2fs_io_schedule_timeout(DEFAULT_IO_TIMEOUT);
 			goto next;
 		}
 skip:
--- a/fs/f2fs/super.c~f2fs-replace-congestion_wait-calls-with-io_schedule_timeout
+++ a/fs/f2fs/super.c
@@ -2135,8 +2135,7 @@ static void f2fs_enable_checkpoint(struc
 	/* we should flush all the data to keep data consistency */
 	do {
 		sync_inodes_sb(sbi->sb);
-		cond_resched();
-		congestion_wait(BLK_RW_ASYNC, DEFAULT_IO_TIMEOUT);
+		f2fs_io_schedule_timeout(DEFAULT_IO_TIMEOUT);
 	} while (get_pages(sbi, F2FS_DIRTY_DATA) && retry--);
 
 	if (unlikely(retry < 0))
@@ -2504,8 +2503,7 @@ retry:
 							&page, &fsdata);
 		if (unlikely(err)) {
 			if (err == -ENOMEM) {
-				congestion_wait(BLK_RW_ASYNC,
-						DEFAULT_IO_TIMEOUT);
+				f2fs_io_schedule_timeout(DEFAULT_IO_TIMEOUT);
 				goto retry;
 			}
 			set_sbi_flag(F2FS_SB(sb), SBI_QUOTA_NEED_REPAIR);
_

Patches currently in -mm which might be from neilb@suse.de are

mm-discard-__gfp_atomic.patch

