From: akpm@linux-foundation.org
Subject: + fsnotify-do-not-share-events-between-notification-groups.patch
 added to -mm tree
Date: Wed, 11 Dec 2013 13:51:19 -0800
Message-ID: <52a8de57.ZQlK8H8IrMaOg8tW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49807 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab3LKVvU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Dec 2013 16:51:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, hch@lst.de, eparis@parisplace.org, jack@suse.cz

Subject: + fsnotify-do-not-share-events-between-notification-groups.patch added to -mm tree
To: jack@suse.cz,eparis@parisplace.org,hch@lst.de,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Wed, 11 Dec 2013 13:51:19 -0800


The patch titled
     Subject: fsnotify: do not share events between notification groups
has been added to the -mm tree.  Its filename is
     fsnotify-do-not-share-events-between-notification-groups.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fsnotify-do-not-share-events-between-notification-groups.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fsnotify-do-not-share-events-between-notification-groups.patch

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
Subject: fsnotify: do not share events between notification groups

Currently fsnotify framework creates one event structure for each
notification event and links this event into all interested notification
groups.  This is done so that we save memory when several notification
groups are interested in the event.  However the need for event structure
shared between inotify & fanotify bloats the event structure so the result
is often higher memory consumption.

Another problem is that fsnotify framework keeps path references with
outstanding events so that fanotify can return open file descriptors with
its events.  This has the undesirable effect that filesystem cannot be
unmounted while there are outstanding events - a regression for inotify
compared to a situation before it was converted to fsnotify framework. 
For fanotify this problem is hard to avoid and users of fanotify should
kind of expect this behavior when they ask for file descriptors from
notified files.

This patch changes fsnotify and its users to create separate event
structure for each group.  This allows for much simpler code (~400 lines
removed by this patch) and also smaller event structures.  For example on
64-bit system original struct fsnotify_event consumes 120 bytes, plus
additional space for file name, additional 24 bytes for second and each
subsequent group linking the event, and additional 32 bytes for each
inotify group for private data.  After the conversion inotify event
consumes 48 bytes plus space for file name which is considerably less
memory unless file names are long and there are several groups interested
in the events (both of which are uncommon).  Fanotify event fits in 56
bytes after the conversion (fanotify doesn't care about file names so its
events don't have to have it allocated).  A win unless there are four or
more fanotify groups interested in the event.

The conversion also solves the problem with unmount when only inotify is
used as we don't have to grab path references for inotify events.

Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Eric Paris <eparis@parisplace.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/dnotify/dnotify.c          |   11 
 fs/notify/fanotify/fanotify.c        |  206 +++++++--------
 fs/notify/fanotify/fanotify.h        |   23 +
 fs/notify/fanotify/fanotify_user.c   |   41 +--
 fs/notify/fsnotify.c                 |   37 --
 fs/notify/group.c                    |    1 
 fs/notify/inotify/inotify.h          |   21 +
 fs/notify/inotify/inotify_fsnotify.c |  125 +++------
 fs/notify/inotify/inotify_user.c     |   86 +-----
 fs/notify/notification.c             |  334 ++-----------------------
 include/linux/fsnotify_backend.h     |  114 ++------
 kernel/audit_tree.c                  |    8 
 kernel/audit_watch.c                 |   14 -
 13 files changed, 314 insertions(+), 707 deletions(-)

diff -puN fs/notify/dnotify/dnotify.c~fsnotify-do-not-share-events-between-notification-groups fs/notify/dnotify/dnotify.c
--- a/fs/notify/dnotify/dnotify.c~fsnotify-do-not-share-events-between-notification-groups
+++ a/fs/notify/dnotify/dnotify.c
@@ -82,21 +82,20 @@ static void dnotify_recalc_inode_mask(st
  * events.
  */
 static int dnotify_handle_event(struct fsnotify_group *group,
+				struct inode *inode,
 				struct fsnotify_mark *inode_mark,
 				struct fsnotify_mark *vfsmount_mark,
-				struct fsnotify_event *event)
+				u32 mask, void *data, int data_type,
+				const unsigned char *file_name)
 {
 	struct dnotify_mark *dn_mark;
-	struct inode *to_tell;
 	struct dnotify_struct *dn;
 	struct dnotify_struct **prev;
 	struct fown_struct *fown;
-	__u32 test_mask = event->mask & ~FS_EVENT_ON_CHILD;
+	__u32 test_mask = mask & ~FS_EVENT_ON_CHILD;
 
 	BUG_ON(vfsmount_mark);
 
-	to_tell = event->to_tell;
-
 	dn_mark = container_of(inode_mark, struct dnotify_mark, fsn_mark);
 
 	spin_lock(&inode_mark->lock);
@@ -155,7 +154,7 @@ static struct fsnotify_ops dnotify_fsnot
 	.should_send_event = dnotify_should_send_event,
 	.free_group_priv = NULL,
 	.freeing_mark = NULL,
-	.free_event_priv = NULL,
+	.free_event = NULL,
 };
 
 /*
diff -puN fs/notify/fanotify/fanotify.c~fsnotify-do-not-share-events-between-notification-groups fs/notify/fanotify/fanotify.c
--- a/fs/notify/fanotify/fanotify.c~fsnotify-do-not-share-events-between-notification-groups
+++ a/fs/notify/fanotify/fanotify.c
@@ -9,31 +9,27 @@
 #include <linux/types.h>
 #include <linux/wait.h>
 
-static bool should_merge(struct fsnotify_event *old, struct fsnotify_event *new)
+#include "fanotify.h"
+
+static bool should_merge(struct fsnotify_event *old_fsn,
+			 struct fsnotify_event *new_fsn)
 {
-	pr_debug("%s: old=%p new=%p\n", __func__, old, new);
+	struct fanotify_event_info *old, *new;
 
-	if (old->to_tell == new->to_tell &&
-	    old->data_type == new->data_type &&
-	    old->tgid == new->tgid) {
-		switch (old->data_type) {
-		case (FSNOTIFY_EVENT_PATH):
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
-			/* dont merge two permission events */
-			if ((old->mask & FAN_ALL_PERM_EVENTS) &&
-			    (new->mask & FAN_ALL_PERM_EVENTS))
-				return false;
+	/* dont merge two permission events */
+	if ((old_fsn->mask & FAN_ALL_PERM_EVENTS) &&
+	    (new_fsn->mask & FAN_ALL_PERM_EVENTS))
+		return false;
 #endif
-			if ((old->path.mnt == new->path.mnt) &&
-			    (old->path.dentry == new->path.dentry))
-				return true;
-			break;
-		case (FSNOTIFY_EVENT_NONE):
-			return true;
-		default:
-			BUG();
-		};
-	}
+	pr_debug("%s: old=%p new=%p\n", __func__, old_fsn, new_fsn);
+	old = FANOTIFY_E(old_fsn);
+	new = FANOTIFY_E(new_fsn);
+
+	if (old_fsn->inode == new_fsn->inode && old->tgid == new->tgid &&
+	    old->path.mnt == new->path.mnt &&
+	    old->path.dentry == new->path.dentry)
+		return true;
 	return false;
 }
 
