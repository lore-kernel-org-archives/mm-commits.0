From: akpm@linux-foundation.org
Subject: + ocfs2-implement-delayed-dropping-of-last-dquot-reference.patch
 added to -mm tree
Date: Fri, 21 Feb 2014 12:48:11 -0800
Message-ID: <5307bb8b.nS6X0wFD7+rhsbLo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58318 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744AbaBUUsM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Feb 2014 15:48:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, srinivas.eeda@oracle.com, rgoldwyn@suse.com, mfasheh@suse.com, jlbec@evilplan.org, jack@suse.cz

Subject: + ocfs2-implement-delayed-dropping-of-last-dquot-reference.patch added to -mm tree
To: jack@suse.cz,jlbec@evilplan.org,mfasheh@suse.com,rgoldwyn@suse.com,srinivas.eeda@oracle.com
From: akpm@linux-foundation.org
Date: Fri, 21 Feb 2014 12:48:11 -0800


The patch titled
     Subject: ocfs2: implement delayed dropping of last dquot reference
has been added to the -mm tree.  Its filename is
     ocfs2-implement-delayed-dropping-of-last-dquot-reference.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-implement-delayed-dropping-of-last-dquot-reference.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-implement-delayed-dropping-of-last-dquot-reference.patch

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
Subject: ocfs2: implement delayed dropping of last dquot reference

We cannot drop last dquot reference from downconvert thread as that
creates the following deadlock:

NODE 1                                  NODE2
holds dentry lock for 'foo'
holds inode lock for GLOBAL_BITMAP_SYSTEM_INODE
                                        dquot_initialize(bar)
                                          ocfs2_dquot_acquire()
                                            ocfs2_inode_lock(USER_QUOTA_SYSTEM_INODE)
                                            ...
downconvert thread (triggered from another
node or a different process from NODE2)
  ocfs2_dentry_post_unlock()
    ...
    iput(foo)
      ocfs2_evict_inode(foo)
        ocfs2_clear_inode(foo)
          dquot_drop(inode)
            ...
	    ocfs2_dquot_release()
              ocfs2_inode_lock(USER_QUOTA_SYSTEM_INODE)
               - blocks
                                            finds we need more space in
                                            quota file
                                            ...
                                            ocfs2_extend_no_holes()
                                              ocfs2_inode_lock(GLOBAL_BITMAP_SYSTEM_INODE)
                                                - deadlocks waiting for
                                                  downconvert thread

We solve the problem by postponing dropping of the last dquot reference
to a workqueue if it happens from the downconvert thread.

Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/ocfs2.h        |    5 +++++
 fs/ocfs2/quota.h        |    2 ++
 fs/ocfs2/quota_global.c |   35 +++++++++++++++++++++++++++++++++++
 fs/ocfs2/super.c        |    8 ++++++++
 4 files changed, 50 insertions(+)

diff -puN fs/ocfs2/ocfs2.h~ocfs2-implement-delayed-dropping-of-last-dquot-reference fs/ocfs2/ocfs2.h
--- a/fs/ocfs2/ocfs2.h~ocfs2-implement-delayed-dropping-of-last-dquot-reference
+++ a/fs/ocfs2/ocfs2.h
@@ -30,6 +30,7 @@
 #include <linux/sched.h>
 #include <linux/wait.h>
 #include <linux/list.h>
+#include <linux/llist.h>
 #include <linux/rbtree.h>
 #include <linux/workqueue.h>
 #include <linux/kref.h>
@@ -419,6 +420,10 @@ struct ocfs2_super
 	struct ocfs2_dentry_lock *dentry_lock_list;
 	struct work_struct dentry_lock_work;
 
+	/* List of dquot structures to drop last reference to */
+	struct llist_head dquot_drop_list;
+	struct work_struct dquot_drop_work;
+
 	wait_queue_head_t		osb_mount_event;
 
 	/* Truncate log info */
diff -puN fs/ocfs2/quota.h~ocfs2-implement-delayed-dropping-of-last-dquot-reference fs/ocfs2/quota.h
--- a/fs/ocfs2/quota.h~ocfs2-implement-delayed-dropping-of-last-dquot-reference
+++ a/fs/ocfs2/quota.h
@@ -28,6 +28,7 @@ struct ocfs2_dquot {
 	unsigned int dq_use_count;	/* Number of nodes having reference to this entry in global quota file */
 	s64 dq_origspace;	/* Last globally synced space usage */
 	s64 dq_originodes;	/* Last globally synced inode usage */
+	struct llist_node list;	/* Member of list of dquots to drop */
 };
 
 /* Description of one chunk to recover in memory */
