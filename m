From: akpm@linux-foundation.org
Subject: +
 ocfs2-move-dquot_initialize-in-ocfs2_delete_inode-somewhat-later.patch
 added to -mm tree
Date: Fri, 21 Feb 2014 12:48:09 -0800
Message-ID: <5307bb89.vql4lK7nk2Hx5r7a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58310 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099AbaBUUsK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Feb 2014 15:48:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, srinivas.eeda@oracle.com, rgoldwyn@suse.com, mfasheh@suse.com, jlbec@evilplan.org, jack@suse.cz

Subject: + ocfs2-move-dquot_initialize-in-ocfs2_delete_inode-somewhat-later.patch added to -mm tree
To: jack@suse.cz,jlbec@evilplan.org,mfasheh@suse.com,rgoldwyn@suse.com,srinivas.eeda@oracle.com
From: akpm@linux-foundation.org
Date: Fri, 21 Feb 2014 12:48:09 -0800


The patch titled
     Subject: ocfs2: move dquot_initialize() in ocfs2_delete_inode() somewhat later
has been added to the -mm tree.  Its filename is
     ocfs2-move-dquot_initialize-in-ocfs2_delete_inode-somewhat-later.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-move-dquot_initialize-in-ocfs2_delete_inode-somewhat-later.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-move-dquot_initialize-in-ocfs2_delete_inode-somewhat-later.patch

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
Cc: Mark Fasheh <mfasheh@suse.com>
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

