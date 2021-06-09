Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3952C47082
	for <mm-commits@archiver.kernel.org>; Wed,  9 Jun 2021 00:13:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA2476139A
	for <mm-commits@archiver.kernel.org>; Wed,  9 Jun 2021 00:13:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231848AbhFIAPD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Jun 2021 20:15:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:43566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231803AbhFIAPD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 8 Jun 2021 20:15:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDF44610F8;
        Wed,  9 Jun 2021 00:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623197586;
        bh=8OU8OiYI5FqSD51LQHoSMZ/B2POpU/HXuQXLKp9x6js=;
        h=Date:From:To:Subject:From;
        b=zESfIz9By/4Kg2pvmLlL+1fn0vnzGJ8kdyRzjuDDsB9oL9qpSJbJe6TQtjqdrdbMx
         SgjmAuFT67wDLCWaLVSLYBk6Tsadk4mUDIA3F1zobn2nmWDz0R6X7sc2c8de6nKtxY
         ITVpfGCk/hqv2z83jsRcJfcAz7Iu1hxSJCn13RRo=
Date:   Tue, 08 Jun 2021 17:13:05 -0700
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, dchinner@redhat.com, dennis@kernel.org,
        guro@fb.com, jack@suse.com, jack@suse.cz,
        mm-commits@vger.kernel.org, tj@kernel.org, viro@zeniv.linux.org.uk
Subject:  +
 writeback-cgroup-increment-isw_nr_in_flight-before-grabbing-an-inode.patch
 added to -mm tree
Message-ID: <20210609001305.D_736JkSc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: writeback, cgroup: increment isw_nr_in_flight before grabbing an inode
has been added to the -mm tree.  Its filename is
     writeback-cgroup-increment-isw_nr_in_flight-before-grabbing-an-inode.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/writeback-cgroup-increment-isw_nr_in_flight-before-grabbing-an-inode.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/writeback-cgroup-increment-isw_nr_in_flight-before-grabbing-an-inode.patch

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

Patches currently in -mm which might be from guro@fb.com are

writeback-cgroup-do-not-switch-inodes-with-i_will_free-flag.patch
writeback-cgroup-add-smp_mb-to-cgroup_writeback_umount.patch
writeback-cgroup-increment-isw_nr_in_flight-before-grabbing-an-inode.patch
writeback-cgroup-switch-to-rcu_work-api-in-inode_switch_wbs.patch
writeback-cgroup-keep-list-of-inodes-attached-to-bdi_writeback.patch
writeback-cgroup-split-out-the-functional-part-of-inode_switch_wbs_work_fn.patch
writeback-cgroup-support-switching-multiple-inodes-at-once.patch
writeback-cgroup-release-dying-cgwbs-by-switching-attached-inodes.patch

