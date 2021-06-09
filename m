Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 329B7C47082
	for <mm-commits@archiver.kernel.org>; Wed,  9 Jun 2021 00:13:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D7656139A
	for <mm-commits@archiver.kernel.org>; Wed,  9 Jun 2021 00:13:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232402AbhFIAPO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Jun 2021 20:15:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:43634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232160AbhFIAPN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 8 Jun 2021 20:15:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F03C561361;
        Wed,  9 Jun 2021 00:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623197590;
        bh=dAIXZjkrZmGMIhz4vD1oaFw3+h2M5hQBtUkXjyAys/8=;
        h=Date:From:To:Subject:From;
        b=1Gxs3j1IzP3JDZNXdBZ1va9Mn1d2RgGh3T//wHKn1xBDq6McUBbwTG7ehxcN9yG+/
         RH2irfO61EW1S9AIpmHAoORrPPxge+VI0Gh3nIQTpVMNIskQY8fCSh6ejY71GKb6Qb
         f74/lhKrEmbUBczAaaB/woCQjw6QEqUO4WyGs4XI=
Date:   Tue, 08 Jun 2021 17:13:09 -0700
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, dchinner@redhat.com, dennis@kernel.org,
        guro@fb.com, jack@suse.com, jack@suse.cz,
        mm-commits@vger.kernel.org, tj@kernel.org, viro@zeniv.linux.org.uk
Subject:  +
 writeback-cgroup-keep-list-of-inodes-attached-to-bdi_writeback.patch added
 to -mm tree
Message-ID: <20210609001309.eMCmjE6Tg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: writeback, cgroup: keep list of inodes attached to bdi_writeback
has been added to the -mm tree.  Its filename is
     writeback-cgroup-keep-list-of-inodes-attached-to-bdi_writeback.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/writeback-cgroup-keep-list-of-inodes-attached-to-bdi_writeback.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/writeback-cgroup-keep-list-of-inodes-attached-to-bdi_writeback.patch

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
Subject: writeback, cgroup: keep list of inodes attached to bdi_writeback

Currently there is no way to iterate over inodes attached to a specific
cgwb structure.  It limits the ability to efficiently reclaim the
writeback structure itself and associated memory and block cgroup
structures without scanning all inodes belonging to a sb, which can be
prohibitively expensive.

While dirty/in-active-writeback an inode belongs to one of the
bdi_writeback's io lists: b_dirty, b_io, b_more_io and b_dirty_time.  Once
cleaned up, it's removed from all io lists.  So the inode->i_io_list can
be reused to maintain the list of inodes, attached to a bdi_writeback
structure.

This patch introduces a new wb->b_attached list, which contains all inodes
which were dirty at least once and are attached to the given cgwb.  Inodes
attached to the root bdi_writeback structures are never placed on such
list.  The following patch will use this list to try to release cgwbs
structures more efficiently.

Link: https://lkml.kernel.org/r/20210608230225.2078447-6-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Suggested-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Dennis Zhou <dennis@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Jan Kara <jack@suse.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c                |   93 ++++++++++++++++++-----------
 include/linux/backing-dev-defs.h |    1 
 mm/backing-dev.c                 |    2 
 3 files changed, 62 insertions(+), 34 deletions(-)

--- a/fs/fs-writeback.c~writeback-cgroup-keep-list-of-inodes-attached-to-bdi_writeback
+++ a/fs/fs-writeback.c
@@ -131,25 +131,6 @@ static bool inode_io_list_move_locked(st
 	return false;
 }
 