@@ -110,6 +111,7 @@ int ocfs2_read_quota_phys_block(struct i
 int ocfs2_create_local_dquot(struct dquot *dquot);
 int ocfs2_local_release_dquot(handle_t *handle, struct dquot *dquot);
 int ocfs2_local_write_dquot(struct dquot *dquot);
+void ocfs2_drop_dquot_refs(struct work_struct *work);
 
 extern const struct dquot_operations ocfs2_quota_operations;
 extern struct quota_format_type ocfs2_quota_format;
diff -puN fs/ocfs2/quota_global.c~ocfs2-implement-delayed-dropping-of-last-dquot-reference fs/ocfs2/quota_global.c
--- a/fs/ocfs2/quota_global.c~ocfs2-implement-delayed-dropping-of-last-dquot-reference
+++ a/fs/ocfs2/quota_global.c
@@ -10,6 +10,7 @@
 #include <linux/jiffies.h>
 #include <linux/writeback.h>
 #include <linux/workqueue.h>
+#include <linux/llist.h>
 
 #include <cluster/masklog.h>
 
@@ -679,6 +680,27 @@ static int ocfs2_calc_qdel_credits(struc
 	       OCFS2_INODE_UPDATE_CREDITS;
 }
 
+void ocfs2_drop_dquot_refs(struct work_struct *work)
+{
+	struct ocfs2_super *osb = container_of(work, struct ocfs2_super,
+					       dquot_drop_work);
+	struct llist_node *list;
+	struct ocfs2_dquot *odquot, *next_odquot;
+
+	list = llist_del_all(&osb->dquot_drop_list);
+	llist_for_each_entry_safe(odquot, next_odquot, list, list) {
+		/* Drop the reference we acquired in ocfs2_dquot_release() */
+		dqput(&odquot->dq_dquot);
+	}
+}
+
+/*
+ * Called when the last reference to dquot is dropped. If we are called from
+ * downconvert thread, we cannot do all the handling here because grabbing
+ * quota lock could deadlock (the node holding the quota lock could need some
+ * other cluster lock to proceed but with blocked downconvert thread we cannot
+ * release any lock).
+ */
 static int ocfs2_release_dquot(struct dquot *dquot)
 {
 	handle_t *handle;
@@ -694,6 +716,19 @@ static int ocfs2_release_dquot(struct dq
 	/* Check whether we are not racing with some other dqget() */
 	if (atomic_read(&dquot->dq_count) > 1)
 		goto out;
+	/* Running from downconvert thread? Postpone quota processing to wq */
+	if (current == osb->dc_task) {
+		/*
+		 * Grab our own reference to dquot and queue it for delayed
+		 * dropping.  Quota code rechecks after calling
+		 * ->release_dquot() and won't free dquot structure.
+		 */
+		dqgrab(dquot);
+		/* First entry on list -> queue work */
+		if (llist_add(&OCFS2_DQUOT(dquot)->list, &osb->dquot_drop_list))
+			queue_work(ocfs2_wq, &osb->dquot_drop_work);
+		goto out;
+	}
 	status = ocfs2_lock_global_qf(oinfo, 1);
 	if (status < 0)
 		goto out;
diff -puN fs/ocfs2/super.c~ocfs2-implement-delayed-dropping-of-last-dquot-reference fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~ocfs2-implement-delayed-dropping-of-last-dquot-reference
+++ a/fs/ocfs2/super.c
@@ -1941,6 +1941,11 @@ static void ocfs2_dismount_volume(struct
 
 	ocfs2_disable_quotas(osb);
 
+	/* All dquots should be freed by now */
+	WARN_ON(!llist_empty(&osb->dquot_drop_list));
+	/* Wait for worker to be done with the work structure in osb */
+	cancel_work_sync(&osb->dquot_drop_work);
+
 	ocfs2_shutdown_local_alloc(osb);
 
 	/* This will disable recovery and flush any recovery work. */
@@ -2276,6 +2281,9 @@ static int ocfs2_initialize_super(struct
 	INIT_WORK(&osb->dentry_lock_work, ocfs2_drop_dl_inodes);
 	osb->dentry_lock_list = NULL;
 
+	INIT_WORK(&osb->dquot_drop_work, ocfs2_drop_dquot_refs);
+	init_llist_head(&osb->dquot_drop_list);
+
 	/* get some pseudo constants for clustersize bits */
 	osb->s_clustersize_bits =
 		le32_to_cpu(di->id2.i_super.s_clustersize_bits);
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

