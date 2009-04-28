From: akpm@linux-foundation.org
Subject: + fsnotify-allow-groups-to-add-private-data-to-events.patch added to -mm tree
Date: Tue, 28 Apr 2009 13:28:17 -0700
Message-ID: <200904282028.n3SKSHWD021186@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45230 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755549AbZD1UcM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Apr 2009 16:32:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eparis@redhat.com, hch@lst.de, viro@zeniv.linux.org.uk


The patch titled
     fsnotify: allow groups to add private data to events
has been added to the -mm tree.  Its filename is
     fsnotify-allow-groups-to-add-private-data-to-events.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fsnotify: allow groups to add private data to events
From: Eric Paris <eparis@redhat.com>

inotify needs per group information attached to events.  This patch allows
groups to attach private information and implements a callback so that
information can be freed when an event is being destroyed.

Signed-off-by: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/dnotify/dnotify.c      |    1 
 fs/notify/notification.c         |   37 ++++++++++++++++++++++++++---
 include/linux/fsnotify_backend.h |   17 ++++++++++++-
 3 files changed, 51 insertions(+), 4 deletions(-)

diff -puN fs/notify/dnotify/dnotify.c~fsnotify-allow-groups-to-add-private-data-to-events fs/notify/dnotify/dnotify.c
--- a/fs/notify/dnotify/dnotify.c~fsnotify-allow-groups-to-add-private-data-to-events
+++ a/fs/notify/dnotify/dnotify.c
@@ -183,6 +183,7 @@ static struct fsnotify_ops dnotify_fsnot
 	.should_send_event = dnotify_should_send_event,
 	.free_group_priv = NULL,
 	.freeing_mark = dnotify_freeing_mark,