-/**
- * inode_io_list_del_locked - remove an inode from its bdi_writeback IO list
- * @inode: inode to be removed
- * @wb: bdi_writeback @inode is being removed from
- *
- * Remove @inode which may be on one of @wb->b_{dirty|io|more_io} lists and
- * clear %WB_has_dirty_io if all are empty afterwards.
- */
-static void inode_io_list_del_locked(struct inode *inode,
-				     struct bdi_writeback *wb)
-{
-	assert_spin_locked(&wb->list_lock);
-	assert_spin_locked(&inode->i_lock);
-
-	inode->i_state &= ~I_SYNC_QUEUED;
-	list_del_init(&inode->i_io_list);
-	wb_io_lists_depopulated(wb);
-}
-
 static void wb_wakeup(struct bdi_writeback *wb)
 {
 	spin_lock_bh(&wb->work_lock);
@@ -279,6 +260,28 @@ void __inode_attach_wb(struct inode *ino
 EXPORT_SYMBOL_GPL(__inode_attach_wb);
 
 /**
+ * inode_cgwb_move_to_attached - put the inode onto wb->b_attached list
+ * @inode: inode of interest with i_lock held
+ * @wb: target bdi_writeback
+ *
+ * Remove the inode from wb's io lists and if necessarily put onto b_attached
+ * list.  Only inodes attached to cgwb's are kept on this list.
+ */
+static void inode_cgwb_move_to_attached(struct inode *inode,
+					struct bdi_writeback *wb)
+{
+	assert_spin_locked(&wb->list_lock);
+	assert_spin_locked(&inode->i_lock);
+
+	inode->i_state &= ~I_SYNC_QUEUED;
+	if (wb != &wb->bdi->wb)
+		list_move(&inode->i_io_list, &wb->b_attached);
+	else
+		list_del_init(&inode->i_io_list);
+	wb_io_lists_depopulated(wb);
+}
+
+/**
  * locked_inode_to_wb_and_lock_list - determine a locked inode's wb and lock it
  * @inode: inode of interest with i_lock held
  *
@@ -418,21 +421,28 @@ static void inode_switch_wbs_work_fn(str
 	wb_get(new_wb);
 
 	/*
-	 * Transfer to @new_wb's IO list if necessary.  The specific list
-	 * @inode was on is ignored and the inode is put on ->b_dirty which
-	 * is always correct including from ->b_dirty_time.  The transfer
-	 * preserves @inode->dirtied_when ordering.
+	 * Transfer to @new_wb's IO list if necessary.  If the @inode is dirty,
+	 * the specific list @inode was on is ignored and the @inode is put on
+	 * ->b_dirty which is always correct including from ->b_dirty_time.
+	 * The transfer preserves @inode->dirtied_when ordering.  If the @inode
+	 * was clean, it means it was on the b_attached list, so move it onto
+	 * the b_attached list of @new_wb.
 	 */
 	if (!list_empty(&inode->i_io_list)) {
-		struct inode *pos;
-
-		inode_io_list_del_locked(inode, old_wb);
 		inode->i_wb = new_wb;
-		list_for_each_entry(pos, &new_wb->b_dirty, i_io_list)
-			if (time_after_eq(inode->dirtied_when,
-					  pos->dirtied_when))
-				break;
-		inode_io_list_move_locked(inode, new_wb, pos->i_io_list.prev);
+
+		if (inode->i_state & I_DIRTY_ALL) {
+			struct inode *pos;
+
+			list_for_each_entry(pos, &new_wb->b_dirty, i_io_list)
+				if (time_after_eq(inode->dirtied_when,
+						  pos->dirtied_when))
+					break;
+			inode_io_list_move_locked(inode, new_wb,
+						  pos->i_io_list.prev);
+		} else {
+			inode_cgwb_move_to_attached(inode, new_wb);
+		}
 	} else {
 		inode->i_wb = new_wb;
 	}
@@ -1021,6 +1031,17 @@ fs_initcall(cgroup_writeback_init);
 static void bdi_down_write_wb_switch_rwsem(struct backing_dev_info *bdi) { }
 static void bdi_up_write_wb_switch_rwsem(struct backing_dev_info *bdi) { }
 
+static void inode_cgwb_move_to_attached(struct inode *inode,
+					struct bdi_writeback *wb)
+{
+	assert_spin_locked(&wb->list_lock);
+	assert_spin_locked(&inode->i_lock);
+
+	inode->i_state &= ~I_SYNC_QUEUED;
+	list_del_init(&inode->i_io_list);
+	wb_io_lists_depopulated(wb);
+}
+
 static struct bdi_writeback *
 locked_inode_to_wb_and_lock_list(struct inode *inode)
 	__releases(&inode->i_lock)
@@ -1121,7 +1142,11 @@ void inode_io_list_del(struct inode *ino
 
 	wb = inode_to_wb_and_lock_list(inode);
 	spin_lock(&inode->i_lock);
-	inode_io_list_del_locked(inode, wb);
+
+	inode->i_state &= ~I_SYNC_QUEUED;
+	list_del_init(&inode->i_io_list);
+	wb_io_lists_depopulated(wb);
+
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&wb->list_lock);
 }
@@ -1434,7 +1459,7 @@ static void requeue_inode(struct inode *
 		inode->i_state &= ~I_SYNC_QUEUED;
 	} else {
 		/* The inode is clean. Remove from writeback lists. */
-		inode_io_list_del_locked(inode, wb);
+		inode_cgwb_move_to_attached(inode, wb);
 	}
 }
 
@@ -1586,7 +1611,7 @@ static int writeback_single_inode(struct
 	 * responsible for the writeback lists.
 	 */
 	if (!(inode->i_state & I_DIRTY_ALL))
-		inode_io_list_del_locked(inode, wb);
+		inode_cgwb_move_to_attached(inode, wb);
 	spin_unlock(&wb->list_lock);
 	inode_sync_complete(inode);
 out:
--- a/include/linux/backing-dev-defs.h~writeback-cgroup-keep-list-of-inodes-attached-to-bdi_writeback
+++ a/include/linux/backing-dev-defs.h
@@ -154,6 +154,7 @@ struct bdi_writeback {
 	struct cgroup_subsys_state *blkcg_css; /* and blkcg */
 	struct list_head memcg_node;	/* anchored at memcg->cgwb_list */
 	struct list_head blkcg_node;	/* anchored at blkcg->cgwb_list */
+	struct list_head b_attached;	/* attached inodes, protected by list_lock */
 
 	union {
 		struct work_struct release_work;
--- a/mm/backing-dev.c~writeback-cgroup-keep-list-of-inodes-attached-to-bdi_writeback
+++ a/mm/backing-dev.c
@@ -396,6 +396,7 @@ static void cgwb_release_workfn(struct w
 	fprop_local_destroy_percpu(&wb->memcg_completions);
 	percpu_ref_exit(&wb->refcnt);
 	wb_exit(wb);
+	WARN_ON_ONCE(!list_empty(&wb->b_attached));
 	kfree_rcu(wb, rcu);
 }
 
@@ -472,6 +473,7 @@ static int cgwb_create(struct backing_de
 
 	wb->memcg_css = memcg_css;
 	wb->blkcg_css = blkcg_css;
+	INIT_LIST_HEAD(&wb->b_attached);
 	INIT_WORK(&wb->release_work, cgwb_release_workfn);
 	set_bit(WB_registered, &wb->state);
 
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

