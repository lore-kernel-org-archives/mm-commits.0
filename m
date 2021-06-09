Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89D49C47082
	for <mm-commits@archiver.kernel.org>; Wed,  9 Jun 2021 00:13:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71D1261361
	for <mm-commits@archiver.kernel.org>; Wed,  9 Jun 2021 00:13:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232411AbhFIAPU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Jun 2021 20:15:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232160AbhFIAPU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 8 Jun 2021 20:15:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA0B9610F8;
        Wed,  9 Jun 2021 00:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623197593;
        bh=ZNoHd3rtod7s0B3bUMcSoCRxPB41jTrsPC2wB7MKdQ8=;
        h=Date:From:To:Subject:From;
        b=0B0hA+ohGsTHtBeLEQwm3z0hZxNOL1AXoxvONc4i+ToKCD64gv4ahB6HuTnUbF6FO
         7W6buebQ0kCA9TVSsxVuEIJcmUSDKTovywzWSsH+yBK3zvdmWf+iFoqO/tbrK8/aJp
         DDwDRc7pa6MNfZvoug7M49IF1UqEWdYxrFn7Y6+o=
Date:   Tue, 08 Jun 2021 17:13:12 -0700
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, dchinner@redhat.com, dennis@kernel.org,
        guro@fb.com, jack@suse.com, jack@suse.cz,
        mm-commits@vger.kernel.org, tj@kernel.org, viro@zeniv.linux.org.uk
Subject:  +
 =?US-ASCII?Q?writeback-cgroup-split-out-the-functional-part-of-inode=5F?=
 =?US-ASCII?Q?switch=5Fwbs=5Fwork=5Ffn.patch?= added to -mm tree
Message-ID: <20210609001312.afwMHckop%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: writeback, cgroup: split out the functional part of inode_switch_wbs_work_fn()
has been added to the -mm tree.  Its filename is
     writeback-cgroup-split-out-the-functional-part-of-inode_switch_wbs_work_fn.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/writeback-cgroup-split-out-the-functional-part-of-inode_switch_wbs_work_fn.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/writeback-cgroup-split-out-the-functional-part-of-inode_switch_wbs_work_fn.patch

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
Subject: writeback, cgroup: split out the functional part of inode_switch_wbs_work_fn()

Split out the functional part of the inode_switch_wbs_work_fn() function
as inode_do switch_wbs() to reuse it later for switching inodes attached
to dying cgwbs.

This commit doesn't bring any functional changes.

Link: https://lkml.kernel.org/r/20210608230225.2078447-7-guro@fb.com
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

 fs/fs-writeback.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- a/fs/fs-writeback.c~writeback-cgroup-split-out-the-functional-part-of-inode_switch_wbs_work_fn
+++ a/fs/fs-writeback.c
@@ -351,15 +351,12 @@ static void bdi_up_write_wb_switch_rwsem
 	up_write(&bdi->wb_switch_rwsem);
 }
 
-static void inode_switch_wbs_work_fn(struct work_struct *work)
+static void inode_do_switch_wbs(struct inode *inode,
+				struct bdi_writeback *new_wb)
 {
-	struct inode_switch_wbs_context *isw =
-		container_of(to_rcu_work(work), struct inode_switch_wbs_context, work);
-	struct inode *inode = isw->inode;
 	struct backing_dev_info *bdi = inode_to_bdi(inode);
 	struct address_space *mapping = inode->i_mapping;
 	struct bdi_writeback *old_wb = inode->i_wb;
-	struct bdi_writeback *new_wb = isw->new_wb;
 	XA_STATE(xas, &mapping->i_pages, 0);
 	struct page *page;
 	bool switched = false;
@@ -470,11 +467,17 @@ skip_switch:
 		wb_wakeup(new_wb);
 		wb_put(old_wb);
 	}
-	wb_put(new_wb);
+}
 
-	iput(inode);
-	kfree(isw);
+static void inode_switch_wbs_work_fn(struct work_struct *work)
+{
+	struct inode_switch_wbs_context *isw =
+		container_of(to_rcu_work(work), struct inode_switch_wbs_context, work);
 
+	inode_do_switch_wbs(isw->inode, isw->new_wb);
+	wb_put(isw->new_wb);
+	iput(isw->inode);
+	kfree(isw);
 	atomic_dec(&isw_nr_in_flight);
 }
 
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

