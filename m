From: akpm@linux-foundation.org
Subject: + backing_dev-fix-hung-task-on-sync-fix.patch added to -mm tree
Date: Tue, 11 Mar 2014 13:37:33 -0700
Message-ID: <531f740d.55ecFqnMyxj2L5ns%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44879 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755808AbaCKUhe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Mar 2014 16:37:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, dbasehore@chromium.org, jack@suse.cz

Subject: + backing_dev-fix-hung-task-on-sync-fix.patch added to -mm tree
To: jack@suse.cz,dbasehore@chromium.org,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 11 Mar 2014 13:37:33 -0700


The patch titled
     Subject: backing_dev-fix-hung-task-on-sync-fix
has been added to the -mm tree.  Its filename is
     backing_dev-fix-hung-task-on-sync-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/backing_dev-fix-hung-task-on-sync-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/backing_dev-fix-hung-task-on-sync-fix.patch

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
Subject: backing_dev-fix-hung-task-on-sync-fix

update changelog, add comment, use bdi_wakeup_thread_delayed()

Reviewed-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Derek Basehore <dbasehore@chromium.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    3 +--
 mm/backing-dev.c  |    3 +++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/fs-writeback.c~backing_dev-fix-hung-task-on-sync-fix fs/fs-writeback.c
--- a/fs/fs-writeback.c~backing_dev-fix-hung-task-on-sync-fix
+++ a/fs/fs-writeback.c
@@ -1042,8 +1042,7 @@ void bdi_writeback_workfn(struct work_st
 	if (!list_empty(&bdi->work_list))
 		mod_delayed_work(bdi_wq, &wb->dwork, 0);
 	else if (wb_has_dirty_io(wb) && dirty_writeback_interval)
-		queue_delayed_work(bdi_wq, &wb->dwork,
-			msecs_to_jiffies(dirty_writeback_interval * 10));
+		bdi_wakeup_thread_delayed(bdi);
 
 	current->flags &= ~PF_SWAPWRITE;
 }
diff -puN mm/backing-dev.c~backing_dev-fix-hung-task-on-sync-fix mm/backing-dev.c
--- a/mm/backing-dev.c~backing_dev-fix-hung-task-on-sync-fix
+++ a/mm/backing-dev.c
@@ -288,6 +288,9 @@ int bdi_has_dirty_io(struct backing_dev_
  * Note, we wouldn't bother setting up the timer, but this function is on the
  * fast-path (used by '__mark_inode_dirty()'), so we save few context switches
  * by delaying the wake-up.
+ *
+ * We have to be careful not to postpone flush work if it is scheduled for
+ * earlier. Thus we use queue_delayed_work().
  */
 void bdi_wakeup_thread_delayed(struct backing_dev_info *bdi)
 {
_

Patches currently in -mm which might be from jack@suse.cz are

backing_dev-fix-hung-task-on-sync.patch
backing_dev-fix-hung-task-on-sync-fix.patch
kthread-ensure-locality-of-task_struct-allocations.patch
fanotify-remove-useless-bypass_perm-check.patch
fanotify-use-fanotify-event-structure-for-permission-response-processing.patch
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

