Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D725BC4743F
	for <mm-commits@archiver.kernel.org>; Wed,  9 Jun 2021 00:13:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBA2861375
	for <mm-commits@archiver.kernel.org>; Wed,  9 Jun 2021 00:13:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232410AbhFIAPQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Jun 2021 20:15:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:43608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232160AbhFIAPQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 8 Jun 2021 20:15:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E44256135D;
        Wed,  9 Jun 2021 00:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623197588;
        bh=Psrqb2pnGz7t3VvyjRn5OCpts4d5ozTvT//kSqfmbJU=;
        h=Date:From:To:Subject:From;
        b=qhbCk3Urzwhx1JIqzml9+YGsKYF+wljm3tRROivDGdTWrrmoD/jZR3HdQtpAM1CHo
         nPzJb+HyGSKRQAZz6pazoNxPjKgQuKg7Iw9HmhdBZk75T795KPbNzynp7on4FGGsUI
         n3JvhdAtwNGXK3LF0pTfd5ceEDLnFlUqT/xNTpjc=
Date:   Tue, 08 Jun 2021 17:13:07 -0700
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, dchinner@redhat.com, dennis@kernel.org,
        guro@fb.com, jack@suse.com, jack@suse.cz,
        mm-commits@vger.kernel.org, tj@kernel.org, viro@zeniv.linux.org.uk
Subject:  +
 writeback-cgroup-switch-to-rcu_work-api-in-inode_switch_wbs.patch added to
 -mm tree
Message-ID: <20210609001307.sMxnZFK4G%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: writeback, cgroup: switch to rcu_work API in inode_switch_wbs()
has been added to the -mm tree.  Its filename is
     writeback-cgroup-switch-to-rcu_work-api-in-inode_switch_wbs.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/writeback-cgroup-switch-to-rcu_work-api-in-inode_switch_wbs.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/writeback-cgroup-switch-to-rcu_work-api-in-inode_switch_wbs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: writeback, cgroup: switch to rcu_work API in inode_switch_wbs()

Inode's wb switching requires two steps divided by an RCU grace period. 
It's currently implemented as an RCU callback inode_switch_wbs_rcu_fn(),
which schedules inode_switch_wbs_work_fn() as a work.

Switching to the rcu_work API allows to do the same in a cleaner and
slightly shorter form.

Link: https://lkml.kernel.org/r/20210608230225.2078447-5-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Dennis Zhou <dennis@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Jan Kara <jack@suse.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

--- a/fs/fs-writeback.c~writeback-cgroup-switch-to-rcu_work-api-in-inode_switch_wbs
+++ a/fs/fs-writeback.c
@@ -335,8 +335,7 @@ struct inode_switch_wbs_context {
 	struct inode		*inode;
 	struct bdi_writeback	*new_wb;
 
-	struct rcu_head		rcu_head;
-	struct work_struct	work;
+	struct rcu_work		work;
 };
 
 static void bdi_down_write_wb_switch_rwsem(struct backing_dev_info *bdi)
@@ -352,7 +351,7 @@ static void bdi_up_write_wb_switch_rwsem
 static void inode_switch_wbs_work_fn(struct work_struct *work)
 {
 	struct inode_switch_wbs_context *isw =
-		container_of(work, struct inode_switch_wbs_context, work);
+		container_of(to_rcu_work(work), struct inode_switch_wbs_context, work);
 	struct inode *inode = isw->inode;
 	struct backing_dev_info *bdi = inode_to_bdi(inode);
 	struct address_space *mapping = inode->i_mapping;
@@ -469,16 +468,6 @@ skip_switch:
 	atomic_dec(&isw_nr_in_flight);
 }
 
-static void inode_switch_wbs_rcu_fn(struct rcu_head *rcu_head)
-{
-	struct inode_switch_wbs_context *isw = container_of(rcu_head,
-				struct inode_switch_wbs_context, rcu_head);
-
-	/* needs to grab bh-unsafe locks, bounce to work item */
-	INIT_WORK(&isw->work, inode_switch_wbs_work_fn);
-	queue_work(isw_wq, &isw->work);
-}
-
 /**
  * inode_switch_wbs - change the wb association of an inode
  * @inode: target inode
@@ -536,7 +525,8 @@ static void inode_switch_wbs(struct inod
 	 * lock so that stat transfer can synchronize against them.
 	 * Let's continue after I_WB_SWITCH is guaranteed to be visible.
 	 */
-	call_rcu(&isw->rcu_head, inode_switch_wbs_rcu_fn);
+	INIT_RCU_WORK(&isw->work, inode_switch_wbs_work_fn);
+	queue_rcu_work(isw_wq, &isw->work);
 	return;
 
 out_free:
_

Patches currently in -mm which might be from guro@fb.com are

writeback-cgroup-do-not-switch-inodes-with-i_will_free-flag.patch
writeback-cgroup-add-smp_mb-to-cgroup_writeback_umount.patch
writeback-cgroup-increment-isw_nr_in_flight-before-grabbing-an-inode.patch
writeback-cgroup-switch-to-rcu_work-api-in-inode_switch_wbs.patch
writeback-cgroup-keep-list-of-inodes-attached-to-bdi_writeback.patch
writeback-cgroup-split-out-the-functional-part-of-inode_switch_wbs_work_fn.patch
writeback-cgroup-support-switching-multiple-inodes-at-once.patch
writeback-cgroup-release-dying-cgwbs-by-switching-attached-inodes.patch

