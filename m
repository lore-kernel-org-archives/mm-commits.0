From: akpm@linux-foundation.org
Subject: + ocfs2-fix-quota-file-corruption.patch added to -mm tree
Date: Fri, 21 Feb 2014 13:58:06 -0800
Message-ID: <5307cbee.fMbUIHwWFKL/YtTw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58672 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbaBUV6H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Feb 2014 16:58:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, rgoldwyn@suse.de, mfasheh@suse.com, jlbec@evilplan.org, jack@suse.cz

Subject: + ocfs2-fix-quota-file-corruption.patch added to -mm tree
To: jack@suse.cz,jlbec@evilplan.org,mfasheh@suse.com,rgoldwyn@suse.de,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 21 Feb 2014 13:58:06 -0800


The patch titled
     Subject: ocfs2: fix quota file corruption
has been added to the -mm tree.  Its filename is
     ocfs2-fix-quota-file-corruption.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-quota-file-corruption.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-quota-file-corruption.patch

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
Subject: ocfs2: fix quota file corruption

Global quota files are accessed from different nodes.  Thus we cannot
cache offset of quota structure in the quota file after we drop our node
reference count to it because after that moment quota structure may be
freed and reallocated elsewhere by a different node resulting in
corruption of quota file.

Fix the problem by clearing dq_off when we are releasing dquot structure. 
We also remove the DB_READ_B handling because it is useless - DQ_ACTIVE_B
is set iff DQ_READ_B is set.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/quota_global.c |   27 +++++++++++++++++----------
 fs/ocfs2/quota_local.c  |    4 ----
 2 files changed, 17 insertions(+), 14 deletions(-)

diff -puN fs/ocfs2/quota_global.c~ocfs2-fix-quota-file-corruption fs/ocfs2/quota_global.c
--- a/fs/ocfs2/quota_global.c~ocfs2-fix-quota-file-corruption
+++ a/fs/ocfs2/quota_global.c
@@ -752,6 +752,12 @@ static int ocfs2_release_dquot(struct dq
 	 */
 	if (status < 0)
 		mlog_errno(status);
+	/*
+	 * Clear dq_off so that we search for the structure in quota file next
+	 * time we acquire it. The structure might be deleted and reallocated
+	 * elsewhere by another node while our dquot structure is on freelist.
+	 */
+	dquot->dq_off = 0;
 	clear_bit(DQ_ACTIVE_B, &dquot->dq_flags);
 out_trans:
 	ocfs2_commit_trans(osb, handle);
@@ -791,16 +797,17 @@ static int ocfs2_acquire_dquot(struct dq
 	status = ocfs2_lock_global_qf(info, 1);
 	if (status < 0)
 		goto out;
-	if (!test_bit(DQ_READ_B, &dquot->dq_flags)) {
-		status = ocfs2_qinfo_lock(info, 0);
-		if (status < 0)
-			goto out_dq;
-		status = qtree_read_dquot(&info->dqi_gi, dquot);
-		ocfs2_qinfo_unlock(info, 0);
-		if (status < 0)
-			goto out_dq;
-	}
-	set_bit(DQ_READ_B, &dquot->dq_flags);
+	status = ocfs2_qinfo_lock(info, 0);
+	if (status < 0)
+		goto out_dq;
+	/*
+	 * We always want to read dquot structure from disk because we don't
+	 * know what happened with it while it was on freelist.
+	 */
+	status = qtree_read_dquot(&info->dqi_gi, dquot);
+	ocfs2_qinfo_unlock(info, 0);
+	if (status < 0)
+		goto out_dq;
 
 	OCFS2_DQUOT(dquot)->dq_use_count++;
 	OCFS2_DQUOT(dquot)->dq_origspace = dquot->dq_dqb.dqb_curspace;
diff -puN fs/ocfs2/quota_local.c~ocfs2-fix-quota-file-corruption fs/ocfs2/quota_local.c
--- a/fs/ocfs2/quota_local.c~ocfs2-fix-quota-file-corruption
+++ a/fs/ocfs2/quota_local.c
@@ -1303,10 +1303,6 @@ int ocfs2_local_release_dquot(handle_t *
 	ocfs2_journal_dirty(handle, od->dq_chunk->qc_headerbh);
 
 out:
-	/* Clear the read bit so that next time someone uses this
-	 * dquot he reads fresh info from disk and allocates local
-	 * dquot structure */
-	clear_bit(DQ_READ_B, &dquot->dq_flags);
 	return status;
 }
 
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
quota-fix-race-between-dqput-and-dquot_scan_active.patch
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

