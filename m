Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FDB0C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jan 2022 22:42:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbiA0Wmv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Jan 2022 17:42:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241930AbiA0Wmu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jan 2022 17:42:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8805C061714
        for <mm-commits@vger.kernel.org>; Thu, 27 Jan 2022 14:42:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58AFA61BBE
        for <mm-commits@vger.kernel.org>; Thu, 27 Jan 2022 22:42:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ABB2C340E6;
        Thu, 27 Jan 2022 22:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643323369;
        bh=a8DOMAIrMk3bmjgviA9FQYiZsTuAxDu/iyWKmegW0Ko=;
        h=Date:From:To:Subject:From;
        b=L39+MyqMr4Mm25X4meatf4CrVOOuIuI5I93n2Do2TG9uMSEcp1jtudAUcNXvc/KkS
         V+xzOwjwqWrrgdJxM8s21dsn17swMVFo68o2/00Uf0sv/O8Zs0l8Tj8A4555YiEfu5
         sNrfPmwT0kNJJMhkPHz9ZWH/8q3UtnnuuQiKI5E4=
Date:   Thu, 27 Jan 2022 14:42:48 -0800
From:   akpm@linux-foundation.org
To:     Anna.Schumaker@Netapp.com, axboe@kernel.dk, chao@kernel.org,
        david@fromorbit.com, djwong@kernel.org, hch@lst.de,
        idryomov@gmail.com, jaegeuk@kernel.org, jlayton@kernel.org,
        konishi.ryusuke@gmail.com, lars.ellenberg@linbit.com,
        miklos@szeredi.hu, mm-commits@vger.kernel.org, neilb@suse.de,
        paolo.valente@linaro.org, philipp.reisner@linbit.com,
        trond.myklebust@hammerspace.com
Subject:  +
 f2fs-change-retry-waiting-for-f2fs_write_single_data_page.patch added to
 -mm tree
Message-ID: <20220127224248.0Anqg_vJE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: f2fs: change retry waiting for f2fs_write_single_data_page()
has been added to the -mm tree.  Its filename is
     f2fs-change-retry-waiting-for-f2fs_write_single_data_page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/f2fs-change-retry-waiting-for-f2fs_write_single_data_page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/f2fs-change-retry-waiting-for-f2fs_write_single_data_page.patch

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
Subject: f2fs: change retry waiting for f2fs_write_single_data_page()

f2fs_write_single_data_page() can return -EAGAIN if it cannot get the
cp_rwsem lock - it holds a page lock and so cannot wait for it.

Some code which calls f2fs_write_single_data_page() use congestion_wait()
and then tries again.  congestion_wait() doesn't do anything useful as
congestion is no longer tracked.  So this is just a simple sleep.

A better approach is it wait until the cp_rwsem lock can be taken - then
try again.  There is certainly no point trying again *before* the lock can
be taken.

Link: https://lkml.kernel.org/r/164325158956.29787.7016948342209980097.stgit@noble.brown
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

 fs/f2fs/compress.c |    6 +++---
 fs/f2fs/data.c     |    9 ++++++---
 2 files changed, 9 insertions(+), 6 deletions(-)

--- a/fs/f2fs/compress.c~f2fs-change-retry-waiting-for-f2fs_write_single_data_page
+++ a/fs/f2fs/compress.c
@@ -1505,9 +1505,9 @@ continue_unlock:
 				if (IS_NOQUOTA(cc->inode))
 					return 0;
 				ret = 0;
-				cond_resched();
-				congestion_wait(BLK_RW_ASYNC,
-						DEFAULT_IO_TIMEOUT);
+				/* Wait until we can get the lock, then try again. */
+				f2fs_lock_op(F2FS_I_SB(cc->inode));
+				f2fs_unlock_op(F2FS_I_SB(cc->inode));
 				goto retry_write;
 			}
 			return ret;
--- a/fs/f2fs/data.c~f2fs-change-retry-waiting-for-f2fs_write_single_data_page
+++ a/fs/f2fs/data.c
@@ -3047,9 +3047,12 @@ result:
 				} else if (ret == -EAGAIN) {
 					ret = 0;
 					if (wbc->sync_mode == WB_SYNC_ALL) {
-						cond_resched();
-						congestion_wait(BLK_RW_ASYNC,
-							DEFAULT_IO_TIMEOUT);
+						/* Wait until we can get the
+						 * lock, then try again.
+						 */
+						f2fs_lock_op(F2FS_I_SB(mapping->host));
+						f2fs_unlock_op(F2FS_I_SB(mapping->host));
+
 						goto retry_write;
 					}
 					goto next;
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

