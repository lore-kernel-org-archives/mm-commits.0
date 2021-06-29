Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77547C11F67
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:35:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64ED861A2B
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:35:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbhF2CiJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:38:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:58766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231332AbhF2CiI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:38:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56F2661D04;
        Tue, 29 Jun 2021 02:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934141;
        bh=unKalR+Zt15uPhXVAHy6w6tD6YklfdZhuL0E1nSW5fQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=RIkIy1JCliyGJieypwiqPnhWDm/s9vdAYRQu26SirB9lSEy90orh6bNf35XoY/agN
         iEFT0Joi1t8KZnqFEYIC4rFeDu6Eyq+9Et5ZeO9sQMr1FKpKBLuDck9gHPkachS8p+
         ccUwEq4gbYnLHZbHtFeDSXvYnp47wzm+evtANT8E=
Date:   Mon, 28 Jun 2021 19:35:41 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, axboe@kernel.dk, dchinner@redhat.com,
        dennis@kernel.org, guro@fb.com, jack@suse.com, jack@suse.cz,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, tj@kernel.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
Subject:  [patch 046/192] writeback, cgroup: do not switch inodes
 with I_WILL_FREE flag
Message-ID: <20210629023541.IAUudyuWD%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Roman Gushchin <guro@fb.com>
Subject: writeback, cgroup: do not switch inodes with I_WILL_FREE flag

Patch series "cgroup, blkcg: prevent dirty inodes to pin dying memory cgroups", v9.

When an inode is getting dirty for the first time it's associated with a
wb structure (see __inode_attach_wb()).  It can later be switched to
another wb (if e.g.  some other cgroup is writing a lot of data to the
same inode), but otherwise stays attached to the original wb until being
reclaimed.

The problem is that the wb structure holds a reference to the original
memory and blkcg cgroups.  So if an inode has been dirty once and later is
actively used in read-only mode, it has a good chance to pin down the
original memory and blkcg cgroups forever.  This is often the case with
services bringing data for other services, e.g.  updating some rpm
packages.

In the real life it becomes a problem due to a large size of the memcg
structure, which can easily be 1000x larger than an inode.  Also a really
large number of dying cgroups can raise different scalability issues, e.g.
making the memory reclaim costly and less effective.

To solve the problem inodes should be eventually detached from the
corresponding writeback structure.  It's inefficient to do it after every
writeback completion.  Instead it can be done whenever the original memory
cgroup is offlined and writeback structure is getting killed.  Scanning
over a (potentially long) list of inodes and detach them from the
writeback structure can take quite some time.  To avoid scanning all
inodes, attached inodes are kept on a new list (b_attached).  To make it
less noticeable to a user, the scanning and switching is performed from a
work context.

Big thanks to Jan Kara, Dennis Zhou, Hillf Danton and Tejun Heo for their
ideas and contribution to this patchset.


This patch (of 8):

If an inode's state has I_WILL_FREE flag set, the inode will be freed
soon, so there is no point in trying to switch the inode to a different
cgwb.

I_WILL_FREE was ignored since the introduction of the inode switching, so
it looks like it doesn't lead to any noticeable issues for a user.  This
is why the patch is not intended for a stable backport.

Link: https://lkml.kernel.org/r/20210608230225.2078447-1-guro@fb.com
Link: https://lkml.kernel.org/r/20210608230225.2078447-2-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Suggested-by: Jan Kara <jack@suse.cz>
Acked-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Dennis Zhou <dennis@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Jan Kara <jack@suse.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/fs-writeback.c~writeback-cgroup-do-not-switch-inodes-with-i_will_free-flag
+++ a/fs/fs-writeback.c
@@ -389,10 +389,10 @@ static void inode_switch_wbs_work_fn(str
 	xa_lock_irq(&mapping->i_pages);
 
 	/*
-	 * Once I_FREEING is visible under i_lock, the eviction path owns
-	 * the inode and we shouldn't modify ->i_io_list.
+	 * Once I_FREEING or I_WILL_FREE are visible under i_lock, the eviction
+	 * path owns the inode and we shouldn't modify ->i_io_list.
 	 */
-	if (unlikely(inode->i_state & I_FREEING))
+	if (unlikely(inode->i_state & (I_FREEING | I_WILL_FREE)))
 		goto skip_switch;
 
 	trace_inode_switch_wbs(inode, old_wb, new_wb);
@@ -517,7 +517,7 @@ static void inode_switch_wbs(struct inod
 	/* while holding I_WB_SWITCH, no one else can update the association */
 	spin_lock(&inode->i_lock);
 	if (!(inode->i_sb->s_flags & SB_ACTIVE) ||
-	    inode->i_state & (I_WB_SWITCH | I_FREEING) ||
+	    inode->i_state & (I_WB_SWITCH | I_FREEING | I_WILL_FREE) ||
 	    inode_to_wb(inode) == isw->new_wb) {
 		spin_unlock(&inode->i_lock);
 		goto out_free;
_
