From: akpm@linux-foundation.org
Subject: [merged] fsnotify-convert-notification_mutex-to-a-spinlock.patch
 removed from -mm tree
Date: Mon, 10 Oct 2016 15:42:16 -0700
Message-ID: <57fc1948.K8NnxkoESspg5DP6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37358 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752232AbcJJWuv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:50:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, LinoSanfilippo@gmx.de, eparis@redhat.com, linux@roeck-us.net, mszeredi@redhat.com, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fsnotify: convert notification_mutex to a spinlock
has been removed from the -mm tree.  Its filename was
     fsnotify-convert-notification_mutex-to-a-spinlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: fsnotify: convert notification_mutex to a spinlock

notification_mutex is used to protect the list of pending events.  As such
there's no reason to use a sleeping lock for it.  Convert it to a
spinlock.

[jack@suse.cz: fixed version]
  Link: http://lkml.kernel.org/r/1474031567-1831-1-git-send-email-jack@suse.cz
Link: http://lkml.kernel.org/r/1473797711-14111-5-git-send-email-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fanotify/fanotify_user.c |   27 ++++++++++++++-------------
 fs/notify/group.c                  |    6 +++---
 fs/notify/inotify/inotify_user.c   |   16 ++++++++--------
 fs/notify/notification.c           |   27 +++++++++++++++------------
 include/linux/fsnotify_backend.h   |    2 +-
 5 files changed, 41 insertions(+), 37 deletions(-)

diff -puN fs/notify/fanotify/fanotify_user.c~fsnotify-convert-notification_mutex-to-a-spinlock fs/notify/fanotify/fanotify_user.c
--- a/fs/notify/fanotify/fanotify_user.c~fsnotify-convert-notification_mutex-to-a-spinlock
+++ a/fs/notify/fanotify/fanotify_user.c
@@ -49,12 +49,13 @@ struct kmem_cache *fanotify_perm_event_c
  * enough to fit in "count". Return an error pointer if the count
  * is not large enough.
  *
- * Called with the group->notification_mutex held.
+ * Called with the group->notification_lock held.
  */
 static struct fsnotify_event *get_one_event(struct fsnotify_group *group,
 					    size_t count)
 {
-	BUG_ON(!mutex_is_locked(&group->notification_mutex));
+	BUG_ON(IS_ENABLED(CONFIG_SMP) &&
+	       !spin_is_locked(&group->notification_lock));
 
 	pr_debug("%s: group=%p count=%zd\n", __func__, group, count);
 
@@ -64,7 +65,7 @@ static struct fsnotify_event *get_one_ev
 	if (FAN_EVENT_METADATA_LEN > count)
 		return ERR_PTR(-EINVAL);
 
-	/* held the notification_mutex the whole time, so this is the
+	/* held the notification_lock the whole time, so this is the
 	 * same event we peeked above */
 	return fsnotify_remove_first_event(group);
 }
@@ -244,10 +245,10 @@ static unsigned int fanotify_poll(struct
 	int ret = 0;
 
 	poll_wait(file, &group->notification_waitq, wait);
-	mutex_lock(&group->notification_mutex);
+	spin_lock(&group->notification_lock);
 	if (!fsnotify_notify_queue_is_empty(group))
 		ret = POLLIN | POLLRDNORM;
-	mutex_unlock(&group->notification_mutex);
+	spin_unlock(&group->notification_lock);
 
 	return ret;
 }