@@ -41,59 +37,25 @@ static bool should_merge(struct fsnotify
 static struct fsnotify_event *fanotify_merge(struct list_head *list,
 					     struct fsnotify_event *event)
 {
-	struct fsnotify_event_holder *test_holder;
 	struct fsnotify_event *test_event = NULL;
-	struct fsnotify_event *new_event;
 
 	pr_debug("%s: list=%p event=%p\n", __func__, list, event);
 
-
-	list_for_each_entry_reverse(test_holder, list, event_list) {
-		if (should_merge(test_holder->event, event)) {
-			test_event = test_holder->event;
+	list_for_each_entry_reverse(test_event, list, list) {
+		if (should_merge(test_event, event))
 			break;
-		}
 	}
 
 	if (!test_event)
 		return NULL;
 
-	fsnotify_get_event(test_event);
-
-	/* if they are exactly the same we are done */
-	if (test_event->mask == event->mask)
-		return test_event;
-
-	/*
-	 * if the refcnt == 2 this is the only queue
-	 * for this event and so we can update the mask
-	 * in place.
-	 */
-	if (atomic_read(&test_event->refcnt) == 2) {
-		test_event->mask |= event->mask;
-		return test_event;
-	}
-
-	new_event = fsnotify_clone_event(test_event);
-
-	/* done with test_event */
-	fsnotify_put_event(test_event);
-
-	/* couldn't allocate memory, merge was not possible */
-	if (unlikely(!new_event))
-		return ERR_PTR(-ENOMEM);
-
-	/* build new event and replace it on the list */
-	new_event->mask = (test_event->mask | event->mask);
-	fsnotify_replace_event(test_holder, new_event);
-
-	/* we hold a reference on new_event from clone_event */
-	return new_event;
+	test_event->mask |= event->mask;
+	return test_event;
 }
 
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
 static int fanotify_get_response_from_access(struct fsnotify_group *group,
-					     struct fsnotify_event *event)
+					     struct fanotify_event_info *event)
 {
 	int ret;
 
@@ -106,7 +68,6 @@ static int fanotify_get_response_from_ac
 		return 0;
 
 	/* userspace responded, convert to something usable */
-	spin_lock(&event->lock);
 	switch (event->response) {
 	case FAN_ALLOW:
 		ret = 0;
@@ -116,7 +77,6 @@ static int fanotify_get_response_from_ac
 		ret = -EPERM;
 	}
 	event->response = 0;
-	spin_unlock(&event->lock);
 
 	pr_debug("%s: group=%p event=%p about to return ret=%d\n", __func__,
 		 group, event, ret);
@@ -125,48 +85,8 @@ static int fanotify_get_response_from_ac
 }
 #endif
 
-static int fanotify_handle_event(struct fsnotify_group *group,
-				 struct fsnotify_mark *inode_mark,
-				 struct fsnotify_mark *fanotify_mark,
-				 struct fsnotify_event *event)
-{
-	int ret = 0;
-	struct fsnotify_event *notify_event = NULL;
-
-	BUILD_BUG_ON(FAN_ACCESS != FS_ACCESS);
-	BUILD_BUG_ON(FAN_MODIFY != FS_MODIFY);
-	BUILD_BUG_ON(FAN_CLOSE_NOWRITE != FS_CLOSE_NOWRITE);
-	BUILD_BUG_ON(FAN_CLOSE_WRITE != FS_CLOSE_WRITE);
-	BUILD_BUG_ON(FAN_OPEN != FS_OPEN);
-	BUILD_BUG_ON(FAN_EVENT_ON_CHILD != FS_EVENT_ON_CHILD);
-	BUILD_BUG_ON(FAN_Q_OVERFLOW != FS_Q_OVERFLOW);
-	BUILD_BUG_ON(FAN_OPEN_PERM != FS_OPEN_PERM);
-	BUILD_BUG_ON(FAN_ACCESS_PERM != FS_ACCESS_PERM);
-	BUILD_BUG_ON(FAN_ONDIR != FS_ISDIR);
-
-	pr_debug("%s: group=%p event=%p\n", __func__, group, event);
-
-	notify_event = fsnotify_add_notify_event(group, event, NULL, fanotify_merge);
-	if (IS_ERR(notify_event))
-		return PTR_ERR(notify_event);
-
-#ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
-	if (event->mask & FAN_ALL_PERM_EVENTS) {
-		/* if we merged we need to wait on the new event */
-		if (notify_event)
-			event = notify_event;
-		ret = fanotify_get_response_from_access(group, event);
-	}
-#endif
-
-	if (notify_event)
-		fsnotify_put_event(notify_event);
-
-	return ret;
-}
-
 static bool fanotify_should_send_event(struct fsnotify_group *group,
-				       struct inode *to_tell,
+				       struct inode *inode,
 				       struct fsnotify_mark *inode_mark,
 				       struct fsnotify_mark *vfsmnt_mark,
 				       __u32 event_mask, void *data, int data_type)
@@ -174,8 +94,8 @@ static bool fanotify_should_send_event(s
 	__u32 marks_mask, marks_ignored_mask;
 	struct path *path = data;
 
-	pr_debug("%s: group=%p to_tell=%p inode_mark=%p vfsmnt_mark=%p "
-		 "mask=%x data=%p data_type=%d\n", __func__, group, to_tell,
+	pr_debug("%s: group=%p inode=%p inode_mark=%p vfsmnt_mark=%p "
+		 "mask=%x data=%p data_type=%d\n", __func__, group, inode,
 		 inode_mark, vfsmnt_mark, event_mask, data, data_type);
 
 	/* if we don't have enough info to send an event to userspace say no */
@@ -217,6 +137,70 @@ static bool fanotify_should_send_event(s
 	return false;
 }
 
+static int fanotify_handle_event(struct fsnotify_group *group,
+				 struct inode *inode,
+				 struct fsnotify_mark *inode_mark,
+				 struct fsnotify_mark *fanotify_mark,
+				 u32 mask, void *data, int data_type,
+				 const unsigned char *file_name)
+{
+	int ret = 0;
+	struct fanotify_event_info *event;
+	struct fsnotify_event *fsn_event;
+	struct fsnotify_event *notify_fsn_event;
+
+	BUILD_BUG_ON(FAN_ACCESS != FS_ACCESS);
+	BUILD_BUG_ON(FAN_MODIFY != FS_MODIFY);
+	BUILD_BUG_ON(FAN_CLOSE_NOWRITE != FS_CLOSE_NOWRITE);
+	BUILD_BUG_ON(FAN_CLOSE_WRITE != FS_CLOSE_WRITE);
+	BUILD_BUG_ON(FAN_OPEN != FS_OPEN);
+	BUILD_BUG_ON(FAN_EVENT_ON_CHILD != FS_EVENT_ON_CHILD);
+	BUILD_BUG_ON(FAN_Q_OVERFLOW != FS_Q_OVERFLOW);
+	BUILD_BUG_ON(FAN_OPEN_PERM != FS_OPEN_PERM);
+	BUILD_BUG_ON(FAN_ACCESS_PERM != FS_ACCESS_PERM);
+	BUILD_BUG_ON(FAN_ONDIR != FS_ISDIR);
+
+	pr_debug("%s: group=%p inode=%p mask=%x\n", __func__, group, inode,
+		 mask);
+
+	event = kmem_cache_alloc(fanotify_event_cachep, GFP_KERNEL);
+	if (unlikely(!event))
+		return -ENOMEM;
+
+	fsn_event = &event->fse;
+	fsnotify_init_event(fsn_event, inode, mask);
+	event->tgid = get_pid(task_tgid(current));
+	if (data_type == FSNOTIFY_EVENT_PATH) {
+		struct path *path = data;
+		event->path = *path;
+		path_get(&event->path);
+	} else {
+		event->path.mnt = NULL;
+		event->path.dentry = NULL;
+	}
+#ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
+	event->response = 0;
+#endif
+
+	notify_fsn_event = fsnotify_add_notify_event(group, fsn_event,
+						     fanotify_merge);
+	if (notify_fsn_event) {
+		/* Our event wasn't used in the end. Free it. */
+		fsnotify_destroy_event(group, fsn_event);
+		if (IS_ERR(notify_fsn_event))
+			return PTR_ERR(notify_fsn_event);
+		/* We need to ask about a different events after a merge... */
+		event = FANOTIFY_E(notify_fsn_event);
+		fsn_event = notify_fsn_event;
+	}
+
+#ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
+	if (fsn_event->mask & FAN_ALL_PERM_EVENTS)
+		ret = fanotify_get_response_from_access(group, event);
+#endif
+	return ret;
+}
+
 static void fanotify_free_group_priv(struct fsnotify_group *group)
 {
 	struct user_struct *user;
@@ -226,10 +210,20 @@ static void fanotify_free_group_priv(str
 	free_uid(user);
 }
 
+static void fanotify_free_event(struct fsnotify_event *fsn_event)
+{
+	struct fanotify_event_info *event;
+
+	event = FANOTIFY_E(fsn_event);
+	path_put(&event->path);
+	put_pid(event->tgid);
+	kmem_cache_free(fanotify_event_cachep, event);
+}
+
 const struct fsnotify_ops fanotify_fsnotify_ops = {
 	.handle_event = fanotify_handle_event,
 	.should_send_event = fanotify_should_send_event,
 	.free_group_priv = fanotify_free_group_priv,
-	.free_event_priv = NULL,
+	.free_event = fanotify_free_event,
 	.freeing_mark = NULL,
 };
diff -puN /dev/null fs/notify/fanotify/fanotify.h
--- /dev/null
+++ a/fs/notify/fanotify/fanotify.h
@@ -0,0 +1,23 @@
+#include <linux/fsnotify_backend.h>
+#include <linux/path.h>
+#include <linux/slab.h>
+
+extern struct kmem_cache *fanotify_event_cachep;
+
+struct fanotify_event_info {
+	struct fsnotify_event fse;
+	/*
+	 * We hold ref to this path so it may be dereferenced at any point
+	 * during this object's lifetime
+	 */
+	struct path path;
+	struct pid *tgid;
+#ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
+	u32 response;	/* userspace answer to question */
+#endif
+};
+
+static inline struct fanotify_event_info *FANOTIFY_E(struct fsnotify_event *fse)
+{
+	return container_of(fse, struct fanotify_event_info, fse);
+}
diff -puN fs/notify/fanotify/fanotify_user.c~fsnotify-do-not-share-events-between-notification-groups fs/notify/fanotify/fanotify_user.c
--- a/fs/notify/fanotify/fanotify_user.c~fsnotify-do-not-share-events-between-notification-groups
+++ a/fs/notify/fanotify/fanotify_user.c
@@ -19,6 +19,7 @@
 
 #include "../../mount.h"
 #include "../fdinfo.h"
+#include "fanotify.h"
 
 #define FANOTIFY_DEFAULT_MAX_EVENTS	16384
 #define FANOTIFY_DEFAULT_MAX_MARKS	8192
@@ -28,11 +29,12 @@ extern const struct fsnotify_ops fanotif
 
 static struct kmem_cache *fanotify_mark_cache __read_mostly;
 static struct kmem_cache *fanotify_response_event_cache __read_mostly;
+struct kmem_cache *fanotify_event_cachep __read_mostly;
 
 struct fanotify_response_event {
 	struct list_head list;
 	__s32 fd;
-	struct fsnotify_event *event;
+	struct fanotify_event_info *event;
 };
 
 /*
@@ -61,8 +63,8 @@ static struct fsnotify_event *get_one_ev
 }
 
 static int create_fd(struct fsnotify_group *group,
-			struct fsnotify_event *event,
-			struct file **file)
+		     struct fanotify_event_info *event,
+		     struct file **file)
 {
 	int client_fd;
 	struct file *new_file;
@@ -73,12 +75,6 @@ static int create_fd(struct fsnotify_gro
 	if (client_fd < 0)
 		return client_fd;
 
-	if (event->data_type != FSNOTIFY_EVENT_PATH) {
-		WARN_ON(1);
-		put_unused_fd(client_fd);
-		return -EINVAL;
-	}
-
 	/*
 	 * we need a new file handle for the userspace program so it can read even if it was
 	 * originally opened O_WRONLY.
@@ -109,23 +105,25 @@ static int create_fd(struct fsnotify_gro
 }
 
 static int fill_event_metadata(struct fsnotify_group *group,
-				   struct fanotify_event_metadata *metadata,
-				   struct fsnotify_event *event,
-				   struct file **file)
+			       struct fanotify_event_metadata *metadata,
+			       struct fsnotify_event *fsn_event,
+			       struct file **file)
 {
 	int ret = 0;
+	struct fanotify_event_info *event;
 
 	pr_debug("%s: group=%p metadata=%p event=%p\n", __func__,
-		 group, metadata, event);
+		 group, metadata, fsn_event);
 
 	*file = NULL;
+	event = container_of(fsn_event, struct fanotify_event_info, fse);
 	metadata->event_len = FAN_EVENT_METADATA_LEN;
 	metadata->metadata_len = FAN_EVENT_METADATA_LEN;
 	metadata->vers = FANOTIFY_METADATA_VERSION;
 	metadata->reserved = 0;
-	metadata->mask = event->mask & FAN_ALL_OUTGOING_EVENTS;
+	metadata->mask = fsn_event->mask & FAN_ALL_OUTGOING_EVENTS;
 	metadata->pid = pid_vnr(event->tgid);
-	if (unlikely(event->mask & FAN_Q_OVERFLOW))
+	if (unlikely(fsn_event->mask & FAN_Q_OVERFLOW))
 		metadata->fd = FAN_NOFD;
 	else {
 		metadata->fd = create_fd(group, event, file);
@@ -209,7 +207,7 @@ static int prepare_for_access_response(s
 	if (!re)
 		return -ENOMEM;
 
-	re->event = event;
+	re->event = FANOTIFY_E(event);
 	re->fd = fd;
 
 	mutex_lock(&group->fanotify_data.access_mutex);
@@ -217,7 +215,7 @@ static int prepare_for_access_response(s
 	if (atomic_read(&group->fanotify_data.bypass_perm)) {
 		mutex_unlock(&group->fanotify_data.access_mutex);
 		kmem_cache_free(fanotify_response_event_cache, re);
-		event->response = FAN_ALLOW;
+		FANOTIFY_E(event)->response = FAN_ALLOW;
 		return 0;
 	}
 		
@@ -273,7 +271,7 @@ out_close_fd:
 out:
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
 	if (event->mask & FAN_ALL_PERM_EVENTS) {
-		event->response = FAN_DENY;
+		FANOTIFY_E(event)->response = FAN_DENY;
 		wake_up(&group->fanotify_data.access_waitq);
 	}
 #endif
@@ -321,7 +319,7 @@ static ssize_t fanotify_read(struct file
 			if (IS_ERR(kevent))
 				break;
 			ret = copy_event_to_user(group, kevent, buf);
-			fsnotify_put_event(kevent);
+			fsnotify_destroy_event(group, kevent);
 			if (ret < 0)
 				break;
 			buf += ret;
@@ -409,7 +407,7 @@ static int fanotify_release(struct inode
 static long fanotify_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct fsnotify_group *group;
-	struct fsnotify_event_holder *holder;
+	struct fsnotify_event *fsn_event;
 	void __user *p;
 	int ret = -ENOTTY;
 	size_t send_len = 0;
@@ -421,7 +419,7 @@ static long fanotify_ioctl(struct file *
 	switch (cmd) {
 	case FIONREAD:
 		mutex_lock(&group->notification_mutex);
-		list_for_each_entry(holder, &group->notification_list, event_list)
+		list_for_each_entry(fsn_event, &group->notification_list, list)
 			send_len += FAN_EVENT_METADATA_LEN;
 		mutex_unlock(&group->notification_mutex);
 		ret = put_user(send_len, (int __user *) p);
@@ -906,6 +904,7 @@ static int __init fanotify_user_setup(vo
 	fanotify_mark_cache = KMEM_CACHE(fsnotify_mark, SLAB_PANIC);
 	fanotify_response_event_cache = KMEM_CACHE(fanotify_response_event,
 						   SLAB_PANIC);
+	fanotify_event_cachep = KMEM_CACHE(fanotify_event_info, SLAB_PANIC);
 
 	return 0;
 }
diff -puN fs/notify/fsnotify.c~fsnotify-do-not-share-events-between-notification-groups fs/notify/fsnotify.c
--- a/fs/notify/fsnotify.c~fsnotify-do-not-share-events-between-notification-groups
+++ a/fs/notify/fsnotify.c
@@ -128,8 +128,7 @@ static int send_to_group(struct inode *t
 			 struct fsnotify_mark *vfsmount_mark,
 			 __u32 mask, void *data,
 			 int data_is, u32 cookie,
-			 const unsigned char *file_name,
-			 struct fsnotify_event **event)
+			 const unsigned char *file_name)
 {
 	struct fsnotify_group *group = NULL;
 	__u32 inode_test_mask = 0;
@@ -170,10 +169,10 @@ static int send_to_group(struct inode *t
 
 	pr_debug("%s: group=%p to_tell=%p mask=%x inode_mark=%p"
 		 " inode_test_mask=%x vfsmount_mark=%p vfsmount_test_mask=%x"
-		 " data=%p data_is=%d cookie=%d event=%p\n",
+		 " data=%p data_is=%d cookie=%d\n",
 		 __func__, group, to_tell, mask, inode_mark,
 		 inode_test_mask, vfsmount_mark, vfsmount_test_mask, data,
-		 data_is, cookie, *event);
+		 data_is, cookie);
 
 	if (!inode_test_mask && !vfsmount_test_mask)
 		return 0;
@@ -183,14 +182,9 @@ static int send_to_group(struct inode *t
 					  data_is) == false)
 		return 0;
 
-	if (!*event) {
-		*event = fsnotify_create_event(to_tell, mask, data,
-						data_is, file_name,
-						cookie, GFP_KERNEL);
-		if (!*event)
-			return -ENOMEM;
-	}
-	return group->ops->handle_event(group, inode_mark, vfsmount_mark, *event);
+	return group->ops->handle_event(group, to_tell, inode_mark,
+					vfsmount_mark, mask, data, data_is,
+					file_name);
 }
 
 /*
@@ -205,7 +199,6 @@ int fsnotify(struct inode *to_tell, __u3
 	struct hlist_node *inode_node = NULL, *vfsmount_node = NULL;
 	struct fsnotify_mark *inode_mark = NULL, *vfsmount_mark = NULL;
 	struct fsnotify_group *inode_group, *vfsmount_group;
-	struct fsnotify_event *event = NULL;
 	struct mount *mnt;
 	int idx, ret = 0;
 	/* global tests shouldn't care about events on child only the specific event */
@@ -258,18 +251,18 @@ int fsnotify(struct inode *to_tell, __u3
 
 		if (inode_group > vfsmount_group) {
 			/* handle inode */
-			ret = send_to_group(to_tell, inode_mark, NULL, mask, data,
-					    data_is, cookie, file_name, &event);
+			ret = send_to_group(to_tell, inode_mark, NULL, mask,
+					    data, data_is, cookie, file_name);
 			/* we didn't use the vfsmount_mark */
 			vfsmount_group = NULL;
 		} else if (vfsmount_group > inode_group) {
-			ret = send_to_group(to_tell, NULL, vfsmount_mark, mask, data,
-					    data_is, cookie, file_name, &event);
+			ret = send_to_group(to_tell, NULL, vfsmount_mark, mask,
+					    data, data_is, cookie, file_name);
 			inode_group = NULL;
 		} else {
 			ret = send_to_group(to_tell, inode_mark, vfsmount_mark,
-					    mask, data, data_is, cookie, file_name,
-					    &event);
+					    mask, data, data_is, cookie,
+					    file_name);
 		}
 
 		if (ret && (mask & ALL_FSNOTIFY_PERM_EVENTS))
@@ -285,12 +278,6 @@ int fsnotify(struct inode *to_tell, __u3
 	ret = 0;
 out:
 	srcu_read_unlock(&fsnotify_mark_srcu, idx);
-	/*
-	 * fsnotify_create_event() took a reference so the event can't be cleaned
-	 * up while we are still trying to add it to lists, drop that one.
-	 */
-	if (event)
-		fsnotify_put_event(event);
 
 	return ret;
 }
diff -puN fs/notify/group.c~fsnotify-do-not-share-events-between-notification-groups fs/notify/group.c
--- a/fs/notify/group.c~fsnotify-do-not-share-events-between-notification-groups
+++ a/fs/notify/group.c
@@ -99,6 +99,7 @@ struct fsnotify_group *fsnotify_alloc_gr
 	INIT_LIST_HEAD(&group->marks_list);
 
 	group->ops = ops;
+	fsnotify_init_event(&group->overflow_event, NULL, FS_Q_OVERFLOW);
 
 	return group;
 }
diff -puN fs/notify/inotify/inotify.h~fsnotify-do-not-share-events-between-notification-groups fs/notify/inotify/inotify.h
--- a/fs/notify/inotify/inotify.h~fsnotify-do-not-share-events-between-notification-groups
+++ a/fs/notify/inotify/inotify.h
@@ -2,11 +2,12 @@
 #include <linux/inotify.h>
 #include <linux/slab.h> /* struct kmem_cache */
 
-extern struct kmem_cache *event_priv_cachep;
-
-struct inotify_event_private_data {
-	struct fsnotify_event_private_data fsnotify_event_priv_data;
+struct inotify_event_info {
+	struct fsnotify_event fse;
 	int wd;
+	u32 sync_cookie;
+	int name_len;
+	char name[];
 };
 
 struct inotify_inode_mark {
@@ -14,8 +15,18 @@ struct inotify_inode_mark {
 	int wd;
 };
 
+static inline struct inotify_event_info *INOTIFY_E(struct fsnotify_event *fse)
+{
+	return container_of(fse, struct inotify_event_info, fse);
+}
+
 extern void inotify_ignored_and_remove_idr(struct fsnotify_mark *fsn_mark,
 					   struct fsnotify_group *group);
-extern void inotify_free_event_priv(struct fsnotify_event_private_data *event_priv);
+extern int inotify_handle_event(struct fsnotify_group *group,
+				struct inode *inode,
+				struct fsnotify_mark *inode_mark,
+				struct fsnotify_mark *vfsmount_mark,
+				u32 mask, void *data, int data_type,
+				const unsigned char *file_name);
 
 extern const struct fsnotify_ops inotify_fsnotify_ops;
diff -puN fs/notify/inotify/inotify_fsnotify.c~fsnotify-do-not-share-events-between-notification-groups fs/notify/inotify/inotify_fsnotify.c
--- a/fs/notify/inotify/inotify_fsnotify.c~fsnotify-do-not-share-events-between-notification-groups
+++ a/fs/notify/inotify/inotify_fsnotify.c
@@ -34,100 +34,80 @@
 #include "inotify.h"
 
 /*
- * Check if 2 events contain the same information.  We do not compare private data
- * but at this moment that isn't a problem for any know fsnotify listeners.
+ * Check if 2 events contain the same information.
  */
-static bool event_compare(struct fsnotify_event *old, struct fsnotify_event *new)
+static bool event_compare(struct fsnotify_event *old_fsn,
+			  struct fsnotify_event *new_fsn)
 {
-	if ((old->mask == new->mask) &&
-	    (old->to_tell == new->to_tell) &&
-	    (old->data_type == new->data_type) &&
-	    (old->name_len == new->name_len)) {
-		switch (old->data_type) {
-		case (FSNOTIFY_EVENT_INODE):
-			/* remember, after old was put on the wait_q we aren't
-			 * allowed to look at the inode any more, only thing
-			 * left to check was if the file_name is the same */
-			if (!old->name_len ||
-			    !strcmp(old->file_name, new->file_name))
-				return true;
-			break;
-		case (FSNOTIFY_EVENT_PATH):
-			if ((old->path.mnt == new->path.mnt) &&
-			    (old->path.dentry == new->path.dentry))
-				return true;
-			break;
-		case (FSNOTIFY_EVENT_NONE):
-			if (old->mask & FS_Q_OVERFLOW)
-				return true;
-			else if (old->mask & FS_IN_IGNORED)
-				return false;
-			return true;
-		};
-	}
+	struct inotify_event_info *old, *new;
+
+	if (old_fsn->mask & FS_IN_IGNORED)
+		return false;
+	old = INOTIFY_E(old_fsn);
+	new = INOTIFY_E(new_fsn);
+	if ((old_fsn->mask == new_fsn->mask) &&
+	    (old_fsn->inode == new_fsn->inode) &&
+	    (old->name_len == new->name_len) &&
+	    (!old->name_len || !strcmp(old->name, new->name)))
+		return true;
 	return false;
 }
 
 static struct fsnotify_event *inotify_merge(struct list_head *list,
 					    struct fsnotify_event *event)
 {
-	struct fsnotify_event_holder *last_holder;
 	struct fsnotify_event *last_event;
 
-	/* and the list better be locked by something too */
-	spin_lock(&event->lock);
-
-	last_holder = list_entry(list->prev, struct fsnotify_event_holder, event_list);
-	last_event = last_holder->event;
-	if (event_compare(last_event, event))
-		fsnotify_get_event(last_event);
-	else
-		last_event = NULL;
-
-	spin_unlock(&event->lock);
-
+	last_event = list_entry(list->prev, struct fsnotify_event, list);
+	if (!event_compare(last_event, event))
+		return NULL;
 	return last_event;
 }
 
-static int inotify_handle_event(struct fsnotify_group *group,
-				struct fsnotify_mark *inode_mark,
-				struct fsnotify_mark *vfsmount_mark,
-				struct fsnotify_event *event)
+int inotify_handle_event(struct fsnotify_group *group,
+			 struct inode *inode,
+			 struct fsnotify_mark *inode_mark,
+			 struct fsnotify_mark *vfsmount_mark,
+			 u32 mask, void *data, int data_type,
+			 const unsigned char *file_name)
 {
 	struct inotify_inode_mark *i_mark;
-	struct inode *to_tell;
-	struct inotify_event_private_data *event_priv;
-	struct fsnotify_event_private_data *fsn_event_priv;
+	struct inotify_event_info *event;
 	struct fsnotify_event *added_event;
-	int wd, ret = 0;
+	struct fsnotify_event *fsn_event;
+	int ret = 0;
+	int len = 0;
+	int alloc_len = sizeof(struct inotify_event_info);
 
 	BUG_ON(vfsmount_mark);
 
-	pr_debug("%s: group=%p event=%p to_tell=%p mask=%x\n", __func__, group,
-		 event, event->to_tell, event->mask);
+	if (file_name) {
+		len = strlen(file_name);
+		alloc_len += len + 1;
+	}
 
-	to_tell = event->to_tell;
+	pr_debug("%s: group=%p inode=%p mask=%x\n", __func__, group, inode,
+		 mask);
 
 	i_mark = container_of(inode_mark, struct inotify_inode_mark,
 			      fsn_mark);
-	wd = i_mark->wd;
 
-	event_priv = kmem_cache_alloc(event_priv_cachep, GFP_KERNEL);
-	if (unlikely(!event_priv))
+	event = kmalloc(alloc_len, GFP_KERNEL);
+	if (unlikely(!event))
 		return -ENOMEM;
 
-	fsn_event_priv = &event_priv->fsnotify_event_priv_data;
-
-	fsnotify_get_group(group);
-	fsn_event_priv->group = group;
-	event_priv->wd = wd;
+	fsn_event = &event->fse;
+	fsnotify_init_event(fsn_event, inode, mask);
+	event->wd = i_mark->wd;
+	event->name_len = len;
+	if (len)
+		strcpy(event->name, file_name);
 
-	added_event = fsnotify_add_notify_event(group, event, fsn_event_priv, inotify_merge);
+	added_event = fsnotify_add_notify_event(group, fsn_event, inotify_merge);
 	if (added_event) {
-		inotify_free_event_priv(fsn_event_priv);
-		if (!IS_ERR(added_event))
-			fsnotify_put_event(added_event);
-		else
+		/* Our event wasn't used in the end. Free it. */
+		fsnotify_destroy_event(group, fsn_event);
+		if (IS_ERR(added_event))
 			ret = PTR_ERR(added_event);
 	}
 
@@ -202,22 +182,15 @@ static void inotify_free_group_priv(stru
 	free_uid(group->inotify_data.user);
 }
 
-void inotify_free_event_priv(struct fsnotify_event_private_data *fsn_event_priv)
+static void inotify_free_event(struct fsnotify_event *fsn_event)
 {
-	struct inotify_event_private_data *event_priv;
-
-
-	event_priv = container_of(fsn_event_priv, struct inotify_event_private_data,
-				  fsnotify_event_priv_data);
-
-	fsnotify_put_group(fsn_event_priv->group);
-	kmem_cache_free(event_priv_cachep, event_priv);
+	kfree(INOTIFY_E(fsn_event));
 }
 
 const struct fsnotify_ops inotify_fsnotify_ops = {
 	.handle_event = inotify_handle_event,
 	.should_send_event = inotify_should_send_event,
 	.free_group_priv = inotify_free_group_priv,
-	.free_event_priv = inotify_free_event_priv,
+	.free_event = inotify_free_event,
 	.freeing_mark = inotify_freeing_mark,
 };
diff -puN fs/notify/inotify/inotify_user.c~fsnotify-do-not-share-events-between-notification-groups fs/notify/inotify/inotify_user.c
--- a/fs/notify/inotify/inotify_user.c~fsnotify-do-not-share-events-between-notification-groups
+++ a/fs/notify/inotify/inotify_user.c
@@ -50,7 +50,6 @@ static int inotify_max_queued_events __r
 static int inotify_max_user_watches __read_mostly;
 
 static struct kmem_cache *inotify_inode_mark_cachep __read_mostly;
-struct kmem_cache *event_priv_cachep __read_mostly;
 
 #ifdef CONFIG_SYSCTL
 
@@ -124,8 +123,11 @@ static unsigned int inotify_poll(struct
 	return ret;
 }
 
-static int round_event_name_len(struct fsnotify_event *event)
+static int round_event_name_len(struct fsnotify_event *fsn_event)
 {
+	struct inotify_event_info *event;
+
+	event = INOTIFY_E(fsn_event);
 	if (!event->name_len)
 		return 0;
 	return roundup(event->name_len + 1, sizeof(struct inotify_event));
@@ -169,40 +171,27 @@ static struct fsnotify_event *get_one_ev
  * buffer we had in "get_one_event()" above.
  */
 static ssize_t copy_event_to_user(struct fsnotify_group *group,
-				  struct fsnotify_event *event,
+				  struct fsnotify_event *fsn_event,
 				  char __user *buf)
 {
 	struct inotify_event inotify_event;
-	struct fsnotify_event_private_data *fsn_priv;
-	struct inotify_event_private_data *priv;
+	struct inotify_event_info *event;
 	size_t event_size = sizeof(struct inotify_event);
 	size_t name_len;
 	size_t pad_name_len;
 
-	pr_debug("%s: group=%p event=%p\n", __func__, group, event);
-
-	/* we get the inotify watch descriptor from the event private data */
-	spin_lock(&event->lock);
-	fsn_priv = fsnotify_remove_priv_from_event(group, event);
-	spin_unlock(&event->lock);
-
-	if (!fsn_priv)
-		inotify_event.wd = -1;
-	else {
-		priv = container_of(fsn_priv, struct inotify_event_private_data,
-				    fsnotify_event_priv_data);
-		inotify_event.wd = priv->wd;
-		inotify_free_event_priv(fsn_priv);
-	}
+	pr_debug("%s: group=%p event=%p\n", __func__, group, fsn_event);
 
+	event = INOTIFY_E(fsn_event);
 	name_len = event->name_len;
 	/*
 	 * round up name length so it is a multiple of event_size
 	 * plus an extra byte for the terminating '\0'.
 	 */
-	pad_name_len = round_event_name_len(event);
+	pad_name_len = round_event_name_len(fsn_event);
 	inotify_event.len = pad_name_len;
-	inotify_event.mask = inotify_mask_to_arg(event->mask);
+	inotify_event.mask = inotify_mask_to_arg(fsn_event->mask);
+	inotify_event.wd = event->wd;
 	inotify_event.cookie = event->sync_cookie;
 
 	/* send the main event */
@@ -218,7 +207,7 @@ static ssize_t copy_event_to_user(struct
 	 */
 	if (pad_name_len) {
 		/* copy the path name */
-		if (copy_to_user(buf, event->file_name, name_len))
+		if (copy_to_user(buf, event->name, name_len))
 			return -EFAULT;
 		buf += name_len;
 
@@ -257,7 +246,7 @@ static ssize_t inotify_read(struct file
 			if (IS_ERR(kevent))
 				break;
 			ret = copy_event_to_user(group, kevent, buf);
-			fsnotify_put_event(kevent);
+			fsnotify_destroy_event(group, kevent);
 			if (ret < 0)
 				break;
 			buf += ret;
@@ -300,8 +289,7 @@ static long inotify_ioctl(struct file *f
 			  unsigned long arg)
 {
 	struct fsnotify_group *group;
-	struct fsnotify_event_holder *holder;
-	struct fsnotify_event *event;
+	struct fsnotify_event *fsn_event;
 	void __user *p;
 	int ret = -ENOTTY;
 	size_t send_len = 0;
@@ -314,10 +302,10 @@ static long inotify_ioctl(struct file *f
 	switch (cmd) {
 	case FIONREAD:
 		mutex_lock(&group->notification_mutex);
-		list_for_each_entry(holder, &group->notification_list, event_list) {
-			event = holder->event;
+		list_for_each_entry(fsn_event, &group->notification_list,
+				    list) {
 			send_len += sizeof(struct inotify_event);
-			send_len += round_event_name_len(event);
+			send_len += round_event_name_len(fsn_event);
 		}
 		mutex_unlock(&group->notification_mutex);
 		ret = put_user(send_len, (int __user *) p);
@@ -504,43 +492,12 @@ void inotify_ignored_and_remove_idr(stru
 				    struct fsnotify_group *group)
 {
 	struct inotify_inode_mark *i_mark;
-	struct fsnotify_event *ignored_event, *notify_event;
-	struct inotify_event_private_data *event_priv;
-	struct fsnotify_event_private_data *fsn_event_priv;
-	int ret;
-
-	i_mark = container_of(fsn_mark, struct inotify_inode_mark, fsn_mark);
 
-	ignored_event = fsnotify_create_event(NULL, FS_IN_IGNORED, NULL,
-					      FSNOTIFY_EVENT_NONE, NULL, 0,
-					      GFP_NOFS);
-	if (!ignored_event)
-		goto skip_send_ignore;
-
-	event_priv = kmem_cache_alloc(event_priv_cachep, GFP_NOFS);
-	if (unlikely(!event_priv))
-		goto skip_send_ignore;
-
-	fsn_event_priv = &event_priv->fsnotify_event_priv_data;
-
-	fsnotify_get_group(group);
-	fsn_event_priv->group = group;
-	event_priv->wd = i_mark->wd;
-
-	notify_event = fsnotify_add_notify_event(group, ignored_event, fsn_event_priv, NULL);
-	if (notify_event) {
-		if (IS_ERR(notify_event))
-			ret = PTR_ERR(notify_event);
-		else
-			fsnotify_put_event(notify_event);
-		inotify_free_event_priv(fsn_event_priv);
-	}
-
-skip_send_ignore:
-	/* matches the reference taken when the event was created */
-	if (ignored_event)
-		fsnotify_put_event(ignored_event);
+	/* Queue ignore event for the watch */
+	inotify_handle_event(group, NULL, fsn_mark, NULL, FS_IN_IGNORED,
+			     NULL, FSNOTIFY_EVENT_NONE, NULL);
 
+	i_mark = container_of(fsn_mark, struct inotify_inode_mark, fsn_mark);
 	/* remove this mark from the idr */
 	inotify_remove_from_idr(group, i_mark);
 
@@ -837,7 +794,6 @@ static int __init inotify_user_setup(voi
 	BUG_ON(hweight32(ALL_INOTIFY_BITS) != 21);
 
 	inotify_inode_mark_cachep = KMEM_CACHE(inotify_inode_mark, SLAB_PANIC);
-	event_priv_cachep = KMEM_CACHE(inotify_event_private_data, SLAB_PANIC);
 
 	inotify_max_queued_events = 16384;
 	inotify_max_user_instances = 128;
diff -puN fs/notify/notification.c~fsnotify-do-not-share-events-between-notification-groups fs/notify/notification.c
--- a/fs/notify/notification.c~fsnotify-do-not-share-events-between-notification-groups
+++ a/fs/notify/notification.c
@@ -48,15 +48,6 @@
 #include <linux/fsnotify_backend.h>
 #include "fsnotify.h"
 
-static struct kmem_cache *fsnotify_event_cachep;
-static struct kmem_cache *fsnotify_event_holder_cachep;
-/*
- * This is a magic event we send when the q is too full.  Since it doesn't
- * hold real event information we just keep one system wide and use it any time
- * it is needed.  It's refcnt is set 1 at kernel init time and will never
- * get set to 0 so it will never get 'freed'
- */
-static struct fsnotify_event *q_overflow_event;
 static atomic_t fsnotify_sync_cookie = ATOMIC_INIT(0);
 
 /**
@@ -76,60 +67,14 @@ bool fsnotify_notify_queue_is_empty(stru
 	return list_empty(&group->notification_list) ? true : false;
 }
 
-void fsnotify_get_event(struct fsnotify_event *event)
-{
-	atomic_inc(&event->refcnt);
-}
-
-void fsnotify_put_event(struct fsnotify_event *event)
+void fsnotify_destroy_event(struct fsnotify_group *group,
+			    struct fsnotify_event *event)
 {
-	if (!event)
+	/* Overflow events are per-group and we don't want to free them */
+	if (!event || event->mask == FS_Q_OVERFLOW)
 		return;
 
-	if (atomic_dec_and_test(&event->refcnt)) {
-		pr_debug("%s: event=%p\n", __func__, event);
-
-		if (event->data_type == FSNOTIFY_EVENT_PATH)
-			path_put(&event->path);
-
-		BUG_ON(!list_empty(&event->private_data_list));
-
-		kfree(event->file_name);
-		put_pid(event->tgid);
-		kmem_cache_free(fsnotify_event_cachep, event);
-	}
-}
-
-struct fsnotify_event_holder *fsnotify_alloc_event_holder(void)
-{
-	return kmem_cache_alloc(fsnotify_event_holder_cachep, GFP_KERNEL);
-}
-
-void fsnotify_destroy_event_holder(struct fsnotify_event_holder *holder)
-{
-	if (holder)
-		kmem_cache_free(fsnotify_event_holder_cachep, holder);
-}
-
-/*
- * Find the private data that the group previously attached to this event when
- * the group added the event to the notification queue (fsnotify_add_notify_event)
- */
-struct fsnotify_event_private_data *fsnotify_remove_priv_from_event(struct fsnotify_group *group, struct fsnotify_event *event)
-{
-	struct fsnotify_event_private_data *lpriv;
-	struct fsnotify_event_private_data *priv = NULL;
-
-	assert_spin_locked(&event->lock);
-
-	list_for_each_entry(lpriv, &event->private_data_list, event_list) {
-		if (lpriv->group == group) {
-			priv = lpriv;
-			list_del(&priv->event_list);
-			break;
-		}
-	}
-	return priv;
+	group->ops->free_event(event);
 }
 
 /*
@@ -137,91 +82,35 @@ struct fsnotify_event_private_data *fsno
  * event off the queue to deal with.  If the event is successfully added to the
  * group's notification queue, a reference is taken on event.
  */
-struct fsnotify_event *fsnotify_add_notify_event(struct fsnotify_group *group, struct fsnotify_event *event,
-						 struct fsnotify_event_private_data *priv,
+struct fsnotify_event *fsnotify_add_notify_event(struct fsnotify_group *group,
+						 struct fsnotify_event *event,
 						 struct fsnotify_event *(*merge)(struct list_head *,
 										 struct fsnotify_event *))
 {
 	struct fsnotify_event *return_event = NULL;
-	struct fsnotify_event_holder *holder = NULL;
 	struct list_head *list = &group->notification_list;
 
-	pr_debug("%s: group=%p event=%p priv=%p\n", __func__, group, event, priv);
-
-	/*
-	 * There is one fsnotify_event_holder embedded inside each fsnotify_event.
-	 * Check if we expect to be able to use that holder.  If not alloc a new
-	 * holder.
-	 * For the overflow event it's possible that something will use the in
-	 * event holder before we get the lock so we may need to jump back and
-	 * alloc a new holder, this can't happen for most events...
-	 */
-	if (!list_empty(&event->holder.event_list)) {
-alloc_holder:
-		holder = fsnotify_alloc_event_holder();
-		if (!holder)
-			return ERR_PTR(-ENOMEM);
-	}
+	pr_debug("%s: group=%p event=%p\n", __func__, group, event);
 
 	mutex_lock(&group->notification_mutex);
 
 	if (group->q_len >= group->max_events) {
-		event = q_overflow_event;
-
-		/*
-		 * we need to return the overflow event
-		 * which means we need a ref
-		 */
-		fsnotify_get_event(event);
+		/* Queue overflow event only if it isn't already queued */
+		if (list_empty(&group->overflow_event.list))
+			event = &group->overflow_event;
 		return_event = event;
-
-		/* sorry, no private data on the overflow event */
-		priv = NULL;
 	}
 
 	if (!list_empty(list) && merge) {
-		struct fsnotify_event *tmp;
-
-		tmp = merge(list, event);
-		if (tmp) {
-			mutex_unlock(&group->notification_mutex);
-
-			if (return_event)
-				fsnotify_put_event(return_event);
-			if (holder != &event->holder)
-				fsnotify_destroy_event_holder(holder);
-			return tmp;
-		}
-	}
-
-	spin_lock(&event->lock);
-
-	if (list_empty(&event->holder.event_list)) {
-		if (unlikely(holder))
-			fsnotify_destroy_event_holder(holder);
-		holder = &event->holder;
-	} else if (unlikely(!holder)) {
-		/* between the time we checked above and got the lock the in
-		 * event holder was used, go back and get a new one */
-		spin_unlock(&event->lock);
-		mutex_unlock(&group->notification_mutex);
-
+		return_event = merge(list, event);
 		if (return_event) {
-			fsnotify_put_event(return_event);
-			return_event = NULL;
+			mutex_unlock(&group->notification_mutex);
+			return return_event;
 		}
-
-		goto alloc_holder;
 	}
 
 	group->q_len++;
-	holder->event = event;
-
-	fsnotify_get_event(event);
-	list_add_tail(&holder->event_list, list);
-	if (priv)
-		list_add_tail(&priv->event_list, &event->private_data_list);
-	spin_unlock(&event->lock);
+	list_add_tail(&event->list, list);
 	mutex_unlock(&group->notification_mutex);
 
 	wake_up(&group->notification_waitq);
@@ -230,32 +119,20 @@ alloc_holder:
 }
 
 /*
- * Remove and return the first event from the notification list.  There is a
- * reference held on this event since it was on the list.  It is the responsibility
- * of the caller to drop this reference.
+ * Remove and return the first event from the notification list.  It is the
+ * responsibility of the caller to destroy the obtained event
  */
 struct fsnotify_event *fsnotify_remove_notify_event(struct fsnotify_group *group)
 {
 	struct fsnotify_event *event;
-	struct fsnotify_event_holder *holder;
 
 	BUG_ON(!mutex_is_locked(&group->notification_mutex));
 
 	pr_debug("%s: group=%p\n", __func__, group);
 
-	holder = list_first_entry(&group->notification_list, struct fsnotify_event_holder, event_list);
-
-	event = holder->event;
-
-	spin_lock(&event->lock);
-	holder->event = NULL;
-	list_del_init(&holder->event_list);
-	spin_unlock(&event->lock);
-
-	/* event == holder means we are referenced through the in event holder */
-	if (holder != &event->holder)
-		fsnotify_destroy_event_holder(holder);
-
+	event = list_first_entry(&group->notification_list,
+				 struct fsnotify_event, list);
+	list_del(&event->list);
 	group->q_len--;
 
 	return event;
@@ -266,15 +143,10 @@ struct fsnotify_event *fsnotify_remove_n
  */
 struct fsnotify_event *fsnotify_peek_notify_event(struct fsnotify_group *group)
 {
-	struct fsnotify_event *event;
-	struct fsnotify_event_holder *holder;
-
 	BUG_ON(!mutex_is_locked(&group->notification_mutex));
 
-	holder = list_first_entry(&group->notification_list, struct fsnotify_event_holder, event_list);
-	event = holder->event;
-
-	return event;
+	return list_first_entry(&group->notification_list,
+				struct fsnotify_event, list);
 }
 
 /*
@@ -284,181 +156,31 @@ struct fsnotify_event *fsnotify_peek_not
 void fsnotify_flush_notify(struct fsnotify_group *group)
 {
 	struct fsnotify_event *event;
-	struct fsnotify_event_private_data *priv;
 
 	mutex_lock(&group->notification_mutex);
 	while (!fsnotify_notify_queue_is_empty(group)) {
 		event = fsnotify_remove_notify_event(group);
-		/* if they don't implement free_event_priv they better not have attached any */
-		if (group->ops->free_event_priv) {
-			spin_lock(&event->lock);
-			priv = fsnotify_remove_priv_from_event(group, event);
-			spin_unlock(&event->lock);
-			if (priv)
-				group->ops->free_event_priv(priv);
-		}
-		fsnotify_put_event(event); /* matches fsnotify_add_notify_event */
+		fsnotify_destroy_event(group, event);
 	}
 	mutex_unlock(&group->notification_mutex);
 }
 
-static void initialize_event(struct fsnotify_event *event)
-{
-	INIT_LIST_HEAD(&event->holder.event_list);
-	atomic_set(&event->refcnt, 1);
-
-	spin_lock_init(&event->lock);
-
-	INIT_LIST_HEAD(&event->private_data_list);
-}
-
-/*
- * Caller damn well better be holding whatever mutex is protecting the
- * old_holder->event_list and the new_event must be a clean event which
- * cannot be found anywhere else in the kernel.
- */
-int fsnotify_replace_event(struct fsnotify_event_holder *old_holder,
-			   struct fsnotify_event *new_event)
-{
-	struct fsnotify_event *old_event = old_holder->event;
-	struct fsnotify_event_holder *new_holder = &new_event->holder;
-
-	enum event_spinlock_class {
-		SPINLOCK_OLD,
-		SPINLOCK_NEW,
-	};
-
-	pr_debug("%s: old_event=%p new_event=%p\n", __func__, old_event, new_event);
-
-	/*
-	 * if the new_event's embedded holder is in use someone
-	 * screwed up and didn't give us a clean new event.
-	 */
-	BUG_ON(!list_empty(&new_holder->event_list));
-
-	spin_lock_nested(&old_event->lock, SPINLOCK_OLD);
-	spin_lock_nested(&new_event->lock, SPINLOCK_NEW);
-
-	new_holder->event = new_event;
-	list_replace_init(&old_holder->event_list, &new_holder->event_list);
-
-	spin_unlock(&new_event->lock);
-	spin_unlock(&old_event->lock);
-
-	/* event == holder means we are referenced through the in event holder */
-	if (old_holder != &old_event->holder)
-		fsnotify_destroy_event_holder(old_holder);
-
-	fsnotify_get_event(new_event); /* on the list take reference */
-	fsnotify_put_event(old_event); /* off the list, drop reference */
-
-	return 0;
-}
-
-struct fsnotify_event *fsnotify_clone_event(struct fsnotify_event *old_event)
-{
-	struct fsnotify_event *event;
-
-	event = kmem_cache_alloc(fsnotify_event_cachep, GFP_KERNEL);
-	if (!event)
-		return NULL;
-
-	pr_debug("%s: old_event=%p new_event=%p\n", __func__, old_event, event);
-
-	memcpy(event, old_event, sizeof(*event));
-	initialize_event(event);
-
-	if (event->name_len) {
-		event->file_name = kstrdup(old_event->file_name, GFP_KERNEL);
-		if (!event->file_name) {
-			kmem_cache_free(fsnotify_event_cachep, event);
-			return NULL;
-		}
-	}
-	event->tgid = get_pid(old_event->tgid);
-	if (event->data_type == FSNOTIFY_EVENT_PATH)
-		path_get(&event->path);
-
-	return event;
-}
-
 /*
  * fsnotify_create_event - Allocate a new event which will be sent to each
  * group's handle_event function if the group was interested in this
  * particular event.
  *
- * @to_tell the inode which is supposed to receive the event (sometimes a
+ * @inode the inode which is supposed to receive the event (sometimes a
  *	parent of the inode to which the event happened.
  * @mask what actually happened.
  * @data pointer to the object which was actually affected
  * @data_type flag indication if the data is a file, path, inode, nothing...
  * @name the filename, if available
  */
-struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask, void *data,
-					     int data_type, const unsigned char *name,
-					     u32 cookie, gfp_t gfp)
+void fsnotify_init_event(struct fsnotify_event *event, struct inode *inode,
+			 u32 mask)
 {
-	struct fsnotify_event *event;
-
-	event = kmem_cache_zalloc(fsnotify_event_cachep, gfp);
-	if (!event)
-		return NULL;
-
-	pr_debug("%s: event=%p to_tell=%p mask=%x data=%p data_type=%d\n",
-		 __func__, event, to_tell, mask, data, data_type);
-
-	initialize_event(event);
-
-	if (name) {
-		event->file_name = kstrdup(name, gfp);
-		if (!event->file_name) {
-			kmem_cache_free(fsnotify_event_cachep, event);
-			return NULL;
-		}
-		event->name_len = strlen(event->file_name);
-	}
-
-	event->tgid = get_pid(task_tgid(current));
-	event->sync_cookie = cookie;
-	event->to_tell = to_tell;
-	event->data_type = data_type;
-
-	switch (data_type) {
-	case FSNOTIFY_EVENT_PATH: {
-		struct path *path = data;
-		event->path.dentry = path->dentry;
-		event->path.mnt = path->mnt;
-		path_get(&event->path);
-		break;
-	}
-	case FSNOTIFY_EVENT_INODE:
-		event->inode = data;
-		break;
-	case FSNOTIFY_EVENT_NONE:
-		event->inode = NULL;
-		event->path.dentry = NULL;
-		event->path.mnt = NULL;
-		break;
-	default:
-		BUG();
-	}
-
+	INIT_LIST_HEAD(&event->list);
+	event->inode = inode;
 	event->mask = mask;
-
-	return event;
-}
-
-static __init int fsnotify_notification_init(void)
-{
-	fsnotify_event_cachep = KMEM_CACHE(fsnotify_event, SLAB_PANIC);
-	fsnotify_event_holder_cachep = KMEM_CACHE(fsnotify_event_holder, SLAB_PANIC);
-
-	q_overflow_event = fsnotify_create_event(NULL, FS_Q_OVERFLOW, NULL,
-						 FSNOTIFY_EVENT_NONE, NULL, 0,
-						 GFP_KERNEL);
-	if (!q_overflow_event)
-		panic("unable to allocate fsnotify q_overflow_event\n");
-
-	return 0;
 }
-subsys_initcall(fsnotify_notification_init);
diff -puN include/linux/fsnotify_backend.h~fsnotify-do-not-share-events-between-notification-groups include/linux/fsnotify_backend.h
--- a/include/linux/fsnotify_backend.h~fsnotify-do-not-share-events-between-notification-groups
+++ a/include/linux/fsnotify_backend.h
@@ -15,7 +15,6 @@
 #include <linux/path.h> /* struct path */
 #include <linux/spinlock.h>
 #include <linux/types.h>
-
 #include <linux/atomic.h>
 
 /*
@@ -79,6 +78,7 @@ struct fsnotify_group;
 struct fsnotify_event;
 struct fsnotify_mark;
 struct fsnotify_event_private_data;
+struct fsnotify_fname;
 
 /*
  * Each group much define these ops.  The fsnotify infrastructure will call
@@ -99,12 +99,26 @@ struct fsnotify_ops {
 				  struct fsnotify_mark *vfsmount_mark,
 				  __u32 mask, void *data, int data_type);
 	int (*handle_event)(struct fsnotify_group *group,
+			    struct inode *inode,
 			    struct fsnotify_mark *inode_mark,
 			    struct fsnotify_mark *vfsmount_mark,
-			    struct fsnotify_event *event);
+			    u32 mask, void *data, int data_type,
+			    const unsigned char *file_name);
 	void (*free_group_priv)(struct fsnotify_group *group);
 	void (*freeing_mark)(struct fsnotify_mark *mark, struct fsnotify_group *group);
-	void (*free_event_priv)(struct fsnotify_event_private_data *priv);
+	void (*free_event)(struct fsnotify_event *event);
+};
+
+/*
+ * all of the information about the original object we want to now send to
+ * a group.  If you want to carry more info from the accessing task to the
+ * listener this structure is where you need to be adding fields.
+ */
+struct fsnotify_event {
+	struct list_head list;
+	/* inode may ONLY be dereferenced during handle_event(). */
+	struct inode *inode;	/* either the inode the event happened to or its parent */
+	u32 mask;		/* the type of access, bitwise OR for FS_* event types */
 };
 
 /*
@@ -148,7 +162,11 @@ struct fsnotify_group {
 					 * a group */
 	struct list_head marks_list;	/* all inode marks for this group */
 
-	struct fasync_struct    *fsn_fa;    /* async notification */
+	struct fasync_struct *fsn_fa;    /* async notification */
+
+	struct fsnotify_event overflow_event;	/* Event we queue when the
+						 * notification list is too
+						 * full */
 
 	/* groups can define private fields here or use the void *private */
 	union {
@@ -177,76 +195,10 @@ struct fsnotify_group {
 	};
 };
 
-/*
- * A single event can be queued in multiple group->notification_lists.
- *
- * each group->notification_list will point to an event_holder which in turns points
- * to the actual event that needs to be sent to userspace.
- *
- * Seemed cheaper to create a refcnt'd event and a small holder for every group
- * than create a different event for every group
- *
- */
-struct fsnotify_event_holder {
-	struct fsnotify_event *event;
-	struct list_head event_list;
-};
-
-/*
- * Inotify needs to tack data onto an event.  This struct lets us later find the
- * correct private data of the correct group.
- */
-struct fsnotify_event_private_data {
-	struct fsnotify_group *group;
-	struct list_head event_list;
-};
-
-/*
- * all of the information about the original object we want to now send to
- * a group.  If you want to carry more info from the accessing task to the
- * listener this structure is where you need to be adding fields.
- */
-struct fsnotify_event {
-	/*
-	 * If we create an event we are also likely going to need a holder
-	 * to link to a group.  So embed one holder in the event.  Means only
-	 * one allocation for the common case where we only have one group
-	 */
-	struct fsnotify_event_holder holder;
-	spinlock_t lock;	/* protection for the associated event_holder and private_list */
-	/* to_tell may ONLY be dereferenced during handle_event(). */
-	struct inode *to_tell;	/* either the inode the event happened to or its parent */
-	/*
-	 * depending on the event type we should have either a path or inode
-	 * We hold a reference on path, but NOT on inode.  Since we have the ref on
-	 * the path, it may be dereferenced at any point during this object's
-	 * lifetime.  That reference is dropped when this object's refcnt hits
-	 * 0.  If this event contains an inode instead of a path, the inode may
-	 * ONLY be used during handle_event().
-	 */
-	union {
-		struct path path;
-		struct inode *inode;
-	};
 /* when calling fsnotify tell it if the data is a path or inode */
 #define FSNOTIFY_EVENT_NONE	0
 #define FSNOTIFY_EVENT_PATH	1
 #define FSNOTIFY_EVENT_INODE	2
-	int data_type;		/* which of the above union we have */
-	atomic_t refcnt;	/* how many groups still are using/need to send this event */
-	__u32 mask;		/* the type of access, bitwise OR for FS_* event types */
-
-	u32 sync_cookie;	/* used to corrolate events, namely inotify mv events */
-	const unsigned char *file_name;
-	size_t name_len;
-	struct pid *tgid;
-
-#ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
-	__u32 response;	/* userspace answer to question */
-#endif /* CONFIG_FANOTIFY_ACCESS_PERMISSIONS */
-
-	struct list_head private_data_list;	/* groups can store private data here */
-};
 
 /*
  * Inode specific fields in an fsnotify_mark
@@ -370,17 +322,12 @@ extern void fsnotify_put_group(struct fs
 extern void fsnotify_destroy_group(struct fsnotify_group *group);
 /* fasync handler function */
 extern int fsnotify_fasync(int fd, struct file *file, int on);
-/* take a reference to an event */
-extern void fsnotify_get_event(struct fsnotify_event *event);
-extern void fsnotify_put_event(struct fsnotify_event *event);
-/* find private data previously attached to an event and unlink it */
-extern struct fsnotify_event_private_data *fsnotify_remove_priv_from_event(struct fsnotify_group *group,
-									   struct fsnotify_event *event);
-
+/* Free event from memory */
+extern void fsnotify_destroy_event(struct fsnotify_group *group,
+				   struct fsnotify_event *event);
 /* attach the event to the group notification queue */
 extern struct fsnotify_event *fsnotify_add_notify_event(struct fsnotify_group *group,
 							struct fsnotify_event *event,
-							struct fsnotify_event_private_data *priv,
 							struct fsnotify_event *(*merge)(struct list_head *,
 											struct fsnotify_event *));
 /* true if the group notification queue is empty */
@@ -430,15 +377,8 @@ extern void fsnotify_put_mark(struct fsn
 extern void fsnotify_unmount_inodes(struct list_head *list);
 
 /* put here because inotify does some weird stuff when destroying watches */
-extern struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask,
-						    void *data, int data_is,
-						    const unsigned char *name,
-						    u32 cookie, gfp_t gfp);
-
-/* fanotify likes to change events after they are on lists... */
-extern struct fsnotify_event *fsnotify_clone_event(struct fsnotify_event *old_event);
-extern int fsnotify_replace_event(struct fsnotify_event_holder *old_holder,
-				  struct fsnotify_event *new_event);
+extern void fsnotify_init_event(struct fsnotify_event *event,
+				struct inode *to_tell, u32 mask);
 
 #else
 
diff -puN kernel/audit_tree.c~fsnotify-do-not-share-events-between-notification-groups kernel/audit_tree.c
--- a/kernel/audit_tree.c~fsnotify-do-not-share-events-between-notification-groups
+++ a/kernel/audit_tree.c
@@ -912,9 +912,11 @@ static void evict_chunk(struct audit_chu
 }
 
 static int audit_tree_handle_event(struct fsnotify_group *group,
+				   struct inode *to_tell,
 				   struct fsnotify_mark *inode_mark,
-				   struct fsnotify_mark *vfsmonut_mark,
-				   struct fsnotify_event *event)
+				   struct fsnotify_mark *vfsmount_mark,
+				   u32 mask, void *data, int data_type,
+				   const unsigned char *file_name)
 {
 	BUG();
 	return -EOPNOTSUPP;
@@ -945,7 +947,7 @@ static const struct fsnotify_ops audit_t
 	.handle_event = audit_tree_handle_event,
 	.should_send_event = audit_tree_send_event,
 	.free_group_priv = NULL,
-	.free_event_priv = NULL,
+	.free_event = NULL,
 	.freeing_mark = audit_tree_freeing_mark,
 };
 
diff -puN kernel/audit_watch.c~fsnotify-do-not-share-events-between-notification-groups kernel/audit_watch.c
--- a/kernel/audit_watch.c~fsnotify-do-not-share-events-between-notification-groups
+++ a/kernel/audit_watch.c
@@ -475,25 +475,25 @@ static bool audit_watch_should_send_even
 
 /* Update watch data in audit rules based on fsnotify events. */
 static int audit_watch_handle_event(struct fsnotify_group *group,
+				    struct inode *to_tell,
 				    struct fsnotify_mark *inode_mark,
 				    struct fsnotify_mark *vfsmount_mark,
-				    struct fsnotify_event *event)
+				    u32 mask, void *data, int data_type,
+				    const unsigned char *dname)
 {
 	struct inode *inode;
-	__u32 mask = event->mask;
-	const char *dname = event->file_name;
 	struct audit_parent *parent;
 
 	parent = container_of(inode_mark, struct audit_parent, mark);
 
 	BUG_ON(group != audit_watch_group);
 
-	switch (event->data_type) {
+	switch (data_type) {
 	case (FSNOTIFY_EVENT_PATH):
-		inode = event->path.dentry->d_inode;
+		inode = ((struct path *)data)->dentry->d_inode;
 		break;
 	case (FSNOTIFY_EVENT_INODE):
-		inode = event->inode;
+		inode = (struct inode *)data;
 		break;
 	default:
 		BUG();
@@ -516,7 +516,7 @@ static const struct fsnotify_ops audit_w
 	.handle_event = 	audit_watch_handle_event,
 	.free_group_priv = 	NULL,
 	.freeing_mark = 	NULL,
-	.free_event_priv = 	NULL,
+	.free_event = 		NULL,
 };
 
 static int __init audit_watch_init(void)
_

Patches currently in -mm which might be from jack@suse.cz are

inotify-provide-function-for-name-length-rounding.patch
fsnotify-do-not-share-events-between-notification-groups.patch
fsnotify-remove-should_send_event-callback.patch
fsnotify-remove-pointless-null-initializers.patch
blk-mq-use-__smp_call_function_single-directly.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
kernel-use-lockless-list-for-smp_call_function_single.patch
rbtree-test-move-rb_node-to-the-middle-of-the-test-struct.patch
rbtree-test-test-rbtree_postorder_for_each_entry_safe.patch
net-netfilter-ipset-ip_set_hash_netifacec-use-rbtree-postorder-iteration-instead-of-opencoding.patch
fs-ubifs-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
fs-ext4-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
fs-jffs2-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix.patch
arch-sh-kernel-dwarfc-use-rbtree-postorder-iteration-helper-instead-of-solution-using-repeated-rb_erase.patch
linux-next.patch
mm-add-strictlimit-knob-v2.patch

