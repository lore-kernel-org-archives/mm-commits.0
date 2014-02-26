From: akpm@linux-foundation.org
Subject: [wrecked]
 fanotify-use-fanotify-event-structure-for-permission-response-processing.patch removed from -mm tree
Date: Wed, 26 Feb 2014 12:48:33 -0800
Message-ID: <530e5321.VpxVkWAYx1yronYY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52094 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825AbaBZUsd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Feb 2014 15:48:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, eparis@redhat.com, jack@suse.cz

Subject: [wrecked] fanotify-use-fanotify-event-structure-for-permission-response-processing.patch removed from -mm tree
To: jack@suse.cz,eparis@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 26 Feb 2014 12:48:33 -0800


The patch titled
     Subject: fanotify: use fanotify event structure for permission response processing
has been removed from the -mm tree.  Its filename was
     fanotify-use-fanotify-event-structure-for-permission-response-processing.patch

This patch was dropped because other changes were merged, which wrecked this patch

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: fanotify: use fanotify event structure for permission response processing

Currently, fanotify creates new structure to track the fact that
permission event has been reported to userspace and someone is waiting for
a response to it.  As event structures are now completely in the hands of
each notification framework, we can use the event structure for this
tracking instead of allocating a new structure.

Since this makes the event structures for normal events and permission
events even more different and the structures have different lifetime
rules, we split them into two separate structures (where permission event
structure contains the structure for a normal event).  This makes normal
events 8 bytes smaller and the code a tad bit cleaner.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fanotify/fanotify.c      |   63 ++++++++++-----
 fs/notify/fanotify/fanotify.h      |   31 +++++--
 fs/notify/fanotify/fanotify_user.c |  113 +++++++++------------------
 3 files changed, 109 insertions(+), 98 deletions(-)

