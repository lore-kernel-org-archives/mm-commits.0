From: akpm@linux-foundation.org
Subject: [merged]
 fsnotify-add-a-way-to-stop-queueing-events-on-group-shutdown.patch removed
 from -mm tree
Date: Tue, 20 Sep 2016 12:30:47 -0700
Message-ID: <57e18e67.Wesg2aq7OwXaJtWR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48698 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753359AbcITTas (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 20 Sep 2016 15:30:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mszeredi@redhat.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fsnotify: add a way to stop queueing events on group shutdown
has been removed from the -mm tree.  Its filename was
     fsnotify-add-a-way-to-stop-queueing-events-on-group-shutdown.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: fsnotify: add a way to stop queueing events on group shutdown

Implement a function that can be called when a group is being shutdown to
stop queueing new events to the group.  Fanotify will use this.

Fixes: 5838d4442bd5971687b72221736222637e03140d
Link: http://lkml.kernel.org/r/1473797711-14111-2-git-send-email-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Miklos Szeredi <mszeredi@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/group.c                |   19 +++++++++++++++++++
 fs/notify/notification.c         |    8 +++++++-
 include/linux/fsnotify_backend.h |    3 +++
 3 files changed, 29 insertions(+), 1 deletion(-)

diff -puN fs/notify/group.c~fsnotify-add-a-way-to-stop-queueing-events-on-group-shutdown fs/notify/group.c
--- a/fs/notify/group.c~fsnotify-add-a-way-to-stop-queueing-events-on-group-shutdown
+++ a/fs/notify/group.c
@@ -40,6 +40,17 @@ static void fsnotify_final_destroy_group
 }
 
 /*
+ * Stop queueing new events for this group. Once this function returns
+ * fsnotify_add_event() will not add any new events to the group's queue.
+ */
+void fsnotify_group_stop_queueing(struct fsnotify_group *group)
+{
+	mutex_lock(&group->notification_mutex);
+	group->shutdown = true;
+	mutex_unlock(&group->notification_mutex);
+}
+
+/*
  * Trying to get rid of a group. Remove all marks, flush all events and release
  * the group reference.
  * Note that another thread calling fsnotify_clear_marks_by_group() may still
@@ -47,6 +58,14 @@ static void fsnotify_final_destroy_group
  */
 void fsnotify_destroy_group(struct fsnotify_group *group)
 {
+	/*
+	 * Stop queueing new events. The code below is careful enough to not
+	 * require this but fanotify needs to stop queuing events even before
+	 * fsnotify_destroy_group() is called and this makes the other callers
+	 * of fsnotify_destroy_group() to see the same behavior.
+	 */
+	fsnotify_group_stop_queueing(group);
+
 	/* clear all inode marks for this group, attach them to destroy_list */
 	fsnotify_detach_group_marks(group);
 
diff -puN fs/notify/notification.c~fsnotify-add-a-way-to-stop-queueing-events-on-group-shutdown fs/notify/notification.c
--- a/fs/notify/notification.c~fsnotify-add-a-way-to-stop-queueing-events-on-group-shutdown
+++ a/fs/notify/notification.c
@@ -82,7 +82,8 @@ void fsnotify_destroy_event(struct fsnot
  * Add an event to the group notification queue.  The group can later pull this
  * event off the queue to deal with.  The function returns 0 if the event was
  * added to the queue, 1 if the event was merged with some other queued event,
- * 2 if the queue of events has overflown.
+ * 2 if the event was not queued - either the queue of events has overflown
+ * or the group is shutting down.
  */
 int fsnotify_add_event(struct fsnotify_group *group,
 		       struct fsnotify_event *event,
@@ -96,6 +97,11 @@ int fsnotify_add_event(struct fsnotify_g
 
 	mutex_lock(&group->notification_mutex);
 
+	if (group->shutdown) {
+		mutex_unlock(&group->notification_mutex);
+		return 2;
+	}
+
 	if (group->q_len >= group->max_events) {
 		ret = 2;
 		/* Queue overflow event only if it isn't already queued */
diff -puN include/linux/fsnotify_backend.h~fsnotify-add-a-way-to-stop-queueing-events-on-group-shutdown include/linux/fsnotify_backend.h
--- a/include/linux/fsnotify_backend.h~fsnotify-add-a-way-to-stop-queueing-events-on-group-shutdown
+++ a/include/linux/fsnotify_backend.h
@@ -148,6 +148,7 @@ struct fsnotify_group {
 	#define FS_PRIO_1	1 /* fanotify content based access control */
 	#define FS_PRIO_2	2 /* fanotify pre-content access */
 	unsigned int priority;
+	bool shutdown;		/* group is being shut down, don't queue more events */
 
 	/* stores all fastpath marks assoc with this group so they can be cleaned on unregister */
 	struct mutex mark_mutex;	/* protect marks_list */
@@ -292,6 +293,8 @@ extern struct fsnotify_group *fsnotify_a
 extern void fsnotify_get_group(struct fsnotify_group *group);
 /* drop reference on a group from fsnotify_alloc_group */
 extern void fsnotify_put_group(struct fsnotify_group *group);
+/* group destruction begins, stop queuing new events */
+extern void fsnotify_group_stop_queueing(struct fsnotify_group *group);
 /* destroy group */
 extern void fsnotify_destroy_group(struct fsnotify_group *group);
 /* fasync handler function */
_

Patches currently in -mm which might be from jack@suse.cz are

fsnotify-drop-notification_mutex-before-destroying-event.patch
fsnotify-convert-notification_mutex-to-a-spinlock.patch
fsnotify-convert-notification_mutex-to-a-spinlock-fix.patch
fanotify-use-notification_lock-instead-of-access_lock.patch
fanotify-fix-possible-false-warning-when-freeing-events.patch