@@ -268,9 +269,9 @@ static ssize_t fanotify_read(struct file
 
 	add_wait_queue(&group->notification_waitq, &wait);
 	while (1) {
-		mutex_lock(&group->notification_mutex);
+		spin_lock(&group->notification_lock);
 		kevent = get_one_event(group, count);
-		mutex_unlock(&group->notification_mutex);
+		spin_unlock(&group->notification_lock);
 
 		if (IS_ERR(kevent)) {
 			ret = PTR_ERR(kevent);
@@ -387,17 +388,17 @@ static int fanotify_release(struct inode
 	 * dequeue them and set the response. They will be freed once the
 	 * response is consumed and fanotify_get_response() returns.
 	 */
-	mutex_lock(&group->notification_mutex);
+	spin_lock(&group->notification_lock);
 	while (!fsnotify_notify_queue_is_empty(group)) {
 		fsn_event = fsnotify_remove_first_event(group);
 		if (!(fsn_event->mask & FAN_ALL_PERM_EVENTS)) {
-			mutex_unlock(&group->notification_mutex);
+			spin_unlock(&group->notification_lock);
 			fsnotify_destroy_event(group, fsn_event);
-			mutex_lock(&group->notification_mutex);
+			spin_lock(&group->notification_lock);
 		} else
 			FANOTIFY_PE(fsn_event)->response = FAN_ALLOW;
 	}
-	mutex_unlock(&group->notification_mutex);
+	spin_unlock(&group->notification_lock);
 
 	/* Response for all permission events it set, wakeup waiters */
 	wake_up(&group->fanotify_data.access_waitq);
@@ -423,10 +424,10 @@ static long fanotify_ioctl(struct file *
 
 	switch (cmd) {
 	case FIONREAD:
-		mutex_lock(&group->notification_mutex);
+		spin_lock(&group->notification_lock);
 		list_for_each_entry(fsn_event, &group->notification_list, list)
 			send_len += FAN_EVENT_METADATA_LEN;
-		mutex_unlock(&group->notification_mutex);
+		spin_unlock(&group->notification_lock);
 		ret = put_user(send_len, (int __user *) p);
 		break;
 	}
diff -puN fs/notify/group.c~fsnotify-convert-notification_mutex-to-a-spinlock fs/notify/group.c
--- a/fs/notify/group.c~fsnotify-convert-notification_mutex-to-a-spinlock
+++ a/fs/notify/group.c
@@ -45,9 +45,9 @@ static void fsnotify_final_destroy_group
  */
 void fsnotify_group_stop_queueing(struct fsnotify_group *group)
 {
-	mutex_lock(&group->notification_mutex);
+	spin_lock(&group->notification_lock);
 	group->shutdown = true;
-	mutex_unlock(&group->notification_mutex);
+	spin_unlock(&group->notification_lock);
 }
 
 /*
@@ -125,7 +125,7 @@ struct fsnotify_group *fsnotify_alloc_gr
 	atomic_set(&group->refcnt, 1);
 	atomic_set(&group->num_marks, 0);
 
-	mutex_init(&group->notification_mutex);
+	spin_lock_init(&group->notification_lock);
 	INIT_LIST_HEAD(&group->notification_list);
 	init_waitqueue_head(&group->notification_waitq);
 	group->max_events = UINT_MAX;
diff -puN fs/notify/inotify/inotify_user.c~fsnotify-convert-notification_mutex-to-a-spinlock fs/notify/inotify/inotify_user.c
--- a/fs/notify/inotify/inotify_user.c~fsnotify-convert-notification_mutex-to-a-spinlock
+++ a/fs/notify/inotify/inotify_user.c
@@ -115,10 +115,10 @@ static unsigned int inotify_poll(struct
 	int ret = 0;
 
 	poll_wait(file, &group->notification_waitq, wait);
-	mutex_lock(&group->notification_mutex);
+	spin_lock(&group->notification_lock);
 	if (!fsnotify_notify_queue_is_empty(group))
 		ret = POLLIN | POLLRDNORM;
-	mutex_unlock(&group->notification_mutex);
+	spin_unlock(&group->notification_lock);
 
 	return ret;
 }
@@ -138,7 +138,7 @@ static int round_event_name_len(struct f
  * enough to fit in "count". Return an error pointer if
  * not large enough.
  *
- * Called with the group->notification_mutex held.
+ * Called with the group->notification_lock held.
  */
 static struct fsnotify_event *get_one_event(struct fsnotify_group *group,
 					    size_t count)
@@ -157,7 +157,7 @@ static struct fsnotify_event *get_one_ev
 	if (event_size > count)
 		return ERR_PTR(-EINVAL);
 
-	/* held the notification_mutex the whole time, so this is the
+	/* held the notification_lock the whole time, so this is the
 	 * same event we peeked above */
 	fsnotify_remove_first_event(group);
 
@@ -234,9 +234,9 @@ static ssize_t inotify_read(struct file
 
 	add_wait_queue(&group->notification_waitq, &wait);
 	while (1) {
-		mutex_lock(&group->notification_mutex);
+		spin_lock(&group->notification_lock);
 		kevent = get_one_event(group, count);
-		mutex_unlock(&group->notification_mutex);
+		spin_unlock(&group->notification_lock);
 
 		pr_debug("%s: group=%p kevent=%p\n", __func__, group, kevent);
 
@@ -300,13 +300,13 @@ static long inotify_ioctl(struct file *f
 
 	switch (cmd) {
 	case FIONREAD:
-		mutex_lock(&group->notification_mutex);
+		spin_lock(&group->notification_lock);
 		list_for_each_entry(fsn_event, &group->notification_list,
 				    list) {
 			send_len += sizeof(struct inotify_event);
 			send_len += round_event_name_len(fsn_event);
 		}
-		mutex_unlock(&group->notification_mutex);
+		spin_unlock(&group->notification_lock);
 		ret = put_user(send_len, (int __user *) p);
 		break;
 	}
diff -puN fs/notify/notification.c~fsnotify-convert-notification_mutex-to-a-spinlock fs/notify/notification.c
--- a/fs/notify/notification.c~fsnotify-convert-notification_mutex-to-a-spinlock
+++ a/fs/notify/notification.c
@@ -63,7 +63,8 @@ EXPORT_SYMBOL_GPL(fsnotify_get_cookie);
 /* return true if the notify queue is empty, false otherwise */
 bool fsnotify_notify_queue_is_empty(struct fsnotify_group *group)
 {
-	BUG_ON(!mutex_is_locked(&group->notification_mutex));
+	BUG_ON(IS_ENABLED(CONFIG_SMP) &&
+	       !spin_is_locked(&group->notification_lock));
 	return list_empty(&group->notification_list) ? true : false;
 }
 
@@ -95,10 +96,10 @@ int fsnotify_add_event(struct fsnotify_g
 
 	pr_debug("%s: group=%p event=%p\n", __func__, group, event);
 
-	mutex_lock(&group->notification_mutex);
+	spin_lock(&group->notification_lock);
 
 	if (group->shutdown) {
-		mutex_unlock(&group->notification_mutex);
+		spin_unlock(&group->notification_lock);
 		return 2;
 	}
 
@@ -106,7 +107,7 @@ int fsnotify_add_event(struct fsnotify_g
 		ret = 2;
 		/* Queue overflow event only if it isn't already queued */
 		if (!list_empty(&group->overflow_event->list)) {
-			mutex_unlock(&group->notification_mutex);
+			spin_unlock(&group->notification_lock);
 			return ret;
 		}
 		event = group->overflow_event;
@@ -116,7 +117,7 @@ int fsnotify_add_event(struct fsnotify_g
 	if (!list_empty(list) && merge) {
 		ret = merge(list, event);
 		if (ret) {
-			mutex_unlock(&group->notification_mutex);
+			spin_unlock(&group->notification_lock);
 			return ret;
 		}
 	}
@@ -124,7 +125,7 @@ int fsnotify_add_event(struct fsnotify_g
 queue:
 	group->q_len++;
 	list_add_tail(&event->list, list);
-	mutex_unlock(&group->notification_mutex);
+	spin_unlock(&group->notification_lock);
 
 	wake_up(&group->notification_waitq);
 	kill_fasync(&group->fsn_fa, SIGIO, POLL_IN);
@@ -139,7 +140,8 @@ struct fsnotify_event *fsnotify_remove_f
 {
 	struct fsnotify_event *event;
 
-	BUG_ON(!mutex_is_locked(&group->notification_mutex));
+	BUG_ON(IS_ENABLED(CONFIG_SMP) &&
+	       !spin_is_locked(&group->notification_lock));
 
 	pr_debug("%s: group=%p\n", __func__, group);
 
@@ -161,7 +163,8 @@ struct fsnotify_event *fsnotify_remove_f
  */
 struct fsnotify_event *fsnotify_peek_first_event(struct fsnotify_group *group)
 {
-	BUG_ON(!mutex_is_locked(&group->notification_mutex));
+	BUG_ON(IS_ENABLED(CONFIG_SMP) &&
+	       !spin_is_locked(&group->notification_lock));
 
 	return list_first_entry(&group->notification_list,
 				struct fsnotify_event, list);
@@ -175,14 +178,14 @@ void fsnotify_flush_notify(struct fsnoti
 {
 	struct fsnotify_event *event;
 
-	mutex_lock(&group->notification_mutex);
+	spin_lock(&group->notification_lock);
 	while (!fsnotify_notify_queue_is_empty(group)) {
 		event = fsnotify_remove_first_event(group);
-		mutex_unlock(&group->notification_mutex);
+		spin_unlock(&group->notification_lock);
 		fsnotify_destroy_event(group, event);
-		mutex_lock(&group->notification_mutex);
+		spin_lock(&group->notification_lock);
 	}
-	mutex_unlock(&group->notification_mutex);
+	spin_unlock(&group->notification_lock);
 }
 
 /*
diff -puN include/linux/fsnotify_backend.h~fsnotify-convert-notification_mutex-to-a-spinlock include/linux/fsnotify_backend.h
--- a/include/linux/fsnotify_backend.h~fsnotify-convert-notification_mutex-to-a-spinlock
+++ a/include/linux/fsnotify_backend.h
@@ -135,7 +135,7 @@ struct fsnotify_group {
 	const struct fsnotify_ops *ops;	/* how this group handles things */
 
 	/* needed to send notification to userspace */
-	struct mutex notification_mutex;	/* protect the notification_list */
+	spinlock_t notification_lock;		/* protect the notification_list */
 	struct list_head notification_list;	/* list of event_holder this group needs to send to userspace */
 	wait_queue_head_t notification_waitq;	/* read() on the notification file blocks on this waitq */
 	unsigned int q_len;			/* events on the queue */
_

Patches currently in -mm which might be from jack@suse.cz are


