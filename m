From: akpm@linux-foundation.org
Subject: [to-be-updated] ocfs2-remove-ocfs2_inode_skip_delete-flag.patch
 removed from -mm tree
Date: Wed, 26 Feb 2014 15:46:16 -0800
Message-ID: <530e7cc8.aTr6DCnXrCmEcz1A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53511 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbaBZXqR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Feb 2014 18:46:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, srinivas.eeda@oracle.com, rgoldwyn@suse.com, mfasheh@suse.de, jlbec@evilplan.org, jack@suse.cz

Subject: [to-be-updated] ocfs2-remove-ocfs2_inode_skip_delete-flag.patch removed from -mm tree
To: jack@suse.cz,jlbec@evilplan.org,mfasheh@suse.de,rgoldwyn@suse.com,srinivas.eeda@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 26 Feb 2014 15:46:16 -0800


The patch titled
     Subject: ocfs2: remove OCFS2_INODE_SKIP_DELETE flag
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-ocfs2_inode_skip_delete-flag.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: ocfs2: remove OCFS2_INODE_SKIP_DELETE flag

The flag was never set, delete it.

Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c   |    6 ------
 fs/ocfs2/inode.h   |    8 +++-----
 fs/ocfs2/journal.c |    6 ------
 3 files changed, 3 insertions(+), 17 deletions(-)

diff -puN fs/ocfs2/inode.c~ocfs2-remove-ocfs2_inode_skip_delete-flag fs/ocfs2/inode.c
--- a/fs/ocfs2/inode.c~ocfs2-remove-ocfs2_inode_skip_delete-flag
+++ a/fs/ocfs2/inode.c
@@ -849,12 +849,6 @@ static int ocfs2_inode_is_valid_to_delet
 		goto bail_unlock;
 	}
 
-	/* If we have allowd wipe of this inode for another node, it
-	 * will be marked here so we can safely skip it. Recovery will
-	 * cleanup any inodes we might inadvertently skip here. */
-	if (oi->ip_flags & OCFS2_INODE_SKIP_DELETE)
-		goto bail_unlock;
-
 	ret = 1;
 bail_unlock:
 	spin_unlock(&oi->ip_lock);
diff -puN fs/ocfs2/inode.h~ocfs2-remove-ocfs2_inode_skip_delete-flag fs/ocfs2/inode.h
--- a/fs/ocfs2/inode.h~ocfs2-remove-ocfs2_inode_skip_delete-flag
+++ a/fs/ocfs2/inode.h
@@ -91,8 +91,6 @@ struct ocfs2_inode_info
 #define OCFS2_INODE_BITMAP		0x00000004
 /* This inode has been wiped from disk */
 #define OCFS2_INODE_DELETED		0x00000008
-/* Another node is deleting, so our delete is a nop */
-#define OCFS2_INODE_SKIP_DELETE		0x00000010
 /* Has the inode been orphaned on another node?
  *
  * This hints to ocfs2_drop_inode that it should clear i_nlink before
@@ -107,11 +105,11 @@ struct ocfs2_inode_info
  * rely on ocfs2_delete_inode to sort things out under the proper
  * cluster locks.
  */
-#define OCFS2_INODE_MAYBE_ORPHANED	0x00000020
+#define OCFS2_INODE_MAYBE_ORPHANED	0x00000010
 /* Does someone have the file open O_DIRECT */
-#define OCFS2_INODE_OPEN_DIRECT		0x00000040
+#define OCFS2_INODE_OPEN_DIRECT		0x00000020
 /* Tell the inode wipe code it's not in orphan dir */
-#define OCFS2_INODE_SKIP_ORPHAN_DIR     0x00000080
+#define OCFS2_INODE_SKIP_ORPHAN_DIR     0x00000040
 
 static inline struct ocfs2_inode_info *OCFS2_I(struct inode *inode)
 {
diff -puN fs/ocfs2/journal.c~ocfs2-remove-ocfs2_inode_skip_delete-flag fs/ocfs2/journal.c
--- a/fs/ocfs2/journal.c~ocfs2-remove-ocfs2_inode_skip_delete-flag
+++ a/fs/ocfs2/journal.c
@@ -2132,12 +2132,6 @@ static int ocfs2_recover_orphans(struct
 		iter = oi->ip_next_orphan;
 
 		spin_lock(&oi->ip_lock);
-		/* The remote delete code may have set these on the
-		 * assumption that the other node would wipe them
-		 * successfully.  If they are still in the node's
-		 * orphan dir, we need to reset that state. */
-		oi->ip_flags &= ~(OCFS2_INODE_DELETED|OCFS2_INODE_SKIP_DELETE);
-
 		/* Set the proper information to get us going into
 		 * ocfs2_delete_inode. */
 		oi->ip_flags |= OCFS2_INODE_MAYBE_ORPHANED;
_

Patches currently in -mm which might be from jack@suse.cz are

ocfs2-fix-quota-file-corruption.patch
backing_dev-fix-hung-task-on-sync.patch
kthread-ensure-locality-of-task_struct-allocations.patch
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

