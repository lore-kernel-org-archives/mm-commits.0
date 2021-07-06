Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95C05C07E9B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:10:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FBA060C3D
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:10:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbhGFTMl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:12:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231784AbhGFTMl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:12:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9442A6117A;
        Tue,  6 Jul 2021 19:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598602;
        bh=lgWEymnZp4JHErPA+ZCv/4ToyYkPEP3trSxkjrp7ooc=;
        h=Date:From:To:Subject:From;
        b=psZiCsBUs4u7+Z7+nDezdFcwmvdJ9n3c4fTP35IvojQgDKUDIssWuIpXOwQ+UGJry
         T22u7zJ5865C4llImso4g6dK7CFsTdiIkoYwchr/dcveTe89VJBgHENOBkIdyuAuzy
         NCNhYxdwZYX+tsMCQ+IwXujAjiiMIxTR8Ht+prTU=
Date:   Tue, 06 Jul 2021 12:10:02 -0700
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, dchinner@redhat.com, dennis@kernel.org,
        guro@fb.com, jack@suse.com, jack@suse.cz,
        mm-commits@vger.kernel.org, tj@kernel.org, viro@zeniv.linux.org.uk
Subject:  [merged]
 =?US-ASCII?Q?writeback-cgroup-split-out-the-functional-part-of-inode=5F?=
 =?US-ASCII?Q?switch=5Fwbs=5Fwork=5Ffn.patch?= removed from -mm tree
Message-ID: <20210706191002.0tPfwiUnM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: writeback, cgroup: split out the functional part of inode_switch_wbs_work_fn()
has been removed from the -mm tree.  Its filename was
     writeback-cgroup-split-out-the-functional-part-of-inode_switch_wbs_work_fn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


