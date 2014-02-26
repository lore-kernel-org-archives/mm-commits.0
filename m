From: akpm@linux-foundation.org
Subject: [wrecked] fanotify-convert-access_mutex-to-spinlock.patch removed from -mm tree
Date: Wed, 26 Feb 2014 12:48:37 -0800
Message-ID: <530e5325.4duAGuc8aBN52toC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52100 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbaBZUsh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Feb 2014 15:48:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, eparis@redhat.com, jack@suse.cz

Subject: [wrecked] fanotify-convert-access_mutex-to-spinlock.patch removed from -mm tree
To: jack@suse.cz,eparis@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 26 Feb 2014 12:48:37 -0800


The patch titled
     Subject: fanotify: convert access_mutex to spinlock
has been removed from the -mm tree.  Its filename was
     fanotify-convert-access_mutex-to-spinlock.patch

This patch was dropped because other changes were merged, which wrecked this patch

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: fanotify: convert access_mutex to spinlock

access_mutex is used only to guard operations on access_list.  There's no
need for sleeping within this lock so just make a spinlock out of it.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fanotify/fanotify_user.c |   14 +++++++-------
 include/linux/fsnotify_backend.h   |    2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff -puN fs/notify/fanotify/fanotify_user.c~fanotify-convert-access_mutex-to-spinlock fs/notify/fanotify/fanotify_user.c
--- a/fs/notify/fanotify/fanotify_user.c~fanotify-convert-access_mutex-to-spinlock
+++ a/fs/notify/fanotify/fanotify_user.c
@@ -134,7 +134,7 @@ static struct fanotify_perm_event_info *
 {
 	struct fanotify_perm_event_info *event, *return_e = NULL;
 
-	mutex_lock(&group->fanotify_data.access_mutex);
+	spin_lock(&group->fanotify_data.access_lock);
 	list_for_each_entry(event, &group->fanotify_data.access_list,
 			    fae.fse.list) {
 		if (event->fd != fd)
@@ -144,7 +144,7 @@ static struct fanotify_perm_event_info *
 		return_e = event;
 		break;
 	}
-	mutex_unlock(&group->fanotify_data.access_mutex);
+	spin_unlock(&group->fanotify_data.access_lock);
 
 	pr_debug("%s: found return_re=%p\n", __func__, return_e);
 
@@ -210,10 +210,10 @@ static ssize_t copy_event_to_user(struct
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
 	if (event->mask & FAN_ALL_PERM_EVENTS) {
 		FANOTIFY_PE(event)->fd = fd;
-		mutex_lock(&group->fanotify_data.access_mutex);
+		spin_lock(&group->fanotify_data.access_lock);
 		list_add_tail(&event->fae.fse.list,
 			      &group->fanotify_data.access_list);
-		mutex_unlock(&group->fanotify_data.access_mutex);
+		spin_unlock(&group->fanotify_data.access_lock);
 	}
 #endif
 
@@ -343,7 +343,7 @@ static int fanotify_release(struct inode
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
 	struct fanotify_perm_event_info *event, *next;
 
-	mutex_lock(&group->fanotify_data.access_mutex);
+	spin_lock(&group->fanotify_data.access_lock);
 
 	atomic_inc(&group->fanotify_data.bypass_perm);
 
@@ -355,7 +355,7 @@ static int fanotify_release(struct inode
 		list_del_init(&event->fae.fse.list);
 		event->response = FAN_ALLOW;
 	}
-	mutex_unlock(&group->fanotify_data.access_mutex);
+	spin_unlock(&group->fanotify_data.access_lock);
 
 	wake_up(&group->fanotify_data.access_waitq);
 #endif
@@ -702,7 +702,7 @@ SYSCALL_DEFINE2(fanotify_init, unsigned
 	group->fanotify_data.f_flags = event_f_flags;
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
 	oevent->response = 0;
-	mutex_init(&group->fanotify_data.access_mutex);
+	spin_lock_init(&group->fanotify_data.access_lock);
 	init_waitqueue_head(&group->fanotify_data.access_waitq);
 	INIT_LIST_HEAD(&group->fanotify_data.access_list);
 	atomic_set(&group->fanotify_data.bypass_perm, 0);
diff -puN include/linux/fsnotify_backend.h~fanotify-convert-access_mutex-to-spinlock include/linux/fsnotify_backend.h
--- a/include/linux/fsnotify_backend.h~fanotify-convert-access_mutex-to-spinlock
+++ a/include/linux/fsnotify_backend.h
@@ -178,7 +178,7 @@ struct fsnotify_group {
 		struct fanotify_group_private_data {
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
 			/* allows a group to block waiting for a userspace response */
-			struct mutex access_mutex;
+			spinlock_t access_lock;
 			struct list_head access_list;
 			wait_queue_head_t access_waitq;
 			atomic_t bypass_perm;
_

Patches currently in -mm which might be from jack@suse.cz are

ocfs2-fix-quota-file-corruption.patch
backing_dev-fix-hung-task-on-sync.patch
kthread-ensure-locality-of-task_struct-allocations.patch
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
fanotify-reorganize-loop-in-fanotify_read.patch
fanotify-move-unrelated-handling-from-copy_event_to_user.patch
mm-add-strictlimit-knob-v2.patch

