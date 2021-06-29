Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15A28C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:35:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F34C061A2B
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:35:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbhF2CiP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:38:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230152AbhF2CiP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:38:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F65B61D08;
        Tue, 29 Jun 2021 02:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934148;
        bh=Y+kimKWGbdaSKt1YmYNtngz+F4lQyxwcVxcW0boYOb8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=CuNcSFYrvl0/31JIyKCfgJ06N6WGr3NlCfBZOlis4RBWtdLT0/xszpgZ8a5rkJFwv
         LAqNNU2ca3pVKCvl90USVvDq/DNTJKJMOf0mQ2Lzhd+dP5UWFUNHDiq3fL7A1dx9YB
         zaZlJoY0apkKDi+K2IyjXEGWpg4t7UnMj53cE/Qs=
Date:   Mon, 28 Jun 2021 19:35:47 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, axboe@kernel.dk, dchinner@redhat.com,
        dennis@kernel.org, guro@fb.com, jack@suse.com, jack@suse.cz,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, tj@kernel.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
Subject:  [patch 048/192] writeback, cgroup: increment
 isw_nr_in_flight before grabbing an inode
Message-ID: <20210629023547.aNYIt_Rdh%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Roman Gushchin <guro@fb.com>
Subject: writeback, cgroup: increment isw_nr_in_flight before grabbing an inode

isw_nr_in_flight is used to determine whether the inode switch queue
should be flushed from the umount path.  Currently it's increased after
grabbing an inode and even scheduling the switch work.  It means the
umount path can walk past cleanup_offline_cgwb() with active inode
references, which can result in a "Busy inodes after unmount." message and
use-after-free issues (with inode->i_sb which gets freed).

Fix it by incrementing isw_nr_in_flight before doing anything with the
inode and decrementing in the case when switching wasn't scheduled.

The problem hasn't yet been seen in the real life and was discovered by
Jan Kara by looking into the code.

Link: https://lkml.kernel.org/r/20210608230225.2078447-4-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Suggested-by: Jan Kara <jack@suse.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/fs-writeback.c~writeback-cgroup-increment-isw_nr_in_flight-before-grabbing-an-inode
+++ a/fs/fs-writeback.c
@@ -505,6 +505,8 @@ static void inode_switch_wbs(struct inod
 	if (!isw)
 		return;
 
+	atomic_inc(&isw_nr_in_flight);
+
 	/* find and pin the new wb */
 	rcu_read_lock();
 	memcg_css = css_from_id(new_wb_id, &memory_cgrp_subsys);
@@ -535,11 +537,10 @@ static void inode_switch_wbs(struct inod
 	 * Let's continue after I_WB_SWITCH is guaranteed to be visible.
 	 */
 	call_rcu(&isw->rcu_head, inode_switch_wbs_rcu_fn);
-
-	atomic_inc(&isw_nr_in_flight);
 	return;
 
 out_free:
+	atomic_dec(&isw_nr_in_flight);
 	if (isw->new_wb)
 		wb_put(isw->new_wb);
 	kfree(isw);
_
