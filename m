Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34D36C11F66
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:36:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 224A761D08
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:36:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbhF2Cib (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:38:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:59214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231888AbhF2Cia (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:38:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60C4061A2B;
        Tue, 29 Jun 2021 02:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934163;
        bh=sUASIWFykdvM5hRPTtUjq/yc1BKL9jzQLLsIbZwjcu0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=WB1XOsLlam5ME3Ftmop2WQzZL2ZCK2ziQMIuHUGH10eaPe3qtw96pVQjhFgOTFqmy
         W8/HSjnB/BNgs88GQ5u7+6M/24Xz6m5DBEhPyFVWHn4W9D0wRz4YuqecTKwW6AZHMN
         rdjudXDBPMa8xD+fx58LZpRtQRpHZEf1fbj6l4/A=
Date:   Mon, 28 Jun 2021 19:36:03 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, axboe@kernel.dk, dchinner@redhat.com,
        dennis@kernel.org, guro@fb.com, jack@suse.com, jack@suse.cz,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, tj@kernel.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        willy@infradead.org
Subject:  [patch 053/192] writeback, cgroup: release dying cgwbs by
 switching attached inodes
Message-ID: <20210629023603.JOHOyXmD4%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Roman Gushchin <guro@fb.com>
Subject: writeback, cgroup: release dying cgwbs by switching attached inodes

Asynchronously try to release dying cgwbs by switching attached inodes to
the nearest living ancestor wb.  It helps to get rid of per-cgroup
writeback structures themselves and of pinned memory and block cgroups,
which are significantly larger structures (mostly due to large per-cpu
statistics data).  This prevents memory waste and helps to avoid different
scalability problems caused by large piles of dying cgroups.

Reuse the existing mechanism of inode switching used for foreign inode
detection.  To speed things up batch up to 115 inode switching in a single
operation (the maximum number is selected so that the resulting struct
inode_switch_wbs_context can fit into 1024 bytes).  Because every
switching consists of two steps divided by an RCU grace period, it would
be too slow without batching.  Please note that the whole batch counts as
a single operation (when increasing/decreasing isw_nr_in_flight).  This
allows to keep umounting working (flush the switching queue), however
prevents cleanups from consuming the whole switching quota and effectively
blocking the frn switching.

A cgwb cleanup operation can fail due to different reasons (e.g.  not
enough memory, the cgwb has an in-flight/pending io, an attached inode in
a wrong state, etc).  In this case the next scheduled cleanup will make a
new attempt.  An attempt is made each time a new cgwb is offlined (in
other words a memcg and/or a blkcg is deleted by a user).  In the future
an additional attempt scheduled by a timer can be implemented.

[guro@fb.com: replace open-coded "115" with arithmetic]
  Link: https://lkml.kernel.org/r/YMEcSBcq/VXMiPPO@carbon.dhcp.thefacebook.com
[guro@fb.com: add smp_mb() to inode_prepare_wbs_switch()]
  Link: https://lkml.kernel.org/r/YMFa+guFw7OFjf3X@carbon.dhcp.thefacebook.com
[willy@infradead.org: fix documentation]
  Link: https://lkml.kernel.org/r/20210615200242.1716568-2-willy@infradead.org
Link: https://lkml.kernel.org/r/20210608230225.2078447-9-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Dennis Zhou <dennis@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Jan Kara <jack@suse.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c                |  111 ++++++++++++++++++++++++++---
 include/linux/backing-dev-defs.h |    1 
 include/linux/writeback.h        |    1 
 mm/backing-dev.c                 |   64 ++++++++++++++++
 4 files changed, 165 insertions(+), 12 deletions(-)

--- a/fs/fs-writeback.c~writeback-cgroup-release-dying-cgwbs-by-switching-attached-inodes
+++ a/fs/fs-writeback.c
@@ -225,6 +225,13 @@ void wb_wait_for_completion(struct wb_co
 					/* one round can affect upto 5 slots */
 #define WB_FRN_MAX_IN_FLIGHT	1024	/* don't queue too many concurrently */
 
+/*
+ * Maximum inodes per isw.  A specific value has been chosen to make
+ * struct inode_switch_wbs_context fit into 1024 bytes kmalloc.
+ */
+#define WB_MAX_INODES_PER_ISW  ((1024UL - sizeof(struct inode_switch_wbs_context)) \
+                                / sizeof(struct inode *))
+
 static atomic_t isw_nr_in_flight = ATOMIC_INIT(0);
 static struct workqueue_struct *isw_wq;
 
@@ -503,6 +510,32 @@ static void inode_switch_wbs_work_fn(str
 	atomic_dec(&isw_nr_in_flight);
 }
 
+static bool inode_prepare_wbs_switch(struct inode *inode,
+				     struct bdi_writeback *new_wb)
+{
+	/*
+	 * Paired with smp_mb() in cgroup_writeback_umount().
+	 * isw_nr_in_flight must be increased before checking SB_ACTIVE and
+	 * grabbing an inode, otherwise isw_nr_in_flight can be observed as 0
+	 * in cgroup_writeback_umount() and the isw_wq will be not flushed.
+	 */
+	smp_mb();
+
+	/* while holding I_WB_SWITCH, no one else can update the association */
+	spin_lock(&inode->i_lock);
+	if (!(inode->i_sb->s_flags & SB_ACTIVE) ||
+	    inode->i_state & (I_WB_SWITCH | I_FREEING | I_WILL_FREE) ||
+	    inode_to_wb(inode) == new_wb) {
+		spin_unlock(&inode->i_lock);
+		return false;
+	}
+	inode->i_state |= I_WB_SWITCH;
+	__iget(inode);
+	spin_unlock(&inode->i_lock);
+
+	return true;
+}
+
 /**
  * inode_switch_wbs - change the wb association of an inode
  * @inode: target inode
@@ -540,17 +573,8 @@ static void inode_switch_wbs(struct inod
 	if (!isw->new_wb)
 		goto out_free;
 
-	/* while holding I_WB_SWITCH, no one else can update the association */
-	spin_lock(&inode->i_lock);
-	if (!(inode->i_sb->s_flags & SB_ACTIVE) ||
-	    inode->i_state & (I_WB_SWITCH | I_FREEING | I_WILL_FREE) ||
-	    inode_to_wb(inode) == isw->new_wb) {
-		spin_unlock(&inode->i_lock);
+	if (!inode_prepare_wbs_switch(inode, isw->new_wb))
 		goto out_free;
-	}
-	inode->i_state |= I_WB_SWITCH;
-	__iget(inode);
-	spin_unlock(&inode->i_lock);
 
 	isw->inodes[0] = inode;
 
@@ -572,6 +596,73 @@ out_free:
 }
 
 /**
+ * cleanup_offline_cgwb - detach associated inodes
+ * @wb: target wb
+ *
+ * Switch all inodes attached to @wb to a nearest living ancestor's wb in order
+ * to eventually release the dying @wb.  Returns %true if not all inodes were
+ * switched and the function has to be restarted.
+ */
+bool cleanup_offline_cgwb(struct bdi_writeback *wb)
+{
+	struct cgroup_subsys_state *memcg_css;
+	struct inode_switch_wbs_context *isw;
+	struct inode *inode;
+	int nr;
+	bool restart = false;
+
+	isw = kzalloc(sizeof(*isw) + WB_MAX_INODES_PER_ISW *
+		      sizeof(struct inode *), GFP_KERNEL);
+	if (!isw)
+		return restart;
+
+	atomic_inc(&isw_nr_in_flight);
+
+	for (memcg_css = wb->memcg_css->parent; memcg_css;
+	     memcg_css = memcg_css->parent) {
+		isw->new_wb = wb_get_create(wb->bdi, memcg_css, GFP_KERNEL);
+		if (isw->new_wb)
+			break;
+	}
+	if (unlikely(!isw->new_wb))
+		isw->new_wb = &wb->bdi->wb; /* wb_get() is noop for bdi's wb */
+
+	nr = 0;
+	spin_lock(&wb->list_lock);
+	list_for_each_entry(inode, &wb->b_attached, i_io_list) {
+		if (!inode_prepare_wbs_switch(inode, isw->new_wb))
+			continue;
+
+		isw->inodes[nr++] = inode;
+
+		if (nr >= WB_MAX_INODES_PER_ISW - 1) {
+			restart = true;
+			break;
+		}
+	}
+	spin_unlock(&wb->list_lock);
+
+	/* no attached inodes? bail out */
+	if (nr == 0) {
+		atomic_dec(&isw_nr_in_flight);
+		wb_put(isw->new_wb);
+		kfree(isw);
+		return restart;
+	}
+
+	/*
+	 * In addition to synchronizing among switchers, I_WB_SWITCH tells
+	 * the RCU protected stat update paths to grab the i_page
+	 * lock so that stat transfer can synchronize against them.
+	 * Let's continue after I_WB_SWITCH is guaranteed to be visible.
+	 */
+	INIT_RCU_WORK(&isw->work, inode_switch_wbs_work_fn);
+	queue_rcu_work(isw_wq, &isw->work);
+
+	return restart;
+}
+
+/**
  * wbc_attach_and_unlock_inode - associate wbc with target inode and unlock it
  * @wbc: writeback_control of interest
  * @inode: target inode
--- a/include/linux/backing-dev-defs.h~writeback-cgroup-release-dying-cgwbs-by-switching-attached-inodes
+++ a/include/linux/backing-dev-defs.h
@@ -155,6 +155,7 @@ struct bdi_writeback {
 	struct list_head memcg_node;	/* anchored at memcg->cgwb_list */
 	struct list_head blkcg_node;	/* anchored at blkcg->cgwb_list */
 	struct list_head b_attached;	/* attached inodes, protected by list_lock */
+	struct list_head offline_node;	/* anchored at offline_cgwbs */
 
 	union {
 		struct work_struct release_work;
--- a/include/linux/writeback.h~writeback-cgroup-release-dying-cgwbs-by-switching-attached-inodes
+++ a/include/linux/writeback.h
@@ -221,6 +221,7 @@ void wbc_account_cgroup_owner(struct wri
 int cgroup_writeback_by_id(u64 bdi_id, int memcg_id, unsigned long nr_pages,
 			   enum wb_reason reason, struct wb_completion *done);
 void cgroup_writeback_umount(void);
+bool cleanup_offline_cgwb(struct bdi_writeback *wb);
 
 /**
  * inode_attach_wb - associate an inode with its wb
--- a/mm/backing-dev.c~writeback-cgroup-release-dying-cgwbs-by-switching-attached-inodes
+++ a/mm/backing-dev.c
@@ -371,12 +371,16 @@ static void wb_exit(struct bdi_writeback
 #include <linux/memcontrol.h>
 
 /*
- * cgwb_lock protects bdi->cgwb_tree, blkcg->cgwb_list, and memcg->cgwb_list.
- * bdi->cgwb_tree is also RCU protected.
+ * cgwb_lock protects bdi->cgwb_tree, blkcg->cgwb_list, offline_cgwbs and
+ * memcg->cgwb_list.  bdi->cgwb_tree is also RCU protected.
  */
 static DEFINE_SPINLOCK(cgwb_lock);
 static struct workqueue_struct *cgwb_release_wq;
 
+static LIST_HEAD(offline_cgwbs);
+static void cleanup_offline_cgwbs_workfn(struct work_struct *work);
+static DECLARE_WORK(cleanup_offline_cgwbs_work, cleanup_offline_cgwbs_workfn);
+
 static void cgwb_release_workfn(struct work_struct *work)
 {
 	struct bdi_writeback *wb = container_of(work, struct bdi_writeback,
@@ -395,6 +399,11 @@ static void cgwb_release_workfn(struct w
 
 	fprop_local_destroy_percpu(&wb->memcg_completions);
 	percpu_ref_exit(&wb->refcnt);
+
+	spin_lock_irq(&cgwb_lock);
+	list_del(&wb->offline_node);
+	spin_unlock_irq(&cgwb_lock);
+
 	wb_exit(wb);
 	WARN_ON_ONCE(!list_empty(&wb->b_attached));
 	kfree_rcu(wb, rcu);
@@ -414,6 +423,7 @@ static void cgwb_kill(struct bdi_writeba
 	WARN_ON(!radix_tree_delete(&wb->bdi->cgwb_tree, wb->memcg_css->id));
 	list_del(&wb->memcg_node);
 	list_del(&wb->blkcg_node);
+	list_add(&wb->offline_node, &offline_cgwbs);
 	percpu_ref_kill(&wb->refcnt);
 }
 
@@ -635,6 +645,54 @@ static void cgwb_bdi_unregister(struct b
 	mutex_unlock(&bdi->cgwb_release_mutex);
 }
 
+/*
+ * cleanup_offline_cgwbs_workfn - try to release dying cgwbs
+ *
+ * Try to release dying cgwbs by switching attached inodes to the nearest
+ * living ancestor's writeback. Processed wbs are placed at the end
+ * of the list to guarantee the forward progress.
+ */
+static void cleanup_offline_cgwbs_workfn(struct work_struct *work)
+{
+	struct bdi_writeback *wb;
+	LIST_HEAD(processed);
+
+	spin_lock_irq(&cgwb_lock);
+
+	while (!list_empty(&offline_cgwbs)) {
+		wb = list_first_entry(&offline_cgwbs, struct bdi_writeback,
+				      offline_node);
+		list_move(&wb->offline_node, &processed);
+
+		/*
+		 * If wb is dirty, cleaning up the writeback by switching
+		 * attached inodes will result in an effective removal of any
+		 * bandwidth restrictions, which isn't the goal.  Instead,
+		 * it can be postponed until the next time, when all io
+		 * will be likely completed.  If in the meantime some inodes
+		 * will get re-dirtied, they should be eventually switched to
+		 * a new cgwb.
+		 */
+		if (wb_has_dirty_io(wb))
+			continue;
+
+		if (!wb_tryget(wb))
+			continue;
+
+		spin_unlock_irq(&cgwb_lock);
+		while (cleanup_offline_cgwb(wb))
+			cond_resched();
+		spin_lock_irq(&cgwb_lock);
+
+		wb_put(wb);
+	}
+
+	if (!list_empty(&processed))
+		list_splice_tail(&processed, &offline_cgwbs);
+
+	spin_unlock_irq(&cgwb_lock);
+}
+
 /**
  * wb_memcg_offline - kill all wb's associated with a memcg being offlined
  * @memcg: memcg being offlined
@@ -651,6 +709,8 @@ void wb_memcg_offline(struct mem_cgroup
 		cgwb_kill(wb);
 	memcg_cgwb_list->next = NULL;	/* prevent new wb's */
 	spin_unlock_irq(&cgwb_lock);
+
+	queue_work(system_unbound_wq, &cleanup_offline_cgwbs_work);
 }
 
 /**
_
