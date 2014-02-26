From: akpm@linux-foundation.org
Subject: [to-be-updated]
 ocfs2-avoid-blocking-in-ocfs2_mark_lockres_freeing-in-downconvert-thread.patch removed from -mm tree
Date: Wed, 26 Feb 2014 15:46:24 -0800
Message-ID: <530e7cd0.1lAf+aaNyedqOb7o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53540 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbaBZXqZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Feb 2014 18:46:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, srinivas.eeda@oracle.com, rgoldwyn@suse.com, mfasheh@suse.de, jlbec@evilplan.org, jack@suse.cz

Subject: [to-be-updated] ocfs2-avoid-blocking-in-ocfs2_mark_lockres_freeing-in-downconvert-thread.patch removed from -mm tree
To: jack@suse.cz,jlbec@evilplan.org,mfasheh@suse.de,rgoldwyn@suse.com,srinivas.eeda@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 26 Feb 2014 15:46:24 -0800


The patch titled
     Subject: ocfs2: avoid blocking in ocfs2_mark_lockres_freeing() in downconvert thread
has been removed from the -mm tree.  Its filename was
     ocfs2-avoid-blocking-in-ocfs2_mark_lockres_freeing-in-downconvert-thread.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: ocfs2: avoid blocking in ocfs2_mark_lockres_freeing() in downconvert thread

If we are dropping last inode reference from downconvert thread, we will
end up calling ocfs2_mark_lockres_freeing() which can block if the lock we
are freeing is queued thus creating an A-A deadlock.  Luckily, since we
are the downconvert thread, we can immediately dequeue the lock and thus
avoid waiting in this case.

Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmglue.c |   33 +++++++++++++++++++++++++++++++--
 fs/ocfs2/dlmglue.h |    3 ++-
 fs/ocfs2/inode.c   |    7 ++++---
 3 files changed, 37 insertions(+), 6 deletions(-)

diff -puN fs/ocfs2/dlmglue.c~ocfs2-avoid-blocking-in-ocfs2_mark_lockres_freeing-in-downconvert-thread fs/ocfs2/dlmglue.c
--- a/fs/ocfs2/dlmglue.c~ocfs2-avoid-blocking-in-ocfs2_mark_lockres_freeing-in-downconvert-thread
+++ a/fs/ocfs2/dlmglue.c
@@ -3150,7 +3150,8 @@ out:
  * it safe to drop.
  *
  * You can *not* attempt to call cluster_lock on this lockres anymore. */
