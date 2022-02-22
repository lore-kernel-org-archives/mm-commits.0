Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CB1AC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 04:03:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbiBVEDs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Feb 2022 23:03:48 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:37326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbiBVEDl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Feb 2022 23:03:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B5925C36F
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 20:03:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C624615A6
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 04:03:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF8A4C340E8;
        Tue, 22 Feb 2022 04:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645502588;
        bh=1PSNmOlaYRNRrDLfXUzuhMs/5kA+AeGDTEtHmGoCvro=;
        h=Date:To:From:Subject:From;
        b=Y4K76ofQtcJ/MBTOaJ/RQFq+Nud0T9cZUDLP3st/2O2Y2MzKgQbEghO0ak3rFXhuC
         rMpYvCCWdGIQnj++hqOqfWs1aXWda5b3EMi0VSgXWY1z2sNPxwRgNlTUscs6cbNjup
         i5Heo9X+Y+D98UhWJa52Nfy0cMA7z65J50z//gHY=
Date:   Mon, 21 Feb 2022 20:03:07 -0800
To:     mm-commits@vger.kernel.org, trond.myklebust@hammerspace.com,
        philipp.reisner@linbit.com, paolo.valente@linaro.org,
        miklos@szeredi.hu, lars.ellenberg@linbit.com,
        konishi.ryusuke@gmail.com, jlayton@kernel.org, jaegeuk@kernel.org,
        jack@suse.cz, idryomov@gmail.com, fengguang.wu@intel.com,
        djwong@kernel.org, chao@kernel.org, axboe@kernel.dk,
        Anna.Schumaker@Netapp.com, neilb@suse.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + remove-congestion-tracking-framework.patch added to -mm tree
Message-Id: <20220222040307.EF8A4C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: remove congestion tracking framework
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
Subject: remove congestion tracking framework

This framework is no longer used - so discard it.

Link: https://lkml.kernel.org/r/164549983747.9187.6171768583526866601.stgit@noble.brown
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

