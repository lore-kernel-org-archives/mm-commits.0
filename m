Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB192C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 04:03:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbiBVEDs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Feb 2022 23:03:48 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:37150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbiBVEDh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Feb 2022 23:03:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0308F5C344
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 20:03:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C866B81857
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 04:03:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B840C340E8;
        Tue, 22 Feb 2022 04:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645502583;
        bh=xrIdFvbIPAFl2BWNhZxV6vZKiPm9MO9mb+RjJ9zIflg=;
        h=Date:To:From:Subject:From;
        b=Llvnx0hfkQ2XXpLlQJqOHl/Vt/d63FIXatGgqVWG2G80dMhtVY0HriRnvQ6zpcBo8
         d3av2ahIP1mz+sfYKWaPzJF54mor8JMjt69Kqo03H34ixUJVwn3qjASWS/BWjgmX60
         QneW28mI6cqjkomo4HYNuB2F2re+3u5RlXxb/fOI=
Date:   Mon, 21 Feb 2022 20:03:02 -0800
To:     mm-commits@vger.kernel.org, trond.myklebust@hammerspace.com,
        philipp.reisner@linbit.com, paolo.valente@linaro.org,
        miklos@szeredi.hu, lars.ellenberg@linbit.com,
        konishi.ryusuke@gmail.com, jlayton@kernel.org, jaegeuk@kernel.org,
        jack@suse.cz, idryomov@gmail.com, fengguang.wu@intel.com,
        djwong@kernel.org, chao@kernel.org, axboe@kernel.dk,
        Anna.Schumaker@Netapp.com, neilb@suse.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + f2fs-replace-congestion_wait-calls-with-io_schedule_timeout.patch added to -mm tree
Message-Id: <20220222040303.0B840C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: f2fs: replace congestion_wait() calls with io_schedule_timeout()
has been added to the -mm tree.  Its filename is
     f2fs-replace-congestion_wait-calls-with-io_schedule_timeout.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/f2fs-replace-congestion_wait-calls-with-io_schedule_timeout.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/f2fs-replace-congestion_wait-calls-with-io_schedule_timeout.patch

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

doc-convert-subsection-to-section-in-gfph.patch
mm-document-and-polish-read-ahead-code.patch
mm-improve-cleanup-when-readpages-doesnt-process-all-pages.patch
fuse-remove-reliance-on-bdi-congestion.patch
nfs-remove-reliance-on-bdi-congestion.patch
ceph-remove-reliance-on-bdi-congestion.patch
remove-inode_congested.patch
remove-bdi_congested-and-wb_congested-and-related-functions.patch
f2fs-replace-congestion_wait-calls-with-io_schedule_timeout.patch
block-bfq-ioschedc-use-false-rather-than-blk_rw_async.patch
remove-congestion-tracking-framework.patch
mm-discard-__gfp_atomic.patch

