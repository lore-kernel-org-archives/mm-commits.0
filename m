From: akpm@linux-foundation.org
Subject: [to-be-updated]
 quota-provide-function-to-grab-quota-structure-reference.patch removed from -mm tree
Date: Wed, 26 Feb 2014 15:46:20 -0800
Message-ID: <530e7ccc.DfoVOEmDhv9Gcaoz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53526 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbaBZXqV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Feb 2014 18:46:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, srinivas.eeda@oracle.com, rgoldwyn@suse.com, mfasheh@suse.de, jlbec@evilplan.org, jack@suse.cz

Subject: [to-be-updated] quota-provide-function-to-grab-quota-structure-reference.patch removed from -mm tree
To: jack@suse.cz,jlbec@evilplan.org,mfasheh@suse.de,rgoldwyn@suse.com,srinivas.eeda@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 26 Feb 2014 15:46:20 -0800


The patch titled
     Subject: quota: provide function to grab quota structure reference
has been removed from the -mm tree.  Its filename was
     quota-provide-function-to-grab-quota-structure-reference.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: quota: provide function to grab quota structure reference

Provide dqgrab() function to get quota structure reference when we are
sure it already has at least one active reference.  Make use of this
function inside quota code.

Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/quota/dquot.c         |    4 ++--
 include/linux/quotaops.h |    8 ++++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff -puN fs/quota/dquot.c~quota-provide-function-to-grab-quota-structure-reference fs/quota/dquot.c
--- a/fs/quota/dquot.c~quota-provide-function-to-grab-quota-structure-reference
+++ a/fs/quota/dquot.c
@@ -528,7 +528,7 @@ restart:
 		if (atomic_read(&dquot->dq_count)) {
 			DEFINE_WAIT(wait);
 
-			atomic_inc(&dquot->dq_count);
+			dqgrab(dquot);
 			prepare_to_wait(&dquot->dq_wait_unused, &wait,
 					TASK_UNINTERRUPTIBLE);
 			spin_unlock(&dq_list_lock);
@@ -624,7 +624,7 @@ int dquot_writeback_dquots(struct super_
 			/* Now we have active dquot from which someone is
  			 * holding reference so we can safely just increase
 			 * use count */
-			atomic_inc(&dquot->dq_count);
+			dqgrab(dquot);
 			spin_unlock(&dq_list_lock);
 			dqstats_inc(DQST_LOOKUPS);
 			err = sb->dq_op->write_dquot(dquot);
diff -puN include/linux/quotaops.h~quota-provide-function-to-grab-quota-structure-reference include/linux/quotaops.h
--- a/include/linux/quotaops.h~quota-provide-function-to-grab-quota-structure-reference
+++ a/include/linux/quotaops.h
@@ -46,6 +46,14 @@ void inode_reclaim_rsv_space(struct inod
 void dquot_initialize(struct inode *inode);
 void dquot_drop(struct inode *inode);
 struct dquot *dqget(struct super_block *sb, struct kqid qid);
+static inline struct dquot *dqgrab(struct dquot *dquot)
+{
+	/* Make sure someone else has active reference to dquot */
+	WARN_ON_ONCE(!atomic_read(&dquot->dq_count));
+	WARN_ON_ONCE(!test_bit(DQ_ACTIVE_B, &dquot->dq_flags));
+	atomic_inc(&dquot->dq_count);
+	return dquot;
+}
 void dqput(struct dquot *dquot);
 int dquot_scan_active(struct super_block *sb,
 		      int (*fn)(struct dquot *dquot, unsigned long priv),
_

Patches currently in -mm which might be from jack@suse.cz are

ocfs2-fix-quota-file-corruption.patch
backing_dev-fix-hung-task-on-sync.patch
kthread-ensure-locality-of-task_struct-allocations.patch
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

