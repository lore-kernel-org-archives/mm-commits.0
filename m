From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-avoid-blocking-in-ocfs2_mark_lockres_freeing-in-downconvert-thread.patch removed from -mm tree
Date: Fri, 04 Apr 2014 12:30:15 -0700
Message-ID: <533f0847.pw1Q0EEXFUDvW3wC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42742 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461AbaDDTaQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:30:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, srinivas.eeda@oracle.com, mfasheh@suse.de, jlbec@evilplan.org, jack@suse.cz

Subject: [merged] ocfs2-avoid-blocking-in-ocfs2_mark_lockres_freeing-in-downconvert-thread.patch removed from -mm tree
To: jack@suse.cz,jlbec@evilplan.org,mfasheh@suse.de,srinivas.eeda@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:30:15 -0700


The patch titled
     Subject: ocfs2: avoid blocking in ocfs2_mark_lockres_freeing() in downconvert thread
has been removed from the -mm tree.  Its filename was
     ocfs2-avoid-blocking-in-ocfs2_mark_lockres_freeing-in-downconvert-thread.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: ocfs2: avoid blocking in ocfs2_mark_lockres_freeing() in downconvert thread

If we are dropping last inode reference from downconvert thread, we will
end up calling ocfs2_mark_lockres_freeing() which can block if the lock we
are freeing is queued thus creating an A-A deadlock.  Luckily, since we
are the downconvert thread, we can immediately dequeue the lock and thus
avoid waiting in this case.

Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmglue.c |   44 ++++++++++++++++++++++++++++++++++++++++---
 fs/ocfs2/dlmglue.h |    3 +-
 fs/ocfs2/inode.c   |    7 +++---
 3 files changed, 47 insertions(+), 7 deletions(-)

diff -puN fs/ocfs2/dlmglue.c~ocfs2-avoid-blocking-in-ocfs2_mark_lockres_freeing-in-downconvert-thread fs/ocfs2/dlmglue.c
--- a/fs/ocfs2/dlmglue.c~ocfs2-avoid-blocking-in-ocfs2_mark_lockres_freeing-in-downconvert-thread
+++ a/fs/ocfs2/dlmglue.c
@@ -3144,22 +3144,60 @@ out:
 	return 0;
 }
 
+static void ocfs2_process_blocked_lock(struct ocfs2_super *osb,
+				       struct ocfs2_lock_res *lockres);
+
 /* Mark the lockres as being dropped. It will no longer be
  * queued if blocking, but we still may have to wait on it
  * being dequeued from the downconvert thread before we can consider
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
@@ -3180,7 +3218,7 @@ void ocfs2_simple_drop_lockres(struct oc
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

origin.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
linux-next.patch
mm-add-strictlimit-knob-v2.patch