+	.free_event_priv = NULL,
 };
 
 /*
diff -puN fs/notify/notification.c~fsnotify-allow-groups-to-add-private-data-to-events fs/notify/notification.c
--- a/fs/notify/notification.c~fsnotify-allow-groups-to-add-private-data-to-events
+++ a/fs/notify/notification.c
@@ -90,6 +90,8 @@ void fsnotify_put_event(struct fsnotify_
 		if (event->data_type == FSNOTIFY_EVENT_PATH)
 			path_put(&event->path);
 
+		BUG_ON(!list_empty(&event->private_data_list));
+
 		kfree(event->file_name);
 		kmem_cache_free(fsnotify_event_cachep, event);
 	}
@@ -106,7 +108,26 @@ void fsnotify_destroy_event_holder(struc
 }
 
 /*
- * check if 2 events contain the same information.
+ * Find the private data that the group previously attached to this event when
+ * the group added the event to the notification queue (fsnotify_add_notify_event)
+ */
+struct fsnotify_event_private_data *fsnotify_get_priv_from_event(struct fsnotify_group *group, struct fsnotify_event *event)
+{
+	struct fsnotify_event_private_data *lpriv;
+	struct fsnotify_event_private_data *priv = NULL;
+
+	list_for_each_entry(lpriv, &event->private_data_list, event_list) {
+		if (lpriv->group == group) {
+			priv = lpriv;
+			break;
+		}
+	}
+	return priv;
+}
+
+/*
+ * Check if 2 events contain the same information.  We do not compare private data
+ * but at this moment that isn't a problem for any know fsnotify listeners.
  */
 static bool event_compare(struct fsnotify_event *old, struct fsnotify_event *new)
 {
@@ -134,13 +155,17 @@ static bool event_compare(struct fsnotif
  * event off the queue to deal with.  If the event is successfully added to the
  * group's notification queue, a reference is taken on event.
  */
-int fsnotify_add_notify_event(struct fsnotify_group *group, struct fsnotify_event *event)
+int fsnotify_add_notify_event(struct fsnotify_group *group, struct fsnotify_event *event,
+			      struct fsnotify_event_private_data *priv)
 {
 	struct fsnotify_event_holder *holder = NULL;
 	struct list_head *list = &group->notification_list;
 	struct fsnotify_event_holder *last_holder;
 	struct fsnotify_event *last_event;
 
+	/* easy to tell if priv was attached to the event */
+	INIT_LIST_HEAD(&priv->event_list);
+
 	/*
 	 * There is one fsnotify_event_holder embedded inside each fsnotify_event.
 	 * Check if we expect to be able to use that holder.  If not alloc a new
@@ -183,7 +208,7 @@ alloc_holder:
 			mutex_unlock(&group->notification_mutex);
 			if (holder != &event->holder)
 				fsnotify_destroy_event_holder(holder);
-			return 0;
+			return -EEXIST;
 		}
 	}
 
@@ -192,6 +217,8 @@ alloc_holder:
 
 	fsnotify_get_event(event);
 	list_add_tail(&holder->event_list, list);
+	if (priv)
+		list_add_tail(&priv->event_list, &event->private_data_list);
 	spin_unlock(&event->lock);
 	mutex_unlock(&group->notification_mutex);
 
@@ -256,6 +283,8 @@ void fsnotify_flush_notify(struct fsnoti
 	mutex_lock(&group->notification_mutex);
 	while (!fsnotify_notify_queue_is_empty(group)) {
 		event = fsnotify_remove_notify_event(group);
+		if (group->ops->free_event_priv)
+			group->ops->free_event_priv(group, event);
 		fsnotify_put_event(event); /* matches fsnotify_add_notify_event */
 	}
 	mutex_unlock(&group->notification_mutex);
@@ -274,6 +303,8 @@ static void initialize_event(struct fsno
 	event->inode = NULL;
 	event->data_type = FSNOTIFY_EVENT_NONE;
 
+	INIT_LIST_HEAD(&event->private_data_list);
+
 	event->to_tell = NULL;
 
 	event->file_name = NULL;
diff -puN include/linux/fsnotify_backend.h~fsnotify-allow-groups-to-add-private-data-to-events include/linux/fsnotify_backend.h
--- a/include/linux/fsnotify_backend.h~fsnotify-allow-groups-to-add-private-data-to-events
+++ a/include/linux/fsnotify_backend.h
@@ -81,6 +81,7 @@ struct fsnotify_ops {
 	int (*handle_event)(struct fsnotify_group *group, struct fsnotify_event *event);
 	void (*free_group_priv)(struct fsnotify_group *group);
 	void (*freeing_mark)(struct fsnotify_mark_entry *entry, struct fsnotify_group *group);
+	void (*free_event_priv)(struct fsnotify_group *group, struct fsnotify_event *event);
 };
 
 /*
@@ -158,6 +159,15 @@ struct fsnotify_event_holder {
 };
 
 /*
+ * Inotify needs to tack data onto an event.  This struct lets us later find the
+ * correct private data of the correct group.
+ */
+struct fsnotify_event_private_data {
+	struct fsnotify_group *group;
+	struct list_head event_list;
+};
+
+/*
  * all of the information about the original object we want to now send to
  * a group.  If you want to carry more info from the accessing task to the
  * listener this structure is where you need to be adding fields.
@@ -196,6 +206,8 @@ struct fsnotify_event {
 	u32 sync_cookie;	/* used to corrolate events, namely inotify mv events */
 	char *file_name;
 	size_t name_len;
+
+	struct list_head private_data_list;	/* groups can store private data here */
 };
 
 /*
@@ -299,13 +311,16 @@ extern struct fsnotify_event_private_dat
 									struct fsnotify_event *event);
 
 /* attach the event to the group notification queue */
-extern int fsnotify_add_notify_event(struct fsnotify_group *group, struct fsnotify_event *event);
+extern int fsnotify_add_notify_event(struct fsnotify_group *group, struct fsnotify_event *event,
+				     struct fsnotify_event_private_data *priv);
 /* true if the group notification queue is empty */
 extern bool fsnotify_notify_queue_is_empty(struct fsnotify_group *group);
 /* return, but do not dequeue the first event on the notification queue */
 extern struct fsnotify_event *fsnotify_peek_notify_event(struct fsnotify_group *group);
 /* reutnr AND dequeue the first event on the notification queue */
 extern struct fsnotify_event *fsnotify_remove_notify_event(struct fsnotify_group *group);
+extern struct fsnotify_event_private_data *fsnotify_get_priv_from_event(struct fsnotify_group *group,
+									struct fsnotify_event *event);
 
 /* functions used to manipulate the marks attached to inodes */
 
_

Patches currently in -mm which might be from eparis@redhat.com are

linux-next.patch
mutex-add-atomic_dec_and_mutex_lock.patch
fsnotify-unified-filesystem-notification-backend.patch
fsnotify-add-marks-to-inodes-so-groups-can-interpret-how-to-handle-those-inodes.patch
fsnotify-parent-event-notification.patch
dnotify-reimplement-dnotify-using-fsnotify.patch
fsnotify-generic-notification-queue-and-waitq.patch
fsnotify-include-pathnames-with-entries-when-possible.patch
fsnotify-add-correlations-between-events.patch
fsnotify-allow-groups-to-add-private-data-to-events.patch
fsnotify-fsnotify-marks-on-inodes-pin-them-in-core.patch
fsnotify-handle-filesystem-unmounts-with-fsnotify-marks.patch
inotify-reimplement-inotify-using-fsnotify.patch

