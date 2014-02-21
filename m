From: akpm@linux-foundation.org
Subject: +
 ocfs2-avoid-blocking-in-ocfs2_mark_lockres_freeing-in-downconvert-thread.patch added to -mm tree
Date: Fri, 21 Feb 2014 12:48:13 -0800
Message-ID: <5307bb8d.G1t+6k0Y9uBadQcJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58323 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768AbaBUUsO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Feb 2014 15:48:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, srinivas.eeda@oracle.com, rgoldwyn@suse.com, mfasheh@suse.com, jlbec@evilplan.org, jack@suse.cz

Subject: + ocfs2-avoid-blocking-in-ocfs2_mark_lockres_freeing-in-downconvert-thread.patch added to -mm tree
To: jack@suse.cz,jlbec@evilplan.org,mfasheh@suse.com,rgoldwyn@suse.com,srinivas.eeda@oracle.com
From: akpm@linux-foundation.org
Date: Fri, 21 Feb 2014 12:48:13 -0800


The patch titled
     Subject: ocfs2: avoid blocking in ocfs2_mark_lockres_freeing() in downconvert thread
has been added to the -mm tree.  Its filename is
     ocfs2-avoid-blocking-in-ocfs2_mark_lockres_freeing-in-downconvert-thread.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-avoid-blocking-in-ocfs2_mark_lockres_freeing-in-downconvert-thread.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-avoid-blocking-in-ocfs2_mark_lockres_freeing-in-downconvert-thread.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: ocfs2: avoid blocking in ocfs2_mark_lockres_freeing() in downconvert thread

If we are dropping last inode reference from downconvert thread, we will
end up calling ocfs2_mark_lockres_freeing() which can block if the lock we
are freeing is queued thus creating an A-A deadlock.  Luckily, since we
are the downconvert thread, we can immediately dequeue the lock and thus
avoid waiting in this case.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Srinivas Eeda <srinivas.eeda@oracle.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmglue.c |   42 +++++++++++++++++++++++++++++++++++++++---
 fs/ocfs2/dlmglue.h |    3 ++-
 fs/ocfs2/inode.c   |    7 ++++---
 3 files changed, 45 insertions(+), 7 deletions(-)

diff -puN fs/ocfs2/dlmglue.c~ocfs2-avoid-blocking-in-ocfs2_mark_lockres_freeing-in-downconvert-thread fs/ocfs2/dlmglue.c
--- a/fs/ocfs2/dlmglue.c~ocfs2-avoid-blocking-in-ocfs2_mark_lockres_freeing-in-downconvert-thread
+++ a/fs/ocfs2/dlmglue.c
@@ -3150,16 +3150,51 @@ out:
  * it safe to drop.
  *
  * You can *not* attempt to call cluster_lock on this lockres anymore. */
-void ocfs2_mark_lockres_freeing(struct ocfs2_lock_res *lockres)
+void ocfs2_mark_lockres_freeing(struct ocfs2_super *osb,
+				struct ocfs2_lock_res *lockres)
 {
 	int status;
 	struct ocfs2_mask_waiter mw;
-	unsigned long flags;
+	unsigned long flags, flags2;
 
 	ocfs2_init_mask_waiter(&mw);
 
 	spin_lock_irqsave(&lockres->l_lock, flags);
 	lockres->l_flags |= OCFS2_LOCK_FREEING;
+	if (lockres->l_flags & OCFS2_LOCK_QUEUED && current == osb->dc_task) {
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
+		spin_unlock_irqrestore(&lockres->l_lock, flags);
+		spin_lock_irqsave(&osb->dc_task_lock, flags2);
+		list_del_init(&lockres->l_blocked_list);
+		osb->blocked_lock_count--;
+		spin_unlock_irqrestore(&osb->dc_task_lock, flags2);
+		/*
+		 * Warn if we recurse into another post_unlock call.  Strictly
+		 * speaking it isn't a problem but we need to be careful if
+		 * that happens (stack overflow, deadlocks, ...) so warn if
+		 * ocfs2 grows a path for which this can happen.
+		 */
+		WARN_ON_ONCE(lockres->l_ops->post_unlock);
+		/* Since the lock is freeing we don't do much in the fn below */
+		ocfs2_process_blocked_lock(osb, lockres);
+		return;
+	}
 	while (lockres->l_flags & OCFS2_LOCK_QUEUED) {
 		lockres_add_mask_waiter(lockres, &mw, OCFS2_LOCK_QUEUED, 0);
 		spin_unlock_irqrestore(&lockres->l_lock, flags);
@@ -3172,6 +3207,7 @@ void ocfs2_mark_lockres_freeing(struct o
 
 		spin_lock_irqsave(&lockres->l_lock, flags);
 	}
+out_unlock:
 	spin_unlock_irqrestore(&lockres->l_lock, flags);
 }
 
@@ -3180,7 +3216,7 @@ void ocfs2_simple_drop_lockres(struct oc
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

backing_dev-fix-hung-task-on-sync.patch
revert-writeback-do-not-sync-data-dirtied-after-sync-start.patch
kthread-ensure-locality-of-task_struct-allocations.patch
fanotify-remove-useless-bypass_perm-check.patch
fanotify-use-fanotify-event-structure-for-permission-response-processing.patch
fanotify-remove-useless-test-from-event-initialization.patch
fanotify-convert-access_mutex-to-spinlock.patch
fanotify-reorganize-loop-in-fanotify_read.patch
fanotify-move-unrelated-handling-from-copy_event_to_user.patch
ocfs2-remove-ocfs2_inode_skip_delete-flag.patch
ocfs2-move-dquot_initialize-in-ocfs2_delete_inode-somewhat-later.patch
quota-provide-function-to-grab-quota-structure-reference.patch
ocfs2-implement-delayed-dropping-of-last-dquot-reference.patch
ocfs2-avoid-blocking-in-ocfs2_mark_lockres_freeing-in-downconvert-thread.patch
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