-void ocfs2_mark_lockres_freeing(struct ocfs2_lock_res *lockres)
+void ocfs2_mark_lockres_freeing(struct ocfs2_super *osb,
+				struct ocfs2_lock_res *lockres)
 {
 	int status;
 	struct ocfs2_mask_waiter mw;
@@ -3160,6 +3161,33 @@ void ocfs2_mark_lockres_freeing(struct o
 
 	spin_lock_irqsave(&lockres->l_lock, flags);
 	lockres->l_flags |= OCFS2_LOCK_FREEING;
+	if (lockres->l_flags & OCFS2_LOCK_QUEUED && current == osb->dc_task) {
+		unsigned long flags;
+
+		/*
+		 * We know the downconvert is queued but not in progress
+		 * because we are the downconvert thread and processing
+		 * different lock. So we can just remove the lock from the
+		 * queue. This is not only an optimization but also a way
+		 * to avoid the following deadlock:
+		 *   ocfs2_dentry_post_unlock()
+		 *     ocfs2_dentry_lock_put()
+		 *       ocfs2_drop_dentry_lock()
+		 *         iput()
+		 *           ocfs2_evict_inode()
+		 *             ocfs2_clear_inode()
+		 *               ocfs2_mark_lockres_freeing()
+		 *                 ... blocks waiting for OCFS2_LOCK_QUEUED
+		 *                 since we are the downconvert thread which
+		 *                 should clear the flag.
+		 */
+		spin_lock_irqsave(&osb->dc_task_lock, flags);
+		list_del_init(&lockres->l_blocked_list);
+		osb->blocked_lock_count--;
+		spin_unlock_irqrestore(&osb->dc_task_lock, flags);
+		lockres_clear_flags(lockres, OCFS2_LOCK_QUEUED);
+		goto out_unlock;
+	}
 	while (lockres->l_flags & OCFS2_LOCK_QUEUED) {
 		lockres_add_mask_waiter(lockres, &mw, OCFS2_LOCK_QUEUED, 0);
 		spin_unlock_irqrestore(&lockres->l_lock, flags);
@@ -3172,6 +3200,7 @@ void ocfs2_mark_lockres_freeing(struct o
 
 		spin_lock_irqsave(&lockres->l_lock, flags);
 	}
+out_unlock:
 	spin_unlock_irqrestore(&lockres->l_lock, flags);
 }
 
@@ -3180,7 +3209,7 @@ void ocfs2_simple_drop_lockres(struct oc
 {
 	int ret;
 
-	ocfs2_mark_lockres_freeing(lockres);
+	ocfs2_mark_lockres_freeing(osb, lockres);
 	ret = ocfs2_drop_lock(osb, lockres);
 	if (ret)
 		mlog_errno(ret);
diff -puN fs/ocfs2/dlmglue.h~ocfs2-avoid-blocking-in-ocfs2_mark_lockres_freeing-in-downconvert-thread fs/ocfs2/dlmglue.h
--- a/fs/ocfs2/dlmglue.h~ocfs2-avoid-blocking-in-ocfs2_mark_lockres_freeing-in-downconvert-thread
+++ a/fs/ocfs2/dlmglue.h
@@ -157,7 +157,8 @@ int ocfs2_refcount_lock(struct ocfs2_ref
 void ocfs2_refcount_unlock(struct ocfs2_refcount_tree *ref_tree, int ex);
 
 
-void ocfs2_mark_lockres_freeing(struct ocfs2_lock_res *lockres);
+void ocfs2_mark_lockres_freeing(struct ocfs2_super *osb,
+				struct ocfs2_lock_res *lockres);
 void ocfs2_simple_drop_lockres(struct ocfs2_super *osb,
 			       struct ocfs2_lock_res *lockres);
 
diff -puN fs/ocfs2/inode.c~ocfs2-avoid-blocking-in-ocfs2_mark_lockres_freeing-in-downconvert-thread fs/ocfs2/inode.c
--- a/fs/ocfs2/inode.c~ocfs2-avoid-blocking-in-ocfs2_mark_lockres_freeing-in-downconvert-thread
+++ a/fs/ocfs2/inode.c
@@ -1080,6 +1080,7 @@ static void ocfs2_clear_inode(struct ino
 {
 	int status;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
 	clear_inode(inode);
 	trace_ocfs2_clear_inode((unsigned long long)oi->ip_blkno,
@@ -1096,9 +1097,9 @@ static void ocfs2_clear_inode(struct ino
 
 	/* Do these before all the other work so that we don't bounce
 	 * the downconvert thread while waiting to destroy the locks. */
-	ocfs2_mark_lockres_freeing(&oi->ip_rw_lockres);
-	ocfs2_mark_lockres_freeing(&oi->ip_inode_lockres);
-	ocfs2_mark_lockres_freeing(&oi->ip_open_lockres);
+	ocfs2_mark_lockres_freeing(osb, &oi->ip_rw_lockres);
+	ocfs2_mark_lockres_freeing(osb, &oi->ip_inode_lockres);
+	ocfs2_mark_lockres_freeing(osb, &oi->ip_open_lockres);
 
 	ocfs2_resv_discard(&OCFS2_SB(inode->i_sb)->osb_la_resmap,
 			   &oi->ip_la_data_resv);
_

Patches currently in -mm which might be from jack@suse.cz are

ocfs2-fix-quota-file-corruption.patch
backing_dev-fix-hung-task-on-sync.patch
kthread-ensure-locality-of-task_struct-allocations.patch
ocfs2-revert-iput-deferring-code-in-ocfs2_drop_dentry_lock.patch
mm-vmstat-fix-up-zone-state-accounting.patch
fs-cachefiles-use-add_to_page_cache_lru.patch
lib-radix-tree-radix_tree_delete_item.patch
mm-shmem-save-one-radix-tree-lookup-when-truncating-swapped-pages.patch
mm-filemap-move-radix-tree-hole-searching-here.patch
mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees.patch
mm-fs-store-shadow-entries-in-page-cache.patch
mm-thrash-detection-based-file-cache-sizing.patch
lib-radix_tree-tree-node-interface.patch
mm-keep-page-cache-radix-tree-nodes-in-check.patch
mm-readaheadc-fix-readahead-failure-for-memoryless-numa-nodes-and-limit-readahead-pages.patch
printk-remove-duplicated-check-for-log-level.patch
printk-remove-obsolete-check-for-log-level-c.patch
printk-add-comment-about-tricky-check-for-text-buffer-size.patch
printk-use-also-the-last-bytes-in-the-ring-buffer.patch
printk-do-not-compute-the-size-of-the-message-twice.patch
linux-next.patch
mm-add-strictlimit-knob-v2.patch