diff -puN fs/notify/fanotify/fanotify.c~fanotify-use-fanotify-event-structure-for-permission-response-processing fs/notify/fanotify/fanotify.c
--- a/fs/notify/fanotify/fanotify.c~fanotify-use-fanotify-event-structure-for-permission-response-processing
+++ a/fs/notify/fanotify/fanotify.c
@@ -60,8 +60,8 @@ static int fanotify_merge(struct list_he
 }
 
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
-static int fanotify_get_response_from_access(struct fsnotify_group *group,
-					     struct fanotify_event_info *event)
+static int fanotify_get_response(struct fsnotify_group *group,
+				 struct fanotify_perm_event_info *event)
 {
 	int ret;
 
@@ -142,6 +142,40 @@ static bool fanotify_should_send_event(s
 	return false;
 }
 
+static struct fanotify_event_info *alloc_event(struct inode *inode, u32 mask,
+					       struct path *path)
+{
+	struct fanotify_event_info *event;
+
+#ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
+	if (mask & FAN_ALL_PERM_EVENTS) {
+		struct fanotify_perm_event_info *pevent;
+
+		pevent = kmem_cache_alloc(fanotify_perm_event_cachep,
+					  GFP_KERNEL);
+		if (!pevent)
+			return NULL;
+		event = &pevent->fae;
+		pevent->response = 0;
+		goto init;
+	}
+#endif
+	event = kmem_cache_alloc(fanotify_event_cachep, GFP_KERNEL);
+	if (!event)
+		return NULL;
+init: __maybe_unused
+	fsnotify_init_event(&event->fse, inode, mask);
+	event->tgid = get_pid(task_tgid(current));
+	if (data_type == FSNOTIFY_EVENT_PATH) {
+		event->path = *path;
+		path_get(&event->path);
+	} else {
+		event->path.mnt = NULL;
+		event->path.dentry = NULL;
+	}
+	return event;
+}
+
 static int fanotify_handle_event(struct fsnotify_group *group,
 				 struct inode *inode,
 				 struct fsnotify_mark *inode_mark,
@@ -171,25 +205,11 @@ static int fanotify_handle_event(struct
 	pr_debug("%s: group=%p inode=%p mask=%x\n", __func__, group, inode,
 		 mask);
 
-	event = kmem_cache_alloc(fanotify_event_cachep, GFP_KERNEL);
+	event = alloc_event(inode, mask, data);
 	if (unlikely(!event))
 		return -ENOMEM;
 
 	fsn_event = &event->fse;
-	fsnotify_init_event(fsn_event, inode, mask);
-	event->tgid = get_pid(task_tgid(current));
-	if (data_type == FSNOTIFY_EVENT_PATH) {
-		struct path *path = data;
-		event->path = *path;
-		path_get(&event->path);
-	} else {
-		event->path.mnt = NULL;
-		event->path.dentry = NULL;
-	}
-#ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
-	event->response = 0;
-#endif
-
 	ret = fsnotify_add_notify_event(group, fsn_event, fanotify_merge);
 	if (ret) {
 		/* Permission events shouldn't be merged */
@@ -202,7 +222,7 @@ static int fanotify_handle_event(struct
 
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
 	if (mask & FAN_ALL_PERM_EVENTS) {
-		ret = fanotify_get_response_from_access(group, event);
+		ret = fanotify_get_response(group, FANOTIFY_PE(fsn_event));
 		fsnotify_destroy_event(group, fsn_event);
 	}
 #endif
@@ -225,6 +245,13 @@ static void fanotify_free_event(struct f
 	event = FANOTIFY_E(fsn_event);
 	path_put(&event->path);
 	put_pid(event->tgid);
+#ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
+	if (fsn_event->mask & FAN_ALL_PERM_EVENTS) {
+		kmem_cache_free(fanotify_perm_event_cachep,
+				FANOTIFY_PE(fsn_event));
+		return;
+	}
+#endif
 	kmem_cache_free(fanotify_event_cachep, event);
 }
 
diff -puN fs/notify/fanotify/fanotify.h~fanotify-use-fanotify-event-structure-for-permission-response-processing fs/notify/fanotify/fanotify.h
--- a/fs/notify/fanotify/fanotify.h~fanotify-use-fanotify-event-structure-for-permission-response-processing
+++ a/fs/notify/fanotify/fanotify.h
@@ -3,13 +3,12 @@
 #include <linux/slab.h>
 
 extern struct kmem_cache *fanotify_event_cachep;
+extern struct kmem_cache *fanotify_perm_event_cachep;
 
 /*
- * Lifetime of the structure differs for normal and permission events. In both
- * cases the structure is allocated in fanotify_handle_event(). For normal
- * events the structure is freed immediately after reporting it to userspace.
- * For permission events we free it only after we receive response from
- * userspace.
+ * Structure for normal fanotify events. It gets allocated in
+ * fanotify_handle_event() and freed when the information is retrieved by
+ * userspace
  */
 struct fanotify_event_info {
 	struct fsnotify_event fse;
@@ -19,11 +18,29 @@ struct fanotify_event_info {
 	 */
 	struct path path;
 	struct pid *tgid;
+};
+
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
-	u32 response;	/* userspace answer to question */
-#endif
+/*
+ * Structure for permission fanotify events. It gets allocated and freed in
+ * fanotify_handle_event() since we wait there for user response. When the
+ * information is retrieved by userspace the structure is moved from
+ * group->notification_list to group->fanotify_data.access_list to wait for
+ * user response.
+ */
+struct fanotify_perm_event_info {
+	struct fanotify_event_info fae;
+	int response;	/* userspace answer to question */
+	int fd;		/* fd we passed to userspace for this event */
 };
 
+static inline struct fanotify_perm_event_info *
+FANOTIFY_PE(struct fsnotify_event *fse)
+{
+	return container_of(fse, struct fanotify_perm_event_info, fae.fse);
+}
+#endif
+
 static inline struct fanotify_event_info *FANOTIFY_E(struct fsnotify_event *fse)
 {
 	return container_of(fse, struct fanotify_event_info, fse);
diff -puN fs/notify/fanotify/fanotify_user.c~fanotify-use-fanotify-event-structure-for-permission-response-processing fs/notify/fanotify/fanotify_user.c
--- a/fs/notify/fanotify/fanotify_user.c~fanotify-use-fanotify-event-structure-for-permission-response-processing
+++ a/fs/notify/fanotify/fanotify_user.c
@@ -28,14 +28,8 @@
 extern const struct fsnotify_ops fanotify_fsnotify_ops;
 
 static struct kmem_cache *fanotify_mark_cache __read_mostly;
-static struct kmem_cache *fanotify_response_event_cache __read_mostly;
 struct kmem_cache *fanotify_event_cachep __read_mostly;
-
-struct fanotify_response_event {
-	struct list_head list;
-	__s32 fd;
-	struct fanotify_event_info *event;
-};
+struct kmem_cache *fanotify_perm_event_cachep __read_mostly;
 
 /*
  * Get an fsnotify notification event if one exists and is small
@@ -135,33 +129,34 @@ static int fill_event_metadata(struct fs
 }
 
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
-static struct fanotify_response_event *dequeue_re(struct fsnotify_group *group,
-						  __s32 fd)
+static struct fanotify_perm_event_info *dequeue_event(
+				struct fsnotify_group *group, int fd)
 {
-	struct fanotify_response_event *re, *return_re = NULL;
+	struct fanotify_perm_event_info *event, *return_e = NULL;
 
 	mutex_lock(&group->fanotify_data.access_mutex);
-	list_for_each_entry(re, &group->fanotify_data.access_list, list) {
-		if (re->fd != fd)
+	list_for_each_entry(event, &group->fanotify_data.access_list,
+			    fae.fse.list) {
+		if (event->fd != fd)
 			continue;
 
-		list_del_init(&re->list);
-		return_re = re;
+		list_del_init(&event->fae.fse.list);
+		return_e = event;
 		break;
 	}
 	mutex_unlock(&group->fanotify_data.access_mutex);
 
-	pr_debug("%s: found return_re=%p\n", __func__, return_re);
+	pr_debug("%s: found return_re=%p\n", __func__, return_e);
 
-	return return_re;
+	return return_e;
 }
 
 static int process_access_response(struct fsnotify_group *group,
 				   struct fanotify_response *response_struct)
 {
-	struct fanotify_response_event *re;
-	__s32 fd = response_struct->fd;
-	__u32 response = response_struct->response;
+	struct fanotify_perm_event_info *event;
+	int fd = response_struct->fd;
+	int response = response_struct->response;
 
 	pr_debug("%s: group=%p fd=%d response=%d\n", __func__, group,
 		 fd, response);
@@ -181,50 +176,15 @@ static int process_access_response(struc
 	if (fd < 0)
 		return -EINVAL;
 
-	re = dequeue_re(group, fd);
-	if (!re)
+	event = dequeue_event(group, fd);
+	if (!event)
 		return -ENOENT;
 
-	re->event->response = response;
-
+	event->response = response;
 	wake_up(&group->fanotify_data.access_waitq);
 
-	kmem_cache_free(fanotify_response_event_cache, re);
-
-	return 0;
-}
-
-static int prepare_for_access_response(struct fsnotify_group *group,
-				       struct fsnotify_event *event,
-				       __s32 fd)
-{
-	struct fanotify_response_event *re;
-
-	if (!(event->mask & FAN_ALL_PERM_EVENTS))
-		return 0;
-
-	re = kmem_cache_alloc(fanotify_response_event_cache, GFP_KERNEL);
-	if (!re)
-		return -ENOMEM;
-
-	re->event = FANOTIFY_E(event);
-	re->fd = fd;
-
-	mutex_lock(&group->fanotify_data.access_mutex);
-	list_add_tail(&re->list, &group->fanotify_data.access_list);
-	mutex_unlock(&group->fanotify_data.access_mutex);
-
-	return 0;
-}
-
-#else
-static int prepare_for_access_response(struct fsnotify_group *group,
-				       struct fsnotify_event *event,
-				       __s32 fd)
-{
 	return 0;
 }
-
 #endif
 
 static ssize_t copy_event_to_user(struct fsnotify_group *group,
@@ -247,9 +207,15 @@ static ssize_t copy_event_to_user(struct
 			 fanotify_event_metadata.event_len))
 		goto out_close_fd;
 
-	ret = prepare_for_access_response(group, event, fd);
-	if (ret)
-		goto out_close_fd;
+#ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
+	if (event->mask & FAN_ALL_PERM_EVENTS) {
+		FANOTIFY_PE(event)->fd = fd;
+		mutex_lock(&group->fanotify_data.access_mutex);
+		list_add_tail(&event->fae.fse.list,
+			      &group->fanotify_data.access_list);
+		mutex_unlock(&group->fanotify_data.access_mutex);
+	}
+#endif
 
 	if (fd != FAN_NOFD)
 		fd_install(fd, f);
@@ -263,7 +229,7 @@ out_close_fd:
 out:
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
 	if (event->mask & FAN_ALL_PERM_EVENTS) {
-		FANOTIFY_E(event)->response = FAN_DENY;
+		FANOTIFY_PE(event)->response = FAN_DENY;
 		wake_up(&group->fanotify_data.access_waitq);
 	}
 #endif
@@ -312,8 +278,8 @@ static ssize_t fanotify_read(struct file
 				break;
 			ret = copy_event_to_user(group, kevent, buf);
 			/*
-			 * Permission events get destroyed after we
-			 * receive response
+			 * Permission events get queued to wait for response.
+			 * Other events can be destroyed now.
 			 */
 			if (!(kevent->mask & FAN_ALL_PERM_EVENTS))
 				fsnotify_destroy_event(group, kevent);
@@ -375,20 +341,19 @@ static int fanotify_release(struct inode
 	struct fsnotify_group *group = file->private_data;
 
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
-	struct fanotify_response_event *re, *lre;
+	struct fanotify_perm_event_info *event, *next;
 
 	mutex_lock(&group->fanotify_data.access_mutex);
 
 	atomic_inc(&group->fanotify_data.bypass_perm);
 
-	list_for_each_entry_safe(re, lre, &group->fanotify_data.access_list, list) {
-		pr_debug("%s: found group=%p re=%p event=%p\n", __func__, group,
-			 re, re->event);
-
-		list_del_init(&re->list);
-		re->event->response = FAN_ALLOW;
+	list_for_each_entry_safe(event, next, &group->fanotify_data.access_list,
+				 fae.fse.list) {
+		pr_debug("%s: found group=%p event=%p\n", __func__, group,
+			 event);
 
-		kmem_cache_free(fanotify_response_event_cache, re);
+		list_del_init(&event->fae.fse.list);
+		event->response = FAN_ALLOW;
 	}
 	mutex_unlock(&group->fanotify_data.access_mutex);
 
@@ -912,9 +877,11 @@ COMPAT_SYSCALL_DEFINE6(fanotify_mark,
 static int __init fanotify_user_setup(void)
 {
 	fanotify_mark_cache = KMEM_CACHE(fsnotify_mark, SLAB_PANIC);
-	fanotify_response_event_cache = KMEM_CACHE(fanotify_response_event,
-						   SLAB_PANIC);
 	fanotify_event_cachep = KMEM_CACHE(fanotify_event_info, SLAB_PANIC);
+#ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
+	fanotify_perm_event_cachep = KMEM_CACHE(fanotify_perm_event_info,
+						SLAB_PANIC);
+#endif
 
 	return 0;
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
fanotify-remove-useless-test-from-event-initialization.patch
fanotify-convert-access_mutex-to-spinlock.patch
fanotify-reorganize-loop-in-fanotify_read.patch
fanotify-move-unrelated-handling-from-copy_event_to_user.patch
mm-add-strictlimit-knob-v2.patch

