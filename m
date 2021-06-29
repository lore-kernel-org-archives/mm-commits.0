Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6143EC11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:35:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43FF561D06
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:35:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbhF2CiZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:38:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:59064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230152AbhF2CiY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:38:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C5A661A2B;
        Tue, 29 Jun 2021 02:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934157;
        bh=xWIGGqg8F8ns1VbxhDx8TRDYO6NyXyseoa2NlUzXkLs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=c16i+e7zPKo92lx4rNO6vZ6c6d5Qdjt1Go/4B15KHKaGwgsuL04PI3Tb8Ba5LCAII
         kk+LwQjzzihrP2G8SautLq2T+I5dHmBrOan1cMp3rXG513ih4X8RIdTmFy8JpDNW3q
         Saflz5KQf4yqCq0bkoStvf8nQgL2jsyDppc9rX08=
Date:   Mon, 28 Jun 2021 19:35:56 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, axboe@kernel.dk, dchinner@redhat.com,
        dennis@kernel.org, guro@fb.com, jack@suse.com, jack@suse.cz,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, tj@kernel.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
Subject:  [patch 051/192] writeback, cgroup: split out the
 functional part of inode_switch_wbs_work_fn()
Message-ID: <20210629023556.iiZ9-H3xs%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
