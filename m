From: akpm@linux-foundation.org
Subject: [to-be-updated]
 ocfs2-move-dquot_initialize-in-ocfs2_delete_inode-somewhat-later.patch
 removed from -mm tree
Date: Wed, 26 Feb 2014 15:46:18 -0800
Message-ID: <530e7cca.uwKTVqDpzQdV3YUf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53520 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbaBZXqT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Feb 2014 18:46:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, srinivas.eeda@oracle.com, rgoldwyn@suse.com, mfasheh@suse.de, jlbec@evilplan.org, jack@suse.cz

Subject: [to-be-updated] ocfs2-move-dquot_initialize-in-ocfs2_delete_inode-somewhat-later.patch removed from -mm tree
To: jack@suse.cz,jlbec@evilplan.org,mfasheh@suse.de,rgoldwyn@suse.com,srinivas.eeda@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 26 Feb 2014 15:46:18 -0800


The patch titled
     Subject: ocfs2: move dquot_initialize() in ocfs2_delete_inode() somewhat later
has been removed from the -mm tree.  Its filename was
     ocfs2-move-dquot_initialize-in-ocfs2_delete_inode-somewhat-later.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: ocfs2: move dquot_initialize() in ocfs2_delete_inode() somewhat later

Move dquot_initalize() call in ocfs2_delete_inode() after the moment we
verify inode is actually a sane one to delete.  We certainly don't want to
initialize quota for system inodes etc.  This also avoids calling into
quota code from downconvert thread.

Add more details into the comment why bailing out from
ocfs2_delete_inode() when we are in downconvert thread is OK.

Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff -puN fs/ocfs2/inode.c~ocfs2-move-dquot_initialize-in-ocfs2_delete_inode-somewhat-later fs/ocfs2/inode.c
--- a/fs/ocfs2/inode.c~ocfs2-move-dquot_initialize-in-ocfs2_delete_inode-somewhat-later
+++ a/fs/ocfs2/inode.c
@@ -831,11 +831,13 @@ static int ocfs2_inode_is_valid_to_delet
 		goto bail;
 	}
 
-	/* If we're coming from downconvert_thread we can't go into our own
-	 * voting [hello, deadlock city!], so unforuntately we just
-	 * have to skip deleting this guy. That's OK though because
-	 * the node who's doing the actual deleting should handle it
-	 * anyway. */
+	/*
+	 * If we're coming from downconvert_thread we can't go into our own
+	 * voting [hello, deadlock city!] so we cannot delete the inode. But
+	 * since we dropped last inode ref when downconverting dentry lock,
+	 * we cannot have the file open and thus the node doing unlink will
+	 * take care of deleting the inode.
+	 */
 	if (current == osb->dc_task)
 		goto bail;
 
@@ -981,8 +983,6 @@ static void ocfs2_delete_inode(struct in
 	if (is_bad_inode(inode) || !OCFS2_I(inode)->ip_blkno)
 		goto bail;
 
-	dquot_initialize(inode);
-
 	if (!ocfs2_inode_is_valid_to_delete(inode)) {
 		/* It's probably not necessary to truncate_inode_pages
 		 * here but we do it for safety anyway (it will most
@@ -991,6 +991,8 @@ static void ocfs2_delete_inode(struct in
 		goto bail;
 	}
 
+	dquot_initialize(inode);
+
 	/* We want to block signals in delete_inode as the lock and
 	 * messaging paths may return us -ERESTARTSYS. Which would
 	 * cause us to exit early, resulting in inodes being orphaned
_

Patches currently in -mm which might be from jack@suse.cz are

ocfs2-fix-quota-file-corruption.patch
backing_dev-fix-hung-task-on-sync.patch
kthread-ensure-locality-of-task_struct-allocations.patch
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

