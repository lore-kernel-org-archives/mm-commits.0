Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78839C11F66
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:36:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FB2061A2B
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:36:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231750AbhF2Ci2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:38:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:59116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231847AbhF2Ci1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:38:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D11161D06;
        Tue, 29 Jun 2021 02:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934160;
        bh=XjojDIoV2fEnI6SdKXAhIrGwsMifawnqrloqXU5sTXI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=wE7VN6gKXXd9JLJwvlsXr4BN/gjxE5EtfJDgpZocJb1CNTU3bp+f47FaJRfxSlpoU
         zXbMqLJBSKdWqWMn3H56Cl9O3epKkwrbuqz79VZaMbPUApFlAmDljVM+spTr0vMhyB
         WMfFP1PN4D1cfnYU8pF+RAkwa2ULtOq2nwP2eGSY=
Date:   Mon, 28 Jun 2021 19:35:59 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, axboe@kernel.dk, dchinner@redhat.com,
        dennis@kernel.org, guro@fb.com, jack@suse.com, jack@suse.cz,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, tj@kernel.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
Subject:  [patch 052/192] writeback, cgroup: support switching
 multiple inodes at once
Message-ID: <20210629023559.AUtAARde5%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Roman Gushchin <guro@fb.com>
Subject: writeback, cgroup: support switching multiple inodes at once

Currently only a single inode can be switched to another writeback
structure at once.  That means to switch an inode a separate
inode_switch_wbs_context structure must be allocated, and a separate rcu
callback and work must be scheduled.

It's fine for the existing ad-hoc switching, which is not happening that
often, but sub-optimal for massive switching required in order to release
a writeback structure.  To prepare for it, let's add a support for
switching multiple inodes at once.

Instead of containing a single inode pointer, inode_switch_wbs_context
will contain a NULL-terminated array of inode pointers. 
inode_do_switch_wbs() will be called for each inode.

To optimize the locking bdi->wb_switch_rwsem, old_wb's and new_wb's
list_locks will be acquired and released only once altogether for all
inodes.  wb_wakeup() will be also be called only once.  Instead of calling
wb_put(old_wb) after each successful switch, wb_put_many() is introduced
and used.

Link: https://lkml.kernel.org/r/20210608230225.2078447-8-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Dennis Zhou <dennis@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Jan Kara <jack@suse.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c                |  106 +++++++++++++++++------------
 include/linux/backing-dev-defs.h |   18 ++++
 2 files changed, 80 insertions(+), 44 deletions(-)

--- a/fs/fs-writeback.c~writeback-cgroup-support-switching-multiple-inodes-at-once
+++ a/fs/fs-writeback.c
@@ -335,10 +335,18 @@ static struct bdi_writeback *inode_to_wb
 }
 
 struct inode_switch_wbs_context {
-	struct inode		*inode;
-	struct bdi_writeback	*new_wb;
-
 	struct rcu_work		work;
+
+	/*
+	 * Multiple inodes can be switched at once.  The switching procedure
+	 * consists of two parts, separated by a RCU grace period.  To make
+	 * sure that the second part is executed for each inode gone through
+	 * the first part, all inode pointers are placed into a NULL-terminated
+	 * array embedded into struct inode_switch_wbs_context.  Otherwise
+	 * an inode could be left in a non-consistent state.
+	 */
+	struct bdi_writeback	*new_wb;
+	struct inode		*inodes[];
 };
 
 static void bdi_down_write_wb_switch_rwsem(struct backing_dev_info *bdi)
@@ -351,39 +359,15 @@ static void bdi_up_write_wb_switch_rwsem
 	up_write(&bdi->wb_switch_rwsem);
 }
 
