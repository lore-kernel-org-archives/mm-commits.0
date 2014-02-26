From: akpm@linux-foundation.org
Subject: [wrecked]
 fanotify-move-unrelated-handling-from-copy_event_to_user.patch removed from -mm tree
Date: Wed, 26 Feb 2014 12:48:41 -0800
Message-ID: <530e5329.BikYjTiyfbCyarXe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52106 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbaBZUsm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Feb 2014 15:48:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, eparis@redhat.com, jack@suse.cz

Subject: [wrecked] fanotify-move-unrelated-handling-from-copy_event_to_user.patch removed from -mm tree
To: jack@suse.cz,eparis@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 26 Feb 2014 12:48:41 -0800


The patch titled
     Subject: fanotify: move unrelated handling from copy_event_to_user()
has been removed from the -mm tree.  Its filename was
     fanotify-move-unrelated-handling-from-copy_event_to_user.patch

This patch was dropped because other changes were merged, which wrecked this patch

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: fanotify: move unrelated handling from copy_event_to_user()

Move code moving event structure to access_list from copy_event_to_user()
to fanotify_read() where it is more logical (so that we can immediately
see in the main loop that we either move the event to a different list or
free it).  Also move special error handling for permission events from
copy_event_to_user() to the main loop to have it in one place with error
handling for normal events.  This makes copy_event_to_user() really only
copy the event to user without any side effects.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fanotify/fanotify_user.c |   35 +++++++++++++--------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff -puN fs/notify/fanotify/fanotify_user.c~fanotify-move-unrelated-handling-from-copy_event_to_user fs/notify/fanotify/fanotify_user.c
--- a/fs/notify/fanotify/fanotify_user.c~fanotify-move-unrelated-handling-from-copy_event_to_user
+++ a/fs/notify/fanotify/fanotify_user.c
@@ -199,7 +199,7 @@ static ssize_t copy_event_to_user(struct
 
 	ret = fill_event_metadata(group, &fanotify_event_metadata, event, &f);
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	fd = fanotify_event_metadata.fd;
 	ret = -EFAULT;
@@ -208,13 +208,8 @@ static ssize_t copy_event_to_user(struct
 		goto out_close_fd;
 
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
-	if (event->mask & FAN_ALL_PERM_EVENTS) {
+	if (event->mask & FAN_ALL_PERM_EVENTS)
 		FANOTIFY_PE(event)->fd = fd;
-		spin_lock(&group->fanotify_data.access_lock);
-		list_add_tail(&event->fae.fse.list,
-			      &group->fanotify_data.access_list);
-		spin_unlock(&group->fanotify_data.access_lock);
-	}
 #endif
 
 	if (fd != FAN_NOFD)
@@ -226,13 +221,6 @@ out_close_fd:
 		put_unused_fd(fd);
 		fput(f);
 	}
-out:
-#ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
-	if (event->mask & FAN_ALL_PERM_EVENTS) {
-		FANOTIFY_PE(event)->response = FAN_DENY;
-		wake_up(&group->fanotify_data.access_waitq);
-	}
-#endif
 	return ret;
 }
 
@@ -297,10 +285,23 @@ static ssize_t fanotify_read(struct file
 		 * Permission events get queued to wait for response.  Other
 		 * events can be destroyed now.
 		 */
-		if (!(kevent->mask & FAN_ALL_PERM_EVENTS))
+		if (!(kevent->mask & FAN_ALL_PERM_EVENTS)) {
 			fsnotify_destroy_event(group, kevent);
-		if (ret < 0)
-			break;
+			if (ret < 0)
+				break;
+		} else {
+#ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
+			if (ret < 0) {
+				FANOTIFY_PE(kevent)->response = FAN_DENY;
+				wake_up(&group->fanotify_data.access_waitq);
+				break;
+			}
+			spin_lock(&group->fanotify_data.access_lock);
+			list_add_tail(&kevent->list,
+				      &group->fanotify_data.access_list);
+			spin_unlock(&group->fanotify_data.access_lock);
+#endif
+		}
 		buf += ret;
 		count -= ret;
 	}
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
mm-add-strictlimit-knob-v2.patch

