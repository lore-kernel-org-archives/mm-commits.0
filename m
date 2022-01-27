Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7F59C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jan 2022 22:43:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242219AbiA0WnK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Jan 2022 17:43:10 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50928 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242272AbiA0WnJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jan 2022 17:43:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5969461BFE
        for <mm-commits@vger.kernel.org>; Thu, 27 Jan 2022 22:43:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 354B0C340E4;
        Thu, 27 Jan 2022 22:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643323388;
        bh=Fm7+VBQKanJ9O1HZGJpkXfQ+kScZJfVa+XCwqVZyhP8=;
        h=Date:From:To:Subject:From;
        b=XF5v8k3N/Sq6jUSnfwB5icphNh1tT2D6HgQemeUjwTSR3qCXSOQG2UrS4lllMMmR0
         P6ng5mDBwPWwsU0dSSvv9v5Lds8IMzVkNiVhN6ONfrzDURnB+ZcwZnKuHb+PlwJxjc
         k2k3gBZsofkHmFX/5RStQItCPxNn/W+ePSkSDLZI=
Date:   Thu, 27 Jan 2022 14:43:07 -0800
From:   akpm@linux-foundation.org
To:     Anna.Schumaker@Netapp.com, axboe@kernel.dk, chao@kernel.org,
        david@fromorbit.com, djwong@kernel.org, hch@lst.de,
        idryomov@gmail.com, jaegeuk@kernel.org, jlayton@kernel.org,
        konishi.ryusuke@gmail.com, lars.ellenberg@linbit.com,
        miklos@szeredi.hu, mm-commits@vger.kernel.org, neilb@suse.de,
        paolo.valente@linaro.org, philipp.reisner@linbit.com,
        trond.myklebust@hammerspace.com
Subject:  + remove-congestion-tracking-framework.patch added to -mm
 tree
Message-ID: <20220127224307.sez01tyt4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove congestion tracking framework
has been added to the -mm tree.  Its filename is
     remove-congestion-tracking-framework.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/remove-congestion-tracking-framework.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/remove-congestion-tracking-framework.patch

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
Subject: mm: remove congestion tracking framework

This framework is no longer used - so discard it.

Link: https://lkml.kernel.org/r/164325158960.29787.17588717894058708630.stgit@noble.brown
Signed-off-by: NeilBrown <neilb@suse.de>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Chao Yu <chao@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Anna Schumaker <Anna.Schumaker@Netapp.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Paolo Valente <paolo.valente@linaro.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/backing-dev-defs.h |    8 ----
 include/linux/backing-dev.h      |    2 -
 include/trace/events/writeback.h |   28 --------------
 mm/backing-dev.c                 |   57 -----------------------------
 4 files changed, 95 deletions(-)

--- a/include/linux/backing-dev-defs.h~remove-congestion-tracking-framework
+++ a/include/linux/backing-dev-defs.h
@@ -207,14 +207,6 @@ struct backing_dev_info {
 #endif
 };
 
