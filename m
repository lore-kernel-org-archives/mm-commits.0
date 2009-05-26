From: akpm@linux-foundation.org
Subject: [wrecked] fsnotify-generic-notification-queue-and-waitq.patch removed from -mm tree
Date: Tue, 26 May 2009 12:34:23 -0700
Message-ID: <200905261934.n4QJYNSO005525@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56253 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756790AbZEZTes (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 15:34:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eparis@redhat.com, hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fsnotify: generic notification queue and waitq
has been removed from the -mm tree.  Its filename was
     fsnotify-generic-notification-queue-and-waitq.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fsnotify: generic notification queue and waitq
From: Eric Paris <eparis@redhat.com>

inotify needs to do asyc notification in which event information is stored
on a queue until the listener is ready to receive it.  This patch
implements a generic notification queue for inotify (and later fanotify)
to store events to be sent at a later time.

Signed-off-by: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fsnotify.h             |    9 +
 fs/notify/group.c                |    9 +
 fs/notify/notification.c         |  230 ++++++++++++++++++++++++++++-
 include/linux/fsnotify_backend.h |   37 ++++
 4 files changed, 278 insertions(+), 7 deletions(-)

diff -puN fs/notify/fsnotify.h~fsnotify-generic-notification-queue-and-waitq fs/notify/fsnotify.h
--- a/fs/notify/fsnotify.h~fsnotify-generic-notification-queue-and-waitq
+++ a/fs/notify/fsnotify.h
@@ -13,8 +13,12 @@ extern struct list_head fsnotify_groups;
 /* all bitwise OR of all event types (FS_*) for all fsnotify_groups */
 extern __u32 fsnotify_mask;
 
+/* destroy all events sitting in this groups notification queue */
+extern void fsnotify_flush_notify(struct fsnotify_group *group);
+
 /* final kfree of a group */
 extern void fsnotify_final_destroy_group(struct fsnotify_group *group);
+
 /* run the list of all marks associated with inode and flag them to be freed */
 extern void fsnotify_clear_marks_by_inode(struct inode *inode);
 /*
@@ -22,4 +26,9 @@ extern void fsnotify_clear_marks_by_inod
  * about events that happen to its children.
  */
 extern void __fsnotify_update_child_dentry_flags(struct inode *inode);
+
+/* allocate and destroy and event holder to attach events to notification/access queues */
+extern struct fsnotify_event_holder *fsnotify_alloc_event_holder(void);
+extern void fsnotify_destroy_event_holder(struct fsnotify_event_holder *holder);
+
 #endif	/* __FS_NOTIFY_FSNOTIFY_H_ */
diff -puN fs/notify/group.c~fsnotify-generic-notification-queue-and-waitq fs/notify/group.c
--- a/fs/notify/group.c~fsnotify-generic-notification-queue-and-waitq
+++ a/fs/notify/group.c
@@ -91,6 +91,9 @@ static void fsnotify_get_group(struct fs
  */
 void fsnotify_final_destroy_group(struct fsnotify_group *group)
 {
+	/* clear the notification queue of all events */
+	fsnotify_flush_notify(group);
+
 	if (group->ops->free_group_priv)
 		group->ops->free_group_priv(group);
 
@@ -214,6 +217,12 @@ struct fsnotify_group *fsnotify_obtain_g
 	group->group_num = group_num;
 	group->mask = mask;
 
+	mutex_init(&group->notification_mutex);
+	INIT_LIST_HEAD(&group->notification_list);
+	init_waitqueue_head(&group->notification_waitq);
+	group->q_len = 0;
+	group->max_events = UINT_MAX;
+
 	spin_lock_init(&group->mark_lock);
 	atomic_set(&group->num_marks, 0);
 	INIT_LIST_HEAD(&group->mark_entries);
diff -puN fs/notify/notification.c~fsnotify-generic-notification-queue-and-waitq fs/notify/notification.c
--- a/fs/notify/notification.c~fsnotify-generic-notification-queue-and-waitq
+++ a/fs/notify/notification.c
@@ -16,6 +16,21 @@
  *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+/*
+ * Basic idea behind the notification queue: An fsnotify group (like inotify)
+ * sends the userspace notification about events asyncronously some time after
+ * the event happened.  When inotify gets an event it will need to add that
+ * event to the group notify queue.  Since a single event might need to be on
+ * multiple group's notification queues we can't add the event directly to each
+ * queue and instead add a small "event_holder" to each queue.  This event_holder
+ * has a pointer back to the original event.  Since the majority of events are
+ * going to end up on one, and only one, notification queue we embed one
+ * event_holder into each event.  This means we have a single allocation instead
+ * of always needing two.  If the embedded event_holder is already in use by
+ * another group a new event_holder (from fsnotify_event_holder_cachep) will be
+ * allocated and used.
+ */
+
 #include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -33,6 +48,21 @@
 #include "fsnotify.h"
 
 static struct kmem_cache *fsnotify_event_cachep;
+static struct kmem_cache *fsnotify_event_holder_cachep;
+/*
+ * This is a magic event we send when the q is too full.  Since it doesn't
+ * hold real event information we just keep one system wide and use it any time
+ * it is needed.  It's refcnt is set 1 at kernel init time and will never
+ * get set to 0 so it will never get 'freed'
+ */
+static struct fsnotify_event q_overflow_event;
+
+/* return true if the notify queue is empty, false otherwise */
+bool fsnotify_notify_queue_is_empty(struct fsnotify_group *group)
+{
+	BUG_ON(!mutex_is_locked(&group->notification_mutex));
+	return list_empty(&group->notification_list) ? true : false;
+}
 
 void fsnotify_get_event(struct fsnotify_event *event)
 {
@@ -52,19 +82,176 @@ void fsnotify_put_event(struct fsnotify_
 	}
 }
 
+struct fsnotify_event_holder *fsnotify_alloc_event_holder(void)
+{
+	return kmem_cache_alloc(fsnotify_event_holder_cachep, GFP_KERNEL);
+}
+
+void fsnotify_destroy_event_holder(struct fsnotify_event_holder *holder)
+{
+	kmem_cache_free(fsnotify_event_holder_cachep, holder);
+}
+
 /*
- * Allocate a new event which will be sent to each group's handle_event function
- * if the group was interested in this particular event.
+ * check if 2 events contain the same information.
  */
-struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask,
-					     void *data, int data_type)
+static bool event_compare(struct fsnotify_event *old, struct fsnotify_event *new)
+{
+	if ((old->mask == new->mask) &&
+	    (old->to_tell == new->to_tell) &&
+	    (old->data_type == new->data_type)) {
+		switch (old->data_type) {
+		case (FSNOTIFY_EVENT_INODE):
+			if (old->inode == new->inode)
+				return true;
+			break;
+		case (FSNOTIFY_EVENT_PATH):
+			if ((old->path.mnt == new->path.mnt) &&
+			    (old->path.dentry == new->path.dentry))
+				return true;
+		case (FSNOTIFY_EVENT_NONE):
+			return true;
+		};
+	}
+	return false;
+}
+
+/*
+ * Add an event to the group notification queue.  The group can later pull this
+ * event off the queue to deal with.  If the event is successfully added to the
+ * group's notification queue, a reference is taken on event.
+ */
+int fsnotify_add_notify_event(struct fsnotify_group *group, struct fsnotify_event *event)
+{
+	struct fsnotify_event_holder *holder = NULL;
+	struct list_head *list = &group->notification_list;
+	struct fsnotify_event_holder *last_holder;
+	struct fsnotify_event *last_event;
+
+	/*
+	 * There is one fsnotify_event_holder embedded inside each fsnotify_event.
+	 * Check if we expect to be able to use that holder.  If not alloc a new
+	 * holder.
+	 * For the overflow event it's possible that something will use the in
+	 * event holder before we get the lock so we may need to jump back and
+	 * alloc a new holder, this can't happen for most events...
+	 */
+	if (!list_empty(&event->holder.event_list)) {
+alloc_holder:
+		holder = fsnotify_alloc_event_holder();
+		if (!holder)
+			return -ENOMEM;
+	}
+
+	mutex_lock(&group->notification_mutex);
+
+	if (group->q_len >= group->max_events)
+		event = &q_overflow_event;
+
+	spin_lock(&event->lock);
+
+	if (list_empty(&event->holder.event_list)) {
+		if (unlikely(holder))
+			fsnotify_destroy_event_holder(holder);
+		holder = &event->holder;
+	} else if (unlikely(!holder)) {
+		/* between the time we checked above and got the lock the in
+		 * event holder was used, go back and get a new one */
+		spin_unlock(&event->lock);
+		mutex_unlock(&group->notification_mutex);
+		goto alloc_holder;
+	}
+
+	if (!list_empty(list)) {
+		last_holder = list_entry(list->prev, struct fsnotify_event_holder, event_list);
+		last_event = last_holder->event;
+		if (event_compare(last_event, event)) {
+			spin_unlock(&event->lock);
+			mutex_unlock(&group->notification_mutex);
+			if (holder != &event->holder)
+				fsnotify_destroy_event_holder(holder);
+			return 0;
+		}
+	}
+
+	group->q_len++;
+	holder->event = event;
+
+	fsnotify_get_event(event);
+	list_add_tail(&holder->event_list, list);
+	spin_unlock(&event->lock);
+	mutex_unlock(&group->notification_mutex);
+
+	wake_up(&group->notification_waitq);
+	return 0;
+}
+
+/*
+ * Remove and return the first event from the notification list.  There is a
+ * reference held on this event since it was on the list.  It is the responsibility
+ * of the caller to drop this reference.
+ */
+struct fsnotify_event *fsnotify_remove_notify_event(struct fsnotify_group *group)
 {
 	struct fsnotify_event *event;
+	struct fsnotify_event_holder *holder;
 
-	event = kmem_cache_alloc(fsnotify_event_cachep, GFP_KERNEL);
-	if (!event)
-		return NULL;
+	BUG_ON(!mutex_is_locked(&group->notification_mutex));
 
+	holder = list_first_entry(&group->notification_list, struct fsnotify_event_holder, event_list);
+
+	event = holder->event;
+
+	spin_lock(&event->lock);
+	holder->event = NULL;
+	list_del_init(&holder->event_list);
+	spin_unlock(&event->lock);
+
+	/* event == holder means we are referenced through the in event holder */
+	if (holder != &event->holder)
+		fsnotify_destroy_event_holder(holder);
+
+	group->q_len--;
+
+	return event;
+}
+
+/*
+ * This will not remove the event, that must be done with fsnotify_remove_notify_event()
+ */
+struct fsnotify_event *fsnotify_peek_notify_event(struct fsnotify_group *group)
+{
+	struct fsnotify_event *event;
+	struct fsnotify_event_holder *holder;
+
+	BUG_ON(!mutex_is_locked(&group->notification_mutex));
+
+	holder = list_first_entry(&group->notification_list, struct fsnotify_event_holder, event_list);
+	event = holder->event;
+
+	return event;
+}
+
+/*
+ * Called when a group is being torn down to clean up any outstanding
+ * event notifications.
+ */
+void fsnotify_flush_notify(struct fsnotify_group *group)
+{
+	struct fsnotify_event *event;
+
+	mutex_lock(&group->notification_mutex);
+	while (!fsnotify_notify_queue_is_empty(group)) {
+		event = fsnotify_remove_notify_event(group);
+		fsnotify_put_event(event); /* matches fsnotify_add_notify_event */
+	}
+	mutex_unlock(&group->notification_mutex);
+}
+
+static void initialize_event(struct fsnotify_event *event)
+{
+	event->holder.event = NULL;
+	INIT_LIST_HEAD(&event->holder.event_list);
 	atomic_set(&event->refcnt, 1);
 
 	spin_lock_init(&event->lock);
@@ -72,7 +259,32 @@ struct fsnotify_event *fsnotify_create_e
 	event->path.dentry = NULL;
 	event->path.mnt = NULL;
 	event->inode = NULL;
+	event->data_type = FSNOTIFY_EVENT_NONE;
+
+	event->to_tell = NULL;
+}
+
+/*
+ * fsnotify_create_event - Allocate a new event which will be sent to each
+ * group's handle_event function if the group was interested in this
+ * particular event.
+ *
+ * @to_tell the inode which is supposed to receive the event (sometimes a
+ *	parent of the inode to which the event happened.
+ * @mask what actually happened.
+ * @data pointer to the object which was actually affected
+ * @data_type flag indication if the data is a file, path, inode, nothing...
+ */
+struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask,
+					     void *data, int data_type)
+{
+	struct fsnotify_event *event;
 
+	event = kmem_cache_alloc(fsnotify_event_cachep, GFP_KERNEL);
+	if (!event)
+		return NULL;
+
+	initialize_event(event);
 	event->to_tell = to_tell;
 
 	switch (data_type) {
@@ -114,6 +326,10 @@ struct fsnotify_event *fsnotify_create_e
 __init int fsnotify_notification_init(void)
 {
 	fsnotify_event_cachep = KMEM_CACHE(fsnotify_event, SLAB_PANIC);
+	fsnotify_event_holder_cachep = KMEM_CACHE(fsnotify_event_holder, SLAB_PANIC);
+
+	initialize_event(&q_overflow_event);
+	q_overflow_event.mask = FS_Q_OVERFLOW;
 
 	return 0;
 }
diff -puN include/linux/fsnotify_backend.h~fsnotify-generic-notification-queue-and-waitq include/linux/fsnotify_backend.h
--- a/include/linux/fsnotify_backend.h~fsnotify-generic-notification-queue-and-waitq
+++ a/include/linux/fsnotify_backend.h
@@ -119,6 +119,13 @@ struct fsnotify_group {
 
 	const struct fsnotify_ops *ops;	/* how this group handles things */
 
+	/* needed to send notification to userspace */
+	struct mutex notification_mutex;	/* protect the notification_list */
+	struct list_head notification_list;	/* list of event_holder this group needs to send to userspace */
+	wait_queue_head_t notification_waitq;	/* read() on the notification file blocks on this waitq */
+	unsigned int q_len;			/* events on the queue */
+	unsigned int max_events;		/* maximum events allowed on the list */
+
 	/* stores all fastapth entries assoc with this group so they can be cleaned on unregister */
 	spinlock_t mark_lock;		/* protect mark_entries list */
 	atomic_t num_marks;		/* 1 for each mark entry and 1 for not being
@@ -136,11 +143,32 @@ struct fsnotify_group {
 };
 
 /*
+ * A single event can be queued in multiple group->notification_lists.
+ *
+ * each group->notification_list will point to an event_holder which in turns points
+ * to the actual event that needs to be sent to userspace.
+ *
+ * Seemed cheaper to create a refcnt'd event and a small holder for every group
+ * than create a different event for every group
+ *
+ */
+struct fsnotify_event_holder {
+	struct fsnotify_event *event;
+	struct list_head event_list;
+};
+
+/*
  * all of the information about the original object we want to now send to
  * a group.  If you want to carry more info from the accessing task to the
  * listener this structure is where you need to be adding fields.
  */
 struct fsnotify_event {
+	/*
+	 * If we create an event we are also likely going to need a holder
+	 * to link to a group.  So embed one holder in the event.  Means only
+	 * one allocation for the common case where we only have one group
+	 */
+	struct fsnotify_event_holder holder;
 	spinlock_t lock;	/* protection for the associated event_holder and private_list */
 	/* to_tell may ONLY be dereferenced during handle_event(). */
 	struct inode *to_tell;	/* either the inode the event happened to or its parent */
@@ -264,6 +292,15 @@ extern void fsnotify_put_event(struct fs
 extern struct fsnotify_event_private_data *fsnotify_get_priv_from_event(struct fsnotify_group *group,
 									struct fsnotify_event *event);
 
+/* attach the event to the group notification queue */
+extern int fsnotify_add_notify_event(struct fsnotify_group *group, struct fsnotify_event *event);
+/* true if the group notification queue is empty */
+extern bool fsnotify_notify_queue_is_empty(struct fsnotify_group *group);
+/* return, but do not dequeue the first event on the notification queue */
+extern struct fsnotify_event *fsnotify_peek_notify_event(struct fsnotify_group *group);
+/* reutnr AND dequeue the first event on the notification queue */
+extern struct fsnotify_event *fsnotify_remove_notify_event(struct fsnotify_group *group);
+
 /* functions used to manipulate the marks attached to inodes */
 
 /* run all marks associated with an inode and update inode->i_fsnotify_mask */
_

Patches currently in -mm which might be from eparis@redhat.com are

linux-next.patch
fsnotify-generic-notification-queue-and-waitq.patch
fsnotify-include-pathnames-with-entries-when-possible.patch
fsnotify-add-correlations-between-events.patch
fsnotify-allow-groups-to-add-private-data-to-events.patch
fsnotify-fsnotify-marks-on-inodes-pin-them-in-core.patch
fsnotify-handle-filesystem-unmounts-with-fsnotify-marks.patch
inotify-reimplement-inotify-using-fsnotify.patch
inotify-reimplement-inotify-using-fsnotify-report-rounded-up-event-size-to-user-space.patch

