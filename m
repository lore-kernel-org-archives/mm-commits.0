Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A2C6C07E9B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:09:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 730F76117A
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:09:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231792AbhGFTMf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:12:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:47190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231737AbhGFTMf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:12:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9208E60FEE;
        Tue,  6 Jul 2021 19:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598596;
        bh=hs0yr/VoqzFc69lk2IbADugMeFrKMQoocBwmtzKktSM=;
        h=Date:From:To:Subject:From;
        b=ZRRZcJp5Tjz1a/Drw0uZpPIlc4VRn9rcf1o/iZW30Xs4Xlx/0uZP71fEZBLwte7Vm
         l/BTZijWMTvqIY15rs4GNBt9BAfDJO96SrVBM+6h3xiHY4B1M8esuVcgZXTFcjWSWE
         QIbd1nDw4aWrzmOuguvni1LxikdLv6Ac1abncoUI=
Date:   Tue, 06 Jul 2021 12:09:56 -0700
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, dchinner@redhat.com, dennis@kernel.org,
        guro@fb.com, jack@suse.com, jack@suse.cz,
        mm-commits@vger.kernel.org, tj@kernel.org, viro@zeniv.linux.org.uk
Subject:  [merged]
 writeback-cgroup-switch-to-rcu_work-api-in-inode_switch_wbs.patch removed
 from -mm tree
Message-ID: <20210706190956.3aJPqVrp_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: writeback, cgroup: switch to rcu_work API in inode_switch_wbs()
has been removed from the -mm tree.  Its filename was
     writeback-cgroup-switch-to-rcu_work-api-in-inode_switch_wbs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