-enum {
-	BLK_RW_ASYNC	= 0,
-	BLK_RW_SYNC	= 1,
-};
-
-void clear_bdi_congested(struct backing_dev_info *bdi, int sync);
-void set_bdi_congested(struct backing_dev_info *bdi, int sync);
-
 struct wb_lock_cookie {
 	bool locked;
 	unsigned long flags;
--- a/include/linux/backing-dev.h~remove-congestion-tracking-framework
+++ a/include/linux/backing-dev.h
@@ -135,8 +135,6 @@ static inline bool writeback_in_progress
 
 struct backing_dev_info *inode_to_bdi(struct inode *inode);
 
-long congestion_wait(int sync, long timeout);
-
 static inline bool mapping_can_writeback(struct address_space *mapping)
 {
 	return inode_to_bdi(mapping->host)->capabilities & BDI_CAP_WRITEBACK;
--- a/include/trace/events/writeback.h~remove-congestion-tracking-framework
+++ a/include/trace/events/writeback.h
@@ -735,34 +735,6 @@ TRACE_EVENT(writeback_sb_inodes_requeue,
 	)
 );
 
-DECLARE_EVENT_CLASS(writeback_congest_waited_template,
-
-	TP_PROTO(unsigned int usec_timeout, unsigned int usec_delayed),
-
-	TP_ARGS(usec_timeout, usec_delayed),
-
-	TP_STRUCT__entry(
-		__field(	unsigned int,	usec_timeout	)
-		__field(	unsigned int,	usec_delayed	)
-	),
-
-	TP_fast_assign(
-		__entry->usec_timeout	= usec_timeout;
-		__entry->usec_delayed	= usec_delayed;
-	),
-
-	TP_printk("usec_timeout=%u usec_delayed=%u",
-			__entry->usec_timeout,
-			__entry->usec_delayed)
-);
-
-DEFINE_EVENT(writeback_congest_waited_template, writeback_congestion_wait,
-
-	TP_PROTO(unsigned int usec_timeout, unsigned int usec_delayed),
-
-	TP_ARGS(usec_timeout, usec_delayed)
-);
-
 DECLARE_EVENT_CLASS(writeback_single_inode_template,
 
 	TP_PROTO(struct inode *inode,
--- a/mm/backing-dev.c~remove-congestion-tracking-framework
+++ a/mm/backing-dev.c
@@ -1005,60 +1005,3 @@ const char *bdi_dev_name(struct backing_
 	return bdi->dev_name;
 }
 EXPORT_SYMBOL_GPL(bdi_dev_name);
-
-static wait_queue_head_t congestion_wqh[2] = {
-		__WAIT_QUEUE_HEAD_INITIALIZER(congestion_wqh[0]),
-		__WAIT_QUEUE_HEAD_INITIALIZER(congestion_wqh[1])
-	};
-static atomic_t nr_wb_congested[2];
-
-void clear_bdi_congested(struct backing_dev_info *bdi, int sync)
-{
-	wait_queue_head_t *wqh = &congestion_wqh[sync];
-	enum wb_congested_state bit;
-
-	bit = sync ? WB_sync_congested : WB_async_congested;
-	if (test_and_clear_bit(bit, &bdi->wb.congested))
-		atomic_dec(&nr_wb_congested[sync]);
-	smp_mb__after_atomic();
-	if (waitqueue_active(wqh))
-		wake_up(wqh);
-}
-EXPORT_SYMBOL(clear_bdi_congested);
-
-void set_bdi_congested(struct backing_dev_info *bdi, int sync)
-{
-	enum wb_congested_state bit;
-
-	bit = sync ? WB_sync_congested : WB_async_congested;
-	if (!test_and_set_bit(bit, &bdi->wb.congested))
-		atomic_inc(&nr_wb_congested[sync]);
-}
-EXPORT_SYMBOL(set_bdi_congested);
-
-/**
- * congestion_wait - wait for a backing_dev to become uncongested
- * @sync: SYNC or ASYNC IO
- * @timeout: timeout in jiffies
- *
- * Waits for up to @timeout jiffies for a backing_dev (any backing_dev) to exit
- * write congestion.  If no backing_devs are congested then just wait for the
- * next write to be completed.
- */
-long congestion_wait(int sync, long timeout)
-{
-	long ret;
-	unsigned long start = jiffies;
-	DEFINE_WAIT(wait);
-	wait_queue_head_t *wqh = &congestion_wqh[sync];
-
-	prepare_to_wait(wqh, &wait, TASK_UNINTERRUPTIBLE);
-	ret = io_schedule_timeout(timeout);
-	finish_wait(wqh, &wait);
-
-	trace_writeback_congestion_wait(jiffies_to_usecs(timeout),
-					jiffies_to_usecs(jiffies - start));
-
-	return ret;
-}
-EXPORT_SYMBOL(congestion_wait);
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