-static void inode_do_switch_wbs(struct inode *inode,
+static bool inode_do_switch_wbs(struct inode *inode,
+				struct bdi_writeback *old_wb,
 				struct bdi_writeback *new_wb)
 {
-	struct backing_dev_info *bdi = inode_to_bdi(inode);
 	struct address_space *mapping = inode->i_mapping;
-	struct bdi_writeback *old_wb = inode->i_wb;
 	XA_STATE(xas, &mapping->i_pages, 0);
 	struct page *page;
 	bool switched = false;
 
-	/*
-	 * If @inode switches cgwb membership while sync_inodes_sb() is
-	 * being issued, sync_inodes_sb() might miss it.  Synchronize.
-	 */
-	down_read(&bdi->wb_switch_rwsem);
-
-	/*
-	 * By the time control reaches here, RCU grace period has passed
-	 * since I_WB_SWITCH assertion and all wb stat update transactions
-	 * between unlocked_inode_to_wb_begin/end() are guaranteed to be
-	 * synchronizing against the i_pages lock.
-	 *
-	 * Grabbing old_wb->list_lock, inode->i_lock and the i_pages lock
-	 * gives us exclusion against all wb related operations on @inode
-	 * including IO list manipulations and stat updates.
-	 */
-	if (old_wb < new_wb) {
-		spin_lock(&old_wb->list_lock);
-		spin_lock_nested(&new_wb->list_lock, SINGLE_DEPTH_NESTING);
-	} else {
-		spin_lock(&new_wb->list_lock);
-		spin_lock_nested(&old_wb->list_lock, SINGLE_DEPTH_NESTING);
-	}
 	spin_lock(&inode->i_lock);
 	xa_lock_irq(&mapping->i_pages);
 
@@ -458,25 +442,63 @@ skip_switch:
 
 	xa_unlock_irq(&mapping->i_pages);
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&new_wb->list_lock);
-	spin_unlock(&old_wb->list_lock);
-
-	up_read(&bdi->wb_switch_rwsem);
 
-	if (switched) {
-		wb_wakeup(new_wb);
-		wb_put(old_wb);
-	}
+	return switched;
 }
 
 static void inode_switch_wbs_work_fn(struct work_struct *work)
 {
 	struct inode_switch_wbs_context *isw =
 		container_of(to_rcu_work(work), struct inode_switch_wbs_context, work);
+	struct backing_dev_info *bdi = inode_to_bdi(isw->inodes[0]);
+	struct bdi_writeback *old_wb = isw->inodes[0]->i_wb;
+	struct bdi_writeback *new_wb = isw->new_wb;
+	unsigned long nr_switched = 0;
+	struct inode **inodep;
+
+	/*
+	 * If @inode switches cgwb membership while sync_inodes_sb() is
+	 * being issued, sync_inodes_sb() might miss it.  Synchronize.
+	 */
+	down_read(&bdi->wb_switch_rwsem);
+
+	/*
+	 * By the time control reaches here, RCU grace period has passed
+	 * since I_WB_SWITCH assertion and all wb stat update transactions
+	 * between unlocked_inode_to_wb_begin/end() are guaranteed to be
+	 * synchronizing against the i_pages lock.
+	 *
+	 * Grabbing old_wb->list_lock, inode->i_lock and the i_pages lock
+	 * gives us exclusion against all wb related operations on @inode
+	 * including IO list manipulations and stat updates.
+	 */
+	if (old_wb < new_wb) {
+		spin_lock(&old_wb->list_lock);
+		spin_lock_nested(&new_wb->list_lock, SINGLE_DEPTH_NESTING);
+	} else {
+		spin_lock(&new_wb->list_lock);
+		spin_lock_nested(&old_wb->list_lock, SINGLE_DEPTH_NESTING);
+	}
+
+	for (inodep = isw->inodes; *inodep; inodep++) {
+		WARN_ON_ONCE((*inodep)->i_wb != old_wb);
+		if (inode_do_switch_wbs(*inodep, old_wb, new_wb))
+			nr_switched++;
+	}
+
+	spin_unlock(&new_wb->list_lock);
+	spin_unlock(&old_wb->list_lock);
+
+	up_read(&bdi->wb_switch_rwsem);
+
+	if (nr_switched) {
+		wb_wakeup(new_wb);
+		wb_put_many(old_wb, nr_switched);
+	}
 
-	inode_do_switch_wbs(isw->inode, isw->new_wb);
-	wb_put(isw->new_wb);
-	iput(isw->inode);
+	for (inodep = isw->inodes; *inodep; inodep++)
+		iput(*inodep);
+	wb_put(new_wb);
 	kfree(isw);
 	atomic_dec(&isw_nr_in_flight);
 }
@@ -503,7 +525,7 @@ static void inode_switch_wbs(struct inod
 	if (atomic_read(&isw_nr_in_flight) > WB_FRN_MAX_IN_FLIGHT)
 		return;
 
-	isw = kzalloc(sizeof(*isw), GFP_ATOMIC);
+	isw = kzalloc(sizeof(*isw) + 2 * sizeof(struct inode *), GFP_ATOMIC);
 	if (!isw)
 		return;
 
@@ -530,7 +552,7 @@ static void inode_switch_wbs(struct inod
 	__iget(inode);
 	spin_unlock(&inode->i_lock);
 
-	isw->inode = inode;
+	isw->inodes[0] = inode;
 
 	/*
 	 * In addition to synchronizing among switchers, I_WB_SWITCH tells
--- a/include/linux/backing-dev-defs.h~writeback-cgroup-support-switching-multiple-inodes-at-once
+++ a/include/linux/backing-dev-defs.h
@@ -240,8 +240,9 @@ static inline void wb_get(struct bdi_wri
 /**
  * wb_put - decrement a wb's refcount
  * @wb: bdi_writeback to put
+ * @nr: number of references to put
  */
-static inline void wb_put(struct bdi_writeback *wb)
+static inline void wb_put_many(struct bdi_writeback *wb, unsigned long nr)
 {
 	if (WARN_ON_ONCE(!wb->bdi)) {
 		/*
@@ -252,7 +253,16 @@ static inline void wb_put(struct bdi_wri
 	}
 
 	if (wb != &wb->bdi->wb)
-		percpu_ref_put(&wb->refcnt);
+		percpu_ref_put_many(&wb->refcnt, nr);
+}
+
+/**
+ * wb_put - decrement a wb's refcount
+ * @wb: bdi_writeback to put
+ */
+static inline void wb_put(struct bdi_writeback *wb)
+{
+	wb_put_many(wb, 1);
 }
 
 /**
@@ -281,6 +291,10 @@ static inline void wb_put(struct bdi_wri
 {
 }
 
+static inline void wb_put_many(struct bdi_writeback *wb, unsigned long nr)
+{
+}
+
 static inline bool wb_dying(struct bdi_writeback *wb)
 {
 	return false;
_
