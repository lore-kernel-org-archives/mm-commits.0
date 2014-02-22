From: akpm@linux-foundation.org
Subject: [merged] quota-fix-race-between-dqput-and-dquot_scan_active.patch removed from -mm tree
Date: Fri, 21 Feb 2014 16:08:51 -0800
Message-ID: <5307ea93.hAwlny16gGZ7d96t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59421 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbaBVAIw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Feb 2014 19:08:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, jack@suse.cz

Subject: [merged] quota-fix-race-between-dqput-and-dquot_scan_active.patch removed from -mm tree
To: jack@suse.cz,jlbec@evilplan.org,mfasheh@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 21 Feb 2014 16:08:51 -0800


The patch titled
     Subject: quota: fix race between dqput() and dquot_scan_active()
has been removed from the -mm tree.  Its filename was
     quota-fix-race-between-dqput-and-dquot_scan_active.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: quota: fix race between dqput() and dquot_scan_active()

Currently last dqput() can race with dquot_scan_active() causing it to
call callback for an already deactivated dquot.  The race is as follows:

CPU1					CPU2
  dqput()
    spin_lock(&dq_list_lock);
    if (atomic_read(&dquot->dq_count) > 1) {
     - not taken
    if (test_bit(DQ_ACTIVE_B, &dquot->dq_flags)) {
      spin_unlock(&dq_list_lock);
      ->release_dquot(dquot);
        if (atomic_read(&dquot->dq_count) > 1)
         - not taken
					  dquot_scan_active()
					    spin_lock(&dq_list_lock);
					    if (!test_bit(DQ_ACTIVE_B, &dquot->dq_flags))
					     - not taken
					    atomic_inc(&dquot->dq_count);
					    spin_unlock(&dq_list_lock);
        - proceeds to release dquot
					    ret = fn(dquot, priv);
					     - called for inactive dquot

Fix the problem by making sure possible ->release_dquot() is finished by
the time we call the callback and new calls to it will notice reference
dquot_scan_active() has taken and bail out.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/quota/dquot.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff -puN fs/quota/dquot.c~quota-fix-race-between-dqput-and-dquot_scan_active fs/quota/dquot.c
--- a/fs/quota/dquot.c~quota-fix-race-between-dqput-and-dquot_scan_active
+++ a/fs/quota/dquot.c
@@ -581,9 +581,17 @@ int dquot_scan_active(struct super_block
 		dqstats_inc(DQST_LOOKUPS);
 		dqput(old_dquot);
 		old_dquot = dquot;
-		ret = fn(dquot, priv);
-		if (ret < 0)
-			goto out;
+		/*
+		 * ->release_dquot() can be racing with us. Our reference
+		 * protects us from new calls to it so just wait for any
+		 * outstanding call and recheck the DQ_ACTIVE_B after that.
+		 */
+		wait_on_dquot(dquot);
+		if (test_bit(DQ_ACTIVE_B, &dquot->dq_flags)) {
+			ret = fn(dquot, priv);
+			if (ret < 0)
+				goto out;
+		}
 		spin_lock(&dq_list_lock);
 		/* We are safe to continue now because our dquot could not
 		 * be moved out of the inuse list while we hold the reference */
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
ocfs2-fix-quota-file-corruption.patch
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

